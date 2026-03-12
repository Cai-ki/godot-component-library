class_name UI
extends RefCounted

# =============================================
# STYLEBOX FACTORY
# =============================================

static func style(
	bg: Color,
	radius: int = UITheme.RADIUS_MD,
	bw: int = 0,
	bc: Color = Color.TRANSPARENT,
	shadow: int = 0,
	shadow_c: Color = Color(0, 0, 0, 0.25),
	shadow_off: Vector2 = Vector2.ZERO,
	px: int = 0,
	py: int = 0
) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left = radius
	s.corner_radius_top_right = radius
	s.corner_radius_bottom_left = radius
	s.corner_radius_bottom_right = radius
	if bw > 0:
		s.border_width_top = bw
		s.border_width_bottom = bw
		s.border_width_left = bw
		s.border_width_right = bw
		s.border_color = bc
	if shadow > 0:
		s.shadow_size = shadow
		s.shadow_color = shadow_c
		s.shadow_offset = shadow_off if shadow_off != Vector2.ZERO else Vector2(0, shadow * 0.5)
	if px > 0:
		s.content_margin_left = px
		s.content_margin_right = px
	if py > 0:
		s.content_margin_top = py
		s.content_margin_bottom = py
	return s

static func style_left_border(
	bg: Color,
	border_color: Color,
	border_width: int = 4,
	radius: int = UITheme.RADIUS_MD
) -> StyleBoxFlat:
	var s := style(bg, radius)
	s.border_width_left = border_width
	s.border_color = border_color
	return s

# =============================================
# BUTTON FACTORY
# =============================================

static func solid_btn(
	parent: Control,
	text: String,
	color: Color,
	font_color: Color = Color.WHITE,
	radius: int = UITheme.RADIUS_MD,
	px: int = 20,
	py: int = 10,
	font_size: int = UITheme.FONT_MD
) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE

	var n := style(color, radius, 0, Color.TRANSPARENT, 4, Color(0, 0, 0, 0.25), Vector2(0, 2), px, py)
	var h := style(color.lightened(0.15), radius, 0, Color.TRANSPARENT, 8, Color(0, 0, 0, 0.3), Vector2(0, 3), px, py)
	var p := style(color.darkened(0.15), radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var d := style(UITheme.SURFACE_3, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_stylebox_override("disabled", d)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", font_color)
	btn.add_theme_color_override("font_pressed_color", font_color)
	btn.add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)
	btn.add_theme_font_size_override("font_size", font_size)

	parent.add_child(btn)
	return btn

static func outline_btn(
	parent: Control,
	text: String,
	color: Color,
	radius: int = UITheme.RADIUS_MD,
	px: int = 20,
	py: int = 10,
	font_size: int = UITheme.FONT_MD
) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE

	var bg_soft := Color(color.r, color.g, color.b, 0.0)
	var bg_hover := Color(color.r, color.g, color.b, 0.12)
	var bg_pressed := Color(color.r, color.g, color.b, 0.2)

	var n := style(bg_soft, radius, 1, color, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var h := style(bg_hover, radius, 1, color.lightened(0.2), 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var p := style(bg_pressed, radius, 1, color, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color.lightened(0.15))
	btn.add_theme_color_override("font_pressed_color", color)
	btn.add_theme_font_size_override("font_size", font_size)

	parent.add_child(btn)
	return btn

static func soft_btn(
	parent: Control,
	text: String,
	color: Color,
	radius: int = UITheme.RADIUS_MD,
	px: int = 20,
	py: int = 10,
	font_size: int = UITheme.FONT_MD
) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE

	var bg := Color(color.r, color.g, color.b, 0.12)
	var bg_hover := Color(color.r, color.g, color.b, 0.2)
	var bg_pressed := Color(color.r, color.g, color.b, 0.28)

	var n := style(bg, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var h := style(bg_hover, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var p := style(bg_pressed, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color.lightened(0.1))
	btn.add_theme_color_override("font_pressed_color", color)
	btn.add_theme_font_size_override("font_size", font_size)

	parent.add_child(btn)
	return btn

static func ghost_btn(
	parent: Control,
	text: String,
	color: Color,
	radius: int = UITheme.RADIUS_MD,
	px: int = 20,
	py: int = 10,
	font_size: int = UITheme.FONT_MD
) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE

	var bg_hover := Color(color.r, color.g, color.b, 0.08)
	var bg_pressed := Color(color.r, color.g, color.b, 0.15)
	var transparent := Color(0, 0, 0, 0)

	var n := style(transparent, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var h := style(bg_hover, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	var p := style(bg_pressed, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", color)
	btn.add_theme_color_override("font_hover_color", color.lightened(0.15))
	btn.add_theme_color_override("font_pressed_color", color)
	btn.add_theme_font_size_override("font_size", font_size)

	parent.add_child(btn)
	return btn

# =============================================
# LAYOUT HELPERS
# =============================================

static func hbox(parent: Control, gap: int = 12) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", gap)
	parent.add_child(h)
	return h

static func vbox(parent: Control, gap: int = 12) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", gap)
	parent.add_child(v)
	return v

static func spacer(parent: Control, size: int = UITheme.SP_4) -> Control:
	var s := Control.new()
	s.custom_minimum_size = Vector2(size, size)
	parent.add_child(s)
	return s

static func h_expand(parent: Control) -> Control:
	var s := Control.new()
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(s)
	return s

static func sep(parent: Control, margin_v: int = 4) -> void:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_top", margin_v)
	m.add_theme_constant_override("margin_bottom", margin_v)
	m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(m)
	var rect := ColorRect.new()
	rect.color = UITheme.BORDER
	rect.custom_minimum_size.y = 1
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	m.add_child(rect)

# =============================================
# LABEL FACTORY
# =============================================

static func label(
	text: String,
	size: int = UITheme.FONT_MD,
	color: Color = UITheme.TEXT_PRIMARY
) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

# =============================================
# PAGE STRUCTURE HELPERS
# =============================================

static func page_header(parent: Control, title: String, desc: String = "") -> void:
	var v := vbox(parent, 6)
	v.add_child(label(title, UITheme.FONT_3XL, UITheme.TEXT_PRIMARY))
	if desc != "":
		var d := label(desc, UITheme.FONT_BASE, UITheme.TEXT_SECONDARY)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD
		v.add_child(d)
	sep(parent, 8)

static func section(parent: Control, title: String) -> void:
	spacer(parent, UITheme.SP_4)
	var l := label(title.to_upper(), UITheme.FONT_SM, UITheme.TEXT_MUTED)
	parent.add_child(l)

# =============================================
# CARD FACTORY
# =============================================

static func card(
	parent: Control,
	pad_h: int = 24,
	pad_v: int = 20,
	elevation: int = 0
) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var shadow_size := 4 + elevation * 4
	var shadow_alpha := 0.15 + elevation * 0.05
	var s := style(
		UITheme.SURFACE_2, UITheme.RADIUS_LG,
		1, UITheme.BORDER,
		shadow_size, Color(0, 0, 0, shadow_alpha), Vector2(0, shadow_size * 0.4)
	)
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", pad_h)
	margin.add_theme_constant_override("margin_right", pad_h)
	margin.add_theme_constant_override("margin_top", pad_v)
	margin.add_theme_constant_override("margin_bottom", pad_v)
	panel.add_child(margin)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	margin.add_child(v)
	return v

static func hoverable_card(
	parent: Control,
	accent_color: Color = UITheme.PRIMARY,
	pad_h: int = 24,
	pad_v: int = 20
) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var normal_style := style(
		UITheme.SURFACE_2, UITheme.RADIUS_LG,
		1, UITheme.BORDER, 4, Color(0, 0, 0, 0.15), Vector2(0, 2)
	)
	var hover_style := style(
		UITheme.SURFACE_3, UITheme.RADIUS_LG,
		1, accent_color.darkened(0.3), 12, Color(0, 0, 0, 0.25), Vector2(0, 4)
	)

	panel.add_theme_stylebox_override("panel", normal_style)
	parent.add_child(panel)

	panel.mouse_entered.connect(func():
		panel.add_theme_stylebox_override("panel", hover_style)
	)
	panel.mouse_exited.connect(func():
		panel.add_theme_stylebox_override("panel", normal_style)
	)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", pad_h)
	margin.add_theme_constant_override("margin_right", pad_h)
	margin.add_theme_constant_override("margin_top", pad_v)
	margin.add_theme_constant_override("margin_bottom", pad_v)
	panel.add_child(margin)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	margin.add_child(v)
	return v

# =============================================
# BADGE FACTORY
# =============================================

static func badge(
	parent: Control,
	text: String,
	bg_color: Color,
	text_color: Color = Color.WHITE,
	radius: int = UITheme.RADIUS_XS,
	px: int = 10,
	py: int = 4,
	font_size: int = UITheme.FONT_SM
) -> PanelContainer:
	var panel := PanelContainer.new()
	var s := style(bg_color, radius, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var l := label(text, font_size, text_color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(l)
	return panel

static func outline_badge(
	parent: Control,
	text: String,
	color: Color,
	radius: int = UITheme.RADIUS_XS,
	px: int = 10,
	py: int = 4,
	font_size: int = UITheme.FONT_SM
) -> PanelContainer:
	var panel := PanelContainer.new()
	var s := style(Color(0, 0, 0, 0), radius, 1, color, 0, Color.TRANSPARENT, Vector2.ZERO, px, py)
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var l := label(text, font_size, color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(l)
	return panel

static func soft_badge(
	parent: Control,
	text: String,
	color: Color,
	radius: int = UITheme.RADIUS_XS,
	px: int = 10,
	py: int = 4,
	font_size: int = UITheme.FONT_SM
) -> PanelContainer:
	var bg := Color(color.r, color.g, color.b, 0.12)
	return badge(parent, text, bg, color, radius, px, py, font_size)

# =============================================
# INPUT FACTORY
# =============================================

static func styled_input(
	parent: Control,
	placeholder: String = "",
	width: int = 280
) -> LineEdit:
	var input := LineEdit.new()
	input.placeholder_text = placeholder
	input.custom_minimum_size.x = width

	var n := style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var f := style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.PRIMARY, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)

	input.add_theme_stylebox_override("normal", n)
	input.add_theme_stylebox_override("focus", f)
	input.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	input.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
	input.add_theme_color_override("caret_color", UITheme.PRIMARY)
	input.add_theme_color_override("selection_color", UITheme.PRIMARY_SOFT)
	input.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	parent.add_child(input)
	return input

# =============================================
# PROGRESS BAR FACTORY
# =============================================

static func progress_bar(
	parent: Control,
	value: float = 0.5,
	color: Color = UITheme.PRIMARY,
	height: int = 8,
	radius: int = UITheme.RADIUS_SM
) -> Control:
	var container := Control.new()
	container.custom_minimum_size = Vector2(0, height)
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(container)

	var track := PanelContainer.new()
	track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	track.add_theme_stylebox_override("panel", style(UITheme.SURFACE_3, radius))
	container.add_child(track)

	var fill := PanelContainer.new()
	fill.anchor_left = 0
	fill.anchor_top = 0
	fill.anchor_right = clampf(value, 0.0, 1.0)
	fill.anchor_bottom = 1.0
	fill.offset_left = 0
	fill.offset_top = 0
	fill.offset_right = 0
	fill.offset_bottom = 0
	fill.add_theme_stylebox_override("panel", style(color, radius))
	container.add_child(fill)

	return container

# =============================================
# ALERT FACTORY
# =============================================

static func alert(
	parent: Control,
	icon_text: String,
	title: String,
	desc: String,
	color: Color,
	show_close: bool = false
) -> PanelContainer:
	var bg := Color(color.r, color.g, color.b, 0.06)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := style_left_border(bg, color, 4, UITheme.RADIUS_MD)
	s.content_margin_left = 16
	s.content_margin_right = 16
	s.content_margin_top = 14
	s.content_margin_bottom = 14
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var outer_h := HBoxContainer.new()
	outer_h.add_theme_constant_override("separation", 12)
	panel.add_child(outer_h)

	var icon_label := label(icon_text, UITheme.FONT_LG, color)
	outer_h.add_child(icon_label)

	var text_v := VBoxContainer.new()
	text_v.add_theme_constant_override("separation", 4)
	text_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer_h.add_child(text_v)

	text_v.add_child(label(title, UITheme.FONT_MD, color))
	if desc != "":
		var d := label(desc, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD
		text_v.add_child(d)

	if show_close:
		var close_btn := Button.new()
		close_btn.text = "✕"
		close_btn.focus_mode = Control.FOCUS_NONE
		close_btn.flat = true
		close_btn.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		close_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
		close_btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		close_btn.pressed.connect(func(): panel.queue_free())
		outer_h.add_child(close_btn)

	return panel
