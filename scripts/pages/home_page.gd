class_name HomePage
extends RefCounted


func build(parent: Control) -> void:
	_hero(parent)
	_stats(parent)
	_categories(parent)
	_recent(parent)
	_quick_start(parent)
	
	_animate_entrance(parent)


func _animate_entrance(parent: Control) -> void:
	var delay := 0.0
	for child in parent.get_children():
		if child is Control and not child.is_queued_for_deletion():
			child.modulate.a = 0.0
			var t = child.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			t.tween_property(child, "modulate:a", 1.0, 0.4).set_delay(delay)
			delay += 0.08


# =============================================
# HERO
# =============================================

func _hero(parent: Control) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ps := UI.style(
		UITheme.SURFACE_2, UITheme.RADIUS_LG,
		1, UITheme.BORDER_STRONG, 16, Color(0, 0, 0, 0.3), Vector2(0, 8)
	)
	ps.border_width_top = 2
	ps.border_color = UITheme.PRIMARY_SOFT
	panel.add_theme_stylebox_override("panel", ps)
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left",   40)
	m.add_theme_constant_override("margin_right",  40)
	m.add_theme_constant_override("margin_top",    48)
	m.add_theme_constant_override("margin_bottom", 48)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	m.add_child(v)

	# Title row
	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 24)
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(title_row)

	var icon := UI.label("◈", UITheme.FONT_3XL, UITheme.PRIMARY)
	icon.add_theme_font_size_override("font_size", 64)
	title_row.add_child(icon)

	var title_v := VBoxContainer.new()
	title_v.add_theme_constant_override("separation", 6)
	title_row.add_child(title_v)
	
	var title_lbl := UI.label("Godot Component Library", UITheme.FONT_3XL, UITheme.TEXT_PRIMARY)
	title_lbl.add_theme_font_size_override("font_size", 34)
	title_v.add_child(title_lbl)

	var sub_row := HBoxContainer.new()
	sub_row.add_theme_constant_override("separation", 12)
	title_v.add_child(sub_row)
	sub_row.add_child(UI.label("Premium UI Design System for Godot 4.6+", UITheme.FONT_LG, UITheme.TEXT_SECONDARY))
	UI.soft_badge(sub_row, "v2.0 Beta", UITheme.PRIMARY, UITheme.RADIUS_PILL, 12, 4, UITheme.FONT_SM)

	UI.h_expand(title_row)

	# Description
	UI.spacer(v, 8)
	var desc := UI.label(
		"Elevate your Godot projects with a production-ready collection of styled UI components, interactive patterns, and dynamic layouts. Built purely in GDScript to be highly performant and customizable.",
		UITheme.FONT_MD, UITheme.TEXT_MUTED
	)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.custom_minimum_size = Vector2(650, 0)
	
	var center_desc := CenterContainer.new()
	center_desc.add_child(desc)
	v.add_child(center_desc)
	
	UI.spacer(v, 16)
	
	# Buttons
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 16)
	action_row.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(action_row)
	
	var _btn_start := UI.solid_btn(action_row, "Explore Components", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 24, 12, UITheme.FONT_MD)
	UI.outline_btn(action_row, "View on GitHub", UITheme.TEXT_SECONDARY, UITheme.RADIUS_MD, 24, 12, UITheme.FONT_MD)


# =============================================
# STATS
# =============================================

func _stats(parent: Control) -> void:
	var row := UI.hbox(parent, 16)

	_stat(row, "43", "Components",  UITheme.PRIMARY, "◆")
	_stat(row, "20", "Pages",       UITheme.INFO,    "◈")
	_stat(row, "3",  "Themes",      UITheme.SUCCESS, "◇")
	_stat(row, "9",  "Overlays",    UITheme.WARNING, "◉")


func _stat(parent: Control, value: String, label: String, color: Color, icon: String) -> void:
	var card_v := UI.card(parent, 20, 18)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 14)
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	card_v.add_child(h)

	# Icon chip
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", UI.style(
		Color(color.r, color.g, color.b, 0.12), UITheme.RADIUS_MD,
		0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 10, 10
	))
	h.add_child(chip)
	var cc := CenterContainer.new()
	chip.add_child(cc)
	cc.add_child(UI.label(icon, UITheme.FONT_LG, color))

	# Value + label
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	h.add_child(v)
	v.add_child(UI.label(value, UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	v.add_child(UI.label(label, UITheme.FONT_SM, UITheme.TEXT_SECONDARY))


# =============================================
# CATEGORY OVERVIEW
# =============================================

func _categories(parent: Control) -> void:
	UI.section(parent, "Browse by Category")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 16)

	_category_card(row, "COMPONENTS", UITheme.PRIMARY, [
		["◉", "Buttons"],  ["⊞", "Cards"],      ["⊟", "Form Inputs"],
		["◈", "Badges"],   ["◎", "Alerts"],      ["▤", "Progress"],
	])
	_category_card(row, "INTERACTIVE", UITheme.INFO, [
		["⊡", "Navigation"],  ["⊤", "Data & Display"],
		["⊞", "Modals"],      ["⊟", "Form Validation"],
	])
	_category_card(row, "DESIGN", UITheme.SUCCESS, [
		["◆", "Themes"],    ["◇", "Shapes"],
		["▦", "Layouts"],   ["◎", "Animations"],
	])


func _category_card(parent: Control, title: String, accent: Color, items: Array) -> void:
	var card_v := UI.card(parent, 20, 18)

	# Header with accent dot
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	card_v.add_child(header)
	var dot := PanelContainer.new()
	dot.custom_minimum_size = Vector2(10, 10)
	dot.add_theme_stylebox_override("panel", UI.style(accent, UITheme.RADIUS_PILL))
	header.add_child(dot)
	header.add_child(UI.label(title, UITheme.FONT_SM, accent))

	UI.sep(card_v, 2)

	# Item list
	for item: Array in items:
		var item_row := HBoxContainer.new()
		item_row.add_theme_constant_override("separation", 8)
		card_v.add_child(item_row)
		item_row.add_child(UI.label(item[0], UITheme.FONT_SM, UITheme.TEXT_MUTED))
		item_row.add_child(UI.label(item[1], UITheme.FONT_SM, UITheme.TEXT_PRIMARY))


# =============================================
# RECENT ADDITIONS
# =============================================

func _recent(parent: Control) -> void:
	UI.section(parent, "Recent Additions")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 16)

	_recent_card(row, "UINumberInput",      UITheme.PRIMARY,   "Stepper input with long-press repeat, prefix/suffix, decimal steps.")
	_recent_card(row, "UISegmentedControl", UITheme.INFO,      "Single-select button group with animated sliding indicator.")
	_recent_card(row, "UIRating",           UITheme.WARNING,   "Star rating with half-star precision and hover preview.")
	_recent_card(row, "UIDropdown",         UITheme.SUCCESS,   "Click-triggered overlay menu with groups and destructive items.")
	_recent_card(row, "UIPopover",          UITheme.SECONDARY, "Floating panel with any Control content, auto-positioned.")
	_recent_card(row, "UICarousel",         UITheme.DANGER,    "Content slider with fade transition, dots, and auto-play.")


func _recent_card(parent: Control, title: String, accent: Color, desc: String) -> void:
	var card_v := UI.hoverable_card(parent, accent, 20, 18)

	var badge_row := HBoxContainer.new()
	badge_row.add_theme_constant_override("separation", 0)
	card_v.add_child(badge_row)
	UI.soft_badge(badge_row, "NEW", accent, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)
	UI.h_expand(badge_row)

	card_v.add_child(UI.label(title, UITheme.FONT_LG, UITheme.TEXT_PRIMARY))

	var d := UI.label(desc, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD
	card_v.add_child(d)


# =============================================
# QUICK START
# =============================================

func _quick_start(parent: Control) -> void:
	UI.section(parent, "Quick Start")
	var card_v := UI.card(parent, 24, 20)

	card_v.add_child(UI.label(
		"Copy any component folder + scripts/theme.gd to your project:",
		UITheme.FONT_SM, UITheme.TEXT_SECONDARY
	))

	var code_panel := PanelContainer.new()
	code_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_1, UITheme.RADIUS_MD, 1, UITheme.BORDER,
		0, Color.TRANSPARENT, Vector2.ZERO, 16, 14
	))
	card_v.add_child(code_panel)

	var code := VBoxContainer.new()
	code.add_theme_constant_override("separation", 4)
	code_panel.add_child(code)

	var lines := [
		["# 1. Copy files",                                  UITheme.TEXT_MUTED],
		["components/toast/ui_toast.gd",                     UITheme.SUCCESS],
		["scripts/theme.gd",                                 UITheme.SUCCESS],
		["",                                                  UITheme.TEXT_MUTED],
		["# 2. Use in your scene",                           UITheme.TEXT_MUTED],
		["var toast := UIToast.new()",                        UITheme.PRIMARY_LIGHT],
		["add_child(toast)",                                  UITheme.PRIMARY_LIGHT],
		["toast.show_toast(\"Saved!\", UIToast.ToastType.SUCCESS)", UITheme.PRIMARY_LIGHT],
	]

	for line: Array in lines:
		if (line[0] as String).is_empty():
			UI.spacer(code, 2)
		else:
			code.add_child(UI.label(line[0] as String, UITheme.FONT_SM, line[1] as Color))
