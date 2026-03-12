class_name ThemesPage
extends RefCounted

# ── Theme Palettes ─────────────────────────────────
const THEMES := [
	{
		"name": "Indigo",
		"primary": Color("#6C63FF"), "accent": Color("#9B93FF"),
		"surface": Color("#141720"), "surface2": Color("#1C1F2E"),
		"border": Color("#2A2D3E"), "text": Color("#E8E9F3"), "muted": Color("#555A72"),
	},
	{
		"name": "Ocean",
		"primary": Color("#0EA5E9"), "accent": Color("#38BDF8"),
		"surface": Color("#0C1929"), "surface2": Color("#132840"),
		"border": Color("#1E3A5F"), "text": Color("#E0F2FE"), "muted": Color("#4B7399"),
	},
	{
		"name": "Emerald",
		"primary": Color("#10B981"), "accent": Color("#34D399"),
		"surface": Color("#0D1F17"), "surface2": Color("#142E22"),
		"border": Color("#1A4034"), "text": Color("#D1FAE5"), "muted": Color("#3D7A5F"),
	},
	{
		"name": "Sunset",
		"primary": Color("#F59E0B"), "accent": Color("#F97316"),
		"surface": Color("#1F1510"), "surface2": Color("#2D1F14"),
		"border": Color("#4A3320"), "text": Color("#FEF3C7"), "muted": Color("#8B6B3D"),
	},
	{
		"name": "Rose",
		"primary": Color("#F43F5E"), "accent": Color("#FB7185"),
		"surface": Color("#1F1018"), "surface2": Color("#2E1826"),
		"border": Color("#4A2038"), "text": Color("#FFE4E6"), "muted": Color("#8B4060"),
	},
]


func build(parent: Control) -> void:
	UI.page_header(parent, "Color Themes",
		"Five distinct color palettes — each rendering the same components. "
		+ "Switch your UITheme constants to adopt any palette project-wide.")

	for theme in THEMES:
		_theme_card(parent, theme)


func _theme_card(parent: Control, t: Dictionary) -> void:
	var primary: Color  = t["primary"]
	var accent: Color   = t["accent"]
	var surface: Color  = t["surface"]
	var surface2: Color = t["surface2"]
	var border: Color   = t["border"]
	var text_c: Color   = t["text"]
	var muted: Color    = t["muted"]
	var neutral: Color  = surface2.lightened(0.3)

	# Outer card with theme background
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ps := UI.style(surface, UITheme.RADIUS_LG, 1, border, 6, Color(0,0,0,0.2), Vector2(0,3))
	panel.add_theme_stylebox_override("panel", ps)
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",   24)
	margin.add_theme_constant_override("margin_right",  24)
	margin.add_theme_constant_override("margin_top",    20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	margin.add_child(col)

	# ── Header: dot + name ──
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	col.add_child(header)
	var dot := PanelContainer.new()
	dot.custom_minimum_size = Vector2(12, 12)
	dot.add_theme_stylebox_override("panel", UI.style(primary, UITheme.RADIUS_PILL))
	header.add_child(dot)
	header.add_child(UI.label(t["name"] + " Theme", UITheme.FONT_LG, text_c))
	UI.h_expand(header)
	# hex label
	header.add_child(UI.label(primary.to_html(false).to_upper(), UITheme.FONT_SM, muted))

	# ── Solid buttons ──
	var r1 := HBoxContainer.new()
	r1.add_theme_constant_override("separation", 10)
	col.add_child(r1)
	_btn(r1, "Primary", primary, Color.WHITE, surface2)
	_btn(r1, "Accent",  accent,  Color.WHITE, surface2)
	_btn(r1, "Neutral", neutral, text_c, surface2)
	UI.h_expand(r1)

	# ── Outline buttons ──
	var r2 := HBoxContainer.new()
	r2.add_theme_constant_override("separation", 10)
	col.add_child(r2)
	_outline(r2, "Primary", primary, surface2)
	_outline(r2, "Accent",  accent,  surface2)
	_outline(r2, "Neutral", border,  surface2)
	UI.h_expand(r2)

	# ── Input ──
	var input := LineEdit.new()
	input.placeholder_text = "Search or type here..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var in_n := UI.style(surface2, UITheme.RADIUS_MD, 1, border, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var in_f := UI.style(surface2, UITheme.RADIUS_MD, 2, primary, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	input.add_theme_stylebox_override("normal", in_n)
	input.add_theme_stylebox_override("focus",  in_f)
	input.add_theme_color_override("font_color", text_c)
	input.add_theme_color_override("font_placeholder_color", muted)
	input.add_theme_color_override("caret_color", primary)
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(input)

	# ── Badges ──
	var r3 := HBoxContainer.new()
	r3.add_theme_constant_override("separation", 8)
	col.add_child(r3)
	_badge_filled(r3, "Active",  primary)
	_badge_filled(r3, "Accent",  accent)
	_badge_outline(r3, "Outline", primary)
	_badge_soft(r3, "Soft",    primary)
	_badge_soft(r3, "Neutral", neutral)
	UI.h_expand(r3)

	# ── Progress ──
	var prog_h := HBoxContainer.new()
	prog_h.add_theme_constant_override("separation", 10)
	prog_h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(prog_h)

	var bar := Control.new()
	bar.custom_minimum_size.y = 8
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prog_h.add_child(bar)

	var track := PanelContainer.new()
	track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	track.add_theme_stylebox_override("panel", UI.style(surface2, UITheme.RADIUS_SM))
	bar.add_child(track)

	var fill := PanelContainer.new()
	fill.anchor_right = 0.65; fill.anchor_bottom = 1.0
	fill.add_theme_stylebox_override("panel", UI.style(primary, UITheme.RADIUS_SM))
	bar.add_child(fill)

	prog_h.add_child(UI.label("65%", UITheme.FONT_SM, muted))


# ── Mini factories (theme-local colors) ──────────────
func _btn(parent: Control, text: String, bg: Color, fg: Color, _surface: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(bg, UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 4, Color(0,0,0,0.2), Vector2(0,2), 18, 9)
	var h := UI.style(bg.lightened(0.15), UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 6, Color(0,0,0,0.25), Vector2(0,3), 18, 9)
	var p := UI.style(bg.darkened(0.15), UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_color_override("font_hover_color", fg)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)

func _outline(parent: Control, text: String, color: Color, _surface: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(0,0,0,0), UITheme.RADIUS_MD, 1, color, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(color.r,color.g,color.b,0.12), UITheme.RADIUS_MD, 1, color.lightened(0.2), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color.lightened(0.15))
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)

func _badge_filled(parent: Control, text: String, color: Color) -> void:
	UI.badge(parent, text, color, Color.WHITE, UITheme.RADIUS_XS, 10, 4, UITheme.FONT_XS)

func _badge_outline(parent: Control, text: String, color: Color) -> void:
	UI.outline_badge(parent, text, color, UITheme.RADIUS_XS, 10, 4, UITheme.FONT_XS)

func _badge_soft(parent: Control, text: String, color: Color) -> void:
	UI.soft_badge(parent, text, color, UITheme.RADIUS_XS, 10, 4, UITheme.FONT_XS)
