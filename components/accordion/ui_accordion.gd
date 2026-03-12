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
	btn.focus_mode = Control.FOCUS_NONE
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_header(btn, expanded)
	return btn

func _make_body(content: Control, expanded: bool) -> PanelContainer:
	var body := PanelContainer.new()
	body.visible = expanded
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
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   s)
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
	item["expanded"] = expanded
	item["body"].visible = expanded
	var btn: Button = item["btn"]
	btn.text = ("▼  " if expanded else "▶  ") + item["header"]
	_style_header(btn, expanded)
	item_toggled.emit(index, expanded)
