class_name BadgesPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Badges & Tags",
		"Status indicators, labels, and tag components for categorization and notifications.")

	_filled_badges(parent)
	_outline_badges(parent)
	_soft_badges(parent)
	_pill_badges(parent)
	_size_variants(parent)
	_dot_indicators(parent)
	_count_badges(parent)
	_tag_group(parent)


# =============================================
# FILLED BADGES
# =============================================

func _filled_badges(parent: Control) -> void:
	UI.section(parent, "Filled Badges")
	var row := UI.hbox(parent, 8)
	UI.badge(row, "Primary", UITheme.PRIMARY)
	UI.badge(row, "Secondary", UITheme.SECONDARY)
	UI.badge(row, "Success", UITheme.SUCCESS, UITheme.TEXT_INVERSE)
	UI.badge(row, "Warning", UITheme.WARNING, UITheme.TEXT_INVERSE)
	UI.badge(row, "Danger", UITheme.DANGER)
	UI.badge(row, "Info", UITheme.INFO)
	UI.badge(row, "Neutral", UITheme.SURFACE_4, UITheme.TEXT_PRIMARY)
	UI.h_expand(row)


# =============================================
# OUTLINE BADGES
# =============================================

func _outline_badges(parent: Control) -> void:
	UI.section(parent, "Outline Badges")
	var row := UI.hbox(parent, 8)
	UI.outline_badge(row, "Primary", UITheme.PRIMARY)
	UI.outline_badge(row, "Secondary", UITheme.SECONDARY)
	UI.outline_badge(row, "Success", UITheme.SUCCESS)
	UI.outline_badge(row, "Warning", UITheme.WARNING)
	UI.outline_badge(row, "Danger", UITheme.DANGER)
	UI.outline_badge(row, "Info", UITheme.INFO)
	UI.outline_badge(row, "Neutral", UITheme.BORDER_STRONG)
	UI.h_expand(row)


# =============================================
# SOFT BADGES
# =============================================

func _soft_badges(parent: Control) -> void:
	UI.section(parent, "Soft / Tint Badges")
	var row := UI.hbox(parent, 8)
	UI.soft_badge(row, "Primary", UITheme.PRIMARY)
	UI.soft_badge(row, "Secondary", UITheme.SECONDARY)
	UI.soft_badge(row, "Success", UITheme.SUCCESS)
	UI.soft_badge(row, "Warning", UITheme.WARNING)
	UI.soft_badge(row, "Danger", UITheme.DANGER)
	UI.soft_badge(row, "Info", UITheme.INFO)
	UI.h_expand(row)


# =============================================
# PILL BADGES
# =============================================

func _pill_badges(parent: Control) -> void:
	UI.section(parent, "Pill Shape")
	var row := UI.hbox(parent, 8)
	UI.badge(row, "Active", UITheme.SUCCESS, UITheme.TEXT_INVERSE, UITheme.RADIUS_PILL, 14, 4)
	UI.badge(row, "Pending", UITheme.WARNING, UITheme.TEXT_INVERSE, UITheme.RADIUS_PILL, 14, 4)
	UI.badge(row, "Inactive", UITheme.DANGER, Color.WHITE, UITheme.RADIUS_PILL, 14, 4)
	UI.badge(row, "Draft", UITheme.SURFACE_4, UITheme.TEXT_PRIMARY, UITheme.RADIUS_PILL, 14, 4)
	UI.outline_badge(row, "v4.3.0", UITheme.PRIMARY, UITheme.RADIUS_PILL, 14, 4)
	UI.soft_badge(row, "Beta", UITheme.INFO, UITheme.RADIUS_PILL, 14, 4)
	UI.h_expand(row)


# =============================================
# SIZE VARIANTS
# =============================================

func _size_variants(parent: Control) -> void:
	UI.section(parent, "Size Variants")
	var row := UI.hbox(parent, 12)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	UI.badge(row, "Small", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_XS, 6, 2, UITheme.FONT_XS)
	UI.badge(row, "Medium", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_XS, 10, 4, UITheme.FONT_SM)
	UI.badge(row, "Large", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_MD)
	UI.h_expand(row)


# =============================================
# DOT INDICATORS
# =============================================

func _dot_indicators(parent: Control) -> void:
	UI.section(parent, "Dot Indicators")
	var row := UI.hbox(parent, 20)

	_dot_item(row, "Online", UITheme.SUCCESS)
	_dot_item(row, "Away", UITheme.WARNING)
	_dot_item(row, "Busy", UITheme.DANGER)
	_dot_item(row, "Offline", UITheme.TEXT_MUTED)
	UI.h_expand(row)


func _dot_item(parent: Control, text: String, color: Color) -> void:
	var h := UI.hbox(parent, 8)
	h.alignment = BoxContainer.ALIGNMENT_CENTER

	var dot := PanelContainer.new()
	dot.custom_minimum_size = Vector2(8, 8)
	dot.add_theme_stylebox_override("panel", UI.style(color, UITheme.RADIUS_PILL))
	h.add_child(dot)

	h.add_child(UI.label(text, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))


# =============================================
# COUNT BADGES
# =============================================

func _count_badges(parent: Control) -> void:
	UI.section(parent, "Notification Counters")
	var row := UI.hbox(parent, 24)

	_count_item(row, "Messages", "3", UITheme.PRIMARY)
	_count_item(row, "Alerts", "12", UITheme.DANGER)
	_count_item(row, "Tasks", "99+", UITheme.WARNING)
	_count_item(row, "Updates", "5", UITheme.INFO)
	UI.h_expand(row)


func _count_item(parent: Control, text: String, count: String, color: Color) -> void:
	var h := UI.hbox(parent, 10)

	h.add_child(UI.label(text, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))

	var badge_panel := PanelContainer.new()
	var min_w := 22 if count.length() <= 2 else 32
	badge_panel.custom_minimum_size = Vector2(min_w, 22)
	badge_panel.add_theme_stylebox_override("panel", UI.style(
		color, UITheme.RADIUS_PILL, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 6, 2
	))
	h.add_child(badge_panel)

	var center := CenterContainer.new()
	badge_panel.add_child(center)
	center.add_child(UI.label(count, UITheme.FONT_XS, Color.WHITE))


# =============================================
# TAG GROUP
# =============================================

func _tag_group(parent: Control) -> void:
	UI.section(parent, "Tag Cloud")

	var card_v := UI.card(parent, 24, 20)

	var tags := [
		["GDScript", UITheme.PRIMARY],
		["Godot", UITheme.SUCCESS],
		["Shaders", UITheme.WARNING],
		["2D", UITheme.INFO],
		["3D", UITheme.SECONDARY],
		["Physics", UITheme.DANGER],
		["UI Design", UITheme.PRIMARY],
		["Animation", UITheme.WARNING],
		["Networking", UITheme.INFO],
		["Audio", UITheme.SUCCESS],
		["Particles", UITheme.DANGER],
		["TileMap", UITheme.SECONDARY],
	]

	# Use HFlowContainer for wrapping
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 8)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(flow)

	for tag_data in tags:
		_removable_tag(flow, tag_data[0], tag_data[1])


func _removable_tag(parent: Control, text: String, color: Color) -> void:
	var panel := PanelContainer.new()
	var bg := Color(color.r, color.g, color.b, 0.12)
	panel.add_theme_stylebox_override("panel", UI.style(
		bg, UITheme.RADIUS_SM, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 10, 5
	))
	parent.add_child(panel)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	panel.add_child(h)

	h.add_child(UI.label(text, UITheme.FONT_SM, color))

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.flat = true
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.custom_minimum_size = Vector2(16, 16)
	close_btn.add_theme_color_override("font_color", color.darkened(0.2))
	close_btn.add_theme_color_override("font_hover_color", color.lightened(0.2))
	close_btn.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	close_btn.pressed.connect(func(): panel.queue_free())
	h.add_child(close_btn)
