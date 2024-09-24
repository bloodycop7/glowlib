# **GlowLib** Documentation
## Functions
1. GlowLib:RemoveAll()
    - Removes all Sprites.
2. GlowLib:Remove(Entity)
    - Removes all Sprites from the given Entity.
3. GlowLib:ShowAll()
    - Shows all currently NoDrawn Sprites.
4. GlowLib:Show(Entity)
    - Shows all NoDrawn Sprites from the given Entity.
5. GlowLib:HideAll()
    - Hides all current Sprites.
6. GLowLib:Hide(Entity)
    - Hides all Sprites belonging the to given Entity.
7. GlowLib:CreateSprite(Entity, SpriteData)
    - Creates a New Sprite belonging to **`Entity`**

    - SpriteData:
        * Color = Color(255, 255, 255)
        * Attachment = "eyes"
        * GlowTexture = "sprites/light_glow02.vmt"
        * Size = 0,3
        * RenderMode = 9 (Not Recommended to Change)

    - **Returns the Created Sprite.**
8. GlowLib:Initialize(Entity)
    - Initializes the Entity's Glow Data and creates sprites based on it.
9. GlowLib:Update(Entity)
    - Updates the Entity's sprites to match the GlowData (except Position and Attachment Values)
10. GlowLib:ShouldDraw(Entity)
    - Returns whether an Entity's Sprites should be drawn.

## Hooks
1. GlowLib_CanUseCreationMenu(Player, Panel)
    - Return true or false.

    Panel is not always valid, use:
    ```
    if IsValid(Panel) then
        return false // lol, troll
    end
    ```
2. GlowLib_CanPlayerSaveCreation(Player, Model, Data)
    - Return true or false
3. GlowLib_CanUseEditMenu(Player, Entity, Panel)
    - Return true or false.
4. GlowLib_CanPerformEdit(Player, Entity, Sprite, Data)
    - Return true or false
5. GlowLib_Remove(Entity)
    - Called when an Entity's Sprites get removed.
6. GlowLib_RemoveAll()
    - Called when GlowLib:RemoveAll() is called.
7. GlowLib_Initialize(Entity)
    - Called after GlowLib:Initialize(Entity) has finished.
8. GlowLib_Update(Entity)
    - Called after GlowLib:Update(Entity) has been called.
9. GlowLib_PreHide(Entity)
    - Called before GlowLib does it's internal Sprite hiding on an Entity.
10. GlowLib_Hide(Entity)
    - Called after GlowLib has finished Hiding an Entity's Sprites.
11. GlowLib_PreShow(Entity)
    - Called before GlowLib does it's internal Sprite showing on an Entity.
12. GlowLib_Show(Entity)
    - Called after GlowLib does it's internal Sprite showing on an Entity.