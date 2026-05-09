@echo off
REM Focus HSC AI - APK Build Script

echo.
echo ========================================
echo  Focus HSC AI - APK Builder
echo ========================================
echo.

REM Set path
set PATH=%PATH%;C:\src\flutter\bin;C:\flutter\bin

REM Check Flutter
echo Checking Flutter...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found!
    echo Please install Flutter first or set PATH correctly.
    pause
    exit /b 1
)

echo ✓ Flutter found

REM Navigate to project
cd /d "c:\Users\vsadi\OneDrive\Apps\HSC 2026\focus-hsc-ai-flutter"

echo.
echo Step 1: Getting dependencies...
flutter pub get

echo.
echo Step 2: Running build_runner...
flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo Step 3: Building APK...
flutter build apk --release

echo.
echo ========================================
echo Build Complete!
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
echo.
pause
