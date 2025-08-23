## [SignalTracker] keeps a list of signals and their associated callables
## Provides the ability to disconnect from all associated signals at once
class_name SignalTracker
extends Resource


var signal_info_list: Array[SignalInfo] = []


func add_signal(_signal: Signal, callable: Callable, connect_flags: int = 0) -> bool:
	assert(
		connect_flags & Object.CONNECT_REFERENCE_COUNTED == 0,
		"Reference counting is not supported by SignalTracker"
	)

	print("Attempting to add signal")
	if _find_info(_signal, callable) != null:
		print("Signal already exists, skipping")
		return false

	var signal_info = SignalInfo.new(_signal, callable, connect_flags)
	if signal_info.try_connect():
		signal_info_list.append(signal_info)

	return true


func disconnect_signal(_signal: Signal, callable: Callable):
	var info := _find_info(_signal, callable)
	info.try_disconnect()
	signal_info_list.erase(info)


func disconnect_all_signals():
	for signal_info in signal_info_list:
		signal_info.try_disconnect()
	signal_info_list.clear()


func _find_info(_signal: Signal, callable: Callable) -> SignalInfo:
	for info in signal_info_list:
		if info._signal == _signal and info.callable == callable:
			return info
	return null


class SignalInfo:
	var _signal: Signal
	var callable: Callable
	var connect_flags: int

	func _init(_signal: Signal, callable: Callable, connect_flags: Object.ConnectFlags):
		self._signal = _signal
		self.callable = callable
		self.connect_flags = connect_flags


	func try_connect() -> bool:
		if _signal.is_connected(callable):
			return false
		_signal.connect(callable)
		print("Signal connected")
		return true


	func try_disconnect() -> bool:
		if not _signal.is_connected(callable):
			return false
		_signal.disconnect(callable)
		return true
