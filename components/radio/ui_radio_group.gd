## UIRadioGroup — Standalone Component
## Groups UIRadio buttons so only one can be selected at a time.
##
## Usage:
##   var group := UIRadioGroup.new()
##   group.add_radio(radio1)
##   group.add_radio(radio2)
##   group.selected_index = 0
##   group.selection_changed.connect(func(i): print(i))
##   parent.add_child(group)
##
## Dependencies: UIRadio, scripts/theme.gd (UITheme)
class_name UIRadioGroup
extends VBoxContainer

signal selection_changed(index: int)

@export var selected_index: int = -1:
	set(v):
		selected_index = v
		if is_inside_tree(): _apply_selection()

var _radios: Array[UIRadio] = []


func _ready() -> void:
	add_theme_constant_override("separation", 8)
	_apply_selection()


# ── Public API ────────────────────────────────────────────────────────────────

func add_radio(radio: UIRadio) -> void:
	_radios.append(radio)
	add_child(radio)
	var idx := _radios.size() - 1
	radio.toggled.connect(func(_v: bool): _on_radio_toggled(idx))
	radio.checked = (idx == selected_index)


# ── Internal ──────────────────────────────────────────────────────────────────

func _on_radio_toggled(idx: int) -> void:
	selected_index = idx
	selection_changed.emit(idx)


func _apply_selection() -> void:
	for i in _radios.size():
		_radios[i].checked = (i == selected_index)
