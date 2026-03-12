class_name ButtonsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Buttons",
		"A versatile button system with multiple variants, sizes, and states for every use case.")

	_solid_section(parent)
	_outline_section(parent)
	_soft_section(parent)
	_ghost_section(parent)
	_sizes_section(parent)
	_special_section(parent)


# =============================================
# SOLID BUTTONS
# =============================================

func _solid_section(parent: Control) -> void:
	UI.section(parent, "Solid Variants")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 12)
	UI.solid_btn(row, "Primary", UITheme.PRIMARY)
	UI.solid_btn(row, "Secondary", UITheme.SECONDARY)
	UI.solid_btn(row, "Success", UITheme.SUCCESS, UITheme.TEXT_INVERSE)
	UI.solid_btn(row, "Warning", UITheme.WARNING, UITheme.TEXT_INVERSE)
	UI.solid_btn(row, "Danger", UITheme.DANGER)
	UI.solid_btn(row, "Neutral", UITheme.SURFACE_4, UITheme.TEXT_PRIMARY)
	UI.h_expand(row)


# =============================================
# OUTLINE BUTTONS
# =============================================

func _outline_section(parent: Control) -> void:
	UI.section(parent, "Outline Variants")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 12)
	UI.outline_btn(row, "Primary", UITheme.PRIMARY)
	UI.outline_btn(row, "Secondary", UITheme.SECONDARY)
	UI.outline_btn(row, "Success", UITheme.SUCCESS)
	UI.outline_btn(row, "Warning", UITheme.WARNING)
	UI.outline_btn(row, "Danger", UITheme.DANGER)
	UI.outline_btn(row, "Neutral", UITheme.BORDER_STRONG)
	UI.h_expand(row)


# =============================================
# SOFT BUTTONS
# =============================================

func _soft_section(parent: Control) -> void:
	UI.section(parent, "Soft / Tint Variants")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 12)
	UI.soft_btn(row, "Primary", UITheme.PRIMARY)
	UI.soft_btn(row, "Secondary", UITheme.SECONDARY)
	UI.soft_btn(row, "Success", UITheme.SUCCESS)
	UI.soft_btn(row, "Warning", UITheme.WARNING)
	UI.soft_btn(row, "Danger", UITheme.DANGER)
	UI.soft_btn(row, "Info", UITheme.INFO)
	UI.h_expand(row)


# =============================================
# GHOST BUTTONS
# =============================================

func _ghost_section(parent: Control) -> void:
	UI.section(parent, "Ghost / Text Variants")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 12)
	UI.ghost_btn(row, "Primary", UITheme.PRIMARY)
	UI.ghost_btn(row, "Secondary", UITheme.SECONDARY)
	UI.ghost_btn(row, "Success", UITheme.SUCCESS)
	UI.ghost_btn(row, "Warning", UITheme.WARNING)
	UI.ghost_btn(row, "Danger", UITheme.DANGER)
	UI.ghost_btn(row, "Neutral", UITheme.TEXT_SECONDARY)
	UI.h_expand(row)


# =============================================
# SIZE VARIANTS
# =============================================

func _sizes_section(parent: Control) -> void:
	UI.section(parent, "Size Variants")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 12)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	UI.solid_btn(row, "XS", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_SM, 12, 4, UITheme.FONT_XS)
	UI.solid_btn(row, "Small", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)
	UI.solid_btn(row, "Medium", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 20, 10, UITheme.FONT_MD)
	UI.solid_btn(row, "Large", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 24, 14, UITheme.FONT_BASE)
	UI.solid_btn(row, "Extra Large", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_LG, 32, 16, UITheme.FONT_LG)
	UI.h_expand(row)


# =============================================
# SPECIAL BUTTONS
# =============================================

func _special_section(parent: Control) -> void:
	UI.section(parent, "Special Buttons")
	var card1 := UI.card(parent, 24, 20)

	# Row 1: Icon + Text, Pill shape
	var row1 := UI.hbox(card1, 12)
	UI.solid_btn(row1, "⊕  Add Item", UITheme.PRIMARY)
	UI.solid_btn(row1, "⟳  Refresh", UITheme.SECONDARY)
	UI.solid_btn(row1, "✓  Confirm", UITheme.SUCCESS, UITheme.TEXT_INVERSE)
	UI.solid_btn(row1, "✕  Delete", UITheme.DANGER)

	# Separator
	var vsep := VSeparator.new()
	vsep.add_theme_constant_override("separation", 8)
	row1.add_child(vsep)

	# Pill buttons
	UI.solid_btn(row1, "Pill Primary", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_PILL)
	UI.outline_btn(row1, "Pill Outline", UITheme.PRIMARY, UITheme.RADIUS_PILL)
	UI.soft_btn(row1, "Pill Soft", UITheme.PRIMARY, UITheme.RADIUS_PILL)
	UI.h_expand(row1)

	# Row 2: Disabled buttons
	UI.section(parent, "Disabled State")
	var card2 := UI.card(parent, 24, 20)
	var row2 := UI.hbox(card2, 12)
	var d1 := UI.solid_btn(row2, "Disabled Solid", UITheme.PRIMARY)
	d1.disabled = true
	var d2 := UI.outline_btn(row2, "Disabled Outline", UITheme.PRIMARY)
	d2.disabled = true
	d2.add_theme_stylebox_override("disabled", UI.style(
		Color(0, 0, 0, 0), UITheme.RADIUS_MD, 1, UITheme.SURFACE_3, 0, Color.TRANSPARENT, Vector2.ZERO, 20, 10
	))
	d2.add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)

	# Loading button simulation
	var loading := UI.solid_btn(row2, "⟳  Loading...", UITheme.SURFACE_4, UITheme.TEXT_SECONDARY)
	loading.disabled = true
	UI.h_expand(row2)

	# Row 3: Button group demo
	UI.section(parent, "Button Group")
	var card3 := UI.card(parent, 24, 20)
	var row3 := UI.hbox(card3, 0)

	_group_btn(row3, "Day", true, true, false)
	_group_btn(row3, "Week", false, false, false)
	_group_btn(row3, "Month", false, false, false)
	_group_btn(row3, "Year", false, false, true)
	UI.h_expand(row3)


func _group_btn(parent: Control, text: String, active: bool, first: bool, last: bool) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.focus_mode = Control.FOCUS_NONE
	btn.toggle_mode = true
	btn.button_pressed = active

	var r_tl := UITheme.RADIUS_MD if first else 0
	var r_tr := UITheme.RADIUS_MD if last else 0
	var r_bl := UITheme.RADIUS_MD if first else 0
	var r_br := UITheme.RADIUS_MD if last else 0

	var color_bg := UITheme.PRIMARY if active else UITheme.SURFACE_3
	var color_text := Color.WHITE if active else UITheme.TEXT_SECONDARY

	var s := StyleBoxFlat.new()
	s.bg_color = color_bg
	s.corner_radius_top_left = r_tl
	s.corner_radius_top_right = r_tr
	s.corner_radius_bottom_left = r_bl
	s.corner_radius_bottom_right = r_br
	s.border_width_top = 1
	s.border_width_bottom = 1
	s.border_width_left = 1 if first else 0
	s.border_width_right = 1
	s.border_color = UITheme.PRIMARY if active else UITheme.BORDER
	s.content_margin_left = 20
	s.content_margin_right = 20
	s.content_margin_top = 10
	s.content_margin_bottom = 10

	var h := s.duplicate()
	h.bg_color = color_bg.lightened(0.1) if active else UITheme.SURFACE_4

	btn.add_theme_stylebox_override("normal", s)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus", s)
	btn.add_theme_color_override("font_color", color_text)
	btn.add_theme_color_override("font_hover_color", color_text)
	btn.add_theme_color_override("font_pressed_color", color_text)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	parent.add_child(btn)
	return btn
