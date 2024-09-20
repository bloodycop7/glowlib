# Documentation
### Define Arguments
```
Color - Color(r, g, b)
GlowTexture = "sprites/light_glow02.vmt"
Size = 0.3
Position = function(self, ent)
    local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
    return attachmentData.Pos
end
Attachment = "eyes"
CustomColor = function(self, ent, glowCol)

end
OnInitialize = function(self, ent, sprite)

end
```

**Example**
```lua
GlowLib:Define("model.mdl", {
    Position = function(ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.3,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(180, 100, 25)
    },
})
```
**Example  - Multiple Glow Eyes**
```lua
GlowLib:Define("models/hunter.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("top_eye"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -4
    end,
    Attachment = "top_eye",
    Color = {
        [0] = Color(0, 255, 255, 160),
    },
    Size = 0.4,
    OnInitialize = function(self, ent, sprite)
        local glow_eyes = ent:GetGlowingEyes()
        local glow_color = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glow_color = self:CustomColor(ent, glowCol)
        end

        local attach = ent:LookupAttachment("bottom_eye")
        local attachmentData = ent:GetAttachment(attach)
        if !attachmentData then return end

        local sprite = GlowLib:CreateSprite(ent, {
            Color = glow_color,
            Attachment = "bottom_eye",
            Position = attachmentData.Pos + attachmentData.Ang:Forward() * -4,
            Size = 0.4,
        })
    end,
})
```
### Getting the Sprite Entities
```
** SHARED **
ent:GetGlowingEyes() :: table
```
### In the case you're using a custom entity and the glow is not showing.
```
ENT.GlowLib_IgnoreHealth = true
```
