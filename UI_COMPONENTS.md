# UI Component Library

## Reusable UI Components

This document defines the reusable UI components that form the building blocks of the dungeon crawler interface.

## Base Components

### 1. Panel Component

**Purpose**: Standard container for all UI content areas

**Styling**:
```css
.ui-panel {
  background: #2d2d2d;
  border: 3px solid #8B4513;
  border-radius: 4px;
  padding: 8px;
  box-shadow: inset 0 0 10px rgba(0,0,0,0.5);
}

.ui-panel-header {
  background: #8B4513;
  color: #E6E6E6;
  text-align: center;
  font-weight: bold;
  padding: 4px;
  margin: -8px -8px 8px -8px;
}
```

**Variants**:
- `ui-panel-large`: For main content areas
- `ui-panel-small`: For status indicators
- `ui-panel-overlay`: For modal dialogs

### 2. Button Component

**Purpose**: Interactive elements for user actions

**States and Styling**:
```css
.ui-button {
  background: linear-gradient(#4a4a4a, #2d2d2d);
  border: 2px solid #8B4513;
  color: #E6E6E6;
  padding: 6px 12px;
  cursor: pointer;
  font-family: monospace;
}

.ui-button:hover {
  background: linear-gradient(#5a5a5a, #3d3d3d);
  border-color: #DAA520;
}

.ui-button:active {
  background: linear-gradient(#2d2d2d, #4a4a4a);
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.3);
}

.ui-button:disabled {
  background: #1a1a1a;
  border-color: #555;
  color: #666;
  cursor: not-allowed;
}
```

**Variants**:
- `ui-button-primary`: For main actions (golden highlights)
- `ui-button-danger`: For destructive actions (red highlights)
- `ui-button-small`: Compact size for secondary actions

### 3. Progress Bar Component

**Purpose**: Visual representation of numeric values (health, mana, experience)

**HTML Structure**:
```html
<div class="ui-progress-bar">
  <div class="ui-progress-fill" style="width: 75%"></div>
  <span class="ui-progress-text">HP: 45/60</span>
</div>
```

**Styling**:
```css
.ui-progress-bar {
  background: #1a1a1a;
  border: 1px solid #555;
  height: 20px;
  position: relative;
  overflow: hidden;
}

.ui-progress-fill {
  background: linear-gradient(#8B0000, #A52A2A);
  height: 100%;
  transition: width 0.3s ease;
}

.ui-progress-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #E6E6E6;
  font-weight: bold;
  text-shadow: 1px 1px 2px rgba(0,0,0,0.8);
}
```

**Color Variants**:
- Health: `#8B0000` to `#A52A2A` (red gradient)
- Mana: `#191970` to `#4169E1` (blue gradient)
- Experience: `#DAA520` to `#FFD700` (gold gradient)

### 4. List Component

**Purpose**: Displaying collections of items, menu options, inventory

**HTML Structure**:
```html
<ul class="ui-list">
  <li class="ui-list-item selected">
    <span class="ui-list-icon">🗡️</span>
    <span class="ui-list-label">Iron Sword</span>
    <span class="ui-list-value">+5 ATK</span>
  </li>
</ul>
```

**Styling**:
```css
.ui-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.ui-list-item {
  display: flex;
  align-items: center;
  padding: 4px 8px;
  cursor: pointer;
  border-bottom: 1px solid #444;
}

.ui-list-item:hover {
  background: rgba(218, 165, 32, 0.1);
}

.ui-list-item.selected {
  background: rgba(218, 165, 32, 0.2);
  border: 1px solid #DAA520;
}

.ui-list-icon {
  width: 20px;
  text-align: center;
  margin-right: 8px;
}

.ui-list-label {
  flex: 1;
  color: #E6E6E6;
}

.ui-list-value {
  color: #B0B0B0;
  font-size: 0.9em;
}
```

### 5. Modal Dialog Component

**Purpose**: Overlay panels for confirmations, detailed information

**HTML Structure**:
```html
<div class="ui-modal-backdrop">
  <div class="ui-modal">
    <div class="ui-modal-header">
      <h3>Confirm Action</h3>
      <button class="ui-modal-close">×</button>
    </div>
    <div class="ui-modal-body">
      <p>Are you sure you want to discard this item?</p>
    </div>
    <div class="ui-modal-footer">
      <button class="ui-button">Cancel</button>
      <button class="ui-button ui-button-danger">Discard</button>
    </div>
  </div>
</div>
```

**Styling**:
```css
.ui-modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.ui-modal {
  background: #2d2d2d;
  border: 3px solid #8B4513;
  min-width: 300px;
  max-width: 90%;
  max-height: 90%;
  overflow: auto;
}

.ui-modal-header {
  background: #8B4513;
  color: #E6E6E6;
  padding: 8px 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.ui-modal-close {
  background: none;
  border: none;
  color: #E6E6E6;
  font-size: 20px;
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
}
```

### 6. Tab Component

**Purpose**: Organization of related content sections

**HTML Structure**:
```html
<div class="ui-tabs">
  <div class="ui-tab-headers">
    <button class="ui-tab-header active">Stats</button>
    <button class="ui-tab-header">Equipment</button>
    <button class="ui-tab-header">Skills</button>
  </div>
  <div class="ui-tab-content">
    <!-- Tab panel content -->
  </div>
</div>
```

**Styling**:
```css
.ui-tab-headers {
  display: flex;
  border-bottom: 2px solid #8B4513;
}

.ui-tab-header {
  background: #2d2d2d;
  border: 2px solid #8B4513;
  border-bottom: none;
  color: #B0B0B0;
  padding: 8px 16px;
  cursor: pointer;
  margin-right: 2px;
}

.ui-tab-header.active {
  background: #3d3d3d;
  color: #E6E6E6;
  border-bottom: 2px solid #3d3d3d;
}

.ui-tab-content {
  background: #3d3d3d;
  padding: 12px;
  border: 2px solid #8B4513;
  border-top: none;
}
```

## Layout Components

### 1. Grid System

**Purpose**: Responsive layout structure

**Classes**:
```css
.ui-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

.ui-row {
  display: flex;
  flex-wrap: wrap;
  margin: 0 -8px;
}

.ui-col {
  padding: 0 8px;
  flex: 1;
}

.ui-col-1 { flex: 0 0 8.333%; }
.ui-col-2 { flex: 0 0 16.666%; }
.ui-col-3 { flex: 0 0 25%; }
.ui-col-4 { flex: 0 0 33.333%; }
.ui-col-6 { flex: 0 0 50%; }
.ui-col-12 { flex: 0 0 100%; }
```

### 2. Flexbox Utilities

**Purpose**: Common layout patterns

```css
.ui-flex { display: flex; }
.ui-flex-column { flex-direction: column; }
.ui-flex-center { justify-content: center; align-items: center; }
.ui-flex-between { justify-content: space-between; }
.ui-flex-around { justify-content: space-around; }
.ui-flex-end { justify-content: flex-end; }
```

## Interactive Components

### 1. Tooltip Component

**Purpose**: Contextual information on hover

**HTML Structure**:
```html
<span class="ui-tooltip" data-tooltip="This is a helpful tip">
  Hover me
</span>
```

**Styling**:
```css
.ui-tooltip {
  position: relative;
  cursor: help;
}

.ui-tooltip::after {
  content: attr(data-tooltip);
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background: #1a1a1a;
  color: #E6E6E6;
  padding: 4px 8px;
  border: 1px solid #8B4513;
  border-radius: 3px;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s;
  z-index: 1000;
}

.ui-tooltip:hover::after {
  opacity: 1;
}
```

### 2. Dropdown Component

**Purpose**: Selection from a list of options

**HTML Structure**:
```html
<div class="ui-dropdown">
  <button class="ui-dropdown-toggle">
    Select Option <span class="ui-dropdown-arrow">▼</span>
  </button>
  <ul class="ui-dropdown-menu">
    <li class="ui-dropdown-item">Option 1</li>
    <li class="ui-dropdown-item">Option 2</li>
    <li class="ui-dropdown-item">Option 3</li>
  </ul>
</div>
```

**Styling**:
```css
.ui-dropdown {
  position: relative;
  display: inline-block;
}

.ui-dropdown-toggle {
  background: #2d2d2d;
  border: 2px solid #8B4513;
  color: #E6E6E6;
  padding: 6px 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-width: 120px;
}

.ui-dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: #2d2d2d;
  border: 2px solid #8B4513;
  border-top: none;
  list-style: none;
  padding: 0;
  margin: 0;
  max-height: 200px;
  overflow-y: auto;
  display: none;
  z-index: 1000;
}

.ui-dropdown.open .ui-dropdown-menu {
  display: block;
}

.ui-dropdown-item {
  padding: 6px 12px;
  cursor: pointer;
  color: #E6E6E6;
}

.ui-dropdown-item:hover {
  background: rgba(218, 165, 32, 0.2);
}
```

## Animation and Transition Guidelines

### 1. Standard Transitions

**Duration**: 0.2s for UI feedback, 0.3s for layout changes
**Easing**: `ease-out` for opening, `ease-in` for closing
**Properties**: `opacity`, `transform`, `background-color`, `border-color`

### 2. Common Animations

```css
/* Fade in/out */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Slide down */
@keyframes slideDown {
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

/* Pulse effect for notifications */
@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}
```

## Accessibility Features

### 1. Keyboard Navigation

- All interactive elements must be focusable with Tab key
- Clear focus indicators with `outline` or `box-shadow`
- Logical tab order through proper HTML structure
- Support for arrow key navigation in menus and lists

### 2. Screen Reader Support

- Proper semantic HTML elements (`button`, `nav`, `main`, etc.)
- ARIA labels for complex interactions
- Alt text for informational images
- Role attributes for custom components

### 3. Color and Contrast

- Minimum 4.5:1 contrast ratio for normal text
- 3:1 ratio for large text and UI elements
- Color-blind friendly palette alternatives
- Text information not dependent on color alone

This component library provides the foundation for consistent, accessible, and maintainable UI implementation across the entire dungeon crawler game.