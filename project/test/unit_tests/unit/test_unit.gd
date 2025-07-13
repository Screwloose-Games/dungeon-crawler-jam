class_name UnitTest
extends GdUnitTestSuite

const UNIT_SKELETON := preload(
	"res://levels/battles/battle/unit/resources/unit_skeleton.tres"
)

## Example: https://martinfowler.com/bliki/GivenWhenThen.html


# A Unit should load with all required fields
func test_skeleton_unit_has_required_fields():
	# Given a preloaded Skeleton unit
	var unit := UNIT_SKELETON

	# Then the unit should have a name
	assert_str(unit.name).is_not_empty()

	# And the unit should have a description
	assert_str(unit.description).is_not_empty()

	# And the unit should have at least one ability
	assert_int(unit.abilities.size()).is_greater(0)

	# And the unit should have a movement configuration
	assert_object(unit.movement).is_not_null()

	# And the unit should have valid sprite_frames
	assert_object(unit.sprite_frames).is_not_null()
	assert_bool(unit.sprite_frames.get_animation_names().size() > 0).is_true()

	# And the unit should have a portrait
	assert_object(unit.portrait).is_not_null()


func test_skeleton_unit_spends_corrent_ap_when_acting():
	pass
