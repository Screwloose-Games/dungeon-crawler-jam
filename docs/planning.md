Game Objects:

- Player
- Enemy
  - Ghost
  - Shield
  - Sword
- Weapon
  - Types: Sword, Spear, Bow, Bomb, Shield
- Room
  - Doors:
    - UP, DOWN, LEFT, RIGHT
- Door
  - State: Open, Closed, Locked
- Collectable
  - Plasma

Components:

- HitBoxComponent2D
- HurtBoxComponent2D
- HealthComponent
- StateMachine
- PossessionComponent

Sounds:

- Possession

State Machine:

- [Guide](https://www.youtube.com/watch?v=bNdFXooM1MQ&t=352s&ab_channel=TheShaggyDev)

- Chase enemy logic
- Attack / kill

Does hopping in / out of object / hopping out more fun?


Player moves. When you press "possess" near an object. Object is controlled.
There are possessable weapons

- Sword, Spear, Bow

Sword Attack slash
Spear attack, longer ranged melee
Bow attack, ranged

