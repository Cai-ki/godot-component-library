## UIButton
**extends:** Button
**Usage:** Copy `ui_button.gd` + `../../scripts/theme.gd` to your project.

```gdscript
var btn := UIButton.new()
btn.text = "Click Me"
btn.variant = UIButton.Variant.OUTLINE
btn.color_scheme = UIButton.ColorScheme.SUCCESS
btn.pill_shape = true
add_child(btn)
```

**Exports:**
- `variant` SOLID / OUTLINE / SOFT / GHOST
- `color_scheme` PRIMARY / SECONDARY / SUCCESS / WARNING / DANGER / INFO / NEUTRAL
- `size` XS / SM / MD / LG / XL
- `pill_shape` bool
- `is_loading` bool — disables + shows spinner text

**Methods:**
- `set_loading(v: bool)` — alias for `is_loading` setter
