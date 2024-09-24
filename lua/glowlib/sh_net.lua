if ( SERVER ) then
    util.AddNetworkString("GlowLib:EditMenu:Save")
    util.AddNetworkString("GlowLib:HideServerside")
    util.AddNetworkString("GlowLib:HideServersideRagdoll")
    util.AddNetworkString("GlowLib:CreationMenu:SaveCreation")

    net.Receive("GlowLib:EditMenu:Save", function(len, ply)
        if ( !IsValid(ply) ) then return end

        local ent = net.ReadEntity()
        local sprite = net.ReadEntity()
        local data = net.ReadTable()

        if ( !hook.Run("GlowLib:CanPerformEdit", ply, ent, sprite, data) ) then return end

        if ( !IsValid(ent) ) then return end
        if ( !IsValid(sprite) ) then return end
        if ( !data ) then return end

        local model = ent:GetModel()
        if ( !model ) then return end
        model = model:lower()

        local glowData = GlowLib.Glow_Data[model]
        if ( !glowData ) then return end

        local entTable = ent:GetTable()
        entTable.GlowLib_bDontUpdate = true

        local data_size = data["size"]
        local data_color = data["color"]

        sprite:SetColor(data_color)
        sprite:SetKeyValue("scale", tostring(data_size))
    end)

    net.Receive("GlowLib:CreationMenu:SaveCreation", function(len, ply)
        if ( !IsValid(ply) ) then return end
        if ( !ply:IsAdmin() ) then return end

        local model = net.ReadString()
        local data = net.ReadTable()

        if ( !model or model == "" ) then return end
        if ( !data ) then return end

        model = model:lower()

        local creationCount = 1
        for k, v in ipairs(file.Find("glowlib/creations/*", "DATA")) do
            creationCount = creationCount + 1
        end

        file.Write("glowlib/creations/" .. creationCount .. "creation.txt", util.TableToJSON(data, true))
        print("Saved creation for " .. model)

        GlowLib:IncludeCreations()
        BroadcastLua([[GlowLib:IncludeCreations()]])
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