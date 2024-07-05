local GlowLib = GlowLib

if ( SERVER ) then
    local function initGlow(ent)
        if ( !IsValid(ent) ) then return end
        local model = ent:GetModel()
        if ( !model ) then return end

        local glowEye = ent:GetGlowingEye()
        if ( IsValid(glowEye) ) then return end

        GlowLib:Initialize(ent)
    end

    local function updateGlow(ent)
        if ( !IsValid(ent) ) then return end
        local model = ent:GetModel()
        if ( !model ) then return end

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
end

GlowLib:Hook("GlowLib:ShouldDraw", "ShouldDrawHook", function(ent)
    if ( !IsValid(ent) ) then return false end
    if ( SERVER ) then
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
        if not ( sv_enabled ) then
            return false
        end
    end

    if ( CLIENT ) then
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        if ( !ply:ShouldDrawLocalPlayer() or !hook.Run("ShouldDrawLocalPlayer", ply) ) then
            return false
        end

        if ( ent:Health() <= 0 ) then
            local cl_keep_on_death = GetConVar("cl_glowlib_keep_on_death"):GetBool()
            if not ( cl_keep_on_death ) then
                return false
            end
        end
    end

    if ( ent:GetNoDraw() ) then
        return false
    end

    return true
end)