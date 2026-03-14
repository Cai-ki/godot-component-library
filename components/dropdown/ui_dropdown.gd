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


# ── Public API ────────────────────────────────────────────────

func add_item(label: String, icon: String = "", callback: Callable = Callable(),
		destructive: bool = false, group: String = "") -> String:
	var id := "item_%d" % _items.size()
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
		_close()
	else:
		_show()


func show_dropdown() -> void:
	_show()


func hide_dropdown() -> void:
	_close()


# ── Build ─────────────────────────────────────────────────────

func _show() -> void:
	_close()
	if _items.size() == 0: return
	var layer := _get_or_create_layer()

	# Full-screen dismiss overlay
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed:
			_close()
	)
	layer.add_child(_overlay)

	# Panel
	_panel = PanelContainer.new()
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_2
	ps.set_corner_radius_all(UITheme.RADIUS_MD)
	ps.border_width_top = 1; ps.border_width_bottom = 1
	ps.border_width_left = 1; ps.border_width_right = 1
	ps.border_color = UITheme.BORDER_STRONG
	ps.shadow_size = 18
	ps.shadow_color = Color(0, 0, 0, 0.35)
	ps.shadow_offset = Vector2(0, 6)
	ps.content_margin_left = 0; ps.content_margin_right = 0
	ps.content_margin_top = 6; ps.content_margin_bottom = 6
	_panel.add_theme_stylebox_override("panel", ps)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	_panel.add_child(vbox)

	# Build items
	var last_group := ""
	for item in _items:
		if item.type == "separator":
			_build_separator(vbox)
		else:
			var grp: String = item.get("group", "")
			if grp != "" and grp != last_group:
				if last_group != "":
					_build_separator(vbox)
				_build_group_header(vbox, grp)
				last_group = grp
			_build_item(vbox, item)

	_overlay.add_child(_panel)

	# Position below target
	if is_instance_valid(_target):
		var rect := _target.get_global_rect()
		_panel.position = Vector2(rect.position.x, rect.position.y + rect.size.y + 4)
	_clamp_to_screen.call_deferred()

	# Fade in
	_panel.modulate.a = 0.0
	_panel.create_tween().tween_property(_panel, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE)


func _build_item(parent_vbox: VBoxContainer, item: Dictionary) -> void:
	var btn := Button.new()
	var icon_str: String = item.get("icon", "")
	if icon_str != "":
		btn.text = "%s  %s" % [icon_str, item.label]
	else:
		btn.text = item.label
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_NONE
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

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_stylebox_override("focus", n)
	btn.add_theme_color_override("font_color", font_color)
	btn.add_theme_color_override("font_hover_color", hover_color)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	var item_id: String = item.id
	var item_cb: Callable = item.callback
	btn.pressed.connect(func():
		_close()
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
	var panel_size := _panel.get_minimum_size()
	var vp_size := get_tree().root.get_visible_rect().size
	_panel.position = Vector2(
		clampf(_panel.position.x, 4.0, vp_size.x - panel_size.x - 4.0),
		clampf(_panel.position.y, 4.0, vp_size.y - panel_size.y - 4.0)
	)


# ── Close / Cleanup ──────────────────────────────────────────

func _close() -> void:
	if is_instance_valid(_overlay):
		_overlay.queue_free()
	_overlay = null
	_panel = null


func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == LAYER_NAME:
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = LAYER_NAME
	layer.layer = LAYER_INDEX
	root.add_child(layer)
	return layer


func _exit_tree() -> void:
	_close()
