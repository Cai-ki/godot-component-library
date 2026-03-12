class_name CardsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Cards",
		"Versatile card components for grouping content with elevation, borders, and interactive effects.")

	_basic_cards(parent)
	_stat_cards(parent)
	_feature_cards(parent)
	_content_cards(parent)


# =============================================
# BASIC CARDS
# =============================================

func _basic_cards(parent: Control) -> void:
	UI.section(parent, "Card Elevations")
	var row := UI.hbox(parent, 16)

	# Default card
	var c1 := UI.card(row, 24, 20, 0)
	c1.add_child(UI.label("Default Card", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	c1.add_child(UI.label("Subtle shadow with border.\nGood for most content sections.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# Elevated card
	var c2 := UI.card(row, 24, 20, 1)
	c2.add_child(UI.label("Elevated Card", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	c2.add_child(UI.label("Stronger shadow for emphasis.\nDraws attention to important items.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# High elevation card
	var c3 := UI.card(row, 24, 20, 2)
	c3.add_child(UI.label("High Elevation", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	c3.add_child(UI.label("Maximum shadow depth.\nUse for modals or floating elements.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# Outline only
	var c4_panel := PanelContainer.new()
	c4_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	c4_panel.add_theme_stylebox_override("panel", UI.style(
		Color(0, 0, 0, 0), UITheme.RADIUS_LG, 1, UITheme.BORDER_STRONG
	))
	row.add_child(c4_panel)
	var c4_margin := MarginContainer.new()
	c4_margin.add_theme_constant_override("margin_left", 24)
	c4_margin.add_theme_constant_override("margin_right", 24)
	c4_margin.add_theme_constant_override("margin_top", 20)
	c4_margin.add_theme_constant_override("margin_bottom", 20)
	c4_panel.add_child(c4_margin)
	var c4 := VBoxContainer.new()
	c4.add_theme_constant_override("separation", 12)
	c4_margin.add_child(c4)
	c4.add_child(UI.label("Outline Card", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	c4.add_child(UI.label("No background fill.\nClean border-only style.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))


# =============================================
# STAT CARDS
# =============================================

func _stat_cards(parent: Control) -> void:
	UI.section(parent, "Statistics Cards")
	var row := UI.hbox(parent, 16)

	_stat_card(row, "◆", UITheme.INFO, "12,847", "Total Users", "↑ 12.5%", UITheme.SUCCESS)
	_stat_card(row, "◈", UITheme.SUCCESS, "$48.2K", "Revenue", "↑ 8.3%", UITheme.SUCCESS)
	_stat_card(row, "◇", UITheme.WARNING, "1,284", "Active Now", "↓ 2.1%", UITheme.DANGER)
	_stat_card(row, "◉", UITheme.PRIMARY, "98.7%", "Uptime", "→ 0.0%", UITheme.TEXT_SECONDARY)


func _stat_card(parent: Control, icon: String, accent: Color, value: String,
		title: String, trend: String, trend_color: Color) -> void:
	var card_vbox := UI.card(parent, 24, 20)

	# Icon chip
	var icon_row := UI.hbox(card_vbox, 0)
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", UI.style(
		Color(accent.r, accent.g, accent.b, 0.15), UITheme.RADIUS_MD,
		0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 10, 8
	))
	icon_row.add_child(chip)
	chip.add_child(UI.label(icon, UITheme.FONT_BASE, accent))
	UI.h_expand(icon_row)

	# Value
	card_vbox.add_child(UI.label(value, UITheme.FONT_3XL, UITheme.TEXT_PRIMARY))

	# Title + Trend
	var bottom_row := UI.hbox(card_vbox, 8)
	bottom_row.add_child(UI.label(title, UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.h_expand(bottom_row)
	bottom_row.add_child(UI.label(trend, UITheme.FONT_SM, trend_color))


# =============================================
# FEATURE CARDS (Hoverable)
# =============================================

func _feature_cards(parent: Control) -> void:
	UI.section(parent, "Feature Cards (Hover)")
	var row := UI.hbox(parent, 16)

	_feature_card(row, "⚡", UITheme.PRIMARY, "Fast Performance",
		"Optimized rendering pipeline delivers smooth 60fps gameplay even on mobile devices.")
	_feature_card(row, "☆", UITheme.WARNING, "Extensible System",
		"Plugin architecture allows easy customization and community-driven extensions.")
	_feature_card(row, "◈", UITheme.SUCCESS, "Cross Platform",
		"Deploy to desktop, mobile, web, and consoles from a single project source.")


func _feature_card(parent: Control, icon: String, accent: Color,
		title: String, desc: String) -> void:
	var card_vbox := UI.hoverable_card(parent, accent)

	# Icon area
	var icon_panel := PanelContainer.new()
	icon_panel.add_theme_stylebox_override("panel", UI.style(
		Color(accent.r, accent.g, accent.b, 0.12), UITheme.RADIUS_LG,
		0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 0, 0
	))
	icon_panel.custom_minimum_size = Vector2(48, 48)
	card_vbox.add_child(icon_panel)

	var icon_center := CenterContainer.new()
	icon_panel.add_child(icon_center)
	icon_center.add_child(UI.label(icon, UITheme.FONT_2XL, accent))

	UI.spacer(card_vbox, 4)
	card_vbox.add_child(UI.label(title, UITheme.FONT_LG, UITheme.TEXT_PRIMARY))

	var d := UI.label(desc, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD
	card_vbox.add_child(d)


# =============================================
# CONTENT CARDS
# =============================================

func _content_cards(parent: Control) -> void:
	UI.section(parent, "Content Cards")
	var row := UI.hbox(parent, 16)

	# Profile card
	_profile_card(row)

	# Action card
	_action_card(row)


func _profile_card(parent: Control) -> void:
	var card_vbox := UI.card(parent, 24, 24)

	# Avatar + Name row
	var top_row := UI.hbox(card_vbox, 14)

	# Avatar component
	var avatar := UIAvatar.new()
	avatar.initials = "JD"
	avatar.bg_color = UITheme.PRIMARY
	avatar.avatar_size = UIAvatar.AvatarSize.MD
	top_row.add_child(avatar)

	# Name + role
	var name_v := VBoxContainer.new()
	name_v.add_theme_constant_override("separation", 2)
	top_row.add_child(name_v)
	name_v.add_child(UI.label("John Doe", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	name_v.add_child(UI.label("Senior Developer", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	UI.sep(card_vbox, 4)

	# Bio
	var bio := UI.label("Building scalable systems and crafting beautiful user interfaces. Passionate about open source.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	bio.autowrap_mode = TextServer.AUTOWRAP_WORD
	card_vbox.add_child(bio)

	# Tags
	var tags_row := UI.hbox(card_vbox, 6)
	UI.soft_badge(tags_row, "GDScript", UITheme.PRIMARY, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)
	UI.soft_badge(tags_row, "Godot", UITheme.SUCCESS, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)
	UI.soft_badge(tags_row, "Shaders", UITheme.WARNING, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)

	# Action buttons
	var actions := UI.hbox(card_vbox, 8)
	UI.solid_btn(actions, "Follow", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 16, 8, UITheme.FONT_SM)
	UI.outline_btn(actions, "Message", UITheme.TEXT_SECONDARY, UITheme.RADIUS_MD, 16, 8, UITheme.FONT_SM)


func _action_card(parent: Control) -> void:
	var card_vbox := UI.card(parent, 0, 0)
	card_vbox.add_theme_constant_override("separation", 0)

	# Header
	var header_margin := MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 24)
	header_margin.add_theme_constant_override("margin_right", 24)
	header_margin.add_theme_constant_override("margin_top", 18)
	header_margin.add_theme_constant_override("margin_bottom", 14)
	card_vbox.add_child(header_margin)

	var header_v := VBoxContainer.new()
	header_v.add_theme_constant_override("separation", 4)
	header_margin.add_child(header_v)
	header_v.add_child(UI.label("Create New Project", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))
	header_v.add_child(UI.label("Deploy your new project in one-click.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# Separator
	var sep_rect := ColorRect.new()
	sep_rect.color = UITheme.BORDER
	sep_rect.custom_minimum_size.y = 1
	sep_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_vbox.add_child(sep_rect)

	# Body
	var body_margin := MarginContainer.new()
	body_margin.add_theme_constant_override("margin_left", 24)
	body_margin.add_theme_constant_override("margin_right", 24)
	body_margin.add_theme_constant_override("margin_top", 18)
	body_margin.add_theme_constant_override("margin_bottom", 18)
	card_vbox.add_child(body_margin)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 14)
	body_margin.add_child(body)

	# Form fields
	_field(body, "Project Name", "my-awesome-project")
	_field(body, "Framework", "Godot 4.3")
	_field(body, "Description", "Enter project description...")

	# Footer separator
	var sep2 := ColorRect.new()
	sep2.color = UITheme.BORDER
	sep2.custom_minimum_size.y = 1
	sep2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_vbox.add_child(sep2)

	# Footer
	var footer_margin := MarginContainer.new()
	footer_margin.add_theme_constant_override("margin_left", 24)
	footer_margin.add_theme_constant_override("margin_right", 24)
	footer_margin.add_theme_constant_override("margin_top", 14)
	footer_margin.add_theme_constant_override("margin_bottom", 14)
	card_vbox.add_child(footer_margin)

	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 8)
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer_margin.add_child(footer)

	UI.ghost_btn(footer, "Cancel", UITheme.TEXT_SECONDARY, UITheme.RADIUS_MD, 16, 8, UITheme.FONT_SM)
	UI.solid_btn(footer, "Create", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 20, 8, UITheme.FONT_SM)


func _field(parent: Control, label_text: String, placeholder: String) -> void:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	parent.add_child(v)
	v.add_child(UI.label(label_text, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.styled_input(v, placeholder, 0).size_flags_horizontal = Control.SIZE_EXPAND_FILL
