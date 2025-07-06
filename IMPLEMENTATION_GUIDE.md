# Implementation Guide

## Overview

This guide provides technical implementation details for bringing the dungeon crawler UI design to life. It covers technology recommendations, file structure, state management, and integration patterns.

## Technology Stack Recommendations

### Option 1: HTML5/CSS3/JavaScript (Web-based)
**Best for**: Cross-platform deployment, rapid prototyping
```
├── HTML5 Canvas or WebGL for game rendering
├── CSS3 for UI styling and animations
├── JavaScript/TypeScript for game logic
├── Web Components for reusable UI elements
└── Local Storage for save data
```

### Option 2: Unity Engine
**Best for**: Rich graphics, built-in UI system
```
├── Unity UI (uGUI) system
├── TextMeshPro for text rendering
├── Scriptable Objects for data management
├── Unity Input System for controls
└── JSON for save data serialization
```

### Option 3: Godot Engine
**Best for**: Open source, lightweight, good 2D support
```
├── Godot's Control nodes for UI
├── Themes and StyleBoxes for consistent styling
├── GDScript or C# for game logic
├── Scenes for modular UI components
└── ConfigFile for settings management
```

## File Structure

### Recommended Project Organization
```
project/
├── assets/
│   ├── ui/
│   │   ├── fonts/
│   │   │   ├── monospace.ttf
│   │   │   └── serif-bold.ttf
│   │   ├── textures/
│   │   │   ├── panel-border.png
│   │   │   ├── button-normal.png
│   │   │   ├── button-hover.png
│   │   │   └── button-pressed.png
│   │   ├── icons/
│   │   │   ├── items/
│   │   │   ├── status/
│   │   │   └── ui/
│   │   └── audio/
│   │       ├── ui-sounds/
│   │       └── music/
├── src/
│   ├── ui/
│   │   ├── components/
│   │   │   ├── Panel.js
│   │   │   ├── Button.js
│   │   │   ├── ProgressBar.js
│   │   │   ├── List.js
│   │   │   └── Modal.js
│   │   ├── screens/
│   │   │   ├── MainMenu.js
│   │   │   ├── CharacterStats.js
│   │   │   ├── Inventory.js
│   │   │   ├── Combat.js
│   │   │   └── Settings.js
│   │   ├── managers/
│   │   │   ├── UIManager.js
│   │   │   ├── InputManager.js
│   │   │   └── AudioManager.js
│   │   └── styles/
│   │       ├── base.css
│   │       ├── components.css
│   │       └── themes.css
│   ├── game/
│   │   ├── entities/
│   │   ├── systems/
│   │   └── data/
│   └── core/
│       ├── GameState.js
│       ├── SaveManager.js
│       └── EventSystem.js
└── docs/
    ├── UI_DESIGN.md
    ├── UI_COMPONENTS.md
    ├── UI_WIREFRAMES.md
    └── IMPLEMENTATION.md
```

## State Management

### Game State Structure
```javascript
const GameState = {
  // UI State
  ui: {
    currentScreen: 'mainMenu', // mainMenu, game, inventory, etc.
    modalStack: [],
    inputMode: 'keyboard', // keyboard, mouse, gamepad
    settings: {
      masterVolume: 0.8,
      musicVolume: 0.6,
      sfxVolume: 0.9,
      resolution: '1024x768',
      fullscreen: true,
      uiScale: 0.7
    }
  },
  
  // Player State
  player: {
    name: 'Adventurer',
    level: 5,
    experience: 234,
    health: { current: 24, max: 30 },
    mana: { current: 12, max: 30 },
    attributes: {
      strength: 12,
      dexterity: 14,
      intelligence: 8,
      constitution: 11,
      luck: 9
    },
    equipment: {
      weapon: { id: 'iron_dagger', name: 'Iron Dagger' },
      shield: null,
      helmet: { id: 'leather_cap', name: 'Leather Cap' },
      armor: { id: 'linen_robes', name: 'Linen Robes' },
      gloves: null,
      boots: { id: 'worn_boots', name: 'Worn Boots' },
      ring: null,
      amulet: { id: 'luck_charm', name: 'Luck Charm' }
    },
    inventory: [
      { id: 'health_potion', quantity: 3 },
      { id: 'torch', quantity: 5 },
      { id: 'rusty_key', quantity: 1 },
      { id: 'gold_coins', quantity: 47 }
    ],
    statusEffects: []
  },
  
  // Game World State
  world: {
    currentLevel: 'dungeon_floor_1',
    playerPosition: { x: 5, y: 3 },
    mapData: {
      explored: new Set(['5,3', '4,3', '5,2']),
      rooms: new Map(),
      treasures: new Set(),
      enemies: new Map()
    }
  },
  
  // Combat State
  combat: {
    active: false,
    enemies: [],
    turnOrder: [],
    currentTurn: 0,
    selectedAction: null
  }
};
```

### Event System Implementation
```javascript
class EventSystem {
  constructor() {
    this.listeners = new Map();
  }
  
  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event).push(callback);
  }
  
  emit(event, data) {
    if (this.listeners.has(event)) {
      this.listeners.get(event).forEach(callback => callback(data));
    }
  }
  
  off(event, callback) {
    if (this.listeners.has(event)) {
      const callbacks = this.listeners.get(event);
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }
}

// Usage examples
const events = new EventSystem();

// UI updates based on game state changes
events.on('player:healthChanged', (data) => {
  updateHealthBar(data.current, data.max);
});

events.on('inventory:itemAdded', (item) => {
  showNotification(`Found ${item.name}!`);
  refreshInventoryDisplay();
});

events.on('combat:started', (enemies) => {
  showCombatScreen(enemies);
});
```

## Component Implementation Examples

### Panel Component (JavaScript)
```javascript
class Panel {
  constructor(options = {}) {
    this.element = document.createElement('div');
    this.element.className = 'ui-panel';
    
    if (options.header) {
      this.createHeader(options.header);
    }
    
    if (options.className) {
      this.element.classList.add(options.className);
    }
    
    this.contentArea = document.createElement('div');
    this.contentArea.className = 'ui-panel-content';
    this.element.appendChild(this.contentArea);
  }
  
  createHeader(text) {
    const header = document.createElement('div');
    header.className = 'ui-panel-header';
    header.textContent = text;
    this.element.appendChild(header);
  }
  
  setContent(content) {
    this.contentArea.innerHTML = '';
    if (typeof content === 'string') {
      this.contentArea.innerHTML = content;
    } else {
      this.contentArea.appendChild(content);
    }
  }
  
  show() {
    this.element.style.display = 'block';
  }
  
  hide() {
    this.element.style.display = 'none';
  }
  
  destroy() {
    if (this.element.parentNode) {
      this.element.parentNode.removeChild(this.element);
    }
  }
}
```

### Progress Bar Component
```javascript
class ProgressBar {
  constructor(options = {}) {
    this.element = document.createElement('div');
    this.element.className = 'ui-progress-bar';
    
    this.fill = document.createElement('div');
    this.fill.className = 'ui-progress-fill';
    this.element.appendChild(this.fill);
    
    this.text = document.createElement('span');
    this.text.className = 'ui-progress-text';
    this.element.appendChild(this.text);
    
    this.min = options.min || 0;
    this.max = options.max || 100;
    this.current = options.current || 0;
    this.format = options.format || '{current}/{max}';
    this.colorClass = options.colorClass || 'health';
    
    this.fill.classList.add(this.colorClass);
    this.update();
  }
  
  setValue(current, max = null) {
    this.current = current;
    if (max !== null) {
      this.max = max;
    }
    this.update();
  }
  
  update() {
    const percentage = ((this.current - this.min) / (this.max - this.min)) * 100;
    this.fill.style.width = `${Math.max(0, Math.min(100, percentage))}%`;
    
    const text = this.format
      .replace('{current}', this.current)
      .replace('{max}', this.max)
      .replace('{percentage}', Math.round(percentage));
    
    this.text.textContent = text;
  }
  
  animateChange(newValue, duration = 300) {
    const startValue = this.current;
    const startTime = Date.now();
    
    const animate = () => {
      const elapsed = Date.now() - startTime;
      const progress = Math.min(elapsed / duration, 1);
      
      const currentValue = startValue + (newValue - startValue) * progress;
      this.setValue(Math.round(currentValue));
      
      if (progress < 1) {
        requestAnimationFrame(animate);
      }
    };
    
    animate();
  }
}
```

### Screen Manager Implementation
```javascript
class ScreenManager {
  constructor() {
    this.screens = new Map();
    this.screenStack = [];
    this.currentScreen = null;
    this.container = document.getElementById('screen-container');
  }
  
  registerScreen(name, screenClass) {
    this.screens.set(name, screenClass);
  }
  
  showScreen(name, data = {}) {
    // Hide current screen
    if (this.currentScreen) {
      this.currentScreen.hide();
    }
    
    // Create or reuse screen instance
    let screen = this.screens.get(name);
    if (typeof screen === 'function') {
      screen = new screen();
      this.screens.set(name, screen);
    }
    
    // Show new screen
    this.currentScreen = screen;
    this.container.appendChild(screen.element);
    screen.show(data);
    
    // Update screen stack for back navigation
    this.screenStack.push(name);
  }
  
  goBack() {
    if (this.screenStack.length > 1) {
      this.screenStack.pop(); // Remove current
      const previousScreen = this.screenStack.pop(); // Get previous
      this.showScreen(previousScreen);
    }
  }
  
  showModal(modalClass, data = {}) {
    const modal = new modalClass();
    modal.show(data);
    
    // Add close handler
    modal.onClose = () => {
      modal.destroy();
    };
    
    document.body.appendChild(modal.element);
    return modal;
  }
}

// Screen base class
class Screen {
  constructor() {
    this.element = document.createElement('div');
    this.element.className = 'screen';
    this.isVisible = false;
  }
  
  show(data = {}) {
    this.isVisible = true;
    this.element.style.display = 'block';
    this.onShow(data);
  }
  
  hide() {
    this.isVisible = false;
    this.element.style.display = 'none';
    this.onHide();
  }
  
  onShow(data) {
    // Override in subclasses
  }
  
  onHide() {
    // Override in subclasses
  }
  
  destroy() {
    if (this.element.parentNode) {
      this.element.parentNode.removeChild(this.element);
    }
  }
}
```

## Input Handling

### Keyboard Navigation System
```javascript
class InputManager {
  constructor() {
    this.keyBindings = new Map();
    this.inputModes = ['keyboard', 'mouse', 'gamepad'];
    this.currentMode = 'keyboard';
    this.focusStack = [];
    
    this.setupEventListeners();
    this.loadKeyBindings();
  }
  
  setupEventListeners() {
    document.addEventListener('keydown', this.handleKeyDown.bind(this));
    document.addEventListener('mousemove', this.handleMouseMove.bind(this));
    document.addEventListener('gamepadconnected', this.handleGamepadConnect.bind(this));
  }
  
  handleKeyDown(event) {
    this.setInputMode('keyboard');
    
    const action = this.keyBindings.get(event.code);
    if (action) {
      event.preventDefault();
      this.executeAction(action);
    }
  }
  
  setInputMode(mode) {
    if (this.currentMode !== mode) {
      this.currentMode = mode;
      document.body.className = `input-mode-${mode}`;
      events.emit('input:modeChanged', mode);
    }
  }
  
  executeAction(action) {
    events.emit(`input:${action}`);
  }
  
  loadKeyBindings() {
    // Default key bindings
    this.keyBindings.set('Escape', 'menu');
    this.keyBindings.set('KeyI', 'inventory');
    this.keyBindings.set('KeyC', 'character');
    this.keyBindings.set('KeyM', 'map');
    this.keyBindings.set('ArrowUp', 'navigateUp');
    this.keyBindings.set('ArrowDown', 'navigateDown');
    this.keyBindings.set('ArrowLeft', 'navigateLeft');
    this.keyBindings.set('ArrowRight', 'navigateRight');
    this.keyBindings.set('Enter', 'confirm');
    this.keyBindings.set('Space', 'confirm');
    this.keyBindings.set('Digit1', 'quickItem1');
    this.keyBindings.set('Digit2', 'quickItem2');
    // ... more bindings
  }
  
  setKeyBinding(action, keyCode) {
    // Remove old binding
    for (const [key, value] of this.keyBindings) {
      if (value === action) {
        this.keyBindings.delete(key);
        break;
      }
    }
    
    // Set new binding
    this.keyBindings.set(keyCode, action);
    this.saveKeyBindings();
  }
}
```

## Data Management

### Save System Implementation
```javascript
class SaveManager {
  constructor() {
    this.saveSlots = 3;
    this.autoSaveInterval = 30000; // 30 seconds
    this.compressionEnabled = true;
  }
  
  saveGame(slot = 'auto') {
    try {
      const saveData = {
        version: '1.0.0',
        timestamp: Date.now(),
        gameState: this.serializeGameState(),
        playTime: this.getPlayTime(),
        checksum: null
      };
      
      saveData.checksum = this.calculateChecksum(saveData);
      
      const serialized = JSON.stringify(saveData);
      const compressed = this.compressionEnabled ? 
        this.compress(serialized) : serialized;
      
      localStorage.setItem(`save_${slot}`, compressed);
      
      events.emit('save:completed', { slot, timestamp: saveData.timestamp });
      return true;
    } catch (error) {
      console.error('Save failed:', error);
      events.emit('save:failed', { slot, error });
      return false;
    }
  }
  
  loadGame(slot) {
    try {
      const data = localStorage.getItem(`save_${slot}`);
      if (!data) {
        return null;
      }
      
      const decompressed = this.compressionEnabled ? 
        this.decompress(data) : data;
      
      const saveData = JSON.parse(decompressed);
      
      // Verify checksum
      const storedChecksum = saveData.checksum;
      saveData.checksum = null;
      const calculatedChecksum = this.calculateChecksum(saveData);
      
      if (storedChecksum !== calculatedChecksum) {
        throw new Error('Save file corrupted');
      }
      
      this.deserializeGameState(saveData.gameState);
      events.emit('load:completed', { slot });
      return saveData;
    } catch (error) {
      console.error('Load failed:', error);
      events.emit('load:failed', { slot, error });
      return null;
    }
  }
  
  serializeGameState() {
    // Deep clone and serialize current game state
    return JSON.parse(JSON.stringify(GameState));
  }
  
  deserializeGameState(data) {
    // Restore game state from save data
    Object.assign(GameState, data);
    events.emit('gameState:restored');
  }
  
  calculateChecksum(data) {
    // Simple checksum implementation
    const str = JSON.stringify(data);
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.toString(16);
  }
}
```

## Performance Optimization

### UI Rendering Optimization
```javascript
class UIRenderer {
  constructor() {
    this.dirtyComponents = new Set();
    this.renderQueue = [];
    this.isRendering = false;
  }
  
  markDirty(component) {
    this.dirtyComponents.add(component);
    this.scheduleRender();
  }
  
  scheduleRender() {
    if (!this.isRendering) {
      this.isRendering = true;
      requestAnimationFrame(() => this.render());
    }
  }
  
  render() {
    // Process dirty components
    for (const component of this.dirtyComponents) {
      if (component.isVisible) {
        component.updateDisplay();
      }
    }
    
    this.dirtyComponents.clear();
    this.isRendering = false;
  }
  
  // Object pooling for frequently created UI elements
  getPooledElement(type) {
    const pool = this.pools.get(type) || [];
    if (pool.length > 0) {
      return pool.pop();
    }
    return this.createElement(type);
  }
  
  returnToPool(element, type) {
    element.reset();
    const pool = this.pools.get(type) || [];
    pool.push(element);
    this.pools.set(type, pool);
  }
}
```

## Testing Guidelines

### Unit Tests for UI Components
```javascript
// Example test for ProgressBar component
describe('ProgressBar', () => {
  let progressBar;
  
  beforeEach(() => {
    progressBar = new ProgressBar({
      min: 0,
      max: 100,
      current: 50
    });
  });
  
  test('should display correct percentage', () => {
    expect(progressBar.fill.style.width).toBe('50%');
  });
  
  test('should update text correctly', () => {
    expect(progressBar.text.textContent).toBe('50/100');
  });
  
  test('should handle edge cases', () => {
    progressBar.setValue(-10);
    expect(progressBar.fill.style.width).toBe('0%');
    
    progressBar.setValue(150);
    expect(progressBar.fill.style.width).toBe('100%');
  });
});
```

### Integration Tests
```javascript
describe('Screen Navigation', () => {
  let screenManager;
  
  beforeEach(() => {
    screenManager = new ScreenManager();
    screenManager.registerScreen('main', MainMenuScreen);
    screenManager.registerScreen('inventory', InventoryScreen);
  });
  
  test('should navigate between screens', () => {
    screenManager.showScreen('main');
    expect(screenManager.currentScreen).toBeInstanceOf(MainMenuScreen);
    
    screenManager.showScreen('inventory');
    expect(screenManager.currentScreen).toBeInstanceOf(InventoryScreen);
  });
  
  test('should handle back navigation', () => {
    screenManager.showScreen('main');
    screenManager.showScreen('inventory');
    screenManager.goBack();
    
    expect(screenManager.currentScreen).toBeInstanceOf(MainMenuScreen);
  });
});
```

This implementation guide provides the technical foundation needed to transform the UI design into a working game interface, with considerations for maintainability, performance, and user experience.