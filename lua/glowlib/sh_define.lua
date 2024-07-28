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
    DynamicLightPos = function(self, ent, sprite)
        return sprite:GetPos() + sprite:GetAngles():Forward() * 1
    end
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

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
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
    DynamicLightPos = function(self, ent, sprite)
        return sprite:GetPos() + sprite:GetAngles():Forward() * -15
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
    DynamicLightPos = function(self, ent, sprite)
        return sprite:GetPos() + sprite:GetAngles():Forward() * 4
    end,
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
    CustomColor = function(self, ent, sprite)
        if ( ent:GetInternalVariable("m_bIsBlue") ) then
            return Color(40, 0, 255)
        end
    end,
})

GlowLib.Glow_Data["models/vortigaunt_slave.mdl"] = table.Copy(GlowLib.Glow_Data["models/vortigaunt.mdl"])
GlowLib.Glow_Data["models/vortigaunt_blue.mdl"] = table.Copy(GlowLib.Glow_Data["models/vortigaunt.mdl"])
GlowLib.Glow_Data["models/vortigaunt_doctor.mdl"] = table.Copy(GlowLib.Glow_Data["models/vortigaunt.mdl"])

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
})

GlowLib.Glow_Data["models/player/combine_soldier_prisonguard.mdl"] = table.Copy(GlowLib.Glow_Data["models/combine_soldier_prisonguard.mdl"])

GlowLib:Define("models/antlion_guard.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("attach_glow1"))
        return attachmentData.Pos
    end,
    Attachment = "attach_glow1",
    Color = {
        [0] = Color(255, 100, 0),
        [1] = Color(0, 255, 0),
    },
    Size = 0.5,
    GlowTexture = "sprites/grubflare1.vmt",
    OnInitialize = function(self, ent, sprite)
        local attachment = ent:LookupAttachment("attach_glow2")
        local attachmentData = ent:GetAttachment(attachment)
        local glow_eyes = ent:GetGlowingEyes()

        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(attachmentData.Pos + attachmentData.Ang:Forward() * -4)
        sprite:SetParent(ent, attachment or 0)
        sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
        sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)

        sprite:SetKeyValue("model", tostring(self.GlowTexture))
        sprite:SetColor(glowCol)

        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("HDRColorScale", "0.5")
        sprite:SetKeyValue("scale", "0.5")

        sprite:SetNW2Bool("bIsGlowLib", true)
        sprite:Spawn()
        sprite:Activate()

        ent:DeleteOnRemove(sprite)
    end,
    PostUpdate = function(self, ent, sprites)
        for k, v in ipairs(ent:GetChildren()) do
            if ( !IsValid(v) ) then continue end

            local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

            local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
            if ( glowColCustom != nil ) then
                glowCol = self:CustomColor(ent, glowCol)
            end



            v:SetColor(glowCol)
        end
    end,
    CustomColor = function(self, ent, sprite)
        if ( ent:GetInternalVariable("cavernbreed" ) ) then
            return Color(0, 255, 0)
        end
    end,
    ShouldDraw = function(self, ent)
        if ( !ent:GetInternalVariable("cavernbreed") and ent:GetSkin() == 0 ) then
            return false
        end

        return true
    end,
})

GlowLib:Define("models/antlion_grub.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("glow"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1 + attachmentData.Ang:Right() * -2
    end,
    Attachment = "glow",
    Color = {
        [0] = Color(0, 255, 0),
    },
    Size = 0.3,
    GlowTexture = "sprites/grubflare1.vmt",
    PostUpdate = function(self, ent, sprites)
        for k, v in ipairs(ent:GetChildren()) do
            if ( !IsValid(v) ) then continue end

            local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

            local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
            if ( glowColCustom != nil ) then
                glowCol = self:CustomColor(ent, glowCol)
            end



            v:SetColor(glowCol)
        end
    end,
})