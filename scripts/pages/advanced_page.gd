class_name AdvancedPage
extends RefCounted


func build(parent: Control) -> void:
	UI.page_header(parent, "Advanced Components",
		"UITreeView, UIColorPicker, UIDatePicker, and UICommandPalette — complex interactive widgets.")

	_tree_section(parent)
	_color_picker_section(parent)
	_date_picker_section(parent)
	_command_palette_section(parent)


# =============================================
# TREE VIEW
# =============================================

func _tree_section(parent: Control) -> void:
	UI.section(parent, "Tree View  (UITreeView)")

	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 24)

	# ── Tree 1: File explorer ──
	var col1 := VBoxContainer.new()
	col1.add_theme_constant_override("separation", 8)
	col1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col1)
	col1.add_child(UI.label("File Explorer", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var tree1 := UITreeView.new()
	var src := tree1.add_node("src", "", true)
	var comp := tree1.add_node("components", src, true)
	tree1.add_node("ui_button.gd", comp)
	tree1.add_node("ui_card.gd", comp)
	tree1.add_node("ui_input.gd", comp)
	var scripts := tree1.add_node("scripts", src, true)
	tree1.add_node("main.gd", scripts)
	tree1.add_node("theme.gd", scripts)
	tree1.add_node("helpers.gd", scripts)
	var pages := tree1.add_node("pages", scripts, true)
	tree1.add_node("home_page.gd", pages)
	tree1.add_node("buttons_page.gd", pages)
	tree1.add_node("project.godot", src)
	tree1.add_node("README.md", src)
	col1.add_child(tree1)

	# ── Tree 2: Organization chart ──
	var col2 := VBoxContainer.new()
	col2.add_theme_constant_override("separation", 8)
	col2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col2)
	col2.add_child(UI.label("Organization Structure", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var tree2 := UITreeView.new()
	var eng := tree2.add_node("Engineering", "", true)
	var fe := tree2.add_node("Frontend", eng, true)
	tree2.add_node("Alice Chen", fe)
	tree2.add_node("Bob Kim", fe)
	var be := tree2.add_node("Backend", eng, true)
	tree2.add_node("Carol Liu", be)
	tree2.add_node("David Park", be)
	var design := tree2.add_node("Design", "", true)
	tree2.add_node("Eve Wang", design)
	tree2.add_node("Frank Zhang", design)
	col2.add_child(tree2)

	# Selection feedback
	UI.spacer(card_v, 8)
	var status_lbl := UI.label("Click a node to select it", UITheme.FONT_SM, UITheme.TEXT_MUTED)
	card_v.add_child(status_lbl)

	var toast := UIToast.new()
	card_v.add_child(toast)
	tree1.node_selected.connect(func(id: String):
		toast.show_toast("Selected: " + id, UIToast.ToastType.INFO)
	)
	tree2.node_selected.connect(func(id: String):
		toast.show_toast("Selected: " + id, UIToast.ToastType.INFO)
	)


# =============================================
# COLOR PICKER
# =============================================

func _color_picker_section(parent: Control) -> void:
	UI.section(parent, "Color Picker  (UIColorPicker)")

	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 32)

	# ── Picker ──
	var picker_col := VBoxContainer.new()
	picker_col.add_theme_constant_override("separation", 8)
	row.add_child(picker_col)
	picker_col.add_child(UI.label("Select a Color", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var picker := UIColorPicker.new()
	picker_col.add_child(picker)

	# ── Live preview ──
	var preview_col := VBoxContainer.new()
	preview_col.add_theme_constant_override("separation", 12)
	preview_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(preview_col)
	preview_col.add_child(UI.label("Live Preview", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	# Preview card
	var preview_panel := PanelContainer.new()
	preview_panel.custom_minimum_size = Vector2(0, 80)
	var preview_style := StyleBoxFlat.new()
	preview_style.bg_color = picker.current_color
	preview_style.corner_radius_top_left = UITheme.RADIUS_LG
	preview_style.corner_radius_top_right = UITheme.RADIUS_LG
	preview_style.corner_radius_bottom_left = UITheme.RADIUS_LG
	preview_style.corner_radius_bottom_right = UITheme.RADIUS_LG
	preview_panel.add_theme_stylebox_override("panel", preview_style)
	preview_col.add_child(preview_panel)

	var preview_center := CenterContainer.new()
	preview_panel.add_child(preview_center)
	var preview_lbl := UI.label("Selected Color", UITheme.FONT_LG, Color.WHITE)
	preview_center.add_child(preview_lbl)

	# Hex value label
	var hex_lbl := UI.label("HEX: #" + picker.current_color.to_html(false), UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	preview_col.add_child(hex_lbl)

	# Demo buttons with selected color
	var btn_row := UI.hbox(preview_col, 8)
	var demo_solid := UIButton.new()
	demo_solid.text = "Solid"
	demo_solid.variant = UIButton.Variant.SOLID
	btn_row.add_child(demo_solid)

	var demo_outline := UIButton.new()
	demo_outline.text = "Outline"
	demo_outline.variant = UIButton.Variant.OUTLINE
	btn_row.add_child(demo_outline)

	var demo_badge := UIBadge.new()
	demo_badge.badge_text = "Badge"
	demo_badge.variant = UIBadge.Variant.FILLED
	btn_row.add_child(demo_badge)

	# Update preview on color change
	picker.color_changed.connect(func(c: Color):
		preview_style.bg_color = c
		preview_panel.add_theme_stylebox_override("panel", preview_style)
		hex_lbl.text = "HEX: #" + c.to_html(false)
		# Contrast text
		var tc := Color.WHITE if c.get_luminance() < 0.5 else Color.BLACK
		preview_lbl.add_theme_color_override("font_color", tc)

		# Update demo buttons using theme overrides
		var solid_s := StyleBoxFlat.new()
		solid_s.bg_color = c
		solid_s.corner_radius_top_left = UITheme.RADIUS_MD
		solid_s.corner_radius_top_right = UITheme.RADIUS_MD
		solid_s.corner_radius_bottom_left = UITheme.RADIUS_MD
		solid_s.corner_radius_bottom_right = UITheme.RADIUS_MD
		solid_s.content_margin_left = 20; solid_s.content_margin_right = 20
		solid_s.content_margin_top = 10; solid_s.content_margin_bottom = 10
		demo_solid.add_theme_stylebox_override("normal", solid_s)
		demo_solid.add_theme_stylebox_override("hover", solid_s)
		demo_solid.add_theme_stylebox_override("pressed", solid_s)
		demo_solid.add_theme_color_override("font_color", tc)

		var outline_s := solid_s.duplicate()
		outline_s.bg_color = Color.TRANSPARENT
		outline_s.border_color = c
		outline_s.border_width_left = 1; outline_s.border_width_right = 1
		outline_s.border_width_top = 1; outline_s.border_width_bottom = 1
		demo_outline.add_theme_stylebox_override("normal", outline_s)
		demo_outline.add_theme_stylebox_override("hover", outline_s)
		demo_outline.add_theme_color_override("font_color", c)

		var badge_s := StyleBoxFlat.new()
		badge_s.bg_color = c
		badge_s.corner_radius_top_left = UITheme.RADIUS_XS
		badge_s.corner_radius_top_right = UITheme.RADIUS_XS
		badge_s.corner_radius_bottom_left = UITheme.RADIUS_XS
		badge_s.corner_radius_bottom_right = UITheme.RADIUS_XS
		badge_s.content_margin_left = 10; badge_s.content_margin_right = 10
		badge_s.content_margin_top = 4; badge_s.content_margin_bottom = 4
		demo_badge.add_theme_stylebox_override("panel", badge_s)
	)


# =============================================
# DATE PICKER
# =============================================

func _date_picker_section(parent: Control) -> void:
	UI.section(parent, "Date Picker  (UIDatePicker)")

	var card_v := UI.card(parent, 24, 20)
	var row := UI.hbox(card_v, 32)

	# ── Basic date picker ──
	var col1 := VBoxContainer.new()
	col1.add_theme_constant_override("separation", 8)
	row.add_child(col1)
	col1.add_child(UI.label("Basic", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var dp1 := UIDatePicker.new()
	dp1.label_text = "Start Date"
	dp1.custom_minimum_size.x = 220
	col1.add_child(dp1)

	# ── With placeholder ──
	var col2 := VBoxContainer.new()
	col2.add_theme_constant_override("separation", 8)
	row.add_child(col2)
	col2.add_child(UI.label("Custom Placeholder", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	var dp2 := UIDatePicker.new()
	dp2.label_text = "End Date"
	dp2.placeholder = "Pick an end date..."
	dp2.custom_minimum_size.x = 220
	col2.add_child(dp2)

	UI.spacer(card_v, 12)

	# Feedback label
	var result_lbl := UI.label("Selected: (none)", UITheme.FONT_MD, UITheme.TEXT_SECONDARY)
	card_v.add_child(result_lbl)

	dp1.date_selected.connect(func(d: Dictionary):
		if d.is_empty():
			result_lbl.text = "Start date cleared"
		else:
			result_lbl.text = "Start date: %04d-%02d-%02d" % [d["year"], d["month"], d["day"]]
	)
	dp2.date_selected.connect(func(d: Dictionary):
		if d.is_empty():
			result_lbl.text = "End date cleared"
		else:
			result_lbl.text = "End date: %04d-%02d-%02d" % [d["year"], d["month"], d["day"]]
	)


# =============================================
# COMMAND PALETTE
# =============================================

func _command_palette_section(parent: Control) -> void:
	UI.section(parent, "Command Palette  (UICommandPalette)")

	var card_v := UI.card(parent, 24, 20)

	card_v.add_child(UI.label("Press  Ctrl+K  or click the button to open", UITheme.FONT_SM, UITheme.TEXT_MUTED))

	UI.spacer(card_v, 4)

	# Create command palette
	var palette := UICommandPalette.new()
	palette.add_command("Go to Dashboard", "Navigate to the main dashboard", "🏠", "Navigation")
	palette.add_command("Go to Settings", "Open application settings", "⚙", "Navigation")
	palette.add_command("Go to Profile", "View your user profile", "👤", "Navigation")
	palette.add_command("New Project", "Create a new project from scratch", "📁", "Actions")
	palette.add_command("Import File", "Import data from external source", "📥", "Actions")
	palette.add_command("Export PDF", "Export current view as PDF", "📄", "Actions")
	palette.add_command("Toggle Theme", "Switch between dark and light mode", "🎨", "Preferences")
	palette.add_command("Keyboard Shortcuts", "View all keyboard shortcuts", "⌨", "Help")
	palette.add_command("Documentation", "Open the documentation site", "📖", "Help")
	palette.add_command("Report Bug", "Submit a bug report", "🐛", "Help")
	card_v.add_child(palette)

	# Open button
	var btn_row := UI.hbox(card_v, 12)
	var open_btn := UIButton.new()
	open_btn.text = "🔍  Open Command Palette"
	open_btn.variant = UIButton.Variant.OUTLINE
	open_btn.color_scheme = UIButton.ColorScheme.PRIMARY
	open_btn.button_size = UIButton.Size.LG
	open_btn.pressed.connect(palette.show_palette)
	btn_row.add_child(open_btn)

	# Keyboard shortcut hint
	var hint_panel := PanelContainer.new()
	var hint_s := StyleBoxFlat.new()
	hint_s.bg_color = UITheme.SURFACE_3
	hint_s.corner_radius_top_left = UITheme.RADIUS_SM
	hint_s.corner_radius_top_right = UITheme.RADIUS_SM
	hint_s.corner_radius_bottom_left = UITheme.RADIUS_SM
	hint_s.corner_radius_bottom_right = UITheme.RADIUS_SM
	hint_s.content_margin_left = 10; hint_s.content_margin_right = 10
	hint_s.content_margin_top = 6; hint_s.content_margin_bottom = 6
	hint_panel.add_theme_stylebox_override("panel", hint_s)
	hint_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	btn_row.add_child(hint_panel)

	var hint_lbl := Label.new()
	hint_lbl.text = "Ctrl+K"
	hint_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	hint_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	hint_panel.add_child(hint_lbl)

	UI.spacer(card_v, 8)

	# Result feedback
	var result_lbl := UI.label("Select a command to see the result...", UITheme.FONT_SM, UITheme.TEXT_SECONDARY)
	card_v.add_child(result_lbl)

	var toast := UIToast.new()
	card_v.add_child(toast)

	palette.command_selected.connect(func(id: String):
		result_lbl.text = "Executed command: " + id
		toast.show_toast("Command: " + id, UIToast.ToastType.SUCCESS)
	)
