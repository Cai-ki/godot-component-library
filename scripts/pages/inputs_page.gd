class_name InputsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Form Inputs",
		"Styled form controls including text fields, selectors, checkboxes, toggles, and sliders.")

	_text_inputs(parent)
	_input_states(parent)
	_textarea_section(parent)
	_select_section(parent)
	_checkbox_section(parent)
	_toggle_section(parent)
	_radio_section(parent)
	_slider_section(parent)


# =============================================
# TEXT INPUTS
# =============================================

func _text_inputs(parent: Control) -> void:
	UI.section(parent, "Text Inputs")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	# Default input
	var v1 := UI.vbox(row, 6)
	v1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v1.add_child(UI.label("Email", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.styled_input(v1, "you@example.com", 0).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# With value
	var v2 := UI.vbox(row, 6)
	v2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v2.add_child(UI.label("Username", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	var input2 := UI.styled_input(v2, "", 0)
	input2.text = "john_doe"
	input2.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Password
	var v3 := UI.vbox(row, 6)
	v3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v3.add_child(UI.label("Password", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	var input3 := UI.styled_input(v3, "Enter password", 0)
	input3.secret = true
	input3.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Disabled
	var v4 := UI.vbox(row, 6)
	v4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v4.add_child(UI.label("Disabled", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var input4 := UI.styled_input(v4, "Disabled input", 0)
	input4.editable = false
	input4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input4.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	input4.add_theme_stylebox_override("read_only", UI.style(
		UITheme.SURFACE_3, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10
	))


# =============================================
# INPUT STATES
# =============================================

func _input_states(parent: Control) -> void:
	UI.section(parent, "Validation States")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	# Normal
	_state_input(row, "Default", "Normal input", Color.TRANSPARENT, "")

	# Success
	_state_input(row, "Success", "Valid input", UITheme.SUCCESS, "✓  Looks good!")

	# Error
	_state_input(row, "Error", "Invalid input", UITheme.DANGER, "✕  This field is required")

	# Warning
	_state_input(row, "Warning", "Check input", UITheme.WARNING, "⚠  This name is already taken")


func _state_input(parent: Control, lbl: String, placeholder: String,
		border_color: Color, hint: String) -> void:
	var v := UI.vbox(parent, 6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(lbl, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var input := UI.styled_input(v, placeholder, 0)
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	if border_color != Color.TRANSPARENT:
		var n := UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, border_color, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
		input.add_theme_stylebox_override("normal", n)
		input.add_theme_stylebox_override("focus", n)

	if hint != "":
		v.add_child(UI.label(hint, UITheme.FONT_XS, border_color))


# =============================================
# TEXTAREA
# =============================================

func _textarea_section(parent: Control) -> void:
	UI.section(parent, "Textarea")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	var v := UI.vbox(row, 6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	v.add_child(UI.label("Description", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var textarea := TextEdit.new()
	textarea.placeholder_text = "Enter your description here..."
	textarea.custom_minimum_size = Vector2(0, 120)
	textarea.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var n := UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var f := UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.PRIMARY, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	textarea.add_theme_stylebox_override("normal", n)
	textarea.add_theme_stylebox_override("focus", f)
	textarea.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	textarea.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
	textarea.add_theme_color_override("caret_color", UITheme.PRIMARY)
	textarea.add_theme_color_override("selection_color", UITheme.PRIMARY_SOFT)
	textarea.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	v.add_child(textarea)

	var hint_row := UI.hbox(v, 0)
	hint_row.add_child(UI.label("Max 500 characters", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	UI.h_expand(hint_row)
	hint_row.add_child(UI.label("0 / 500", UITheme.FONT_XS, UITheme.TEXT_MUTED))

	# Right side: Read-only textarea with value
	var v2 := UI.vbox(row, 6)
	v2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v2.add_child(UI.label("Read Only", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var textarea2 := TextEdit.new()
	textarea2.text = "This is a read-only text area that displays pre-filled content. Users cannot edit this field but can still select and copy the text."
	textarea2.editable = false
	textarea2.custom_minimum_size = Vector2(0, 120)
	textarea2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	textarea2.add_theme_stylebox_override("normal", UI.style(
		UITheme.SURFACE_3, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10
	))
	textarea2.add_theme_stylebox_override("read_only", UI.style(
		UITheme.SURFACE_3, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10
	))
	textarea2.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	textarea2.add_theme_color_override("font_readonly_color", UITheme.TEXT_SECONDARY)
	textarea2.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	v2.add_child(textarea2)


# =============================================
# SELECT / DROPDOWN
# =============================================

func _select_section(parent: Control) -> void:
	UI.section(parent, "Dropdown Select")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	# Default — no selection
	var sel1 := UISelect.new()
	sel1.label_text = "Framework"
	sel1.placeholder = "Choose a framework..."
	sel1.options = ["Godot 4.3", "Godot 4.2", "Godot 4.1", "Godot 3.5", "Unity 6", "Unreal 5"]
	row.add_child(sel1)

	# Pre-selected value
	var sel2 := UISelect.new()
	sel2.label_text = "Region"
	sel2.placeholder = "Select region..."
	sel2.options = ["US East", "US West", "Europe (Frankfurt)", "Asia Pacific", "South America"]
	sel2.selected_index = 0
	row.add_child(sel2)

	# Disabled state
	var sel3 := UISelect.new()
	sel3.label_text = "Plan (Disabled)"
	sel3.placeholder = "Enterprise"
	sel3.options = ["Starter", "Pro", "Enterprise"]
	sel3.selected_index = 2
	sel3.disabled = true
	row.add_child(sel3)


# =============================================
# CHECKBOXES
# =============================================

func _checkbox_section(parent: Control) -> void:
	UI.section(parent, "Checkboxes")
	var card_v := UI.card(parent, 24, 0)
	card_v.add_theme_constant_override("separation", 0)

	var checks := [
		["Accept Terms of Service",  "Required to create an account and use the platform.", false],
		["Subscribe to newsletter",  "Get weekly updates, tips, and community highlights.", true],
		["Enable notifications",     "Receive alerts for new activity and messages.", true],
		["Public profile",           "Allow others to find and view your profile page.", false],
	]

	for i in checks.size():
		var m := MarginContainer.new()
		m.add_theme_constant_override("margin_top", 14)
		m.add_theme_constant_override("margin_bottom", 14)
		card_v.add_child(m)

		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 3)
		m.add_child(v)

		var cb := UICheckbox.new()
		cb.label_text = checks[i][0]
		cb.checked = checks[i][2]
		v.add_child(cb)

		var desc_row := MarginContainer.new()
		desc_row.add_theme_constant_override("margin_left", 30)
		v.add_child(desc_row)
		desc_row.add_child(UI.label(checks[i][1], UITheme.FONT_SM, UITheme.TEXT_MUTED))

		if i < checks.size() - 1:
			UI.sep(card_v, 0)


# =============================================
# TOGGLES
# =============================================

func _toggle_section(parent: Control) -> void:
	UI.section(parent, "Toggle Switches")
	var card_v := UI.card(parent, 24, 0)
	card_v.add_theme_constant_override("separation", 0)

	var toggles := [
		["Dark Mode",       "Switch between light and dark interface themes.", true],
		["Auto Save",       "Automatically save changes every 30 seconds.", true],
		["Analytics",       "Send anonymous usage data to help improve the product.", false],
		["Two Factor Auth", "Add an extra layer of security to your account.", false],
	]

	for i in toggles.size():
		var m := MarginContainer.new()
		m.add_theme_constant_override("margin_top", 14)
		m.add_theme_constant_override("margin_bottom", 14)
		card_v.add_child(m)

		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 16)
		h.alignment = BoxContainer.ALIGNMENT_CENTER
		m.add_child(h)

		var text_v := VBoxContainer.new()
		text_v.add_theme_constant_override("separation", 3)
		text_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(text_v)
		text_v.add_child(UI.label(toggles[i][0], UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
		text_v.add_child(UI.label(toggles[i][1], UITheme.FONT_SM, UITheme.TEXT_MUTED))

		var toggle := UISwitch.new()
		toggle.toggled_on = toggles[i][2]
		h.add_child(toggle)

		if i < toggles.size() - 1:
			UI.sep(card_v, 0)


# =============================================
# RADIO BUTTONS
# =============================================

func _radio_section(parent: Control) -> void:
	UI.section(parent, "Radio Buttons")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 40)

	# Group 1: Default accent
	var v1 := UI.vbox(row, 8)
	v1.add_child(UI.label("Notification Frequency", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.spacer(v1, 4)
	var group1 := UIRadioGroup.new()
	group1.selected_index = 1
	for opt in ["Real-time", "Daily digest", "Weekly summary", "Never"]:
		var r := UIRadio.new()
		r.label_text = opt
		group1.add_radio(r)
	v1.add_child(group1)

	# Group 2: Custom accent colors
	var v2 := UI.vbox(row, 8)
	v2.add_child(UI.label("Priority Level", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.spacer(v2, 4)
	var priorities := [
		["Low",      UITheme.SUCCESS],
		["Medium",   UITheme.WARNING],
		["High",     UITheme.DANGER],
		["Critical", UITheme.DANGER],
	]
	var group2 := UIRadioGroup.new()
	group2.selected_index = 0
	for p in priorities:
		var r := UIRadio.new()
		r.label_text = p[0]
		r.accent_color = p[1]
		group2.add_radio(r)
	v2.add_child(group2)

	# Group 3: With disabled radio
	var v3 := UI.vbox(row, 8)
	v3.add_child(UI.label("Plan (some disabled)", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.spacer(v3, 4)
	var group3 := UIRadioGroup.new()
	group3.selected_index = 0
	var plan_data := [
		["Free",       false],
		["Pro",        false],
		["Enterprise", true],
	]
	for pd in plan_data:
		var r := UIRadio.new()
		r.label_text = pd[0]
		r.disabled = pd[1]
		group3.add_radio(r)
	v3.add_child(group3)

	UI.h_expand(row)


# =============================================
# SLIDERS
# =============================================

func _slider_section(parent: Control) -> void:
	UI.section(parent, "Range Sliders")
	var card_v := UI.card(parent, 24, 20)
	var grid := UI.vbox(card_v, 20)

	_labeled_slider(grid, "Volume", 75, "%")
	_labeled_slider(grid, "Brightness", 50, "%")
	_labeled_slider(grid, "Quality", 3, "", 1, 5, 1)


func _labeled_slider(parent: Control, title: String, value: float, suffix: String,
		min_val: float = 0, max_val: float = 100, step: float = 1) -> void:
	var h := UI.hbox(parent, 16)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	h.add_child(UI.label(title, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))

	var slider := UISlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step
	slider.value = value
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size = Vector2(200, 28)
	h.add_child(slider)

	var value_label := UI.label(str(int(value)) + suffix, UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	value_label.custom_minimum_size.x = 48
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(value_label)

	slider.value_changed.connect(func(v: float):
		value_label.text = str(int(v)) + suffix
	)
