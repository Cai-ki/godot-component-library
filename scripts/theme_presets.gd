## UIThemePresets — Theme switching helper
## Changes UITheme surface/text/border colors to apply different visual modes.
## Brand colors (PRIMARY/SUCCESS/DANGER etc.) remain unchanged.
##
## Usage:
##   UIThemePresets.apply_dark_indigo()   # default
##   UIThemePresets.apply_light()
##   UIThemePresets.apply_midnight()
class_name UIThemePresets
extends RefCounted


# ── Dark Indigo (default) ────────────────────────────────────────────────────

static func apply_dark_indigo() -> void:
	UITheme.BG       = Color("#0D0F14")
	UITheme.SURFACE_1 = Color("#141720")
	UITheme.SURFACE_2 = Color("#1C1F2E")
	UITheme.SURFACE_3 = Color("#252A3A")
	UITheme.SURFACE_4 = Color("#2E3347")

	UITheme.BORDER        = Color("#2A2D3E")
	UITheme.BORDER_LIGHT  = Color("#353849")
	UITheme.BORDER_STRONG = Color("#4A4D60")

	UITheme.TEXT_PRIMARY   = Color("#E8E9F3")
	UITheme.TEXT_SECONDARY = Color("#8B90A7")
	UITheme.TEXT_MUTED     = Color("#555A72")
	UITheme.TEXT_INVERSE   = Color("#0D0F14")

	UITheme.PRIMARY_SOFT    = Color(0.424, 0.388, 1.0, 0.12)
	UITheme.SECONDARY_SOFT  = Color(0.31, 0.765, 0.97, 0.12)
	UITheme.SUCCESS_SOFT    = Color(0.29, 0.87, 0.5, 0.12)
	UITheme.WARNING_SOFT    = Color(0.98, 0.57, 0.24, 0.12)
	UITheme.DANGER_SOFT     = Color(0.97, 0.44, 0.44, 0.12)
	UITheme.INFO_SOFT       = Color(0.38, 0.65, 0.98, 0.12)


# ── Light ────────────────────────────────────────────────────────────────────

static func apply_light() -> void:
	UITheme.BG       = Color("#F0F2F8")
	UITheme.SURFACE_1 = Color("#F8F9FC")
	UITheme.SURFACE_2 = Color("#FFFFFF")
	UITheme.SURFACE_3 = Color("#EEF0F7")
	UITheme.SURFACE_4 = Color("#E2E5F0")

	UITheme.BORDER        = Color("#D4D7E8")
	UITheme.BORDER_LIGHT  = Color("#C0C5DE")
	UITheme.BORDER_STRONG = Color("#A8AECB")

	UITheme.TEXT_PRIMARY   = Color("#1A1C2E")
	UITheme.TEXT_SECONDARY = Color("#4A4F6A")
	UITheme.TEXT_MUTED     = Color("#8A90AA")
	UITheme.TEXT_INVERSE   = Color("#FFFFFF")

	UITheme.PRIMARY_SOFT    = Color(0.424, 0.388, 1.0, 0.10)
	UITheme.SECONDARY_SOFT  = Color(0.31, 0.765, 0.97, 0.10)
	UITheme.SUCCESS_SOFT    = Color(0.29, 0.87, 0.5, 0.10)
	UITheme.WARNING_SOFT    = Color(0.98, 0.57, 0.24, 0.10)
	UITheme.DANGER_SOFT     = Color(0.97, 0.44, 0.44, 0.10)
	UITheme.INFO_SOFT       = Color(0.38, 0.65, 0.98, 0.10)


# ── Midnight ─────────────────────────────────────────────────────────────────

static func apply_midnight() -> void:
	UITheme.BG       = Color("#070A12")
	UITheme.SURFACE_1 = Color("#0C1020")
	UITheme.SURFACE_2 = Color("#111828")
	UITheme.SURFACE_3 = Color("#182035")
	UITheme.SURFACE_4 = Color("#1F2840")

	UITheme.BORDER        = Color("#1C2540")
	UITheme.BORDER_LIGHT  = Color("#253054")
	UITheme.BORDER_STRONG = Color("#2E3D66")

	UITheme.TEXT_PRIMARY   = Color("#D0D8F0")
	UITheme.TEXT_SECONDARY = Color("#6B7A9E")
	UITheme.TEXT_MUTED     = Color("#3D4A6B")
	UITheme.TEXT_INVERSE   = Color("#070A12")

	UITheme.PRIMARY_SOFT    = Color(0.424, 0.388, 1.0, 0.15)
	UITheme.SECONDARY_SOFT  = Color(0.31, 0.765, 0.97, 0.15)
	UITheme.SUCCESS_SOFT    = Color(0.29, 0.87, 0.5, 0.15)
	UITheme.WARNING_SOFT    = Color(0.98, 0.57, 0.24, 0.15)
	UITheme.DANGER_SOFT     = Color(0.97, 0.44, 0.44, 0.15)
	UITheme.INFO_SOFT       = Color(0.38, 0.65, 0.98, 0.15)
