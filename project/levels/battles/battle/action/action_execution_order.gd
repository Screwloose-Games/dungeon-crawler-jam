## Represents a specific command issued by a [Commander] to execute a [UnitAction]. [br]
## Links a commanding [Commander] to a target [Unit] and the specific [UnitAction] to perform. [br]
## Encapsulates the complete context needed to execute an [Action].
class_name ActionExecutionCommand
extends Resource

@export var unit: Unit
@export var commander: Commander
@export var action: UnitAction
@export var targets: Array[BattleGridCell]
