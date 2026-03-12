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
