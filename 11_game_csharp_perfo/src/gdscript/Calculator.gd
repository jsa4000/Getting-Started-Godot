extends Spatial

func _ready():
	
	var calculator = load("res://src/csharp/Calculator.cs").new()
	print(calculator.name)
	
	var result = calculator.Sum(1.0, 2.0)
	print("The sum is %f" % result)

