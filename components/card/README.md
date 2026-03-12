## UICard
**extends:** PanelContainer
**Usage:** Copy `ui_card.gd` + `../../scripts/theme.gd`

```gdscript
var card := UICard.new()
card.elevation = 1
card.hoverable = true
add_child(card)
var content := card.get_content()
content.add_child(some_label)
```

**Exports:**
- `elevation` int 0–3 (shadow depth)
- `hoverable` bool (hover highlight effect)
- `accent_color` Color (left border accent; TRANSPARENT = all-border)
- `pad_h / pad_v` int (horizontal/vertical padding)

**Methods:**
- `get_content() -> VBoxContainer`
