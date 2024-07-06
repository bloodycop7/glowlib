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

            local glowEye = v:GetGlowingEye()
            if ( IsValid(glowEye) ) then
                updateGlow(v)
            else
                initGlow(v)
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

            if ( v:GetNoDraw() ) then
                GlowLib:Hide(v)
                continue
            end

            if ( v == ply ) then continue end

            if ( glowData["ShouldDraw"] and !glowData["ShouldDraw"](glowData, v) ) then
                GlowLib:Hide(v)

                continue
            end

            local glowEye = v:GetGlowingEye()
            if ( IsValid(glowEye) ) then
                GlowLib:Show(v)
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

            local glowEye = v:GetGlowingEye()
            if ( !IsValid(glowEye) ) then continue end
            if ( glowEye:GetNoDraw() ) then continue end

            local dynLight = DynamicLight(v:EntIndex())
            if ( !dynLight ) then continue end

            dynLight.Pos = glowEye:GetPos() + glowEye:GetAngles():Forward() * 0.3
            dynLight.r = glowEye:GetColor().r
            dynLight.g = glowEye:GetColor().g
            dynLight.b = glowEye:GetColor().b
            dynLight.Brightness = 1
            dynLight.Size = 20
            dynLight.Decay = 1000 / 1
            dynLight.DieTime = CurTime() + 1
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

    local ownGlowEyes = ply:GetGlowingEye()
    if ( IsValid(ownGlowEyes) ) then
        GlowLib:Remove(ply)
    end
end)