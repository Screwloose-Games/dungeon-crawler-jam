## A [TargetTileConstraint] that provides OR behavior for multiple constraints. [br]
## If any of the listed tile constraints are satisfied, this constraint is valid. [br]
## Use this when you want flexible targeting where multiple different conditions could work. [br]
## Contrasts with the default AND behavior when multiple constraints are used on an [Ability].
class_name AnyTargetTileConstraint
extends TargetTileConstraint

## Array of constraints where any one being satisfied makes this constraint valid
@export var constraints: Array[TargetTileConstraint]


## Validates that at least one of the member constraints is satisfied. [br]
## updates [param preview] with the result
func validate(
	command: ActionExecutionCommand,
	preview: ActionPreviewData,
):
	var results: Array[ActionPreviewData] = []
	for constraint in constraints:
		# Temp preview data to get result from tile constraint
		var constraint_result = ActionPreviewData.new()
		constraint.validate(command, constraint_result)
		results.append(constraint_result)
		if constraint_result.valid:
			return

	# None of the constraints were valid, so let's add all as errors
	for result in results:
		for error in result.get_error_reasons():
			preview.add_error(error)
