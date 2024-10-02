if ( SERVER ) then
    util.AddNetworkString("GlowLib:EditMenu:Save")
    util.AddNetworkString("GlowLib:HideServerside")
    util.AddNetworkString("GlowLib:HandleClientsideRagdoll")
    util.AddNetworkString("GlowLib:ClientsideInitalize")

    net.Receive("GlowLib:EditMenu:Save", function(len, ply)
        if ( !IsValid(ply) ) then return end

        local ent = net.ReadEntity()
        local sprite = net.ReadEntity()
        local data = net.ReadTable()

        if ( !hook.Run("GlowLib_CanPerformEdit", ply, ent, sprite, data) ) then return end

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
else
    net.Receive("GlowLib:HideServerside", function(len)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        if ( !GlowLib:ShouldDraw(ply) ) then
            GlowLib:Hide(ply)
        end
    end)

    net.Receive("GlowLib:HandleClientsideRagdoll", function(len)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local ent = net.ReadEntity()
        if ( !IsValid(ent) ) then return end

        local cl_glowLib = GetConVar("cl_glowlib_remove_on_death"):GetBool()
        if ( !GlowLib:ShouldDraw(ent) or cl_glowLib and ent:GetNW2Bool("GlowLib:IsNPCRagdoll", false) ) then
            ent:SetNW2Bool("GlowLib:ShouldDraw", false)
            ent:SetNW2Bool("GlowLib:IsNPCRagdoll", true)

            GlowLib:Hide(ent)
        end
    end)

    net.Receive("GlowLib:ClientsideInitalize", function()
        local ent = net.ReadEntity()
        if ( !IsValid(ent) ) then return end

        local model = ent:GetModel()
        if ( !model or model == "" ) then return end

        model = model:lower()

        local glow_data = GlowLib.Glow_Data[model]
        if ( !glow_data ) then return end

        if ( glow_data.OnInitialize and isfunction(glow_data.OnInitialize) ) then
            glow_data:OnInitialize(ent, ent:GetGlowingEyes()[1])
        end

        hook.Run("GlowLib_Initalize", ent)
    end)
end