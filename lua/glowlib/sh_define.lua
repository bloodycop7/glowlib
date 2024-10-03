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
        if ( !attachmentData ) then return end

        if ( SERVER ) then
            local sprite = GlowLib:CreateSprite(ent, {
                Color = glow_color,
                Attachment = "bottom_eye",
                Position = attachmentData.Pos + attachmentData.Ang:Forward() * -4,
                Size = 0.4,
            })
        end
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
        [0] = Color(0, 255, 255),
    },
    Size = 0.15,
    GlowTexture = "sprites/light_glow02.vmt",
    OnInitialize = function(self, ent, sprite)
        local glow_eyes = ent:GetGlowingEyes()
        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        if ( SERVER ) then
            local sprite = GlowLib:CreateSprite(ent, {
                Color = Color(0, 195, 255, 170),
                Position = ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 5,
                Size = 0.5,
            })

            local spriteTable = sprite:GetTable()
            spriteTable.GlowLib_bNoUpdate = true

            ent:DeleteOnRemove(sprite)

            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 12 + ent:GetAngles():Up() * 3 + ent:GetAngles():Right() * -5)
            light:SetParent(ent)
            light:SetKeyValue("_light", "0 255 255 255")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "15")
            light:SetKeyValue("brightness", "1")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
    end,
})

GlowLib:Define("models/props_combine/suit_charger001.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetAngles():Forward() * 7 + ent:GetAngles():Up() * 11 + ent:GetAngles():Right() * 1.5
    end,
    Color = {
        [0] = Color(255, 100, 0),
    },
    Size = 0.15,
    GlowTexture = "sprites/light_glow02.vmt",
    OnInitialize = function(self, ent, sprite)
        local glow_eyes = ent:GetGlowingEyes()

        local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            glowCol = self:CustomColor(ent, glowCol)
        end

        if ( SERVER ) then
            local sprite = GlowLib:CreateSprite(ent, {
                Color = Color(255, 115, 0, 170),
                Position = ent:GetPos() + ent:GetAngles():Forward() * 9 + ent:GetAngles():Up() * 5,
                Size = 0.5,
            })

            local spriteTable = sprite:GetTable()
            spriteTable.GlowLib_bNoUpdate = true

            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 10 + ent:GetAngles():Up() * 4 + ent:GetAngles():Right() * -1)
            light:SetParent(ent)
            light:SetKeyValue("_light", "255 135 0")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "5")
            light:SetKeyValue("brightness", "6")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
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
        local entTable = ent:GetTable()
        entTable.GlowLib_bDontUpdate = true
        entTable.GlowLib_bDisabled = true

        if ( SERVER ) then
            if ( IsValid(ent) and IsValid(sprite) ) then
                sprite:SetParent(nil)
                SafeRemoveEntity(sprite)
            end

            for k, v in ipairs(ent:GetChildren()) do
                if ( !IsValid(v) or v:GetClass() != "env_sprite" ) then continue end

                local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

                local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
                if ( glowColCustom != nil ) then
                    glowCol = self:CustomColor(ent, glowCol)
                end

                v:SetColor(glowCol)
            end
        end
    end,
    CustomColor = function(self, ent, sprite)
        if ( ent:GetInternalVariable("cavernbreed") ) then
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
        if ( SERVER ) then
            local entTable = ent:GetTable()
            entTable.GlowLib_bDontUpdate = true
            entTable.GlowLib_bDisabled = true

            if ( IsValid(ent) and IsValid(sprite) ) then
                sprite:SetParent(nil)
                SafeRemoveEntity(sprite)
            end

            for k, v in ipairs(ent:GetChildren()) do
                if ( !IsValid(v) or v:GetClass() != "env_sprite" ) then continue end

                local glowCol = self.Color[ent:GetSkin()] or self.Color[0] or color_white

                local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glowCol)
                if ( glowColCustom != nil ) then
                    glowCol = self:CustomColor(ent, glowCol)
                end

                v:SetColor(glowCol)
            end
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
        if ( SERVER ) then
            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetUp() * 5)
            light:SetParent(ent)
            light:SetKeyValue("_light", "0 255 0")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "13")
            light:SetKeyValue("brightness", "2")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
    end,
})

GlowLib:Define("models/items/healthkit.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 5 + ent:GetRight() * -3.5
    end,
    Color = {
        [0] = Color(0, 255, 0, 150),
    },
    Size = 0.25,
    OnInitialize = function(self, ent, sprite)
        if ( SERVER ) then
            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 5 + ent:GetRight() * -3.5)
            light:SetParent(ent)
            light:SetKeyValue("_light", "0 255 0")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "18")
            light:SetKeyValue("brightness", "2")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
    end,
})

GlowLib:Define("models/items/battery.mdl", {
    Position = function(self, ent)
        return ent:GetPos() + ent:GetUp() * 6 + ent:GetForward() * 2
    end,
    Color = {
        [0] = Color(0, 255, 255, 150),
    },
    Size = 0.2,
    OnInitialize = function(self, ent, sprite)
        if ( SERVER ) then
            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetUp() * 5)
            light:SetParent(ent)
            light:SetKeyValue("_light", "0 255 255")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "13")
            light:SetKeyValue("brightness", "2")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
    end,
})

GlowLib:Define("models/items/combine_rifle_ammo01.mdl", {
    Position = function(self, ent)
        return ent:WorldSpaceCenter()
    end,
    Color = {
        [0] = Color(255, 220, 0, 220),
    },
    Size = 0.3,
    OnInitialize = function(self, ent, sprite)
        if ( SERVER ) then
            local light = ents.Create("light_dynamic")
            light:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            light:SetPos(ent:GetPos() + ent:GetUp() * 5)
            light:SetParent(ent)
            light:SetKeyValue("_light", "255 220 0")
            light:SetKeyValue("style", "1")
            light:SetKeyValue("distance", "13")
            light:SetKeyValue("brightness", "2")
            light:Spawn()
            light:Activate()

            ent:DeleteOnRemove(light)
        end
    end,
})