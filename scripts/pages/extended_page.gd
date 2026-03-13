class_name ExtendedPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Extended Components",
		"UIBreadcrumb, UIChip, UINotificationBadge, and UITimeline — navigation, filtering, counts, and activity feeds.")

	_breadcrumb_section(parent)
	_chip_section(parent)
	_notification_badge_section(parent)
	_timeline_section(parent)


# =============================================
# BREADCRUMB
# =============================================

func _breadcrumb_section(parent: Control) -> void:
	UI.section(parent, "Breadcrumb  (UIBreadcrumb)")

	var card_v := UI.card(parent, 24, 20)

	# Basic breadcrumb
	card_v.add_child(UI.label("Basic", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var bc1 := UIBreadcrumb.new()
	bc1.items = PackedStringArray(["Home", "Products", "Electronics", "Smartphones"])
	card_v.add_child(bc1)

	UI.spacer(card_v, 8)

	# Custom separator
	card_v.add_child(UI.label("Custom Separator ( / )", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var bc2 := UIBreadcrumb.new()
	bc2.items = PackedStringArray(["Dashboard", "Users", "Profile"])
	bc2.separator = "/"
	card_v.add_child(bc2)

	UI.spacer(card_v, 8)

	# Arrow separator
	card_v.add_child(UI.label("Arrow Separator ( → )", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var bc3 := UIBreadcrumb.new()
	bc3.items = PackedStringArray(["Settings", "Account", "Security", "Two-Factor"])
	bc3.separator = "→"
	card_v.add_child(bc3)

	UI.spacer(card_v, 8)

	# Interactive with toast feedback
	card_v.add_child(UI.label("Interactive (click a segment)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var bc4 := UIBreadcrumb.new()
	bc4.items = PackedStringArray(["Home", "Blog", "2024", "March", "Current Post"])
	card_v.add_child(bc4)

	var toast := UIToast.new()
	card_v.add_child(toast)
	bc4.segment_clicked.connect(func(i: int):
		toast.show_toast("Navigate to: " + bc4.items[i], UIToast.ToastType.INFO)
	)


# =============================================
# CHIP
# =============================================

func _chip_section(parent: Control) -> void:
	UI.section(parent, "Chip  (UIChip)")

	var card_v := UI.card(parent, 24, 20)

	# Color schemes
	card_v.add_child(UI.label("Color Schemes", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var colors_row := HFlowContainer.new()
	colors_row.add_theme_constant_override("h_separation", 8)
	colors_row.add_theme_constant_override("v_separation", 8)
	card_v.add_child(colors_row)

	var schemes := ["Primary", "Secondary", "Success", "Warning", "Danger", "Info", "Neutral"]
	for i in schemes.size():
		var chip := UIChip.new()
		chip.chip_text = schemes[i]
		chip.color_scheme = i as UIChip.ColorScheme
		colors_row.add_child(chip)

	UI.spacer(card_v, 12)

	# Selectable chips
	card_v.add_child(UI.label("Selectable (click to toggle)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var select_row := HFlowContainer.new()
	select_row.add_theme_constant_override("h_separation", 8)
	select_row.add_theme_constant_override("v_separation", 8)
	card_v.add_child(select_row)

	var techs := ["Vue.js", "React", "Angular", "Svelte", "Solid", "Qwik"]
	var chip_colors: Array[int] = [0, 1, 2, 3, 4, 5]
	for i in techs.size():
		var chip := UIChip.new()
		chip.chip_text = techs[i]
		chip.selectable = true
		chip.color_scheme = chip_colors[i] as UIChip.ColorScheme
		chip.selected = (i == 0 or i == 2)   # Pre-select some
		select_row.add_child(chip)

	UI.spacer(card_v, 12)

	# Removable chips
	card_v.add_child(UI.label("Removable (click ✕)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var remove_row := HFlowContainer.new()
	remove_row.add_theme_constant_override("h_separation", 8)
	remove_row.add_theme_constant_override("v_separation", 8)
	card_v.add_child(remove_row)

	var tags := ["GDScript", "Godot 4.6", "UI Library", "Dark Theme", "Open Source"]
	for i in tags.size():
		var chip := UIChip.new()
		chip.chip_text = tags[i]
		chip.removable = true
		chip.color_scheme = (i % 3) as UIChip.ColorScheme
		remove_row.add_child(chip)

	UI.spacer(card_v, 12)

	# Non-pill shape
	card_v.add_child(UI.label("Rounded Rectangle (pill_shape = false)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var rect_row := HFlowContainer.new()
	rect_row.add_theme_constant_override("h_separation", 8)
	rect_row.add_theme_constant_override("v_separation", 8)
	card_v.add_child(rect_row)

	for lbl in ["Label A", "Label B", "Label C"]:
		var chip := UIChip.new()
		chip.chip_text = lbl
		chip.pill_shape = false
		chip.selectable = true
		rect_row.add_child(chip)


# =============================================
# NOTIFICATION BADGE
# =============================================

func _notification_badge_section(parent: Control) -> void:
	UI.section(parent, "Notification Badge  (UINotificationBadge)")

	var card_v := UI.card(parent, 24, 20)

	# Count badges on buttons
	card_v.add_child(UI.label("Count Badges on Buttons", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var btn_row := UI.hbox(card_v, 24)

	var demos := [
		["🔔  Alerts", 3, UITheme.DANGER],
		["✉  Messages", 12, UITheme.PRIMARY],
		["👥  Friends", 99, UITheme.SUCCESS],
		["📦  Orders", 150, UITheme.WARNING],
	]

	for d in demos:
		var label_text: String = d[0]
		var count_val: int = d[1]
		var color: Color = d[2]

		var btn := UIButton.new()
		btn.text = label_text
		btn.variant = UIButton.Variant.OUTLINE
		btn.color_scheme = UIButton.ColorScheme.NEUTRAL
		btn.button_size = UIButton.Size.MD
		btn_row.add_child(btn)

		var badge := UINotificationBadge.new()
		badge.count = count_val
		badge.badge_color = color
		btn.add_child(badge)

	UI.spacer(card_v, 16)

	# Dot-only badges on avatars
	card_v.add_child(UI.label("Dot Mode on Avatars (count = 0, show_zero = true)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var avatar_row := UI.hbox(card_v, 20)

	var avatar_data := [
		["AB", UITheme.PRIMARY],
		["CD", UITheme.SUCCESS],
		["EF", UITheme.WARNING],
		["GH", UITheme.DANGER],
	]

	for ad in avatar_data:
		var init: String = ad[0]
		var c: Color = ad[1]
		var avatar := UIAvatar.new()
		avatar.initials = init
		avatar.bg_color = c
		avatar.avatar_size = UIAvatar.AvatarSize.LG
		avatar_row.add_child(avatar)

		var dot := UINotificationBadge.new()
		dot.count = 0
		dot.show_zero = true
		dot.badge_color = UITheme.DANGER
		avatar.add_child(dot)

	UI.spacer(card_v, 16)

	# Interactive increment
	card_v.add_child(UI.label("Interactive — Click to Increment", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var int_row := UI.hbox(card_v, 16)

	var counter_btn := UIButton.new()
	counter_btn.text = "📬  Inbox"
	counter_btn.variant = UIButton.Variant.SOLID
	counter_btn.color_scheme = UIButton.ColorScheme.PRIMARY
	int_row.add_child(counter_btn)

	var counter_badge := UINotificationBadge.new()
	counter_badge.count = 0
	counter_btn.add_child(counter_badge)

	var inc_btn := UI.solid_btn(int_row, "+1", UITheme.SUCCESS)
	var dec_btn := UI.outline_btn(int_row, "-1", UITheme.DANGER)
	var reset_btn := UI.ghost_btn(int_row, "Reset", UITheme.TEXT_SECONDARY)

	inc_btn.pressed.connect(func(): counter_badge.count += 1)
	dec_btn.pressed.connect(func(): counter_badge.count = maxi(0, counter_badge.count - 1))
	reset_btn.pressed.connect(func(): counter_badge.count = 0)


# =============================================
# TIMELINE
# =============================================

func _timeline_section(parent: Control) -> void:
	UI.section(parent, "Timeline  (UITimeline)")

	var card_v := UI.card(parent, 24, 20)

	# Basic timeline
	card_v.add_child(UI.label("Activity Feed", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var tl := UITimeline.new()
	tl.add_item("Deployed v2.1.0", "Production release with 8 new components", "2 hours ago", UITheme.SUCCESS, "🚀")
	tl.add_item("Code Review Approved", "PR #247 — Add UIBreadcrumb and UIChip components", "5 hours ago", UITheme.PRIMARY, "✓")
	tl.add_item("Build Failed", "CI pipeline error in unit tests", "8 hours ago", UITheme.DANGER, "✕")
	tl.add_item("Branch Created", "feature/extended-components", "1 day ago", UITheme.SECONDARY, "⑂")
	tl.add_item("Sprint Planning", "Planned 12 tasks for Sprint 14", "2 days ago", UITheme.INFO, "📋")
	tl.add_item("Team Standup", "Daily sync meeting completed", "3 days ago", UITheme.WARNING)
	card_v.add_child(tl)
