local GlowLib = GlowLib

properties.Add("glowlib_edit", {
    MenuLabel = "GlowLib Edit",
    Order = 999,
    MenuIcon = "icon16/wrench.png",
    Filter = function(self, ent, ply)
        if ( !IsValid(ply) ) then return false end
        if ( !IsValid(ent) ) then return false end
        if ( !ply:IsAdmin() ) then return false end

        if ( !ent.GetGlowingEyes ) then return false end

        local glowEyes = ent:GetGlowingEyes()
        if ( !glowEyes ) then return false end
        if ( #glowEyes == 0 ) then return false end

        return true
    end,
    Action = function(self, ent)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end
        if ( !IsValid(ent) ) then return end

        if ( !self:Filter(ent, ply) ) then return end

        GlowLib:ShowEditMenu(ent)
    end
})