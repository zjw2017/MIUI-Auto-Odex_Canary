SKIPUNZIP=0
SDK=$(getprop ro.system.build.version.sdk)
if [ "$SDK" -ge 28 ]; then
  ui_print "- Android SDK version: $SDK"
else
  ui_print "*********************************************************"
  ui_print "! Unsupported Android SDK version $SDK"
  abort "*********************************************************"
fi
ui_print "- Magisk version: $MAGISK_VER_CODE"
if [ "$MAGISK_VER_CODE" -lt 24000 ]; then
  ui_print "*********************************************************"
  ui_print "! Please install Magisk 24.0+"
  abort "*********************************************************"
fi
if [ ! -d /storage/emulated/0/MIUI_odex ]; then
  mkdir -p /storage/emulated/0/MIUI_odex
else
  rm -rf /storage/emulated/0/MIUI_odex/odex.sh
  rm -rf /storage/emulated/0/MIUI_odex/odex.json
fi
cp -f "$MODPATH"/odex.sh /storage/emulated/0/MIUI_odex && rm -rf "$MODPATH"/odex.sh
cp -f "$MODPATH"/odex.json /storage/emulated/0/MIUI_odex && rm -rf "$MODPATH"/odex.json
echo -n "description=$(cat $MODPATH/odex.md | sed '1d')" >>/data/adb/modules_update/odex_script_update_online_zjw2017/module.prop && rm -rf "$MODPATH"/odex.md
rm -rf "$MODPATH"/system.prop
[ ! -f /storage/emulated/0/MIUI_odex/Simple_List.prop ] && cp -f "$MODPATH"/Simple_List.prop /storage/emulated/0/MIUI_odex && rm -rf "$MODPATH"/Simple_List.prop
ui_print "- Done"