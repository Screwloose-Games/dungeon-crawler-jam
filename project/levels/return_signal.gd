## Object that tracks a number of blockers, and will execute a given callable once all blockers have been complete
## Participants must register themselves with register_blocker()
## Once they are ready, they should call complete_blocker()
## The callable will only ever be called once
class_name ReturnSignal
extends RefCounted

var _pending_count: int
var _on_complete: Callable
var _all_registered: bool

func _init(on_complete: Callable):
	_pending_count = 0
	_on_complete = on_complete


## Must be called once it is ensured that all participants have registered
func all_participants_registered():
	_all_registered = true
	if _pending_count == 0:
		_execute()


func register_blocker():
	_pending_count += 1


func complete_blocker():
	_pending_count -= 1
	if _all_registered and is_complete():
		_execute()


func is_complete() -> bool:
	return _pending_count == 0


func _execute():
	if _on_complete:
		_on_complete.call()
		# Remove value to ensure its only called once
		_on_complete = func(): return
