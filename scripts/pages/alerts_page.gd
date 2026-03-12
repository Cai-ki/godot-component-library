class_name AlertsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Alerts",
		"Notification and alert components for displaying contextual feedback messages.")

	_standard_alerts(parent)
	_compact_alerts(parent)
	_dismissable_alerts(parent)
	_alert_with_actions(parent)
	_banner_alerts(parent)


# =============================================
# STANDARD ALERTS
# =============================================

func _standard_alerts(parent: Control) -> void:
	UI.section(parent, "Standard Alerts")

	UI.alert(parent, "ℹ", "Information",
		"This is an informational alert. Use it to provide helpful context to the user.",
		UITheme.INFO)

	UI.alert(parent, "✓", "Success",
		"Operation completed successfully. Your changes have been saved.",
		UITheme.SUCCESS)

	UI.alert(parent, "⚠", "Warning",
		"Please review your input. Some fields may require attention before proceeding.",
		UITheme.WARNING)

	UI.alert(parent, "✕", "Error",
		"Something went wrong. Please try again or contact support if the issue persists.",
		UITheme.DANGER)


# =============================================
# COMPACT ALERTS
# =============================================

func _compact_alerts(parent: Control) -> void:
	UI.section(parent, "Compact Alerts (Single Line)")

	_compact_alert(parent, "ℹ", "New version v4.3.1 is now available.", UITheme.INFO)
	_compact_alert(parent, "✓", "File uploaded successfully.", UITheme.SUCCESS)
	_compact_alert(parent, "⚠", "Your session will expire in 5 minutes.", UITheme.WARNING)
	_compact_alert(parent, "✕", "Failed to connect to server.", UITheme.DANGER)


func _compact_alert(parent: Control, icon: String, text: String, color: Color) -> void:
	var bg := Color(color.r, color.g, color.b, 0.06)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := UI.style_left_border(bg, color, 3, UITheme.RADIUS_SM)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	panel.add_child(h)

	h.add_child(UI.label(icon, UITheme.FONT_MD, color))
	h.add_child(UI.label(text, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))


# =============================================
# DISMISSABLE ALERTS
# =============================================

func _dismissable_alerts(parent: Control) -> void:
	UI.section(parent, "Dismissable Alerts")

	UI.alert(parent, "ℹ", "Tip",
		"You can customize your dashboard layout by dragging widgets. Click the close button to dismiss this tip.",
		UITheme.INFO, true)

	UI.alert(parent, "⚠", "Maintenance Notice",
		"Scheduled maintenance on March 15, 2026. Services may be temporarily unavailable.",
		UITheme.WARNING, true)


# =============================================
# ALERTS WITH ACTIONS
# =============================================

func _alert_with_actions(parent: Control) -> void:
	UI.section(parent, "Alerts with Actions")

	# Update alert
	var update_panel := _action_alert_base(parent, "⟳", "Update Available",
		"A new version of the component library is available. Would you like to update now?",
		UITheme.PRIMARY)
	var update_actions := UI.hbox(update_panel, 8)
	UI.solid_btn(update_actions, "Update Now", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)
	UI.ghost_btn(update_actions, "Later", UITheme.TEXT_SECONDARY, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)

	# Error with retry
	var error_panel := _action_alert_base(parent, "✕", "Connection Error",
		"Unable to reach the server. Please check your network connection and try again.",
		UITheme.DANGER)
	var error_actions := UI.hbox(error_panel, 8)
	UI.solid_btn(error_actions, "Retry", UITheme.DANGER, Color.WHITE, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)
	UI.ghost_btn(error_actions, "Dismiss", UITheme.TEXT_SECONDARY, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)

	# Confirm action
	var confirm_panel := _action_alert_base(parent, "⚠", "Confirm Deletion",
		"This action cannot be undone. Are you sure you want to delete all selected items?",
		UITheme.WARNING)
	var confirm_actions := UI.hbox(confirm_panel, 8)
	UI.solid_btn(confirm_actions, "Delete", UITheme.DANGER, Color.WHITE, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)
	UI.outline_btn(confirm_actions, "Cancel", UITheme.TEXT_SECONDARY, UITheme.RADIUS_SM, 14, 6, UITheme.FONT_SM)


func _action_alert_base(parent: Control, icon: String, title: String,
		desc: String, color: Color) -> VBoxContainer:
	var bg := Color(color.r, color.g, color.b, 0.06)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := UI.style_left_border(bg, color, 4, UITheme.RADIUS_MD)
	s.content_margin_left = 16
	s.content_margin_right = 16
	s.content_margin_top = 14
	s.content_margin_bottom = 14
	panel.add_theme_stylebox_override("panel", s)
	parent.add_child(panel)

	var outer_h := HBoxContainer.new()
	outer_h.add_theme_constant_override("separation", 12)
	panel.add_child(outer_h)

	outer_h.add_child(UI.label(icon, UITheme.FONT_LG, color))

	var content_v := VBoxContainer.new()
	content_v.add_theme_constant_override("separation", 8)
	content_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer_h.add_child(content_v)

	content_v.add_child(UI.label(title, UITheme.FONT_MD, color))
	var d := UI.label(desc, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD
	content_v.add_child(d)

	return content_v


# =============================================
# BANNER ALERTS
# =============================================

func _banner_alerts(parent: Control) -> void:
	UI.section(parent, "Full-Width Banners")

	_banner(parent, "✓  Changes saved successfully", UITheme.SUCCESS)
	_banner(parent, "ℹ  System is undergoing maintenance — some features may be slow", UITheme.INFO)
	_banner(parent, "⚠  Your storage is almost full (92% used)", UITheme.WARNING)
	_banner(parent, "✕  Payment failed — please update your billing information", UITheme.DANGER)


func _banner(parent: Control, text: String, color: Color) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", UI.style(
		color, UITheme.RADIUS_SM, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 16, 10
	))
	parent.add_child(panel)

	var center := CenterContainer.new()
	panel.add_child(center)

	var text_color := UITheme.TEXT_INVERSE if color.get_luminance() > 0.5 else Color.WHITE
	center.add_child(UI.label(text, UITheme.FONT_SM, text_color))
