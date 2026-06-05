#!/usr/bin/env bash
# Ranger preview script for CSV, XLSX/XLS/ODS and Markdown
# Usage: ranger preview script

file="$1"
# Determine file extension
ext="${file##*.}"
case "$ext" in
  csv|tsv)
    # Use xlsx2csv to convert to csv if needed, then bat
    if command -v xlsx2csv >/dev/null 2>&1; then
      xlsx2csv "$file" | bat --style=numbers --color=always --plain
    else
      bat --style=numbers --color=always --plain "$file"
    fi
    ;;
  xlsx|xls|ods)
    if command -v xlsx2csv >/dev/null 2>&1; then
      xlsx2csv "$file"
    else
      echo "xlsx2csv not installed"
    fi
    ;;
  md|markdown)
    if command -v glow >/dev/null 2>&1; then
      glow "$file"
    else
      bat --style=numbers --color=always --plain "$file"
    fi
    ;;
  *)
    # Default preview: cat
    cat "$file"
    ;;
esac
