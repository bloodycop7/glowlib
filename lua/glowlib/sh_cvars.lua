local GlowLib = GlowLib

if ( CLIENT ) then
    CreateClientConVar("cl_glowlib_enabled", "1", true, false, "Enable or disable GlowLib", 0, 1)
    CreateClientConVar("cl_glowlib_remove_on_death", "1", true, false, "Remove glowing eyes on death (NPCs)", 0, 1)
else
    CreateConVar("sv_glowlib_enabled", "1", {FCVAR_ARCHIVE, FCVAR_GAMEDLL}, "Enable or disable GlowLib", 0, 1)
    CreateConVar("sv_glowlib_remove_on_death", "1", {FCVAR_ARCHIVE, FCVAR_GAMEDLL}, "Enable or disable removing Glowing Eyes On Death (NPCs)", 0, 1)
end

cvars.AddChangeCallback("sv_glowlib_enabled", function(_, _, newValue)
    if ( !SERVER ) then return end

    if ( newValue == "0" ) then
        for k, v in ipairs(GlowLib:GetAllEntities()) do
            if ( !IsValid(v) ) then continue end

            v:SetNW2Bool("GlowLib:ShouldDraw", false)
        end

        GlowLib:HideAll()

        return
    end

    for k, v in ipairs(GlowLib:GetAllEntities()) do
        if ( !IsValid(v) ) then continue end

        v:SetNW2Bool("GlowLib:ShouldDraw", true)
    end

    GlowLib:ShowAll()
end)

cvars.AddChangeCallback("sv_glowlib_remove_on_death", function(_, _, newValue)
    if ( !SERVER ) then return end

    if ( newValue == "1" ) then
        for k, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
            if ( !IsValid(ragdoll) ) then continue end

            ragdoll:SetNW2Bool("GlowLib:ShouldDraw", false)
            GlowLib:Remove(ragdoll)
        end

        return
    end

    for k, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
        if ( !IsValid(ragdoll) ) then continue end

        ragdoll:SetNW2Bool("GlowLib:ShouldDraw", true)
    end
end)

cvars.AddChangeCallback("cl_glowlib_enabled", function(_, _, newValue)
    if ( newValue == "0" ) then
        for k, v in ipairs(GlowLib:GetAllEntities()) do
            if ( !IsValid(v) ) then continue end

            v:SetNW2Bool("GlowLib:ShouldDraw", false)
        end

        GlowLib:HideAll()

        return
    end

    for k, v in ipairs(GlowLib:GetAllEntities()) do
        if ( !IsValid(v) ) then continue end

        v:SetNW2Bool("GlowLib:ShouldDraw", true)
    end

    GlowLib:ShowAll()
end)

cvars.AddChangeCallback("cl_glowlib_remove_on_death", function(_, _, newValue)
    if ( newValue == "1" ) then
        for k, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
            if ( !IsValid(ragdoll) ) then continue end

            ragdoll:SetNW2Bool("GlowLib:ShouldDraw", false)
            GlowLib:Hide(ragdoll)
        end

        return
    end

    for k, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
        if ( !IsValid(ragdoll) ) then continue end

        ragdoll:SetNW2Bool("GlowLib:ShouldDraw", true)
        GlowLib:Show(ragdoll)
    end
end)