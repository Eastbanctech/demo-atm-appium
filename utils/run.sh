#!/bin/sh

rm -rf build

mkdir build

xcodebuild -workspace ios/myRCN/myRCN.xcworkspace -scheme myRCN -derivedDataPath build/ -sdk iphonesimulator

cucumber appium/
