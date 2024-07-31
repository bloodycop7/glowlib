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
        [0] = Color(0, 255, 255),
    },
    OnInitialize = function(self, ent, sprite)
        local attachment = ent:LookupAttachment("bottom_eye")
        local attachmentData = ent:GetAttachment(attachment)
        local glow_eyes = ent:GetGlowingEyes()

        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white
        if ( self["CustomColor"] and isfunction(self["CustomColor"]) ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(attachmentData.Pos + attachmentData.Ang:Forward() * -4)
        sprite:SetParent(ent, attachment or 0)
        sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
        sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)

        sprite:SetKeyValue("model", "sprites/light_glow02.vmt")
        sprite:SetColor(glowCol)

        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("HDRColorScale", "0.5")
        sprite:SetKeyValue("scale", "0.3")

        sprite:SetNW2Bool("bIsGlowLib", true)
        sprite:Spawn()
        sprite:Activate()

        ent:DeleteOnRemove(sprite)
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
