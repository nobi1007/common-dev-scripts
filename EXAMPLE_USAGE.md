# Media Optimization Scripts - Example Usage

## Complete Workflow Example

Here's how you would use these scripts on a fresh project:

### 1. **Initial Setup**
```bash
# Place the conversion scripts in your project
cp /path/to/convertImageToWebp.sh .
cp /path/to/convertVideoToWebm.sh .

# Make sure the optimization scripts are available
cp /path/to/optimize-media.sh .
cp /path/to/validate-optimization.sh .

# Make them executable
chmod +x *.sh
```

### 2. **Validation (Always run first)**
```bash
./validate-optimization.sh
```

**Expected Output:**
```
🔍 MEDIA OPTIMIZATION VALIDATOR
Project: /Users/yourname/project
WebP Script: ./convertImageToWebp.sh
WebM Script: ./convertVideoToWebm.sh

🔍 VALIDATING PREREQUISITES
[SUCCESS] Project root found: /Users/yourname/project
[SUCCESS] WebP script found: ./convertImageToWebp.sh
[SUCCESS] WebM script found: ./convertVideoToWebm.sh
[SUCCESS] Tool available: find
[SUCCESS] Tool available: grep
[SUCCESS] Tool available: sed
[SUCCESS] Build tool found: pnpm

📊 ANALYZING MEDIA FILES
Images found:
   → src/assets/hero.jpg (245KB)
   → src/assets/product.png (156KB)
   → public/og-image.png (89KB)

Videos found:
   → src/assets/demo.mp4 (2.3MB)
   → src/assets/intro.mov (1.8MB)

[INFO] Summary:
   → Total images: 3
   → Total videos: 2
   → Total image size: 490KB
   → Total video size: 4.1MB

🔍 FINDING FILE REFERENCES
References in src:
   → src/components/Hero.astro
   → src/components/Product.tsx
   → src/pages/index.astro

[INFO] Total files with references: 3

📈 ESTIMATED IMPACT
   → Current total media size: 4.6MB
   → Estimated savings: 3.2MB (60-80%)
   → Performance improvement: Faster loading, better SEO

✅ VALIDATION COMPLETE
[SUCCESS] Project is ready for media optimization!
```

### 3. **Run Optimization**
```bash
./optimize-media.sh
```

**Expected Output:**
```
🚀 MEDIA OPTIMIZATION SCRIPT
Project: /Users/yourname/project
WebP Script: ./convertImageToWebp.sh
WebM Script: ./convertVideoToWebm.sh

🔍 ANALYZING PROJECT
📊 Found:
   • Images: 3 files
   • Videos: 2 files
   • Files with references: 3 files

📋 OPTIMIZATION SUMMARY
┌─────────────────────────────────────────────────────────┐
│                    PLANNED OPERATIONS                   │
├─────────────────────────────────────────────────────────┤
│ 🖼️  Convert 3 images to WebP format                     │
│ 🎥 Convert 2 videos to WebM format                      │
│ 🔄 Update references in 3 files                         │
│ 🗑️  Remove original files after successful conversion     │
│ ⏱️  Estimated time: 45s                                 │
└─────────────────────────────────────────────────────────┘

⚠️  IMPORTANT NOTES
• Original files will be deleted after successful conversion
• All import statements will be automatically updated
• A backup strategy is recommended before proceeding
• The process will stop if any errors occur

Do you want to proceed with media optimization? [y/N]: y

🖼️  CONVERTING IMAGES TO WEBP
[INFO] Processing directory: src
[SUCCESS] Converted images in src
[INFO] Processing directory: public
[SUCCESS] Converted images in public
[SUCCESS] Image conversion completed

🎥 CONVERTING VIDEOS TO WEBM
[INFO] Processing directory: src
[SUCCESS] Converted videos in src
[SUCCESS] Video conversion completed

🔄 UPDATING FILE REFERENCES
[INFO] Updated references in: src/components/Hero.astro
[INFO] Updated references in: src/components/Product.tsx
[INFO] Updated references in: src/pages/index.astro
[SUCCESS] Updated references in 3 files

🧪 TESTING BUILD
[SUCCESS] Build test passed

🗑️  REMOVING ORIGINAL FILES
[INFO] Removed: src/assets/hero.jpg
[INFO] Removed: src/assets/product.png
[INFO] Removed: public/og-image.png
[INFO] Removed: src/assets/demo.mp4
[INFO] Removed: src/assets/intro.mov
[SUCCESS] Removed 5 original files

🎉 OPTIMIZATION COMPLETED
┌─────────────────────────────────────────────────────────┐
│                    FINAL SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│ ✅ Images converted: 3                                  │
│ ✅ Videos converted: 2                                  │
│ ✅ Files updated: 3                                     │
│ ⏱️  Total time: 42s                                     │
└─────────────────────────────────────────────────────────┘

💾 ESTIMATED SPACE SAVINGS
• Images: ~70-90% size reduction with WebP
• Videos: ~40-60% size reduction with WebM
• Overall: Significant performance improvement

[SUCCESS] Media optimization completed successfully!
[INFO] Your project now uses optimized WebP images and WebM videos
[INFO] Build test passed - all references updated correctly
```

## Advanced Usage

### Custom Directories
```bash
# Only process specific directories
# Edit SOURCE_DIRS in the script:
SOURCE_DIRS=("src/assets" "public/images" "docs/media")
```

### Different File Types
```bash
# Add more image formats
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "webp" "avif")

# Add more video formats  
VIDEO_EXTENSIONS=("mp4" "mov" "avi" "mkv" "webm" "ogv")
```

### Integration with CI/CD
```bash
# In your deployment script
./validate-optimization.sh || exit 1
./optimize-media.sh || exit 1
npm run build
```

## Real Project Results

Based on our actual optimization of this project:

**Before Optimization:**
- 51 images (various formats)
- 5 videos (MP4 format)
- Total size: ~47MB

**After Optimization:**
- 51 WebP images
- 5 WebM videos  
- Total size: ~13MB
- **Space savings: 72% reduction**
- **Performance: Significantly faster loading**

## Best Practices

1. **Always validate first**: Run validation script before optimization
2. **Test thoroughly**: The script tests builds, but manual testing is recommended
3. **Version control**: Commit before running optimization
4. **Monitor performance**: Use tools like Lighthouse to measure improvements
5. **Browser support**: WebP and WebM have excellent modern browser support

## Troubleshooting

### Script Not Found
```bash
# Make sure scripts are executable
chmod +x optimize-media.sh validate-optimization.sh

# Check script paths
ls -la *.sh
```

### Build Failures
```bash
# The script will stop if build fails
# Check the error output and fix manually
# Then re-run the optimization
```

### Permission Issues
```bash
# Make sure you have write permissions
chmod 755 src/ public/
```

---

These scripts automate the entire process we just completed manually, making it repeatable and reliable for any project!
