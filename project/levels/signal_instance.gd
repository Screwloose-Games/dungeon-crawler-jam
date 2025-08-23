## Maintains a list of callables and provides an API similar to [Signal]
## This is differentiated from [Signal] as arbitrary number of [SignalInstance] can be created at runtime,
## whereas normally signals must be defined at compile time.
## Cannot validate arguments of the signal and callable match,
## as GDScript does not support custom variadic arguments
## Arguments must be sent and received with [Array[Variant]]
class_name SignalInstance
extends Resource


var _callables: Array[Callable]


func add_connection(callable: Callable) -> bool:
	if has_connection(callable):
		return false

	_callables.append(callable)
	return true


func remove_connection(callable: Callable) -> bool:
	if not has_connection(callable):
		return false

	_callables.erase(callable)
	return true


func emit(args: Array[Variant]):
	for callable in _callables:
		callable.call(args)


func has_connection(callable: Callable) -> bool:
	return _callables.find(callable) >= 0