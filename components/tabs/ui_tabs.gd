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
	btn.focus_mode = Control.FOCUS_ALL
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

	# We'll use a Control as a child of PanelContainer to manually draw/animate the indicator
	var nav_wrap := Control.new()
	nav_wrap.custom_minimum_size.y = 42 # Height of tabs
	nav_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_panel.add_child(nav_wrap)

	_nav_row = HBoxContainer.new()
	_nav_row.add_theme_constant_override("separation", 0)
	_nav_row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Add some margin
	_nav_row.add_theme_constant_override("margin_left", 4)
	_nav_row.add_theme_constant_override("margin_right", 4)
	nav_wrap.add_child(_nav_row)

	# Indicator Line
	var indicator := ColorRect.new()
	indicator.color = UITheme.PRIMARY
	indicator.custom_minimum_size.y = 2
	indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nav_wrap.add_child(indicator)
	set_meta("indicator", indicator)

func _tab_style(active: bool) -> Array[StyleBoxFlat]:  # [normal, hover]
	var n := StyleBoxFlat.new()
	n.bg_color = Color(0, 0, 0, 0)
	n.corner_radius_top_left    = UITheme.RADIUS_SM
	n.corner_radius_top_right   = UITheme.RADIUS_SM
	n.content_margin_left  = 18; n.content_margin_right  = 18
	n.content_margin_top   = 10; n.content_margin_bottom = 10
	
	var h := n.duplicate()
	h.bg_color = UITheme.SURFACE_3
	
	var f := n.duplicate()
	f.border_width_bottom = 2; f.border_color = UITheme.PRIMARY_SOFT
	
	return [n, h, f]

func _refresh_styles() -> void:
	if _btns.size() == 0: return
	
	for i in _btns.size():
		var btn := _btns[i]
		var active := (i == _active)
		var btn_styles := _tab_style(active)
		
		btn.add_theme_stylebox_override("normal", btn_styles[0])
		btn.add_theme_stylebox_override("hover",  btn_styles[1])
		btn.add_theme_stylebox_override("pressed", btn_styles[0])
		btn.add_theme_stylebox_override("focus",   btn_styles[2])
		
		var fc := UITheme.TEXT_PRIMARY if active else UITheme.TEXT_SECONDARY
		var hc := UITheme.TEXT_PRIMARY
		btn.add_theme_color_override("font_color",       fc)
		btn.add_theme_color_override("font_hover_color", hc)
		btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	# Update indicator position
	_update_indicator()

func _update_indicator() -> void:
	if _btns.size() == 0 or _active >= _btns.size(): return
	var target_btn := _btns[_active]
	var indicator: ColorRect = get_meta("indicator")
	
	# Wait one frame for layout if needed (initial build)
	if target_btn.size.x <= 0:
		await get_tree().process_frame
	
	var target_x := target_btn.position.x
	var target_w := target_btn.size.x
	var target_y := _nav_row.size.y - 2
	
	var t := create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(indicator, "position:x", target_x, 0.25)
	t.tween_property(indicator, "size:x", target_w, 0.25)
	t.tween_property(indicator, "position:y", target_y, 0.25)
	t.tween_property(indicator, "size:y", 2, 0.25)
