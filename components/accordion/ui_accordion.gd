## UIAccordion — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIAccordion
extends VBoxContainer

signal item_toggled(index: int, expanded: bool)

@export var allow_multiple: bool = false

var _items: Array[Dictionary] = []

func _ready() -> void:
	add_theme_constant_override("separation", 4)

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
	btn.text = ("▼  " if expanded else "▶  ") + header
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_ALL
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_header(btn, expanded)
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
	s.content_margin_left = 16; s.content_margin_right  = 16
	s.content_margin_top  = 16; s.content_margin_bottom = 16
	body.add_theme_stylebox_override("panel", s)
	body.add_child(content)
	
	if not expanded:
		body.visible = false
		body.custom_minimum_size.y = 0
	else:
		body.visible = true
		# Wait for layout if needed, but for now just let it be
	
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
	fo.border_color = UITheme.PRIMARY_LIGHT
	fo.expand_margin_left = 1; fo.expand_margin_right = 1
	fo.expand_margin_top = 1; fo.expand_margin_bottom = 1
	
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   fo)
	btn.add_theme_color_override("font_color",       UITheme.TEXT_PRIMARY)
	btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

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
	btn.text = ("▼  " if expanded else "▶  ") + item["header"]
	_style_header(btn, expanded)
	
	var body: PanelContainer = item["body"]
	
	# Kill existing tween if any
	if body.has_meta("tween"):
		var old_t: Tween = body.get_meta("tween")
		if old_t and old_t.is_valid():
			old_t.kill()
	
	var t := body.create_tween().set_parallel(true)
	body.set_meta("tween", t)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if expanded:
		body.visible = true
		body.modulate.a = 0.0
		# Reset to calculate target height correctly
		body.custom_minimum_size.y = 0
		var target_h := body.get_combined_minimum_size().y
		
		t.tween_property(body, "custom_minimum_size:y", target_h, 0.3)
		t.tween_property(body, "modulate:a", 1.0, 0.2)
	else:
		t.tween_property(body, "custom_minimum_size:y", 0.0, 0.3)
		t.tween_property(body, "modulate:a", 0.0, 0.2)
		t.chain().tween_callback(func(): 
			if not item["expanded"]: # Re-check in case it was toggled back mid-animation
				body.visible = false
		)
	
	item_toggled.emit(index, expanded)
