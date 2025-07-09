# Game Texture Planning Form

## General Game Information

1. Target Platforms:
   - [ ] Mobile
   - [ ] Desktop
   - [ ] Web

2. Max Screen Resolution Supported by Target Platform (in pixels):
   - (Enter number: ________)
   - Web and Desktop is typically 1920x1080

3. Maximum Texture Size Supported by Target Platform (in pixels):
   - (Enter number: ________)
   - Mobile is typically 2048x2048 or 4096x4096
   - Web is typically 4096x4096 or 8192x8192
   - Desktop is typically 8192x8192 or 16384x16384

---

## Design Considerations

1. What is the closes that the camera will get to the sprites? Specifically, how many pixels (x, y) will a sprite or part of a sprite take up on screen at the closest point?
    - (Enter number: ________)
    - default: The closest point is the full sprite taking up 1/4 of the screen width or height

2. What is the greatest number of unique sprites that will be on screen at once?
    - (Enter number: ________)
    - default: 10

---

## Determine max sprite size:

Multiply the max screen resolution by the 

Example: at 1920 x 1080 and a sprite that takes up 1/2 of the screen height and 1/8 of the screen width, the sprite sheet should be 240 wide x 540 tall.

## Determine sprite padding

- Create some quick example sketches of animations
- Determine the most amount of padding that will be needed for the sprite

How much total space will be needed for the sprite when it is at its largest?

Example: The character that is max 240 wide x 540 tall tall will need to fully extend arms to the sides, put arms up, etc. The sprite will need to be 540 wide x 650 tall.

## Determine sprite sheet size

- With an animation of 10 frames and keeping to a max size of 4096 x 4096
- It would allow 7 frames wide and 6 frames tall.
- Allows up to a total frames of 42.

- With an animation of 10 frames and keeping to a max size of 2048 x 2048
- 3 wide, 3 tall
- cant fit 10 frames at 540 wide x 650





## Sprite Sheet Details

1. Maximum Number of Frames per Animation:
   - (Enter number: ________)
   - default: 15

2. Max Number of Animations per Character/Object:
   - (Enter number: ________)
   - Default: 12

3. Average Dimensions of Each Sprite (in pixels):
   - Width: (Enter number: ________)
   - Height: (Enter number: ________)

4. Number of Unique Characters/Objects Using Sprite Sheets:
   - (Enter number: ________)

5. Preferred Layout for Sprite Sheets:
   - ( ) Fixed grid (all sprites the same size)
   - ( ) Mixed sizes (sprites may vary in size)

6. Do you want to fit all animations for a single character/object on one sprite sheet?
   - ( ) Yes
   - ( ) No

7. Maximum File Size Limit for Sprite Sheets (in MB, optional):
    - (Enter number: ________)

---

## Tileset Details

11. **Tile Dimensions (in pixels):**
    - Width: (Enter number: ________)
    - Height: (Enter number: ________)

12. **Number of Unique Tiles in Your Tileset:**
    - (Enter number: ________)

13. **Do you want to organize tiles into a single tileset file?**
    - ( ) Yes
    - ( ) No

14. **Maximum File Size Limit for Tileset Files (in MB, optional):**
    - (Enter number: ________)

---

## Performance and Optimization

15. **Do you need mipmapping support?**  
    *(This allows textures to scale well at various distances but increases memory usage.)*
    - ( ) Yes
    - ( ) No

16. **What is your priority for texture optimization?**
    - ( ) Minimize memory usage
    - ( ) Maximize visual fidelity
    - ( ) Balanced between memory and fidelity

17. **Should padding be added between sprites/tiles to prevent texture bleeding?**
    - ( ) Yes
    - ( ) No

18. **Do you plan to export assets at multiple resolutions (e.g., 1x, 2x, 4x)?**
    - ( ) Yes
    - ( ) No

---

## Export and Style Considerations

19. **Primary Art Style:**
    - ( ) Flat / Cell Shaded
    - ( ) Detailed / Textured
    - ( ) Minimalist

20. **Vector Art Export Resolution for Rasterization (DPI or PPI):**
    - (Enter number: ________)

21. **Do you want to maintain editable vector files alongside exported PNGs?**
    - ( ) Yes
    - ( ) No

22. **Do you require alpha transparency in your PNGs?**
    - ( ) Yes
    - ( ) No

23. **Will sprites/tiles need scaling or rotation in-game?**
    - ( ) Yes
    - ( ) No

---

## Output Preferences

24. **Desired Texture Sheet Dimensions for Sprite Sheets (if known):**
    *(Use power-of-two sizes, e.g., 1024x1024, 2048x2048)*  
    - Width: (Enter number: ________)
    - Height: (Enter number: ________)

25. **Desired Texture Sheet Dimensions for Tilesets (if known):**
    *(Use power-of-two sizes, e.g., 1024x1024, 2048x2048)*  
    - Width: (Enter number: ________)
    - Height: (Enter number: ________)

26. **Would you like to automate texture packing (e.g., using a texture atlas tool)?**
    - ( ) Yes
    - ( ) No

27. **Additional Notes or Special Requirements:**
    - (Text box: ____________________________)

