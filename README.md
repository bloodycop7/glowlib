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
    - Returns true or false.
    Panel is not always valid, use:
    ```
    if IsValid(Panel) then
        return false // lol, troll
    end
    ```
