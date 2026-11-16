#!/bin/bash

folders=(
  "activities"
  "audio-video"
  "business-payments"
  "common-actions"
  "communication"
  "devices"
  "hardware"
  "household"
  "maps"
  "photo-camera"
  "privacy-security"
  "shapes-symbols"
  "social"
  "text-formatting"
  "time-date"
  "transportation"
  "travel"
  "ui-actions"
)

for dir in "${folders[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "skip: folder $dir tidak ditemukan"
    continue
  fi

  echo "=== memproses $dir ==="

  if ! git add "$dir"; then
    echo "error: gagal git add pada $dir"
    exit 1
  fi

  if git diff --cached --quiet; then
    echo "skip: tidak ada perubahan di $dir"
    continue
  fi

  if ! git commit -m "add $dir icons"; then
    echo "error: gagal git commit pada $dir"
    git reset "$dir" >/dev/null 2>&1
    exit 1
  fi

  if ! git push; then
    echo "error: gagal git push pada $dir"
    exit 1
  fi

  echo "sukses: $dir selesai di-push"
done

echo "=== memproses file root ==="

if ! git add .; then
  echo "error: gagal git add pada file root"
  exit 1
fi

if ! git diff --cached --quiet; then
  if ! git commit -m "chore: update root files"; then
    echo "error: gagal git commit pada file root"
    git reset >/dev/null 2>&1
    exit 1
  fi

  if ! git push; then
    echo "error: gagal git push pada file root"
    exit 1
  fi
  echo "sukses: file root selesai di-push"
else
  echo "skip: tidak ada perubahan di file root"
fi

echo "semua selesai"

