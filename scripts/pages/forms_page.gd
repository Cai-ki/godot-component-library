class_name FormsPage
extends RefCounted

# Per-field state: {input, hint, valid}
var _fields: Dictionary = {}
var _terms_cb: CheckBox
var _submit_btn: Button
var _toast: UIToast


func build(parent: Control) -> void:
	UI.page_header(parent, "Form Validation",
		"Real-time validation, state-driven error hints, and full submit lifecycle "
		+ "— copy this pattern for any form in your project.")

	_toast = UIToast.new()
	parent.add_child(_toast)

	_registration_form(parent)
	_validation_reference(parent)


# =============================================
# REGISTRATION FORM
# =============================================

func _registration_form(parent: Control) -> void:
	UI.section(parent, "Registration Form")
	var card_v := UI.card(parent, 32, 28)

	card_v.add_child(UI.label("Create Account", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	card_v.add_child(UI.label(
		"Fill in your details below to get started.",
		UITheme.FONT_SM, UITheme.TEXT_SECONDARY
	))
	UI.sep(card_v, 4)

	# Row 1: Username + Email
	var row1 := UI.hbox(card_v, 20)
	_make_field(row1, "username", "Username",          "e.g. john_doe")
	_make_field(row1, "email",    "Email",             "you@example.com")

	# Row 2: Password + Confirm
	var row2 := UI.hbox(card_v, 20)
	_make_field(row2, "password", "Password",          "Min 8 characters")
	_make_field(row2, "confirm",  "Confirm Password",  "Repeat your password")
	(_fields["password"]["input"] as LineEdit).secret = true
	(_fields["confirm"]["input"]  as LineEdit).secret = true

	# Terms
	var terms_row := UI.hbox(card_v, 10)
	terms_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_terms_cb = CheckBox.new()
	_terms_cb.focus_mode = Control.FOCUS_NONE
	terms_row.add_child(_terms_cb)
	terms_row.add_child(UI.label(
		"I agree to the Terms of Service and Privacy Policy",
		UITheme.FONT_MD, UITheme.TEXT_PRIMARY
	))
	_terms_cb.toggled.connect(func(_v): _check_submit())

	UI.spacer(card_v, 4)

	# Submit
	_submit_btn = UI.solid_btn(card_v, "Create Account  →",
		UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 24, 14, UITheme.FONT_BASE)
	_submit_btn.disabled = true
	_submit_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_submit_btn.pressed.connect(_on_submit)

	# Connect validators
	(_fields["username"]["input"] as LineEdit).text_changed.connect(_validate_username)
	(_fields["email"]["input"]    as LineEdit).text_changed.connect(_validate_email)
	(_fields["password"]["input"] as LineEdit).text_changed.connect(_validate_password)
	(_fields["confirm"]["input"]  as LineEdit).text_changed.connect(_validate_confirm)


func _make_field(parent: Control, key: String, label_text: String, placeholder: String) -> void:
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_theme_constant_override("separation", 6)
	parent.add_child(v)

	v.add_child(UI.label(label_text, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var input := UI.styled_input(v, placeholder, 0)
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var hint := UI.label("", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	v.add_child(hint)

	_fields[key] = {"input": input, "hint": hint, "valid": false}


# =============================================
# VALIDATORS
# =============================================

func _validate_username(text: String) -> void:
	if text.is_empty():
		_set_state("username", "neutral", "")
	elif text.length() < 3:
		_set_state("username", "error", "✕  Minimum 3 characters required")
	elif not text.is_valid_identifier():
		_set_state("username", "error", "✕  Letters, numbers and _ only")
	else:
		_set_state("username", "success", "✓  Username looks good")


func _validate_email(text: String) -> void:
	if text.is_empty():
		_set_state("email", "neutral", "")
	elif not text.contains("@") or not text.contains("."):
		_set_state("email", "error", "✕  Enter a valid email address")
	else:
		_set_state("email", "success", "✓  Email looks good")


func _validate_password(text: String) -> void:
	if text.is_empty():
		_set_state("password", "neutral", "")
	elif text.length() < 8:
		_set_state("password", "warning", "⚠  Minimum 8 characters")
	else:
		_set_state("password", "success", "✓  Strong enough")
	# Re-run confirm validation whenever password changes
	_validate_confirm((_fields["confirm"]["input"] as LineEdit).text)


func _validate_confirm(text: String) -> void:
	var pw: String = (_fields["password"]["input"] as LineEdit).text
	if text.is_empty():
		_set_state("confirm", "neutral", "")
	elif text != pw:
		_set_state("confirm", "error", "✕  Passwords do not match")
	else:
		_set_state("confirm", "success", "✓  Passwords match")


func _set_state(key: String, state: String, hint_text: String) -> void:
	var input := _fields[key]["input"] as LineEdit
	var hint  := _fields[key]["hint"]  as Label
	_fields[key]["valid"] = (state == "success")
	_apply_visual(input, hint, state, hint_text)
	_check_submit()


func _apply_visual(input: LineEdit, hint: Label, state: String, hint_text: String) -> void:
	hint.text = hint_text
	var normal_s: StyleBoxFlat
	var focus_s:  StyleBoxFlat
	match state:
		"success":
			hint.add_theme_color_override("font_color", UITheme.SUCCESS)
			normal_s = UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.SUCCESS, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
			focus_s  = normal_s.duplicate()
		"error":
			hint.add_theme_color_override("font_color", UITheme.DANGER)
			normal_s = UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.DANGER,  0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
			focus_s  = normal_s.duplicate()
		"warning":
			hint.add_theme_color_override("font_color", UITheme.WARNING)
			normal_s = UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.WARNING, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
			focus_s  = normal_s.duplicate()
		_:
			hint.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
			normal_s = UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 1, UITheme.BORDER,   0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
			focus_s  = UI.style(UITheme.SURFACE_2, UITheme.RADIUS_MD, 2, UITheme.PRIMARY,  0, Color.TRANSPARENT, Vector2.ZERO, 12, 10)
	input.add_theme_stylebox_override("normal", normal_s)
	input.add_theme_stylebox_override("focus",  focus_s)


func _check_submit() -> void:
	_submit_btn.disabled = not (
		_fields["username"]["valid"] and
		_fields["email"]["valid"]    and
		_fields["password"]["valid"] and
		_fields["confirm"]["valid"]  and
		_terms_cb.button_pressed
	)


# =============================================
# SUBMIT LIFECYCLE
# =============================================

func _on_submit() -> void:
	_submit_btn.text    = "⟳  Creating account..."
	_submit_btn.disabled = true
	for key in _fields:
		(_fields[key]["input"] as LineEdit).editable = false

	var timer := Timer.new()
	timer.one_shot  = true
	timer.wait_time = 1.5
	_submit_btn.add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		_toast.show_toast("Account created! Welcome aboard.", UIToast.ToastType.SUCCESS, 4.0)
		_reset_form()
		timer.queue_free()
	)


func _reset_form() -> void:
	for key in _fields:
		var input := _fields[key]["input"] as LineEdit
		input.text     = ""
		input.editable = true
		_apply_visual(input, _fields[key]["hint"], "neutral", "")
		_fields[key]["valid"] = false
	_terms_cb.button_pressed = false
	_submit_btn.text         = "Create Account  →"
	_submit_btn.disabled     = true


# =============================================
# VALIDATION STATE REFERENCE
# =============================================

func _validation_reference(parent: Control) -> void:
	UI.section(parent, "Validation State Reference")
	var card_v := UI.card(parent, 32, 24)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 16)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(grid)

	_ref_field(grid, "Default",  "neutral",  "")
	_ref_field(grid, "Success",  "success",  "✓  Validation passed")
	_ref_field(grid, "Error",    "error",    "✕  This field is required")
	_ref_field(grid, "Warning",  "warning",  "⚠  Value already in use")


func _ref_field(parent: Control, label_text: String, state: String, hint_text: String) -> void:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(v)

	v.add_child(UI.label(label_text, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var input := UI.styled_input(v, "Sample input", 0)
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var hint := UI.label(hint_text, UITheme.FONT_XS, UITheme.TEXT_MUTED)
	v.add_child(hint)

	# Apply visual directly — bypasses _fields/_check_submit
	_apply_visual(input, hint, state, hint_text)
