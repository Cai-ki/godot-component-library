## UISteps — Standalone Component
## Multi-step wizard indicator with completed/active/pending states.
##
## Usage:
##   var steps := UISteps.new()
##   steps.steps = ["Account", "Profile", "Review", "Done"]
##   steps.current_step = 1
##   steps.clickable = true
##   steps.step_clicked.connect(func(i): steps.current_step = i)
##   parent.add_child(steps)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UISteps
extends VBoxContainer

signal step_clicked(index: int)

@export var steps: PackedStringArray = []:
	set(v): steps = v; if is_inside_tree(): _rebuild.call_deferred()

@export var current_step: int = 0:
	set(v): current_step = clampi(v, 0, maxi(steps.size() - 1, 0)); if is_inside_tree(): _rebuild.call_deferred()

@export var clickable: bool = false:
	set(v): clickable = v; if is_inside_tree(): _rebuild.call_deferred()

const CIRCLE_SIZE := 36
const LINE_HEIGHT := 2


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rebuild()


# ── Public API ────────────────────────────────────────────────────────────────

func next_step() -> void:
	if current_step < steps.size() - 1:
		current_step += 1

func prev_step() -> void:
	if current_step > 0:
		current_step -= 1


# ── Build ─────────────────────────────────────────────────────────────────────

func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()

	if steps.size() == 0: return

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(row)

	for i in steps.size():
		_build_step(row, i)
		if i < steps.size() - 1:
			_build_connector(row, i)


func _build_step(parent: Control, index: int) -> void:
	var state := _step_state(index)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(col)

	# Circle
	var center := CenterContainer.new()
	col.add_child(center)

	var circle := PanelContainer.new()
	circle.custom_minimum_size = Vector2(CIRCLE_SIZE, CIRCLE_SIZE)

	var circle_c: Color
	var text_c:   Color
	var label_c:  Color
	match state:
		"completed":
			circle_c = UITheme.SUCCESS
			text_c   = Color.WHITE
			label_c  = UITheme.SUCCESS
		"active":
			circle_c = UITheme.PRIMARY
			text_c   = Color.WHITE
			label_c  = UITheme.PRIMARY
		_:
			circle_c = UITheme.SURFACE_3
			text_c   = UITheme.TEXT_MUTED
			label_c  = UITheme.TEXT_MUTED

	var cs := StyleBoxFlat.new()
	cs.bg_color = circle_c
	cs.corner_radius_top_left     = UITheme.RADIUS_PILL
	cs.corner_radius_top_right    = UITheme.RADIUS_PILL
	cs.corner_radius_bottom_left  = UITheme.RADIUS_PILL
	cs.corner_radius_bottom_right = UITheme.RADIUS_PILL
	circle.add_theme_stylebox_override("panel", cs)
	center.add_child(circle)

	# Number or checkmark
	var num_center := CenterContainer.new()
	circle.add_child(num_center)
	var content := "✓" if state == "completed" else str(index + 1)
	var num_lbl := Label.new()
	num_lbl.text = content
	num_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	num_lbl.add_theme_color_override("font_color", text_c)
	num_center.add_child(num_lbl)

	# Step label
	var step_lbl := Label.new()
	step_lbl.text = steps[index]
	step_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	step_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	step_lbl.add_theme_color_override("font_color", label_c)
	col.add_child(step_lbl)

	# Clickable behavior
	if clickable:
		circle.mouse_filter = Control.MOUSE_FILTER_STOP
		circle.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		var hover_cs := cs.duplicate()
		hover_cs.bg_color = circle_c.lightened(0.15)
		circle.mouse_entered.connect(func():
			circle.add_theme_stylebox_override("panel", hover_cs))
		circle.mouse_exited.connect(func():
			circle.add_theme_stylebox_override("panel", cs))

		var captured := index
		circle.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton:
				var mb := event as InputEventMouseButton
				if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
					step_clicked.emit(captured)
		)


func _build_connector(parent: Control, index: int) -> void:
	var completed := index < current_step
	var line_container := Control.new()
	line_container.custom_minimum_size = Vector2(60, LINE_HEIGHT)
	line_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(line_container)

	var line := ColorRect.new()
	line.anchor_top    = 0.3
	line.anchor_bottom = 0.3
	line.anchor_left   = 0.0
	line.anchor_right  = 1.0
	line.offset_top    = 0
	line.offset_bottom = LINE_HEIGHT
	line.color = UITheme.SUCCESS if completed else UITheme.SURFACE_3
	line_container.add_child(line)


func _step_state(index: int) -> String:
	if index < current_step: return "completed"
	if index == current_step: return "active"
	return "pending"
