local GlowLib = GlowLib

local function initGlow(ent)
    if ( !SERVER ) then return end

    if ( !IsValid(ent) ) then return end

    local model = ent:GetModel()
    if ( !model ) then return end
    model = model:lower()

    local glowEyes = ent:GetGlowingEyes()
    if ( #glowEyes == 0 ) then
        GlowLib:Initialize(ent)
    end
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

            if ( ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() ) and v:Health() <= 0 and !v.GlowLib_IgnoreHealth ) then
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

            GlowLib:Show(v)
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

        local shouldDrawLocalPlayer = ply:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ply) or false
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
            if ( v == ply ) then continue end

            local model = v:GetModel()
            if ( !model or model == "" ) then continue end
            model = model:lower()

            local glowData = GlowLib.Glow_Data[model]
            if ( !glowData ) then continue end

            if ( v:GetNoDraw() ) then
                GlowLib:Hide(v)

                continue
            end

            if ( v:GetClass() == "class C_BaseFlex" ) then continue end

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

        local glib_enabled = GetConVar("cl_glowlib_enabled"):GetBool()
        if ( !glib_enabled ) then return end

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

            if ( glowData.NoDynamicLight ) then v:SetNW2Bool("GlowLib_HasDynamicLight", false) continue end

            for k2, v2 in ipairs(glowEyes) do
                if ( !IsValid(v2) ) then continue end
                if ( v2:GetNoDraw() ) then v:SetNW2Bool("GlowLib_HasDynamicLight", false) continue end

                local dynLight = DynamicLight(v:EntIndex())
                if ( !dynLight ) then continue end

                local lightPos = glowData["DynamicLightPos"] and glowData:DynamicLightPos(v, v2)
                local lightColor = ( glowData["DynamicLightColor"] and glowData:DynamicLightColor(v, v2) ) or v2:GetColor()
                local lightBrightness = ( glowData["DynamicLightBrightness"] and glowData:DynamicLightBrightness(v, v2) ) or 3
                local lightSize = ( glowData["DynamicLightSize"] and glowData:DynamicLightSize(v, v2) ) or 20

                if ( !lightPos ) then
                    lightPos = v2:GetPos() + v2:GetAngles():Forward() * 2
                end

                dynLight.Pos = lightPos
                dynLight.r = lightColor.r
                dynLight.g = lightColor.g
                dynLight.b = lightColor.b
                dynLight.Brightness = lightBrightness
                dynLight.Size = lightSize
                dynLight.Decay = 1000
                dynLight.DieTime = CurTime() + 1

                v:SetNW2Bool("GlowLib_HasDynamicLight", true)
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