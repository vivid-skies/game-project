extends BoxContainer

var pointingHand: CursorShape = Control.CURSOR_POINTING_HAND
var arrow: CursorShape = Control.CURSOR_ARROW


@onready var clickSound: AudioStreamPlayer = %AudioPlayerClick
@onready var hoverSound: AudioStreamPlayer = %AudioPlayerHover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons: Array[Node] = get_children()
	for i in buttons.size():
		var child: TextureButton = buttons[i]
		registerButton(child)
		



	# StartButton.mouse_entered.connect(_on_mouse_entered.bind(StartButton))
	# StartButton.mouse_exited.connect(_on_mouse_exited.bind(StartButton))

	# SettingsButton.mouse_entered.connect(_on_mouse_entered)
	# SettingsButton.mouse_exited.connect(_on_mouse_exited)

	# QuitButton.mouse_entered.connect(_on_mouse_entered)
	# QuitButton.mouse_exited.connect(_on_mouse_exited)

	# player.hit.connect(_on_player_hit.bind("sword", 100))

# func _on_button_down():

# print("Button down!")

# func _on_player_hit(weapon_type, damage):

# print("Hit with weapon %s for %d damage." % weapon_type, damage)
func registerButton(button: TextureButton) -> void:
	button.pressed.connect(_on_button_pressed.bind(button))
	button.mouse_entered.connect(_on_mouse_entered.bind(button))
	button.mouse_exited.connect(_on_mouse_exited.bind(button))

func _process(_delta: float) -> void:
	pass

func _on_mouse_entered(button: TextureButton) -> void:
	hoverSound.play()
	button.custom_minimum_size = Vector2(26, 26)
	button.mouse_default_cursor_shape = pointingHand
	# print("Mouse Entered")

func _on_mouse_exited(button: TextureButton) -> void:
	button.custom_minimum_size = Vector2(24, 24)
	button.mouse_default_cursor_shape = arrow
	# print("Mouse Exited")

func _on_button_pressed(button: TextureButton) -> void:
	clickSound.play()
	print(button.name + " Clicked!")
