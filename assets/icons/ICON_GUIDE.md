# Currency ConvertX - Custom App Icon Guide

## Current Status
- ✅ App name updated to "Currency ConvertX" in AndroidManifest.xml
- ✅ flutter_launcher_icons package added to dev dependencies
- ✅ Launcher icons configuration added to pubspec.yaml

## Creating the Custom App Icon

### Icon Design Concept
Create a **1024x1024px** PNG image with the following design:
- Background: Android Green gradient (#4CAF50 to #2E7D32)
- Center icon: White wallet/currency symbol (💰 or 💱)
- Style: Modern, flat design with slight shadow
- Border: Optional subtle rounded corners

### Steps to Apply the Custom Icon

1. **Create the icon image:**
   ```
   Size: 1024x1024 pixels
   Format: PNG with transparency
   Name: app_icon.png
   Location: assets/icons/app_icon.png
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate launcher icons:**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Alternative: Manual Icon Creation**
   If you don't have the icon file, you can manually replace the existing icons in:
   ```
   android/app/src/main/res/mipmap-hdpi/ic_launcher.png (72x72)
   android/app/src/main/res/mipmap-mdpi/ic_launcher.png (48x48)
   android/app/src/main/res/mipmap-xhdpi/ic_launcher.png (96x96)
   android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png (144x144)
   android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png (192x192)
   ```

### Icon Design Elements
- **Primary Color**: #4CAF50 (Android Green)
- **Secondary Color**: #2E7D32 (Dark Green)
- **Accent**: #81C784 (Light Green)
- **Icon Symbol**: Currency/wallet theme (💱, 💰, or custom dollar sign)
- **Style**: Material Design 3 principles

### Quick Icon Creation Tools
- **Online**: Canva, Figma, or Adobe Express
- **Desktop**: GIMP, Photoshop, or Inkscape
- **Mobile**: Icon Pack Studio, Logo Maker

### Testing the Icon
After generating/replacing the icons:
```bash
flutter clean
flutter build apk
```

The new "Currency ConvertX" icon will appear on the device with the updated branding and Android green theme.