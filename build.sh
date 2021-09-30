#!/bin/bash

flutter clean
flutter build ios --release --no-sound-null-safety

xcodebuild -scheme Runner \
    -destination generic/platform=iOS \
    archive -archivePath ".temp/R.xcarchive" \
    -workspace "ios/Runner.xcworkspace" \
    -configuration Release \
    ENABLE_BITCODE=NO

xcodebuild -exportArchive \
    -exportOptionsPlist "ios/Runner/Info.plist" \
    -archivePath ".temp/R.xcarchive" \
    -exportPath  ".temp/R.ipa" \
    ENABLE_BITCODE=NO