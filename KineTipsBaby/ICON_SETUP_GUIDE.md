# App Icon Setup Guide

## Converting SVG to PNG for iOS

I've created an SVG icon (`AppIcon.svg`) that matches your Android app's style:
- **Same teal background** (#008577)
- **White baby figure** in exercise pose
- **Subtle grid pattern** overlay
- **Soft pink heart** accent

### Steps to Add the Icon to iOS

#### Option 1: Online Converter (Easiest)

1. **Convert SVG to PNG**:
   - Visit: https://svgtopng.com or https://cloudconvert.com/svg-to-png
   - Upload `AppIcon.svg` from your project folder
   - Set size to **1024x1024 pixels**
   - Download the PNG

2. **Add to Xcode**:
   - Open Xcode
   - Navigate to `Assets.xcassets` → `AppIcon`
   - Drag the 1024x1024 PNG into the "iOS" slot (1024x1024 pt)
   - Xcode will automatically generate all required sizes

#### Option 2: Using Preview (Mac Built-in)

1. **Open the SVG**:
   ```bash
   open AppIcon.svg
   ```

2. **Export as PNG**:
   - File → Export
   - Format: PNG
   - Resolution: 1024x1024
   - Save as `AppIcon.png`

3. **Add to Xcode** (same as above)

#### Option 3: Command Line (ImageMagick)

If you have ImageMagick installed:
```bash
cd /Users/cosminoprea/personal-projects/KineTipsBaby/KineTipsBaby
convert -background none -size 1024x1024 AppIcon.svg AppIcon.png
```

Then drag `AppIcon.png` into Xcode's Assets.xcassets → AppIcon.

### Icon Design Details

**Matches Android:**
- ✅ Teal background (#008577)
- ✅ White foreground character
- ✅ Subtle grid pattern
- ✅ Rounded corners (iOS style)

**Baby Exercise Theme:**
- Baby figure with arms raised (exercise pose)
- Soft pink heart on chest
- Simple, friendly design
- Clear at all sizes

### Verify the Icon

After adding:
1. Build and run the app (⌘R)
2. Press Home button (⌘⇧H in simulator)
3. Check the app icon on the home screen
4. Verify it looks good in both light and dark mode

The icon should now match your Android app's branding! 🎨
