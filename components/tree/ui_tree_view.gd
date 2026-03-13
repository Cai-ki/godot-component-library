## UITreeView — Standalone Component
## Collapsible tree list (file explorer style) with expandable nodes,
## indent levels, click selection, and folder/leaf icons.
##
## Usage:
##   var tree := UITreeView.new()
##   var root_id := tree.add_node("src", "", true)          # folder
##   var child := tree.add_node("main.gd", root_id)         # leaf
##   tree.add_node("utils", root_id, true)                  # nested folder
##   tree.node_selected.connect(func(id): print(id))
##   parent.add_child(tree)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UITreeView
extends VBoxContainer

signal node_selected(node_id: String)
signal node_toggled(node_id: String, expanded: bool)

var _nodes: Dictionary = {}     # id -> { label, parent_id, is_folder, expanded, children }
var _root_ids: Array[String] = []
var _selected_id: String = ""
var _next_id: int = 0

@export var indent_size: int = 20:
	set(v): indent_size = v; if is_inside_tree(): _rebuild.call_deferred()

@export var show_lines: bool = true:
	set(v): show_lines = v; if is_inside_tree(): _rebuild.call_deferred()


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 0)
	_rebuild()


## Add a node. Returns the node_id.
## parent_id: empty string for root level.
func add_node(label_text: String, parent_id: String = "", is_folder: bool = false) -> String:
	var id := "tn_" + str(_next_id)
	_next_id += 1

	_nodes[id] = {
		"id": id,
		"label": label_text,
		"parent_id": parent_id,
		"is_folder": is_folder,
		"expanded": true,
		"children": [] as Array[String]
	}

	if parent_id.is_empty():
		_root_ids.append(id)
	else:
		if _nodes.has(parent_id):
			var parent_children: Array = _nodes[parent_id]["children"]
			parent_children.append(id)

	if is_inside_tree():
		_rebuild.call_deferred()
	return id


func clear_nodes() -> void:
	_nodes.clear()
	_root_ids.clear()
	_selected_id = ""
	_next_id = 0
	if is_inside_tree():
		_rebuild.call_deferred()


func toggle_node(node_id: String) -> void:
	if not _nodes.has(node_id): return
	var node: Dictionary = _nodes[node_id]
	if not node["is_folder"]: return
	node["expanded"] = not node["expanded"]
	node_toggled.emit(node_id, node["expanded"])
	if is_inside_tree():
		_rebuild.call_deferred()


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()

	for root_id in _root_ids:
		_build_node(root_id, 0)


func _build_node(node_id: String, depth: int) -> void:
	if not _nodes.has(node_id): return
	var node: Dictionary = _nodes[node_id]

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(row)

	# Indent
	if depth > 0:
		var indent := Control.new()
		indent.custom_minimum_size.x = indent_size * depth
		row.add_child(indent)

	# Expand/collapse arrow or spacer
	var is_folder: bool = node["is_folder"]
	var expanded: bool = node["expanded"]
	var children: Array = node["children"]
	var captured_id := node_id

	if is_folder and children.size() > 0:
		var arrow_btn := Button.new()
		arrow_btn.text = "▾" if expanded else "▸"
		arrow_btn.flat = true
		arrow_btn.focus_mode = Control.FOCUS_NONE
		arrow_btn.custom_minimum_size = Vector2(20, 0)
		arrow_btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		arrow_btn.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		arrow_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
		arrow_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		arrow_btn.pressed.connect(func(): toggle_node(captured_id))
		row.add_child(arrow_btn)
	else:
		var spacer := Control.new()
		spacer.custom_minimum_size.x = 20
		row.add_child(spacer)

	# Icon
	var icon_lbl := Label.new()
	icon_lbl.text = "📁" if is_folder and expanded else "📂" if is_folder else "📄"
	icon_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	row.add_child(icon_lbl)

	# Label (clickable)
	var name_btn := Button.new()
	name_btn.text = node["label"]
	name_btn.flat = true
	name_btn.focus_mode = Control.FOCUS_NONE
	name_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	name_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var is_selected := node_id == _selected_id
	var text_c := UITheme.PRIMARY if is_selected else UITheme.TEXT_PRIMARY
	name_btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	name_btn.add_theme_color_override("font_color", text_c)
	name_btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY_LIGHT)

	# Transparent / hover styles
	var n_s := StyleBoxFlat.new()
	n_s.bg_color = UITheme.PRIMARY_SOFT if is_selected else Color.TRANSPARENT
	n_s.corner_radius_top_left = UITheme.RADIUS_XS
	n_s.corner_radius_top_right = UITheme.RADIUS_XS
	n_s.corner_radius_bottom_left = UITheme.RADIUS_XS
	n_s.corner_radius_bottom_right = UITheme.RADIUS_XS
	n_s.content_margin_left = 6; n_s.content_margin_right = 6
	n_s.content_margin_top = 3; n_s.content_margin_bottom = 3

	var h_s := n_s.duplicate()
	h_s.bg_color = UITheme.SURFACE_3

	name_btn.add_theme_stylebox_override("normal", n_s)
	name_btn.add_theme_stylebox_override("hover", h_s)
	name_btn.add_theme_stylebox_override("pressed", h_s)
	name_btn.add_theme_stylebox_override("focus", n_s)

	name_btn.pressed.connect(func():
		_selected_id = captured_id
		node_selected.emit(captured_id)
		_rebuild.call_deferred()
	)
	row.add_child(name_btn)

	# Children
	if is_folder and expanded:
		for child_id in children:
			var cid: String = child_id
			_build_node(cid, depth + 1)
