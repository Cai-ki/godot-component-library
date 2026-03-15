class_name UIContextMenu
extends Node

## Styled right-click context menu.
##
## Usage:
##   var menu := UIContextMenu.new()
##   menu.add_item("✎  Rename",  func(): rename())
##   menu.add_item("◈  Duplicate", func(): duplicate())
##   menu.add_separator()
##   menu.add_item("✕  Delete",  func(): delete(), true)  # destructive=true → red
##   menu.attach(my_node)           # auto-shows on right-click
##   # or: menu.show_at(get_global_mouse_position())

var _items: Array = []   # [{type, label, callback, destructive}]
var _overlay: Control    # full-screen dismiss layer
var _panel: PanelContainer


# ── Public API ───────────────────────────────────────────────────────────────

func add_item(label: String, callback: Callable, destructive: bool = false) -> void:
	_items.append({type = "item", label = label, callback = callback, destructive = destructive})


func add_separator() -> void:
	_items.append({type = "separator"})


func clear() -> void:
	_items.clear()


## Show the menu at the given global screen position.
func show_at(pos: Vector2) -> void:
	_close()
	_build(pos)


## Attach to a Control: menu opens on right-click automatically.
func attach(target: Control) -> void:
	target.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton \
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT \
		and (event as InputEventMouseButton).pressed:
			show_at(target.get_global_mouse_position())
	)


# ── Build ────────────────────────────────────────────────────────────────────

func _build(pos: Vector2) -> void:
	var layer := _get_or_create_layer()

	# Full-screen overlay — catches outside clicks to dismiss
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
			_close()
	)
	layer.add_child(_overlay)

	# Menu panel
	_panel = PanelContainer.new()
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_2
	ps.corner_radius_top_left     = UITheme.RADIUS_MD
	ps.corner_radius_top_right    = UITheme.RADIUS_MD
	ps.corner_radius_bottom_left  = UITheme.RADIUS_MD
	ps.corner_radius_bottom_right = UITheme.RADIUS_MD
	ps.border_width_top    = 1; ps.border_width_bottom = 1
	ps.border_width_left   = 1; ps.border_width_right  = 1
	ps.border_color  = UITheme.BORDER_STRONG
	ps.shadow_size   = 18
	ps.shadow_color  = Color(0, 0, 0, 0.35)
	ps.shadow_offset = Vector2(0, 6)
	ps.content_margin_left   = 0; ps.content_margin_right  = 0
	ps.content_margin_top    = 6; ps.content_margin_bottom = 6
	_panel.add_theme_stylebox_override("panel", ps)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	_panel.add_child(vbox)

	for item in _items:
		if item.type == "separator":
			var sm := MarginContainer.new()
			sm.add_theme_constant_override("margin_top",    4)
			sm.add_theme_constant_override("margin_bottom", 4)
			sm.add_theme_constant_override("margin_left",   10)
			sm.add_theme_constant_override("margin_right",  10)
			vbox.add_child(sm)
			var line := ColorRect.new()
			line.color = UITheme.BORDER
			line.custom_minimum_size.y = 1
			line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			sm.add_child(line)
		else:
			_build_item(vbox, item)

	_overlay.add_child(_panel)
	_panel.position = pos
	_clamp_to_screen.bind(pos).call_deferred()

	# Fade in
	_panel.modulate.a = 0.0
	_panel.create_tween().tween_property(_panel, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE)


func _build_item(parent: Control, item: Dictionary) -> void:
	var btn := Button.new()
	btn.text = item.label
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_NONE
	btn.custom_minimum_size = Vector2(176, 34)

	var font_color: Color  = UITheme.DANGER if item.destructive else UITheme.TEXT_PRIMARY
	var hover_color: Color = UITheme.DANGER if item.destructive else UITheme.PRIMARY_LIGHT
	var hover_bg: Color    = Color(UITheme.DANGER.r, UITheme.DANGER.g, UITheme.DANGER.b, 0.1) \
		if item.destructive else UITheme.PRIMARY_SOFT

	var n := StyleBoxFlat.new()
	n.bg_color = Color(0, 0, 0, 0)
	n.corner_radius_top_left     = UITheme.RADIUS_SM
	n.corner_radius_top_right    = UITheme.RADIUS_SM
	n.corner_radius_bottom_left  = UITheme.RADIUS_SM
	n.corner_radius_bottom_right = UITheme.RADIUS_SM
	n.content_margin_left = 14; n.content_margin_right  = 14
	n.content_margin_top  =  4; n.content_margin_bottom =  4

	var m := StyleBoxFlat.new()
	m.bg_color = hover_bg
	m.corner_radius_top_left     = UITheme.RADIUS_SM
	m.corner_radius_top_right    = UITheme.RADIUS_SM
	m.corner_radius_bottom_left  = UITheme.RADIUS_SM
	m.corner_radius_bottom_right = UITheme.RADIUS_SM
	m.content_margin_left = 14; m.content_margin_right  = 14
	m.content_margin_top  =  4; m.content_margin_bottom =  4

	btn.add_theme_stylebox_override("normal",  n)
	btn.add_theme_stylebox_override("hover",   m)
	btn.add_theme_stylebox_override("pressed", m)
	btn.add_theme_stylebox_override("focus",   n)
	btn.add_theme_color_override("font_color",       font_color)
	btn.add_theme_color_override("font_hover_color", hover_color)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	btn.pressed.connect(func():
		var cb: Callable = item.callback
		_close()
		cb.call()
	)

	# Margin wrapper so items don't touch panel edges
	var item_wrap := MarginContainer.new()
	item_wrap.add_theme_constant_override("margin_left",  4)
	item_wrap.add_theme_constant_override("margin_right", 4)
	item_wrap.add_theme_constant_override("margin_top",   0)
	item_wrap.add_theme_constant_override("margin_bottom",0)
	item_wrap.add_child(btn)
	parent.add_child(item_wrap)


func _clamp_to_screen(pos: Vector2) -> void:
	if not is_instance_valid(_panel):
		return
	var panel_size := _panel.get_minimum_size()
	var vp_size    := get_tree().root.get_visible_rect().size
	_panel.position = UI.clamp_position_to_viewport(pos, panel_size, vp_size, 4.0)


# ── Close ────────────────────────────────────────────────────────────────────

func _close() -> void:
	if is_instance_valid(_overlay):
		_overlay.queue_free()
	_overlay = null
	_panel   = null


# ── Layer ────────────────────────────────────────────────────────────────────

func _get_or_create_layer() -> CanvasLayer:
	return UI.ensure_overlay_layer(get_tree().root, "_UIContextMenuLayer", 102)
