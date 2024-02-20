#!/bin/zsh

rm -rf /Users/jk/Library/Application\ Support/BookMacster/*
cp -Rp /Users/jk/Library/Application\ Support/BookMacster-v2/ /Users/jk/Library/Application\ Support/BookMacster/

defaults write com.sheepsystems.BookMacster lastVersion "2.12.4"

defaults write com.sheepsystems.BookMacster doOpenAfterLaunchUuids -array "93BBD4BF-E938-4B2D-B5E1-31BEDAFC73B1"
