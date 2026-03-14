## UICommandPalette — Standalone Component
## Cmd+K style global search overlay with filterable command list,
## keyboard navigation, and CanvasLayer architecture.
##
## Usage:
##   var palette := UICommandPalette.new()
##   palette.add_command("Settings", "Open application settings", "⚙")
##   palette.add_command("Profile", "View your profile", "👤")
##   palette.command_selected.connect(func(id): print(id))
##   parent.add_child(palette)
##   # Opens with Ctrl+K or palette.show_palette()
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UICommandPalette
extends Node

signal command_selected(command_id: String)

var _commands: Array[Dictionary] = []    # [{id, label, description, icon, group}]
var _next_id: int = 0
var _is_open: bool = false
var _layer: CanvasLayer
var _panel: PanelContainer
var _search_input: LineEdit
var _results_vbox: VBoxContainer
var _selected_index: int = 0
var _filtered: Array[Dictionary] = []

const LAYER_NAME := "_UICommandPaletteLayer"
const LAYER_Z := 106
const MAX_VISIBLE := 8


func _ready() -> void:
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ke := event as InputEventKey
		if ke.pressed and ke.keycode == KEY_K and (ke.ctrl_pressed or ke.meta_pressed):
			get_viewport().set_input_as_handled()
			if _is_open:
				hide_palette()
			else:
				show_palette()
		elif ke.pressed and ke.keycode == KEY_ESCAPE and _is_open:
			get_viewport().set_input_as_handled()
			hide_palette()


## Add a command. Returns the command_id.
func add_command(label: String, description: String = "", icon: String = "",
		group: String = "") -> String:
	var id := "cmd_" + str(_next_id)
	_next_id += 1
	_commands.append({
		"id": id,
		"label": label,
		"description": description,
		"icon": icon,
		"group": group
	})
	return id


func clear_commands() -> void:
	_commands.clear()
	_next_id = 0


func show_palette() -> void:
	if _is_open: return
	_is_open = true
	_selected_index = 0
	_build()


func hide_palette() -> void:
	if not _is_open: return
	_is_open = false
	
	if is_instance_valid(_panel) and _layer and is_instance_valid(_layer):
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property(_panel, "modulate:a", 0.0, 0.15)
		t.tween_property(_panel, "position:y", _panel.position.y + 10, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		
		var overlay = _layer.get_node_or_null("_cp_overlay")
		if overlay:
			t.tween_property(overlay, "modulate:a", 0.0, 0.15)
		t.chain().tween_callback(_cleanup)
	else:
		_cleanup()


func _build() -> void:
	_layer = _get_or_create_layer()

	# Overlay background with Glassmorphism
	var overlay = UI.glass_backdrop(_layer, 2.0, Color(0, 0, 0, 0.4))
	overlay.name = "_cp_overlay"
	overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
				hide_palette()
	)
	
	# Start completely transparent and fade in
	overlay.modulate.a = 0.0
	var overlay_t := overlay.create_tween()
	overlay_t.tween_property(overlay, "modulate:a", 1.0, 0.15)

	# Center wrapper
	var center_wrapper := Control.new()
	center_wrapper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_layer.add_child(center_wrapper)

	# Panel
	_panel = PanelContainer.new()
	var panel_width := 520.0
	var vp := get_tree().root.size
	_panel.position = Vector2((vp.x - panel_width) / 2.0, vp.y * 0.2)
	_panel.custom_minimum_size.x = panel_width

	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_1
	ps.border_color = UITheme.BORDER
	ps.border_width_left = 1; ps.border_width_right = 1
	ps.border_width_top = 1; ps.border_width_bottom = 1
	ps.corner_radius_top_left = UITheme.RADIUS_LG
	ps.corner_radius_top_right = UITheme.RADIUS_LG
	ps.corner_radius_bottom_left = UITheme.RADIUS_LG
	ps.corner_radius_bottom_right = UITheme.RADIUS_LG
	ps.shadow_size = 20
	ps.shadow_color = Color(0, 0, 0, 0.4)
	ps.content_margin_left = 0; ps.content_margin_right = 0
	ps.content_margin_top = 0; ps.content_margin_bottom = 0
	_panel.add_theme_stylebox_override("panel", ps)
	center_wrapper.add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 0)
	_panel.add_child(vbox)

	# ── Search input ──
	var search_margin := MarginContainer.new()
	search_margin.add_theme_constant_override("margin_left", 16)
	search_margin.add_theme_constant_override("margin_right", 16)
	search_margin.add_theme_constant_override("margin_top", 12)
	search_margin.add_theme_constant_override("margin_bottom", 8)
	vbox.add_child(search_margin)

	var search_row := HBoxContainer.new()
	search_row.add_theme_constant_override("separation", 10)
	search_margin.add_child(search_row)

	var search_icon := Label.new()
	search_icon.text = "🔍"
	search_icon.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	search_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	search_row.add_child(search_icon)

	_search_input = LineEdit.new()
	_search_input.placeholder_text = "Type a command..."
	_search_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_search_input.add_theme_font_size_override("font_size", UITheme.FONT_BASE)
	_search_input.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_search_input.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
	_search_input.add_theme_color_override("caret_color", UITheme.PRIMARY)

	var input_empty := StyleBoxFlat.new()
	input_empty.bg_color = Color.TRANSPARENT
	_search_input.add_theme_stylebox_override("normal", input_empty)
	_search_input.add_theme_stylebox_override("focus", input_empty)
	_search_input.text_changed.connect(_on_search_changed)
	_search_input.gui_input.connect(_on_search_key)
	search_row.add_child(_search_input)

	# Shortcut hint
	var esc_lbl := Label.new()
	esc_lbl.text = "ESC"
	esc_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	esc_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	esc_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	search_row.add_child(esc_lbl)

	# ── Divider ──
	var div := ColorRect.new()
	div.custom_minimum_size.y = 1
	div.color = UITheme.BORDER
	div.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(div)

	# ── Results ──
	var results_scroll := ScrollContainer.new()
	results_scroll.custom_minimum_size.y = MAX_VISIBLE * 44
	results_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	results_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(results_scroll)

	_results_vbox = VBoxContainer.new()
	_results_vbox.add_theme_constant_override("separation", 0)
	_results_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	results_scroll.add_child(_results_vbox)

	_apply_filter("")

	# Focus search input
	_search_input.grab_focus.call_deferred()

	# Fade in
	_panel.modulate.a = 0.0
	_panel.position.y += 10
	var t := _panel.create_tween()
	t.set_parallel(true)
	t.tween_property(_panel, "modulate:a", 1.0, 0.15)
	t.tween_property(_panel, "position:y", _panel.position.y - 10, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _cleanup() -> void:
	var layer := _get_or_create_layer()
	for child in layer.get_children():
		child.queue_free()
	_panel = null
	_search_input = null
	_results_vbox = null


func _on_search_changed(text: String) -> void:
	_selected_index = 0
	_apply_filter(text)


func _on_search_key(event: InputEvent) -> void:
	if not (event is InputEventKey): return
	var ke := event as InputEventKey
	if not ke.pressed: return

	if ke.keycode == KEY_DOWN:
		_selected_index = mini(_selected_index + 1, _filtered.size() - 1)
		_update_selection()
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_UP:
		_selected_index = maxi(_selected_index - 1, 0)
		_update_selection()
		get_viewport().set_input_as_handled()
	elif ke.keycode == KEY_ENTER:
		if _selected_index >= 0 and _selected_index < _filtered.size():
			var cmd: Dictionary = _filtered[_selected_index]
			var cmd_id: String = cmd["id"]
			command_selected.emit(cmd_id)
			hide_palette()
		get_viewport().set_input_as_handled()


func _apply_filter(query: String) -> void:
	_filtered.clear()
	var q := query.to_lower().strip_edges()

	for cmd in _commands:
		var label_str: String = cmd["label"]
		var desc_str: String = cmd.get("description", "")
		var group_str: String = cmd.get("group", "")
		if q.is_empty() or label_str.to_lower().contains(q) or desc_str.to_lower().contains(q) or group_str.to_lower().contains(q):
			_filtered.append(cmd)

	_rebuild_results()


func _rebuild_results() -> void:
	if _results_vbox == null: return

	while _results_vbox.get_child_count() > 0:
		var child := _results_vbox.get_child(0)
		_results_vbox.remove_child(child)
		child.queue_free()

	if _filtered.is_empty():
		var empty_margin := MarginContainer.new()
		empty_margin.add_theme_constant_override("margin_left", 16)
		empty_margin.add_theme_constant_override("margin_right", 16)
		empty_margin.add_theme_constant_override("margin_top", 16)
		empty_margin.add_theme_constant_override("margin_bottom", 16)
		_results_vbox.add_child(empty_margin)

		var empty_lbl := Label.new()
		empty_lbl.text = "No commands found"
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		empty_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		empty_margin.add_child(empty_lbl)
		return

	var visible_count := mini(_filtered.size(), MAX_VISIBLE)
	for i in visible_count:
		_build_result_item(i)


func _build_result_item(index: int) -> void:
	var cmd: Dictionary = _filtered[index]
	var is_selected := index == _selected_index

	var row := PanelContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_STOP
	row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var rs := StyleBoxFlat.new()
	rs.bg_color = UITheme.PRIMARY_SOFT if is_selected else Color.TRANSPARENT
	rs.content_margin_left = 16; rs.content_margin_right = 16
	rs.content_margin_top = 8; rs.content_margin_bottom = 8
	row.add_theme_stylebox_override("panel", rs)

	var hover_s := rs.duplicate()
	hover_s.bg_color = UITheme.SURFACE_3 if not is_selected else UITheme.PRIMARY_SOFT
	var captured_idx := index
	row.mouse_entered.connect(func():
		_selected_index = captured_idx
		_update_selection()
	)

	row.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
				var cmd_id: String = cmd["id"]
				command_selected.emit(cmd_id)
				hide_palette()
	)
	_results_vbox.add_child(row)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 12)
	row.add_child(h)

	# Icon
	var icon_str: String = cmd.get("icon", "")
	if not icon_str.is_empty():
		var icon_lbl := Label.new()
		icon_lbl.text = icon_str
		icon_lbl.add_theme_font_size_override("font_size", UITheme.FONT_BASE)
		icon_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(icon_lbl)

	# Text column
	var text_col := VBoxContainer.new()
	text_col.add_theme_constant_override("separation", 2)
	text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(text_col)

	var label_lbl := Label.new()
	var label_str: String = cmd["label"]
	label_lbl.text = label_str
	label_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	label_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	text_col.add_child(label_lbl)

	var desc_str: String = cmd.get("description", "")
	if not desc_str.is_empty():
		var desc_lbl := Label.new()
		desc_lbl.text = desc_str
		desc_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
		desc_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		text_col.add_child(desc_lbl)

	# Group badge
	var group_str: String = cmd.get("group", "")
	if not group_str.is_empty():
		var group_lbl := Label.new()
		group_lbl.text = group_str
		group_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
		group_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		group_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(group_lbl)


func _update_selection() -> void:
	_rebuild_results()


func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == LAYER_NAME:
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = LAYER_NAME
	layer.layer = LAYER_Z
	root.add_child(layer)
	return layer


func _exit_tree() -> void:
	if _is_open:
		hide_palette()
