class_name ShapesPage
extends RefCounted

# Shape presets: [name, radius, border_width, description]
const SHAPES := [
	["Rounded",    8,   1, "Balanced corners — the default modern look"],
	["Pill",       999, 1, "Maximum roundness — soft and friendly"],
	["Sharp",      0,   1, "Zero radius — technical and precise"],
	["Brutalist",  0,   3, "Thick borders, no radius — bold and heavy"],
]


func build(parent: Control) -> void:
	UI.page_header(parent, "Shape Styles",
		"The same components rendered with different corner-radius and border-width philosophies.")

	for shape in SHAPES:
		_shape_section(parent, shape[0], shape[1], shape[2], shape[3])

	_mixed_section(parent)


func _shape_section(parent: Control, name: String, radius: int, bw: int, desc: String) -> void:
	UI.section(parent, name + " — radius " + str(radius) + "px, border " + str(bw) + "px")

	# Outer demo card
	var card_panel := PanelContainer.new()
	card_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cs := UI.style(UITheme.SURFACE_2, radius, bw, UITheme.BORDER, 4, Color(0,0,0,0.15), Vector2(0,2))
	card_panel.add_theme_stylebox_override("panel", cs)
	parent.add_child(card_panel)

	var cm := MarginContainer.new()
	cm.add_theme_constant_override("margin_left", 24); cm.add_theme_constant_override("margin_right", 24)
	cm.add_theme_constant_override("margin_top", 20);  cm.add_theme_constant_override("margin_bottom", 20)
	card_panel.add_child(cm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	cm.add_child(col)

	# Description
	col.add_child(UI.label(desc, UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# ── Buttons row ──
	var btns := HBoxContainer.new()
	btns.add_theme_constant_override("separation", 10)
	col.add_child(btns)

	_solid(btns, "Solid",   UITheme.PRIMARY, Color.WHITE, radius, bw)
	_solid(btns, "Success", UITheme.SUCCESS, UITheme.TEXT_INVERSE, radius, bw)
	_solid(btns, "Danger",  UITheme.DANGER,  Color.WHITE, radius, bw)
	_oline(btns, "Outline", UITheme.PRIMARY, radius, bw)
	_soft_b(btns, "Soft",   UITheme.PRIMARY, radius)
	UI.h_expand(btns)

	# ── Inner card + badge ──
	var inner := HBoxContainer.new()
	inner.add_theme_constant_override("separation", 16)
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(inner)

	# Mini card
	var mini_panel := PanelContainer.new()
	mini_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ms := UI.style(UITheme.SURFACE_3, radius, bw, UITheme.BORDER)
	ms.content_margin_left = 16; ms.content_margin_right = 16
	ms.content_margin_top  = 14; ms.content_margin_bottom = 14
	mini_panel.add_theme_stylebox_override("panel", ms)
	inner.add_child(mini_panel)

	var mini_v := VBoxContainer.new()
	mini_v.add_theme_constant_override("separation", 8)
	mini_panel.add_child(mini_v)
	mini_v.add_child(UI.label("Card Title", UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
	mini_v.add_child(UI.label("Content inside a card with this shape style.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var badge_row := HBoxContainer.new()
	badge_row.add_theme_constant_override("separation", 6)
	mini_v.add_child(badge_row)
	UI.badge(badge_row, "Badge", UITheme.PRIMARY, Color.WHITE, radius, 10, 4, UITheme.FONT_XS)
	UI.outline_badge(badge_row, "Outline", UITheme.SUCCESS, radius, 10, 4, UITheme.FONT_XS)
	UI.soft_badge(badge_row, "Soft", UITheme.WARNING, radius, 10, 4, UITheme.FONT_XS)

	# Input
	var input_v := VBoxContainer.new()
	input_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_v.add_theme_constant_override("separation", 6)
	inner.add_child(input_v)
	input_v.add_child(UI.label("Input", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var input := LineEdit.new()
	input.placeholder_text = "Type here..."
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var in_n := UI.style(UITheme.SURFACE_2, radius, bw, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var in_f := UI.style(UITheme.SURFACE_2, radius, 2, UITheme.PRIMARY, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	input.add_theme_stylebox_override("normal", in_n)
	input.add_theme_stylebox_override("focus",  in_f)
	input.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	input.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
	input.add_theme_color_override("caret_color", UITheme.PRIMARY)
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	input_v.add_child(input)

	# Progress
	input_v.add_child(UI.label("Progress", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.progress_bar(input_v, 0.6, UITheme.PRIMARY, 8, radius)


# ── Mixed shapes section ───────────────────────────
func _mixed_section(parent: Control) -> void:
	UI.section(parent, "Mixed — sharp frame + rounded internals")

	var card_panel := PanelContainer.new()
	card_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2, 0, 2, UITheme.BORDER))
	parent.add_child(card_panel)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	card_panel.add_child(col)

	# Sharp header bar
	var header := PanelContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var hs := UI.style(UITheme.SURFACE_3, 0, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO)
	hs.content_margin_left = 20; hs.content_margin_right = 20
	hs.content_margin_top  = 14; hs.content_margin_bottom = 14
	hs.border_width_bottom = 2; hs.border_color = UITheme.BORDER
	header.add_theme_stylebox_override("panel", hs)
	col.add_child(header)

	var hh := HBoxContainer.new()
	header.add_child(hh)
	hh.add_child(UI.label("Sharp Frame / Rounded Contents", UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
	UI.h_expand(hh)
	UI.badge(hh, "Mix", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_PILL, 12, 4, UITheme.FONT_XS)

	# Rounded body
	var body_m := MarginContainer.new()
	body_m.add_theme_constant_override("margin_left", 20); body_m.add_theme_constant_override("margin_right", 20)
	body_m.add_theme_constant_override("margin_top", 16);  body_m.add_theme_constant_override("margin_bottom", 16)
	col.add_child(body_m)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 12)
	body_m.add_child(body)

	body.add_child(UI.label("Cards and buttons stay rounded while the outer frame is sharp.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	body.add_child(row)
	UI.solid_btn(row, "Rounded Btn", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_PILL, 18, 9, UITheme.FONT_SM)
	UI.outline_btn(row, "Pill Outline", UITheme.SUCCESS, UITheme.RADIUS_PILL, 18, 9, UITheme.FONT_SM)
	UI.soft_btn(row, "Soft Round", UITheme.WARNING, UITheme.RADIUS_LG, 18, 9, UITheme.FONT_SM)
	UI.h_expand(row)


# ── Button factories ────────────────────────────────
func _solid(parent: Control, text: String, bg: Color, fg: Color, r: int, bw: int) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(bg, r, 0, Color.TRANSPARENT, 4, Color(0,0,0,0.2), Vector2(0,2), 18, 9)
	var h := UI.style(bg.lightened(0.15), r, 0, Color.TRANSPARENT, 6, Color(0,0,0,0.25), Vector2(0,3), 18, 9)
	var p := UI.style(bg.darkened(0.15), r, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	if bw > 1:
		for s in [n, h, p]:
			s.border_width_top = bw; s.border_width_bottom = bw
			s.border_width_left = bw; s.border_width_right = bw
			s.border_color = bg.darkened(0.3)
	btn.add_theme_stylebox_override("normal", n); btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p); btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", fg); btn.add_theme_color_override("font_hover_color", fg)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)

func _oline(parent: Control, text: String, color: Color, r: int, bw: int) -> void:
	var btn := Button.new()
	btn.text = text; btn.focus_mode = Control.FOCUS_NONE
	var n := UI.style(Color(0,0,0,0), r, bw, color, 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	var h := UI.style(Color(color.r,color.g,color.b,0.12), r, bw, color.lightened(0.2), 0, Color.TRANSPARENT, Vector2.ZERO, 18, 9)
	btn.add_theme_stylebox_override("normal", n); btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", n); btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color); btn.add_theme_color_override("font_hover_color", color.lightened(0.15))
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	parent.add_child(btn)

func _soft_b(parent: Control, text: String, color: Color, r: int) -> void:
	UI.soft_btn(parent, text, color, r, 18, 9, UITheme.FONT_SM)
