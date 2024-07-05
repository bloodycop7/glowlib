local GlowLib = GlowLib

local function initGlow(ent)
    if ( !SERVER ) then return end

    if ( !IsValid(ent) ) then return end
    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEye = ent:GetGlowingEye()
    if ( IsValid(glowEye) ) then return end

    GlowLib:Initialize(ent)
end

local function updateGlow(ent)
    if ( !SERVER ) then return end

    if ( !IsValid(ent) ) then return end
    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEye = ent:GetGlowingEye()
    if ( !IsValid(glowEye) ) then return end

    local saveData = ent:GetTable()
    if ( !saveData ) then return end

    local updModel, updSkin, updMaterials, updBodygroups = false, false, false, false
    if ( !saveData.GlowLib_Model or saveData.GlowLib_Model != model ) then
        saveData.GlowLib_Model = model
        updModel = true
    end

    if ( !saveData.GlowLib_Skin or saveData.GlowLib_Skin != ent:GetSkin() ) then
        saveData.GlowLib_Skin = ent:GetSkin()
        updSkin = true
    end

    if ( !saveData.GlowLib_Materials or saveData.GlowLib_Materials != ent:GetMaterials() ) then
        saveData.GlowLib_Materials = ent:GetMaterials()
        updMaterials = true
    end

    if ( !saveData.GlowLib_Bodygroups or saveData.GlowLib_Bodygroups != ent:GetBodyGroups() ) then
        saveData.GlowLib_Bodygroups = ent:GetBodyGroups()
        updBodygroups = true
    end

    if ( updModel or updSkin or updMaterials or updBodygroups ) then
        GlowLib:Update(ent)
    end
end

local nextThinkSV = 0
hook.Add("Think", "GlowLib:Think_SV", function()
    if ( !SERVER ) then return end
    if ( nextThinkSV > CurTime() ) then return end
    nextThinkSV = CurTime() + 1

    local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
    if ( !sv_enabled ) then return end

    for k, v in ents.Iterator() do
        if ( !IsValid(v) ) then continue end

        local model = v:GetModel()
        if ( !model ) then continue end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then
            GlowLib:Remove(v)
            continue
        end

        if ( v:GetNoDraw() ) then
            GlowLib:Hide(v)
            continue
        end

        if ( v:Health() <= 0 ) then
            GlowLib:Remove(v)
            continue
        end

        local glowEye = v:GetGlowingEye()
        if ( IsValid(glowEye) ) then
            updateGlow(v)
        else
            initGlow(v)
        end
    end
end)

local nextThinkCL = 0
hook.Add("Think", "GlowLib:Think_CL", function()
    if ( !CLIENT ) then return end
    if ( nextThinkCL > CurTime() ) then return end
    nextThinkCL = CurTime() + 1

    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return end

    local glib_enabled = GetConVar("cl_glowlib_enabled"):GetBool()
    if ( !glib_enabled ) then return end

    local shouldDrawLocalPlayer = ply:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ply)
    local ownGlowEyes = ply:GetGlowingEye()
    if ( IsValid(ownGlowEyes) ) then
        if ( shouldDrawLocalPlayer ) then
            GlowLib:Show(ply)
        else
            GlowLib:Hide(ply)
        end
    end

    for k, v in ents.Iterator() do
        if ( !IsValid(v) ) then continue end

        local model = v:GetModel()
        if ( !model ) then continue end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then continue end

        if ( v == ply ) then continue end

        if ( v:GetNoDraw() ) then
            GlowLib:Hide(v)
            continue
        end

        local glowEye = v:GetGlowingEye()
        if ( IsValid(glowEye) ) then
            GlowLib:Show(v)
        end
    end
end)

hook.Add("DoPlayerDeath", "GlowLib:DoPlayerDeath", function(ply)
    if ( !IsValid(ply) ) then return end

    local model = ply:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowData = GlowLib.Glow_Data[model]
    if ( !glowData ) then return end

    local ownGlowEyes = ply:GetGlowingEye()
    if ( IsValid(ownGlowEyes) ) then
        GlowLib:Remove(ply)
    end
end)