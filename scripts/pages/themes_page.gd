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

	# ═══════════════════════════════════════════════
	# MATERIAL STYLES
	# ═══════════════════════════════════════════════
	UI.spacer(parent, UITheme.SP_8)
	UI.page_header(parent, "Material Styles",
		"Beyond color — different surface treatments, shadows, and visual textures. "
		+ "Each style uses the same components with distinct material properties.")

	_glassmorphism(parent)
	_neumorphism(parent)
	_neon_glow(parent)
	_paper_light(parent)
	_frosted_matte(parent)


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


# ═══════════════════════════════════════════════════════
# MATERIAL: Glassmorphism (毛玻璃)
# ═══════════════════════════════════════════════════════
func _glassmorphism(parent: Control) -> void:
	UI.section(parent, "Glassmorphism  (毛玻璃)")

	# Outer frame with colorful gradient background
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.custom_minimum_size.y = 280
	frame.add_theme_stylebox_override("panel", UI.style(Color("#0F0A1A"), UITheme.RADIUS_LG, 1, UITheme.BORDER))
	parent.add_child(frame)

	# Colorful blobs behind glass (simulate gradient background)
	var bg_container := Control.new()
	bg_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_container.clip_contents = true
	frame.add_child(bg_container)

	# Colored circles as bg blobs
	var blobs := [
		[Color("#6C63FF50"), Vector2(100, 60),  120.0],
		[Color("#F43F5E40"), Vector2(350, 180), 100.0],
		[Color("#0EA5E945"), Vector2(550, 40),  90.0],
		[Color("#10B98140"), Vector2(200, 200), 80.0],
		[Color("#F59E0B35"), Vector2(700, 140), 110.0],
	]
	for blob in blobs:
		var b := PanelContainer.new()
		b.custom_minimum_size = Vector2(blob[2] * 2, blob[2] * 2)
		b.position = blob[1] - Vector2(blob[2], blob[2])
		b.add_theme_stylebox_override("panel", UI.style(blob[0], int(blob[2])))
		bg_container.add_child(b)

	# Glass cards on top
	var content := MarginContainer.new()
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.add_theme_constant_override("margin_left", 24)
	content.add_theme_constant_override("margin_right", 24)
	content.add_theme_constant_override("margin_top", 20)
	content.add_theme_constant_override("margin_bottom", 20)
	frame.add_child(content)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	content.add_child(col)

	col.add_child(UI.label("Semi-transparent surfaces over colorful backgrounds", UITheme.FONT_SM, Color(1, 1, 1, 0.7)))

	# Glass cards row
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(row)

	for i in 3:
		var titles := ["Dashboard", "Analytics", "Settings"]
		var values := ["$12.4K", "842", "98%"]
		var icons  := ["◆", "◈", "◉"]
		_glass_card(row, icons[i], titles[i], values[i])

	# Glass buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 10)
	col.add_child(btn_row)

	_glass_btn(btn_row, "Primary",   Color("#6C63FF"), 0.25)
	_glass_btn(btn_row, "Secondary", Color("#0EA5E9"), 0.2)
	_glass_btn(btn_row, "Accent",    Color("#F43F5E"), 0.2)
	_glass_outline_btn(btn_row, "Ghost", Color(1, 1, 1, 0.6))
	UI.h_expand(btn_row)

	# Glass input
	var input := LineEdit.new()
	input.placeholder_text = "Search through the glass..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var glass_in := UI.style(Color(1, 1, 1, 0.06), UITheme.RADIUS_MD, 1, Color(1, 1, 1, 0.12), 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	input.add_theme_stylebox_override("normal", glass_in)
	input.add_theme_stylebox_override("focus", UI.style(Color(1, 1, 1, 0.1), UITheme.RADIUS_MD, 1, Color("#6C63FF80"), 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10))
	input.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	input.add_theme_color_override("font_placeholder_color", Color(1, 1, 1, 0.3))
	input.add_theme_color_override("caret_color", Color("#6C63FF"))
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(input)


func _glass_card(parent: Control, icon: String, title: String, value: String) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := UI.style(Color(1, 1, 1, 0.08), UITheme.RADIUS_LG, 1, Color(1, 1, 1, 0.12), 8, Color(0, 0, 0, 0.15), Vector2(0, 4))
	panel.add_theme_stylebox_override("panel", s)

	# Hover
	var h_s := UI.style(Color(1, 1, 1, 0.12), UITheme.RADIUS_LG, 1, Color(1, 1, 1, 0.18), 12, Color(0, 0, 0, 0.2), Vector2(0, 6))
	panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", h_s))
	panel.mouse_exited.connect(func():  panel.add_theme_stylebox_override("panel", s))
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 16); m.add_theme_constant_override("margin_right", 16)
	m.add_theme_constant_override("margin_top", 14);  m.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	m.add_child(v)
	v.add_child(UI.label(icon, UITheme.FONT_LG, Color(1, 1, 1, 0.5)))
	v.add_child(UI.label(value, UITheme.FONT_2XL, Color(1, 1, 1, 0.95)))
	v.add_child(UI.label(title, UITheme.FONT_SM, Color(1, 1, 1, 0.45)))


func _glass_btn(parent: Control, text: String, tint: Color, alpha: float) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(tint.r, tint.g, tint.b, alpha), UITheme.RADIUS_MD, 1, Color(tint.r, tint.g, tint.b, alpha + 0.1), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(tint.r, tint.g, tint.b, alpha + 0.1), UITheme.RADIUS_MD, 1, Color(tint.r, tint.g, tint.b, alpha + 0.2), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _glass_outline_btn(parent: Control, text: String, color: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(0, 0, 0, 0), UITheme.RADIUS_MD, 1, Color(1, 1, 1, 0.15), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(1, 1, 1, 0.05), UITheme.RADIUS_MD, 1, Color(1, 1, 1, 0.25), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


# ═══════════════════════════════════════════════════════
# MATERIAL: Neumorphism (新拟态)
# ═══════════════════════════════════════════════════════
func _neumorphism(parent: Control) -> void:
	UI.section(parent, "Neumorphism  (新拟态)")

	var bg_color := Color("#2A2D3A")
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", UI.style(bg_color, UITheme.RADIUS_LG))
	parent.add_child(frame)

	var fm := MarginContainer.new()
	fm.add_theme_constant_override("margin_left", 24); fm.add_theme_constant_override("margin_right", 24)
	fm.add_theme_constant_override("margin_top", 20);  fm.add_theme_constant_override("margin_bottom", 20)
	frame.add_child(fm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	fm.add_child(col)

	col.add_child(UI.label("Soft shadows simulate depth — elements appear extruded from the surface", UITheme.FONT_SM, Color("#8890A5")))

	# Neumorphic cards
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(row)

	for i in 3:
		_neu_card(row, bg_color, ["Volume", "Brightness", "Contrast"][i], [75, 50, 30][i])

	# Neumorphic buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 12)
	col.add_child(btn_row)

	_neu_btn(btn_row, "Primary",   bg_color, Color("#6C63FF"))
	_neu_btn(btn_row, "Secondary", bg_color, Color("#4FC3F7"))
	_neu_btn(btn_row, "Success",   bg_color, Color("#4ADE80"))
	_neu_inset_btn(btn_row, "Inset", bg_color)
	UI.h_expand(btn_row)

	# Neumorphic input
	_neu_input(col, bg_color, "Type something...")


func _neu_style(bg: Color, raised: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left = UITheme.RADIUS_LG; s.corner_radius_top_right = UITheme.RADIUS_LG
	s.corner_radius_bottom_left = UITheme.RADIUS_LG; s.corner_radius_bottom_right = UITheme.RADIUS_LG
	if raised:
		# Dark shadow bottom-right
		s.shadow_size = 8
		s.shadow_color = Color(0, 0, 0, 0.35)
		s.shadow_offset = Vector2(4, 4)
		# Light highlight via top/left border
		s.border_width_top = 1; s.border_width_left = 1
		s.border_color = bg.lightened(0.12)
	else:
		# Inset: dark top/left, light bottom/right via border
		s.border_width_top = 2; s.border_width_left = 2
		s.border_color = bg.darkened(0.15)
		s.border_width_bottom = 1; s.border_width_right = 1
	return s


func _neu_card(parent: Control, bg: Color, title: String, value: int) -> void:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := _neu_style(bg.lightened(0.02), true)
	s.content_margin_left = 20; s.content_margin_right = 20
	s.content_margin_top = 16; s.content_margin_bottom = 16
	card.add_theme_stylebox_override("panel", s)
	parent.add_child(card)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	card.add_child(v)

	v.add_child(UI.label(title, UITheme.FONT_SM, bg.lightened(0.5)))

	# Inset track + fill
	var track := PanelContainer.new()
	track.custom_minimum_size.y = 8
	track.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ts := _neu_style(bg.darkened(0.08), false)
	ts.corner_radius_top_left = UITheme.RADIUS_SM; ts.corner_radius_top_right = UITheme.RADIUS_SM
	ts.corner_radius_bottom_left = UITheme.RADIUS_SM; ts.corner_radius_bottom_right = UITheme.RADIUS_SM
	track.add_theme_stylebox_override("panel", ts)
	v.add_child(track)

	v.add_child(UI.label(str(value) + "%", UITheme.FONT_2XL, bg.lightened(0.6)))


func _neu_btn(parent: Control, text: String, bg: Color, accent: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := _neu_style(bg.lightened(0.04), true)
	n.content_margin_left = 18; n.content_margin_right = 18
	n.content_margin_top = 9; n.content_margin_bottom = 9
	var p := _neu_style(bg.darkened(0.02), false)
	p.content_margin_left = 18; p.content_margin_right = 18
	p.content_margin_top = 9; p.content_margin_bottom = 9
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", n)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", accent)
	btn.add_theme_color_override("font_hover_color", accent.lightened(0.2))
	btn.add_theme_color_override("font_pressed_color", accent)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _neu_inset_btn(parent: Control, text: String, bg: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := _neu_style(bg.darkened(0.03), false)
	n.content_margin_left = 18; n.content_margin_right = 18
	n.content_margin_top = 9; n.content_margin_bottom = 9
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", n)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", bg.lightened(0.35))
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _neu_input(parent: Control, bg: Color, placeholder: String) -> void:
	var input := LineEdit.new()
	input.placeholder_text = placeholder
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := _neu_style(bg.darkened(0.06), false)
	s.corner_radius_top_left = UITheme.RADIUS_MD; s.corner_radius_top_right = UITheme.RADIUS_MD
	s.corner_radius_bottom_left = UITheme.RADIUS_MD; s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.content_margin_left = 12; s.content_margin_right = 12
	s.content_margin_top = 10; s.content_margin_bottom = 10
	input.add_theme_stylebox_override("normal", s)
	input.add_theme_stylebox_override("focus", s)
	input.add_theme_color_override("font_color", bg.lightened(0.55))
	input.add_theme_color_override("font_placeholder_color", bg.lightened(0.25))
	input.add_theme_color_override("caret_color", Color("#6C63FF"))
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	parent.add_child(input)


# ═══════════════════════════════════════════════════════
# MATERIAL: Neon Glow (霓虹)
# ═══════════════════════════════════════════════════════
func _neon_glow(parent: Control) -> void:
	UI.section(parent, "Neon Glow  (霓虹)")

	var bg := Color("#08080F")
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", UI.style(bg, UITheme.RADIUS_LG, 1, Color("#1A1A2E")))
	parent.add_child(frame)

	var fm := MarginContainer.new()
	fm.add_theme_constant_override("margin_left", 24); fm.add_theme_constant_override("margin_right", 24)
	fm.add_theme_constant_override("margin_top", 20);  fm.add_theme_constant_override("margin_bottom", 20)
	frame.add_child(fm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	fm.add_child(col)

	col.add_child(UI.label("Bright borders with colored glow shadows on dark backgrounds", UITheme.FONT_SM, Color("#555580")))

	# Neon cards
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(row)

	var neon_colors := [Color("#E879F9"), Color("#22D3EE"), Color("#A3E635")]
	var neon_labels := ["Fuchsia", "Cyan", "Lime"]
	var neon_values := ["2,847", "1,293", "98.5%"]
	for i in 3:
		_neon_card(row, neon_colors[i], neon_labels[i], neon_values[i], bg)

	# Neon buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 12)
	col.add_child(btn_row)

	_neon_btn(btn_row, "⚡ Fuchsia", Color("#E879F9"), bg)
	_neon_btn(btn_row, "◈ Cyan",    Color("#22D3EE"), bg)
	_neon_btn(btn_row, "✦ Lime",    Color("#A3E635"), bg)
	_neon_outline(btn_row, "Ghost",  Color("#E879F9"), bg)
	UI.h_expand(btn_row)

	# Neon input
	var input := LineEdit.new()
	input.placeholder_text = "Enter the matrix..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var in_n := UI.style(Color("#0D0D18"), UITheme.RADIUS_MD, 1, Color("#E879F930"), 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var in_f := UI.style(Color("#0D0D18"), UITheme.RADIUS_MD, 2, Color("#E879F9"), 6, Color("#E879F930"), Vector2(0, 0), 12, 10)
	input.add_theme_stylebox_override("normal", in_n)
	input.add_theme_stylebox_override("focus", in_f)
	input.add_theme_color_override("font_color", Color("#E0E0FF"))
	input.add_theme_color_override("font_placeholder_color", Color("#444466"))
	input.add_theme_color_override("caret_color", Color("#E879F9"))
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(input)

	# Neon badges
	var badge_row := HBoxContainer.new()
	badge_row.add_theme_constant_override("separation", 8)
	col.add_child(badge_row)
	for i in 3:
		_neon_badge(badge_row, neon_labels[i], neon_colors[i])
	UI.h_expand(badge_row)


func _neon_card(parent: Control, color: Color, title: String, value: String, bg: Color) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := UI.style(bg.lightened(0.03), UITheme.RADIUS_MD, 1, color.darkened(0.3), 12, Color(color.r, color.g, color.b, 0.2), Vector2(0, 0))
	panel.add_theme_stylebox_override("panel", s)

	var h_s := s.duplicate()
	h_s.border_color = color
	h_s.shadow_size = 20
	h_s.shadow_color = Color(color.r, color.g, color.b, 0.35)
	panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", h_s))
	panel.mouse_exited.connect(func():  panel.add_theme_stylebox_override("panel", s))
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 16); m.add_theme_constant_override("margin_right", 16)
	m.add_theme_constant_override("margin_top", 14);  m.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	m.add_child(v)
	v.add_child(UI.label(title, UITheme.FONT_SM, color.darkened(0.2)))
	v.add_child(UI.label(value, UITheme.FONT_2XL, color))
	# Glow line
	var line := ColorRect.new()
	line.color = color
	line.custom_minimum_size = Vector2(0, 2)
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(line)


func _neon_btn(parent: Control, text: String, color: Color, _bg: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(color.r,color.g,color.b,0.1), UITheme.RADIUS_MD, 1, color.darkened(0.2), 6, Color(color.r,color.g,color.b,0.15), Vector2(0,0), 18, 9)
	var h := UI.style(Color(color.r,color.g,color.b,0.18), UITheme.RADIUS_MD, 1, color, 12, Color(color.r,color.g,color.b,0.3), Vector2(0,0), 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _neon_outline(parent: Control, text: String, color: Color, _bg: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(0,0,0,0), UITheme.RADIUS_MD, 1, color.darkened(0.4), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(0,0,0,0), UITheme.RADIUS_MD, 1, color, 8, Color(color.r,color.g,color.b,0.2), Vector2(0,0), 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color.darkened(0.2))
	btn.add_theme_color_override("font_hover_color", color)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _neon_badge(parent: Control, text: String, color: Color) -> void:
	var panel := PanelContainer.new()
	var s := UI.style(Color(color.r,color.g,color.b,0.08), UITheme.RADIUS_SM, 1, color.darkened(0.3), 4, Color(color.r,color.g,color.b,0.15), Vector2(0,0), 10, 4)
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)
	panel.add_child(UI.label(text, UITheme.FONT_XS, color))


# ═══════════════════════════════════════════════════════
# MATERIAL: Paper / Light (纸质)
# ═══════════════════════════════════════════════════════
func _paper_light(parent: Control) -> void:
	UI.section(parent, "Paper / Light  (纸质明亮)")

	var bg := Color("#F0F1F5")
	var card_bg := Color("#FFFFFF")
	var text_dark := Color("#1A1A2E")
	var text_mid  := Color("#6B7280")
	var border_c  := Color("#E2E4EA")
	var primary   := Color("#4F46E5")

	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", UI.style(bg, UITheme.RADIUS_LG))
	parent.add_child(frame)

	var fm := MarginContainer.new()
	fm.add_theme_constant_override("margin_left", 24); fm.add_theme_constant_override("margin_right", 24)
	fm.add_theme_constant_override("margin_top", 20);  fm.add_theme_constant_override("margin_bottom", 20)
	frame.add_child(fm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	fm.add_child(col)

	col.add_child(UI.label("Clean whites with strong shadows — Material Design inspired", UITheme.FONT_SM, text_mid))

	# Paper cards
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(row)

	var paper_icons  := ["◆", "◈", "◉"]
	var paper_titles := ["Users", "Revenue", "Growth"]
	var paper_vals   := ["3,291", "$24.8K", "+18%"]
	var paper_colors := [primary, Color("#059669"), Color("#D97706")]
	for i in 3:
		_paper_card(row, paper_icons[i], paper_titles[i], paper_vals[i], paper_colors[i], card_bg, border_c, text_dark, text_mid)

	# Paper buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 10)
	col.add_child(btn_row)

	_paper_btn(btn_row, "Primary",   primary,           Color.WHITE)
	_paper_btn(btn_row, "Success",   Color("#059669"),   Color.WHITE)
	_paper_btn(btn_row, "Warning",   Color("#D97706"),   Color.WHITE)
	_paper_outline_btn(btn_row, "Outline", primary, border_c)
	UI.h_expand(btn_row)

	# Paper input
	var input := LineEdit.new()
	input.placeholder_text = "Search..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var in_n := UI.style(card_bg, UITheme.RADIUS_MD, 1, border_c, 2, Color(0,0,0,0.06), Vector2(0,1), 12, 10)
	var in_f := UI.style(card_bg, UITheme.RADIUS_MD, 2, primary, 2, Color(0,0,0,0.06), Vector2(0,1), 12, 10)
	input.add_theme_stylebox_override("normal", in_n)
	input.add_theme_stylebox_override("focus", in_f)
	input.add_theme_color_override("font_color", text_dark)
	input.add_theme_color_override("font_placeholder_color", Color("#9CA3AF"))
	input.add_theme_color_override("caret_color", primary)
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(input)


func _paper_card(parent: Control, icon: String, title: String, value: String,
		_accent: Color, card_bg: Color, _border: Color, text_dark: Color, text_mid: Color) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", UI.style(card_bg, UITheme.RADIUS_LG, 0, Color.TRANSPARENT, 6, Color(0,0,0,0.08), Vector2(0, 3)))
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 16); m.add_theme_constant_override("margin_right", 16)
	m.add_theme_constant_override("margin_top", 14);  m.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	m.add_child(v)
	v.add_child(UI.label(icon + "  " + title, UITheme.FONT_SM, text_mid))
	v.add_child(UI.label(value, UITheme.FONT_2XL, text_dark))


func _paper_btn(parent: Control, text: String, bg: Color, fg: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(bg, UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 3, Color(0,0,0,0.12), Vector2(0,2), 18, 9)
	var h := UI.style(bg.darkened(0.08), UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 4, Color(0,0,0,0.15), Vector2(0,3), 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_color_override("font_hover_color", fg)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _paper_outline_btn(parent: Control, text: String, color: Color, border: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color.WHITE, UITheme.RADIUS_MD, 1, border, 2, Color(0,0,0,0.06), Vector2(0,1), 18, 9)
	var h := UI.style(Color("#F5F5FF"), UITheme.RADIUS_MD, 1, color, 2, Color(0,0,0,0.06), Vector2(0,1), 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


# ═══════════════════════════════════════════════════════
# MATERIAL: Frosted Matte (磨砂)
# ═══════════════════════════════════════════════════════
func _frosted_matte(parent: Control) -> void:
	UI.section(parent, "Frosted Matte  (磨砂)")

	var bg := Color("#1E2028")
	var card_bg := Color("#262830")
	var border_c := Color("#3A3D48")
	var text_c := Color("#B8BCC8")
	var muted  := Color("#6B7080")
	var accent := Color("#8B90A5")

	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", UI.style(bg, UITheme.RADIUS_LG))
	parent.add_child(frame)

	var fm := MarginContainer.new()
	fm.add_theme_constant_override("margin_left", 24); fm.add_theme_constant_override("margin_right", 24)
	fm.add_theme_constant_override("margin_top", 20);  fm.add_theme_constant_override("margin_bottom", 20)
	frame.add_child(fm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	fm.add_child(col)

	col.add_child(UI.label("Heavy borders, no shadows, muted tones — tactile and understated", UITheme.FONT_SM, muted))

	# Matte cards
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(row)

	var mat_titles := ["Storage", "Memory", "CPU"]
	var mat_vals   := ["64 GB", "16 GB", "3.8 GHz"]
	var mat_pcts   := [0.72, 0.45, 0.88]
	for i in 3:
		_matte_card(row, mat_titles[i], mat_vals[i], mat_pcts[i], card_bg, border_c, text_c, muted, accent)

	# Matte buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 10)
	col.add_child(btn_row)

	_matte_btn(btn_row, "Action",  card_bg, accent, border_c)
	_matte_btn(btn_row, "Cancel",  card_bg, muted, border_c)
	_matte_outline(btn_row, "Details", accent, border_c)
	UI.h_expand(btn_row)

	# Matte input
	var input := LineEdit.new()
	input.placeholder_text = "Filter..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var in_s := UI.style(bg, UITheme.RADIUS_SM, 2, border_c, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var in_f := UI.style(bg, UITheme.RADIUS_SM, 2, accent, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	input.add_theme_stylebox_override("normal", in_s)
	input.add_theme_stylebox_override("focus", in_f)
	input.add_theme_color_override("font_color", text_c)
	input.add_theme_color_override("font_placeholder_color", muted)
	input.add_theme_color_override("caret_color", accent)
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(input)


func _matte_card(parent: Control, title: String, value: String, pct: float,
		card_bg: Color, border: Color, text_c: Color, muted: Color, accent: Color) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", UI.style(card_bg, UITheme.RADIUS_SM, 2, border))
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 16); m.add_theme_constant_override("margin_right", 16)
	m.add_theme_constant_override("margin_top", 14);  m.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	m.add_child(v)
	v.add_child(UI.label(title, UITheme.FONT_SM, muted))
	v.add_child(UI.label(value, UITheme.FONT_2XL, text_c))

	# Matte progress bar (no radius, thick)
	var track := PanelContainer.new()
	track.custom_minimum_size.y = 6
	track.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	track.add_theme_stylebox_override("panel", UI.style(card_bg.darkened(0.1), 1, 1, border))
	v.add_child(track)

	var fill := PanelContainer.new()
	fill.anchor_right = pct; fill.anchor_bottom = 1.0
	fill.add_theme_stylebox_override("panel", UI.style(accent, 1))
	track.add_child(fill)

	v.add_child(UI.label(str(int(pct * 100)) + "% used", UITheme.FONT_XS, muted))


func _matte_btn(parent: Control, text: String, bg: Color, fg: Color, border: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(bg, UITheme.RADIUS_SM, 2, border, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(bg.lightened(0.05), UITheme.RADIUS_SM, 2, fg, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_color_override("font_hover_color", fg.lightened(0.2))
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)


func _matte_outline(parent: Control, text: String, color: Color, border: Color) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(0,0,0,0), UITheme.RADIUS_SM, 2, border, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(0,0,0,0), UITheme.RADIUS_SM, 2, color, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color.lightened(0.2))
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)
