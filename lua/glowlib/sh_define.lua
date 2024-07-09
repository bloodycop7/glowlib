local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(205, 75, 0, 100)
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
        [1] = Color(205, 55, 30)
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
    OnInitialize = function(self, ent)
        local attachment = ent:LookupAttachment("bottom_eye")
        local attachmentData = ent:GetAttachment(attachment)

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(attachmentData.Pos + attachmentData.Ang:Forward() * -5)
        sprite:SetParent(ent, attachment or 0)
        sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
        sprite:SetNW2String("GlowLib_Eye_Count", #ent:GetGlowingEyes() + 1)
        sprite:SetKeyValue("model", "sprites/light_glow02.vmt")
        sprite:SetKeyValue("rendercolor", "0 255 255")
        sprite:SetKeyValue("renderamt", "255")
        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("HDRColorScale", "0.5")
        sprite:SetKeyValue("scale", "0.3")
        sprite:Spawn()

        ent:DeleteOnRemove(sprite)
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
        return attachmentData.Pos + attachmentData.Ang:Forward() * 0
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(220, 10, 0),
    },
    ColorAlpha = 255,
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

GlowLib:Define("models/props_combine/combine_intmonitor001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Up() * 29 + ent:GetAngles():Forward() * 10
    end,
    Color = {
        [0] = Color(0, 255, 255),
    },
    Size = 1.7,
    NoDynamicLight = true,
})

GlowLib:Define("models/props_combine/combine_intmonitor003.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Up() * 29 + ent:GetAngles():Forward() * 35
    end,
    Color = {
        [0] = Color(0, 255, 255),
    },
    Size = 1.7,
    NoDynamicLight = true,
})

GlowLib:Define("models/props_combine/combine_monitorbay.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Up() * 10 + ent:GetAngles():Forward() * 10
    end,
    Color = {
        [0] = Color(0, 255, 255),
    },
    Size = 4,
    NoDynamicLight = true,
})

GlowLib:Define("models/props_combine/weaponstripper.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Up() * 60 + ent:GetAngles():Forward() * 15
    end,
    Color = {
        [0] = Color(0, 255, 255),
    },
    Size = 3,
    NoDynamicLight = true,
})

GlowLib:Define("models/props_combine/combine_interface001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Up() * 48 + ent:GetAngles():Forward() * 2 + ent:GetAngles():Right() * 2
    end,
    Color = {
        [0] = Color(0, 255, 255),
    },
    Size = 1,
    NoDynamicLight = true,
})