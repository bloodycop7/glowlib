local GlowLib = GlowLib

if ( SERVER ) then
    function GlowLib:Remove(ent)
        if not ( IsValid(ent) ) then
            return
        end

        local model = ent:GetModel()
        if not ( model ) then
            return
        end

        local glow_eyes = ent:GetGlowingEyes()
        for k, v in ipairs(glow_eyes) do
            if ( IsValid(v) ) then
                v:Remove()
            end
        end

        hook.Run("GlowLib:Remove", ent)
    end

    function GlowLib:RemoveAll()
        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            local model = v:GetModel()
            if not ( model ) then
                continue
            end

            self:Remove(v)
        end

        hook.Run("GlowLib:RemoveAll")
    end

    function GlowLib:Initialize(ent)
        if ( !IsValid(ent) ) then return end

        local glow_eyes = ent:GetGlowingEyes()
        for k, v in ipairs(glow_eyes) do
            if ( IsValid(v) ) then
                v:Remove()
            end
        end

        local model = ent:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowData = self.Glow_Data[model]
        if ( glowData ) then
            local glowCol = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
            local renderMode = glowData.RenderMode or 9
            local colAlpha = glowData.ColorAlpha or ( glowCol.a or 255 )
            local glow_mat = glowData.GlowTexture or "sprites/light_glow02.vmt"
            local glow_size = glowData.Size or 0.3
            local vec_sprite = ( glowData["Position"] and glowData:Position(ent, glowData) ) or vector_origin
            local attach = ent:LookupAttachment(glowData.Attachment or "eyes")

            if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
                glowCol = glowData:CustomColor(ent, glowCol)
            end

            if ( !glowData["ShouldDraw"] ) then
                glowData["ShouldDraw"] = function(self, ent) return true end
            end

            if ( !glowData:ShouldDraw(ent) ) then return end

            local sprite = ents.Create("env_sprite")
            sprite:SetPos(vec_sprite)
            sprite:SetParent(ent, attach or 0)
            sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)
            sprite:SetKeyValue("model", tostring(glow_mat))
            sprite:SetKeyValue("rendercolor", tostring(glowCol))
            sprite:SetKeyValue("renderamt", tostring(colAlpha))
            sprite:SetKeyValue("rendermode", tostring(renderMode))
            sprite:SetKeyValue("HDRColorScale", "0.5")
            sprite:SetKeyValue("scale", tostring(glow_size))
            sprite:Spawn()

            ent:DeleteOnRemove(sprite)
            ent:CallOnRemove("GlowLib:Remove", function(ent)
                GlowLib:Remove(ent)
            end)

            if ( glowData["OnInitialize"] and isfunction(glowData["OnInitialize"]) and !ent.glowlib_hasBeenInitalized ) then
                glowData:OnInitialize(ent, sprite)
                ent.glowlib_hasBeenInitalized = true
            end

            hook.Run("GlowLib:Initalize", ent)
        end
    end

    function GlowLib:Update(ent)
        if ( !IsValid(ent) ) then return end

        local model = ent:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowEyes = ent:GetGlowingEyes()
        if ( !glowEyes or #glowEyes == 0 ) then return end

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then return end

        for k, v in ipairs(glowEyes) do
            local col = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
            if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
                col = glowData:CustomColor(ent, col)
            end

            v:SetKeyValue("model", glowData.GlowTexture or "sprites/light_glow02.vmt")
            v:SetKeyValue("rendercolor", tostring(col))
            v:SetKeyValue("renderamt", tostring(glowData.ColorAlpha or 255))
            v:SetKeyValue("rendermode", tostring(glowData.RenderMode or 9))
            v:SetKeyValue("HDRColorScale", "0.5")
            v:SetKeyValue("scale", tostring(glowData.Size or 0.3))
        end

        hook.Run("GlowLib:Update", ent)
    end
end

function GlowLib:Hide(ent)
    if ( !IsValid(ent) ) then return end

    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowData = self.Glow_Data[model]
    if ( !glowData ) then return end

    local glow_eyes = ent:GetGlowingEyes()
    for k, v in ipairs(glow_eyes) do
        if ( IsValid(v) and !v:GetNoDraw() ) then
            v:SetNoDraw(true)
        end
    end

    hook.Run("GlowLib:Hide", ent)
end

function GlowLib:HideAll()
    for k, v in ents.Iterator() do
        if not ( IsValid(v) ) then
            continue
        end

        local model = v:GetModel()
        if ( !model ) then continue end
        model = model:lower()

        local glowData = self.Glow_Data[model]
        if ( !glowData ) then continue end

        self:Hide(v)
    end
end

function GlowLib:Show(ent)
    if ( !IsValid(ent) ) then return end

    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowData = self.Glow_Data[model]
    if ( !glowData ) then return end

    local glow_eyes = ent:GetGlowingEyes()
    for k, v in ipairs(glow_eyes) do
        if ( IsValid(v) and v:GetNoDraw() ) then
            v:SetNoDraw(false)
        end
    end

    if ( CLIENT ) then
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local plyModel = ply:GetModel()
        if ( !plyModel ) then return end
        plyModel = plyModel:lower()

        local glowData = self.Glow_Data[plyModel]
        if ( !glowData ) then return end

        local shouldDrawLocalPlayer = ply:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ply)
        if ( !shouldDrawLocalPlayer ) then
            self:Hide(ply)
        end
    else
        if ( ent:IsPlayer() ) then
            timer.Simple(0.1, function()
                if ( !IsValid(ent) ) then return end

                ent:SendLua([[GlowLib:Hide(LocalPlayer())]])
            end)
        end
    end

    hook.Run("GlowLib:Show", ent)
end

function GlowLib:ShowAll()
    for k, v in ents.Iterator() do
        if not ( IsValid(v) ) then
            continue
        end

        local model = v:GetModel()
        if ( !model ) then continue end
        model = model:lower()

        local glowData = self.Glow_Data[model]
        if ( !glowData ) then continue end

        self:Show(v)
    end
end