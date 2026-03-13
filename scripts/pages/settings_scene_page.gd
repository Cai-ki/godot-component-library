class_name SettingsScenePage
extends RefCounted

var _toast: UIToast
var _display_name: UIInput
var _profile_email: UIInput
var _phone: UIInput
var _location: UIInput
var _bio: UIInput


func build(parent: Control) -> void:
	UI.page_header(parent, "Settings",
		"A realistic settings page combining UITabs, UISwitch, UISelect, UIRadioGroup, "
		+ "UIInput, and UIAvatar into a complete application preferences interface.")

	_toast = UIToast.new()
	parent.add_child(_toast)

	var tabs := UITabs.new()
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(tabs)

	tabs.add_tab("General",       _build_general())
	tabs.add_tab("Notifications", _build_notifications())
	tabs.add_tab("Profile",       _build_profile())

	# Set initial values after nodes are in the scene tree (_ready → _input created)
	_display_name.text = "Jordan Smith"
	_profile_email.text = "jordan@example.com"
	_phone.text = "+1 (555) 123-4567"
	_location.text = "San Francisco, CA"

	_features(parent)


# =============================================
# TAB 1: GENERAL
# =============================================

func _build_general() -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	UI.spacer(v, 16)

	var card_v := UI.card(v, 24, 20)

	# — Application ————————————————————————
	_sub_label(card_v, "Application")
	UI.spacer(card_v, 12)

	var lang_sel := UISelect.new()
	lang_sel.options = PackedStringArray(["English", "Chinese", "Japanese", "Korean"])
	lang_sel.selected_index = 0
	lang_sel.custom_minimum_size.x = 200
	_setting_row(card_v, "Language", "Display language for the application", lang_sel)

	UI.spacer(card_v, 16)

	var theme_group := UIRadioGroup.new()
	for t: String in ["Light", "Dark", "System"]:
		var r := UIRadio.new()
		r.label_text = t
		theme_group.add_radio(r)
	theme_group.selected_index = 1
	_setting_row(card_v, "Theme", "Choose your preferred appearance", theme_group)

	UI.spacer(card_v, 16)

	var tz_sel := UISelect.new()
	tz_sel.options = PackedStringArray([
		"UTC-8  (Pacific)", "UTC-6  (Central)", "UTC-5  (Eastern)",
		"UTC+0  (GMT)", "UTC+1  (CET)", "UTC+8  (CST)", "UTC+9  (JST)"
	])
	tz_sel.selected_index = 3
	tz_sel.custom_minimum_size.x = 200
	_setting_row(card_v, "Timezone", "Your local timezone for dates and times", tz_sel)

	UI.spacer(card_v, 24)
	card_v.add_child(UIDivider.new())
	UI.spacer(card_v, 20)

	# — Behavior ————————————————————————
	_sub_label(card_v, "Behavior")
	UI.spacer(card_v, 12)

	var sw1 := UISwitch.new()
	sw1.toggled_on = true
	_setting_row(card_v, "Auto-save", "Automatically save changes as you work", sw1)

	UI.spacer(card_v, 16)

	var sw2 := UISwitch.new()
	sw2.toggled_on = true
	_setting_row(card_v, "Show welcome page", "Display welcome page on application startup", sw2)

	UI.spacer(card_v, 16)

	var sw3 := UISwitch.new()
	_setting_row(card_v, "Compact mode", "Use condensed UI layout to fit more content", sw3)

	return v


# =============================================
# TAB 2: NOTIFICATIONS
# =============================================

func _build_notifications() -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	UI.spacer(v, 16)

	var card_v := UI.card(v, 24, 20)

	# — Email —————————————————————————————
	_sub_label(card_v, "Email Notifications")
	UI.spacer(card_v, 12)

	var sw1 := UISwitch.new()
	_setting_row(card_v, "Marketing emails", "Receive promotional offers and newsletters", sw1)

	UI.spacer(card_v, 16)

	var sw2 := UISwitch.new()
	sw2.toggled_on = true
	_setting_row(card_v, "Security alerts", "Get notified about unusual account activity", sw2)

	UI.spacer(card_v, 16)

	var sw3 := UISwitch.new()
	_setting_row(card_v, "Product updates", "News about new features and improvements", sw3)

	UI.spacer(card_v, 24)
	card_v.add_child(UIDivider.new())
	UI.spacer(card_v, 20)

	# — Push —————————————————————————————
	_sub_label(card_v, "Push Notifications")
	UI.spacer(card_v, 12)

	var sw4 := UISwitch.new()
	sw4.toggled_on = true
	_setting_row(card_v, "Desktop notifications", "Show system notifications on your desktop", sw4)

	UI.spacer(card_v, 16)

	var sw5 := UISwitch.new()
	sw5.toggled_on = true
	_setting_row(card_v, "Sound", "Play sound for incoming notifications", sw5)

	UI.spacer(card_v, 16)

	var freq_sel := UISelect.new()
	freq_sel.options = PackedStringArray(["Instant", "Hourly", "Daily"])
	freq_sel.selected_index = 0
	freq_sel.custom_minimum_size.x = 160
	_setting_row(card_v, "Frequency", "How often to batch and deliver notifications", freq_sel)

	return v


# =============================================
# TAB 3: PROFILE
# =============================================

func _build_profile() -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	UI.spacer(v, 16)

	var card_v := UI.card(v, 24, 20)

	# — Avatar row ————————————————————————
	var avatar_row := HBoxContainer.new()
	avatar_row.add_theme_constant_override("separation", 20)
	card_v.add_child(avatar_row)

	var avatar := UIAvatar.new()
	avatar.initials = "JS"
	avatar.bg_color = UITheme.PRIMARY
	avatar.avatar_size = UIAvatar.AvatarSize.XL
	avatar.status = UIAvatar.StatusType.ONLINE
	avatar_row.add_child(avatar)

	var info_v := VBoxContainer.new()
	info_v.add_theme_constant_override("separation", 4)
	info_v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	avatar_row.add_child(info_v)

	info_v.add_child(UI.label("Jordan Smith", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))
	info_v.add_child(UI.label("jordan@example.com", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.spacer(info_v, 4)

	var ch_btn := UI.outline_btn(info_v, "Change Avatar", UITheme.BORDER_LIGHT,
		UITheme.RADIUS_MD, 14, 8, UITheme.FONT_SM)
	ch_btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	ch_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	ch_btn.pressed.connect(func():
		_toast.show_toast("Avatar upload is not implemented in this demo.", UIToast.ToastType.INFO, 2.5)
	)

	UI.spacer(card_v, 20)
	card_v.add_child(UIDivider.new())
	UI.spacer(card_v, 20)

	# — Personal Info ——————————————————————
	_sub_label(card_v, "Personal Info")
	UI.spacer(card_v, 12)

	var row1 := UI.hbox(card_v, 16)
	_display_name = UIInput.new()
	_display_name.label_text = "Display Name"
	_display_name.placeholder = "Your display name"
	row1.add_child(_display_name)

	_profile_email = UIInput.new()
	_profile_email.label_text = "Email"
	_profile_email.placeholder = "your@email.com"
	row1.add_child(_profile_email)

	UI.spacer(card_v, 12)

	var row2 := UI.hbox(card_v, 16)
	_phone = UIInput.new()
	_phone.label_text = "Phone"
	_phone.placeholder = "+1 (555) 000-0000"
	row2.add_child(_phone)

	_location = UIInput.new()
	_location.label_text = "Location"
	_location.placeholder = "City, Country"
	row2.add_child(_location)

	UI.spacer(card_v, 20)
	card_v.add_child(UIDivider.new())
	UI.spacer(card_v, 20)

	# — Bio ————————————————————————————————
	_sub_label(card_v, "Bio")
	UI.spacer(card_v, 12)

	_bio = UIInput.new()
	_bio.label_text = "About"
	_bio.placeholder = "Tell us about yourself..."
	card_v.add_child(_bio)

	UI.spacer(card_v, 24)

	# — Action buttons ————————————————————
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 12)
	btn_row.alignment = BoxContainer.ALIGNMENT_END
	card_v.add_child(btn_row)

	var cancel_btn := UI.ghost_btn(btn_row, "Cancel", UITheme.TEXT_SECONDARY,
		UITheme.RADIUS_MD, 20, 10, UITheme.FONT_BASE)
	cancel_btn.pressed.connect(func():
		_display_name.text = "Jordan Smith"
		_profile_email.text = "jordan@example.com"
		_phone.text = "+1 (555) 123-4567"
		_location.text = "San Francisco, CA"
		_bio.text = ""
		_toast.show_toast("Changes discarded.", UIToast.ToastType.INFO, 2.0)
	)

	var save_btn := UI.solid_btn(btn_row, "Save Changes", UITheme.PRIMARY,
		Color.WHITE, UITheme.RADIUS_MD, 20, 10, UITheme.FONT_BASE)
	save_btn.pressed.connect(func():
		_toast.show_toast("Profile saved successfully!", UIToast.ToastType.SUCCESS, 3.0)
	)

	return v


# =============================================
# HELPER — SETTING ROW
# =============================================

## Renders a label+description on the left, control on the right.
func _setting_row(parent: Control, lbl: String, desc: String, control: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(row)

	var text_v := VBoxContainer.new()
	text_v.add_theme_constant_override("separation", 2)
	text_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_v)

	text_v.add_child(UI.label(lbl, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	text_v.add_child(UI.label(desc, UITheme.FONT_XS, UITheme.TEXT_MUTED))

	control.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(control)
	# Prevent controls (e.g. UISelect) from expanding to fill all horizontal space
	control.size_flags_horizontal = Control.SIZE_SHRINK_END


func _sub_label(parent: Control, text: String) -> void:
	var lbl := UI.label(text.to_upper(), UITheme.FONT_XS, UITheme.TEXT_MUTED)
	parent.add_child(lbl)


# =============================================
# COMPONENTS USED REFERENCE
# =============================================

func _features(parent: Control) -> void:
	UI.section(parent, "Components Used")
	var card_v := UI.card(parent, 24, 20)

	var items: Array = [
		["UITabs",       "Three-tab navigation (General / Notifications / Profile)", UITheme.PRIMARY],
		["UISwitch",     "8 toggle switches across General and Notifications tabs",  UITheme.SUCCESS],
		["UISelect",     "Language, Timezone, and Frequency dropdown selectors",     UITheme.INFO],
		["UIRadioGroup", "Theme preference selection (Light / Dark / System)",       UITheme.WARNING],
		["UIInput",      "Display name, email, phone, location, and bio fields",    UITheme.DANGER],
		["UIAvatar",     "Profile picture with online status indicator",             UITheme.SECONDARY],
		["UIDivider",    "Section separators within each settings panel",            UITheme.PRIMARY_SOFT],
		["UIToast",      "Save confirmation and action feedback toasts",             UITheme.SUCCESS],
	]

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(grid)

	for item: Array in items:
		var name_str: String = item[0]
		var desc_str: String = item[1]
		var accent: Color   = item[2]

		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.add_theme_stylebox_override("panel", UI.style(
			UITheme.SURFACE_2, UITheme.RADIUS_MD,
			1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 10
		))
		grid.add_child(chip)

		var chip_row := HBoxContainer.new()
		chip_row.add_theme_constant_override("separation", 12)
		chip.add_child(chip_row)

		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(6, 6)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.add_theme_stylebox_override("panel", UI.style(accent, UITheme.RADIUS_PILL))
		chip_row.add_child(dot)

		var tv := VBoxContainer.new()
		tv.add_theme_constant_override("separation", 2)
		tv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip_row.add_child(tv)
		tv.add_child(UI.label(name_str, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
		var d := UI.label(desc_str, UITheme.FONT_XS, UITheme.TEXT_MUTED)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD
		tv.add_child(d)
