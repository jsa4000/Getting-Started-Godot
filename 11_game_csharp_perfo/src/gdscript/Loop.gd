extends Spatial

func _ready():
	print("Starting GD Script Test")
	
	_simpleLoopTest()
	
	"""
	Starting GD Script Test
	Fibonacci Test with counter 20000000 has finished in 1389 ms
	Fibonacci Test with counter 20000000 has finished in 1383 ms
	Fibonacci Test with counter 20000000 has finished in 1373 ms
	Fibonacci Test with counter 20000000 has finished in 1376 ms
	Fibonacci Test with counter 20000000 has finished in 1427 ms
	Fibonacci Test with counter 20000000 has finished in 1377 ms
	Fibonacci Test with counter 20000000 has finished in 1398 ms
	Fibonacci Test with counter 20000000 has finished in 1399 ms
	Fibonacci Test with counter 20000000 has finished in 1392 ms
	Fibonacci Test with counter 20000000 has finished in 1396 ms
	Fibonacci Test with counter 20000000 has finished in 1420 ms
	Fibonacci Test with counter 20000000 has finished in 1395 ms
	Fibonacci Test with counter 20000000 has finished in 1402 ms
	Fibonacci Test with counter 20000000 has finished in 1400 ms
	Fibonacci Test with counter 20000000 has finished in 1406 ms
	Fibonacci Test with counter 20000000 has finished in 1408 ms
	Fibonacci Test with counter 20000000 has finished in 1397 ms
	Fibonacci Test with counter 20000000 has finished in 1409 ms
	Fibonacci Test with counter 20000000 has finished in 1411 ms
	Fibonacci Test with counter 20000000 has finished in 1400 ms
	Simple Loop has been finished with an average of 1397.900000
	GDScript has been finished

	"""
	print("GDScript has been finished")

func _simpleLoopTest():
	var series = 20
	var counter = 20000000
	
	var executions = []
	for i in range(0, series ):
		executions.append(_simpleLoop(counter))
		
	var average = 0.0
	for i in executions:
		average += i
	average = average /  executions.size()
	print("Simple Loop has been finished with an average of %f" % average)
	
func _simpleLoop(number : int) -> float:
	var start_time = OS.get_ticks_msec()

	var counter = 0
	for i in range(0, number):
		counter += 1

	var elapsedMs = OS.get_ticks_msec() - start_time
	print("Fibonacci Test with counter %s has finished in %s ms" % [counter,elapsedMs])
	return elapsedMs;
	
