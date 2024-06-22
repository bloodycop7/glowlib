CreateConVar("sv_glowlib_enabled", "1", {FCVAR_ARCHIVE, FCVAR_GAMEDLL}, "Enable or disable GlowLib", 0, 1)

if ( CLIENT ) then
    CreateClientConVar("cl_glowlib_enabled", "1", true, false, "Enable or disable GlowLib", 0, 1)
end

cvars.AddChangeCallback("sv_glowlib_enabled", function(_, _, newValue)
    if not ( SERVER ) then
        return
    end

    if ( newValue == "0" ) then
        GlowLib:RemoveAll()

        return
    end

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

cvars.AddChangeCallback("cl_glowlib_enabled", function(_, _, newValue)
    if ( newValue == "0" ) then
        GlowLib:HideAll()

        return
    end

    GlowLib:ShowAll()
end)