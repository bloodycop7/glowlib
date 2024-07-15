local GlowLib = GlowLib

function GlowLib:GetAllEntities()
    local returned = {}

    for k, v in ents.Iterator() do
        if ( !IsValid(v) ) then continue end
        if ( !v:GetNW2Bool("bHasGlowLibEffect", false) ) then continue end

        table.insert(returned, v)
    end

    return returned
end

function GlowLib:GetAllSprites()
    local returned = {}

    for k, v in ipairs(ents.FindByClass("env_sprite")) do
        if ( !IsValid(v) ) then continue end
        if ( !v:GetNW2Bool("bIsGlowLib", false) ) then continue end

        table.insert(returned, v)
    end

    return returned
end

if ( SERVER ) then
    function GlowLib:Remove(ent)
        if ( !IsValid(ent) ) then return end

        local model = ent:GetModel()
        if ( !model ) then return end

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
            if ( ent.NoGlowLib ) then return end
            local glowCol = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white

            local glow_mat = glowData.GlowTexture
            if ( !glow_mat ) then
                glowData.GlowTexture = "sprites/light_glow02.vmt"
                glow_mat = glowData.GlowTexture
            end

            local glow_size = glowData.Size
            if ( !glow_size ) then
                glowData.Size = 0.3
                glow_size = glowData.Size
            end

            local vec_sprite = glowData["Position"] and glowData:Position(ent, glowData)
            if ( !vec_sprite ) then
                vec_sprite = ent:EyePos() + ent:GetAngles():Forward() * 7
            end

            if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
                glowCol = glowData:CustomColor(ent, glowCol)
            end

            glowCol.a = glowCol.a or glowData.ColorAlpha or 255

            if ( glowData["CustomSize"] and isfunction(glowData["CustomSize"]) ) then
                glow_size = glowData:CustomSize(ent, glow_size)
            end

            if ( !glowData["ShouldDraw"] ) then
                glowData["ShouldDraw"] = function(self, ent) return true end
            end

            if ( !glowData:ShouldDraw(ent) ) then return end

            local attach = ent:LookupAttachment(glowData.Attachment or "eyes")
            local sprite = ents.Create("env_sprite")
            sprite:SetPos(vec_sprite)
            sprite:SetParent(ent, attach or 0)

            sprite:SetNW2String("GlowEyeName", "GlowLib_Eye_" .. ent:EntIndex())
            sprite:SetNW2String("GlowLib_Eye_Count", #glow_eyes + 1)

            sprite:SetKeyValue("model", tostring(glow_mat))
            sprite:SetColor(glowCol)

            sprite:SetKeyValue("rendermode", "9")
            sprite:SetKeyValue("HDRColorScale", "0.5")
            sprite:SetKeyValue("scale", tostring(glow_size))

            sprite:SetNW2Bool("bIsGlowLib", true)
            sprite:Spawn()

            ent:SetNW2Bool("bHasGlowLibEffect", true)
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

        local col = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
        if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
            col = glowData:CustomColor(ent, col)
        end
        col.a = col.a or glowData.ColorAlpha or 255

        local size = glowData.Size or 0.3

        for k, v in ipairs(glowEyes) do
            if ( !ent.GlowLib_DisableUpdating ) then
                v:SetKeyValue("model", glowData.GlowTexture or "sprites/light_glow02.vmt")
                v:SetColor(col)
            end

            v:SetKeyValue("HDRColorScale", "0.5")

            if ( !ent.GlowLib_DisableUpdating ) then
                v:SetKeyValue("scale", tostring(size))
            end
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

    hook.Run("GlowLib:PreHide", ent)

    local glow_eyes = ent:GetGlowingEyes()
    for k, v in ipairs(glow_eyes) do
        if ( IsValid(v) ) then
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

    hook.Run("GlowLib:PreShow", ent)

    local glow_eyes = ent:GetGlowingEyes()
    for k, v in ipairs(glow_eyes) do
        if ( IsValid(v) ) then
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
            net.Start("GlowLib:HideServerside")
            net.Send(ent)
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