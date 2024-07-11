local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(255, 60, 0)
    },
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(255, 200, 0, 200),
        [1] = Color(205, 55, 30, 200)
    },
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/combine_scanner.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        if ( !attachmentData ) then
            return ent:GetPos() + ent:GetAngles():Forward() * 15 + ent:GetAngles():Up() * 1.1
        end

        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(255, 135, 0),
    },
})

GlowLib:Define("models/hunter.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("top_eye"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -5
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

        glowCol.a = glowCol.a or self.ColorAlpha or 255

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(attachmentData.Pos + attachmentData.Ang:Forward() * -5)
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
    DynamicLightPos = function(self, ent, sprite)
        return sprite:GetPos() + sprite:GetAngles():Forward() * 0
    end,
    DynamicLightSize = function(self, ent, sprite)
        return 30
    end,
    DynamicLightBrightness = function(self, ent, sprite)
        return 4
    end,
})

GlowLib:Define("models/shield_scanner.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eye"))
        return attachmentData.Pos
    end,
    DynamicLightPos = function(self, ent, sprite)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eye"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 2
    end,
    Attachment = "eye",
    Size = 0.35,
    Color = {
        [0] = Color(255, 135, 0),
    },
})

GlowLib:Define("models/vortigaunt.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 3
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(255, 50, 50),
    },
    Size = 0.25,
    ColorAlpha = 180,
})

GlowLib.Glow_Data["models/vortigaunt_slave.mdl"] = GlowLib.Glow_Data["models/vortigaunt.mdl"]
GlowLib.Glow_Data["models/vortigaunt_blue.mdl"] = GlowLib.Glow_Data["models/vortigaunt.mdl"]
GlowLib.Glow_Data["models/vortigaunt_doctor.mdl"] = GlowLib.Glow_Data["models/vortigaunt.mdl"]

GlowLib:Define("models/dog.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(220, 10, 0),
    },
    DynamicLightBrightness = function(self, ent, sprite)
        return 4
    end,
    DynamicLightPos = function(self, ent, sprite)
        return sprite:GetPos() + sprite:GetAngles():Forward() * 10
    end,
})

GlowLib:Define("models/props_combine/health_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 4
    end,
    Color = {
        [0] = Color(0, 145, 210),
    },
    Size = 0.8,
    NoDynamicLight = true,
})

GlowLib:Define("models/props_combine/suit_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 7
    end,
    Color = {
        [0] = Color(210, 120, 0),
    },
    Size = 0.8,
    NoDynamicLight = true,
})

GlowLib:Define("models/player/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(205, 75, 0, 100)
    },
    CustomColor = function(self, ent, sprie)
        if ( ent:IsPlayer() ) then
            return ent:GetPlayerColor():ToColor()
        end
    end,
    ColorAlpha = 200,
})

GlowLib:Define("models/player/combine_super_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(255, 0, 0),
    },
    CustomColor = function(self, ent, sprie)
        if ( ent:IsPlayer() ) then
            return ent:GetPlayerColor():ToColor()
        end
    end,
    ColorAlpha = 200,
})