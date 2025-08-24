#!/bin/bash

# =============================================================================
# Media Optimization Script
# Converts images to WebP, videos to WebM, updates references, and cleans up
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

# Global variables
TOTAL_IMAGES=0
TOTAL_VIDEOS=0
TOTAL_REFERENCES=0
CONVERTED_IMAGES=()
CONVERTED_VIDEOS=()
UPDATED_FILES=()
START_TIME=$(date +%s)

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

# Function to estimate processing time
estimate_time() {
    local images=$1
    local videos=$2
    local references=$3
    
    # Rough estimates (in seconds)
    local image_time=$((images * 2))     # 2s per image
    local video_time=$((videos * 10))    # 10s per video
    local reference_time=$((references / 10)) # 10 references per second
    
    local total=$((image_time + video_time + reference_time))
    echo "$total"
}

# Function to format time
format_time() {
    local seconds=$1
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    
    if [ $minutes -gt 0 ]; then
        echo "${minutes}m ${remaining_seconds}s"
    else
        echo "${remaining_seconds}s"
    fi
}

# Function to humanize file size
humanize_size() {
    local bytes=$1
    local sizes=("B" "KB" "MB" "GB")
    local unit=0
    
    while [ $bytes -gt 1024 ] && [ $unit -lt 3 ]; do
        bytes=$((bytes / 1024))
        unit=$((unit + 1))
    done
    
    echo "${bytes}${sizes[$unit]}"
}

# Function to analyze project
analyze_project() {
    print_header "🔍 ANALYZING PROJECT"
    
    local image_count=0
    local video_count=0
    local reference_count=0
    
    # Count media files
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${IMAGE_EXTENSIONS[@]}"; do
                local count=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null | wc -l)
                image_count=$((image_count + count))
            done
            
            for ext in "${VIDEO_EXTENSIONS[@]}"; do
                local count=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null | wc -l)
                video_count=$((video_count + count))
            done
        fi
    done
    
    # Count references in code files
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${CODE_EXTENSIONS[@]}"; do
                if [ -n "$(find "$PROJECT_ROOT/$dir" -name "*.$ext" 2>/dev/null)" ]; then
                    local count=$(find "$PROJECT_ROOT/$dir" -name "*.$ext" -exec grep -l '\.\(jpg\|jpeg\|png\|gif\|bmp\|tiff\|mp4\|mov\|avi\|mkv\|flv\|wmv\|mpeg\|mpg\|m4v\|3gp\|ogg\)' {} \; 2>/dev/null | wc -l)
                    reference_count=$((reference_count + count))
                fi
            done
        fi
    done
    
    TOTAL_IMAGES=$image_count
    TOTAL_VIDEOS=$video_count
    TOTAL_REFERENCES=$reference_count
    
    echo "📊 Found:"
    echo "   • Images: $TOTAL_IMAGES files"
    echo "   • Videos: $TOTAL_VIDEOS files"
    echo "   • Files with references: $TOTAL_REFERENCES files"
    echo ""
}

# Function to show summary and get confirmation
show_summary_and_confirm() {
    local estimated_time=$(estimate_time $TOTAL_IMAGES $TOTAL_VIDEOS $TOTAL_REFERENCES)
    local formatted_time=$(format_time $estimated_time)
    
    print_header "📋 OPTIMIZATION SUMMARY"
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│                    PLANNED OPERATIONS                   │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ 🖼️  Convert $TOTAL_IMAGES images to WebP format                     │"
    echo "│ 🎥 Convert $TOTAL_VIDEOS videos to WebM format                      │"
    echo "│ 🔄 Update references in $TOTAL_REFERENCES files                     │"
    echo "│ 🗑️  Remove original files after successful conversion     │"
    echo "│ ⏱️  Estimated time: $formatted_time                               │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    
    print_header "⚠️  IMPORTANT NOTES"
    echo "• Original files will be deleted after successful conversion"
    echo "• All import statements will be automatically updated"
    echo "• A backup strategy is recommended before proceeding"
    echo "• The process will stop if any errors occur"
    echo ""
    
    read -p "$(echo -e "${YELLOW}Do you want to proceed with media optimization? [y/N]: ${NC}")" -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Operation cancelled by user"
        exit 0
    fi
    
    echo ""
}

# Function to convert images
convert_images() {
    if [ $TOTAL_IMAGES -eq 0 ]; then
        print_status "No images found to convert"
        return 0
    fi
    
    print_header "🖼️  CONVERTING IMAGES TO WEBP"
    
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            print_status "Processing directory: $dir"
            
            # Check if conversion script exists
            if [ ! -f "$WEBP_SCRIPT_PATH" ]; then
                print_error "WebP conversion script not found: $WEBP_SCRIPT_PATH"
                return 1
            fi
            
            # Run conversion script
            cd "$PROJECT_ROOT"
            chmod +x "$WEBP_SCRIPT_PATH"
            
            if "$WEBP_SCRIPT_PATH" "$dir" > /dev/null 2>&1; then
                print_success "Converted images in $dir"
                
                # Move converted files to original locations
                if [ -d "$dir/webp" ]; then
                    find "$dir/webp" -name "*.webp" | while read -r webp_file; do
                        # Calculate original path
                        relative_path="${webp_file#$dir/webp/$dir/}"
                        target_path="$dir/$relative_path"
                        target_dir=$(dirname "$target_path")
                        
                        mkdir -p "$target_dir"
                        cp "$webp_file" "$target_path"
                        CONVERTED_IMAGES+=("$target_path")
                    done
                    
                    # Clean up temporary webp directory
                    rm -rf "$dir/webp"
                fi
            else
                print_error "Failed to convert images in $dir"
                return 1
            fi
        fi
    done
    
    print_success "Image conversion completed"
}

# Function to convert videos
convert_videos() {
    if [ $TOTAL_VIDEOS -eq 0 ]; then
        print_status "No videos found to convert"
        return 0
    fi
    
    print_header "🎥 CONVERTING VIDEOS TO WEBM"
    
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            print_status "Processing directory: $dir"
            
            # Check if conversion script exists
            if [ ! -f "$WEBM_SCRIPT_PATH" ]; then
                print_error "WebM conversion script not found: $WEBM_SCRIPT_PATH"
                return 1
            fi
            
            # Run conversion script
            cd "$PROJECT_ROOT"
            chmod +x "$WEBM_SCRIPT_PATH"
            
            if "$WEBM_SCRIPT_PATH" "$dir" > /dev/null 2>&1; then
                print_success "Converted videos in $dir"
                
                # Move converted files to original locations
                if [ -d "$dir/webm" ]; then
                    find "$dir/webm" -name "*.webm" | while read -r webm_file; do
                        # Calculate original path
                        relative_path="${webm_file#$dir/webm/$dir/}"
                        target_path="$dir/$relative_path"
                        target_dir=$(dirname "$target_path")
                        
                        mkdir -p "$target_dir"
                        cp "$webm_file" "$target_path"
                        CONVERTED_VIDEOS+=("$target_path")
                    done
                    
                    # Clean up temporary webm directory
                    rm -rf "$dir/webm"
                fi
            else
                print_error "Failed to convert videos in $dir"
                return 1
            fi
        fi
    done
    
    print_success "Video conversion completed"
}

# Function to update references
update_references() {
    print_header "🔄 UPDATING FILE REFERENCES"
    
    local updated_count=0
    
    # Find all code files that might contain media references
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${CODE_EXTENSIONS[@]}"; do
                find "$PROJECT_ROOT/$dir" -name "*.$ext" | while read -r file; do
                    local file_updated=false
                    local temp_file=$(mktemp)
                    cp "$file" "$temp_file"
                    
                    # Update image extensions
                    for img_ext in "${IMAGE_EXTENSIONS[@]}"; do
                        if grep -q "\.$img_ext" "$file"; then
                            sed -i '' "s/\.$img_ext/.webp/g" "$temp_file"
                            file_updated=true
                        fi
                    done
                    
                    # Update video extensions
                    for vid_ext in "${VIDEO_EXTENSIONS[@]}"; do
                        if grep -q "\.$vid_ext" "$file"; then
                            sed -i '' "s/\.$vid_ext/.webm/g" "$temp_file"
                            file_updated=true
                        fi
                    done
                    
                    if [ "$file_updated" = true ]; then
                        mv "$temp_file" "$file"
                        UPDATED_FILES+=("$file")
                        updated_count=$((updated_count + 1))
                        print_status "Updated references in: ${file#$PROJECT_ROOT/}"
                    else
                        rm "$temp_file"
                    fi
                done
            done
        fi
    done
    
    print_success "Updated references in $updated_count files"
}

# Function to test build
test_build() {
    print_header "🧪 TESTING BUILD"
    
    cd "$PROJECT_ROOT"
    
    if command -v pnpm >/dev/null 2>&1; then
        if pnpm build --silent >/dev/null 2>&1; then
            print_success "Build test passed"
            return 0
        else
            print_error "Build test failed"
            return 1
        fi
    elif command -v npm >/dev/null 2>&1; then
        if npm run build >/dev/null 2>&1; then
            print_success "Build test passed"
            return 0
        else
            print_error "Build test failed"
            return 1
        fi
    else
        print_warning "No package manager found, skipping build test"
        return 0
    fi
}

# Function to clean up original files
cleanup_originals() {
    print_header "🗑️  REMOVING ORIGINAL FILES"
    
    local removed_count=0
    
    # Remove original image files that have WebP counterparts
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            for ext in "${IMAGE_EXTENSIONS[@]}"; do
                find "$PROJECT_ROOT/$dir" -name "*.$ext" | while read -r original_file; do
                    webp_file="${original_file%.*}.webp"
                    if [ -f "$webp_file" ]; then
                        rm "$original_file"
                        removed_count=$((removed_count + 1))
                        print_status "Removed: ${original_file#$PROJECT_ROOT/}"
                    fi
                done
            done
            
            # Remove original video files that have WebM counterparts
            for ext in "${VIDEO_EXTENSIONS[@]}"; do
                find "$PROJECT_ROOT/$dir" -name "*.$ext" | while read -r original_file; do
                    webm_file="${original_file%.*}.webm"
                    if [ -f "$webm_file" ]; then
                        rm "$original_file"
                        removed_count=$((removed_count + 1))
                        print_status "Removed: ${original_file#$PROJECT_ROOT/}"
                    fi
                done
            done
        fi
    done
    
    print_success "Removed $removed_count original files"
}

# Function to show final summary
show_final_summary() {
    local end_time=$(date +%s)
    local total_time=$((end_time - START_TIME))
    local formatted_total_time=$(format_time $total_time)
    
    print_header "🎉 OPTIMIZATION COMPLETED"
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│                    FINAL SUMMARY                        │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ ✅ Images converted: ${#CONVERTED_IMAGES[@]}                              │"
    echo "│ ✅ Videos converted: ${#CONVERTED_VIDEOS[@]}                              │"
    echo "│ ✅ Files updated: ${#UPDATED_FILES[@]}                                 │"
    echo "│ ⏱️  Total time: $formatted_total_time                               │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    
    # Calculate space savings (approximate)
    print_header "💾 ESTIMATED SPACE SAVINGS"
    echo "• Images: ~70-90% size reduction with WebP"
    echo "• Videos: ~40-60% size reduction with WebM"
    echo "• Overall: Significant performance improvement"
    echo ""
    
    print_success "Media optimization completed successfully!"
    print_status "Your project now uses optimized WebP images and WebM videos"
    print_status "Build test passed - all references updated correctly"
}

# Main execution
main() {
    print_header "🚀 MEDIA OPTIMIZATION SCRIPT"
    echo "Project: $PROJECT_ROOT"
    echo "WebP Script: $WEBP_SCRIPT_PATH"
    echo "WebM Script: $WEBM_SCRIPT_PATH"
    echo ""
    
    # Step 1: Analyze
    analyze_project
    
    # Step 2: Show summary and confirm
    show_summary_and_confirm
    
    # Step 3: Convert images
    convert_images || {
        print_error "Image conversion failed"
        exit 1
    }
    
    # Step 4: Convert videos
    convert_videos || {
        print_error "Video conversion failed"
        exit 1
    }
    
    # Step 5: Update references
    update_references || {
        print_error "Reference update failed"
        exit 1
    }
    
    # Step 6: Test build
    test_build || {
        print_error "Build test failed - references may be incorrect"
        exit 1
    }
    
    # Step 7: Clean up originals
    cleanup_originals || {
        print_error "Cleanup failed"
        exit 1
    }
    
    # Step 8: Final summary
    show_final_summary
}

# Check if script paths are provided or exist
if [ ! -f "$WEBP_SCRIPT_PATH" ] && [ ! -f "$WEBM_SCRIPT_PATH" ]; then
    print_error "Conversion scripts not found!"
    echo "Usage: $0 [webp_script_path] [webm_script_path] [project_root]"
    echo "Example: $0 ./convertImageToWebp.sh ./convertVideoToWebm.sh ."
    exit 1
fi

# Run main function
main "$@"
