## UICard — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UICard
extends PanelContainer

@export var elevation: int = 0:
	set(v): elevation = clampi(v, 0, 3); if is_inside_tree(): _refresh_style()

@export var hoverable: bool = false:
	set(v): hoverable = v; _toggle_hover(v)

@export var accent_color: Color = Color.TRANSPARENT:
	set(v): accent_color = v; if is_inside_tree(): _refresh_style()

@export var pad_h: int = 24
@export var pad_v: int = 20

var _content: VBoxContainer
var _normal_style: StyleBoxFlat
var _hover_style: StyleBoxFlat

func _ready() -> void:
	_build()

# ── Public API ────────────────────────────────────
func get_content() -> VBoxContainer:
	return _content

# ── Internal ──────────────────────────────────────
func _build() -> void:
	_refresh_style()

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left",   pad_h)
	m.add_theme_constant_override("margin_right",  pad_h)
	m.add_theme_constant_override("margin_top",    pad_v)
	m.add_theme_constant_override("margin_bottom", pad_v)
	add_child(m)

	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 12)
	m.add_child(_content)

	if hoverable:
		_toggle_hover(true)

func _make_style(surface: Color, border: Color, shadow_sz: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = surface
	s.corner_radius_top_left     = UITheme.RADIUS_LG
	s.corner_radius_top_right    = UITheme.RADIUS_LG
	s.corner_radius_bottom_left  = UITheme.RADIUS_LG
	s.corner_radius_bottom_right = UITheme.RADIUS_LG
	if accent_color != Color.TRANSPARENT:
		s.border_width_left = 3
		s.border_color = accent_color
	else:
		s.border_width_top    = 1; s.border_width_bottom = 1
		s.border_width_left   = 1; s.border_width_right  = 1
		s.border_color = border
	if shadow_sz > 0:
		s.shadow_size   = shadow_sz
		s.shadow_color  = Color(0, 0, 0, 0.15 + elevation * 0.04)
		s.shadow_offset = Vector2(0, shadow_sz * 0.4)
	return s

func _refresh_style() -> void:
	var shadow := 4 + elevation * 4
	_normal_style = _make_style(UITheme.SURFACE_2, UITheme.BORDER, shadow)
	_hover_style  = _make_style(UITheme.SURFACE_3, UITheme.BORDER_LIGHT, shadow + 6)
	add_theme_stylebox_override("panel", _normal_style)

func _toggle_hover(on: bool) -> void:
	if on:
		if not mouse_entered.is_connected(_on_enter):
			mouse_entered.connect(_on_enter)
		if not mouse_exited.is_connected(_on_exit):
			mouse_exited.connect(_on_exit)
	else:
		if mouse_entered.is_connected(_on_enter):
			mouse_entered.disconnect(_on_enter)
		if mouse_exited.is_connected(_on_exit):
			mouse_exited.disconnect(_on_exit)

func _on_enter() -> void:
	if _hover_style:
		add_theme_stylebox_override("panel", _hover_style)

func _on_exit() -> void:
	if _normal_style:
		add_theme_stylebox_override("panel", _normal_style)
