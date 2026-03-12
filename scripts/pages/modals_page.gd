class_name ModalsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Modals",
		"UIModal — overlay dialog with header, body, footer. Reparents to scene root on show.")

	_basic_modals(parent)
	_form_modal(parent)
	_confirm_modal(parent)
	_info_modal(parent)


# =============================================
# BASIC MODAL VARIANTS
# =============================================

func _basic_modals(parent: Control) -> void:
	UI.section(parent, "Modal Variants")

	var demo_card := UI.card(parent, 24, 20)
	demo_card.add_child(UI.label(
		"Click a button below to open the corresponding modal. "
		+ "Backdrop click or ✕ closes the modal.",
		UITheme.FONT_SM, UITheme.TEXT_SECONDARY
	))

	var btns := UI.hbox(demo_card, 12)

	# Info modal
	var info_modal := UIModal.new()
	info_modal.title_text = "Information"
	parent.add_child(info_modal)
	var ib := info_modal.get_body()
	ib.add_child(UI.label(
		"This is a standard information modal.\n\nUse it to display important details that require user acknowledgement before continuing.",
		UITheme.FONT_MD, UITheme.TEXT_SECONDARY
	))
	var if_ := info_modal.get_footer()
	UI.solid_btn(if_, "Got it", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_MD, 20, 10).pressed.connect(func(): info_modal.hide_modal())

	UI.solid_btn(btns, "ℹ  Info Modal", UITheme.INFO).pressed.connect(func(): info_modal.show_modal())

	# Success modal
	var success_modal := UIModal.new()
	success_modal.title_text = "Operation Successful"
	parent.add_child(success_modal)
	var sb := success_modal.get_body()
	_add_icon_content(sb, "✓", UITheme.SUCCESS, "All changes saved",
		"Your project settings have been updated. The new configuration will take effect on next launch.")
	var sf := success_modal.get_footer()
	UI.solid_btn(sf, "Continue", UITheme.SUCCESS, UITheme.TEXT_INVERSE, UITheme.RADIUS_MD, 20, 10).pressed.connect(func(): success_modal.hide_modal())

	UI.solid_btn(btns, "✓  Success Modal", UITheme.SUCCESS, UITheme.TEXT_INVERSE).pressed.connect(func(): success_modal.show_modal())

	# Warning modal
	var warn_modal := UIModal.new()
	warn_modal.title_text = "Warning"
	parent.add_child(warn_modal)
	var wb := warn_modal.get_body()
	_add_icon_content(wb, "⚠", UITheme.WARNING, "Unsaved Changes",
		"You have unsaved changes that will be lost if you continue. Do you want to save before proceeding?")
	var wf := warn_modal.get_footer()
	UI.ghost_btn(wf, "Discard",  UITheme.TEXT_SECONDARY).pressed.connect(func(): warn_modal.hide_modal())
	UI.solid_btn(wf, "Save & Continue", UITheme.WARNING, UITheme.TEXT_INVERSE).pressed.connect(func(): warn_modal.hide_modal())

	UI.solid_btn(btns, "⚠  Warning Modal", UITheme.WARNING, UITheme.TEXT_INVERSE).pressed.connect(func(): warn_modal.show_modal())

	# Error modal
	var err_modal := UIModal.new()
	err_modal.title_text = "Error Occurred"
	parent.add_child(err_modal)
	var eb := err_modal.get_body()
	_add_icon_content(eb, "✕", UITheme.DANGER, "Connection Failed",
		"Unable to reach the server. Please check your internet connection and try again. Error code: ERR_NETWORK_TIMEOUT")
	var ef := err_modal.get_footer()
	UI.ghost_btn(ef, "Cancel",   UITheme.TEXT_SECONDARY).pressed.connect(func(): err_modal.hide_modal())
	UI.solid_btn(ef, "Retry",    UITheme.DANGER,          Color.WHITE).pressed.connect(func(): err_modal.hide_modal())

	UI.solid_btn(btns, "✕  Error Modal", UITheme.DANGER).pressed.connect(func(): err_modal.show_modal())
	UI.h_expand(btns)


func _add_icon_content(body: VBoxContainer, icon: String, color: Color,
		title: String, desc: String) -> void:
	var center := CenterContainer.new()
	body.add_child(center)
	var icon_chip := PanelContainer.new()
	icon_chip.add_theme_stylebox_override("panel", UI.style(
		Color(color.r, color.g, color.b, 0.12), UITheme.RADIUS_PILL,
		0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 12, 10
	))
	center.add_child(icon_chip)
	var icon_c := CenterContainer.new()
	icon_chip.add_child(icon_c)
	icon_c.add_child(UI.label(icon, UITheme.FONT_2XL, color))

	var tc := CenterContainer.new()
	body.add_child(tc)
	tc.add_child(UI.label(title, UITheme.FONT_LG, UITheme.TEXT_PRIMARY))

	var dl := UI.label(desc, UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	dl.autowrap_mode = TextServer.AUTOWRAP_WORD
	dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.add_child(dl)


# =============================================
# FORM MODAL
# =============================================

func _form_modal(parent: Control) -> void:
	UI.section(parent, "Form Modal")

	var demo_card2 := UI.card(parent, 24, 20)

	var form_modal := UIModal.new()
	form_modal.title_text = "Create New Component"
	form_modal.dialog_width = 520.0
	parent.add_child(form_modal)

	var fb := form_modal.get_body()
	var fields := [
		["Component Name", "e.g. UIButton"],
		["Category",       "e.g. Interactive"],
		["Description",    "Short description..."],
	]
	for field in fields:
		var fv := UIInput.new()
		fv.label_text = field[0]
		fv.placeholder = field[1]
		fb.add_child(fv)

	var ff := form_modal.get_footer()
	UI.ghost_btn(ff,  "Cancel",  UITheme.TEXT_SECONDARY).pressed.connect(func(): form_modal.hide_modal())
	UI.solid_btn(ff,  "Create",  UITheme.PRIMARY, Color.WHITE).pressed.connect(func(): form_modal.hide_modal())

	demo_card2.add_child(UI.label("Form modal with UIInput fields inside.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var open_btn := UI.solid_btn(demo_card2, "⊕  Open Form Modal", UITheme.PRIMARY)
	open_btn.pressed.connect(func(): form_modal.show_modal())


# =============================================
# CONFIRM MODAL
# =============================================

func _confirm_modal(parent: Control) -> void:
	UI.section(parent, "Confirm Deletion Modal")

	var demo_card3 := UI.card(parent, 24, 20)
	demo_card3.add_child(UI.label("Destructive action confirmation pattern.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	var del_modal := UIModal.new()
	del_modal.title_text = "Delete Project"
	parent.add_child(del_modal)

	var db := del_modal.get_body()
	var alert := UIAlert.new()
	alert.alert_type = UIAlert.AlertType.DANGER
	alert.title_text = "This action is permanent"
	alert.body_text  = "All files, settings, and history for this project will be deleted. This cannot be undone."
	db.add_child(alert)

	var confirm_input := UIInput.new()
	confirm_input.label_text = "Type \"DELETE\" to confirm"
	confirm_input.placeholder = "DELETE"
	db.add_child(confirm_input)

	var df := del_modal.get_footer()
	UI.ghost_btn(df,  "Cancel", UITheme.TEXT_SECONDARY).pressed.connect(func(): del_modal.hide_modal())
	var del_btn := UI.solid_btn(df, "Delete Project", UITheme.DANGER)
	del_btn.disabled = true
	confirm_input.text_changed.connect(func(t: String):
		del_btn.disabled = (t.strip_edges().to_upper() != "DELETE")
	)
	del_btn.pressed.connect(func(): del_modal.hide_modal())

	var open_del := UI.solid_btn(demo_card3, "✕  Delete Project", UITheme.DANGER)
	open_del.pressed.connect(func(): del_modal.show_modal())


# =============================================
# INFO MODAL
# =============================================

func _info_modal(parent: Control) -> void:
	UI.section(parent, "Terms & Conditions Modal")

	var demo_card4 := UI.card(parent, 24, 20)
	demo_card4.add_child(UI.label("Scrollable long-content modal with accept/decline.", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	var tos_modal := UIModal.new()
	tos_modal.title_text = "Terms of Service"
	tos_modal.dialog_width = 560.0
	parent.add_child(tos_modal)

	var tb := tos_modal.get_body()
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size.y = 200
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tb.add_child(scroll)
	var scroll_v := VBoxContainer.new()
	scroll_v.add_theme_constant_override("separation", 12)
	scroll_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(scroll_v)

	var tos_text := [
		"1. Acceptance of Terms",
		"By accessing this component library, you agree to be bound by these Terms of Service.",
		"2. License",
		"Components are provided under the MIT license. You may use, modify, and distribute them freely in personal and commercial projects.",
		"3. Attribution",
		"Attribution is appreciated but not required. If you find these components helpful, consider contributing back to the project.",
		"4. Disclaimer",
		"Components are provided as-is without warranty of any kind.",
	]
	for i in tos_text.size():
		var tl := UI.label(tos_text[i], UITheme.FONT_MD if i % 2 == 0 else UITheme.FONT_SM,
			UITheme.TEXT_PRIMARY if i % 2 == 0 else UITheme.TEXT_SECONDARY)
		tl.autowrap_mode = TextServer.AUTOWRAP_WORD
		scroll_v.add_child(tl)

	var accept_check := CheckBox.new()
	accept_check.text = "I have read and agree to the Terms of Service"
	accept_check.focus_mode = Control.FOCUS_NONE
	accept_check.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	accept_check.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	tb.add_child(accept_check)

	var tf := tos_modal.get_footer()
	UI.ghost_btn(tf,  "Decline", UITheme.TEXT_SECONDARY).pressed.connect(func(): tos_modal.hide_modal())
	var accept_btn := UI.solid_btn(tf, "Accept & Continue", UITheme.PRIMARY)
	accept_btn.disabled = true
	accept_check.toggled.connect(func(on: bool): accept_btn.disabled = !on)
	accept_btn.pressed.connect(func(): tos_modal.hide_modal())

	UI.solid_btn(demo_card4, "⊟  Open ToS Modal", UITheme.SECONDARY).pressed.connect(func(): tos_modal.show_modal())
