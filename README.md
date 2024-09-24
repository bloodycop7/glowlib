# **GlowLib** Documentation
## Functions
1. GlowLib:RemoveAll()
    - Removes all Sprites.
2.  GlowLib:Remove(Entity)
    - Removes all Sprites from the given Entity.
### GlowLib:ShowAll()
- Shows all currently NoDrawn Sprites.
### GlowLib:Show(Entity)
- Shows all NoDrawn Sprites from the given Entity.
### GlowLib:HideAll()
- Hides all current Sprites.
### GLowLib:Hide(Entity)
- Hides all Sprites belonging the to given Entity.
### GlowLib:CreateSprite(Entity, SpriteData)
**- Creates a New Sprite belonging to `Entity`**

SpriteData:
* Color = Color(255, 255, 255)
* Attachment = "eyes"
* GlowTexture = "sprites/light_glow02.vmt"
* Size = 0,3
* RenderMode = 9 (Not Recommended to Change)

- **Returns the Created Sprite.**
### GlowLib:Initialize(Entity)
- Initializes the Entity's Glow Data and creates sprites based on it.
### GlowLib:Update(Entity)
- Updates the Entity's sprites to match the GlowData (except Position and Attachment Values)
### GlowLib:ShouldDraw(Entity)
- Returns whether an Entity's Sprites should be drawn.