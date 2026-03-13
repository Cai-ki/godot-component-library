class_name HomePage
extends RefCounted


func build(parent: Control) -> void:
	_hero(parent)
	_stats(parent)
	_categories(parent)
	_recent(parent)
	_quick_start(parent)


# =============================================
# HERO
# =============================================

func _hero(parent: Control) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ps := UI.style(
		UITheme.SURFACE_1, UITheme.RADIUS_LG,
		1, UITheme.BORDER, 8, Color(0, 0, 0, 0.2), Vector2(0, 4)
	)
	panel.add_theme_stylebox_override("panel", ps)
	parent.add_child(panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left",   32)
	m.add_theme_constant_override("margin_right",  32)
	m.add_theme_constant_override("margin_top",    36)
	m.add_theme_constant_override("margin_bottom", 36)
	panel.add_child(m)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	m.add_child(v)

	# Title row
	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 14)
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(title_row)

	var icon := UI.label("⬡", UITheme.FONT_3XL, UITheme.PRIMARY)
	title_row.add_child(icon)

	var title_v := VBoxContainer.new()
	title_v.add_theme_constant_override("separation", 4)
	title_row.add_child(title_v)
	title_v.add_child(UI.label("UI Component Library", UITheme.FONT_3XL, UITheme.TEXT_PRIMARY))

	var sub_row := HBoxContainer.new()
	sub_row.add_theme_constant_override("separation", 10)
	title_v.add_child(sub_row)
	sub_row.add_child(UI.label("Dark Indigo Design System for Godot 4.6", UITheme.FONT_BASE, UITheme.TEXT_SECONDARY))
	UI.soft_badge(sub_row, "v2.0", UITheme.PRIMARY, UITheme.RADIUS_PILL, 10, 3, UITheme.FONT_XS)

	UI.h_expand(title_row)

	# Description
	var desc := UI.label(
		"A production-ready collection of styled UI components, interactive patterns, "
		+ "and design references — all built entirely in GDScript without .tres theme files.",
		UITheme.FONT_MD, UITheme.TEXT_MUTED
	)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(desc)


# =============================================
# STATS
# =============================================

func _stats(parent: Control) -> void:
	var row := UI.hbox(parent, 16)

	_stat(row, "21", "Components",  UITheme.PRIMARY, "◆")
	_stat(row, "16", "Pages",       UITheme.INFO,    "◈")
	_stat(row, "5",  "Themes",      UITheme.SUCCESS, "◇")
	_stat(row, "4",  "Overlays",    UITheme.WARNING, "◉")


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
	var row := UI.hbox(parent, 16)

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
	var row := UI.hbox(parent, 16)

	_recent_card(row, "UIToast",       UITheme.SUCCESS, "Non-blocking auto-dismiss notifications with stacking.")
	_recent_card(row, "UITooltip",     UITheme.INFO,    "Hover-triggered floating hints, auto-positioned above target.")
	_recent_card(row, "UIContextMenu", UITheme.WARNING, "Right-click menus with destructive item styling and screen clamping.")


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
