class_name NavigationPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Navigation",
		"UITabs and UIAccordion — modular navigation components ready to drop into any project.")

	_tabs_section(parent)
	_accordion_section(parent)


# =============================================
# TABS
# =============================================

func _tabs_section(parent: Control) -> void:
	UI.section(parent, "Tabs Component  (UITabs)")

	var card_v := UI.card(parent, 24, 20)
	var tabs := UITabs.new()
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(tabs)

	tabs.add_tab("Overview",   _tab_overview())
	tabs.add_tab("Analytics",  _tab_analytics())
	tabs.add_tab("Team",       _tab_team())
	tabs.add_tab("Settings",   _tab_settings())

	# Underlined style note
	var note_panel := PanelContainer.new()
	note_panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_3, UITheme.RADIUS_MD, 1, UITheme.BORDER
	))
	card_v.add_child(note_panel)
	var nm := MarginContainer.new()
	nm.add_theme_constant_override("margin_left", 16)
	nm.add_theme_constant_override("margin_right", 16)
	nm.add_theme_constant_override("margin_top", 12)
	nm.add_theme_constant_override("margin_bottom", 12)
	note_panel.add_child(nm)
	nm.add_child(UI.label("ℹ  Copy components/tabs/ui_tabs.gd + scripts/theme.gd to use in your project.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))


func _tab_content(text: String) -> Control:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 20)
	m.add_theme_constant_override("margin_right", 20)
	m.add_theme_constant_override("margin_top", 20)
	m.add_theme_constant_override("margin_bottom", 20)
	m.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2))
	var l := UI.label(text, UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD
	m.add_child(l)
	return m


func _tab_overview() -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2))
	v.add_child(panel)
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 24)
	m.add_theme_constant_override("margin_right", 24)
	m.add_theme_constant_override("margin_top", 20)
	m.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(m)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 16)
	m.add_child(inner)

	inner.add_child(UI.label("Project Overview", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))
	var desc := UI.label(
		"Welcome to the component library dashboard. This tab demonstrates the UITabs component "
		+ "with real content — cards, stats, and text — inside each panel.",
		UITheme.FONT_MD, UITheme.TEXT_SECONDARY
	)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	inner.add_child(desc)

	var stats := UI.hbox(inner, 16)
	for item in [["482", "Components"], ["14", "Categories"], ["3", "Themes"]]:
		var cv := UI.vbox(stats, 4)
		cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cp := PanelContainer.new()
		cp.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_3, UITheme.RADIUS_MD))
		cv.add_child(cp)
		var cm := MarginContainer.new()
		cm.add_theme_constant_override("margin_left", 16)
		cm.add_theme_constant_override("margin_right", 16)
		cm.add_theme_constant_override("margin_top", 12)
		cm.add_theme_constant_override("margin_bottom", 12)
		cp.add_child(cm)
		var cv2 := VBoxContainer.new()
		cv2.add_theme_constant_override("separation", 2)
		cm.add_child(cv2)
		cv2.add_child(UI.label(item[0], UITheme.FONT_2XL, UITheme.PRIMARY))
		cv2.add_child(UI.label(item[1], UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	return v


func _tab_analytics() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2))
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 24)
	m.add_theme_constant_override("margin_right", 24)
	m.add_theme_constant_override("margin_top", 20)
	m.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	m.add_child(v)
	v.add_child(UI.label("Usage Analytics", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))

	var bars := [["Buttons", 0.92], ["Cards", 0.78], ["Inputs", 0.65], ["Badges", 0.45], ["Alerts", 0.38]]
	for bar_data in bars:
		var bv := VBoxContainer.new()
		bv.add_theme_constant_override("separation", 6)
		v.add_child(bv)
		var brow := UI.hbox(bv, 0)
		brow.add_child(UI.label(bar_data[0], UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
		UI.h_expand(brow)
		brow.add_child(UI.label(str(int(float(bar_data[1]) * 100)) + "%", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
		UI.progress_bar(bv, bar_data[1], UITheme.PRIMARY)
	return panel


func _tab_team() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2))
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 24)
	m.add_theme_constant_override("margin_right", 24)
	m.add_theme_constant_override("margin_top", 20)
	m.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	m.add_child(v)
	v.add_child(UI.label("Team Members", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))

	var members := [["JD", UITheme.PRIMARY, "John Doe", "Lead Designer", true],
		["AS", UITheme.SUCCESS, "Alice Smith", "Frontend Dev", true],
		["MB", UITheme.WARNING, "Mike Brown", "Backend Dev", false],
		["CL", UITheme.DANGER,  "Carol Lee",  "QA Engineer",  false]]

	for mem in members:
		var row := UI.hbox(v, 12)
		var av := UIAvatar.new()
		av.initials = mem[0]; av.bg_color = mem[1]; av.avatar_size = UIAvatar.AvatarSize.SM
		av.status = UIAvatar.StatusType.ONLINE if mem[4] else UIAvatar.StatusType.AWAY
		row.add_child(av)
		var info := VBoxContainer.new()
		info.add_theme_constant_override("separation", 2)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info)
		info.add_child(UI.label(mem[2], UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
		info.add_child(UI.label(mem[3], UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	return panel


func _tab_settings() -> Control:
	return _tab_content("Settings panel — configure component defaults, theme colors, and export options.")


# =============================================
# ACCORDION
# =============================================

func _accordion_section(parent: Control) -> void:
	UI.section(parent, "Accordion Component  (UIAccordion)")
	var card_v := UI.card(parent, 24, 20)

	var acc := UIAccordion.new()
	acc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(acc)

	var items := [
		["What is a component library?",
		 "A component library is a collection of reusable UI elements that share a consistent design language. Each component is isolated, documented, and easily imported into new projects."],
		["How do I use these components?",
		 "Copy the component folder (e.g. components/button/) plus scripts/theme.gd to your Godot project. Instantiate via code: var btn := UIButton.new()"],
		["Can I customize the colors?",
		 "Yes — each component uses UITheme constants. Modify UITheme to change the global design system, or pass colors directly via @export properties on each component."],
		["Is Godot 4.x required?",
		 "Yes. All components use Godot 4 GDScript syntax including typed variables, @export decorators, lambdas, and the Tween API."],
	]

	for i in items.size():
		var body_v := VBoxContainer.new()
		var body_l := UI.label(items[i][1], UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
		body_l.autowrap_mode = TextServer.AUTOWRAP_WORD
		body_v.add_child(body_l)
		acc.add_item(items[i][0], body_v, i == 0)

	# Allow-multiple variant
	UI.section(parent, "Allow Multiple Open  (allow_multiple = true)")
	var card_v2 := UI.card(parent, 24, 20)
	var acc2 := UIAccordion.new()
	acc2.allow_multiple = true
	acc2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v2.add_child(acc2)

	for title in ["Section Alpha", "Section Beta", "Section Gamma"]:
		var c := VBoxContainer.new()
		c.add_child(UI.label("Content for " + title + ". All sections can be open simultaneously.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
		acc2.add_item(title, c)
