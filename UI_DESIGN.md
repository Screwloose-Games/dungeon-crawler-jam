# Dungeon Crawler Game - UI Design Document

## Overview

This document outlines the comprehensive user interface design for the dungeon crawler game, inspired by classic old-school RPGs such as Fear & Hunger, Shadow Tower, and traditional dungeon crawlers. The design emphasizes atmospheric dark fantasy aesthetics while maintaining clear usability and information hierarchy.

## Design Philosophy

### Core Principles
- **Atmospheric Immersion**: Dark, medieval fantasy aesthetic that enhances the dungeon crawler experience
- **Information Clarity**: Clear organization of complex game data (stats, inventory, equipment)
- **Nostalgic Appeal**: Classic RPG interface patterns familiar to genre veterans
- **Accessibility**: Readable text and intuitive navigation despite the dark theme

### Visual Style Guide

#### Color Palette
- **Primary Dark**: `#1a1a1a` (Deep black for backgrounds)
- **Secondary Dark**: `#2d2d2d` (Lighter black for panels)
- **Border/Frame**: `#8B4513` (Saddle brown for ornate borders)
- **Accent Gold**: `#DAA520` (Goldenrod for highlights and selections)
- **Text Primary**: `#E6E6E6` (Light gray for main text)
- **Text Secondary**: `#B0B0B0` (Medium gray for secondary text)
- **Health/Danger**: `#8B0000` (Dark red for health/damage)
- **Mana/Magic**: `#191970` (Midnight blue for magic/mana)
- **Success/Healing**: `#006400` (Dark green for healing/positive effects)

#### Typography
- **Primary Font**: Monospace font family for retro feel and alignment
- **Header Font**: Bold serif for titles and important labels
- **Body Text Size**: 14px minimum for readability
- **UI Element Text**: 12px for labels and secondary information

#### Border and Frame Design
- **Ornate Borders**: 3-5px thick frames with corner decorations
- **Panel Separators**: 1-2px lines in accent color
- **Button Borders**: Raised/inset effects using light/dark gradients

## UI Screens and Components

## 1. Main Menu

### Layout Description
- **Background**: Dark atmospheric artwork (similar to Shadow Tower title screen)
- **Title Area**: Game logo prominently displayed in upper portion
- **Menu Options**: Vertically centered list with ornate selection highlighting
- **Version Info**: Small text in bottom corner

### Menu Options
```
> New Game
  Continue
  Load Game
  Settings
  Credits
  Exit
```

### Interactive Elements
- **Selection Highlight**: Golden border around selected option
- **Hover Effects**: Subtle glow on menu items
- **Sound**: Atmospheric background music with UI sound effects

---

## 2. Character Stats Screen

### Layout Structure
```
┌─────────────────────────────────────────┐
│ CHARACTER                               │
├─────────────────┬───────────────────────┤
│ STATS           │ EQUIPMENT             │
│                 │                       │
│ Level: 12       │ Weapon: [J] Dagger    │
│ HP: 58/65       │ Shield: None          │
│ MP: 20/20       │ Armor: Linen Clothes  │
│ STR: 14         │ Accessory: Gemstone   │
│ DEX: 11         │                       │
│ INT: 8          │ Misc.                 │
│ CON: 13         │                       │
│                 │                       │
├─────────────────┴───────────────────────┤
│ STATUS EFFECTS                          │
│ [None currently active]                 │
└─────────────────────────────────────────┘
```

### Panel Details
- **Stats Panel**: Left side with core character attributes
- **Equipment Panel**: Right side showing equipped items with hotkey indicators
- **Status Panel**: Bottom section for active buffs/debuffs
- **Background**: Semi-transparent dark panel with ornate borders

---

## 3. Inventory Interface

### Layout Design
```
┌─────────────────────────────────────────┐
│ INVENTORY                     Weight    │
├─────────────────────────────────────────┤
│ USE ITEM                               │
│                                         │
│ 🔥 TORCH                           1    │
│ 🧪 HEALING POTION                  7    │
│ ⚗️ ANTI-VENOM                      2    │
│ 💀 DORADO'S ASHES                  1    │
│                                         │
│ RECOVERS ALL HP                         │
├─────────────────────────────────────────┤
│ [Use] [Drop] [Examine] [Cancel]         │
└─────────────────────────────────────────┘
```

### Features
- **Item Icons**: Simple ASCII or Unicode symbols for item types
- **Quantity Display**: Numbers on the right showing item counts
- **Item Description**: Bottom area showing details of selected item
- **Action Buttons**: Context-sensitive commands at bottom
- **Weight System**: Optional encumbrance tracking

### Item Categories
- **Consumables**: Potions, food, scrolls
- **Equipment**: Weapons, armor, accessories
- **Key Items**: Quest items, tools, special objects
- **Materials**: Crafting components, currency

---

## 4. Combat Interface

### Battle Screen Layout
```
┌─────────────────────────────────────────┐
│ Shadow Wraith                  HP: ▓▓▓░ │
├─────────────────────────────────────────┤
│                                         │
│    [Enemy Sprite/Animation Area]        │
│                                         │
├─────────────────────────────────────────┤
│ Player                         HP: ▓▓▓▓ │
│                                MP: ▓▓░░ │
├─────────────────────────────────────────┤
│ > Attack                                │
│   Magic                                 │
│   Items                                 │
│   Defend                                │
│   Flee                                  │
└─────────────────────────────────────────┘
```

### Combat Elements
- **Enemy Status**: Top panel with name and health bar
- **Battle Area**: Central space for combat animations/sprites
- **Player Status**: Character health and mana with visual bars
- **Action Menu**: Bottom panel with combat options
- **Turn Indicator**: Visual feedback for whose turn it is

### Status Bar Design
- **Health Bars**: Red blocks (▓) for current health, gray (░) for missing
- **Magic Bars**: Blue blocks for mana/spell points
- **Status Effects**: Small icons near character names

---

## 5. Dialogue System

### Conversation Interface
```
┌─────────────────────────────────────────┐
│ [Character Portrait/Location Image]     │
├─────────────────────────────────────────┤
│ You were born with the soul of the      │
│ endless that makes you yearn for        │
│ adventure beyond the mortal realm...    │
│                                         │
├─────────────────────────────────────────┤
│ > Continue                              │
│   Ask about the prophecy                │
│   [Leave conversation]                  │
└─────────────────────────────────────────┘
```

### Dialogue Features
- **Text Area**: Large panel for story text and dialogue
- **Portrait Area**: Optional character/scene images
- **Choice Selection**: Multiple dialogue options with clear selection
- **Text Speed**: Configurable text reveal speed
- **Skip Option**: Ability to fast-forward through text

---

## 6. In-Game HUD

### Overlay Elements
```
┌─ Status ─────────────────────────────────┐
│ HP: ▓▓▓▓░░ 24/30                        │
│ MP: ▓▓░░░░ 8/25                         │
│ Level: 5    Gold: 127                   │
└─────────────────────────────────────────┘

                MAP AREA

┌─ Quick Items ───────────────────────────┐
│ [1] Torch  [2] Potion  [3] Key          │
└─────────────────────────────────────────┘
```

### HUD Components
- **Status Window**: Always visible character vital signs
- **Quick Items**: Hotkey accessible items (1-9 keys)
- **Minimap**: Optional small map in corner
- **Message Log**: Recent game messages and notifications

---

## 7. Settings Menu

### Options Layout
```
┌─────────────────────────────────────────┐
│ SETTINGS                                │
├─────────────────────────────────────────┤
│ Audio                                   │
│   Master Volume    [████████░░] 80%     │
│   Music Volume     [██████░░░░] 60%     │
│   Sound FX         [█████████░] 90%     │
│                                         │
│ Display                                 │
│   Resolution       [1024x768    ▼]     │
│   Fullscreen       [✓] On              │
│   UI Scale         [██████░░░░] 60%     │
│                                         │
│ Controls                                │
│   [Customize Key Bindings]              │
│                                         │
├─────────────────────────────────────────┤
│ [Apply] [Cancel] [Reset to Defaults]    │
└─────────────────────────────────────────┘
```

### Settings Categories
- **Audio Settings**: Volume controls with visual sliders
- **Display Options**: Resolution, fullscreen, UI scaling
- **Control Configuration**: Key binding customization
- **Gameplay Options**: Difficulty, auto-save, text speed

---

## 8. Map/Journal Interface

### Map Screen
```
┌─────────────────────────────────────────┐
│ DUNGEON MAP - Level 1                   │
├─────────────────────────────────────────┤
│ ┌─┐ ┌─┬─┐     ┌─┐                      │
│ │ │ │ │ │     │?│                      │
│ │ └─┘ │ └─┬─┬─┘ │                      │
│ │       │   │   │                      │
│ └───────┘   └─●─┘                      │
│                                         │
│ ● Current Location                      │
│ ? Unexplored Area                       │
│ ┌─┐ Explored Rooms                      │
├─────────────────────────────────────────┤
│ [Journal] [Quest Log] [Close]           │
└─────────────────────────────────────────┘
```

### Navigation Features
- **Auto-mapping**: Rooms revealed as player explores
- **Legend**: Clear symbols for different map elements
- **Notes**: Player can add custom markers and notes
- **Quest Integration**: Quest objectives marked on map

## Technical Implementation Notes

### Responsive Design
- **Scalable UI**: All elements scale with resolution/UI scale setting
- **Minimum Size**: 800x600 resolution support
- **Aspect Ratios**: Support for 4:3, 16:9, and 16:10 displays

### Accessibility Features
- **High Contrast**: Option for higher contrast text/backgrounds
- **Font Scaling**: Separate font size controls
- **Color Blind Support**: Alternative color schemes
- **Keyboard Navigation**: Full keyboard control support

### Performance Considerations
- **Static Backgrounds**: Pre-rendered UI backgrounds to reduce draw calls
- **Texture Atlasing**: UI elements combined into texture atlases
- **Minimal Animations**: Subtle effects that don't impact performance
- **Caching**: UI layouts cached and reused when possible

## Asset Requirements

### Graphics Assets Needed
- **Border Textures**: Ornate frame designs in various sizes
- **Button States**: Normal, hover, pressed, disabled states
- **Icon Set**: Complete set of item, status, and UI icons
- **Background Textures**: Panel backgrounds and atmospheric images
- **Font Files**: Monospace and serif fonts for different UI elements

### Audio Assets
- **UI Sounds**: Menu navigation, selection, error sounds
- **Ambient**: Background music for different game states
- **Feedback**: Audio cues for important actions and events

This design document provides a comprehensive foundation for implementing a cohesive, atmospheric UI that captures the essence of classic dungeon crawler RPGs while maintaining modern usability standards.