# shellcheck disable=SC2148,SC2034

SKIPUNZIP=0
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
elif [[ "$APATCH" == "true" ]]; then
  ui_print "- APatch 版本名: $APATCH_VER"
  ui_print "- APatch 版本号: $APATCH_VER_CODE"
else
  ui_print "- Magisk 版本名: $MAGISK_VER"
  ui_print "- Magisk 版本号: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 Magisk 26.0+"
    abort "*********************************************"
  fi
fi
rm -rf /data/system/package_cache/*
set_perm_recursive "$MODPATH" 0 0 0755 0644
[ -d "$MODPATH"/system/vendor/app ] && set_perm_recursive "$MODPATH"/system/vendor/app 0 0 0755 0644 u:object_r:vendor_app_file:s0
[ -d "$MODPATH"/system/vendor/odm/app ] && set_perm_recursive "$MODPATH"/system/vendor/odm/app 0 0 0755 0644 u:object_r:vendor_app_file:s0
[ -d "$MODPATH"/system/vendor/framework ] && set_perm_recursive "$MODPATH"/system/vendor/framework 0 0 0755 0644 u:object_r:vendor_framework_file:s0
