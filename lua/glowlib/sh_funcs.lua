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
        local sv_glowlib_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
        if ( !sv_glowlib_enabled ) then return end

        if ( !IsValid(ent) ) then return end

        if ( ent:GetClass() == "prop_effect" ) then
            local child = ent:GetInternalVariable("m_hMoveChild")
            if ( IsValid(child) ) then
                ent = child
            end
        end

        local glow_eyes = ent:GetGlowingEyes()
        for k, v in ipairs(glow_eyes) do
            if ( IsValid(v) ) then
                v:Remove()
            end
        end

        local model = ent:GetModel()
        if ( !model ) then return end
        model = model:lower()

        if ( !util.IsValidModel(model) ) then return end

        local glowData = self.Glow_Data[model]
        if ( glowData ) then
            local entTable = ent:GetTable()

            if ( entTable.NoGlowLib ) then return end
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

            local glowColCustom = glowData.CustomColor and isfunction(glowData.CustomColor) and glowData:CustomColor(ent, glowCol)
            if ( glowColCustom != nil ) then
                glowCol = glowData:CustomColor(ent, glowCol)
            end

            local customSize = glowData.CustomSize and isfunction(glowData.CustomSize) and glowData:CustomSize(ent, glow_size)
            if ( customSize != nil ) then
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
            sprite:SetKeyValue("scale", tostring(glow_size))

            sprite:SetNW2Bool("bIsGlowLib", true)
            sprite:Spawn()

            ent:SetNW2Bool("bHasGlowLibEffect", true)
            ent:DeleteOnRemove(sprite)
            ent:CallOnRemove("GlowLib:Remove", function(ent)
                GlowLib:Remove(ent)
            end)

            entTable.GlowLib_DisableUpdating = false

            if ( glowData["OnInitialize"] and isfunction(glowData["OnInitialize"]) and !entTable.glowlib_hasBeenInitalized ) then
                glowData:OnInitialize(ent, sprite)
                entTable.glowlib_hasBeenInitalized = true
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

        local entTable = ent:GetTable()
        if ( entTable.GlowLib_DisableUpdating ) then return end

        local col = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
        local glowColCustom = glowData.CustomColor and isfunction(glowData.CustomColor) and glowData:CustomColor(ent, glowCol)
        if ( glowColCustom != nil ) then
            col = glowData:CustomColor(ent, glowCol)
        end

        local size = glowData.Size or 0.3

        for k, v in ipairs(glowEyes) do
            local vTable = v:GetTable()
            if ( vTable.NoGlowLibUpdate ) then return end

            v:SetKeyValue("model", glowData.GlowTexture or "sprites/light_glow02.vmt")
            v:SetKeyValue("scale", tostring(size))
            v:SetColor(col)
        end

        local postUpdate = glowData.PostUpdate and isfunction(glowData.PostUpdate) and glowData:PostUpdate(ent, glowEyes)
        if ( postUpdate != nil ) then
            glowData:PostUpdate(ent, glowEyes)
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

    if ( SERVER ) then
        if ( ent:IsPlayer() ) then
            net.Start("GlowLib:HideServerside")
            net.Send(ent)
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

    if ( !GlowLib:ShouldDraw(ent) ) then
        GlowLib:Hide(ent)

        return
    end

    local glow_eyes = ent:GetGlowingEyes()
    for k, v in ipairs(glow_eyes) do
        if ( IsValid(v) ) then
            v:SetNoDraw(false)
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

function GlowLib:ShouldDraw(ent)
    if ( CLIENT ) then
        local glib_enabled = GetConVar("cl_glowlib_enabled"):GetBool()
        if ( !glib_enabled ) then return false end
    end

    if ( !IsValid(ent) ) then return false end

    local model = ent:GetModel()
    if ( !model ) then return false end
    model = model:lower()

    local glowData = self.Glow_Data[model]
    if ( !glowData ) then return false end

    local entTable = ent:GetTable()
    if ( entTable.NoGlowLib ) then return false end

    if ( glowData["ShouldDraw"] ) then
        if ( !glowData:ShouldDraw(ent) ) then return false end
    end

    if ( ent:IsPlayer() ) then print("DAD") end

    if ( !ent:GetNW2Bool("GlowLib:ShouldDraw", true) ) then return false end
    if ( ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() ) and ent:Health() <= 0 and !entTable.GlowLib_IgnoreHealth ) then return false end
    if ( ent:GetNoDraw() ) then return false end

    if ( CLIENT ) then
        if ( ent == LocalPlayer() ) then
            local shouldDrawLocalPlayer = ent:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ent) or false
            if ( !shouldDrawLocalPlayer or ent:GetNoDraw() ) then
                return false
            end
        end

        if ( ent:GetClass() == "class C_BaseFlex" ) then
            return false
        end
    else
        if ( ent:IsPlayer() ) then
            if ( ent:GetNoDraw() ) then
                return false
            end

            net.Start("GlowLib:HideServerside")
            net.Send(ent)
        end
    end

    return true
end