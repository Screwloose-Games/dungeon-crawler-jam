# Technical Specs

An action that can only target a unit on an enemy team.

An ability that can only target a unit.

The ability determines what it can target.

The move ability determines what it can target.


For movement and other abilities, there are constraints on what can be targeted.


## TargetConstraint

Abstract UnitTargetConstraint

UnitPresentTargetConstraint
* inverse (true/false)
UnitRelationTargetConstraint
* relation (ally/enemy/neutral/same)
* inverse (true/false)
TerrainTypeTargetConstraint
* terrain_type (ground/water/air)

Walk is an ability