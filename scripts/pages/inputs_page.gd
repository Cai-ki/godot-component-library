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
	_slider_section(parent)


# =============================================
# TEXT INPUTS
# =============================================

func _text_inputs(parent: Control) -> void:
	UI.section(parent, "Text Inputs")
	var row := UI.hbox(parent, 24)

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
	var row := UI.hbox(parent, 24)

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
	var row := UI.hbox(parent, 24)

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
	var row := UI.hbox(parent, 24)

	# Default dropdown
	var v1 := UI.vbox(row, 6)
	v1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v1.add_child(UI.label("Framework", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var select := OptionButton.new()
	select.add_item("Select a framework...")
	select.add_item("Godot 4.3")
	select.add_item("Godot 4.2")
	select.add_item("Godot 4.1")
	select.add_item("Godot 3.5")
	select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	select.focus_mode = Control.FOCUS_NONE

	var n := UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	var h := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_MD, 1, UITheme.BORDER_LIGHT, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	select.add_theme_stylebox_override("normal", n)
	select.add_theme_stylebox_override("hover", h)
	select.add_theme_stylebox_override("pressed", n)
	select.add_theme_stylebox_override("focus", n)
	select.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	select.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	select.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	v1.add_child(select)

	# Second dropdown
	var v2 := UI.vbox(row, 6)
	v2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v2.add_child(UI.label("Region", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var select2 := OptionButton.new()
	select2.add_item("Select region...")
	select2.add_item("US East")
	select2.add_item("US West")
	select2.add_item("Europe")
	select2.add_item("Asia Pacific")
	select2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	select2.focus_mode = Control.FOCUS_NONE
	select2.add_theme_stylebox_override("normal", n.duplicate())
	select2.add_theme_stylebox_override("hover", h.duplicate())
	select2.add_theme_stylebox_override("pressed", n.duplicate())
	select2.add_theme_stylebox_override("focus", n.duplicate())
	select2.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	select2.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	select2.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	v2.add_child(select2)

	# Spacers
	UI.h_expand(row)


# =============================================
# CHECKBOXES
# =============================================

func _checkbox_section(parent: Control) -> void:
	UI.section(parent, "Checkboxes")
	var row := UI.hbox(parent, 32)

	var checks := [
		["Accept Terms of Service", false],
		["Subscribe to newsletter", true],
		["Enable notifications", true],
		["Public profile", false],
	]

	for data in checks:
		var cb := CheckBox.new()
		cb.text = data[0]
		cb.button_pressed = data[1]
		cb.focus_mode = Control.FOCUS_NONE
		cb.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		cb.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
		cb.add_theme_color_override("font_pressed_color", UITheme.TEXT_PRIMARY)
		cb.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		row.add_child(cb)

	UI.h_expand(row)


# =============================================
# TOGGLES
# =============================================

func _toggle_section(parent: Control) -> void:
	UI.section(parent, "Toggle Switches")
	var row := UI.hbox(parent, 32)

	var toggles := [
		["Dark Mode", true],
		["Auto Save", true],
		["Analytics", false],
		["Two Factor Auth", false],
	]

	for data in toggles:
		var toggle := CheckButton.new()
		toggle.text = data[0]
		toggle.button_pressed = data[1]
		toggle.focus_mode = Control.FOCUS_NONE
		toggle.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		toggle.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
		toggle.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		row.add_child(toggle)

	UI.h_expand(row)


# =============================================
# SLIDERS
# =============================================

func _slider_section(parent: Control) -> void:
	UI.section(parent, "Range Sliders")
	var grid := UI.vbox(parent, 20)

	_labeled_slider(grid, "Volume", 75, "%")
	_labeled_slider(grid, "Brightness", 50, "%")
	_labeled_slider(grid, "Quality", 3, "", 1, 5, 1)


func _labeled_slider(parent: Control, title: String, value: float, suffix: String,
		min_val: float = 0, max_val: float = 100, step: float = 1) -> void:
	var h := UI.hbox(parent, 16)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	h.add_child(UI.label(title, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))

	var slider := HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step
	slider.value = value
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size = Vector2(200, 20)

	var track_style := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_SM)
	var fill_style := UI.style(UITheme.PRIMARY, UITheme.RADIUS_SM)
	var grabber_style := StyleBoxFlat.new()
	grabber_style.bg_color = UITheme.PRIMARY
	grabber_style.corner_radius_top_left = UITheme.RADIUS_PILL
	grabber_style.corner_radius_top_right = UITheme.RADIUS_PILL
	grabber_style.corner_radius_bottom_left = UITheme.RADIUS_PILL
	grabber_style.corner_radius_bottom_right = UITheme.RADIUS_PILL
	grabber_style.content_margin_left = 8
	grabber_style.content_margin_right = 8
	grabber_style.content_margin_top = 8
	grabber_style.content_margin_bottom = 8

	var grabber_hover := grabber_style.duplicate()
	grabber_hover.bg_color = UITheme.PRIMARY_LIGHT

	slider.add_theme_stylebox_override("slider", track_style)
	slider.add_theme_stylebox_override("grabber_area", fill_style)
	slider.add_theme_stylebox_override("grabber_area_highlight", fill_style)

	h.add_child(slider)

	var value_label := UI.label(str(int(value)) + suffix, UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	value_label.custom_minimum_size.x = 48
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(value_label)

	slider.value_changed.connect(func(v: float):
		value_label.text = str(int(v)) + suffix
	)
