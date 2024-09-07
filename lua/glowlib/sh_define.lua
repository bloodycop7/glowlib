local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(0, 100, 210, 170),
        [1] = Color(140, 25, 0, 170)
    },
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(190, 145, 0, 170),
        [1] = Color(155, 40, 0, 170)
    },
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(200, 0, 0, 170),
    },
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
        [0] = Color(215, 105, 0, 170),
    },
})

GlowLib:Define("models/hunter.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("top_eye"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -4
    end,
    Attachment = "top_eye",
    Color = {
        [0] = Color(0, 255, 255, 170),
    },
    Size = 0.4,
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
        sprite:SetKeyValue("scale", "0.4")

        sprite:SetNW2Bool("bIsGlowLib", true)
        sprite:Spawn()
        sprite:Activate()

        ent:DeleteOnRemove(sprite)
    end,
})

GlowLib:Define("models/shield_scanner.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eye"))
        return attachmentData.Pos
    end,
    Attachment = "eye",
    Size = 0.35,
    Color = {
        [0] = Color(215, 105, 0, 170),
    },
})

GlowLib:Define("models/vortigaunt.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 3
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(205, 0, 0, 170),
    },
    Size = 0.25,
    CustomColor = function(self, ent, sprite)
        if ( ent:GetInternalVariable("m_bIsBlue") ) then
            return Color(65, 0, 255, 170)
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
        [0] = Color(220, 5, 0, 170),
    },
})

GlowLib:Define("models/props_combine/health_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 7 + ent:GetAngles():Up() * -1 + ent:GetAngles():Right() * 2.5
    end,
    Color = {
        [0] = Color(0, 255, 255, 255),
    },
    Size = 0.1,
    GlowTexture = "sprites/light_glow02.vmt",
    OnInitialize = function(self, ent, sprite)
        local glow_eyes = ent:GetGlowingEyes()

        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 5)
        sprite:SetParent(ent)
        sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
        sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)

        sprite:SetKeyValue("model", "sprites/light_glow02.vmt")
        sprite:SetColor(Color(0, 195, 255, 170))

        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("scale", "0.5")

        sprite:SetNW2Bool("bIsGlowLib", true)
        sprite:Spawn()
        sprite:Activate()

        local spriteTable = sprite:GetTable()
        spriteTable.NoGlowLibUpdate = true

        ent:DeleteOnRemove(sprite)
    end,
})

GlowLib:Define("models/props_combine/suit_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 7
    end,
    Color = {
        [0] = Color(205, 115, 0, 200),
    },
    Size = 0.45,
})

GlowLib:Define("models/props_combine/suit_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 7 + ent:GetAngles():Up() * 11 + ent:GetAngles():Right() * 1
    end,
    Color = {
        [0] = Color(255, 135, 0),
    },
    Size = 0.1,
    GlowTexture = "sprites/light_glow02.vmt",
    OnInitialize = function(self, ent, sprite)
        local glow_eyes = ent:GetGlowingEyes()

        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        local sprite = ents.Create("env_sprite")
        sprite:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 5)
        sprite:SetParent(ent)
        sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
        sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)

        sprite:SetKeyValue("model", "sprites/light_glow02.vmt")
        sprite:SetColor(Color(255, 115, 0, 170))

        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("scale", "0.5")

        sprite:SetNW2Bool("bIsGlowLib", true)
        sprite:Spawn()
        sprite:Activate()

        local spriteTable = sprite:GetTable()
        spriteTable.NoGlowLibUpdate = true

        ent:DeleteOnRemove(sprite)
    end,
})

GlowLib:Define("models/player/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Color = {
        [0] = Color(0, 100, 210, 170),
        [1] = Color(140, 25, 0, 170)
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
        [0] = Color(200, 0, 0, 170),
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

        sprite:SetKeyValue("model", "sprites/grubflare1.vmt")
        sprite:SetColor(glowCol)

        sprite:SetKeyValue("rendermode", "9")
        sprite:SetKeyValue("HDRColorScale", "1")
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
        return ent:GetAttachment(1).Pos
    end,
    Attachment = "glow",
    Color = {
        [0] = Color(0, 255, 0),
    },
    GlowTexture = "sprites/grubflare1.vmt",
    OnInitialize = function(self, ent, sprite)
        sprite:SetPos(ent:GetAttachment(1).Pos)
        sprite:SetParent(ent:GetChildren()[1])
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
})

GlowLib:Define("models/healthvial.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetUp() * 5
    end,
    Color = {
        [0] = Color(0, 255, 0, 200),
    },
    Size = 0.15,
    OnInitialize = function(self, ent, sprite)
        local light = ents.Create("light_dynamic")
        light:SetPos(ent:GetPos() + ent:GetUp() * 5)
        light:SetParent(ent)
        light:SetKeyValue("_light", "0 255 0")
        light:SetKeyValue("style", "1")
        light:SetKeyValue("distance", "13")
        light:SetKeyValue("brightness", "2")
        light:Spawn()
        light:Activate()

        ent:DeleteOnRemove(light)
    end,
})

GlowLib:Define("models/items/healthkit.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 5 + ent:GetRight() * -3.5
    end,
    Color = {
        [0] = Color(0, 255, 0, 200),
    },
    Size = 0.25,
    OnInitialize = function(self, ent, sprite)
        local light = ents.Create("light_dynamic")
        light:SetPos(ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 5 + ent:GetRight() * -3.5)
        light:SetParent(ent)
        light:SetKeyValue("_light", "0 255 0")
        light:SetKeyValue("style", "1")
        light:SetKeyValue("distance", "18")
        light:SetKeyValue("brightness", "2")
        light:Spawn()
        light:Activate()

        ent:DeleteOnRemove(light)
    end,
})

GlowLib:Define("models/items/battery.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 2
    end,
    Color = {
        [0] = Color(0, 255, 255, 200),
    },
    Size = 0.2,
    OnInitialize = function(self, ent, sprite)
        local light = ents.Create("light_dynamic")
        light:SetPos(ent:GetPos() + ent:GetUp() * 5)
        light:SetParent(ent)
        light:SetKeyValue("_light", "0 255 255")
        light:SetKeyValue("style", "1")
        light:SetKeyValue("distance", "13")
        light:SetKeyValue("brightness", "2")
        light:Spawn()
        light:Activate()

        ent:DeleteOnRemove(light)
    end,
})