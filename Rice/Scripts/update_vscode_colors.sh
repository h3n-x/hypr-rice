#!/usr/bin/env bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ Requiere 'jq' (sudo pacman -S jq)"
  exit 1
fi

PYWAL_SASS="${HOME}/.cache/wal/colors.scss"
PYWAL_SH="${HOME}/.cache/wal/colors.sh"

# ---------- helpers ----------
die() {
  echo "❌ $*" >&2
  exit 1
}

clamp() {
  local v="$1"
  ((v < 0)) && v=0
  ((v > 255)) && v=255
  echo "$v"
}

lighten_hex() {
  local h="${1#\#}" a="${2:-20}"
  local r=$((16#${h:0:2} + a))
  r=$(clamp "$r")
  local g=$((16#${h:2:2} + a))
  g=$(clamp "$g")
  local b=$((16#${h:4:2} + a))
  b=$(clamp "$b")
  printf "#%02x%02x%02x" "$r" "$g" "$b"
}

darken_hex() {
  local h="${1#\#}" a="${2:-20}"
  local r=$((16#${h:0:2} - a))
  r=$(clamp "$r")
  local g=$((16#${h:2:2} - a))
  g=$(clamp "$g")
  local b=$((16#${h:4:2} - a))
  b=$(clamp "$b")
  printf "#%02x%02x%02x" "$r" "$g" "$b"
}

with_alpha() {
  # with_alpha "#RRGGBB" alpha (0..1 flotante o 0..255 entero)
  local h="${1#\#}" a="${2:-0.8}"
  if [[ "$a" == *.* ]]; then
    a=$(
      python - "$a" <<'PY'
import sys
f=max(0.0,min(1.0,float(sys.argv[1])))
print("%02x"%int(f*255))
PY
    )
  else
    a=$(printf "%02x" "$(clamp "$a")")
  fi
  echo "#${h}${a}"
}

have() { command -v "$1" >/dev/null 2>&1; }

# ---------- carga pywal ----------
declare background foreground cursor
declare color0 color1 color2 color3 color4 color5 color6 color7
declare color8 color9 color10 color11 color12 color13 color14 color15
declare wallpaper=""

load_from_scss() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  echo "🔎 Leyendo paleta desde: $f"
  local get_hex
  get_hex() { grep -E "^\s*\$$1:\s*#([0-9a-fA-F]{6})" "$f" | head -1 | sed -E 's/.*#/#/;s/;//'; }
  background="$(get_hex background)"
  foreground="$(get_hex foreground)"
  cursor="$(get_hex cursor)"
  for i in {0..15}; do
    eval "color$i=\"$(get_hex color$i || true)\""
  done
  # wallpaper (opcional)
  wallpaper=$(grep -E '^\s*\$wallpaper:\s*"' "$f" | sed -E 's/.*"([^"]+)".*/\1/' || true)
  [[ -n "${background}" && -n "${foreground}" && -n "${color0}" && -n "${color15}" ]]
}

load_from_sh() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  echo "🔎 Leyendo paleta desde: $f"
  # shellcheck disable=SC1090
  source "$f"
  # variables ya definidas por pywal
  true
}

choose_palette_source() {
  if [[ -f "$PYWAL_SASS" && -f "$PYWAL_SH" ]]; then
    local ts_scss ts_sh
    ts_scss=$(stat -c %Y "$PYWAL_SASS" 2>/dev/null || echo 0)
    ts_sh=$(stat -c %Y "$PYWAL_SH" 2>/dev/null || echo 0)
    if ((ts_scss >= ts_sh)); then
      load_from_scss "$PYWAL_SASS" || load_from_sh "$PYWAL_SH" || die "No pude cargar paleta de pywal"
    else
      load_from_sh "$PYWAL_SH" || load_from_scss "$PYWAL_SASS" || die "No pude cargar paleta de pywal"
    fi
  elif [[ -f "$PYWAL_SASS" ]]; then
    load_from_scss "$PYWAL_SASS" || die "No pude cargar paleta de $PYWAL_SASS"
  elif [[ -f "$PYWAL_SH" ]]; then
    load_from_sh "$PYWAL_SH" || die "No pude cargar paleta de $PYWAL_SH"
  else
    die "No se encontró ni $PYWAL_SASS ni $PYWAL_SH. Ejecuta: wal -i /ruta/a/wallpaper"
  fi

  # validación mínima
  : "${background:?}" "${foreground:?}" "${cursor:?}" \
    "${color0:?}" "${color1:?}" "${color2:?}" "${color3:?}" \
    "${color4:?}" "${color5:?}" "${color6:?}" "${color7:?}" \
    "${color8:?}" "${color9:?}" "${color10:?}" "${color11:?}" \
    "${color12:?}" "${color13:?}" "${color14:?}" "${color15:?}"
}

# ---------- paths VS Code ----------
SETTINGS="${HOME}/.config/Code/User/settings.json"
if [[ ! -f "$SETTINGS" ]]; then
  for p in \
    "${HOME}/.config/Code - OSS/User/settings.json" \
    "${HOME}/.config/VSCodium/User/settings.json"; do
    if [[ -f "$p" ]]; then
      SETTINGS="$p"
      break
    fi
  done
fi
mkdir -p "$(dirname "$SETTINGS")"
[[ -f "$SETTINGS" ]] || echo "{}" >"$SETTINGS"

CURRENT_THEME="$(jq -r '.["workbench.colorTheme"] // "Default Dark Modern"' "$SETTINGS")"

# ---------- main ----------
choose_palette_source

# Derivados y roles
BG_DARK="$(darken_hex "$background" 12)"
BG_DARKER="$(darken_hex "$background" 24)"
BG_LIGHT="$(lighten_hex "$background" 12)"
FG_DIM="$(with_alpha "$foreground" 0.75)"
ACCENT="$color4"
ACCENT_2="$color2"
ACCENT_WARN="$color3"
ACCENT_ERR="$color1"
OK="$color2"

BACKUP="${SETTINGS}.bak.$(date +%s)"
cp -f "$SETTINGS" "$BACKUP"

echo "⚙️  Editando: $SETTINGS"
echo "🗂️  Backup:  $BACKUP"
[[ -n "$wallpaper" ]] && echo "🖼️  Wallpaper: $wallpaper"
echo "🎨 Tema activo: $CURRENT_THEME"
echo "🎯 Modo: SOLO GUI (workbench.colorCustomizations)"

# ---------- JSON GUI masivo ----------
read -r -d '' STAR_JSON <<JSON || true
{
  "foreground": "${foreground}",
  "focusBorder": "${ACCENT}",
  "descriptionForeground": "${FG_DIM}",
  "selection.background": "$(with_alpha "$ACCENT" 0.35)",
  "icon.foreground": "${foreground}",

  "window.activeBorder": "${BG_DARKER}",
  "window.inactiveBorder": "${BG_DARK}",
  "sash.hoverBorder": "${ACCENT}",

  "activityBar.background": "${BG_DARKER}",
  "activityBar.border": "${BG_DARK}",
  "activityBar.foreground": "${foreground}",
  "activityBar.inactiveForeground": "$(with_alpha "$foreground" 0.5)",
  "activityBar.activeBorder": "${ACCENT}",
  "activityBar.activeBackground": "${BG_DARK}",
  "activityBar.activeFocusBorder": "${ACCENT}",
  "activityBar.dropBorder": "${ACCENT}",
  "activityBarBadge.background": "${ACCENT}",
  "activityBarBadge.foreground": "${background}",

  "sideBar.background": "${BG_DARK}",
  "sideBar.border": "${BG_DARKER}",
  "sideBar.foreground": "${foreground}",
  "sideBarTitle.foreground": "${foreground}",
  "sideBar.dropBackground": "$(with_alpha "$ACCENT" 0.18)",
  "sideBarSectionHeader.background": "${BG_DARKER}",
  "sideBarSectionHeader.foreground": "${foreground}",
  "sideBarSectionHeader.border": "${BG_DARKER}",

  "list.activeSelectionBackground": "$(with_alpha "$ACCENT" 0.22)",
  "list.activeSelectionForeground": "${foreground}",
  "list.inactiveSelectionBackground": "$(with_alpha "$ACCENT" 0.14)",
  "list.inactiveSelectionForeground": "${foreground}",
  "list.focusBackground": "$(with_alpha "$ACCENT" 0.18)",
  "list.focusForeground": "${foreground}",
  "list.hoverBackground": "$(with_alpha "$foreground" 0.06)",
  "list.hoverForeground": "${foreground}",
  "list.dropBackground": "$(with_alpha "$ACCENT" 0.2)",
  "list.filterMatchBackground": "$(with_alpha "$ACCENT" 0.22)",
  "list.filterMatchBorder": "${ACCENT}",
  "list.deemphasizedForeground": "$(with_alpha "$foreground" 0.55)",
  "list.errorForeground": "${ACCENT_ERR}",
  "list.warningForeground": "${ACCENT_WARN}",

  "tree.indentGuidesStroke": "$(with_alpha "$(lighten_hex "$background" 42)" 0.4)",
  "tree.tableColumnsBorder": "${BG_DARKER}",

  "editor.background": "${background}",
  "editor.foreground": "${foreground}",
  "editorLineNumber.foreground": "$(with_alpha "$foreground" 0.45)",
  "editorLineNumber.activeForeground": "${foreground}",
  "editorCursor.background": "${background}",
  "editorCursor.foreground": "${cursor}",
  "editor.selectionBackground": "$(with_alpha "$ACCENT" 0.35)",
  "editor.inactiveSelectionBackground": "$(with_alpha "$ACCENT" 0.2)",
  "editor.selectionHighlightBackground": "$(with_alpha "$ACCENT_2" 0.25)",
  "editor.selectionHighlightBorder": "${ACCENT_2}",
  "editor.wordHighlightBackground": "$(with_alpha "$color12" 0.2)",
  "editor.wordHighlightBorder": "$(with_alpha "$color12" 0.5)",
  "editor.wordHighlightStrongBackground": "$(with_alpha "$color14" 0.25)",
  "editor.wordHighlightStrongBorder": "$(with_alpha "$color14" 0.6)",
  "editor.findMatchBackground": "$(with_alpha "$ACCENT_WARN" 0.35)",
  "editor.findMatchHighlightBackground": "$(with_alpha "$ACCENT_WARN" 0.22)",
  "editor.findRangeHighlightBackground": "$(with_alpha "$color8" 0.25)",
  "searchEditor.findMatchBackground": "$(with_alpha "$ACCENT_WARN" 0.35)",
  "searchEditor.findMatchBorder": "${ACCENT_WARN}",
  "searchEditor.textInputBorder": "${BG_DARKER}",
  "editor.hoverHighlightBackground": "$(with_alpha "$ACCENT" 0.15)",
  "editor.lineHighlightBackground": "$(with_alpha "$foreground" 0.06)",
  "editor.lineHighlightBorder": "$(with_alpha "$foreground" 0.08)",
  "editorLink.activeForeground": "${ACCENT}",
  "editor.rangeHighlightBackground": "$(with_alpha "$color8" 0.25)",
  "editor.rangeHighlightBorder": "$(with_alpha "$foreground" 0.08)",
  "editor.symbolHighlightBackground": "$(with_alpha "$ACCENT_2" 0.2)",
  "editor.symbolHighlightBorder": "${ACCENT_2}",
  "editorWhitespace.foreground": "$(with_alpha "$(lighten_hex "$background" 40)" 0.4)",
  "editorIndentGuide.background": "$(with_alpha "$(lighten_hex "$background" 36)" 0.35)",
  "editorIndentGuide.activeBackground": "$(with_alpha "$(lighten_hex "$background" 56)" 0.7)",
  "editorRuler.foreground": "$(with_alpha "$(lighten_hex "$background" 42)" 0.45)",
  "editor.linkedEditingBackground": "$(with_alpha "$ACCENT_2" 0.2)",
  "editorCodeLens.foreground": "$(with_alpha "$foreground" 0.6)",
  "editorBracketMatch.background": "$(with_alpha "$color6" 0.15)",
  "editorBracketMatch.border": "$(with_alpha "$color6" 0.6)",
  "editor.foldBackground": "$(with_alpha "$foreground" 0.05)",

  "editorBracketHighlight.foreground1": "${color6}",
  "editorBracketHighlight.foreground2": "${color4}",
  "editorBracketHighlight.foreground3": "${color2}",
  "editorBracketHighlight.foreground4": "${color5}",
  "editorBracketHighlight.foreground5": "${color3}",
  "editorBracketHighlight.foreground6": "${color14}",
  "editorBracketHighlight.unexpectedBracket.foreground": "${ACCENT_ERR}",
  "editorBracketPairGuide.activeBackground1": "$(with_alpha "$color6" 0.5)",
  "editorBracketPairGuide.activeBackground2": "$(with_alpha "$color4" 0.5)",
  "editorBracketPairGuide.activeBackground3": "$(with_alpha "$color2" 0.5)",
  "editorBracketPairGuide.background1": "$(with_alpha "$color6" 0.25)",
  "editorBracketPairGuide.background2": "$(with_alpha "$color4" 0.25)",
  "editorBracketPairGuide.background3": "$(with_alpha "$color2" 0.25)",

  "editorGutter.background": "${background}",
  "editorGutter.addedBackground": "${OK}",
  "editorGutter.modifiedBackground": "${ACCENT}",
  "editorGutter.deletedBackground": "${ACCENT_ERR}",
  "editorGutter.commentRangeForeground": "$(with_alpha "$foreground" 0.55)",
  "editorGutter.foldingControlForeground": "${foreground}",

  "editorOverviewRuler.background": "${BG_DARK}",
  "editorOverviewRuler.border": "${BG_DARKER}",
  "editorOverviewRuler.findMatchForeground": "${ACCENT_WARN}",
  "editorOverviewRuler.rangeHighlightForeground": "$(with_alpha "$foreground" 0.25)",
  "editorOverviewRuler.selectionHighlightForeground": "${ACCENT}",
  "editorOverviewRuler.wordHighlightForeground": "$(with_alpha "$foreground" 0.25)",
  "editorOverviewRuler.wordHighlightStrongForeground": "${ACCENT}",
  "editorOverviewRuler.modifiedForeground": "${ACCENT}",
  "editorOverviewRuler.addedForeground": "${OK}",
  "editorOverviewRuler.deletedForeground": "${ACCENT_ERR}",
  "editorOverviewRuler.errorForeground": "${ACCENT_ERR}",
  "editorOverviewRuler.warningForeground": "${ACCENT_WARN}",
  "editorOverviewRuler.infoForeground": "${ACCENT}",

  "diffEditor.insertedTextBackground": "$(with_alpha "$OK" 0.12)",
  "diffEditor.insertedTextBorder": "${OK}",
  "diffEditor.removedTextBackground": "$(with_alpha "$ACCENT_ERR" 0.12)",
  "diffEditor.removedTextBorder": "${ACCENT_ERR}",
  "diffEditor.diagonalFill": "$(with_alpha "$foreground" 0.18)",
  "diffEditor.border": "${BG_DARKER}",
  "diffEditorGutter.insertedLineBackground": "$(with_alpha "$OK" 0.08)",
  "diffEditorGutter.removedLineBackground": "$(with_alpha "$ACCENT_ERR" 0.08)",
  "diffEditorOverview.insertedForeground": "${OK}",
  "diffEditorOverview.removedForeground": "${ACCENT_ERR}",

  "peekView.border": "${ACCENT}",
  "peekViewTitle.background": "${BG_DARKER}",
  "peekViewTitleLabel.foreground": "${foreground}",
  "peekViewEditor.background": "${BG_DARK}",
  "peekViewEditorGutter.background": "${BG_DARK}",
  "peekViewEditor.matchHighlightBackground": "$(with_alpha "$ACCENT_WARN" 0.35)",
  "peekViewEditor.matchHighlightBorder": "${ACCENT_WARN}",
  "peekViewResult.background": "${BG_DARK}",
  "peekViewResult.fileForeground": "${foreground}",
  "peekViewResult.lineForeground": "${foreground}",
  "peekViewResult.matchHighlightBackground": "$(with_alpha "$ACCENT_WARN" 0.35)",
  "peekViewResult.selectionBackground": "$(with_alpha "$ACCENT" 0.22)",
  "peekViewResult.selectionForeground": "${foreground}",
  "peekViewEditorStickyScroll.background": "${BG_DARK}",

  "editorWidget.background": "${BG_DARK}",
  "editorWidget.foreground": "${foreground}",
  "editorWidget.border": "${BG_DARKER}",
  "editorWidget.resizeBorder": "${ACCENT}",
  "editorSuggestWidget.background": "${BG_DARK}",
  "editorSuggestWidget.border": "${BG_DARKER}",
  "editorSuggestWidget.foreground": "${foreground}",
  "editorSuggestWidget.highlightForeground": "${ACCENT}",
  "editorSuggestWidget.selectedBackground": "$(with_alpha "$ACCENT" 0.22)",
  "editorSuggestWidget.selectedForeground": "${foreground}",
  "editorSuggestWidget.selectedIconForeground": "${foreground}",
  "editorSuggestWidget.focusHighlightForeground": "${ACCENT}",
  "editorSuggestWidgetStatus.foreground": "$(with_alpha "$foreground" 0.6)",
  "editorHoverWidget.background": "${BG_DARK}",
  "editorHoverWidget.border": "${BG_DARKER}",
  "editorHoverWidget.foreground": "${foreground}",
  "editorHoverWidget.highlightForeground": "${ACCENT}",
  "editorHoverWidget.statusBarBackground": "${BG_DARKER}",

  "editorGhostText.background": "$(with_alpha "$foreground" 0.05)",
  "editorGhostText.border": "$(with_alpha "$foreground" 0.2)",
  "editorGhostText.foreground": "$(with_alpha "$foreground" 0.6)",

  "editorStickyScroll.background": "${BG_DARKER}",
  "editorStickyScrollHover.background": "${BG_LIGHT}",

  "statusBar.background": "${BG_DARKER}",
  "statusBar.foreground": "${foreground}",
  "statusBar.border": "${BG_DARKER}",
  "statusBar.noFolderBackground": "${BG_DARK}",
  "statusBar.noFolderForeground": "${foreground}",
  "statusBar.noFolderBorder": "${BG_DARKER}",
  "statusBar.debuggingBackground": "${ACCENT_ERR}",
  "statusBar.debuggingForeground": "${background}",
  "statusBar.debuggingBorder": "${ACCENT_ERR}",
  "statusBarItem.hoverBackground": "$(with_alpha "$foreground" 0.08)",
  "statusBarItem.activeBackground": "$(with_alpha "$ACCENT" 0.2)",
  "statusBarItem.prominentBackground": "${ACCENT}",
  "statusBarItem.prominentForeground": "${background}",
  "statusBarItem.prominentHoverBackground": "$(lighten_hex "$ACCENT" 14)",
  "statusBarItem.remoteBackground": "${ACCENT}",
  "statusBarItem.remoteForeground": "${background}",
  "statusBarItem.errorBackground": "${ACCENT_ERR}",
  "statusBarItem.errorForeground": "${background}",
  "statusBarItem.warningBackground": "${ACCENT_WARN}",
  "statusBarItem.warningForeground": "${background}",
  "statusBarItem.compactHoverBackground": "${BG_LIGHT}",
  "statusBarItem.focusBorder": "${ACCENT}",

  "titleBar.activeBackground": "${BG_DARKER}",
  "titleBar.activeForeground": "${foreground}",
  "titleBar.inactiveBackground": "${BG_DARK}",
  "titleBar.inactiveForeground": "$(with_alpha "$foreground" 0.6)",
  "titleBar.border": "${BG_DARKER}",

  "menubar.selectionForeground": "${foreground}",
  "menubar.selectionBackground": "${BG_LIGHT}",
  "menubar.selectionBorder": "$(with_alpha "$foreground" 0.18)",
  "menu.foreground": "${foreground}",
  "menu.background": "${BG_DARK}",
  "menu.selectionForeground": "${foreground}",
  "menu.selectionBackground": "$(with_alpha "$ACCENT" 0.22)",
  "menu.selectionBorder": "${ACCENT}",
  "menu.separatorBackground": "${BG_DARKER}",
  "menu.border": "${BG_DARKER}",

  "notificationCenterHeader.background": "${BG_DARKER}",
  "notificationCenterHeader.foreground": "${foreground}",
  "notificationCenter.border": "${BG_DARKER}",
  "notificationToast.border": "${BG_DARKER}",
  "notifications.background": "${BG_DARK}",
  "notifications.foreground": "${foreground}",
  "notifications.border": "${BG_DARKER}",
  "notificationsErrorIcon.foreground": "${ACCENT_ERR}",
  "notificationsWarningIcon.foreground": "${ACCENT_WARN}",
  "notificationsInfoIcon.foreground": "${ACCENT}",

  "badge.background": "${ACCENT}",
  "badge.foreground": "${background}",
  "progressBar.background": "${ACCENT}",

  "dropdown.background": "${BG_DARK}",
  "dropdown.listBackground": "${BG_DARK}",
  "dropdown.foreground": "${foreground}",
  "dropdown.border": "${BG_DARKER}",
  "button.background": "${ACCENT}",
  "button.foreground": "${background}",
  "button.hoverBackground": "$(lighten_hex "$ACCENT" 14)",
  "button.secondaryBackground": "${BG_LIGHT}",
  "button.secondaryForeground": "${foreground}",
  "button.secondaryHoverBackground": "$(lighten_hex "$BG_LIGHT" 10)",
  "checkbox.background": "${BG_DARK}",
  "checkbox.foreground": "${foreground}",
  "checkbox.border": "${BG_DARKER}",
  "radio.activeBackground": "$(with_alpha "$ACCENT" 0.22)",
  "radio.activeBorder": "${ACCENT}",
  "radio.inactiveBorder": "${BG_DARKER}",

  "input.background": "${BG_DARK}",
  "input.foreground": "${foreground}",
  "input.border": "${BG_DARKER}",
  "input.placeholderForeground": "$(with_alpha "$foreground" 0.5)",
  "inputOption.activeBackground": "$(with_alpha "$ACCENT" 0.25)",
  "inputOption.activeBorder": "${ACCENT}",
  "inputOption.activeForeground": "${foreground}",
  "inputValidation.infoBackground": "$(with_alpha "$ACCENT" 0.25)",
  "inputValidation.infoForeground": "${foreground}",
  "inputValidation.infoBorder": "${ACCENT}",
  "inputValidation.warningBackground": "$(with_alpha "$ACCENT_WARN" 0.25)",
  "inputValidation.warningForeground": "${foreground}",
  "inputValidation.warningBorder": "${ACCENT_WARN}",
  "inputValidation.errorBackground": "$(with_alpha "$ACCENT_ERR" 0.25)",
  "inputValidation.errorForeground": "${foreground}",
  "inputValidation.errorBorder": "${ACCENT_ERR}",

  "scrollbar.shadow": "$(with_alpha "$background" 0.0)",
  "scrollbarSlider.background": "$(with_alpha "$foreground" 0.15)",
  "scrollbarSlider.hoverBackground": "$(with_alpha "$foreground" 0.25)",
  "scrollbarSlider.activeBackground": "$(with_alpha "$foreground" 0.35)",

  "minimap.background": "${BG_DARK}",
  "minimap.selectionHighlight": "$(with_alpha "$ACCENT" 0.45)",
  "minimap.findMatchHighlight": "$(with_alpha "$ACCENT_WARN" 0.5)",
  "minimap.errorHighlight": "${ACCENT_ERR}",
  "minimap.warningHighlight": "${ACCENT_WARN}",
  "minimapGutter.addedBackground": "${OK}",
  "minimapGutter.modifiedBackground": "${ACCENT}",
  "minimapGutter.deletedBackground": "${ACCENT_ERR}",
  "minimapSlider.background": "$(with_alpha "$foreground" 0.15)",
  "minimapSlider.hoverBackground": "$(with_alpha "$foreground" 0.25)",
  "minimapSlider.activeBackground": "$(with_alpha "$foreground" 0.35)",

  "breadcrumb.foreground": "$(with_alpha "$foreground" 0.6)",
  "breadcrumb.background": "${BG_DARKER}",
  "breadcrumb.focusForeground": "${foreground}",
  "breadcrumb.activeSelectionForeground": "${foreground}",
  "breadcrumbPicker.background": "${BG_DARK}",

  "panel.background": "${BG_DARK}",
  "panel.border": "${BG_DARKER}",
  "panel.dropBorder": "${ACCENT}",
  "panelTitle.activeBorder": "${ACCENT}",
  "panelTitle.activeForeground": "${foreground}",
  "panelTitle.inactiveForeground": "$(with_alpha "$foreground" 0.6)",
  "panelInput.border": "${BG_DARKER}",
  "panelSection.border": "${BG_DARKER}",
  "panelSection.dropBackground": "$(with_alpha "$ACCENT" 0.2)",
  "panelSectionHeader.background": "${BG_DARKER}",
  "panelSectionHeader.foreground": "${foreground}",
  "panelSectionHeader.border": "${BG_DARKER}",

  "problemsErrorIcon.foreground": "${ACCENT_ERR}",
  "problemsWarningIcon.foreground": "${ACCENT_WARN}",
  "problemsInfoIcon.foreground": "${ACCENT}",

  "editorError.foreground": "${ACCENT_ERR}",
  "editorError.border": "${ACCENT_ERR}",
  "editorError.background": "$(with_alpha "$ACCENT_ERR" 0.06)",
  "editorWarning.foreground": "${ACCENT_WARN}",
  "editorWarning.border": "${ACCENT_WARN}",
  "editorWarning.background": "$(with_alpha "$ACCENT_WARN" 0.06)",
  "editorInfo.foreground": "${ACCENT}",
  "editorInfo.border": "${ACCENT}",
  "editorInfo.background": "$(with_alpha "$ACCENT" 0.06)",

  "gitDecoration.addedResourceForeground": "${OK}",
  "gitDecoration.modifiedResourceForeground": "${ACCENT}",
  "gitDecoration.deletedResourceForeground": "${ACCENT_ERR}",
  "gitDecoration.renamedResourceForeground": "${color6}",
  "gitDecoration.stageModifiedResourceForeground": "${ACCENT}",
  "gitDecoration.stageDeletedResourceForeground": "${ACCENT_ERR}",
  "gitDecoration.untrackedResourceForeground": "${OK}",
  "gitDecoration.ignoredResourceForeground": "$(with_alpha "$foreground" 0.45)",
  "gitDecoration.conflictingResourceForeground": "${ACCENT_ERR}",
  "gitDecoration.submoduleResourceForeground": "${color6}",

  "quickInput.background": "${BG_DARK}",
  "quickInput.foreground": "${foreground}",
  "quickInputList.focusBackground": "$(with_alpha "$ACCENT" 0.22)",
  "quickInputList.focusForeground": "${foreground}",
  "quickInputList.focusIconForeground": "${foreground}",
  "quickInputTitle.background": "${BG_DARK}",

  "pickerGroup.border": "${BG_DARKER}",
  "pickerGroup.foreground": "${ACCENT}",

  "keybindingLabel.background": "${BG_LIGHT}",
  "keybindingLabel.foreground": "${foreground}",
  "keybindingLabel.border": "$(with_alpha "$foreground" 0.2)",
  "keybindingLabel.bottomBorder": "$(with_alpha "$foreground" 0.2)",

  "terminal.background": "${background}",
  "terminal.foreground": "${foreground}",
  "terminal.border": "${BG_DARKER}",
  "terminal.selectionBackground": "$(with_alpha "$ACCENT" 0.22)",
  "terminal.findMatchBackground": "$(with_alpha "$ACCENT_WARN" 0.35)",
  "terminal.findMatchBorder": "${ACCENT_WARN}",
  "terminal.findMatchHighlightBackground": "$(with_alpha "$ACCENT_WARN" 0.22)",
  "terminal.findMatchHighlightBorder": "$(with_alpha "$ACCENT_WARN" 0.5)",
  "terminalCursor.background": "${background}",
  "terminalCursor.foreground": "${cursor}",

  "terminal.ansiBlack": "${color0}",
  "terminal.ansiRed": "${color1}",
  "terminal.ansiGreen": "${color2}",
  "terminal.ansiYellow": "${color3}",
  "terminal.ansiBlue": "${color4}",
  "terminal.ansiMagenta": "${color5}",
  "terminal.ansiCyan": "${color6}",
  "terminal.ansiWhite": "${color7}",
  "terminal.ansiBrightBlack": "${color8}",
  "terminal.ansiBrightRed": "${color9}",
  "terminal.ansiBrightGreen": "${color10}",
  "terminal.ansiBrightYellow": "${color11}",
  "terminal.ansiBrightBlue": "${color12}",
  "terminal.ansiBrightMagenta": "${color13}",
  "terminal.ansiBrightCyan": "${color14}",
  "terminal.ansiBrightWhite": "${color15}",

  "debugToolBar.background": "${BG_DARK}",
  "debugToolBar.border": "${BG_DARKER}",
  "editor.stackFrameHighlightBackground": "$(with_alpha "$ACCENT_WARN" 0.12)",
  "editor.focusedStackFrameHighlightBackground": "$(with_alpha "$OK" 0.12)",
  "debugView.exceptionLabelForeground": "${ACCENT_ERR}",
  "debugView.exceptionLabelBackground": "$(with_alpha "$ACCENT_ERR" 0.12)",
  "debugView.stateLabelForeground": "${foreground}",
  "debugView.stateLabelBackground": "${BG_LIGHT}",
  "debugView.valueChangedHighlight": "${ACCENT}",

  "testing.iconFailed": "${ACCENT_ERR}",
  "testing.iconErrored": "${ACCENT_ERR}",
  "testing.iconPassed": "${OK}",
  "testing.runAction": "${ACCENT}",
  "testing.iconQueued": "${ACCENT_WARN}",
  "testing.iconUnset": "$(with_alpha "$foreground" 0.55)",
  "testing.iconSkipped": "${color6}",
  "testing.peekBorder": "${ACCENT}",
  "testing.peekHeaderBackground": "${BG_DARK}",

  "notebook.editorBackground": "${background}",
  "notebook.cellBorderColor": "${BG_DARKER}",
  "notebook.cellHoverBackground": "${BG_LIGHT}",
  "notebook.cellInsertionIndicator": "${ACCENT}",
  "notebook.cellStatusBarItemHoverBackground": "${BG_LIGHT}",
  "notebook.cellToolbarSeparator": "${BG_DARKER}",
  "notebook.cellEditorBackground": "${BG_DARK}",
  "notebook.focusedCellBackground": "${BG_LIGHT}",
  "notebook.focusedCellBorder": "${ACCENT}",
  "notebook.focusedEditorBorder": "${ACCENT}",
  "notebook.inactiveFocusedCellBorder": "$(with_alpha "$foreground" 0.3)",
  "notebook.inactiveSelectedCellBorder": "${BG_DARKER}",
  "notebook.outputContainerBackgroundColor": "${BG_DARK}",
  "notebook.outputContainerBorderColor": "${BG_DARKER}",
  "notebook.selectedCellBackground": "${BG_LIGHT}",
  "notebook.selectedCellBorder": "$(with_alpha "$foreground" 0.3)",
  "notebook.symbolHighlightBackground": "$(with_alpha "$ACCENT_2" 0.2)",
  "notebookScrollbarSlider.activeBackground": "$(with_alpha "$foreground" 0.35)",
  "notebookScrollbarSlider.background": "$(with_alpha "$foreground" 0.15)",
  "notebookScrollbarSlider.hoverBackground": "$(with_alpha "$foreground" 0.25)",
  "notebookStatusErrorIcon.foreground": "${ACCENT_ERR}",
  "notebookStatusRunningIcon.foreground": "${ACCENT_WARN}",
  "notebookStatusSuccessIcon.foreground": "${OK}",

  "settings.headerForeground": "${foreground}",
  "settings.modifiedItemIndicator": "${ACCENT}",
  "settings.dropdownBackground": "${BG_DARK}",
  "settings.dropdownForeground": "${foreground}",
  "settings.dropdownBorder": "${BG_DARKER}",
  "settings.dropdownListBorder": "${BG_DARKER}",
  "settings.checkboxBackground": "${BG_DARK}",
  "settings.checkboxForeground": "${foreground}",
  "settings.checkboxBorder": "${BG_DARKER}",
  "settings.rowHoverBackground": "${BG_LIGHT}",
  "settings.textInputBackground": "${BG_DARK}",
  "settings.textInputForeground": "${foreground}",
  "settings.textInputBorder": "${BG_DARKER}",
  "settings.numberInputBackground": "${BG_DARK}",
  "settings.numberInputForeground": "${foreground}",
  "settings.numberInputBorder": "${BG_DARKER}",
  "settings.focusedRowBackground": "${BG_LIGHT}",
  "settings.focusedRowBorder": "${ACCENT}",
  "settings.headerBorder": "${BG_DARKER}",
  "settings.sashBorder": "${BG_DARKER}",
  "settings.settingsHeaderHoverForeground": "${foreground}",

  "welcomePage.background": "${BG_DARKER}",
  "welcomePage.progress.background": "${BG_DARK}",
  "welcomePage.progress.foreground": "${ACCENT}",
  "welcomePage.tileBackground": "${BG_DARK}",
  "welcomePage.tileHoverBackground": "${BG_LIGHT}",
  "welcomePage.tileBorder": "${BG_DARKER}",

  "walkThrough.embeddedEditorBackground": "${BG_DARK}",

  "charts.foreground": "${foreground}",
  "charts.lines": "${foreground}",
  "charts.red": "${ACCENT_ERR}",
  "charts.blue": "${ACCENT}",
  "charts.yellow": "${ACCENT_WARN}",
  "charts.orange": "${ACCENT_ERR}",
  "charts.green": "${OK}",
  "charts.purple": "${color5}",

  "ports.iconRunningProcessForeground": "${OK}",
  "commentsView.resolvedIcon": "${OK}",
  "commentsView.unresolvedIcon": "${ACCENT_WARN}",

  "inlineChat.background": "${BG_DARK}",
  "inlineChat.border": "${BG_DARKER}",
  "inlineChat.foreground": "${foreground}",
  "inlineChatInput.background": "${BG_DARK}",
  "inlineChatInput.border": "${BG_DARKER}",

  "commandCenter.border": "${BG_DARKER}",
  "commandCenter.background": "${BG_DARK}",
  "commandCenter.foreground": "${foreground}",
  "toolbar.hoverBackground": "${BG_LIGHT}",
  "toolbar.activeBackground": "$(with_alpha "$ACCENT" 0.2)"
}
JSON

# ---------- merge con jq (SOLO GUI) ----------
TMP="$(mktemp)"
jq \
  --arg theme "$CURRENT_THEME" \
  --argjson star "$STAR_JSON" \
  '
  . as $root
  | .["workbench.colorCustomizations"] = (
      ($root["workbench.colorCustomizations"] // {}) as $wcc
      | $wcc
      + { "[*]": (($wcc["[*]"] // {}) + $star) }
      + { ("[" + $theme + "]"): ((($wcc["["+$theme+"]"] // {})) + $star) }
    )
  ' "$SETTINGS" >"$TMP"

mv "$TMP" "$SETTINGS"

echo "✅ settings.json actualizado (GUI):"
echo "   • workbench.colorCustomizations[*] (+ $CURRENT_THEME)"
echo "   • Terminal ANSI y cursores incluidos en GUI"
echo "🗨️  Sugerencia: en VS Code ejecuta 'Developer: Reload Window' para ver cambios."

# ---------- recarga opcional ----------
if [[ "${1:-}" == "--reload" ]]; then
  echo "🔄 Intentando recargar ventana de VS Code..."
  if have code; then
    code --reuse-window --command workbench.action.reloadWindow >/dev/null 2>&1 || true
  elif have code-oss; then
    code-oss --reuse-window --command workbench.action.reloadWindow >/dev/null 2>&1 || true
  elif have vscodium; then
    vscodium --reuse-window --command workbench.action.reloadWindow >/dev/null 2>&1 || true
  else
    echo "ℹ️ No se encontró CLI de VS Code; recarga manualmente la ventana."
  fi
fi
