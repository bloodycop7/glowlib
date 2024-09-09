local GlowLib = GlowLib

local function updateGlow(ent)
    if ( !SERVER ) then return end
    if ( !IsValid(ent) ) then return end

    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEyes = ent:GetGlowingEyes()
    if ( #glowEyes == 0 ) then
        GlowLib:Initialize(ent)

        return
    end

    GlowLib:Update(ent)
end

if ( SERVER ) then
    local nextThinkSV = 0
    hook.Add("Think", "GlowLib:Think_SV", function()
        if ( nextThinkSV > CurTime() ) then return end

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

            if ( !GlowLib:ShouldDraw(v) ) then
                GlowLib:Hide(v)

                if ( v:IsPlayer() ) then
                    print(v, "GUH")
                end

                continue
            end

            updateGlow(v)
            GlowLib:Show(v)
        end

        nextThinkSV = CurTime() + 1
    end)

    hook.Add("DoPlayerDeath", "GlowLib:DoPlayerDeath", function(ply)
        if ( !IsValid(ply) ) then return end

        local model = ply:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then return end

        GlowLib:Remove(ply)
    end)

    hook.Add("CreateEntityRagdoll", "GlowLib:EntityRagdollCreated", function(ent, ragdoll)
        if ( !IsValid(ent) or !IsValid(ragdoll) ) then return end

        timer.Simple(0, function()
            if ( !IsValid(ragdoll) ) then return end

            GlowLib:Initialize(ragdoll)

            local bRemoveOnDeath = GetConVar("sv_glowlib_remove_on_death"):GetBool()
            if ( bRemoveOnDeath ) then
                ragdoll:SetNW2Bool("GlowLib:ShouldDraw", false)
                GlowLib:Remove(ragdoll)

                return
            end

            net.Start("GlowLib:HideServersideRagdoll")
                net.WriteEntity(ragdoll)
            net.Broadcast()
        end)
    end)

    hook.Add("OnNPCKilled", "GlowLib:OnNPCKilled", function(npc, attacker, inflictor)
        if ( !IsValid(npc) ) then return end

        local model = npc:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then return end

        GlowLib:Remove(npc)
    end)
else
    local nextThinkCL = 0
    hook.Add("Think", "GlowLib:Think_CL", function()
        if ( nextThinkCL > CurTime() ) then return end

        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local glib_enabled = GetConVar("cl_glowlib_enabled"):GetBool()

        if ( !GlowLib:ShouldDraw(ply) ) then
            GlowLib:Hide(ply)
            nextThinkCL = CurTime() + 1

            return
        end

        for k, v in ents.Iterator() do
            if ( !IsValid(v) ) then continue end
            if ( v == ply ) then continue end

            local model = v:GetModel()
            if ( !model or model == "" ) then continue end
            model = model:lower()

            local glowData = GlowLib.Glow_Data[model]
            if ( !glowData ) then continue end

            v:SetNW2Bool("GlowLib:ShouldDraw", glib_enabled)

            if ( !GlowLib:ShouldDraw(v) ) then
                GlowLib:Hide(v)

                continue
            end

            print(v)
            GlowLib:Show(v)
        end

        nextThinkCL = CurTime() + 1
    end)
end