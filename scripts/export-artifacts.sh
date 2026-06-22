#!/bin/sh
set -eu

mkdir -p /output
found=0

for package in \
	$(find /sdk/bin/packages /sdk/bin/targets -type f \
		\( -name 'cup_off_coffee_*.ipk' -o -name 'cup_off_coffee-*.apk' \
		-o -name 'luci-app-cup-off-coffee_*.ipk' -o -name 'luci-app-cup-off-coffee-*.apk' \) \
		2>/dev/null); do
	cp "$package" /output/
	echo "exported: $(basename "$package")"
	found=1
done

if [ "$found" -ne 1 ]; then
	echo "no cup_off_coffee artifacts found" >&2
	exit 1
fi
