## Documentation
### Define Arguments
```
Color - a Color(r, g, b) (reverts to the color with skin 0 or the color white)
RenderMode - a number, check https://developer.valvesoftware.com/wiki/Env_sprite
ColorAlpha - a number (0 - 255)
GlowTexture - a string
Size - a number
Position - a function(ent)
    return self:GetPos() + self:GetForward() * 2
end
Attachment - a string
CustomColor - a function(ent, glowCol)
    return color_white
end
OnInitialize - a function(ent, sprite)

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
    Size = 0.2,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(180, 100, 25)
    },
    ColorAlpha = 180,
})
```
### Getting the Sprite Entity
```
** SHARED **
ent:GetGlowingEye()
** SERVER **
GlowLib.Entities[ent]
```
