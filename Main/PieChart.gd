extends Control

func _ready() -> void:
	set_data([51,0,0,4,0,0,0,0,0,49])

func set_data(Data : Array[float] = [0,0,0,0,0,0,0,0,0,0]):
	var index : int = 0
	var LastAngle : float = 0
	var TotalAmount : float = 0
	for i in Data:
		TotalAmount += i
	var Percentage : float = 0
	for child in $Chart.get_children():
		Percentage = ((Data[index])/(TotalAmount))*100
		var DataTweener = create_tween()
		DataTweener.tween_property(child, "value", Percentage, 0.15)
#		(child as TextureProgressBar).value = Data[index]
		var AngleTweener = create_tween()
		AngleTweener.tween_property(child, "rotation_degrees", LastAngle, 0.15)
#		(child as TextureProgressBar).rotation_degrees = LastAngle
#		print("Index: " + str(index) + "\nPercentage: " + str(Data[index]) + "\nRotation: " + str(LastAngle) + "\n\n\n")
		LastAngle += ((Percentage)/(100))*360
		index = index + 1

func reset_data():
	for child in $Chart.get_children():
		child.rotation_degrees = 0
		child.value = 0


