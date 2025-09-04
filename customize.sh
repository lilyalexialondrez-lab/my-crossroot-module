#!/system/bin/sh
# customize.sh - install-time behavior for both Magisk and KernelSU
MODDIR="${0%/*}"
ui_print() { echo "$1"; }

# Detect KernelSU (KSU) environment
IS_KSU=false
[ "$KSU" = "true" ] && IS_KSU=true

ui_print ">> Installing My Cross-Root Module"
ui_print ">> Platform: $([ "$IS_KSU" = true ] && echo KernelSU || echo Magisk)"

# Sample lists - modify to your needs
REPLACE_LIST="
/system/app/YouTube
"
REMOVE_LIST="
/system/app/Bloatware
"

if [ "$IS_KSU" = true ]; then
  # KSU style: pass REPLACE/REMOVE variables to installer
  REPLACE="$REPLACE_LIST"
  REMOVE="$REMOVE_LIST"
  export REPLACE REMOVE
else
  # Magisk: create .replace sentinel files and whiteouts
  for p in $REPLACE_LIST; do
    mkdir -p "$MODDIR$p"
    touch "$MODDIR$p/.replace"
  done
  for p in $REMOVE_LIST; do
    mkdir -p "$(dirname "$MODDIR$p")"
    mknod "$MODDIR$p" c 0 0 2>/dev/null || true
  done
fi

# Standard perms for system/ payloads
if [ -d "$MODDIR/system" ]; then
  set_perm_recursive "$MODDIR/system" 0 0 0755 0644
fi
