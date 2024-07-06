local GlowLib = GlowLib

local function initGlow(ent)
    if ( !SERVER ) then return end

    if ( !IsValid(ent) ) then return end

    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEye = ent:GetGlowingEyes()

    GlowLib:Initialize(ent)
end

local function updateGlow(ent)
    if ( !SERVER ) then return end

    if ( !IsValid(ent) ) then return end
    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEyes = ent:GetGlowingEyes()
    if ( #glowEyes == 0 ) then return end

    GlowLib:Update(ent)
end

if ( SERVER ) then
    local nextThinkSV = 0
    hook.Add("Think", "GlowLib:Think_SV", function()
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

            if ( ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() ) and v:Health() <= 0 ) then
                GlowLib:Remove(v)

                continue
            end

            if ( glowData["ShouldDraw"] and !glowData["ShouldDraw"](glowData, v) ) then
                GlowLib:Hide(v)

                continue
            end

            local glowEyes = v:GetGlowingEyes()
            if ( #glowEyes == 0 ) then
                initGlow(v)

                continue
            end

            for k2, v2 in ipairs(glowEyes) do
                if ( IsValid(v2) ) then
                    updateGlow(v)
                end
            end
        end
    end)
else
    local nextThinkCL = 0
    hook.Add("Think", "GlowLib:Think_CL", function()
        if ( nextThinkCL > CurTime() ) then return end
        nextThinkCL = CurTime() + 1

        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local glib_enabled = GetConVar("cl_glowlib_enabled"):GetBool()
        if ( !glib_enabled ) then return end

        local shouldDrawLocalPlayer = ply:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ply)
        local ownGlowEyes = ply:GetGlowingEyes()
        for k, v in ipairs(ownGlowEyes) do
            if ( IsValid(v) ) then
                if ( shouldDrawLocalPlayer ) then
                    GlowLib:Show(ply)
                else
                    GlowLib:Hide(ply)
                end
            end
        end

        for k, v in ents.Iterator() do
            if ( !IsValid(v) ) then continue end

            local model = v:GetModel()
            if ( !model ) then continue end
            model = model:lower()

            local glowData = GlowLib.Glow_Data[model]
            if ( !glowData ) then continue end

            if ( v:GetNoDraw() ) then
                GlowLib:Hide(v)
                continue
            end

            if ( v == ply ) then continue end

            if ( glowData["ShouldDraw"] and !glowData["ShouldDraw"](glowData, v) ) then
                GlowLib:Hide(v)

                continue
            end

            local glowEyes = v:GetGlowingEyes()
            for k2, v2 in ipairs(glowEyes) do
                if ( IsValid(v2) ) then
                    GlowLib:Show(v)
                end
            end
        end
    end)

    hook.Add("Think", "GlowLib:DynamicLight", function()
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local enabled = GetConVar("cl_glowlib_dynamiclights"):GetBool()
        if ( !enabled ) then return end

        for k, v in ents.Iterator() do
            if ( !IsValid(v) ) then continue end

            local model = v:GetModel()
            if ( !model ) then continue end
            model = model:lower()

            local glowData = GlowLib.Glow_Data[model]
            if ( !glowData ) then continue end

            local glowEyes = v:GetGlowingEyes()
            if ( #glowEyes == 0 ) then continue end

            for k2, v2 in ipairs(glowEyes) do
                if ( v2:GetNoDraw() ) then continue end

                local dynLight = DynamicLight(v:EntIndex())
                if ( !dynLight ) then continue end

                dynLight.Pos = v2:GetPos() + v2:GetAngles():Forward() * 0.3
                dynLight.r = v2:GetColor().r
                dynLight.g = v2:GetColor().g
                dynLight.b = v2:GetColor().b
                dynLight.Brightness = 1
                dynLight.Size = 20
                dynLight.Decay = 1000 / 1
                dynLight.DieTime = CurTime() + 1
            end
        end
    end)
end

hook.Add("DoPlayerDeath", "GlowLib:DoPlayerDeath", function(ply)
    if ( !IsValid(ply) ) then return end

    local model = ply:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowData = GlowLib.Glow_Data[model]
    if ( !glowData ) then return end

    local ownGlowEyes = ply:GetGlowingEyes()
    for k, v in ipairs(ownGlowEyes) do
        if ( IsValid(v) ) then
            GlowLib:Remove(ply)
        end
    end
end)