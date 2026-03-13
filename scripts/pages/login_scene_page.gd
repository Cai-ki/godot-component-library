class_name LoginScenePage
extends RefCounted

var _email: UIInput
var _pass: UIInput
var _remember: UICheckbox
var _sign_in_btn: Button
var _toast: UIToast


func build(parent: Control) -> void:
	UI.page_header(parent, "Login Form",
		"A realistic sign-in page combining UIInput, UIButton, UICheckbox, "
		+ "UIDivider, and UIToast into a cohesive authentication flow.")

	_toast = UIToast.new()
	parent.add_child(_toast)

	_login_card(parent)
	_features(parent)


# =============================================
# LOGIN CARD
# =============================================

func _login_card(parent: Control) -> void:
	# Center the login card
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(center)

	# Card panel
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 420
	panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_1, UITheme.RADIUS_LG,
		1, UITheme.BORDER, 12, Color(0, 0, 0, 0.3), Vector2(0, 6)
	))
	center.add_child(panel)

	# Inner margin
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",   32)
	margin.add_theme_constant_override("margin_right",  32)
	margin.add_theme_constant_override("margin_top",    36)
	margin.add_theme_constant_override("margin_bottom", 36)
	panel.add_child(margin)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 20)
	margin.add_child(v)

	_header_section(v)
	_form_section(v)
	_divider_section(v)
	_social_section(v)
	_footer_section(v)


func _header_section(parent: Control) -> void:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	parent.add_child(v)

	# Icon
	var icon_panel := PanelContainer.new()
	icon_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.PRIMARY_SOFT, UITheme.RADIUS_MD,
		0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 12
	))
	v.add_child(icon_panel)
	var cc := CenterContainer.new()
	icon_panel.add_child(cc)
	cc.add_child(UI.label("⊡", UITheme.FONT_2XL, UITheme.PRIMARY))

	# Title + subtitle
	var title := UI.label("Sign in to your account", UITheme.FONT_XL, UITheme.TEXT_PRIMARY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(title)

	var sub := UI.label("Enter your credentials to continue", UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(sub)


func _form_section(parent: Control) -> void:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 16)
	parent.add_child(v)

	# Email
	_email = UIInput.new()
	_email.label_text = "Email"
	_email.placeholder = "you@example.com"
	v.add_child(_email)
	_email.text_changed.connect(_validate_email)

	# Password
	_pass = UIInput.new()
	_pass.label_text = "Password"
	_pass.placeholder = "Min 6 characters"
	_pass.password = true
	v.add_child(_pass)
	_pass.text_changed.connect(_validate_password)

	# Remember me + Forgot password
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	v.add_child(row)

	_remember = UICheckbox.new()
	_remember.label_text = "Remember me"
	row.add_child(_remember)

	UI.h_expand(row)

	var forgot := UI.ghost_btn(row, "Forgot password?", UITheme.PRIMARY,
		UITheme.RADIUS_SM, 8, 6, UITheme.FONT_SM)
	forgot.pressed.connect(func():
		_toast.show_toast("Password reset link sent to your email.", UIToast.ToastType.INFO, 3.0)
	)

	# Sign In button
	_sign_in_btn = UI.solid_btn(v, "Sign In  →", UITheme.PRIMARY,
		Color.WHITE, UITheme.RADIUS_MD, 24, 14, UITheme.FONT_BASE)
	_sign_in_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_sign_in_btn.pressed.connect(_on_sign_in)


func _divider_section(parent: Control) -> void:
	var div := UIDivider.new()
	div.divider_label = "or continue with"
	parent.add_child(div)


func _social_section(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	parent.add_child(row)

	for provider in ["◉  Google", "◈  GitHub", "◇  Twitter"]:
		var btn := UI.outline_btn(row, provider, UITheme.BORDER_LIGHT,
			UITheme.RADIUS_MD, 16, 10, UITheme.FONT_SM)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
		btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
		btn.pressed.connect(func():
			_toast.show_toast("Social login is not implemented in this demo.", UIToast.ToastType.INFO, 2.5)
		)


func _footer_section(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(row)

	row.add_child(UI.label("Don't have an account?", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var signup := UI.ghost_btn(row, "Sign up", UITheme.PRIMARY,
		UITheme.RADIUS_SM, 6, 4, UITheme.FONT_SM)
	signup.pressed.connect(func():
		_toast.show_toast("Registration page coming soon!", UIToast.ToastType.INFO, 2.5)
	)


# =============================================
# VALIDATION
# =============================================

func _validate_email(t: String) -> void:
	if t.is_empty():
		_email.validation_state = UIInput.State.DEFAULT
		_email.hint_text = ""
	elif not t.contains("@") or not t.contains("."):
		_email.validation_state = UIInput.State.ERROR
		_email.hint_text = "✕  Please enter a valid email address"
	else:
		_email.validation_state = UIInput.State.SUCCESS
		_email.hint_text = "✓  Looks good"


func _validate_password(t: String) -> void:
	if t.is_empty():
		_pass.validation_state = UIInput.State.DEFAULT
		_pass.hint_text = ""
	elif t.length() < 6:
		_pass.validation_state = UIInput.State.WARNING
		_pass.hint_text = "⚠  At least 6 characters required"
	else:
		_pass.validation_state = UIInput.State.SUCCESS
		_pass.hint_text = "✓  Password strength OK"


# =============================================
# SIGN IN LIFECYCLE
# =============================================

func _on_sign_in() -> void:
	# Validate before submit
	if _email.text.is_empty() or _pass.text.is_empty():
		_toast.show_toast("Please fill in all fields.", UIToast.ToastType.WARNING, 2.5)
		return
	if _email.validation_state == UIInput.State.ERROR:
		_toast.show_toast("Please fix the errors before submitting.", UIToast.ToastType.ERROR, 2.5)
		return
	if _pass.validation_state == UIInput.State.WARNING:
		_toast.show_toast("Password is too short.", UIToast.ToastType.ERROR, 2.5)
		return

	# Loading state
	_sign_in_btn.text = "⟳  Signing in..."
	_sign_in_btn.disabled = true
	_email.disabled = true
	_pass.disabled = true

	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 1.5
	_sign_in_btn.add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		_toast.show_toast("Welcome back! Login successful.", UIToast.ToastType.SUCCESS, 4.0)
		_reset_form()
		timer.queue_free()
	)


func _reset_form() -> void:
	_email.text = ""
	_email.validation_state = UIInput.State.DEFAULT
	_email.hint_text = ""
	_email.disabled = false

	_pass.text = ""
	_pass.validation_state = UIInput.State.DEFAULT
	_pass.hint_text = ""
	_pass.disabled = false

	_remember.checked = false
	_sign_in_btn.text = "Sign In  →"
	_sign_in_btn.disabled = false


# =============================================
# FEATURES REFERENCE
# =============================================

func _features(parent: Control) -> void:
	UI.section(parent, "Components Used")
	var card_v := UI.card(parent, 24, 20)

	var items: Array = [
		["UIInput",    "Email & password fields with real-time validation",  UITheme.PRIMARY],
		["UIButton",   "Primary sign-in button with loading state",         UITheme.SUCCESS],
		["UICheckbox", "Remember me toggle",                                UITheme.INFO],
		["UIDivider",  "\"or continue with\" separator",                    UITheme.WARNING],
		["UIToast",    "Success / error notifications",                     UITheme.DANGER],
		["Ghost Btn",  "Forgot password & sign up links",                   UITheme.SECONDARY],
	]

	# 2-column grid: each item is a mini hoverable card
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(grid)

	for item: Array in items:
		var name_str: String = item[0]
		var desc_str: String = item[1]
		var accent: Color = item[2]

		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.add_theme_stylebox_override("panel", UI.style(
			UITheme.SURFACE_2, UITheme.RADIUS_MD,
			1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 10
		))
		grid.add_child(chip)

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		chip.add_child(row)

		# Accent dot
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(6, 6)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.add_theme_stylebox_override("panel", UI.style(accent, UITheme.RADIUS_PILL))
		row.add_child(dot)

		# Text
		var tv := VBoxContainer.new()
		tv.add_theme_constant_override("separation", 2)
		tv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(tv)
		tv.add_child(UI.label(name_str, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
		var desc := UI.label(desc_str, UITheme.FONT_XS, UITheme.TEXT_MUTED)
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD
		tv.add_child(desc)
