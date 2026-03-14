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
	_number_input_section(parent)
	_segmented_control_section(parent)
	_rating_section(parent)


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

	# Editable with counter
	var v1 := UI.vbox(row, 0)
	v1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ta1 := UITextArea.new()
	ta1.label_text = "Description"
	ta1.placeholder = "Enter your description here..."
	ta1.max_length = 500
	ta1.show_counter = true
	ta1.hint_text = "Max 500 characters"
	v1.add_child(ta1)

	# Read-only with prefilled content
	var v2 := UI.vbox(row, 0)
	v2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ta2 := UITextArea.new()
	ta2.label_text = "Read Only"
	ta2.readonly = true
	v2.add_child(ta2)
	ta2.text = "This is a read-only text area that displays pre-filled content. Users cannot edit this field but can still select and copy the text."

	# Second row: validation states
	var row2 := UI.hbox(card_v, 24)

	var v3 := UI.vbox(row2, 0)
	v3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ta3 := UITextArea.new()
	ta3.label_text = "Bio (Success)"
	ta3.placeholder = "Tell us about yourself..."
	ta3.validation_state = UITextArea.State.SUCCESS
	ta3.hint_text = "✓  Looks great!"
	ta3.show_counter = true
	ta3.max_length = 200
	ta3.min_lines = 3
	v3.add_child(ta3)
	ta3.text = "Godot enthusiast building UI components."

	var v4 := UI.vbox(row2, 0)
	v4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ta4 := UITextArea.new()
	ta4.label_text = "Notes (Error)"
	ta4.placeholder = "Add notes..."
	ta4.validation_state = UITextArea.State.ERROR
	ta4.hint_text = "✕  This field is required"
	ta4.min_lines = 3
	v4.add_child(ta4)

	var v5 := UI.vbox(row2, 0)
	v5.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ta5 := UITextArea.new()
	ta5.label_text = "Disabled"
	ta5.disabled = true
	ta5.min_lines = 3
	v5.add_child(ta5)
	ta5.text = "This textarea is disabled."


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


# =============================================
# NUMBER INPUTS
# =============================================

func _number_input_section(parent: Control) -> void:
	UI.section(parent, "Number Inputs")
	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	# Basic
	var v1 := UI.vbox(row, 6)
	v1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ni1 := UINumberInput.new()
	ni1.label_text = "Quantity"
	ni1.value = 5.0
	ni1.min_value = 0.0
	ni1.max_value = 99.0
	v1.add_child(ni1)

	# With prefix/suffix
	var v2 := UI.vbox(row, 6)
	v2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ni2 := UINumberInput.new()
	ni2.label_text = "Price"
	ni2.value = 29.99
	ni2.min_value = 0.0
	ni2.max_value = 9999.0
	ni2.step = 0.01
	ni2.prefix = "¥"
	v2.add_child(ni2)

	# Decimal step
	var v3 := UI.vbox(row, 6)
	v3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ni3 := UINumberInput.new()
	ni3.label_text = "Opacity"
	ni3.value = 0.5
	ni3.min_value = 0.0
	ni3.max_value = 1.0
	ni3.step = 0.1
	ni3.suffix = ""
	v3.add_child(ni3)

	# Disabled
	var v4 := UI.vbox(row, 6)
	v4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ni4 := UINumberInput.new()
	ni4.label_text = "Locked"
	ni4.value = 42.0
	ni4.disabled = true
	v4.add_child(ni4)


# =============================================
# SEGMENTED CONTROL
# =============================================

func _segmented_control_section(parent: Control) -> void:
	UI.section(parent, "Segmented Control")
	var card_v := UI.card(parent, 24, 20)

	# Row 1: three sizes side by side, all full_width within their column
	card_v.add_child(UI.label("Sizes", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var row1 := UI.hbox(card_v, 16)

	var col1 := UI.vbox(row1, 4)
	col1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col1.add_child(UI.label("Small", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var seg_sm := UISegmentedControl.new()
	seg_sm.items = PackedStringArray(["S", "M", "L", "XL"])
	seg_sm.selected_index = 1
	seg_sm.control_size = UISegmentedControl.Size.SM
	seg_sm.full_width = true
	col1.add_child(seg_sm)

	var col2 := UI.vbox(row1, 4)
	col2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col2.add_child(UI.label("Medium (default)", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var seg_md := UISegmentedControl.new()
	seg_md.items = PackedStringArray(["Day", "Week", "Month", "Year"])
	seg_md.selected_index = 0
	seg_md.full_width = true
	col2.add_child(seg_md)

	var col3 := UI.vbox(row1, 4)
	col3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col3.add_child(UI.label("Large", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var seg_lg := UISegmentedControl.new()
	seg_lg.items = PackedStringArray(["Overview", "Analytics", "Reports"])
	seg_lg.selected_index = 2
	seg_lg.control_size = UISegmentedControl.Size.LG
	seg_lg.full_width = true
	col3.add_child(seg_lg)

	UI.spacer(card_v, 8)

	# Row 2: full width
	card_v.add_child(UI.label("Full Width", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var seg_full := UISegmentedControl.new()
	seg_full.items = PackedStringArray(["All", "Active", "Completed", "Archived"])
	seg_full.selected_index = 0
	seg_full.full_width = true
	card_v.add_child(seg_full)

	UI.spacer(card_v, 8)

	# Row 3: disabled + interactive side by side
	var row3 := UI.hbox(card_v, 16)

	var col_dis := UI.vbox(row3, 4)
	col_dis.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col_dis.add_child(UI.label("Disabled", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var seg_dis := UISegmentedControl.new()
	seg_dis.items = PackedStringArray(["On", "Off"])
	seg_dis.selected_index = 0
	seg_dis.disabled = true
	seg_dis.full_width = true
	col_dis.add_child(seg_dis)

	var col_int := UI.vbox(row3, 4)
	col_int.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col_int.add_child(UI.label("Interactive", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var seg_interactive := UISegmentedControl.new()
	seg_interactive.items = PackedStringArray(["List", "Grid", "Table"])
	seg_interactive.selected_index = 0
	seg_interactive.full_width = true
	col_int.add_child(seg_interactive)

	var view_label := Label.new()
	view_label.text = "→ Currently showing: List view"
	view_label.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	view_label.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	col_int.add_child(view_label)

	seg_interactive.selection_changed.connect(func(_i: int):
		view_label.text = "→ Currently showing: %s view" % seg_interactive.get_selected_text()
	)


# =============================================
# RATING
# =============================================

func _rating_section(parent: Control) -> void:
	UI.section(parent, "Star Rating")
	var card_v := UI.card(parent, 24, 20)

	# Row 1: sizes
	card_v.add_child(UI.label("Sizes", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var row1 := UI.hbox(card_v, 32)

	var col_sm := UI.vbox(row1, 4)
	col_sm.add_child(UI.label("Small", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var r_sm := UIRating.new()
	r_sm.value = 3.0
	r_sm.star_size = UIRating.Size.SM
	col_sm.add_child(r_sm)

	var col_md := UI.vbox(row1, 4)
	col_md.add_child(UI.label("Medium", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var r_md := UIRating.new()
	r_md.value = 4.0
	col_md.add_child(r_md)

	var col_lg := UI.vbox(row1, 4)
	col_lg.add_child(UI.label("Large", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var r_lg := UIRating.new()
	r_lg.value = 3.5
	r_lg.star_size = UIRating.Size.LG
	col_lg.add_child(r_lg)

	var col_xl := UI.vbox(row1, 4)
	col_xl.add_child(UI.label("XL", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	var r_xl := UIRating.new()
	r_xl.value = 4.5
	r_xl.star_size = UIRating.Size.XL
	col_xl.add_child(r_xl)

	UI.spacer(card_v, 8)

	# Row 2: features
	var row2 := UI.hbox(card_v, 32)

	# Half star with label
	var col_half := UI.vbox(row2, 4)
	col_half.add_child(UI.label("Half Stars + Value", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r_half := UIRating.new()
	r_half.value = 3.5
	r_half.half_stars = true
	r_half.show_value_label = true
	r_half.star_size = UIRating.Size.LG
	col_half.add_child(r_half)

	# Readonly
	var col_ro := UI.vbox(row2, 4)
	col_ro.add_child(UI.label("Readonly", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r_ro := UIRating.new()
	r_ro.value = 4.0
	r_ro.readonly = true
	r_ro.show_value_label = true
	r_ro.star_size = UIRating.Size.LG
	col_ro.add_child(r_ro)

	# Custom color
	var col_custom := UI.vbox(row2, 4)
	col_custom.add_child(UI.label("Custom Color", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r_custom := UIRating.new()
	r_custom.value = 4.0
	r_custom.accent_color = UITheme.DANGER
	r_custom.star_size = UIRating.Size.LG
	col_custom.add_child(r_custom)

	UI.spacer(card_v, 8)

	# Interactive feedback
	card_v.add_child(UI.label("Interactive", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var int_row := UI.hbox(card_v, 16)
	int_row.alignment = BoxContainer.ALIGNMENT_CENTER

	var r_interactive := UIRating.new()
	r_interactive.value = 0.0
	r_interactive.star_size = UIRating.Size.XL
	r_interactive.show_value_label = true
	int_row.add_child(r_interactive)

	var feedback_lbl := Label.new()
	feedback_lbl.text = "Click to rate"
	feedback_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	feedback_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	int_row.add_child(feedback_lbl)

	r_interactive.rating_changed.connect(func(v: float):
		var messages := {1.0: "Poor", 1.5: "Below Average", 2.0: "Fair", 2.5: "Average",
			3.0: "Good", 3.5: "Above Average", 4.0: "Great", 4.5: "Excellent", 5.0: "Outstanding!"}
		var key := snappedf(v, 0.5)
		feedback_lbl.text = messages.get(key, "%.1f stars" % v)
		feedback_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	)
