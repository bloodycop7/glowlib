# Documentation
### Define Arguments
```
Color - Color(r, g, b)
ColorAlpha = 0-255
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
DynamicLightColor = function(self, ent, sprite)

end
DynamicLightPos = function(self, ent, sprite)

end
DynamicLightBrightness = function(self, ent, sprite)

end
DynamicLightSize = function(self, ent, sprite)

end
```

**Example**
```
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
    ColorAlpha = 180,
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
