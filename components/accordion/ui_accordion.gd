## UIAccordion — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIAccordion
extends VBoxContainer

signal item_toggled(index: int, expanded: bool)

@export var allow_multiple: bool = false

var _items: Array[Dictionary] = []

func _ready() -> void:
	add_theme_constant_override("separation", 4)
	set_process_unhandled_input(true)

# ── Public API ────────────────────────────────────
func add_item(header: String, content: Control, expanded: bool = false) -> int:
	var idx := _items.size()
	var item_wrap := VBoxContainer.new()
	item_wrap.add_theme_constant_override("separation", 0)
	add_child(item_wrap)

	var btn := _make_header_btn(header, expanded)
	item_wrap.add_child(btn)

	var body := _make_body(content, expanded)
	item_wrap.add_child(body)

	var item := { "header": header, "btn": btn, "body": body, "wrap": item_wrap, "expanded": expanded }
	_items.append(item)
	btn.pressed.connect(func(): _toggle(idx))
	return idx

func expand_item(index: int) -> void:   _set_state(index, true)
func collapse_item(index: int) -> void: _set_state(index, false)
func clear_items() -> void:
	for item in _items:
		item["wrap"].queue_free()
	_items.clear()

# ── Internal ──────────────────────────────────────
func _make_header_btn(header: String, expanded: bool) -> Button:
	var btn := Button.new()
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_ALL
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_header(btn, expanded)
	
	var h_box := HBoxContainer.new()
	h_box.add_theme_constant_override("separation", 12)
	h_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Need to add some padding to the HBox to match the button content margins
	h_box.add_theme_constant_override("margin_left", 16)
	btn.add_child(h_box)
	
	var arrow := Label.new()
	arrow.text = "▶"
	arrow.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	arrow.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	arrow.pivot_offset = Vector2(6, 9) # Center of the arrow character
	h_box.add_child(arrow)
	
	if expanded:
		arrow.rotation_degrees = 90
		arrow.add_theme_color_override("font_color", UITheme.PRIMARY_LIGHT)
	
	var lbl := Label.new()
	lbl.text = header
	lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	h_box.add_child(lbl)
	
	btn.set_meta("arrow", arrow)
	btn.set_meta("label", lbl)
	
	return btn

func _make_body(content: Control, expanded: bool) -> PanelContainer:
	var body := PanelContainer.new()
	body.clip_contents = true
	var s := StyleBoxFlat.new()
	s.bg_color = UITheme.SURFACE_1
	s.corner_radius_bottom_left  = UITheme.RADIUS_MD
	s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.border_width_bottom = 1; s.border_width_left = 1; s.border_width_right = 1
	s.border_color = UITheme.BORDER
	s.content_margin_left = 20; s.content_margin_right  = 20
	s.content_margin_top  = 16; s.content_margin_bottom = 16
	body.add_theme_stylebox_override("panel", s)
	body.add_child(content)
	
	if not expanded:
		body.visible = false
		body.custom_minimum_size.y = 0
		body.modulate.a = 0.0
	else:
		body.visible = true
		body.modulate.a = 1.0
	
	return body

func _style_header(btn: Button, expanded: bool) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = UITheme.SURFACE_2
	s.corner_radius_top_left    = UITheme.RADIUS_MD; s.corner_radius_top_right   = UITheme.RADIUS_MD
	s.corner_radius_bottom_left = 0 if expanded else UITheme.RADIUS_MD
	s.corner_radius_bottom_right = 0 if expanded else UITheme.RADIUS_MD
	s.border_width_top = 1; s.border_width_bottom = 1
	s.border_width_left = 1; s.border_width_right = 1
	s.border_color = UITheme.BORDER
	s.content_margin_left = 16; s.content_margin_right  = 16
	s.content_margin_top  = 14; s.content_margin_bottom = 14
	
	var h := s.duplicate(); h.bg_color = UITheme.SURFACE_3
	
	var fo := s.duplicate()
	fo.border_color = UITheme.PRIMARY
	fo.expand_margin_left = 1; fo.expand_margin_right = 1
	fo.expand_margin_top = 1; fo.expand_margin_bottom = 1
	
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   fo)

func _toggle(index: int) -> void:
	if not allow_multiple:
		for i in _items.size():
			if i != index and _items[i]["expanded"]:
				_set_state(i, false)
	_set_state(index, not _items[index]["expanded"])

func _set_state(index: int, expanded: bool) -> void:
	var item := _items[index]
	if item["expanded"] == expanded: return
	
	item["expanded"] = expanded
	var btn: Button = item["btn"]
	_style_header(btn, expanded)
	
	var arrow: Label = btn.get_meta("arrow")
	var body:  PanelContainer = item["body"]
	
	# Icon Rotation Tween
	var arrow_t := arrow.create_tween()
	arrow_t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	arrow_t.tween_property(arrow, "rotation_degrees", 90.0 if expanded else 0.0, 0.25)
	# BUG-10 FIX: Use add_theme_color_override instead of modulate so the color
	# stays theme-aware (Color.WHITE modulate causes arrow to disappear in Light theme).
	var target_color := UITheme.PRIMARY_LIGHT if expanded else UITheme.TEXT_MUTED
	arrow.add_theme_color_override("font_color", target_color)
	
	# Body Expansion Tween
	if body.has_meta("tween"):
		var old_t: Tween = body.get_meta("tween")
		if old_t and old_t.is_valid():
			old_t.kill()
	
	var t := body.create_tween().set_parallel(true)
	body.set_meta("tween", t)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if expanded:
		body.visible = true
		body.custom_minimum_size.y = 0
		# BUG-4 FIX: wait one frame so the layout engine can calculate the
		# body's natural height before we use it as the tween target.
		body.set_meta("tween", t)  # store early so kill() still works if toggled fast
		await body.get_tree().process_frame
		# Re-check: user may have toggled again while we were waiting
		if not item["expanded"]:
			return
		var target_h := body.get_combined_minimum_size().y
		if target_h <= 0:
			target_h = body.size.y  # fallback
		# Kill the old tween and create a fresh one after awaiting
		if body.has_meta("tween"):
			var old_t2: Tween = body.get_meta("tween")
			if old_t2 and old_t2.is_valid():
				old_t2.kill()
		var t2 := body.create_tween().set_parallel(true)
		body.set_meta("tween", t2)
		t2.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t2.tween_property(body, "custom_minimum_size:y", target_h, 0.3)
		t2.tween_property(body, "modulate:a", 1.0, 0.2)
	else:
		t.tween_property(body, "custom_minimum_size:y", 0.0, 0.3)
		t.tween_property(body, "modulate:a", 0.0, 0.2)
		t.chain().tween_callback(func(): 
			if not item["expanded"]: 
				body.visible = false
		)
	
	item_toggled.emit(index, expanded)


func _get_focused_item_index() -> int:
	var focused_ctrl := get_viewport().gui_get_focus_owner()
	for i in _items.size():
		var btn: Button = _items[i]["btn"]
		if btn == focused_ctrl:
			return i
	return -1


func _focus_item(index: int) -> void:
	if index < 0 or index >= _items.size(): return
	var btn: Button = _items[index]["btn"]
	btn.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey): return
	var ke := event as InputEventKey
	if not ke.pressed or ke.echo: return
	var focused_idx := _get_focused_item_index()
	if focused_idx < 0: return
	if ke.keycode == KEY_DOWN:
		_focus_item(mini(focused_idx + 1, _items.size() - 1))
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_UP:
		_focus_item(maxi(focused_idx - 1, 0))
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_RIGHT:
		_set_state(focused_idx, true)
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_LEFT:
		_set_state(focused_idx, false)
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_ENTER or ke.keycode == KEY_KP_ENTER or ke.keycode == KEY_SPACE:
		_toggle(focused_idx)
		get_viewport().set_input_as_handled()
