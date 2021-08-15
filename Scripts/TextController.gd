extends PanelContainer


const InputResponse = preload("res://Scenes/InputResponse.tscn")
const Response = preload("res://Scenes/Response.tscn")

export (int) var max_lines_remembered := 30

# Keeps track of scroll bar to enable scrolling with auto snap
var max_scroll_length: = 0

onready var command_processor = $CommandProcessor
onready var history_rows = $MarginContainer/Rows/GameInfo/Scroll/HistoryRows
onready var scroll = $MarginContainer/Rows/GameInfo/Scroll
onready var scrollbar = scroll.get_v_scrollbar()


func _ready():
	scrollbar.connect("changed", self, "handle_scrollbar_changed")
	max_scroll_length = scrollbar.max_value
	
	# starting text # move to game controller?
	add_response("Type 'help' to see available commands.")


func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_length


func add_input_and_response(input_text: String, response_text: String):
	var response = InputResponse.instance()
	response.set_text(input_text, response_text)
	add_control_to_display(response)


func add_response(response_text: String):
	var response = Response.instance()
	response.text = response_text
	add_control_to_display(response)


# adds control node to history rows display in game
func add_control_to_display(response: Control):
	history_rows.add_child(response)
	delete_history_beyond_limit()


func delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_forgot = history_rows.get_child_count() - max_lines_remembered
		for i in range(rows_to_forgot):
			history_rows.get_child(i).queue_free()
