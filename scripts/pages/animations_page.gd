class_name AnimationsPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Animation Patterns",
		"Tween-based UI animations. Each demo is interactive — click Replay to re-trigger. "
		+ "All patterns use node.create_tween() so they work inside any Control.")

	_fade_section(parent)
	_slide_section(parent)
	_stagger_section(parent)
	_easing_section(parent)
	_counter_section(parent)


# =============================================
# 1. FADE
# =============================================

func _fade_section(parent: Control) -> void:
	UI.section(parent, "Fade  (modulate:a)")
	var card_v := UI.card(parent, 24, 20)

	# Preview element
	var preview := PanelContainer.new()
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview.add_theme_stylebox_override("panel", UI.style(
		UITheme.PRIMARY_SOFT, UITheme.RADIUS_LG, 1, UITheme.PRIMARY.darkened(0.3)
	))
	card_v.add_child(preview)

	var pm := MarginContainer.new()
	for s in ["margin_left","margin_right","margin_top","margin_bottom"]:
		pm.add_theme_constant_override(s, 20)
	preview.add_child(pm)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 4)
	pv.alignment = BoxContainer.ALIGNMENT_CENTER
	pm.add_child(pv)
	var pi := UI.label("◆", UITheme.FONT_2XL, UITheme.PRIMARY)
	pi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(pi)
	var pt := UI.label("Fade Demo", UITheme.FONT_LG, UITheme.TEXT_PRIMARY)
	pt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pv.add_child(pt)

	# Controls
	var row := UI.hbox(card_v, 10)
	var btn_in  := UI.solid_btn(row, "Fade In  ▼", UITheme.SUCCESS, UITheme.TEXT_INVERSE)
	var btn_out := UI.solid_btn(row, "Fade Out ▲", UITheme.DANGER)
	var btn_tog := UI.outline_btn(row, "Toggle  ↔", UITheme.PRIMARY)
	UI.h_expand(row)

	btn_in.pressed.connect(func():
		preview.create_tween().tween_property(preview, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)
	)
	btn_out.pressed.connect(func():
		preview.create_tween().tween_property(preview, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	)
	btn_tog.pressed.connect(func():
		var target := 0.0 if preview.modulate.a > 0.5 else 1.0
		preview.create_tween().tween_property(preview, "modulate:a", target, 0.4).set_trans(Tween.TRANS_SINE)
	)

	card_v.add_child(UI.label(
		"tween.tween_property(node, \"modulate:a\", 1.0, 0.4).set_trans(Tween.TRANS_SINE)",
		UITheme.FONT_XS, UITheme.TEXT_MUTED
	))


# =============================================
# 2. SLIDE
# =============================================

func _slide_section(parent: Control) -> void:
	UI.section(parent, "Slide  (position:x)")
	var card_v := UI.card(parent, 24, 20)

	# Clipping stage
	var stage := Control.new()
	stage.clip_contents = true
	stage.custom_minimum_size = Vector2(0, 80)
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_v.add_child(stage)

	# Sliding card
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(220, 60)
	panel.position = Vector2(-240, 10)
	panel.add_theme_stylebox_override("panel", UI.style(
		UITheme.SECONDARY.darkened(0.2), UITheme.RADIUS_LG,
		1, UITheme.SECONDARY.lightened(0.1), 8, Color(0, 0, 0, 0.2), Vector2(0, 3)
	))
	stage.add_child(panel)

	var pm := MarginContainer.new()
	for s in ["margin_left","margin_right","margin_top","margin_bottom"]:
		pm.add_theme_constant_override(s, 14)
	panel.add_child(pm)
	var ph := HBoxContainer.new()
	ph.add_theme_constant_override("separation", 12)
	ph.alignment = BoxContainer.ALIGNMENT_CENTER
	pm.add_child(ph)
	ph.add_child(UI.label("⊞", UITheme.FONT_2XL, UITheme.SECONDARY.lightened(0.4)))
	var pv2 := VBoxContainer.new()
	pv2.add_theme_constant_override("separation", 2)
	ph.add_child(pv2)
	pv2.add_child(UI.label("Slide Panel", UITheme.FONT_MD, UITheme.TEXT_PRIMARY))
	pv2.add_child(UI.label("TRANS_BACK · EASE_OUT", UITheme.FONT_XS, UITheme.TEXT_MUTED))

	# Controls
	var row := UI.hbox(card_v, 10)
	var btn_slide := UI.solid_btn(row, "→  Slide In", UITheme.SECONDARY)
	var btn_reset := UI.outline_btn(row, "↺  Reset",   UITheme.TEXT_SECONDARY)
	UI.h_expand(row)

	btn_slide.pressed.connect(func():
		panel.create_tween() \
			.tween_property(panel, "position:x", 20.0, 0.5) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	)
	btn_reset.pressed.connect(func():
		panel.create_tween() \
			.tween_property(panel, "position:x", -240.0, 0.3) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	)

	card_v.add_child(UI.label(
		"tween.tween_property(node, \"position:x\", 20.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)",
		UITheme.FONT_XS, UITheme.TEXT_MUTED
	))


# =============================================
# 3. STAGGER
# =============================================

func _stagger_section(parent: Control) -> void:
	UI.section(parent, "Stagger  (set_parallel + set_delay)")
	var card_v := UI.card(parent, 24, 20)

	var colors := [
		UITheme.PRIMARY, UITheme.INFO, UITheme.SUCCESS,
		UITheme.WARNING, UITheme.DANGER, UITheme.SECONDARY,
		UITheme.PRIMARY.lightened(0.2), UITheme.SUCCESS.lightened(0.2),
	]

	var blocks_row := UI.hbox(card_v, 8)
	blocks_row.alignment = BoxContainer.ALIGNMENT_CENTER
	var blocks: Array[Control] = []

	for i in colors.size():
		var b := PanelContainer.new()
		b.custom_minimum_size = Vector2(52, 52)
		b.add_theme_stylebox_override("panel", UI.style(colors[i], UITheme.RADIUS_MD))
		var bc := CenterContainer.new()
		b.add_child(bc)
		bc.add_child(UI.label(str(i + 1), UITheme.FONT_MD, Color.WHITE))
		blocks_row.add_child(b)
		blocks.append(b)

	UI.h_expand(blocks_row)

	var row := UI.hbox(card_v, 10)
	var btn := UI.solid_btn(row, "↺  Replay Stagger", UITheme.PRIMARY)
	UI.h_expand(row)

	btn.pressed.connect(func():
		for b in blocks:
			b.modulate.a = 0.0
			b.scale = Vector2(0.7, 0.7)
		var tween := blocks[0].create_tween()
		tween.set_parallel(true)
		for i in blocks.size():
			tween.tween_property(blocks[i], "modulate:a", 1.0, 0.35) \
				.set_delay(i * 0.07).set_trans(Tween.TRANS_SINE)
			tween.tween_property(blocks[i], "scale", Vector2.ONE, 0.35) \
				.set_delay(i * 0.07).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	)

	card_v.add_child(UI.label(
		"tween.set_parallel(true)  →  tween_property(...).set_delay(i * 0.07)",
		UITheme.FONT_XS, UITheme.TEXT_MUTED
	))


# =============================================
# 4. EASING SHOWCASE
# =============================================

func _easing_section(parent: Control) -> void:
	UI.section(parent, "Easing Functions")
	var card_v := UI.card(parent, 24, 20)

	var easings := [
		["LINEAR",  Tween.TRANS_LINEAR,  UITheme.TEXT_SECONDARY],
		["SINE",    Tween.TRANS_SINE,    UITheme.INFO],
		["BACK",    Tween.TRANS_BACK,    UITheme.PRIMARY],
		["BOUNCE",  Tween.TRANS_BOUNCE,  UITheme.WARNING],
		["ELASTIC", Tween.TRANS_ELASTIC, UITheme.DANGER],
	]

	var fills: Array[Control] = []

	for ed in easings:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card_v.add_child(row)

		var lbl := UI.label(ed[0] as String, UITheme.FONT_SM, ed[2] as Color)
		lbl.custom_minimum_size.x = 72
		row.add_child(lbl)

		# Track
		var bar_outer := Control.new()
		bar_outer.custom_minimum_size.y = 10
		bar_outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(bar_outer)

		var track := PanelContainer.new()
		track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		track.add_theme_stylebox_override("panel", UI.style(UITheme.SURFACE_3, UITheme.RADIUS_SM))
		bar_outer.add_child(track)

		var fill := PanelContainer.new()
		fill.anchor_left = 0.0; fill.anchor_top = 0.0
		fill.anchor_right = 0.0; fill.anchor_bottom = 1.0
		fill.add_theme_stylebox_override("panel", UI.style(ed[2] as Color, UITheme.RADIUS_SM))
		bar_outer.add_child(fill)
		fills.append(fill)

	var row2 := UI.hbox(card_v, 10)
	var btn := UI.solid_btn(row2, "↺  Replay All", UITheme.PRIMARY)
	UI.h_expand(row2)

	btn.pressed.connect(func():
		for f in fills:
			f.anchor_right = 0.0
		var tween := btn.create_tween()
		tween.set_parallel(true)
		for i in fills.size():
			tween.tween_property(fills[i], "anchor_right", 0.92, 1.6) \
				.set_trans(easings[i][1] as int).set_ease(Tween.EASE_OUT)
	)

	card_v.add_child(UI.label(
		"tween.set_parallel(true)  →  tween_property(fill, \"anchor_right\", 0.92, 1.6).set_trans(TRANS_XXX)",
		UITheme.FONT_XS, UITheme.TEXT_MUTED
	))


# =============================================
# 5. NUMBER COUNTER
# =============================================

func _counter_section(parent: Control) -> void:
	UI.section(parent, "Number Counter  (tween_method)")
	var card_v := UI.card(parent, 24, 20)

	var counters := [
		["12,847", 12847.0, "Total Users",   UITheme.PRIMARY, "◆"],
		["$48.2K", 48200.0, "Revenue",       UITheme.SUCCESS, "◈"],
		["98.7%",  98.7,    "Uptime",        UITheme.INFO,    "◉"],
	]

	var stat_row := UI.hbox(card_v, 16)
	var labels: Array[Label] = []
	var targets: Array[float] = []
	var formats: Array[String] = []

	for c: Array in counters:
		var panel := PanelContainer.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.add_theme_stylebox_override("panel", UI.style(
			UITheme.SURFACE_3, UITheme.RADIUS_LG, 0, Color.TRANSPARENT,
			0, Color.TRANSPARENT, Vector2.ZERO, 20, 18
		))
		stat_row.add_child(panel)

		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 6)
		v.alignment = BoxContainer.ALIGNMENT_CENTER
		panel.add_child(v)

		var accent: Color = c[3]
		v.add_child(UI.label(c[4] as String, UITheme.FONT_LG, Color(accent.r, accent.g, accent.b, 0.5)))

		var val_lbl := UI.label("0", UITheme.FONT_3XL, UITheme.TEXT_PRIMARY)
		val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(val_lbl)

		var title_lbl := UI.label(c[2] as String, UITheme.FONT_SM, UITheme.TEXT_MUTED)
		title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(title_lbl)

		labels.append(val_lbl)
		targets.append(c[1] as float)
		formats.append(c[0] as String)

	var btn_row := UI.hbox(card_v, 10)
	var btn := UI.solid_btn(btn_row, "↺  Replay Counters", UITheme.PRIMARY)
	UI.h_expand(btn_row)

	btn.pressed.connect(func():
		for lbl in labels:
			lbl.text = "0"
		var tween := btn.create_tween()
		tween.set_parallel(true)
		for i in labels.size():
			var lbl := labels[i]
			var target := targets[i]
			var fmt := formats[i]
			tween.tween_method(func(val: float):
				if fmt.begins_with("$"):
					lbl.text = "$" + _format_number(val / 1000.0, 1) + "K"
				elif fmt.ends_with("%"):
					lbl.text = _format_number(val, 1) + "%"
				else:
					lbl.text = _format_int(int(val))
			, 0.0, target, 2.0) \
				.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT) \
				.set_delay(i * 0.15)
	)

	card_v.add_child(UI.label(
		"tween.tween_method(update_label, 0.0, target, 2.0).set_trans(Tween.TRANS_EXPO)",
		UITheme.FONT_XS, UITheme.TEXT_MUTED
	))


static func _format_int(n: int) -> String:
	var s := str(n)
	var result := ""
	for i in s.length():
		if i > 0 and (s.length() - i) % 3 == 0:
			result += ","
		result += s[i]
	return result


static func _format_number(n: float, decimals: int) -> String:
	var int_part := int(n)
	var dec_part := int(abs(n - int_part) * pow(10, decimals))
	return _format_int(int_part) + "." + str(dec_part)
