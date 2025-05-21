# shellcheck disable=SC2148

SKIPUNZIP=1
if [ "$API" -ge 28 ]; then
  ui_print "- 安卓 SDK 版本: $API"
else
  ui_print "*********************************************************"
  ui_print "! 不支持安卓 SDK 版本 $API"
  abort "*********************************************************"
fi

if [[ "$KSU" == "true" ]]; then
  ui_print "- KernelSU 用户空间版本号: $KSU_VER_CODE"
  ui_print "- KernelSU 内核空间版本号: $KSU_KERNEL_VER_CODE"
  if [ "$KSU_KERNEL_VER_CODE" -lt 11089 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 KernelSU 管理器 v0.6.2 或更高版本"
    abort "*********************************************"
  fi
  RootImplement="KernelSU"
  version="$KSU_VER_CODE"
  versionCode="$KSU_KERNEL_VER_CODE"
elif [[ "$APATCH" == "true" ]]; then
  ui_print "- APatch 版本名: $APATCH_VER"
  ui_print "- APatch 版本号: $APATCH_VER_CODE"
  RootImplement="APatch"
  version="$APATCH_VER"
  versionCode="$APATCH_VER_CODE"
else
  ui_print "- Magisk 版本名: $MAGISK_VER"
  ui_print "- Magisk 版本号: $MAGISK_VER_CODE"
  RootImplement="Magisk"
  version="$MAGISK_VER"
  versionCode="$MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 Magisk 26.0+"
    abort "*********************************************"
  fi
fi
if [ ! -d /storage/emulated/0/Android/MIUI_odex/module_files ]; then
  mkdir -p /storage/emulated/0/Android/MIUI_odex/module_files
fi
{
  echo "RootImplement=$RootImplement"
  echo "version=$version"
  echo "versionCode=$versionCode"
} >>/storage/emulated/0/Android/MIUI_odex/RootImplement
rm -rf /data/system/package_cache/*
unzip -o "$ZIPFILE" 'module.prop' -d "$MODPATH"
unzip -o "$ZIPFILE" 'uninstall.sh' -d "$MODPATH"
unzip -o "$ZIPFILE" 'system/*' -d "$MODPATH"
unzip -o "$ZIPFILE" 'META-INF/*' -d "$MODPATH"
unzip -o "$ZIPFILE" 'customize_odex.sh' -d "$MODPATH"

unzip -o "$ZIPFILE" 'odex.sh' -d "/storage/emulated/0/Android/MIUI_odex"
[ ! -f /storage/emulated/0/Android/MIUI_odex/Simple_List.prop ] && unzip -o "$ZIPFILE" 'Simple_List.prop' -d "/storage/emulated/0/Android/MIUI_odex"
[ -f /storage/emulated/0/Android/MIUI_odex/odex.json ] && rm -rf /storage/emulated/0/Android/MIUI_odex/odex.json
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH"/system/bin 0 2000 0755 0755
ui_print "- 安装完成,请重启后运行/storage/emulated/0/Android/MIUI_odex/odex.sh"
