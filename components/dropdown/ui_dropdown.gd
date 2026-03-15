## UIDropdown — Standalone Component
## Click-triggered dropdown menu with icons, groups, and separators.
##
## Usage:
##   var dd := UIDropdown.new()
##   dd.add_item("Profile", "👤", func(): go_profile())
##   dd.add_item("Settings", "⚙", func(): go_settings())
##   dd.add_separator()
##   dd.add_item("Log Out", "⏻", func(): logout(), true)
##   dd.attach(my_button)   # click triggers dropdown
##   parent.add_child(dd)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIDropdown
extends Node

signal item_selected(id: String)

const LAYER_NAME := "_UIDropdownLayer"
const LAYER_INDEX := 107

var _items: Array = []   # [{type, label, icon, callback, destructive, group, id}]
var _overlay: Control
var _panel: PanelContainer
var _target: Control
var _id_counter: int = 0  # BUG-12 FIX: monotonic counter prevents ID reset after clear_items()


# ── Public API ────────────────────────────────────────────────

func add_item(label: String, icon: String = "", callback: Callable = Callable(),
		destructive: bool = false, group: String = "") -> String:
	# BUG-12 FIX: use monotonic _id_counter so IDs don't reset after clear_items()
	var id := "item_%d" % _id_counter
	_id_counter += 1
	_items.append({type = "item", label = label, icon = icon,
		callback = callback, destructive = destructive, group = group, id = id})
	return id


func add_separator() -> void:
	_items.append({type = "separator"})


func clear_items() -> void:
	_items.clear()


func attach(target: Control) -> void:
	_target = target
	if target.has_signal("pressed"):
		target.pressed.connect(func(): toggle())
	else:
		target.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				toggle()
		)


func toggle() -> void:
	if is_instance_valid(_panel):
		_show_exit_animation()
	else:
		_show()


func show_dropdown() -> void:
	_show()


func hide_dropdown() -> void:
	_show_exit_animation()


# ── Build ─────────────────────────────────────────────────────

func _show() -> void:
	if is_instance_valid(_panel):
		_close() # Animation-less close to swap instantly if needed
	
	if _items.size() == 0: return
	var layer := _get_or_create_layer()

	# Full-screen dismiss overlay with subtle glassmorphism
	_overlay = UI.glass_backdrop(layer, 1.2, Color(0, 0, 0, 0.15))
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed:
			hide_dropdown()
	)

	# Panel with Glassmorphism
	_panel = PanelContainer.new()
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Using UI.style but with semi-transparency for glass feel
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(UITheme.SURFACE_2.r, UITheme.SURFACE_2.g, UITheme.SURFACE_2.b, 0.82)
	ps.set_corner_radius_all(UITheme.RADIUS_MD)
	ps.border_width_top = 1; ps.border_width_bottom = 1
	ps.border_width_left = 1; ps.border_width_right = 1
	ps.border_color = UITheme.BORDER_STRONG
	ps.shadow_size = 24
	ps.shadow_color = Color(0, 0, 0, 0.45)
	ps.shadow_offset = Vector2(0, 8)
	ps.content_margin_left = 0; ps.content_margin_right = 0
	ps.content_margin_top = 6; ps.content_margin_bottom = 6
	_panel.add_theme_stylebox_override("panel", ps)

	var v_box := VBoxContainer.new()
	v_box.add_theme_constant_override("separation", 1)
	_panel.add_child(v_box)

	# Build items
	var last_group := ""
	for item in _items:
		if item.type == "separator":
			_build_separator(v_box)
		else:
			var grp: String = item.get("group", "")
			if grp != "" and grp != last_group:
				if last_group != "":
					_build_separator(v_box)
				_build_group_header(v_box, grp)
				last_group = grp
			_build_item(v_box, item)

	_overlay.add_child(_panel)

	# Position below target
	if is_instance_valid(_target):
		var rect := _target.get_global_rect()
		_panel.position = Vector2(rect.position.x, rect.position.y + rect.size.y + 6)

	# BUG-8 FIX: schedule clamp first, then animation in a second deferred call,
	# so tween target reflects the final clamped position (not the pre-clamp position).
	_panel.modulate.a = 0.0
	_panel.scale = Vector2(0.95, 0.95)
	_panel.pivot_offset = Vector2(_panel.get_combined_minimum_size().x / 2.0, 0)
	_clamp_to_screen.call_deferred()
	_start_open_animation.call_deferred()


func _build_item(parent_vbox: VBoxContainer, item: Dictionary) -> void:
	var btn := Button.new()
	var icon_str: String = item.get("icon", "")
	if icon_str != "":
		btn.text = "%s  %s" % [icon_str, item.label]
	else:
		btn.text = item.label
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_ALL # Enable keyboard nav
	btn.custom_minimum_size = Vector2(180, 34)

	var font_color: Color = UITheme.DANGER if item.destructive else UITheme.TEXT_PRIMARY
	var hover_color: Color = UITheme.DANGER if item.destructive else UITheme.PRIMARY_LIGHT
	var hover_bg: Color = Color(UITheme.DANGER.r, UITheme.DANGER.g, UITheme.DANGER.b, 0.1) \
		if item.destructive else UITheme.PRIMARY_SOFT

	var n := StyleBoxFlat.new()
	n.bg_color = Color.TRANSPARENT
	n.set_corner_radius_all(UITheme.RADIUS_SM)
	n.content_margin_left = 14; n.content_margin_right = 14
	n.content_margin_top = 4; n.content_margin_bottom = 4

	var h := n.duplicate()
	h.bg_color = hover_bg
	
	var f := n.duplicate()
	f.bg_color = Color(UITheme.PRIMARY.r, UITheme.PRIMARY.g, UITheme.PRIMARY.b, 0.08)
	f.border_width_left = 2
	f.border_color = UITheme.PRIMARY

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_stylebox_override("focus", f)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", hover_color)
	btn.add_theme_color_override("font_focus_color", hover_color)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	var item_id: String = item.id
	var item_cb: Callable = item.callback
	btn.pressed.connect(func():
		hide_dropdown()
		item_selected.emit(item_id)
		if item_cb.is_valid():
			item_cb.call()
	)

	var item_wrap := MarginContainer.new()
	item_wrap.add_theme_constant_override("margin_left", 4)
	item_wrap.add_theme_constant_override("margin_right", 4)
	item_wrap.add_child(btn)
	parent_vbox.add_child(item_wrap)


func _build_separator(vbox: VBoxContainer) -> void:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_top", 4)
	m.add_theme_constant_override("margin_bottom", 4)
	m.add_theme_constant_override("margin_left", 10)
	m.add_theme_constant_override("margin_right", 10)
	vbox.add_child(m)
	var line := ColorRect.new()
	line.color = UITheme.BORDER
	line.custom_minimum_size.y = 1
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	m.add_child(line)


func _build_group_header(vbox: VBoxContainer, group_name: String) -> void:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 18)
	m.add_theme_constant_override("margin_right", 14)
	m.add_theme_constant_override("margin_top", 6)
	m.add_theme_constant_override("margin_bottom", 2)
	vbox.add_child(m)
	var lbl := Label.new()
	lbl.text = group_name.to_upper()
	lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(lbl)


func _clamp_to_screen() -> void:
	if not is_instance_valid(_panel): return
	var panel_size := _panel.get_combined_minimum_size()
	UI.clamp_control_to_viewport(_panel, panel_size, 8.0)


# ── Close / Cleanup ──────────────────────────────────────────

# BUG-8 FIX: starts animation AFTER _clamp_to_screen so position is final
func _start_open_animation() -> void:
	if not is_instance_valid(_panel): return
	var target_y := _panel.position.y
	_panel.position.y = target_y - 10
	var t := _panel.create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(_panel, "modulate:a", 1.0, 0.15)
	t.tween_property(_panel, "scale", Vector2.ONE, 0.25)
	t.tween_property(_panel, "position:y", target_y, 0.25)

func _close() -> void:
	# Immediate cleanup
	if is_instance_valid(_overlay):
		_overlay.queue_free()
	_overlay = null
	_panel = null

func _show_exit_animation() -> void:
	if not is_instance_valid(_panel): 
		_close()
		return
	
	var p := _panel
	var o := _overlay
	_panel = null # Prevent further access
	_overlay = null
	
	var t := p.create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t.tween_property(p, "modulate:a", 0.0, 0.15)
	t.tween_property(p, "scale", Vector2(0.95, 0.95), 0.2)
	t.tween_property(p, "position:y", p.position.y - 12, 0.2)
	t.chain().tween_callback(func():
		if is_instance_valid(o): o.queue_free()
	)

func _get_or_create_layer() -> CanvasLayer:
	return UI.ensure_overlay_layer(get_tree().root, LAYER_NAME, LAYER_INDEX)


func _exit_tree() -> void:
	_close()
