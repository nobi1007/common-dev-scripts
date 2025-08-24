#!/bin/bash

# =============================================================================
# Media Optimization Validator Script
# Validates and previews what the optimization script will do
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script paths (can be passed as arguments)
WEBP_SCRIPT_PATH="${1:-./convertImageToWebp.sh}"
WEBM_SCRIPT_PATH="${2:-./convertVideoToWebm.sh}"
PROJECT_ROOT="${3:-$(pwd)}"

# Configuration
SOURCE_DIRS=("src" "public")
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif" "bmp" "tiff")
VIDEO_EXTENSIONS=("mp4" "mov" "avi" "mkv" "flv" "wmv" "mpeg" "mpg" "m4v" "3gp" "ogg")
CODE_EXTENSIONS=("astro" "tsx" "jsx" "ts" "js" "vue" "svelte" "json")

# Function to print colored output
print_status() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BOLD}${BLUE}$1${NC}"
}

print_detail() {
    echo -e "${MAGENTA}   → $1${NC}"
}

# Function to humanize file size
humanize_size() {
    local size=$1
    if [ $size -gt 1073741824 ]; then
        echo "$(echo "scale=1; $size/1073741824" | bc)GB"
    elif [ $size -gt 1048576 ]; then
        echo "$(echo "scale=1; $size/1048576" | bc)MB"
    elif [ $size -gt 1024 ]; then
        echo "$(echo "scale=1; $size/1024" | bc)KB"
    else
        echo "${size}B"
    fi
}

# Function to validate prerequisites
validate_prerequisites() {
    print_header "🔍 VALIDATING PREREQUISITES"
    
    local errors=0
    
    # Check if project root exists
    if [ ! -d "$PROJECT_ROOT" ]; then
        print_error "Project root does not exist: $PROJECT_ROOT"
        errors=$((errors + 1))
    else
        print_success "Project root found: $PROJECT_ROOT"
    fi
    
    # Check conversion scripts
    if [ ! -f "$WEBP_SCRIPT_PATH" ]; then
        print_error "WebP conversion script not found: $WEBP_SCRIPT_PATH"
        errors=$((errors + 1))
    else
        print_success "WebP script found: $WEBP_SCRIPT_PATH"
        if [ ! -x "$WEBP_SCRIPT_PATH" ]; then
            print_warning "WebP script is not executable (will be made executable)"
        fi
    fi
    
    if [ ! -f "$WEBM_SCRIPT_PATH" ]; then
        print_error "WebM conversion script not found: $WEBM_SCRIPT_PATH"
        errors=$((errors + 1))
    else
        print_success "WebM script found: $WEBM_SCRIPT_PATH"
        if [ ! -x "$WEBM_SCRIPT_PATH" ]; then
            print_warning "WebM script is not executable (will be made executable)"
        fi
    fi
    
    # Check required tools
    local required_tools=("find" "grep" "sed")
    for tool in "${required_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            print_success "Tool available: $tool"
        else
            print_error "Required tool not found: $tool"
            errors=$((errors + 1))
        fi
    done
    
    # Check build tools
    if command -v pnpm >/dev/null 2>&1; then
        print_success "Build tool found: pnpm"
    elif command -v npm >/dev/null 2>&1; then
        print_success "Build tool found: npm"
    else
        print_warning "No build tool found (pnpm/npm) - build testing will be skipped"
    fi
    
    echo ""
    return $errors
}

# Function to analyze media files
analyze_media_files() {
    print_header "📊 ANALYZING MEDIA FILES"
    
    local total_images=0
    local total_videos=0
    local total_image_size=0
    local total_video_size=0
    
    echo "Images found:"
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${IMAGE_EXTENSIONS[@]}"; do
                local files=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null)
                if [ -n "$files" ]; then
                    local count=$(echo "$files" | wc -l)
                    total_images=$((total_images + count))
                    
                    echo "$files" | while read -r file; do
                        if [ -f "$file" ]; then
                            local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
                            local human_size=$(humanize_size $size)
                            print_detail "${file#$PROJECT_ROOT/} ($human_size)"
                            total_image_size=$((total_image_size + size))
                        fi
                    done
                fi
            done
        fi
    done
    
    echo ""
    echo "Videos found:"
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${VIDEO_EXTENSIONS[@]}"; do
                local files=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null)
                if [ -n "$files" ]; then
                    local count=$(echo "$files" | wc -l)
                    total_videos=$((total_videos + count))
                    
                    echo "$files" | while read -r file; do
                        if [ -f "$file" ]; then
                            local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
                            local human_size=$(humanize_size $size)
                            print_detail "${file#$PROJECT_ROOT/} ($human_size)"
                            total_video_size=$((total_video_size + size))
                        fi
                    done
                fi
            done
        fi
    done
    
    echo ""
    print_status "Summary:"
    print_detail "Total images: $total_images"
    print_detail "Total videos: $total_videos"
    print_detail "Total image size: $(humanize_size $total_image_size)"
    print_detail "Total video size: $(humanize_size $total_video_size)"
    echo ""
}

# Function to find references
find_references() {
    print_header "🔍 FINDING FILE REFERENCES"
    
    local total_references=0
    
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            echo "References in $dir:"
            
            for ext in "${CODE_EXTENSIONS[@]}"; do
                find "$PROJECT_ROOT/$dir" -name "*.$ext" | while read -r file; do
                    # Create pattern for all media extensions
                    local img_pattern=""
                    for img_ext in "${IMAGE_EXTENSIONS[@]}"; do
                        if [ -n "$img_pattern" ]; then
                            img_pattern="$img_pattern\|"
                        fi
                        img_pattern="$img_pattern\\.$img_ext"
                    done
                    
                    local vid_pattern=""
                    for vid_ext in "${VIDEO_EXTENSIONS[@]}"; do
                        if [ -n "$vid_pattern" ]; then
                            vid_pattern="$vid_pattern\|"
                        fi
                        vid_pattern="$vid_pattern\\.$vid_ext"
                    done
                    
                    local combined_pattern="\\($img_pattern\\|$vid_pattern\\)"
                    
                    if grep -q "$combined_pattern" "$file" 2>/dev/null; then
                        total_references=$((total_references + 1))
                        print_detail "${file#$PROJECT_ROOT/}"
                        
                        # Show specific matches
                        grep -n "$combined_pattern" "$file" 2>/dev/null | head -3 | while read -r line; do
                            echo "      $line"
                        done
                    fi
                done
            done
        fi
    done
    
    echo ""
    print_status "Total files with references: $total_references"
    echo ""
}

# Function to simulate the optimization process
simulate_optimization() {
    print_header "🎯 OPTIMIZATION SIMULATION"
    
    echo "The optimization process will:"
    echo ""
    
    print_detail "1. Convert all images to WebP format (typically 70-90% smaller)"
    print_detail "2. Convert all videos to WebM format (typically 40-60% smaller)"
    print_detail "3. Update all import/src references in code files"
    print_detail "4. Test build to ensure no broken references"
    print_detail "5. Remove original files only after successful conversion"
    echo ""
    
    print_warning "⚠️  IMPORTANT CONSIDERATIONS:"
    print_detail "• Original files will be permanently deleted"
    print_detail "• All code references will be automatically updated"
    print_detail "• Process will stop if any errors occur"
    print_detail "• Backup your project before running if needed"
    echo ""
}

# Function to estimate impact
estimate_impact() {
    print_header "📈 ESTIMATED IMPACT"
    
    local total_size=0
    
    # Calculate current total size
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${IMAGE_EXTENSIONS[@]}" "${VIDEO_EXTENSIONS[@]}"; do
                local files=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null)
                if [ -n "$files" ]; then
                    echo "$files" | while read -r file; do
                        if [ -f "$file" ]; then
                            local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
                            total_size=$((total_size + size))
                        fi
                    done
                fi
            done
        fi
    done
    
    local estimated_webp_savings=$((total_size * 80 / 100))  # 80% average savings
    local estimated_webm_savings=$((total_size * 50 / 100))  # 50% average savings
    local estimated_total_savings=$(((estimated_webp_savings + estimated_webm_savings) / 2))
    
    print_detail "Current total media size: $(humanize_size $total_size)"
    print_detail "Estimated savings: $(humanize_size $estimated_total_savings) (60-80%)"
    print_detail "Performance improvement: Faster loading, better SEO"
    print_detail "Browser compatibility: WebP/WebM widely supported"
    echo ""
}

# Function to check for potential issues
check_potential_issues() {
    print_header "⚠️  POTENTIAL ISSUES CHECK"
    
    local issues_found=0
    
    # Check for files that might not convert well
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            # Check for very small images (might not benefit from WebP)
            find "$PROJECT_ROOT/$dir" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | while read -r file; do
                if [ -f "$file" ]; then
                    local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
                    if [ $size -lt 1024 ]; then  # Less than 1KB
                        print_warning "Very small image (may not benefit): ${file#$PROJECT_ROOT/}"
                        issues_found=$((issues_found + 1))
                    fi
                fi
            done
            
            # Check for unusual file extensions
            find "$PROJECT_ROOT/$dir" -name "*.gif" | while read -r file; do
                print_warning "GIF file found (animation may be lost): ${file#$PROJECT_ROOT/}"
                issues_found=$((issues_found + 1))
            done
        fi
    done
    
    # Check for dynamic imports (harder to catch)
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            find "$PROJECT_ROOT/$dir" -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | while read -r file; do
                if grep -q "import.*\${" "$file" 2>/dev/null; then
                    print_warning "Dynamic imports detected: ${file#$PROJECT_ROOT/} (manual review needed)"
                    issues_found=$((issues_found + 1))
                fi
            done
        fi
    done
    
    if [ $issues_found -eq 0 ]; then
        print_success "No potential issues detected"
    else
        print_warning "Found $issues_found potential issues (review above)"
    fi
    
    echo ""
}

# Main validation function
main() {
    print_header "🔍 MEDIA OPTIMIZATION VALIDATOR"
    echo "Project: $PROJECT_ROOT"
    echo "WebP Script: $WEBP_SCRIPT_PATH"
    echo "WebM Script: $WEBM_SCRIPT_PATH"
    echo ""
    
    # Validate prerequisites
    local errors=$(validate_prerequisites)
    if [ $errors -gt 0 ]; then
        print_error "Validation failed with $errors errors"
        echo ""
        print_status "Please fix the above issues before running the optimization script"
        exit 1
    fi
    
    # Analyze current state
    analyze_media_files
    find_references
    simulate_optimization
    estimate_impact
    check_potential_issues
    
    # Final recommendation
    print_header "✅ VALIDATION COMPLETE"
    print_success "Project is ready for media optimization!"
    echo ""
    print_status "To run optimization: ./optimize-media.sh $WEBP_SCRIPT_PATH $WEBM_SCRIPT_PATH $PROJECT_ROOT"
    echo ""
}

# Run validation
main "$@"
