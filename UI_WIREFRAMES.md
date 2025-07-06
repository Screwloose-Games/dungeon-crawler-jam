# Wireframes and Screen Layouts

## Screen Flow Diagram

```
[Title Screen] 
      │
      ▼
[Main Menu] ◄─────────────────┐
      │                      │
      ▼                      │
[Character Creation]         │
      │                      │
      ▼                      │
[Game World] ◄──────────┐    │
      │                 │    │
      ├─► [Inventory]───┘    │
      ├─► [Character Stats]  │
      ├─► [Map/Journal]      │
      ├─► [Settings] ────────┘
      └─► [Combat Screen]
```

## Detailed Wireframes

### 1. Main Menu Screen (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ████████  ████████  ███     ███  ████████                    │
│  ██         ██    ██  ████   ████  ██                          │
│  ██  ████   ██████    ██ ██ ██ ██  ████████                    │
│  ██    ██   ██    ██  ██  ███  ██  ██                          │
│  ████████   ██    ██  ██   █   ██  ████████                    │
│                                                                │
│                        TITLE                                   │
│                                                                │
│                    ┌─────────────┐                            │
│                    │ > NEW GAME  │ ◄── Golden highlight        │
│                    │   CONTINUE  │                            │
│                    │   LOAD GAME │                            │
│                    │   SETTINGS  │                            │
│                    │   CREDITS   │                            │
│                    │   EXIT      │                            │
│                    └─────────────┘                            │
│                                                                │
│                                                                │
│  [Background: Dark atmospheric artwork]                       │
│                                                                │
│                                     Version 1.0.0             │
└────────────────────────────────────────────────────────────────┘
```

### 2. Character Stats Screen (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ CHARACTER INFORMATION                                      ║ │
│ ╠═══════════════════════════╦════════════════════════════════╣ │
│ ║ ATTRIBUTES                ║ EQUIPMENT                      ║ │
│ ║                           ║                                ║ │
│ ║ Name: Adventurer          ║ Weapon:    [J] Iron Dagger     ║ │
│ ║ Level: 5        XP: 234   ║ Shield:    None                ║ │
│ ║                           ║ Helmet:    Leather Cap         ║ │
│ ║ HP: ████████░░ 24/30      ║ Armor:     Linen Robes         ║ │
│ ║ MP: ████░░░░░░ 12/30      ║ Gloves:    None                ║ │
│ ║                           ║ Boots:     Worn Boots          ║ │
│ ║ Strength:     12          ║ Ring:      None                ║ │
│ ║ Dexterity:    14          ║ Amulet:    Luck Charm          ║ │
│ ║ Intelligence: 8           ║                                ║ │
│ ║ Constitution: 11          ║ Attack:    7  (5 + 2)          ║ │
│ ║ Luck:         9           ║ Defense:   4  (2 + 2)          ║ │
│ ║                           ║ Magic Att: 3                   ║ │
│ ║                           ║ Magic Def: 2                   ║ │
│ ╠═══════════════════════════╩════════════════════════════════╣ │
│ ║ STATUS EFFECTS                                             ║ │
│ ║ [Currently none active]                                    ║ │
│ ║                                                            ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│ [TAB] Equipment  [I] Inventory  [M] Map  [ESC] Close          │
└────────────────────────────────────────────────────────────────┘
```

### 3. Inventory Screen (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ INVENTORY                              Weight: 15/50       ║ │
│ ╠════════════════════════════════════════════════════════════╣ │
│ ║ ITEMS                                                      ║ │
│ ║                                                            ║ │
│ ║ ┌────────────────────────────────────────────────────────┐ ║ │
│ ║ │ > 🗡️ Iron Dagger             [Equipped]           1 │ ║ │
│ ║ │   🧪 Health Potion           Restores 20 HP        3 │ ║ │
│ ║ │   🔥 Torch                   Provides light        5 │ ║ │
│ ║ │   🗝️ Rusty Key               Opens doors           1 │ ║ │
│ ║ │   💰 Gold Coins              Currency              47 │ ║ │
│ ║ │   📜 Scroll of Fireball      Magic spell           1 │ ║ │
│ ║ │   🍞 Bread                   Restores 5 HP         2 │ ║ │
│ ║ │   💎 Ruby Gem                Valuable item         1 │ ║ │
│ ║ └────────────────────────────────────────────────────────┘ ║ │
│ ║                                                            ║ │
│ ║ ITEM DETAILS                                               ║ │
│ ║ ┌────────────────────────────────────────────────────────┐ ║ │
│ ║ │ Iron Dagger                                            │ ║ │
│ ║ │ A simple but effective blade forged from iron.        │ ║ │
│ ║ │ Attack Power: +2                                       │ ║ │
│ ║ │ Durability: 45/50                                      │ ║ │
│ ║ │ Weight: 1                                              │ ║ │
│ ║ └────────────────────────────────────────────────────────┘ ║ │
│ ║                                                            ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│ [U] Use  [D] Drop  [E] Equip  [X] Examine  [ESC] Close        │
└────────────────────────────────────────────────────────────────┘
```

### 4. Combat Screen (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ SHADOW GOBLIN                          HP: ████░░░░░░       ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│                        👹                                     │
│                   [Enemy Sprite]                              │
│                                                                │
│                        ⚔️                                     │
│                   [Combat Action]                             │
│                                                                │
│                        🧙                                     │
│                   [Player Sprite]                             │
│                                                                │
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ ADVENTURER                    HP: ████████░░ 24/30         ║ │
│ ║                               MP: ████░░░░░░ 12/30         ║ │
│ ╠════════════════════════════════════════════════════════════╣ │
│ ║ COMBAT ACTIONS                                             ║ │
│ ║                                                            ║ │
│ ║ > ATTACK        Strike with equipped weapon                ║ │
│ ║   MAGIC         Cast a spell                               ║ │
│ ║   ITEMS         Use an item from inventory                 ║ │
│ ║   DEFEND        Reduce incoming damage                     ║ │
│ ║   FLEE          Attempt to escape                          ║ │
│ ║                                                            ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│ [ENTER] Select  [↑↓] Navigate  [ESC] Menu                     │
└────────────────────────────────────────────────────────────────┘
```

### 5. Map/Journal Screen (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ MAP & JOURNAL                                              ║ │
│ ╠════════════════════════════╦═══════════════════════════════╣ │
│ ║ DUNGEON MAP - FLOOR 1      ║ QUEST LOG                     ║ │
│ ║                            ║                               ║ │
│ ║ ┌─┐ ┌─┬─┐     ┌─┐          ║ Active Quests:                ║ │
│ ║ │S│ │ │ │     │?│          ║                               ║ │
│ ║ │ └─┘ │ └─┬─┬─┘ │          ║ • Find the Ancient Key       ║ │
│ ║ │     │   │T│   │          ║   Progress: 1/3 fragments    ║ │
│ ║ └─────┘   └─●─┬─┘          ║                               ║ │
│ ║             │E│            ║ • Defeat the Goblin Chief    ║ │
│ ║             └─┘            ║   Status: In Progress        ║ │
│ ║                            ║                               ║ │
│ ║ Legend:                    ║ Completed Quests:            ║ │
│ ║ ● Current Position         ║                               ║ │
│ ║ S Starting Room            ║ • Rescue the Merchant        ║ │
│ ║ T Treasure Found           ║ • Clear the Upper Chambers   ║ │
│ ║ E Exit/Stairs              ║                               ║ │
│ ║ ? Unexplored               ║                               ║ │
│ ║                            ║                               ║ │
│ ╠════════════════════════════╩═══════════════════════════════╣ │
│ ║ NOTES                                                      ║ │
│ ║ • Strange markings on the wall in the eastern chamber     ║ │
│ ║ • Heard goblin voices from the north passage              ║ │
│ ║ • Merchant mentioned a secret door behind the altar       ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│ [TAB] Toggle Views  [N] Add Note  [ESC] Close                 │
└────────────────────────────────────────────────────────────────┘
```

### 6. Settings Menu (1024x768)

```
┌────────────────────────────────────────────────────────────────┐
│ ╔════════════════════════════════════════════════════════════╗ │
│ ║ SETTINGS                                                   ║ │
│ ╠════════════════════════════════════════════════════════════╣ │
│ ║                                                            ║ │
│ ║ AUDIO                                                      ║ │
│ ║ ┌────────────────────────────────────────────────────────┐ ║ │
│ ║ │ Master Volume     [████████░░] 80%                     │ ║ │
│ ║ │ Music Volume      [██████░░░░] 60%                     │ ║ │
│ ║ │ Sound Effects     [█████████░] 90%                     │ ║ │
│ ║ └────────────────────────────────────────────────────────┘ ║ │
│ ║                                                            ║ │
│ ║ DISPLAY                                                    ║ │
│ ║ ┌────────────────────────────────────────────────────────┐ ║ │
│ ║ │ Resolution        [1024x768     ▼]                     │ ║ │
│ ║ │ Fullscreen        [✓] Enabled                          │ ║ │
│ ║ │ UI Scale          [███████░░░] 70%                     │ ║ │
│ ║ │ Show FPS          [ ] Disabled                         │ ║ │
│ ║ └────────────────────────────────────────────────────────┘ ║ │
│ ║                                                            ║ │
│ ║ GAMEPLAY                                                   ║ │
│ ║ ┌────────────────────────────────────────────────────────┐ ║ │
│ ║ │ Difficulty        [Normal      ▼]                      │ ║ │
│ ║ │ Auto-Save         [✓] Enabled                          │ ║ │
│ ║ │ Text Speed        [██████░░░░] 60%                     │ ║ │
│ ║ │ Combat Animation  [✓] Enabled                          │ ║ │
│ ║ └────────────────────────────────────────────────────────┘ ║ │
│ ║                                                            ║ │
│ ╚════════════════════════════════════════════════════════════╝ │
│                                                                │
│ [APPLY] [CANCEL] [RESET TO DEFAULTS] [ESC] Close              │
└────────────────────────────────────────────────────────────────┘
```

### 7. In-Game HUD Overlay

```
┌────────────────────────────────────────────────────────────────┐
│ ┌─ Status ──────────────┐                                      │
│ │ HP: ████████░░ 24/30  │    [GAME WORLD VIEW]                │
│ │ MP: ████░░░░░░ 12/30  │                                      │
│ │ Level: 5   XP: 234    │    Player character moves around    │
│ │ Gold: 127             │    dungeon environments here        │
│ └───────────────────────┘                                      │
│                                                                │
│                           ┌─ Mini Map ─┐                      │
│                           │ ┌─┐ ┌─┐    │                      │
│                           │ │ └─┘ │    │                      │
│                           │ │  ●  │    │                      │
│                           │ └─────┘    │                      │
│                           └────────────┘                      │
│                                                                │
│                                                                │
│                                                                │
│                                                                │
│ ┌─ Quick Items ─────────────────────────────────────────────┐ │
│ │ [1] Torch  [2] Health Potion  [3] Key  [4] Scroll       │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                │
│ ┌─ Message Log ─────────────────────────────────────────────┐ │
│ │ > You entered a dark chamber.                            │ │
│ │ > You found 15 gold coins.                               │ │
│ │ > A goblin blocks your path!                             │ │
│ └──────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────┘
```

## Responsive Design Breakpoints

### Mobile/Small Screens (320px - 768px)

- Stack panels vertically
- Reduce padding and margins
- Larger touch targets (minimum 44px)
- Simplified navigation with hamburger menu
- Single column layouts

### Tablet/Medium Screens (768px - 1024px)

- Two-column layouts where appropriate
- Maintain most desktop features
- Touch-friendly interface elements
- Optimized for both portrait and landscape

### Desktop/Large Screens (1024px+)

- Full feature set with multiple panels
- Keyboard shortcuts visible
- Dense information display
- Multi-column layouts

## Accessibility Considerations

### Visual Accessibility

- High contrast borders and text
- Clear focus indicators for keyboard navigation
- Scalable UI elements
- Color blind friendly palette alternatives

### Motor Accessibility

- Large click targets (minimum 24px)
- Keyboard alternatives for all mouse actions
- Customizable key bindings
- Reduced motion options

### Cognitive Accessibility

- Clear information hierarchy
- Consistent navigation patterns
- Helpful tooltips and descriptions
- Undo/confirm for destructive actions

This wireframe document provides the visual foundation for implementing the UI design, ensuring consistent layouts and user experience across all game screens.