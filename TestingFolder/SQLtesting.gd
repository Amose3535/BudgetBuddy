extends Control

@export var DataPath = "user://test_database.db"

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = DataPath
	database.open_db()


func _on_insert_data_pressed() -> void:
	if $FormElements/Element1/InsertName.text == null:
		pass
	elif $FormElements/Element2/InsertScore.text == null:
		pass
	else:
		var ScoreText : String = $FormElements/Element2/InsertScore.text
		if ScoreText.is_valid_int():
			var data = {
				"name" : $FormElements/Element1/InsertName.text,
				"score" : $FormElements/Element2/InsertScore.text
			}
			
			database.insert_row("players",data)


func _on_create_table_pressed() -> void:
	var table = {
		"id" : {"data_type" : "int","primary_key" : true,"not_null" : true,"auto_increment" : true},
		"name" : {"data_type" : "text"},
		"score" : {"data_type" : "int"}
	}
	
	database.create_table("players", table)


func _on_select_data_pressed() -> void:
	#for easy sake i'm gonna show a static expression in order to explain how to use
	#sqlite's custom functions
	var condition : String = "score >= 100"
	var table : String = "players"
	var column1 : String = "name"
	var column2 : String = "score"
	var wantedcolumns = [column1,column2]
	var SelectedValues = database.select_rows(table,condition,wantedcolumns)
	print(SelectedValues)


func _on_updata_data_pressed() -> void:
	#Used to update some certain parameters in a specific pre-existing row. In a more general picture
	#it would be best to automate this process
	var table : String = "players"
	var updatecondition : String = "name = '"+$FormElements/Element1/InsertName.text+"'"
	#Following var has to be a dict so that if wanted is possible to update multiple variables in a row
	var updatedfields : Dictionary = {"score" : int($FormElements/Element2/InsertScore.text)} 
	database.update_rows(table,updatecondition,updatedfields)


func _on_delete_data_pressed() -> void:
	var table : String = "players"
	var deletecondition : String = "name = '"+$FormElements/Element1/InsertName.text+"'"
	database.delete_rows(table,deletecondition)


func _on_custom_select_pressed() -> void:
	var query = "select * from players where score > " + $FormElements/Element2/InsertScore.text
	database.query(query)
	for i in database.query_result:
		print(i)
