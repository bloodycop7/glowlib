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

    GlowLib:Hook("PlayerSpawnedNPC", "CreateEntityEyes", function(ply, ent)
        initFunc(ent)
    end)

    GlowLib:Hook("PlayerSpawnedRagdoll", "CreateRagdollEyes", function(ply, model, ent)
        initFunc(ent)
    end)

    GlowLib:Hook("PlayerLoadout", "CreatePlayerEyes", function(ply)
        initFunc(ply, 1)
    end)

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

    GlowLib.nextThinkRun = 0
    GlowLib:Hook("Think", "UpdateEyes", function()
        if ( GlowLib.nextThinkRun > CurTime() ) then
            return
        end

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            if ( hook.Run("GlowLib:ShouldDraw", v) == false ) then
                continue
            end

            if ( v:GetNoDraw() ) then
                GlowLib:Hide(v)
            else
                GlowLib:Show(v)
            end

            local lastModel, lastSkin = v:GetNW2String("glowlib_lastModel", ""), v:GetNW2Int("glowlib_lastSkin", 0)
            local lastBodygroups, lastMaterials = v.glow_lib_lastBodygroups or "", v.glow_lib_lastMaterials or ""

            if ( lastModel == v:GetModel() and lastSkin == v:GetSkin() and lastBodygroups == table.ToString(v:GetBodyGroups()) and lastMaterials == table.ToString(v:GetMaterials()) ) then
                continue
            end

            v:SetNW2String("glowlib_lastModel", v:GetModel())
            v:SetNW2Int("glowlib_lastSkin", v:GetSkin())
            v.glow_lib_lastBodygroups = table.ToString(v:GetBodyGroups())
            v.glow_lib_lastMaterials = table.ToString(v:GetMaterials())

            GlowLib:Initialize(v)
        end

        GlowLib:SendData()
        GlowLib.nextThinkRun = CurTime() + 1
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
end