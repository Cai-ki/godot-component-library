class_name DashboardScenePage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Dashboard",
		"A realistic admin dashboard combining UITable, UIProgressRing, UIBadge, "
		+ "UIAvatar, and bar charts into a data-rich management interface.")

	_metrics(parent)
	_chart(parent)
	_activity(parent)
	_team(parent)


# =============================================
# KEY METRICS — 4 stat cards
# =============================================

func _metrics(parent: Control) -> void:
	UI.section(parent, "Key Metrics")
	var row := UI.hbox(parent, 16)

	# Total Users
	var c1 := UI.card(row, 20, 18)
	c1.add_child(UI.label("Total Users", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r1 := UI.hbox(c1, 10)
	r1.alignment = BoxContainer.ALIGNMENT_CENTER
	r1.add_child(UI.label("12,847", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	UI.h_expand(r1)
	UI.soft_badge(r1, "↑ 12.5%", UITheme.SUCCESS, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)

	# Revenue
	var c2 := UI.card(row, 20, 18)
	c2.add_child(UI.label("Revenue", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r2 := UI.hbox(c2, 10)
	r2.alignment = BoxContainer.ALIGNMENT_CENTER
	r2.add_child(UI.label("$84,230", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	UI.h_expand(r2)
	UI.soft_badge(r2, "↑ 8.2%", UITheme.INFO, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)

	# Active Projects — with small progress ring
	var c3 := UI.card(row, 20, 18)
	c3.add_child(UI.label("Active Projects", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var r3 := UI.hbox(c3, 14)
	r3.alignment = BoxContainer.ALIGNMENT_CENTER
	r3.add_child(UI.label("23", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	UI.h_expand(r3)
	var ring := UIProgressRing.new()
	ring.value = 0.72
	ring.ring_size = 44
	ring.thickness = 4.0
	ring.show_label = false
	ring.progress_color = UITheme.WARNING
	r3.add_child(ring)

	# Completion Rate — with progress bar
	var c4 := UI.card(row, 20, 18)
	c4.add_child(UI.label("Completion Rate", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	c4.add_child(UI.label("87%", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY))
	UI.spacer(c4, 4)
	var prog := UIProgress.new()
	prog.value = 0.87
	prog.progress_color = UITheme.SUCCESS
	prog.bar_height = 6
	prog.show_label = false
	c4.add_child(prog)


# =============================================
# REVENUE CHART — bar chart with ColorRect
# =============================================

func _chart(parent: Control) -> void:
	UI.section(parent, "Revenue Overview")
	var card_v := UI.card(parent, 24, 20)

	# Title row
	var title_row := UI.hbox(card_v, 0)
	title_row.add_child(UI.label("Monthly Revenue", UITheme.FONT_BASE, UITheme.TEXT_PRIMARY))
	UI.h_expand(title_row)
	UI.soft_badge(title_row, "2025", UITheme.PRIMARY, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)

	UI.spacer(card_v, 8)

	# Chart area — fixed height container
	var chart_area := PanelContainer.new()
	chart_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chart_area.custom_minimum_size.y = 200
	chart_area.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_1, UITheme.RADIUS_MD, 1, UITheme.BORDER,
		0, Color.TRANSPARENT, Vector2.ZERO, 16, 16
	))
	card_v.add_child(chart_area)

	var chart_margin := MarginContainer.new()
	chart_margin.add_theme_constant_override("margin_left", 8)
	chart_margin.add_theme_constant_override("margin_right", 8)
	chart_margin.add_theme_constant_override("margin_top", 8)
	chart_margin.add_theme_constant_override("margin_bottom", 8)
	chart_area.add_child(chart_margin)

	var bars_row := HBoxContainer.new()
	bars_row.add_theme_constant_override("separation", 8)
	bars_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bars_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chart_margin.add_child(bars_row)

	var months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
					"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var values := [45, 62, 55, 78, 65, 88, 72, 95, 82, 70, 90, 85]
	var max_val: int = 95

	for i in range(12):
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 4)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.size_flags_vertical = Control.SIZE_EXPAND_FILL
		bars_row.add_child(col)

		# Spacer pushes bar to bottom
		var push := Control.new()
		push.size_flags_vertical = Control.SIZE_EXPAND_FILL
		col.add_child(push)

		# Bar
		var bar_height: int = int(float(values[i]) / float(max_val) * 140.0)
		var bar := PanelContainer.new()
		bar.custom_minimum_size = Vector2(0, bar_height)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bar_color: Color = UITheme.PRIMARY.lerp(UITheme.PRIMARY_LIGHT, float(i) / 11.0)
		bar.add_theme_stylebox_override("panel", UI.style(
			bar_color, UITheme.RADIUS_XS
		))
		col.add_child(bar)

		# Month label
		var m_lbl := UI.label(months[i], UITheme.FONT_XS, UITheme.TEXT_MUTED)
		m_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(m_lbl)


# =============================================
# RECENT ACTIVITY — table with status badges
# =============================================

func _activity(parent: Control) -> void:
	UI.section(parent, "Recent Activity")
	var card_v := UI.card(parent, 24, 20)

	var table := UITable.new()
	table.sortable = true
	table.filterable = true
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(table)

	table.set_columns(PackedStringArray(["User", "Action", "Status", "Date"]))

	var rows: Array = [
		["Alice Johnson",  "Deployed v2.4.1",    "Completed", "2025-03-12"],
		["Bob Martinez",   "Updated design spec", "Completed", "2025-03-12"],
		["Carol Williams", "Code review #482",   "Pending",   "2025-03-11"],
		["David Chen",     "Bug fix: auth flow",  "Completed", "2025-03-11"],
		["Elena Kowalski", "Database migration",  "Failed",    "2025-03-10"],
		["Frank Nguyen",   "CI pipeline update",  "Completed", "2025-03-10"],
		["Grace Liu",      "API rate limiting",   "Pending",   "2025-03-09"],
		["Henry Park",     "Security audit",      "Completed", "2025-03-08"],
	]
	for row: Array in rows:
		table.add_row(row)


# =============================================
# TEAM MEMBERS — avatar cards
# =============================================

func _team(parent: Control) -> void:
	UI.section(parent, "Team Members")
	var row := UI.hbox(parent, 12)

	var members: Array = [
		["AJ", "Alice Johnson",  "Tech Lead",    UITheme.PRIMARY,   UIAvatar.StatusType.ONLINE],
		["BM", "Bob Martinez",   "Designer",     UITheme.INFO,      UIAvatar.StatusType.ONLINE],
		["CW", "Carol Williams", "Product Lead", UITheme.SUCCESS,   UIAvatar.StatusType.AWAY],
		["DC", "David Chen",     "QA Engineer",  UITheme.WARNING,   UIAvatar.StatusType.ONLINE],
		["EK", "Elena Kowalski", "Backend Dev",  UITheme.DANGER,    UIAvatar.StatusType.BUSY],
		["FN", "Frank Nguyen",   "DevOps",       UITheme.SECONDARY, UIAvatar.StatusType.OFFLINE],
	]

	for m: Array in members:
		var initials_str: String = m[0]
		var name_str: String = m[1]
		var role_str: String = m[2]
		var color: Color = m[3]
		var status_val: UIAvatar.StatusType = m[4]

		var card_v := UI.card(row, 20, 16)

		# Avatar centered
		var center := CenterContainer.new()
		card_v.add_child(center)
		var avatar := UIAvatar.new()
		avatar.initials = initials_str
		avatar.bg_color = color
		avatar.avatar_size = UIAvatar.AvatarSize.LG
		avatar.status = status_val
		center.add_child(avatar)

		UI.spacer(card_v, 4)

		# Name + role
		var name_lbl := UI.label(name_str, UITheme.FONT_SM, UITheme.TEXT_PRIMARY)
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_v.add_child(name_lbl)

		var role_lbl := UI.label(role_str, UITheme.FONT_XS, UITheme.TEXT_MUTED)
		role_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_v.add_child(role_lbl)
