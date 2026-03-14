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
	UITheme.BG       = Color("#0B0C10")
	UITheme.SURFACE_1 = Color("#12141C")
	UITheme.SURFACE_2 = Color("#1A1D27")
	UITheme.SURFACE_3 = Color("#232735")
	UITheme.SURFACE_4 = Color("#2C3144")

	UITheme.BORDER        = Color("#1E2235")
	UITheme.BORDER_LIGHT  = Color("#2A2F45")
	UITheme.BORDER_STRONG = Color("#3F4660")

	UITheme.TEXT_PRIMARY   = Color("#F8FAFC")
	UITheme.TEXT_SECONDARY = Color("#94A3B8")
	UITheme.TEXT_MUTED     = Color("#64748B")
	UITheme.TEXT_INVERSE   = Color("#050914")

	UITheme.PRIMARY_SOFT    = Color(0.486, 0.412, 1.0, 0.12)
	UITheme.SECONDARY_SOFT  = Color(0.22, 0.741, 0.973, 0.12)
	UITheme.SUCCESS_SOFT    = Color(0.176, 0.831, 0.749, 0.12)
	UITheme.WARNING_SOFT    = Color(0.96, 0.62, 0.04, 0.12)
	UITheme.DANGER_SOFT     = Color(0.957, 0.247, 0.369, 0.12)
	UITheme.INFO_SOFT       = Color(0.05, 0.65, 0.91, 0.12)


# ── Light ────────────────────────────────────────────────────────────────────

static func apply_light() -> void:
	UITheme.BG       = Color("#F8FAFC")
	UITheme.SURFACE_1 = Color("#FFFFFF")
	UITheme.SURFACE_2 = Color("#F1F5F9")
	UITheme.SURFACE_3 = Color("#E2E8F0")
	UITheme.SURFACE_4 = Color("#CBD5E1")

	UITheme.BORDER        = Color("#E2E8F0")
	UITheme.BORDER_LIGHT  = Color("#F1F5F9")
	UITheme.BORDER_STRONG = Color("#CBD5E1")

	UITheme.TEXT_PRIMARY   = Color("#0F172A")
	UITheme.TEXT_SECONDARY = Color("#475569")
	UITheme.TEXT_MUTED     = Color("#94A3B8")
	UITheme.TEXT_INVERSE   = Color("#FFFFFF")

	UITheme.PRIMARY_SOFT    = Color(0.486, 0.412, 1.0, 0.08)
	UITheme.SECONDARY_SOFT  = Color(0.22, 0.741, 0.973, 0.08)
	UITheme.SUCCESS_SOFT    = Color(0.176, 0.831, 0.749, 0.08)
	UITheme.WARNING_SOFT    = Color(0.96, 0.62, 0.04, 0.08)
	UITheme.DANGER_SOFT     = Color(0.957, 0.247, 0.369, 0.08)
	UITheme.INFO_SOFT       = Color(0.05, 0.65, 0.91, 0.08)


# ── Midnight ─────────────────────────────────────────────────────────────────

static func apply_midnight() -> void:
	UITheme.BG       = Color("#020617")
	UITheme.SURFACE_1 = Color("#0F172A")
	UITheme.SURFACE_2 = Color("#1E293B")
	UITheme.SURFACE_3 = Color("#334155")
	UITheme.SURFACE_4 = Color("#475569")

	UITheme.BORDER        = Color("#1E293B")
	UITheme.BORDER_LIGHT  = Color("#334155")
	UITheme.BORDER_STRONG = Color("#475569")

	UITheme.TEXT_PRIMARY   = Color("#F1F5F9")
	UITheme.TEXT_SECONDARY = Color("#94A3B8")
	UITheme.TEXT_MUTED     = Color("#64748B")
	UITheme.TEXT_INVERSE   = Color("#020617")

	UITheme.PRIMARY_SOFT    = Color(0.486, 0.412, 1.0, 0.15)
	UITheme.SECONDARY_SOFT  = Color(0.22, 0.741, 0.973, 0.15)
	UITheme.SUCCESS_SOFT    = Color(0.176, 0.831, 0.749, 0.15)
	UITheme.WARNING_SOFT    = Color(0.96, 0.62, 0.04, 0.15)
	UITheme.DANGER_SOFT     = Color(0.957, 0.247, 0.369, 0.15)
	UITheme.INFO_SOFT       = Color(0.05, 0.65, 0.91, 0.15)


# ── Slate (Professional Blue-Gray) ───────────────────────────────────────────

static func apply_slate() -> void:
	UITheme.BG       = Color("#0F172A")
	UITheme.SURFACE_1 = Color("#1E293B")
	UITheme.SURFACE_2 = Color("#334155")
	UITheme.SURFACE_3 = Color("#475569")
	UITheme.SURFACE_4 = Color("#64748B")

	UITheme.BORDER        = Color("#1E293B")
	UITheme.BORDER_LIGHT  = Color("#334155")
	UITheme.BORDER_STRONG = Color("#475569")

	UITheme.PRIMARY       = Color("#38BDF8")
	UITheme.PRIMARY_DARK  = Color("#0EA5E9")
	UITheme.PRIMARY_LIGHT = Color("#7DD3FC")
	UITheme.SECONDARY     = Color("#6366F1")

	UITheme.TEXT_PRIMARY   = Color("#F1F5F9")
	UITheme.TEXT_SECONDARY = Color("#94A3B8")
	UITheme.TEXT_MUTED     = Color("#475569")
	UITheme.TEXT_INVERSE   = Color("#0F172A")

	UITheme.PRIMARY_SOFT    = Color(0.22, 0.74, 0.97, 0.1)
	UITheme.SECONDARY_SOFT  = Color(0.39, 0.4, 0.95, 0.1)


# ── Stone (Modern Neutral Gray) ────────────────────────────────────────────

static func apply_stone() -> void:
	UITheme.BG       = Color("#0C0A09")
	UITheme.SURFACE_1 = Color("#1C1917")
	UITheme.SURFACE_2 = Color("#292524")
	UITheme.SURFACE_3 = Color("#44403C")
	UITheme.SURFACE_4 = Color("#57534E")

	UITheme.BORDER        = Color("#1C1917")
	UITheme.BORDER_LIGHT  = Color("#292524")
	UITheme.BORDER_STRONG = Color("#44403C")

	UITheme.PRIMARY       = Color("#A8A29E")
	UITheme.PRIMARY_DARK  = Color("#78716C")
	UITheme.PRIMARY_LIGHT = Color("#D6D3D1")
	UITheme.SECONDARY     = Color("#D97706")

	UITheme.TEXT_PRIMARY   = Color("#FAFAF9")
	UITheme.TEXT_SECONDARY = Color("#A8A29E")
	UITheme.TEXT_MUTED     = Color("#57534E")
	UITheme.TEXT_INVERSE   = Color("#0C0A09")

	UITheme.PRIMARY_SOFT    = Color(0.66, 0.64, 0.62, 0.1)
	UITheme.SECONDARY_SOFT  = Color(0.85, 0.47, 0.02, 0.1)



