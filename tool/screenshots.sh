#!/usr/bin/env bash
# Portfolio screenshots of the demo build on an iPhone simulator with Dynamic Island.
#
#   tool/screenshots.sh                         # iPhone 17 Pro, light + dark → screenshots/
#   DEVICE="iPhone 17 Pro Max" tool/screenshots.sh
#   SKIP_BUILD=1 tool/screenshots.sh            # reuse build/ios/iphonesimulator/Runner.app
#
# Screenshot scenes hide the status bar (clock, signal, battery), and
# `--mask=alpha` keeps the Dynamic Island and rounded display corners in the PNGs.
set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE="${DEVICE:-iPhone 17 Pro}"
OUT="${OUT:-screenshots}"
DELAY="${DELAY:-5}"
BUNDLE_ID=com.ArtemOslopov.tiksiAvia
SCENES=(splash board tomorrow details drawer notifications settings auth admin editor add edit)

UDID=$(xcrun simctl list devices available -j | python3 -c '
import json, sys
name = sys.argv[1]
for devices in json.load(sys.stdin)["devices"].values():
    for d in devices:
        if d["name"] == name:
            print(d["udid"])
            sys.exit()
sys.exit("Simulator not found: " + name)
' "$DEVICE")

xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b >/dev/null

if [[ -z "${SKIP_BUILD:-}" ]]; then
  flutter build ios --simulator --debug --dart-define=DEMO=true
fi

# A clean install resets the saved theme and notification settings.
xcrun simctl uninstall "$UDID" "$BUNDLE_ID" 2>/dev/null || true
xcrun simctl install "$UDID" build/ios/iphonesimulator/Runner.app

# Dart sees no environment variables on iOS, so the app reads the scene from
# its temporary directory (see DemoScene.fromLaunch).
TMP_DIR="$(xcrun simctl get_app_container "$UDID" "$BUNDLE_ID" data)/tmp"
mkdir -p "$TMP_DIR"

# The first launch of a fresh debug install is slow; warm it up.
echo board > "$TMP_DIR/tiksi_scene"
xcrun simctl launch "$UDID" "$BUNDLE_ID" >/dev/null
sleep 10

for appearance in light dark; do
  xcrun simctl ui "$UDID" appearance "$appearance"
  mkdir -p "$OUT/$appearance"
  n=1
  for scene in "${SCENES[@]}"; do
    xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
    echo "$scene" > "$TMP_DIR/tiksi_scene"
    xcrun simctl launch "$UDID" "$BUNDLE_ID" >/dev/null
    sleep "$DELAY"
    file="$OUT/$appearance/$(printf %02d "$n")-$scene.png"
    xcrun simctl io "$UDID" screenshot --type=png --mask=alpha "$file" >/dev/null 2>&1
    echo "$file"
    n=$((n + 1))
  done
done

xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
rm -f "$TMP_DIR/tiksi_scene"
xcrun simctl ui "$UDID" appearance light
