# Media Optimization Scripts

Two comprehensive scripts for automated media optimization in web projects.

## Scripts Overview

### 1. `validate-optimization.sh` - Validation & Analysis
**Purpose**: Analyzes your project and validates prerequisites before optimization.

**Features**:
- ✅ Validates conversion script paths and dependencies
- 📊 Analyzes current media files and their sizes
- 🔍 Finds all file references in code
- ⚠️ Identifies potential issues
- 📈 Estimates optimization impact
- 🎯 Shows what the optimization will do

### 2. `optimize-media.sh` - Full Optimization Process
**Purpose**: Executes the complete media optimization workflow.

**Features**:
- 🖼️ Converts images to WebP format
- 🎥 Converts videos to WebM format  
- 🔄 Updates all file references in code
- 🧪 Tests build to ensure no broken references
- 🗑️ Removes original files after successful conversion
- 📊 Provides detailed progress and summary reports
- ⏱️ Shows estimated and actual processing time

## Usage

### Step 1: Validate (Recommended)
```bash
./validate-optimization.sh [webp_script] [webm_script] [project_root]
```

### Step 2: Optimize
```bash
./optimize-media.sh [webp_script] [webm_script] [project_root]
```

### Examples
```bash
# Using default paths (scripts in current directory)
./validate-optimization.sh
./optimize-media.sh

# Using custom script paths
./validate-optimization.sh ../tools/convertImageToWebp.sh ../tools/convertVideoToWebm.sh .
./optimize-media.sh ../tools/convertImageToWebp.sh ../tools/convertVideoToWebm.sh .

# Different project directory
./optimize-media.sh ./convertImageToWebp.sh ./convertVideoToWebm.sh /path/to/project
```

## What It Does

### 1. **Analysis Phase**
- Scans `src/` and `public/` directories
- Counts images and videos by extension
- Identifies code files with media references
- Estimates processing time and space savings

### 2. **Conversion Phase**
- Runs your WebP conversion script on all images
- Runs your WebM conversion script on all videos
- Places converted files in original locations
- Tracks all conversions for cleanup

### 3. **Update Phase**
- Finds all code files (`.astro`, `.tsx`, `.jsx`, `.ts`, `.js`, `.vue`, `.svelte`, `.json`)
- Updates import statements and file references
- Changes extensions: `.jpg/.png` → `.webp`, `.mp4/.mov` → `.webm`
- Uses pattern matching: `import.*\.(jpg|jpeg|png|mp4)["']`

### 4. **Validation Phase**
- Tests project build to ensure no broken references
- Verifies all conversions completed successfully
- Ensures code references were updated correctly

### 5. **Cleanup Phase**
- Removes original files ONLY if:
  - ✅ Conversion was successful
  - ✅ WebP/WebM file exists
  - ✅ Build test passed
  - ✅ References were updated

## Safety Features

- **Pre-flight checks**: Validates all prerequisites before starting
- **Build testing**: Ensures no broken references before cleanup
- **Confirmation prompts**: Shows summary and asks for confirmation
- **Error handling**: Stops process if any step fails
- **Progress tracking**: Shows detailed progress throughout
- **Selective cleanup**: Only removes files with successful conversions

## Supported File Types

### Images → WebP
- `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.tiff`

### Videos → WebM  
- `.mp4`, `.mov`, `.avi`, `.mkv`, `.flv`, `.wmv`, `.mpeg`, `.mpg`, `.m4v`, `.3gp`, `.ogg`

### Code Files (for reference updates)
- `.astro`, `.tsx`, `.jsx`, `.ts`, `.js`, `.vue`, `.svelte`, `.json`

## Expected Results

### Performance Improvements
- **Images**: 70-90% size reduction with WebP
- **Videos**: 40-60% size reduction with WebM
- **Loading**: Significantly faster page loads
- **SEO**: Better Core Web Vitals scores

### Example Output
```
🎉 OPTIMIZATION COMPLETED
┌─────────────────────────────────────────────────────────┐
│                    FINAL SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│ ✅ Images converted: 51                                 │
│ ✅ Videos converted: 5                                  │
│ ✅ Files updated: 23                                    │
│ ⏱️  Total time: 2m 34s                                  │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

### Required Tools
- `find`, `grep`, `sed` (usually pre-installed)
- Your WebP conversion script
- Your WebM conversion script

### Optional Tools
- `pnpm` or `npm` (for build testing)
- `bc` (for size calculations)

## Error Handling

The script will stop and show helpful error messages if:
- Conversion scripts are missing or fail
- Build test fails after reference updates
- Required tools are not available
- File permissions prevent operations

## Backup Recommendation

While the script has multiple safety checks, it's recommended to:
1. Commit your current changes to git
2. Or create a backup of your project
3. Run validation first to preview changes
4. Test in a development environment

## Customization

Both scripts can be easily customized by modifying the configuration arrays:
- `SOURCE_DIRS`: Directories to process
- `IMAGE_EXTENSIONS`: Image file types to convert  
- `VIDEO_EXTENSIONS`: Video file types to convert
- `CODE_EXTENSIONS`: Code files to update references in

---

*These scripts were designed for modern web development workflows and have been tested on macOS and Linux systems.*
