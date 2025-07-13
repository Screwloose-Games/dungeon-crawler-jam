class_name BattleEndCondition
extends Resource

func check_condition(_battle: Battle) -> BattleResult:
	assert(false, "BattleEndCondition is abstract and must be inherited by a child class")
	return null
