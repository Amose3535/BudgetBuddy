extends Panel
@onready var Icon = preload("res://Main/Assets/WhiteTickSmall.png")
@onready var IncomeButton : Button = $Entrata
@onready var OutcomeButton : Button = $Uscita
@export var Entrata : bool = false

func _ready() -> void:
	IncomeButton.button_pressed = true
	_on_entrata_pressed()

func _on_entrata_pressed() -> void:
	OutcomeButton.button_pressed = false
	Entrata = true
	(IncomeButton as Button).icon = Icon
	(OutcomeButton as Button).icon = null

func _on_uscita_pressed() -> void:
	IncomeButton.button_pressed = false
	Entrata = false
	(IncomeButton as Button).icon = null
	(OutcomeButton as Button).icon = Icon
