if ( CLIENT ) then
    CreateClientConVar("cl_glowlib_enabled", "1", true, false, "Enable or disable GlowLib", 0, 1)
    CreateClientConVar("cl_glowlib_keep_on_death", "1", true, false, "Keep glowing on death", 0, 1)
else
    CreateConVar("sv_glowlib_enabled", "1", {FCVAR_ARCHIVE, FCVAR_GAMEDLL}, "Enable or disable GlowLib", 0, 1)
end

cvars.AddChangeCallback("sv_glowlib_enabled", function(_, _, newValue)
    if not ( SERVER ) then
        return
    end

    if ( newValue == "0" ) then
        GlowLib:HideAll()

        return
    end

    GlowLib:ShowAll()
end)

cvars.AddChangeCallback("cl_glowlib_enabled", function(_, _, newValue)
    if ( newValue == "0" ) then
        GlowLib:HideAll()

        return
    end

    GlowLib:ShowAll()
end)