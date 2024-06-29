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

    timer.Create("GlowLib:CheckForEntity", 1, 0, function()
        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            if ( IsValid(v:GetNW2Entity("GlowLib_Eye", nil)) ) then
                continue
            end

            initFunc(v, 0.1)
        end
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
                return
            end

            model = model:lower()
            local glowData = GlowLib.Glow_Data[model]

            if ( hook.Run("GlowLib:ShouldDraw", v) == false ) then
                if ( IsValid(v:GetNW2Entity("GlowLib_Eye", nil)) ) then
                    GlowLib:Hide(v)
                end

                continue
            end

            local lastModel, lastSkin = v:GetNW2String("glowlib_lastModel", ""), v:GetNW2Int("glowlib_lastSkin", 0)
            local lastBodygroups, lastMaterials = v.glow_lib_lastBodygroups or "", v.glow_lib_lastMaterials or ""

            if ( ( lastModel == v:GetModel() and lastSkin == v:GetSkin() and lastBodygroups == table.ToString(v:GetBodyGroups()) and lastMaterials == table.ToString(v:GetMaterials()) ) or glowData and !IsValid(v:GetNW2Entity("GlowLib_Eye", nil)) ) then
                continue
            end

            v:SetNW2String("glowlib_lastModel", v:GetModel())
            v:SetNW2Int("glowlib_lastSkin", v:GetSkin())
            v.glow_lib_lastBodygroups = table.ToString(v:GetBodyGroups())
            v.glow_lib_lastMaterials = table.ToString(v:GetMaterials())

            GlowLib:Initialize(v)
            GlowLib:SendData()
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
        if ( ent:GetNoDraw() ) then
            return false
        end

        return true
    end)
end