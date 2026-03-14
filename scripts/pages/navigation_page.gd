class_name NavigationPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Navigation",
		"UITabs and UIAccordion — modular navigation components ready to drop into any project.")

	_tabs_section(parent)
	_dropdown_section(parent)
	_popover_section(parent)
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

	# Usage note
	UI.alert(card_v, "ℹ", "Usage",
		"Copy components/tabs/ui_tabs.gd + scripts/theme.gd to use in your project.",
		UITheme.INFO)


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
# DROPDOWN
# =============================================

func _dropdown_section(parent: Control) -> void:
	UI.section(parent, "Dropdown Menu  (UIDropdown)")
	var card_v := UI.card(parent, 24, 20)

	var row := UI.hbox(card_v, 16)

	# Basic dropdown
	var col1 := UI.vbox(row, 6)
	col1.add_child(UI.label("Basic", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn1 := UIButton.new()
	btn1.text = "Actions  ▾"
	btn1.variant = UIButton.Variant.OUTLINE
	btn1.color_scheme = UIButton.ColorScheme.PRIMARY
	col1.add_child(btn1)

	var dd1 := UIDropdown.new()
	dd1.add_item("Edit", "✎")
	dd1.add_item("Duplicate", "◈")
	dd1.add_item("Archive", "▫")
	dd1.add_separator()
	dd1.add_item("Delete", "✕", Callable(), true)
	dd1.attach(btn1)
	col1.add_child(dd1)

	# With icons and groups
	var col2 := UI.vbox(row, 6)
	col2.add_child(UI.label("Grouped", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn2 := UIButton.new()
	btn2.text = "Navigate  ▾"
	btn2.variant = UIButton.Variant.SOLID
	btn2.color_scheme = UIButton.ColorScheme.SECONDARY
	col2.add_child(btn2)

	var dd2 := UIDropdown.new()
	dd2.add_item("Dashboard", "📊", Callable(), false, "Pages")
	dd2.add_item("Settings", "⚙", Callable(), false, "Pages")
	dd2.add_item("Profile", "👤", Callable(), false, "Pages")
	dd2.add_item("Documentation", "📖", Callable(), false, "Resources")
	dd2.add_item("API Reference", "🔗", Callable(), false, "Resources")
	dd2.attach(btn2)
	col2.add_child(dd2)

	# With feedback
	var col3 := UI.vbox(row, 6)
	col3.add_child(UI.label("With Feedback", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn3 := UIButton.new()
	btn3.text = "Sort By  ▾"
	btn3.variant = UIButton.Variant.OUTLINE
	btn3.color_scheme = UIButton.ColorScheme.NEUTRAL
	col3.add_child(btn3)

	var toast := UIToast.new()
	col3.add_child(toast)

	var dd3 := UIDropdown.new()
	dd3.add_item("Name (A-Z)", "↑")
	dd3.add_item("Name (Z-A)", "↓")
	dd3.add_item("Date Created", "📅")
	dd3.add_item("Last Modified", "🕐")
	dd3.add_item("File Size", "📦")
	dd3.attach(btn3)
	col3.add_child(dd3)

	dd3.item_selected.connect(func(id: String):
		var idx: int = id.split("_")[1].to_int()
		var names := ["Name (A-Z)", "Name (Z-A)", "Date Created", "Last Modified", "File Size"]
		if idx >= 0 and idx < names.size():
			toast.show_toast("Sorted by: %s" % names[idx], UIToast.ToastType.INFO)
	)

	UI.h_expand(row)


# =============================================
# POPOVER
# =============================================

func _popover_section(parent: Control) -> void:
	UI.section(parent, "Popover  (UIPopover)")
	var card_v := UI.card(parent, 24, 20)

	var row := UI.hbox(card_v, 16)

	# 1. Info popover
	var col1 := UI.vbox(row, 6)
	col1.add_child(UI.label("Info Content", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn1 := UIButton.new()
	btn1.text = "User Info"
	btn1.variant = UIButton.Variant.OUTLINE
	btn1.color_scheme = UIButton.ColorScheme.PRIMARY
	col1.add_child(btn1)

	var pop1 := UIPopover.new()
	pop1.attach(btn1)
	pop1.content_builder = func(body: VBoxContainer):
		var header := UI.hbox(body, 10)
		var av := UIAvatar.new()
		av.initials = "JD"
		av.bg_color = UITheme.PRIMARY
		av.avatar_size = UIAvatar.AvatarSize.MD
		av.status = UIAvatar.StatusType.ONLINE
		header.add_child(av)
		var info := UI.vbox(header, 2)
		info.add_child(UI.label("John Doe", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
		info.add_child(UI.label("john@example.com", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
		body.add_child(UI.label("Senior Developer at Acme Corp. Working on UI components and design systems.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	col1.add_child(pop1)

	# 2. Action popover
	var col2 := UI.vbox(row, 6)
	col2.add_child(UI.label("With Actions", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn2 := UIButton.new()
	btn2.text = "Share"
	btn2.variant = UIButton.Variant.SOLID
	btn2.color_scheme = UIButton.ColorScheme.SUCCESS
	col2.add_child(btn2)

	var toast := UIToast.new()
	col2.add_child(toast)

	var pop2 := UIPopover.new()
	pop2.attach(btn2)
	pop2.content_builder = func(body: VBoxContainer):
		body.add_child(UI.label("Share this page", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
		body.add_child(UI.label("Choose how to share:", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
		var actions := UI.vbox(body, 6)
		for item in [["📋  Copy Link", "Link copied!"], ["📧  Email", "Email draft opened!"], ["💬  Slack", "Shared to Slack!"]]:
			var ab := UIButton.new()
			ab.text = item[0]
			ab.variant = UIButton.Variant.GHOST
			ab.color_scheme = UIButton.ColorScheme.NEUTRAL
			actions.add_child(ab)
			var msg: String = item[1]
			ab.pressed.connect(func():
				pop2.hide_popover()
				toast.show_toast(msg, UIToast.ToastType.SUCCESS)
			)
	col2.add_child(pop2)

	# 3. Confirmation popover
	var col3 := UI.vbox(row, 6)
	col3.add_child(UI.label("Confirmation", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var btn3 := UIButton.new()
	btn3.text = "Delete Item"
	btn3.variant = UIButton.Variant.OUTLINE
	btn3.color_scheme = UIButton.ColorScheme.DANGER
	col3.add_child(btn3)

	var toast3 := UIToast.new()
	col3.add_child(toast3)

	var pop3 := UIPopover.new()
	pop3.attach(btn3)
	pop3.popover_width = 280.0
	pop3.content_builder = func(body: VBoxContainer):
		body.add_child(UI.label("Are you sure?", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
		body.add_child(UI.label("This action cannot be undone. The item will be permanently removed.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
		var btn_row := UI.hbox(body, 8)
		UI.h_expand(btn_row)
		var cancel := UIButton.new()
		cancel.text = "Cancel"
		cancel.variant = UIButton.Variant.GHOST
		cancel.color_scheme = UIButton.ColorScheme.NEUTRAL
		cancel.button_size = UIButton.Size.SM
		btn_row.add_child(cancel)
		cancel.pressed.connect(func(): pop3.hide_popover())
		var confirm := UIButton.new()
		confirm.text = "Delete"
		confirm.variant = UIButton.Variant.SOLID
		confirm.color_scheme = UIButton.ColorScheme.DANGER
		confirm.button_size = UIButton.Size.SM
		btn_row.add_child(confirm)
		confirm.pressed.connect(func():
			pop3.hide_popover()
			toast3.show_toast("Item deleted", UIToast.ToastType.SUCCESS)
		)
	col3.add_child(pop3)

	UI.h_expand(row)


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
