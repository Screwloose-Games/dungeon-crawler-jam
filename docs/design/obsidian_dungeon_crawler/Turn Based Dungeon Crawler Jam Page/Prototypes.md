## The player can fight and win or lose a battle
  
1. There is a [BattleScenario](https://www.notion.so/BattleScenario-22b16088def0804090d4dc0060165230?pvs=21) that has
2. There is a Level that starts a Battle on a Battlefield
3. When the [[Battle]] starts, [[BattleRound]] repeat until there is a [[BattleEndCondition]]
4. There is a [[BattleGrid]] system consisting of [[BattleGridCell]]
    1. Gri
5. There is a player character on the grid @rogue
6. There is an enemy on the grid (skeleton)
7. There are 2 “teams, an enemy team and a player team.
8. There is a [[Commander]] turn order.
9. Each [[Commander]] takes a turn in the turn order.
10. Each unit can move and/or attack(action) on their turn.
11. The player can move
12. The player can attack the enemy and hurt it
13. The enemy can move
14. AI: if not in melee range, The enemy moves to the closest player, otherwise it attacks the player
15. The enemy can attack and hurt the player
16. The player can kill the enemy
17. The enemy can kill the player
18. Each grid square of movement uses movement points by unit_move_ap_cost
19. Units have a limited amount of movement points.
20. A unit can only move if it has enough movement points
  
## A navigable overworld
  
- There is a map with connected nodes (graph)
- When one node is “completed”, paths after it unlock.
- A player can move from their current node to any connected nodes through unlocked paths
- A player can activate the node that they are on and start that “level”
- There are 2 connected nodes with “levels” to start.
  
## Story
  
- Characters of the party
  
## Technical Planning
- [ ] Encounter
- [ ] BattleScenario - Kai
- [ ] Battle - Kai
    - [ ] End conditions
        - [ ] Watch for conditions met
    - [x] Teams
    - [ ] TeamRelationships
        - [ ] Fix data structure
    - [ ] BattleGrid
        - [x] Stores cell data
        - [x] Pulls the cell data from battlefield and gridObjectLayout from BattleScenario
        - [ ] Might need more methods to function as a nice to use API
            - [ ] It can move units, and update the position variable in Unit
            - [ ] Previews..
            - [ ] Moving
            - [ ] Astar2D
    - [ ] Battlefield
        - [x] Ability to edit in tile editor
        - [x] Have floor, wall, and pit tiles
        - [ ] Use latest tile sprites
    - [ ] GridObjectLayout
        - [x] Ability edit in tile editor
        - [ ] Add rogue and enemy in tileset, linked to their Unit resources
- [ ] BattleTurn - Kai
    - [ ] Related to team
    - [ ] Signal turn start
    - [ ] Signal turn ended
    - [ ] Controlled by round
    - [ ] Commander chooses to end turn
- [ ] BattleRound - Kai
    - [ ] Turn order
    - [ ] Signal round started, round ended
- [ ] ActionPreview
    - [ ] Listen for preview_execution_command
    - [ ] highlight tiles according to TileConstraints
    - [ ] Movement preview
        - [ ] show reachables tiles
        - [ ] show path
    - [ ] Show expected damage
  
- [ ] Unit Resources - Jonny
    - [ ] Rogue
    - [ ] Skeleton archer
    - [x] HP
    - [x] AP
    - [ ] Movement points
    - [ ] Selected, Hit, Died signals
    - [x] Associated portrait (if any)
    - [ ] play hit, attack, die animations
- [ ] Commander
    - [ ] Keeps track of unit selection
- [ ] ActionPane
    - [ ] Listen for unit selected signal, If player commander and not-null show.
    - [ ] Listen for unit selected signal, If player commander and null hide
    - [ ] Show abilities and portrait of selected unit
        - [ ] tooltips for ability information
    - [ ] Show AP
- [ ] BattleModal
    - [ ] Turn Start
    - [ ] BattleEndResult
- [ ] Commander
    - [ ] Keep track of selected unit
    - [ ] Keep track of selected ability
    - [ ] CommanderAI
        - [ ] If not in melee range: move toward the closest player unit
        - [ ] If in melee range: attack the player unit
    - [ ] CommanderPlayer
        - [ ] Listen for ability_selected signal
        - [ ] Listen for tile_hovered signal
        - [ ] As tiles are hovered over emit preview_execution_command
- [ ] Abilities system
    - [ ] Marry movement and ability usage
- [ ] Tiles
    - [ ] tile_hovered signal
    - [ ] tile_selected signal
    - [ ] when selected, show selected sprite
- [ ] AbilityEffects
    - [ ] DamageUnitAbilityEffect
        - [ ] UnitSwapAbilityEffect
  
[https://github.com/Screwloose-Games/dungeon-crawler-jam/issues/51](https://github.com/Screwloose-Games/dungeon-crawler-jam/issues/51)
  
- [ ] For all gameplay described, the UI should at minimum provide enough visual feedback for the player to understand game state. (hp, ap, selected unit).
    - [ ] ..
- [ ] Art assets are approximately the size they will be in final form.
    - [ ] ..
- [ ] Animations should exist in aseprite files with the correct animations and animation names. Animation length and each frame just needs to provide enough feedback to understand what is happening.
    - [ ] ..
- [ ] There is a [BattleScenario](https://www.notion.so/BattleScenario-22b16088def0804090d4dc0060165230?pvs=21)
    - [ ]
- [x] There is a Battle on a Battlefield
- [x] The battlefield has dungeon tiles on the ground
- [x] the perimeter of the battlefield is clearly defined
- [x] The Battle is based on the BattleScenario
- [x] When the [[Battle]] starts, [[BattleRound]] repeat until there is a [[BattleEndCondition]]
- [x] You can see clearly who's turn it is. (Player turn - see action panel, not player turn, no action panel)
- [x] There is a [[BattleGrid]] system consisting of [[BattleGridCell]]
- [x] There is a player character on the grid Rogue Unit
- [x] There is an enemy on the grid (skeleton)
- [x] They are about 5 units apart.
- [x] There are 2 “teams, an enemy team and a player team.
- [x] There is a [[Commander]] turn order.
- [x] Each [[Commander]] takes a turn in the turn order.
- [x] Each unit can move and/or attack(action) on their turn.
- [x] The player can click on a unit to select it.
- [x] You can see that a unit is selected.
- [x] You can see that a grid square is selected.
- [x] The player can move
- [x] While a player unit is selected, you can see where that unit could walk (`reachable grid cell`) via a green translucent overlay. `ReachableAreaPreview`
- [x] While a player unit is selected, and the players cursor is hovering over a `reachable grid cell`, the `NavigationPathPreview` (a line from the unit to the hovered tile) is shown.
- [x] While the Rogue unit is selected, the available actions for the unit are visible in the `ActionListUI`
- [x] When the player clicks the Attack "Attack" action in the action menu, the Commander UI enters "action target selection mode"attack the enemy and hurt it
- [x] While the player hovers over an action, you see an ActionTooltip that includes: description, damage.
- [x] While in "action target selection mode", you can clearly distinguish what tiles you could target highlighted in red. (similar to ReachableAreaPreview)
- [x] While in "action target selection mode", if the player hovers over a valid target, it shows a preview of the amount of damage the ability would do (-3)
- [x] The enemy can move on the grid.
- [x] AI: if not in range of attacking with the bow, the unit will go closer until they are in range.
- [x] The enemy can attack and hurt the player
- [x] The player can kill the enemy
- [x] The enemy can kill the player
- [x] Each grid square of movement uses movement points by unit_move_ap_cost
- [x] Units have a limited amount of movement points.
- [x] A unit can only move if it has enough action points
- [x] If the BattleEndCondition has been met (LastStandingBattleEndCondition) then the battle ends and the player sees clear feedback that the battle has ended (victory or defeat)