## UITabs — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
## Usage: call add_tab("Name", content_node) for each tab
class_name UITabs
extends VBoxContainer

signal tab_changed(index: int, name: String)

var _btns: Array[Button] = []
var _pages: Array[Control] = []
var _active: int = 0
var _nav_row: HBoxContainer

func _ready() -> void:
	add_theme_constant_override("separation", 0)
	_build_nav()

# ── Public API ────────────────────────────────────
func add_tab(tab_name: String, content: Control) -> void:
	var idx := _btns.size()
	var btn := Button.new()
	btn.text = tab_name
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.pressed.connect(func(): set_active_tab(idx))
	_nav_row.add_child(btn)
	_btns.append(btn)

	content.visible = (idx == _active)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(content)
	_pages.append(content)
	_refresh_styles()

func set_active_tab(index: int) -> void:
	if index < 0 or index >= _btns.size(): return
	_active = index
	for i in _pages.size():
		_pages[i].visible = (i == index)
	_refresh_styles()
	tab_changed.emit(index, _btns[index].text)

func get_active_tab() -> int: return _active

# ── Internal ──────────────────────────────────────
func _build_nav() -> void:
	var nav_panel := PanelContainer.new()
	var ns := StyleBoxFlat.new()
	ns.bg_color = UITheme.SURFACE_1
	ns.border_width_bottom = 1; ns.border_color = UITheme.BORDER
	nav_panel.add_theme_stylebox_override("panel", ns)
	add_child(nav_panel)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left",  4)
	m.add_theme_constant_override("margin_right", 4)
	m.add_theme_constant_override("margin_top",   4)
	nav_panel.add_child(m)

	_nav_row = HBoxContainer.new()
	_nav_row.add_theme_constant_override("separation", 0)
	m.add_child(_nav_row)

func _tab_style(active: bool) -> Array[StyleBoxFlat]:  # [normal, hover]
	var n := StyleBoxFlat.new()
	n.bg_color = Color(0, 0, 0, 0)
	n.corner_radius_top_left    = UITheme.RADIUS_SM
	n.corner_radius_top_right   = UITheme.RADIUS_SM
	n.content_margin_left  = 18; n.content_margin_right  = 18
	n.content_margin_top   = 10; n.content_margin_bottom = 10
	if active:
		n.border_width_bottom = 2; n.border_color = UITheme.PRIMARY
	var h := n.duplicate()
	if not active: h.bg_color = UITheme.SURFACE_3
	return [n, h]

func _refresh_styles() -> void:
	for i in _btns.size():
		var btn := _btns[i]
		var active := (i == _active)
		var styles := _tab_style(active)
		btn.add_theme_stylebox_override("normal", styles[0])
		btn.add_theme_stylebox_override("hover",  styles[1])
		btn.add_theme_stylebox_override("pressed", styles[0])
		btn.add_theme_stylebox_override("focus",   styles[0])
		var fc := UITheme.PRIMARY_LIGHT if active else UITheme.TEXT_SECONDARY
		var hc := UITheme.PRIMARY_LIGHT if active else UITheme.TEXT_PRIMARY
		btn.add_theme_color_override("font_color",       fc)
		btn.add_theme_color_override("font_hover_color", hc)
		btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)
