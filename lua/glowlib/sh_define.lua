local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(205, 75, 0)
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 200, 0),
        [1] = Color(255, 70, 0)
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/combine_scanner.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -3
    end,
    Attachment = "eyes",
    Size = 0.15,
    Color = {
        [0] = Color(255, 135, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/hunter.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("top_eye"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -5
    end,
    Attachment = "top_eye",
    Size = 0.2,
    Color = {
        [0] = Color(0, 255, 255),
    },
    ColorAlpha = 255,
    OnInitialize = function(self, ent)
        timer.Simple(1, function()
            local attachment = ent:LookupAttachment("bottom_eye")
            local attachmentData = ent:GetAttachment(attachment)

            local orgSprite = ent:GetGlowingEye()
            local olgSpriteModel = orgSprite:GetInternalVariable("model")
            local olgSpriteRenderColor = orgSprite:GetInternalVariable("rendercolor")
            local olgSpriteRenderAlpha = orgSprite:GetInternalVariable("renderamt")
            local olgSpriteRenderMode = orgSprite:GetInternalVariable("rendermode")
            local olgSpriteHDRScale = orgSprite:GetInternalVariable("HDRColorScale")
            local olgSpriteScale = orgSprite:GetInternalVariable("scale")

            local sprite = ents.Create("env_sprite")
            sprite:SetPos(attachmentData.Pos + attachmentData.Ang:Forward() * -5)
            sprite:SetParent(ent, attachment)
            sprite:SetKeyValue("model", "sprites/light_glow02_add_noz.vmt")
            sprite:SetKeyValue("rendercolor", "0 255 255")
            sprite:SetKeyValue("renderamt", "255")
            sprite:SetKeyValue("rendermode", "9")
            sprite:SetKeyValue("HDRColorScale", "0.5")
            sprite:SetKeyValue("scale", "0.2")
            sprite:Spawn()

            ent:SetNW2Entity("GlowLib_Eye2", sprite)
            ent:DeleteOnRemove(sprite)
        end)
    end,
})

GlowLib:Define("models/vortigaunt.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 3
    end,
    Attachment = "eyes",
    Size = 0.35,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/dog.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 0
    end,
    Attachment = "eyes",
    Size = 0.25,
    Color = {
        [0] = Color(255, 50, 0),
    },
    ColorAlpha = 255,
})