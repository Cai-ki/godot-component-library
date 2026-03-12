class_name UIToast
extends Node

## Non-blocking toast notification that auto-dismisses.
## Usage: add to any scene node, then call show_toast().
## Internally creates a CanvasLayer(100) at the viewport root so toasts
## always render above the entire UI regardless of where UIToast lives.

enum ToastType { INFO, SUCCESS, WARNING, ERROR }

@export var default_duration: float = 3.0


func show_toast(message: String, type: ToastType = ToastType.INFO, duration: float = -1.0) -> void:
	var stack := _get_or_create_stack()
	var dur := default_duration if duration < 0.0 else duration

	var color: Color
	var icon: String
	match type:
		ToastType.SUCCESS: color = UITheme.SUCCESS; icon = "✓"
		ToastType.WARNING: color = UITheme.WARNING; icon = "⚠"
		ToastType.ERROR:   color = UITheme.DANGER;  icon = "✕"
		_:                 color = UITheme.INFO;    icon = "ℹ"

	# Centering wrapper
	var wrapper := CenterContainer.new()
	wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(wrapper)

	# Toast pill
	var panel := PanelContainer.new()
	var s := StyleBoxFlat.new()
	s.bg_color = Color(color.r, color.g, color.b, 0.15)
	s.corner_radius_top_left     = UITheme.RADIUS_PILL
	s.corner_radius_top_right    = UITheme.RADIUS_PILL
	s.corner_radius_bottom_left  = UITheme.RADIUS_PILL
	s.corner_radius_bottom_right = UITheme.RADIUS_PILL
	s.border_width_top    = 1; s.border_width_bottom = 1
	s.border_width_left   = 1; s.border_width_right  = 1
	s.border_color  = Color(color.r, color.g, color.b, 0.5)
	s.shadow_size   = 12
	s.shadow_color  = Color(0, 0, 0, 0.3)
	s.shadow_offset = Vector2(0, 4)
	s.content_margin_left   = 18; s.content_margin_right  = 18
	s.content_margin_top    = 12; s.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", s)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.add_child(panel)

	# Icon + message
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(h)

	var icon_lbl := Label.new()
	icon_lbl.text = icon
	icon_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	icon_lbl.add_theme_color_override("font_color", color)
	h.add_child(icon_lbl)

	var msg_lbl := Label.new()
	msg_lbl.text = message
	msg_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	msg_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	h.add_child(msg_lbl)

	# Fade in
	wrapper.modulate.a = 0.0
	var tween_in := create_tween()
	tween_in.tween_property(wrapper, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)

	# Auto-dismiss via Timer owned by wrapper (safe if wrapper is freed early)
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = dur
	wrapper.add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		if not is_instance_valid(wrapper):
			return
		var tween_out := create_tween()
		tween_out.tween_property(wrapper, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		tween_out.finished.connect(func():
			if is_instance_valid(wrapper):
				wrapper.queue_free()
		)
	)


# Returns (or creates) the VBoxContainer inside a CanvasLayer(100) at root.
# Layer 100 ensures toasts render above all UI regardless of CanvasLayer setup.
func _get_or_create_stack() -> VBoxContainer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == &"_UIToastLayer":
			return child.get_child(0) as VBoxContainer

	var layer := CanvasLayer.new()
	layer.name = "_UIToastLayer"
	layer.layer = 100
	root.add_child(layer)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_theme_constant_override("separation", 8)
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.offset_bottom = -24
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(vbox)
	return vbox
