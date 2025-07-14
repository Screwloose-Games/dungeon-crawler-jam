## Base class for conditions that determine when a [Battle] should end and who wins. [br]
## Used by [BattleScenario] to define victory, defeat, or draw conditions for tactical combat. [br]
## Evaluated each turn to check if the battle should conclude based on specific criteria. [br]
## Derived classes implement specific win conditions like defeating all enemies or capturing objectives.
class_name BattleEndCondition
extends Resource


## Checks whether this end condition has been met in the current battle state. [br]
## This is an abstract method that must be overridden in derived classes. [br]
## [br]
## [param _battle] The current battle to evaluate for end conditions [br]
## [br]
## [b]Returns:[/b] A [BattleResult] if the condition is met, null otherwise.
func check_condition(_battle: Battle) -> BattleResult:
	assert(false, "BattleEndCondition is abstract and must be inherited by a child class")
	return null
