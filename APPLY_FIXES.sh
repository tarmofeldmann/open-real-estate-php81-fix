#!/bin/bash
# Open Real Estate PHP 8.1 fix applier
echo "Copying fixed files..."
cp -v framework/utils/CJSON.php /var/home/kamreale1/lauaviin.lol/framework/utils/CJSON.php
cp -v framework/db/ar/CActiveFinder.php /var/home/kamreale1/lauaviin.lol/framework/db/ar/CActiveFinder.php
cp -v protected/helpers/HTMLPurifier.standalone.php /var/home/kamreale1/lauaviin.lol/protected/helpers/HTMLPurifier.standalone.php
cp -v protected/helpers/IdnaConvert.php /var/home/kamreale1/lauaviin.lol/protected/helpers/IdnaConvert.php
echo "Clear cache..."
rm -rf /var/home/kamreale1/lauaviin.lol/protected/runtime/cache/*
rm -rf /var/home/kamreale1/lauaviin.lol/assets/*
echo "Done - Ctrl+Shift+R"
