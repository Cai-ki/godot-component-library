class_name LayoutsPage
extends RefCounted

const FS := UITheme.FONT_XS


func build(parent: Control) -> void:
	UI.page_header(parent, "Layout Patterns",
		"Common UI layouts rendered as mini-mockups. Copy the node structures as starting points for your own projects.")

	# 2-column grid of layouts
	var r1 := UI.hbox(parent, 16)
	_login_layout(r1)
	_dashboard_layout(r1)

	var r2 := UI.hbox(parent, 16)
	_settings_layout(r2)
	_chat_layout(r2)

	var r3 := UI.hbox(parent, 16)
	_card_grid_layout(r3)
	_list_layout(r3)

	var r4 := UI.hbox(parent, 16)
	_profile_layout(r4)
	_ecommerce_layout(r4)

	var r5 := UI.hbox(parent, 16)
	_inbox_layout(r5)
	_kanban_layout(r5)

	var r6 := UI.hbox(parent, 16)
	_player_layout(r6)
	_wizard_layout(r6)


# ── Helpers ───────────────────────────────────────
func _frame(parent: Control, title: String) -> VBoxContainer:
	var outer := VBoxContainer.new()
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_theme_constant_override("separation", 8)
	parent.add_child(outer)

	outer.add_child(UI.label(title, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))

	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size.y = 320
	panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_1, UITheme.RADIUS_LG, 1, UITheme.BORDER
	))
	outer.add_child(panel)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 0)
	panel.add_child(inner)
	return inner

func _mini_label(text: String, size: int = FS, color: Color = UITheme.TEXT_PRIMARY) -> Label:
	return UI.label(text, size, color)

func _mini_rect(color: Color, h: int, w: int = 0, radius: int = UITheme.RADIUS_SM) -> PanelContainer:
	var p := PanelContainer.new()
	if h > 0: p.custom_minimum_size.y = h
	if w > 0: p.custom_minimum_size.x = w
	if w == 0: p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.style(color, radius))
	return p

func _mini_margin(parent: Control, m: int) -> MarginContainer:
	var mc := MarginContainer.new()
	mc.add_theme_constant_override("margin_left", m); mc.add_theme_constant_override("margin_right", m)
	mc.add_theme_constant_override("margin_top",  m); mc.add_theme_constant_override("margin_bottom", m)
	mc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mc.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	parent.add_child(mc)
	return mc


# ═══════════════════════════════════════════════════
# 1. LOGIN FORM
# ═══════════════════════════════════════════════════
func _login_layout(parent: Control) -> void:
	var frame := _frame(parent, "Login / Sign In")

	# Background fill
	var bg := PanelContainer.new()
	bg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bg.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	bg.add_theme_stylebox_override("panel", UI.style(UITheme.BG, 0))
	frame.add_child(bg)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	bg.add_child(center)

	# Login card
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(240, 0)
	card.add_theme_stylebox_override("panel", UI.style(
		UITheme.SURFACE_2, UITheme.RADIUS_LG, 1, UITheme.BORDER, 8, Color(0,0,0,0.3), Vector2(0,4)
	))
	center.add_child(card)

	var cm := MarginContainer.new()
	cm.add_theme_constant_override("margin_left", 20); cm.add_theme_constant_override("margin_right", 20)
	cm.add_theme_constant_override("margin_top",  16); cm.add_theme_constant_override("margin_bottom", 16)
	card.add_child(cm)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	cm.add_child(col)

	# Logo
	var logo := _mini_rect(UITheme.PRIMARY_SOFT, 32, 0, UITheme.RADIUS_MD)
	col.add_child(logo)
	var lc := CenterContainer.new()
	logo.add_child(lc)
	lc.add_child(_mini_label("⬡  App", UITheme.FONT_SM, UITheme.PRIMARY))

	col.add_child(_mini_label("Sign in to your account", FS, UITheme.TEXT_SECONDARY))

	# Fields
	for ph in ["Email address", "Password"]:
		var inp := LineEdit.new()
		inp.placeholder_text = ph
		inp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if ph == "Password": inp.secret = true
		var ns := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_SM, 1, UITheme.BORDER, 0, Color.TRANSPARENT, Vector2.ZERO, 8, 6)
		inp.add_theme_stylebox_override("normal", ns)
		inp.add_theme_stylebox_override("focus", ns)
		inp.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		inp.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
		inp.add_theme_font_size_override("font_size", FS)
		col.add_child(inp)

	# Button
	UI.solid_btn(col, "Sign In", UITheme.PRIMARY, Color.WHITE, UITheme.RADIUS_SM, 0, 6, FS).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	col.add_child(_mini_label("Forgot password?", FS, UITheme.PRIMARY))


# ═══════════════════════════════════════════════════
# 2. DASHBOARD
# ═══════════════════════════════════════════════════
func _dashboard_layout(parent: Control) -> void:
	var frame := _frame(parent, "Dashboard")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Sidebar
	var sidebar := PanelContainer.new()
	sidebar.custom_minimum_size.x = 60
	sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var ss := UI.style(UITheme.SURFACE_2, 0)
	ss.border_width_right = 1; ss.border_color = UITheme.BORDER
	sidebar.add_theme_stylebox_override("panel", ss)
	hbox.add_child(sidebar)

	var sm := _mini_margin(sidebar, 8)
	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 6)
	sm.add_child(sv)

	# Nav items
	for i in 4:
		var nav := _mini_rect(UITheme.PRIMARY if i == 0 else UITheme.SURFACE_3, 24, 0, UITheme.RADIUS_SM)
		sv.add_child(nav)
		var nc := CenterContainer.new()
		nav.add_child(nc)
		nc.add_child(_mini_label(["◉","⊞","◎","▤"][i], FS, Color.WHITE if i == 0 else UITheme.TEXT_MUTED))

	# Content
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 0)
	hbox.add_child(content)

	# Top bar
	var top := PanelContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ts := UI.style(UITheme.SURFACE_2, 0)
	ts.border_width_bottom = 1; ts.border_color = UITheme.BORDER
	ts.content_margin_left = 12; ts.content_margin_right = 12
	ts.content_margin_top = 8; ts.content_margin_bottom = 8
	top.add_theme_stylebox_override("panel", ts)
	content.add_child(top)
	var th := HBoxContainer.new()
	top.add_child(th)
	th.add_child(_mini_label("Dashboard", FS, UITheme.TEXT_PRIMARY))
	UI.h_expand(th)
	var av := _mini_rect(UITheme.PRIMARY, 18, 18, UITheme.RADIUS_PILL)
	th.add_child(av)

	# Body
	var body_m := _mini_margin(content, 10)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	body_m.add_child(body)

	# Stat row
	var stats := HBoxContainer.new()
	stats.add_theme_constant_override("separation", 6)
	body.add_child(stats)
	var stat_colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.INFO]
	var stat_vals   := ["$12.4K", "842", "93%", "1.2K"]
	for i in 4:
		var sp := PanelContainer.new()
		sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var sps := UI.style(UITheme.SURFACE_2, UITheme.RADIUS_SM, 1, UITheme.BORDER)
		sps.content_margin_left = 8; sps.content_margin_right = 8
		sps.content_margin_top = 6; sps.content_margin_bottom = 6
		sp.add_theme_stylebox_override("panel", sps)
		stats.add_child(sp)
		var scv := VBoxContainer.new()
		scv.add_theme_constant_override("separation", 2)
		sp.add_child(scv)
		scv.add_child(_mini_label(stat_vals[i], UITheme.FONT_SM, stat_colors[i]))
		scv.add_child(_mini_label("Metric", FS, UITheme.TEXT_MUTED))

	# Placeholder content
	body.add_child(_mini_rect(UITheme.SURFACE_2, 60, 0, UITheme.RADIUS_SM))
	body.add_child(_mini_rect(UITheme.SURFACE_2, 40, 0, UITheme.RADIUS_SM))


# ═══════════════════════════════════════════════════
# 3. SETTINGS
# ═══════════════════════════════════════════════════
func _settings_layout(parent: Control) -> void:
	var frame := _frame(parent, "Settings Page")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Left nav
	var nav_panel := PanelContainer.new()
	nav_panel.custom_minimum_size.x = 90
	nav_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var ns := UI.style(UITheme.SURFACE_2, 0)
	ns.border_width_right = 1; ns.border_color = UITheme.BORDER
	nav_panel.add_theme_stylebox_override("panel", ns)
	hbox.add_child(nav_panel)

	var nm := _mini_margin(nav_panel, 8)
	var nv := VBoxContainer.new()
	nv.add_theme_constant_override("separation", 3)
	nm.add_child(nv)

	var nav_items := ["General", "Profile", "Security", "Billing", "Team"]
	for i in nav_items.size():
		var ni := PanelContainer.new()
		ni.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var nis := UI.style(UITheme.PRIMARY_SOFT if i == 0 else Color(0,0,0,0), UITheme.RADIUS_SM)
		nis.content_margin_left = 8; nis.content_margin_top = 4; nis.content_margin_bottom = 4
		if i == 0:
			nis.border_width_left = 2; nis.border_color = UITheme.PRIMARY
		ni.add_theme_stylebox_override("panel", nis)
		nv.add_child(ni)
		ni.add_child(_mini_label(nav_items[i], FS, UITheme.PRIMARY_LIGHT if i == 0 else UITheme.TEXT_SECONDARY))

	# Right content
	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 0)
	hbox.add_child(right)

	var rm := _mini_margin(right, 12)
	var rv := VBoxContainer.new()
	rv.add_theme_constant_override("separation", 10)
	rm.add_child(rv)

	rv.add_child(_mini_label("General Settings", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	# Setting rows
	for item in [["Project Name", true], ["Description", true], ["Dark Mode", false], ["Notifications", false]]:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		rv.add_child(row)
		row.add_child(_mini_label(item[0], FS, UITheme.TEXT_SECONDARY))
		UI.h_expand(row)
		if item[1]:
			row.add_child(_mini_rect(UITheme.SURFACE_3, 16, 70, UITheme.RADIUS_SM))
		else:
			var toggle := _mini_rect(UITheme.PRIMARY, 12, 24, UITheme.RADIUS_PILL)
			row.add_child(toggle)

		# separator
		var sep := ColorRect.new()
		sep.color = UITheme.BORDER; sep.custom_minimum_size.y = 1
		sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rv.add_child(sep)


# ═══════════════════════════════════════════════════
# 4. CHAT
# ═══════════════════════════════════════════════════
func _chat_layout(parent: Control) -> void:
	var frame := _frame(parent, "Chat Interface")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Contacts
	var contacts := PanelContainer.new()
	contacts.custom_minimum_size.x = 80
	contacts.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var cs := UI.style(UITheme.SURFACE_2, 0)
	cs.border_width_right = 1; cs.border_color = UITheme.BORDER
	contacts.add_theme_stylebox_override("panel", cs)
	hbox.add_child(contacts)

	var cm := _mini_margin(contacts, 6)
	var cv := VBoxContainer.new()
	cv.add_theme_constant_override("separation", 4)
	cm.add_child(cv)

	var contact_colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.DANGER, UITheme.INFO]
	var contact_names  := ["AL", "BK", "CM", "DW", "EF"]
	for i in 5:
		var cr := HBoxContainer.new()
		cr.add_theme_constant_override("separation", 6)
		cv.add_child(cr)
		cr.add_child(_mini_rect(contact_colors[i], 16, 16, UITheme.RADIUS_PILL))
		var cn := VBoxContainer.new()
		cn.add_theme_constant_override("separation", 1)
		cr.add_child(cn)
		cn.add_child(_mini_label(contact_names[i], FS, UITheme.TEXT_PRIMARY))
		cn.add_child(_mini_rect(UITheme.SURFACE_3, 6, 40, 2))

	# Chat area
	var chat_v := VBoxContainer.new()
	chat_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_v.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	chat_v.add_theme_constant_override("separation", 0)
	hbox.add_child(chat_v)

	# Chat header
	var ch := PanelContainer.new()
	ch.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var chs := UI.style(UITheme.SURFACE_2, 0)
	chs.border_width_bottom = 1; chs.border_color = UITheme.BORDER
	chs.content_margin_left = 10; chs.content_margin_top = 6; chs.content_margin_bottom = 6
	ch.add_theme_stylebox_override("panel", chs)
	chat_v.add_child(ch)
	var chr := HBoxContainer.new()
	chr.add_theme_constant_override("separation", 6)
	ch.add_child(chr)
	chr.add_child(_mini_rect(UITheme.PRIMARY, 14, 14, UITheme.RADIUS_PILL))
	chr.add_child(_mini_label("Alice L.", FS, UITheme.TEXT_PRIMARY))

	# Messages
	var msg_m := _mini_margin(chat_v, 8)
	var msg_v := VBoxContainer.new()
	msg_v.add_theme_constant_override("separation", 6)
	msg_v.alignment = BoxContainer.ALIGNMENT_END
	msg_m.add_child(msg_v)

	# Other message (left)
	_msg_bubble(msg_v, "Hey, how's the project?", false)
	_msg_bubble(msg_v, "Going great! Almost done.", true)
	_msg_bubble(msg_v, "Can you share the repo?", false)
	_msg_bubble(msg_v, "Sure, sending link now!", true)

	# Input bar
	var input_bar := PanelContainer.new()
	input_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ibs := UI.style(UITheme.SURFACE_2, 0)
	ibs.border_width_top = 1; ibs.border_color = UITheme.BORDER
	ibs.content_margin_left = 8; ibs.content_margin_right = 8
	ibs.content_margin_top = 6; ibs.content_margin_bottom = 6
	input_bar.add_theme_stylebox_override("panel", ibs)
	chat_v.add_child(input_bar)
	var ibr := HBoxContainer.new()
	ibr.add_theme_constant_override("separation", 6)
	input_bar.add_child(ibr)
	ibr.add_child(_mini_rect(UITheme.SURFACE_3, 18, 0, UITheme.RADIUS_SM))
	ibr.add_child(_mini_rect(UITheme.PRIMARY, 18, 28, UITheme.RADIUS_SM))


func _msg_bubble(parent: Control, text: String, is_mine: bool) -> void:
	var row := HBoxContainer.new()
	parent.add_child(row)
	if is_mine: UI.h_expand(row)

	var bubble := PanelContainer.new()
	var color := UITheme.PRIMARY if is_mine else UITheme.SURFACE_3
	var bs := UI.style(color, UITheme.RADIUS_MD)
	bs.content_margin_left = 8; bs.content_margin_right = 8
	bs.content_margin_top = 4; bs.content_margin_bottom = 4
	bubble.add_theme_stylebox_override("panel", bs)
	row.add_child(bubble)

	var tc := Color.WHITE if is_mine else UITheme.TEXT_PRIMARY
	bubble.add_child(_mini_label(text, FS, tc))

	if not is_mine: UI.h_expand(row)


# ═══════════════════════════════════════════════════
# 5. CARD GRID
# ═══════════════════════════════════════════════════
func _card_grid_layout(parent: Control) -> void:
	var frame := _frame(parent, "Card Grid / Gallery")

	var body_m := _mini_margin(frame, 10)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	body_m.add_child(body)

	body.add_child(_mini_label("Featured Items", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))

	var colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.DANGER, UITheme.INFO, UITheme.SECONDARY]
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(grid)

	for i in 6:
		var gc := PanelContainer.new()
		gc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gc.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2, UITheme.RADIUS_SM, 1, UITheme.BORDER))
		grid.add_child(gc)

		var gv := VBoxContainer.new()
		gv.add_theme_constant_override("separation", 0)
		gc.add_child(gv)

		# Colored header
		gv.add_child(_mini_rect(colors[i], 40, 0, 0))
		# Body
		var gbm := MarginContainer.new()
		gbm.add_theme_constant_override("margin_left", 6); gbm.add_theme_constant_override("margin_right", 6)
		gbm.add_theme_constant_override("margin_top", 5); gbm.add_theme_constant_override("margin_bottom", 5)
		gv.add_child(gbm)
		var gbv := VBoxContainer.new()
		gbv.add_theme_constant_override("separation", 3)
		gbm.add_child(gbv)
		gbv.add_child(_mini_label("Item " + str(i + 1), FS, UITheme.TEXT_PRIMARY))
		gbv.add_child(_mini_rect(UITheme.SURFACE_3, 6, 50, 2))


# ═══════════════════════════════════════════════════
# 6. SIDEBAR + LIST
# ═══════════════════════════════════════════════════
func _list_layout(parent: Control) -> void:
	var frame := _frame(parent, "Sidebar + List")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Sidebar
	var sb := PanelContainer.new()
	sb.custom_minimum_size.x = 70
	sb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var sbs := UI.style(UITheme.SURFACE_2, 0)
	sbs.border_width_right = 1; sbs.border_color = UITheme.BORDER
	sb.add_theme_stylebox_override("panel", sbs)
	hbox.add_child(sb)

	var sm := _mini_margin(sb, 6)
	var sv := VBoxContainer.new()
	sv.add_theme_constant_override("separation", 3)
	sm.add_child(sv)
	sv.add_child(_mini_label("⬡ App", FS, UITheme.PRIMARY))
	UI.spacer(sv, 4)
	for item in ["Home", "Users", "Tasks", "Files"]:
		sv.add_child(_mini_label(item, FS, UITheme.TEXT_SECONDARY))

	# List
	var list_v := VBoxContainer.new()
	list_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_v.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	list_v.add_theme_constant_override("separation", 0)
	hbox.add_child(list_v)

	# Header
	var lh := PanelContainer.new()
	lh.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lhs := UI.style(UITheme.SURFACE_2, 0)
	lhs.border_width_bottom = 1; lhs.border_color = UITheme.BORDER
	lhs.content_margin_left = 10; lhs.content_margin_top = 6; lhs.content_margin_bottom = 6
	lh.add_theme_stylebox_override("panel", lhs)
	list_v.add_child(lh)
	lh.add_child(_mini_label("Users (48)", FS, UITheme.TEXT_PRIMARY))

	# List items
	var list_colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.DANGER, UITheme.INFO, UITheme.SECONDARY, UITheme.PRIMARY]
	var list_names  := ["Alice Johnson", "Bob Martinez", "Carol W.", "David Chen", "Elena K.", "Frank N.", "Grace T."]
	var list_roles  := ["Admin", "Editor", "Viewer", "Editor", "Admin", "Viewer", "Editor"]

	for i in list_names.size():
		var row := PanelContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var rs := UI.style(UITheme.SURFACE_2 if i % 2 == 0 else UITheme.SURFACE_1, 0)
		rs.border_width_bottom = 1; rs.border_color = UITheme.BORDER
		rs.content_margin_left = 10; rs.content_margin_right = 10
		rs.content_margin_top  = 5;  rs.content_margin_bottom = 5
		row.add_theme_stylebox_override("panel", rs)
		list_v.add_child(row)

		var rh := HBoxContainer.new()
		rh.add_theme_constant_override("separation", 6)
		row.add_child(rh)
		rh.add_child(_mini_rect(list_colors[i], 14, 14, UITheme.RADIUS_PILL))
		rh.add_child(_mini_label(list_names[i], FS, UITheme.TEXT_PRIMARY))
		UI.h_expand(rh)
		rh.add_child(_mini_label(list_roles[i], FS, UITheme.TEXT_MUTED))


# ═══════════════════════════════════════════════════
# 7. PROFILE PAGE
# ═══════════════════════════════════════════════════
func _profile_layout(parent: Control) -> void:
	var frame := _frame(parent, "Profile Page")

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(col)

	# Banner
	col.add_child(_mini_rect(UITheme.PRIMARY.darkened(0.4), 60, 0, 0))

	# Avatar + info overlay
	var info_m := MarginContainer.new()
	info_m.add_theme_constant_override("margin_left", 16); info_m.add_theme_constant_override("margin_right", 16)
	info_m.add_theme_constant_override("margin_top", 0);  info_m.add_theme_constant_override("margin_bottom", 0)
	col.add_child(info_m)

	var info_v := VBoxContainer.new()
	info_v.add_theme_constant_override("separation", 8)
	info_m.add_child(info_v)

	# Avatar row (overlapping banner)
	var av_row := HBoxContainer.new()
	av_row.add_theme_constant_override("separation", 10)
	info_v.add_child(av_row)

	var avatar := PanelContainer.new()
	avatar.custom_minimum_size = Vector2(36, 36)
	avatar.add_theme_stylebox_override("panel", UI.style(UITheme.PRIMARY, UITheme.RADIUS_PILL, 2, UITheme.SURFACE_1))
	av_row.add_child(avatar)
	var avc := CenterContainer.new()
	avatar.add_child(avc)
	avc.add_child(_mini_label("JD", FS, Color.WHITE))

	var name_v := VBoxContainer.new()
	name_v.add_theme_constant_override("separation", 1)
	av_row.add_child(name_v)
	name_v.add_child(_mini_label("Jane Doe", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	name_v.add_child(_mini_label("@janedoe · Designer", FS, UITheme.TEXT_MUTED))
	UI.h_expand(av_row)

	# Action buttons
	av_row.add_child(_mini_rect(UITheme.PRIMARY, 18, 50, UITheme.RADIUS_SM))
	av_row.add_child(_mini_rect(UITheme.SURFACE_3, 18, 18, UITheme.RADIUS_SM))

	# Bio
	info_v.add_child(_mini_label("Creating beautiful interfaces and pixel-perfect designs.", FS, UITheme.TEXT_SECONDARY))

	# Stats row
	var stats := HBoxContainer.new()
	stats.add_theme_constant_override("separation", 16)
	info_v.add_child(stats)
	for s in [["248", "Posts"], ["12.4K", "Followers"], ["891", "Following"]]:
		var sv := VBoxContainer.new()
		sv.add_theme_constant_override("separation", 1)
		stats.add_child(sv)
		sv.add_child(_mini_label(s[0], FS, UITheme.TEXT_PRIMARY))
		sv.add_child(_mini_label(s[1], FS, UITheme.TEXT_MUTED))

	# Tab bar
	var tab_bar := PanelContainer.new()
	tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var tbs := UI.style(UITheme.SURFACE_2, 0)
	tbs.border_width_top = 1; tbs.border_width_bottom = 1; tbs.border_color = UITheme.BORDER
	tbs.content_margin_left = 12; tbs.content_margin_top = 6; tbs.content_margin_bottom = 6
	tab_bar.add_theme_stylebox_override("panel", tbs)
	info_v.add_child(tab_bar)
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 16)
	tab_bar.add_child(tabs)
	for t in ["Posts", "Media", "Likes"]:
		var tc := UITheme.PRIMARY if t == "Posts" else UITheme.TEXT_MUTED
		tabs.add_child(_mini_label(t, FS, tc))

	# Post items
	for _i in 3:
		var post := PanelContainer.new()
		post.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var ps := UI.style(UITheme.SURFACE_2, 0)
		ps.border_width_bottom = 1; ps.border_color = UITheme.BORDER
		ps.content_margin_left = 12; ps.content_margin_right = 12
		ps.content_margin_top = 6; ps.content_margin_bottom = 6
		post.add_theme_stylebox_override("panel", ps)
		info_v.add_child(post)
		var pv := VBoxContainer.new()
		pv.add_theme_constant_override("separation", 4)
		post.add_child(pv)
		pv.add_child(_mini_rect(UITheme.SURFACE_3, 8, 0, 2))
		pv.add_child(_mini_rect(UITheme.SURFACE_3, 6, 120, 2))


# ═══════════════════════════════════════════════════
# 8. E-COMMERCE / PRODUCT
# ═══════════════════════════════════════════════════
func _ecommerce_layout(parent: Control) -> void:
	var frame := _frame(parent, "E-Commerce Product")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Product image area
	var img_panel := PanelContainer.new()
	img_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	img_panel.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	img_panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_3, 0))
	hbox.add_child(img_panel)
	var img_c := CenterContainer.new()
	img_panel.add_child(img_c)
	var img_icon := VBoxContainer.new()
	img_icon.add_theme_constant_override("separation", 6)
	img_c.add_child(img_icon)
	img_icon.add_child(_mini_label("⊞", UITheme.FONT_3XL, UITheme.TEXT_MUTED))
	var phl := _mini_label("Product Image", FS, UITheme.TEXT_MUTED)
	phl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	img_icon.add_child(phl)

	# Product details
	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 0)
	hbox.add_child(details)

	var dm := _mini_margin(details, 12)
	var dv := VBoxContainer.new()
	dv.add_theme_constant_override("separation", 8)
	dm.add_child(dv)

	# Breadcrumb
	dv.add_child(_mini_label("Home > Electronics > Headphones", FS, UITheme.TEXT_MUTED))
	# Title
	dv.add_child(_mini_label("Wireless Pro Max", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	# Rating stars
	dv.add_child(_mini_label("★★★★☆  4.2 (128 reviews)", FS, UITheme.WARNING))
	# Price
	var price_row := HBoxContainer.new()
	price_row.add_theme_constant_override("separation", 6)
	dv.add_child(price_row)
	price_row.add_child(_mini_label("$299", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))
	price_row.add_child(_mini_label("$399", FS, UITheme.TEXT_MUTED))

	# Separator
	dv.add_child(_mini_rect(UITheme.BORDER, 1, 0, 0))

	# Color options
	dv.add_child(_mini_label("Color", FS, UITheme.TEXT_SECONDARY))
	var colors := HBoxContainer.new()
	colors.add_theme_constant_override("separation", 6)
	dv.add_child(colors)
	for c in [UITheme.TEXT_PRIMARY, UITheme.PRIMARY, UITheme.DANGER]:
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(14, 14)
		dot.add_theme_stylebox_override("panel", UI.style(c, UITheme.RADIUS_PILL, 1, UITheme.BORDER))
		colors.add_child(dot)

	# Buttons
	var btn_v := VBoxContainer.new()
	btn_v.add_theme_constant_override("separation", 4)
	dv.add_child(btn_v)
	btn_v.add_child(_mini_rect(UITheme.PRIMARY, 22, 0, UITheme.RADIUS_SM))
	btn_v.add_child(_mini_rect(UITheme.SURFACE_3, 22, 0, UITheme.RADIUS_SM))


# ═══════════════════════════════════════════════════
# 9. EMAIL INBOX
# ═══════════════════════════════════════════════════
func _inbox_layout(parent: Control) -> void:
	var frame := _frame(parent, "Email Inbox")

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(hbox)

	# Folders sidebar
	var folders := PanelContainer.new()
	folders.custom_minimum_size.x = 65
	folders.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var fs := UI.style(UITheme.SURFACE_2, 0)
	fs.border_width_right = 1; fs.border_color = UITheme.BORDER
	folders.add_theme_stylebox_override("panel", fs)
	hbox.add_child(folders)

	var fm := _mini_margin(folders, 6)
	var fv := VBoxContainer.new()
	fv.add_theme_constant_override("separation", 3)
	fm.add_child(fv)
	fv.add_child(_mini_label("✉ Mail", FS, UITheme.PRIMARY))
	UI.spacer(fv, 2)
	var folder_items := [["Inbox", "24", true], ["Sent", "", false], ["Drafts", "3", false], ["Spam", "", false], ["Trash", "", false]]
	for f in folder_items:
		var fr := HBoxContainer.new()
		fr.add_theme_constant_override("separation", 4)
		fv.add_child(fr)
		fr.add_child(_mini_label(f[0], FS, UITheme.PRIMARY if f[2] else UITheme.TEXT_SECONDARY))
		if f[1] != "":
			UI.h_expand(fr)
			var badge := PanelContainer.new()
			badge.add_theme_stylebox_override("panel", UI.style(UITheme.PRIMARY if f[2] else UITheme.SURFACE_3, UITheme.RADIUS_PILL, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 4, 1))
			fr.add_child(badge)
			badge.add_child(_mini_label(f[1], FS, Color.WHITE if f[2] else UITheme.TEXT_MUTED))

	# Message list
	var msg_list := VBoxContainer.new()
	msg_list.custom_minimum_size.x = 130
	msg_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	msg_list.add_theme_constant_override("separation", 0)
	hbox.add_child(msg_list)

	# List header
	var lh := PanelContainer.new()
	lh.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lhs := UI.style(UITheme.SURFACE_2, 0)
	lhs.border_width_bottom = 1; lhs.border_width_right = 1; lhs.border_color = UITheme.BORDER
	lhs.content_margin_left = 8; lhs.content_margin_top = 5; lhs.content_margin_bottom = 5
	lh.add_theme_stylebox_override("panel", lhs)
	msg_list.add_child(lh)
	lh.add_child(_mini_label("Inbox (24)", FS, UITheme.TEXT_PRIMARY))

	var emails := [
		["Alice", "Project Update", true],
		["Bob", "Re: Meeting", true],
		["Carol", "Design Review", false],
		["Dave", "Invoice #482", false],
		["Eve", "Quick Question", false],
		["Frank", "Deploy Complete", false],
		["Grace", "Feedback Report", false],
	]
	for i in emails.size():
		var ep := PanelContainer.new()
		ep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var es := UI.style(UITheme.PRIMARY_SOFT if i == 0 else (UITheme.SURFACE_2 if i % 2 == 0 else UITheme.SURFACE_1), 0)
		es.border_width_bottom = 1; es.border_width_right = 1; es.border_color = UITheme.BORDER
		es.content_margin_left = 8; es.content_margin_right = 6
		es.content_margin_top = 4; es.content_margin_bottom = 4
		ep.add_theme_stylebox_override("panel", es)
		msg_list.add_child(ep)
		var ev := VBoxContainer.new()
		ev.add_theme_constant_override("separation", 1)
		ep.add_child(ev)
		var er := HBoxContainer.new()
		er.add_theme_constant_override("separation", 4)
		ev.add_child(er)
		er.add_child(_mini_label(emails[i][0], FS, UITheme.TEXT_PRIMARY))
		UI.h_expand(er)
		if emails[i][2]:
			er.add_child(_mini_rect(UITheme.PRIMARY, 5, 5, UITheme.RADIUS_PILL))
		ev.add_child(_mini_label(emails[i][1], FS, UITheme.TEXT_MUTED))

	# Preview pane
	var preview := VBoxContainer.new()
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	preview.add_theme_constant_override("separation", 0)
	hbox.add_child(preview)

	var ph := PanelContainer.new()
	ph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var phs := UI.style(UITheme.SURFACE_2, 0)
	phs.border_width_bottom = 1; phs.border_color = UITheme.BORDER
	phs.content_margin_left = 10; phs.content_margin_top = 5; phs.content_margin_bottom = 5
	ph.add_theme_stylebox_override("panel", phs)
	preview.add_child(ph)
	ph.add_child(_mini_label("Project Update", FS, UITheme.TEXT_PRIMARY))

	var pm := _mini_margin(preview, 10)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 6)
	pm.add_child(pv)
	var from_row := HBoxContainer.new()
	from_row.add_theme_constant_override("separation", 6)
	pv.add_child(from_row)
	from_row.add_child(_mini_rect(UITheme.PRIMARY, 16, 16, UITheme.RADIUS_PILL))
	from_row.add_child(_mini_label("Alice · 2h ago", FS, UITheme.TEXT_SECONDARY))
	pv.add_child(_mini_rect(UITheme.BORDER, 1, 0, 0))
	for _i in 4:
		pv.add_child(_mini_rect(UITheme.SURFACE_3, 6, 0, 2))


# ═══════════════════════════════════════════════════
# 10. KANBAN BOARD
# ═══════════════════════════════════════════════════
func _kanban_layout(parent: Control) -> void:
	var frame := _frame(parent, "Kanban Board")

	# Top bar
	var top := PanelContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ts := UI.style(UITheme.SURFACE_2, 0)
	ts.border_width_bottom = 1; ts.border_color = UITheme.BORDER
	ts.content_margin_left = 12; ts.content_margin_top = 6; ts.content_margin_bottom = 6
	top.add_theme_stylebox_override("panel", ts)
	frame.add_child(top)
	var th := HBoxContainer.new()
	top.add_child(th)
	th.add_child(_mini_label("Sprint #14", FS, UITheme.TEXT_PRIMARY))
	UI.h_expand(th)
	th.add_child(_mini_rect(UITheme.PRIMARY, 14, 14, UITheme.RADIUS_SM))

	# Columns
	var cols_m := _mini_margin(frame, 8)
	var cols := HBoxContainer.new()
	cols.add_theme_constant_override("separation", 8)
	cols.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols_m.add_child(cols)

	var col_data := [
		["To Do", UITheme.TEXT_MUTED, [["Setup CI pipeline", UITheme.DANGER], ["Write unit tests", UITheme.WARNING], ["Update docs", UITheme.INFO]]],
		["In Progress", UITheme.WARNING, [["Auth system", UITheme.PRIMARY], ["Dashboard UI", UITheme.SUCCESS]]],
		["Done", UITheme.SUCCESS, [["API endpoints", UITheme.SUCCESS], ["Database schema", UITheme.SUCCESS], ["Login page", UITheme.SUCCESS]]],
	]
	for cd in col_data:
		_kanban_col(cols, cd[0], cd[1], cd[2])


func _kanban_col(parent: Control, title: String, title_color: Color, cards: Array) -> void:
	var col := PanelContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	col.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2, UITheme.RADIUS_SM, 1, UITheme.BORDER))
	parent.add_child(col)

	var cm := MarginContainer.new()
	cm.add_theme_constant_override("margin_left", 6); cm.add_theme_constant_override("margin_right", 6)
	cm.add_theme_constant_override("margin_top", 6);  cm.add_theme_constant_override("margin_bottom", 6)
	col.add_child(cm)

	var cv := VBoxContainer.new()
	cv.add_theme_constant_override("separation", 5)
	cm.add_child(cv)

	# Column header
	var hr := HBoxContainer.new()
	hr.add_theme_constant_override("separation", 4)
	cv.add_child(hr)
	hr.add_child(_mini_rect(title_color, 6, 6, UITheme.RADIUS_PILL))
	hr.add_child(_mini_label(title, FS, UITheme.TEXT_PRIMARY))
	UI.h_expand(hr)
	hr.add_child(_mini_label(str(cards.size()), FS, UITheme.TEXT_MUTED))

	# Task cards
	for card in cards:
		var cp := PanelContainer.new()
		cp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cps := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_XS, 1, UITheme.BORDER)
		cps.content_margin_left = 6; cps.content_margin_right = 6
		cps.content_margin_top = 5; cps.content_margin_bottom = 5
		cp.add_theme_stylebox_override("panel", cps)
		cv.add_child(cp)
		var crv := VBoxContainer.new()
		crv.add_theme_constant_override("separation", 3)
		cp.add_child(crv)
		crv.add_child(_mini_label(card[0], FS, UITheme.TEXT_PRIMARY))
		crv.add_child(_mini_rect(card[1], 3, 24, 1))


# ═══════════════════════════════════════════════════
# 11. MEDIA PLAYER
# ═══════════════════════════════════════════════════
func _player_layout(parent: Control) -> void:
	var frame := _frame(parent, "Media Player")

	var bg := PanelContainer.new()
	bg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bg.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	bg.add_theme_stylebox_override("panel", UI.style(Color("#0A0A14"), 0))
	frame.add_child(bg)

	var bm := _mini_margin(bg, 16)
	var bv := VBoxContainer.new()
	bv.add_theme_constant_override("separation", 12)
	bv.alignment = BoxContainer.ALIGNMENT_CENTER
	bm.add_child(bv)

	# Album art placeholder
	var art_c := CenterContainer.new()
	bv.add_child(art_c)
	var art := PanelContainer.new()
	art.custom_minimum_size = Vector2(140, 140)
	art.add_theme_stylebox_override("panel", UI.style(UITheme.PRIMARY.darkened(0.5), UITheme.RADIUS_LG, 0, Color.TRANSPARENT, 16, Color(0, 0, 0, 0.4), Vector2(0, 6)))
	art_c.add_child(art)
	var art_inner := CenterContainer.new()
	art.add_child(art_inner)
	art_inner.add_child(_mini_label("♫", UITheme.FONT_3XL, UITheme.PRIMARY.lightened(0.3)))

	# Track info
	var info_c := CenterContainer.new()
	bv.add_child(info_c)
	var info_v := VBoxContainer.new()
	info_v.add_theme_constant_override("separation", 3)
	info_c.add_child(info_v)
	var title_l := _mini_label("Midnight Dreams", UITheme.FONT_SM, Color("#E8E9F3"))
	title_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_v.add_child(title_l)
	var artist_l := _mini_label("Ambient Collective", FS, Color("#6B7090"))
	artist_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_v.add_child(artist_l)

	# Progress bar
	var prog_v := VBoxContainer.new()
	prog_v.add_theme_constant_override("separation", 4)
	prog_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bv.add_child(prog_v)

	var bar := Control.new()
	bar.custom_minimum_size.y = 4
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prog_v.add_child(bar)
	var track := PanelContainer.new()
	track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	track.add_theme_stylebox_override("panel", UI.style(Color("#1A1A2E"), UITheme.RADIUS_PILL))
	bar.add_child(track)
	var fill := PanelContainer.new()
	fill.anchor_right = 0.35; fill.anchor_bottom = 1.0
	fill.add_theme_stylebox_override("panel", UI.style(UITheme.PRIMARY, UITheme.RADIUS_PILL))
	bar.add_child(fill)

	var time_r := HBoxContainer.new()
	prog_v.add_child(time_r)
	time_r.add_child(_mini_label("1:24", FS, Color("#555580")))
	UI.h_expand(time_r)
	time_r.add_child(_mini_label("3:58", FS, Color("#555580")))

	# Controls
	var ctrl_c := CenterContainer.new()
	bv.add_child(ctrl_c)
	var ctrls := HBoxContainer.new()
	ctrls.add_theme_constant_override("separation", 16)
	ctrl_c.add_child(ctrls)
	ctrls.add_child(_mini_label("⟳", UITheme.FONT_SM, Color("#555580")))
	ctrls.add_child(_mini_label("⟨⟨", UITheme.FONT_SM, Color("#AAAACC")))
	# Play button (circle)
	var play := PanelContainer.new()
	play.custom_minimum_size = Vector2(32, 32)
	play.add_theme_stylebox_override("panel", UI.style(Color.WHITE, UITheme.RADIUS_PILL))
	ctrls.add_child(play)
	var play_c := CenterContainer.new()
	play.add_child(play_c)
	play_c.add_child(_mini_label("▶", UITheme.FONT_SM, Color("#0A0A14")))
	ctrls.add_child(_mini_label("⟩⟩", UITheme.FONT_SM, Color("#AAAACC")))
	ctrls.add_child(_mini_label("♡", UITheme.FONT_SM, Color("#555580")))


# ═══════════════════════════════════════════════════
# 12. FORM WIZARD / STEPPER
# ═══════════════════════════════════════════════════
func _wizard_layout(parent: Control) -> void:
	var frame := _frame(parent, "Form Wizard / Stepper")

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	frame.add_child(col)

	# Step indicator header
	var step_bar := PanelContainer.new()
	step_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sbs := UI.style(UITheme.SURFACE_2, 0)
	sbs.border_width_bottom = 1; sbs.border_color = UITheme.BORDER
	sbs.content_margin_left = 16; sbs.content_margin_right = 16
	sbs.content_margin_top = 10; sbs.content_margin_bottom = 10
	step_bar.add_theme_stylebox_override("panel", sbs)
	col.add_child(step_bar)

	var steps_h := HBoxContainer.new()
	steps_h.add_theme_constant_override("separation", 0)
	steps_h.alignment = BoxContainer.ALIGNMENT_CENTER
	step_bar.add_child(steps_h)

	var step_names := ["Account", "Details", "Payment", "Confirm"]
	var current := 1  # "Details" is active
	for i in step_names.size():
		var step_v := VBoxContainer.new()
		step_v.add_theme_constant_override("separation", 3)
		steps_h.add_child(step_v)

		var dot_c := CenterContainer.new()
		step_v.add_child(dot_c)
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(18, 18)
		var dot_color: Color
		var text_c: Color
		if i < current:
			dot_color = UITheme.SUCCESS; text_c = UITheme.SUCCESS
		elif i == current:
			dot_color = UITheme.PRIMARY; text_c = UITheme.PRIMARY
		else:
			dot_color = UITheme.SURFACE_3; text_c = UITheme.TEXT_MUTED
		dot.add_theme_stylebox_override("panel", UI.style(dot_color, UITheme.RADIUS_PILL))
		dot_c.add_child(dot)
		var dc := CenterContainer.new()
		dot.add_child(dc)
		var dt := "✓" if i < current else str(i + 1)
		dc.add_child(_mini_label(dt, FS, Color.WHITE if i <= current else UITheme.TEXT_MUTED))

		var sl := _mini_label(step_names[i], FS, text_c)
		sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		step_v.add_child(sl)

		# Connector line
		if i < step_names.size() - 1:
			var line_wrap := Control.new()
			line_wrap.custom_minimum_size = Vector2(30, 2)
			line_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			steps_h.add_child(line_wrap)
			var line := ColorRect.new()
			line.anchor_top = 0.35; line.anchor_bottom = 0.35
			line.anchor_right = 1.0
			line.offset_bottom = 2
			line.color = UITheme.SUCCESS if i < current else UITheme.SURFACE_3
			line_wrap.add_child(line)

	# Form body
	var body_m := _mini_margin(col, 16)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 10)
	body_m.add_child(body)

	body.add_child(_mini_label("Personal Details", UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	body.add_child(_mini_label("Fill in your information to continue.", FS, UITheme.TEXT_MUTED))

	# Form fields
	var fields := [["First Name", "Jane"], ["Last Name", "Doe"], ["Phone", "+1 (555) 000-0000"]]
	for f in fields:
		var fv := VBoxContainer.new()
		fv.add_theme_constant_override("separation", 3)
		fv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		body.add_child(fv)
		fv.add_child(_mini_label(f[0], FS, UITheme.TEXT_SECONDARY))
		var inp := PanelContainer.new()
		inp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		inp.custom_minimum_size.y = 20
		var is_ := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_SM, 1, UITheme.BORDER)
		is_.content_margin_left = 8; is_.content_margin_top = 3; is_.content_margin_bottom = 3
		inp.add_theme_stylebox_override("panel", is_)
		fv.add_child(inp)
		inp.add_child(_mini_label(f[1], FS, UITheme.TEXT_PRIMARY))

	# Footer with buttons
	UI.h_expand(body)
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 8)
	footer.alignment = BoxContainer.ALIGNMENT_END
	body.add_child(footer)
	footer.add_child(_mini_rect(UITheme.SURFACE_3, 20, 50, UITheme.RADIUS_SM))
	footer.add_child(_mini_rect(UITheme.PRIMARY, 20, 70, UITheme.RADIUS_SM))
