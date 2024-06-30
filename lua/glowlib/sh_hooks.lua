local GlowLib = GlowLib

if ( SERVER ) then
    local function initFunc(ent, timeOverride)
        if not ( IsValid(ent) ) then
            return
        end

        timeOverride = timeOverride or 0.3

        timer.Simple(timeOverride, function()
            if not ( IsValid(ent) ) then
                return
            end

            GlowLib:Initialize(ent)
        end)
    end

    local function checkForEntities(ent)
        if not ( IsValid(ent) ) then
            continue
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            continue
        end

        if ( IsValid(ent:GetGlowingEye()) ) then
            continue
        end

        initFunc(ent, 0.1)
    end

    local function updateEntities(ent)
        if not ( IsValid(ent) ) then
            continue
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            continue
        end

        local model = ent:GetModel()
        if not ( model ) then
            continue
        end

        model = model:lower()
        local glowData = GlowLib.Glow_Data[model]

        if not ( glowData ) then
            if ( IsValid(ent:GetGlowingEye()) ) then
                GlowLib:Remove(ent)
            end

            continue
        end

        if ( hook.Run("GlowLib:ShouldDraw", ent) == false ) then
            if ( IsValid(ent:GetGlowingEye()) ) then
                GlowLib:Hide(ent)
            end

            continue
        end

        local lastModel, lastSkin = ent:GetNW2String("glowlib_lastModel", ""), ent:GetNW2Int("glowlib_lastSkin", 0)
        local lastBodygroups, lastMaterials = ent.glow_lib_lastBodygroups or "", ent.glow_lib_lastMaterials or ""
        local shouldPass = false

        if ( lastModel == ent:GetModel() and lastSkin == ent:GetSkin() and lastBodygroups == table.ToString(ent:GetBodyGroups()) and lastMaterials == table.ToString(ent:GetMaterials()) ) then
            shouldPass = true
        end

        if ( !IsValid(ent:GetGlowingEye()) ) then
            shouldPass = true
        end

        if ( shouldPass ) then
            continue
        end

        ent:SetNW2String("glowlib_lastModel", ent:GetModel())
        ent:SetNW2Int("glowlib_lastSkin", ent:GetSkin())
        ent.glow_lib_lastBodygroups = table.ToString(ent:GetBodyGroups())
        ent.glow_lib_lastMaterials = table.ToString(ent:GetMaterials())

        GlowLib:Initialize(ent)
        GlowLib:SendData()
    end

    GlowLib:Hook("PlayerDisconnected", "RemovePlayerEyes", function(ply)
        GlowLib:Remove(ply)
        GlowLib:SendData()
    end)

    GlowLib:Hook("OnReloaded", "RemoveAllEyes", function()
        GlowLib:RemoveAll()

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            GlowLib:Initialize(v)
        end
    end)

    local nextThink = 0
    GlowLib:Hook("Think", "UpdateEyes", function()
        if ( nextThink > CurTime() ) then
            return
        end

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            local model = v:GetModel()
            if not ( model ) then
                continue
            end

            checkForEntities(v)
            updateEntities(v)
        end

        nextThink = CurTime() + 1
    end)

    GlowLib:Hook("PlayerNoClip", "NoClipEyes", function(ply, state)
        if ( state ) then
            GlowLib:Hide(ply)
        else
            GlowLib:Show(ply)
        end
    end)

    GlowLib:Hook("DoPlayerDeath", "RemovePlayerEyes", function(ply)
        GlowLib:Remove(ply)
        GlowLib:SendData()
    end)

    GlowLib:Hook("GlowLib:ShouldDraw", "ShouldDrawHook", function(ent)
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
        if not ( sv_enabled ) then
            print("GlowLib is disabled.")
            return false
        end

        if ( ent:GetNoDraw() ) then
            return false
        end

        return true
    end)
end