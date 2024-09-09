if ( SERVER ) then
    util.AddNetworkString("GlowLib:EditMenu:Save")
    util.AddNetworkString("GlowLib:HideServerside")
    util.AddNetworkString("GlowLib:HideServersideRagdoll")

    net.Receive("GlowLib:EditMenu:Save", function(len, ply)
        if ( !IsValid(ply) ) then return end
        if ( !ply:IsAdmin() ) then return end

        local ent = net.ReadEntity()
        local sprite = net.ReadEntity()
        local data = net.ReadTable()

        if ( !IsValid(ent) ) then return end
        if ( !IsValid(sprite) ) then return end
        if ( !data ) then return end

        local model = ent:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then return end

        local entTable = ent:GetTable()
        entTable.GlowLib_DisableUpdating = true

        local size = data["size"]
        local colorData = data["color"]

        sprite:SetColor(colorData)
        sprite:SetKeyValue("scale", tostring(size))
    end)
else
    net.Receive("GlowLib:HideServerside", function(len)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        if ( !GlowLib:ShouldDraw(ply) ) then
            GlowLib:Hide(ply)
        end
    end)

    net.Receive("GlowLib:HideServersideRagdoll", function(len)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local ent = net.ReadEntity()
        if ( !IsValid(ent) ) then return end

        local bRemoveOnDeath = GetConVar("cl_glowlib_remove_on_death"):GetBool()

        if ( bRemoveOnDeath ) then
            ent:SetNW2Bool("GlowLib:ShouldDraw", false)
            GlowLib:Hide(ent)
        end
    end)
end