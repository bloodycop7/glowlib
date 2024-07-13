local GlowLib = GlowLib

if ( CLIENT ) then
    CreateClientConVar("cl_glowlib_enabled", "1", true, false, "Enable or disable GlowLib", 0, 1)
    CreateClientConVar("cl_glowlib_dynamiclights", "1", true, false, "Enable or disable dynamic lights", 0, 1)
else
    CreateConVar("sv_glowlib_enabled", "1", {FCVAR_ARCHIVE, FCVAR_GAMEDLL}, "Enable or disable GlowLib", 0, 1)
end

cvars.AddChangeCallback("sv_glowlib_enabled", function(_, _, newValue)
    if ( !SERVER ) then return end

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

cvars.AddChangeCallback("cl_glowlib_dynamiclights", function(_, _, newValue)
    if ( newValue == "0" ) then
        for k, v in ents.Iterator() do
            if ( !IsValid(v) ) then continue end
            if ( !v:GetNW2Bool("GlowLib_HasDynamicLight", false) ) then continue end

            v:SetNW2Bool("GlowLib_HasDynamicLight", false)
        end
    end
end)