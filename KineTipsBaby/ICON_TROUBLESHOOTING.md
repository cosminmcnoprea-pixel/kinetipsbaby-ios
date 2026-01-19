# App Icon Not Showing - Troubleshooting

## Steps to Fix

### 1. Clean Build Folder
In Xcode:
- **Product → Clean Build Folder** (or press ⌘⇧K)
- Wait for it to complete

### 2. Delete App from Device/Simulator
- On your iPhone or simulator, **long press the app icon**
- Tap **"Remove App"** → **"Delete App"**
- This ensures the old cached icon is removed

### 3. Verify Icon is in Assets
- In Xcode, open `Assets.xcassets`
- Click on `AppIcon`
- Make sure you see the icon image in the **"iOS" 1024x1024** slot
- If it's not there, drag your PNG file into that slot

### 4. Check Info.plist (Optional)
- Open `Info.plist`
- Look for `CFBundleIcons` or icon-related entries
- Usually Xcode handles this automatically

### 5. Rebuild and Reinstall
- In Xcode, select your device/simulator
- Press **⌘R** to build and run
- The app will reinstall with the new icon

### 6. Force Restart (If Still Not Showing)

**On iPhone:**
- Force restart your iPhone
- Or go to Settings → General → Transfer or Reset iPhone → Reset → Reset Home Screen Layout

**On Simulator:**
- Device → Erase All Content and Settings
- Rebuild and run the app

## Common Issues

### Issue: Icon slot is empty in Xcode
**Solution:** Make sure you're dragging a PNG file (not SVG) that's exactly 1024x1024 pixels.

### Issue: Icon shows but it's the default blue/white
**Solution:** The PNG might not have been properly added. Try removing it and adding again.

### Issue: Icon shows in simulator but not on device
**Solution:** Clean build, delete app from device, and reinstall.

## Quick Command Line Check

To verify your icon file size:
```bash
cd /Users/cosminoprea/personal-projects/KineTipsBaby/KineTipsBaby
file AppIcon.png
```

Should show: PNG image data, 1024 x 1024

## Still Not Working?

1. Make sure the PNG is **exactly 1024x1024 pixels**
2. Make sure it's in **RGB color space** (not CMYK)
3. Make sure it has **no transparency** (or solid background)
4. Try converting the SVG again with different settings
