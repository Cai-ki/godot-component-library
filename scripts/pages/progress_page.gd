class_name ProgressPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Progress",
		"Progress indicators including linear bars, size variants, labeled progress, and step indicators.")

	_basic_progress(parent)
	_color_variants(parent)
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
	UI.section(parent, "Step Indicator")

	var card_v := UI.card(parent, 32, 28)

	var steps := ["Account", "Profile", "Settings", "Review", "Complete"]
	var current_step := 2  # 0-indexed, "Settings" is current

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 0)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	card_v.add_child(h)

	for i in steps.size():
		# Step circle + label
		var step_v := VBoxContainer.new()
		step_v.add_theme_constant_override("separation", 8)
		step_v.alignment = BoxContainer.ALIGNMENT_CENTER
		h.add_child(step_v)

		var circle_center := CenterContainer.new()
		step_v.add_child(circle_center)

		var circle := PanelContainer.new()
		circle.custom_minimum_size = Vector2(36, 36)

		var circle_color: Color
		var text_color: Color
		var label_color: Color

		if i < current_step:
			# Completed
			circle_color = UITheme.SUCCESS
			text_color = Color.WHITE
			label_color = UITheme.SUCCESS
		elif i == current_step:
			# Current
			circle_color = UITheme.PRIMARY
			text_color = Color.WHITE
			label_color = UITheme.PRIMARY
		else:
			# Future
			circle_color = UITheme.SURFACE_3
			text_color = UITheme.TEXT_MUTED
			label_color = UITheme.TEXT_MUTED

		circle.add_theme_stylebox_override("panel", UI.style(circle_color, UITheme.RADIUS_PILL))
		circle_center.add_child(circle)

		var num_center := CenterContainer.new()
		circle.add_child(num_center)

		var content_text := "✓" if i < current_step else str(i + 1)
		num_center.add_child(UI.label(content_text, UITheme.FONT_SM, text_color))

		# Step label
		var step_label := UI.label(steps[i], UITheme.FONT_XS, label_color)
		step_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		step_v.add_child(step_label)

		# Connector line (except last)
		if i < steps.size() - 1:
			var line_container := Control.new()
			line_container.custom_minimum_size = Vector2(60, 2)
			line_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			h.add_child(line_container)

			var line := ColorRect.new()
			line.anchor_top = 0.3
			line.anchor_bottom = 0.3
			line.anchor_left = 0
			line.anchor_right = 1
			line.offset_top = 0
			line.offset_bottom = 2
			line.color = UITheme.SUCCESS if i < current_step else UITheme.SURFACE_3
			line_container.add_child(line)


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
