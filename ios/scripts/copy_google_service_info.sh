#!/usr/bin/env bash
# Copies the right GoogleService-Info.plist into the app bundle based on the
# active Xcode build configuration. Runs as a Run Script build phase wired
# inside the Runner target (see docs/release_flavors_ci.md).
#
# Configuration names follow the per-flavor pattern produced by the Flutter
# iOS flavors setup: Debug-dev / Release-dev / Profile-dev, etc.

set -euo pipefail

case "${CONFIGURATION}" in
  *dev)
    FLAVOR=dev
    ;;
  *staging)
    FLAVOR=staging
    ;;
  *production|Debug|Release|Profile)
    FLAVOR=production
    ;;
  *)
    echo "warning: unknown CONFIGURATION '${CONFIGURATION}', defaulting to production"
    FLAVOR=production
    ;;
esac

SRC="${SRCROOT}/config/${FLAVOR}/GoogleService-Info.plist"
DST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

if [[ ! -f "${SRC}" ]]; then
  echo "error: Missing ${SRC}. Download the GoogleService-Info.plist for the" \
       "${FLAVOR} iOS app from Firebase Console and place it there."
  exit 1
fi

echo "Copying Firebase config for flavor '${FLAVOR}' → ${DST}"
cp "${SRC}" "${DST}"
