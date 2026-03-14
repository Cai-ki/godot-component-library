class_name DataPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Data & Display",
		"UITable, UIAvatar, UIDivider, UITag, UISkeletonLoader, UIContextMenu — data and decoration components.")

	_table_section(parent)
	_empty_section(parent)
	_context_menu_section(parent)
	_avatar_section(parent)
	_divider_section(parent)
	_tag_section(parent)
	_carousel_section(parent)
	_skeleton_section(parent)


# =============================================
# TABLE
# =============================================

func _table_section(parent: Control) -> void:
	UI.section(parent, "Data Table  (UITable)")
	var card_v := UI.card(parent, 24, 20)

	var table := UITable.new()
	table.sortable = true
	table.filterable = true
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(table)

	table.set_columns(PackedStringArray(["Name", "Role", "Status", "Joined"]))
	var rows := [
		["Alice Johnson",  "Senior Dev",    "Active",    "2022-03-14"],
		["Bob Martinez",   "Designer",      "Active",    "2023-01-08"],
		["Carol Williams", "Product Lead",  "Away",      "2021-11-20"],
		["David Chen",     "QA Engineer",   "Active",    "2023-07-02"],
		["Elena Kowalski", "Backend Dev",   "Inactive",  "2022-09-15"],
		["Frank Nguyen",   "DevOps",        "Active",    "2024-01-30"],
	]
	for row in rows:
		table.add_row(row)

	# Pagination below the table
	UI.sep(card_v, 4)
	var pag_row := HBoxContainer.new()
	pag_row.add_theme_constant_override("separation", 0)
	pag_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(pag_row)

	var pag_info := UI.label("Showing page 1 of 10", UITheme.FONT_SM, UITheme.TEXT_MUTED)
	pag_row.add_child(pag_info)
	UI.h_expand(pag_row)

	var pagination := UIPagination.new()
	pagination.total_pages = 10
	pagination.current_page = 1
	pag_row.add_child(pagination)

	pagination.page_changed.connect(func(page: int):
		pag_info.text = "Showing page " + str(page) + " of 10"
	)


# =============================================
# AVATARS
# =============================================

func _avatar_section(parent: Control) -> void:
	UI.section(parent, "Avatar Component  (UIAvatar)")

	# Size variants
	var size_card := UI.card(parent, 24, 20)

	var size_h := UI.hbox(size_card, 20)
	size_h.alignment = BoxContainer.ALIGNMENT_CENTER

	var sizes := [
		[UIAvatar.AvatarSize.XS, "XS"],
		[UIAvatar.AvatarSize.SM, "SM"],
		[UIAvatar.AvatarSize.MD, "MD"],
		[UIAvatar.AvatarSize.LG, "LG"],
		[UIAvatar.AvatarSize.XL, "XL"],
	]
	var colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.DANGER, UITheme.INFO]
	var initials_list := ["AB", "CD", "EF", "GH", "IJ"]

	for i in sizes.size():
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 8)
		v.alignment = BoxContainer.ALIGNMENT_CENTER
		size_h.add_child(v)
		var av := UIAvatar.new()
		av.avatar_size = sizes[i][0]
		av.initials = initials_list[i]
		av.bg_color = colors[i]
		var center := CenterContainer.new()
		center.add_child(av)
		v.add_child(center)
		v.add_child(UI.label(sizes[i][1], UITheme.FONT_XS, UITheme.TEXT_MUTED))

	# Status variants
	var div := UIDivider.new()
	div.divider_label = "Status Indicators"
	size_card.add_child(div)

	var status_h := UI.hbox(size_card, 24)
	status_h.alignment = BoxContainer.ALIGNMENT_CENTER

	var statuses := [
		[UIAvatar.StatusType.ONLINE,  "Online",  UITheme.PRIMARY],
		[UIAvatar.StatusType.AWAY,    "Away",    UITheme.WARNING],
		[UIAvatar.StatusType.BUSY,    "Busy",    UITheme.DANGER],
		[UIAvatar.StatusType.OFFLINE, "Offline", UITheme.SECONDARY],
	]
	var si_names := ["JD", "AS", "MB", "CL"]

	for i in statuses.size():
		var sv := VBoxContainer.new()
		sv.add_theme_constant_override("separation", 8)
		sv.alignment = BoxContainer.ALIGNMENT_CENTER
		status_h.add_child(sv)
		var av := UIAvatar.new()
		av.initials = si_names[i]
		av.bg_color = statuses[i][2]
		av.status = statuses[i][0]
		var center := CenterContainer.new()
		center.add_child(av)
		sv.add_child(center)
		sv.add_child(UI.label(statuses[i][1], UITheme.FONT_XS, UITheme.TEXT_MUTED))

	# Avatar group / stack
	var div2 := UIDivider.new()
	div2.divider_label = "Avatar Group"
	size_card.add_child(div2)

	var group_h := UI.hbox(size_card, 0)
	var group_colors := [UITheme.PRIMARY, UITheme.SUCCESS, UITheme.WARNING, UITheme.DANGER, UITheme.INFO]
	var group_names  := ["AA", "BB", "CC", "DD", "EE"]
	for i in 5:
		var av := UIAvatar.new()
		av.initials = group_names[i]
		av.bg_color = group_colors[i]
		av.avatar_size = UIAvatar.AvatarSize.SM
		# Overlap effect via negative margin
		if i > 0:
			var spacer := Control.new()
			spacer.custom_minimum_size = Vector2(-8, 0)
			group_h.add_child(spacer)
		group_h.add_child(av)
	group_h.add_child(UI.label("  +24 more", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))


# =============================================
# DIVIDERS
# =============================================

func _divider_section(parent: Control) -> void:
	UI.section(parent, "Divider Component  (UIDivider)")

	var div_card := UI.card(parent, 24, 20)

	div_card.add_child(UI.label("Default horizontal line", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var d1 := UIDivider.new()
	div_card.add_child(d1)

	div_card.add_child(UI.label("With label", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var d2 := UIDivider.new()
	d2.divider_label = "OR"
	div_card.add_child(d2)

	div_card.add_child(UI.label("Colored", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var d3 := UIDivider.new()
	d3.divider_color = UITheme.PRIMARY
	d3.divider_label = "Section Break"
	div_card.add_child(d3)

	div_card.add_child(UI.label("Thick (4px)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var d4 := UIDivider.new()
	d4.thickness = 4
	d4.divider_color = UITheme.BORDER_STRONG
	div_card.add_child(d4)


# =============================================
# TAGS
# =============================================

func _tag_section(parent: Control) -> void:
	UI.section(parent, "Tag Component  (UITag)")

	var tag_card := UI.card(parent, 24, 20)

	tag_card.add_child(UI.label("Removable tags (click ✕ to remove)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 8)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tag_card.add_child(flow)

	var tag_data := [
		["Godot", UITheme.PRIMARY], ["GDScript", UITheme.INFO], ["2D", UITheme.SUCCESS],
		["Physics", UITheme.WARNING], ["UI Design", UITheme.DANGER], ["Particles", UITheme.SECONDARY],
		["Shaders", UITheme.PRIMARY], ["Audio", UITheme.SUCCESS], ["Networking", UITheme.INFO],
	]
	for td in tag_data:
		var tag := UITag.new()
		tag.tag_text = td[0]; tag.tag_color = td[1]
		flow.add_child(tag)

	# Non-removable pill tags
	var div := UIDivider.new()
	div.divider_label = "Non-removable"
	tag_card.add_child(div)

	var pill_row := UI.hbox(tag_card, 8)
	for td in tag_data.slice(0, 5):
		var tag := UITag.new()
		tag.tag_text = td[0]; tag.tag_color = td[1]
		tag.removable = false; tag.pill_shape = true
		pill_row.add_child(tag)
	UI.h_expand(pill_row)


# =============================================
# CAROUSEL
# =============================================

func _carousel_section(parent: Control) -> void:
	UI.section(parent, "Carousel  (UICarousel)")
	var card_v := UI.card(parent, 24, 20)

	# Build sample slides
	var carousel := UICarousel.new()
	carousel.slide_height = 220.0
	card_v.add_child(carousel)

	var colors := [UITheme.PRIMARY_SOFT, UITheme.SUCCESS_SOFT, UITheme.WARNING_SOFT, UITheme.DANGER_SOFT]
	var titles := ["Welcome to the Carousel", "Slide with Components", "Design System", "Get Started"]
	var descs := [
		"Swipe through slides with smooth animations.",
		"Each slide can contain any Godot Control.",
		"Dark Indigo design system with 3 theme presets.",
		"Copy components/ + scripts/theme.gd to use.",
	]

	for i in range(4):
		var slide := PanelContainer.new()
		var ss := StyleBoxFlat.new()
		ss.bg_color = colors[i]
		ss.content_margin_left = 40; ss.content_margin_right = 40
		ss.content_margin_top = 30; ss.content_margin_bottom = 30
		slide.add_theme_stylebox_override("panel", ss)

		var sv := VBoxContainer.new()
		sv.add_theme_constant_override("separation", 12)
		sv.alignment = BoxContainer.ALIGNMENT_CENTER
		sv.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slide.add_child(sv)

		var t := Label.new()
		t.text = titles[i]
		t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		t.add_theme_font_size_override("font_size", UITheme.FONT_2XL)
		t.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sv.add_child(t)

		var d := Label.new()
		d.text = descs[i]
		d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		d.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		d.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
		d.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sv.add_child(d)

		carousel.add_slide(slide)

	UI.spacer(card_v, 8)

	# Auto-play variant
	card_v.add_child(UI.label("Auto-play (4s interval)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	var carousel2 := UICarousel.new()
	carousel2.slide_height = 140.0
	carousel2.auto_play = true
	carousel2.interval = 4.0
	card_v.add_child(carousel2)

	var auto_colors := [UITheme.SECONDARY_SOFT, UITheme.INFO_SOFT, UITheme.PRIMARY_SOFT]
	var auto_labels := ["Auto Slide 1", "Auto Slide 2", "Auto Slide 3"]
	for i in range(3):
		var slide := PanelContainer.new()
		var ss := StyleBoxFlat.new()
		ss.bg_color = auto_colors[i]
		ss.content_margin_left = 20; ss.content_margin_right = 20
		ss.content_margin_top = 20; ss.content_margin_bottom = 20
		slide.add_theme_stylebox_override("panel", ss)

		var lbl := Label.new()
		lbl.text = auto_labels[i]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", UITheme.FONT_XL)
		lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slide.add_child(lbl)

		carousel2.add_slide(slide)


# =============================================
# SKELETON
# =============================================

func _skeleton_section(parent: Control) -> void:
	UI.section(parent, "Skeleton Loader  (UISkeletonLoader)")

	var skel_card := UI.card(parent, 24, 20)
	skel_card.add_child(UI.label(
		"Click \"Load Content\" to see the skeleton → content transition.",
		UITheme.FONT_SM, UITheme.TEXT_SECONDARY
	))

	# ── Skeleton row (visible initially) ──
	var skeleton_row := UI.hbox(skel_card, 16)
	for _i in 2:
		_build_skeleton_card(skeleton_row)

	# ── Content row (hidden initially) ──
	var content_row := UI.hbox(skel_card, 16)
	content_row.modulate.a = 0.0
	content_row.visible = false

	var people := [
		["JD", UITheme.PRIMARY,   "Jane Doe",     "Lead Designer",
		 "Crafts design systems and component libraries for Godot-based projects."],
		["AS", UITheme.SUCCESS,   "Alex Smith",   "Frontend Dev",
		 "Builds responsive UI layouts and interactive prototypes using GDScript."],
	]
	for p: Array in people:
		_build_real_card(content_row, p[0], p[1], p[2], p[3], p[4])

	# ── Controls ──
	var btn_row := UI.hbox(skel_card, 12)
	var load_btn  := UI.solid_btn(btn_row,   "▶  Load Content",  UITheme.PRIMARY)
	var reset_btn := UI.outline_btn(btn_row,  "↺  Show Loading",  UITheme.TEXT_SECONDARY)
	reset_btn.visible = false
	UI.h_expand(btn_row)

	load_btn.pressed.connect(func():
		load_btn.visible = false
		var t := skeleton_row.create_tween()
		t.tween_property(skeleton_row, "modulate:a", 0.0, 0.3)
		t.finished.connect(func():
			skeleton_row.visible = false
			content_row.visible = true
			content_row.create_tween() \
				.tween_property(content_row, "modulate:a", 1.0, 0.4) \
				.set_trans(Tween.TRANS_SINE)
			reset_btn.visible = true
		)
	)
	reset_btn.pressed.connect(func():
		reset_btn.visible = false
		var t := content_row.create_tween()
		t.tween_property(content_row, "modulate:a", 0.0, 0.3)
		t.finished.connect(func():
			content_row.visible = false
			skeleton_row.visible = true
			skeleton_row.create_tween() \
				.tween_property(skeleton_row, "modulate:a", 1.0, 0.4)
			load_btn.visible = true
		)
	)


func _build_skeleton_card(parent: Control) -> void:
	var cv := VBoxContainer.new()
	cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cv.add_theme_constant_override("separation", 10)
	parent.add_child(cv)

	var card_panel := PanelContainer.new()
	card_panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2, UITheme.RADIUS_LG, 1, UITheme.BORDER))
	cv.add_child(card_panel)

	var cm := MarginContainer.new()
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		cm.add_theme_constant_override(side, 20)
	card_panel.add_child(cm)

	var iv := VBoxContainer.new()
	iv.add_theme_constant_override("separation", 10)
	cm.add_child(iv)

	# Avatar + name skeleton
	var top := UI.hbox(iv, 12)
	var av_skel := UISkeletonLoader.new()
	av_skel.min_width = 40; av_skel.min_height = 40; av_skel.radius = UITheme.RADIUS_PILL
	top.add_child(av_skel)
	var name_skel := VBoxContainer.new()
	name_skel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_skel.add_theme_constant_override("separation", 6)
	top.add_child(name_skel)
	var s1 := UISkeletonLoader.new(); s1.min_height = 14; s1.min_width = 0
	s1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_skel.add_child(s1)
	var s2 := UISkeletonLoader.new(); s2.min_height = 10; s2.min_width = 0
	s2.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN; s2.custom_minimum_size.x = 80
	name_skel.add_child(s2)

	# Text line skeletons
	for _j in 3:
		var sl := UISkeletonLoader.new()
		sl.min_height = 10; sl.min_width = 0
		sl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		iv.add_child(sl)


func _build_real_card(parent: Control, initials: String, color: Color,
		person_name: String, role: String, bio: String) -> void:
	var cv := VBoxContainer.new()
	cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cv.add_theme_constant_override("separation", 10)
	parent.add_child(cv)

	var card_panel := PanelContainer.new()
	card_panel.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_2, UITheme.RADIUS_LG, 1, UITheme.BORDER))
	cv.add_child(card_panel)

	var cm := MarginContainer.new()
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		cm.add_theme_constant_override(side, 20)
	card_panel.add_child(cm)

	var iv := VBoxContainer.new()
	iv.add_theme_constant_override("separation", 10)
	cm.add_child(iv)

	# Avatar + name
	var top := UI.hbox(iv, 12)
	var av := UIAvatar.new()
	av.initials = initials; av.bg_color = color; av.avatar_size = UIAvatar.AvatarSize.SM
	top.add_child(av)
	var name_v := VBoxContainer.new()
	name_v.add_theme_constant_override("separation", 2)
	name_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(name_v)
	name_v.add_child(UI.label(person_name, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
	name_v.add_child(UI.label(role, UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	# Bio text
	var bio_lbl := UI.label(bio, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	bio_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	iv.add_child(bio_lbl)


# =============================================
# EMPTY STATES
# =============================================

func _empty_section(parent: Control) -> void:
	UI.section(parent, "Empty States  (UIEmpty)")
	var card_v := UI.card(parent, 24, 24)
	var row := UI.hbox(card_v, 24)

	# No results
	var e1 := UIEmpty.new()
	e1.icon_text = "◇"
	e1.title_text = "No results found"
	e1.description_text = "Try adjusting your search or filters to find what you're looking for."
	e1.action_label = "Clear Filters"
	e1.custom_minimum_size.y = 200
	row.add_child(e1)

	# Empty inbox
	var e2 := UIEmpty.new()
	e2.icon_text = "✉"
	e2.title_text = "Inbox empty"
	e2.description_text = "You have no new messages."
	e2.accent_color = UITheme.SUCCESS
	e2.custom_minimum_size.y = 200
	row.add_child(e2)

	# No data with action
	var e3 := UIEmpty.new()
	e3.icon_text = "◈"
	e3.title_text = "No projects yet"
	e3.description_text = "Create your first project to get started."
	e3.action_label = "New Project"
	e3.accent_color = UITheme.SECONDARY
	e3.custom_minimum_size.y = 200
	row.add_child(e3)


# =============================================
# CONTEXT MENU
# =============================================

func _context_menu_section(parent: Control) -> void:
	UI.section(parent, "Context Menu  (UIContextMenu)")

	var toast := UIToast.new()
	parent.add_child(toast)

	var card_v := UI.card(parent, 24, 20)
	card_v.add_child(UI.label(
		"Right-click any row to open its context menu. "
		+ "Add UIContextMenu as a child node, build items, then call attach() or show_at().",
		UITheme.FONT_SM, UITheme.TEXT_SECONDARY
	))

	var files := [
		["◆", UITheme.PRIMARY,   "design_system.gd",     "12 KB"],
		["◈", UITheme.INFO,      "ui_button.gd",         "4 KB"],
		["◇", UITheme.SUCCESS,   "helpers.gd",           "8 KB"],
		["◉", UITheme.WARNING,   "ui_modal.gd",          "6 KB"],
		["⊞", UITheme.SECONDARY, "animations_page.gd",   "9 KB"],
	]

	var list_v := UI.vbox(card_v, 0)

	for i in files.size():
		var f: Array = files[i]
		var row := PanelContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.mouse_filter = Control.MOUSE_FILTER_STOP

		var normal_s := UI.style(UITheme.SURFACE_2,   UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 10)
		var hover_s  := UI.style(UITheme.SURFACE_3,   UITheme.RADIUS_MD, 0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 10)
		row.add_theme_stylebox_override("panel", normal_s)
		row.mouse_entered.connect(func(): row.add_theme_stylebox_override("panel", hover_s))
		row.mouse_exited.connect(func():  row.add_theme_stylebox_override("panel", normal_s))

		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 12)
		h.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_child(h)

		h.add_child(UI.label(f[0] as String, UITheme.FONT_MD, f[1] as Color))
		var name_lbl := UI.label(f[2] as String, UITheme.FONT_MD, UITheme.TEXT_PRIMARY)
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(name_lbl)
		h.add_child(UI.label(f[3] as String, UITheme.FONT_SM, UITheme.TEXT_MUTED))

		list_v.add_child(row)
		if i < files.size() - 1:
			UI.sep(list_v, 0)

		# Build context menu for this row
		var menu := UIContextMenu.new()
		parent.add_child(menu)
		var fname: String = f[2] as String
		menu.add_item("⊕  Open",       func(): toast.show_toast("Opened " + fname, UIToast.ToastType.INFO))
		menu.add_item("✎  Rename",     func(): toast.show_toast("Rename: " + fname, UIToast.ToastType.INFO))
		menu.add_item("⊞  Duplicate",  func(): toast.show_toast("Duplicated " + fname, UIToast.ToastType.SUCCESS))
		menu.add_separator()
		menu.add_item("✕  Delete",     func(): toast.show_toast("Deleted " + fname, UIToast.ToastType.ERROR), true)
		menu.attach(row)
