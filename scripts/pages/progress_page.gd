class_name ProgressPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Progress",
		"Progress indicators including linear bars, size variants, labeled progress, and step indicators.")

	_basic_progress(parent)
	_color_variants(parent)
	_circular_progress(parent)
	_size_variants(parent)
	_labeled_progress(parent)
	_step_indicator(parent)
	_animated_progress(parent)


# =============================================
# BASIC PROGRESS BARS
# =============================================

func _basic_progress(parent: Control) -> void:
	UI.section(parent, "Basic Progress")
	var card_v := UI.card(parent, 24, 20)
	var v := UI.vbox(card_v, 14)
	_labeled_bar(v, "Initializing",  0.0,  UITheme.PRIMARY)
	_labeled_bar(v, "Uploading",     0.25, UITheme.PRIMARY)
	_labeled_bar(v, "Processing",    0.50, UITheme.PRIMARY)
	_labeled_bar(v, "Verifying",     0.75, UITheme.PRIMARY)
	_labeled_bar(v, "Complete",      1.0,  UITheme.SUCCESS)


func _progress_row(parent: Control, label_text: String, value: float, color: Color, height: int = 8) -> void:
	var h := UI.hbox(parent, 12)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	UI.progress_bar(h, value, color, height)

	var pct := UI.label(label_text, UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	pct.custom_minimum_size.x = 40
	pct.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(pct)


# =============================================
# COLOR VARIANTS
# =============================================

func _color_variants(parent: Control) -> void:
	UI.section(parent, "Color Variants")
	var card_v := UI.card(parent, 24, 20)
	var v := UI.vbox(card_v, 12)

	_labeled_bar(v, "Primary", 0.65, UITheme.PRIMARY)
	_labeled_bar(v, "Success", 0.80, UITheme.SUCCESS)
	_labeled_bar(v, "Warning", 0.45, UITheme.WARNING)
	_labeled_bar(v, "Danger", 0.30, UITheme.DANGER)
	_labeled_bar(v, "Info", 0.55, UITheme.INFO)
	_labeled_bar(v, "Secondary", 0.70, UITheme.SECONDARY)


func _labeled_bar(parent: Control, title: String, value: float, color: Color) -> void:
	var v := UI.vbox(parent, 6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var top := UI.hbox(v, 0)
	top.add_child(UI.label(title, UITheme.FONT_SM, UITheme.TEXT_PRIMARY))
	UI.h_expand(top)
	top.add_child(UI.label(str(int(value * 100)) + "%", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	UI.progress_bar(v, value, color)


# =============================================
# CIRCULAR PROGRESS
# =============================================

func _circular_progress(parent: Control) -> void:
	UI.section(parent, "Circular Progress")
	var card_v := UI.card(parent, 24, 24)

	# Row of rings
	var row := UI.hbox(card_v, 32)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	var items := [
		["Design",  0.95, UITheme.SUCCESS,   80.0, 6.0],
		["Code",    0.72, UITheme.PRIMARY,   80.0, 6.0],
		["Docs",    0.35, UITheme.WARNING,   80.0, 6.0],
		["Tests",   0.15, UITheme.DANGER,    80.0, 6.0],
	]

	for item in items:
		var col := UI.vbox(row, 8)
		col.alignment = BoxContainer.ALIGNMENT_CENTER

		var center := CenterContainer.new()
		col.add_child(center)

		var ring := UIProgressRing.new()
		ring.value = item[1]
		ring.progress_color = item[2]
		ring.ring_size = item[3]
		ring.thickness = item[4]
		center.add_child(ring)

		var lbl := UI.label(item[0], UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(lbl)

	# Size variants row
	UI.spacer(card_v, 8)
	card_v.add_child(UI.label("Size Variants", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	var row2 := UI.hbox(card_v, 24)
	row2.alignment = BoxContainer.ALIGNMENT_CENTER

	var sizes := [
		[48.0,  4.0, 0.6],
		[64.0,  5.0, 0.6],
		[96.0,  7.0, 0.6],
		[120.0, 8.0, 0.6],
	]
	for sz in sizes:
		var c := CenterContainer.new()
		row2.add_child(c)
		var ring := UIProgressRing.new()
		ring.value = sz[2]
		ring.ring_size = sz[0]
		ring.thickness = sz[1]
		c.add_child(ring)


# =============================================
# SIZE VARIANTS
# =============================================

func _size_variants(parent: Control) -> void:
	UI.section(parent, "Size Variants")
	var card_v := UI.card(parent, 24, 20)
	var v := UI.vbox(card_v, 16)

	var h1 := UI.hbox(v, 12)
	h1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h1.add_child(UI.label("Thin (4px)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.progress_bar(h1, 0.6, UITheme.PRIMARY, 4, UITheme.RADIUS_XS)

	var h2 := UI.hbox(v, 12)
	h2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h2.add_child(UI.label("Default (8px)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.progress_bar(h2, 0.6, UITheme.PRIMARY, 8, UITheme.RADIUS_SM)

	var h3 := UI.hbox(v, 12)
	h3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h3.add_child(UI.label("Thick (14px)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.progress_bar(h3, 0.6, UITheme.PRIMARY, 14, UITheme.RADIUS_MD)

	var h4 := UI.hbox(v, 12)
	h4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h4.add_child(UI.label("Large (20px)", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))
	UI.progress_bar(h4, 0.6, UITheme.PRIMARY, 20, UITheme.RADIUS_MD)


# =============================================
# LABELED PROGRESS
# =============================================

func _labeled_progress(parent: Control) -> void:
	UI.section(parent, "Project Progress")

	var card_v := UI.card(parent, 24, 20)

	var items := [
		["Design System", 0.95, UITheme.SUCCESS],
		["Component Library", 0.72, UITheme.PRIMARY],
		["Documentation", 0.35, UITheme.WARNING],
		["Testing", 0.15, UITheme.DANGER],
		["Deployment", 0.0, UITheme.TEXT_MUTED],
	]

	for i in items.size():
		var item: Array = items[i]
		_project_item(card_v, item[0], item[1], item[2])
		if i < items.size() - 1:
			UI.sep(card_v, 2)


func _project_item(parent: Control, title: String, value: float, color: Color) -> void:
	var v := UI.vbox(parent, 8)

	var top := UI.hbox(v, 0)
	top.add_child(UI.label(title, UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
	UI.h_expand(top)

	# Status badge
	var status_text := "Not Started"
	if value >= 1.0:
		status_text = "Complete"
	elif value >= 0.5:
		status_text = "In Progress"
	elif value > 0.0:
		status_text = "Started"
	UI.soft_badge(top, status_text, color, UITheme.RADIUS_SM, 8, 3, UITheme.FONT_XS)

	var bottom := UI.hbox(v, 12)
	bottom.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UI.progress_bar(bottom, value, color)
	var pct := UI.label(str(int(value * 100)) + "%", UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	pct.custom_minimum_size.x = 36
	pct.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	bottom.add_child(pct)


# =============================================
# STEP INDICATOR
# =============================================

func _step_indicator(parent: Control) -> void:
	UI.section(parent, "Step Indicator  (UISteps)")

	var card_v := UI.card(parent, 32, 28)

	# Static UISteps
	var st := UISteps.new()
	st.steps = PackedStringArray(["Account", "Profile", "Settings", "Review", "Complete"])
	st.current_step = 2
	card_v.add_child(st)

	# Interactive UISteps
	UI.spacer(card_v, 8)
	card_v.add_child(UI.label("Interactive (click steps or buttons)", UITheme.FONT_SM, UITheme.TEXT_MUTED))
	UI.spacer(card_v, 4)

	var st2 := UISteps.new()
	st2.steps = PackedStringArray(["Cart", "Shipping", "Payment", "Confirm"])
	st2.current_step = 0
	st2.clickable = true
	st2.step_clicked.connect(func(i: int): st2.current_step = i)
	card_v.add_child(st2)

	UI.spacer(card_v, 4)
	var btn_row := UI.hbox(card_v, 12)
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER

	var prev_btn := UI.outline_btn(btn_row, "◂  Previous", UITheme.TEXT_SECONDARY)
	prev_btn.pressed.connect(func(): st2.prev_step())

	var next_btn := UI.solid_btn(btn_row, "Next  ▸", UITheme.PRIMARY)
	next_btn.pressed.connect(func(): st2.next_step())


# =============================================
# ANIMATED PROGRESS
# =============================================

func _animated_progress(parent: Control) -> void:
	UI.section(parent, "Interactive Progress")

	var card_v := UI.card(parent, 24, 20)
	card_v.add_child(UI.label("Drag the slider to control progress", UITheme.FONT_SM, UITheme.TEXT_SECONDARY))

	var bar_container := Control.new()
	bar_container.custom_minimum_size = Vector2(0, 14)
	bar_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(bar_container)

	var track := PanelContainer.new()
	track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	track.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_3, UITheme.RADIUS_MD))
	bar_container.add_child(track)

	var fill := PanelContainer.new()
	fill.anchor_left = 0
	fill.anchor_top = 0
	fill.anchor_right = 0.5
	fill.anchor_bottom = 1.0
	fill.add_theme_stylebox_override("panel", UI.style(UITheme.PRIMARY, UITheme.RADIUS_MD))
	bar_container.add_child(fill)

	var pct_label := UI.label("50%", UITheme.FONT_2XL, UITheme.TEXT_PRIMARY)
	pct_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card_v.add_child(pct_label)

	# Slider control
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.step = 1
	slider.value = 50
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var track_style := UI.style(UITheme.SURFACE_3, UITheme.RADIUS_SM)
	var fill_style := UI.style(UITheme.PRIMARY, UITheme.RADIUS_SM)
	slider.add_theme_stylebox_override("slider", track_style)
	slider.add_theme_stylebox_override("grabber_area", fill_style)
	slider.add_theme_stylebox_override("grabber_area_highlight", fill_style)
	card_v.add_child(slider)

	slider.value_changed.connect(func(v: float):
		fill.anchor_right = v / 100.0
		pct_label.text = str(int(v)) + "%"

		# Change color based on value
		var color: Color
		if v >= 80:
			color = UITheme.SUCCESS
		elif v >= 50:
			color = UITheme.PRIMARY
		elif v >= 25:
			color = UITheme.WARNING
		else:
			color = UITheme.DANGER
		fill.add_theme_stylebox_override("panel", UI.style(color, UITheme.RADIUS_MD))
	)
