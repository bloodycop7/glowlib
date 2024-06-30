GlowLib = GlowLib or {}
GlowLib.Entities = GlowLib.Entities or {}
GlowLib.Glow_Data = GlowLib.Glow_Data or {}

local fileFind, AddCSLuaFile, fileInclude = file.Find, AddCSLuaFile, include

function GlowLib:IncludeFile(fileName, realm)
    realm = (realm or "shared"):lower()

    if ( ( realm:lower() == "server" or fileName:lower():find("sv_") ) and SERVER ) then
        return fileInclude(fileName)
	elseif ( realm:lower() == "shared" or fileName:lower():find("shared.lua") or fileName:lower():find("sh_") ) then
		if ( SERVER ) then
			AddCSLuaFile(fileName)
		end

		return fileInclude(fileName)
	elseif ( realm:lower() == "client" or fileName:find("cl_") ) then
		if ( SERVER ) then
			AddCSLuaFile(fileName)
		else
			return fileInclude(fileName)
		end
	end
end

function GlowLib:IncludeDir(dir)
    local files, folders = fileFind(dir .. "/*", "LUA")
    for _, file in ipairs(files) do
        self:IncludeFile(dir .. "/" .. file)
    end

    for _, folder in ipairs(folders) do
        self:IncludeDir(dir .. "/" .. folder)
    end
end

local hookAdd = hook.Add
function GlowLib:Hook(hookName, hookIdentifier, hookFunc)
    if not ( hookName ) then
        return print("GlowLib:Hook - hookName is a required argument [1]")
    end

    if not ( hookIdentifier ) then
        return print("GlowLib:Hook - hookIdentifier is a required argument [2]")
    end

    hookFunc = hookFunc or function()
        print(hookName, hookFunc, "Does not have a proper function argument [3]")
    end

    hookAdd(hookName, "GlowLib:" .. hookIdentifier, hookFunc)
end

function GlowLib:Define(entModel, glowData)
    if not ( entModel ) then
        return print("GlowLib:Define - entModel is a required argument [1]")
    end

    if not ( glowData ) then
        return print("GlowLib:Define - glowData is a required argument [2]")
    end

    self.Glow_Data[entModel] = glowData
end

GlowLib:IncludeDir("glowlib")
GlowLib:Hook("OnReloaded", "GlowLibReload", function()
    GlowLib:IncludeDir("glowlib")
end)

if ( SERVER ) then
    util.AddNetworkString("GlowLib:SendData")

    function GlowLib:SendData()
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool() or true
        if not ( sv_enabled ) then
            self:HideAll()
            return
        end

        net.Start("GlowLib:SendData")
            net.WriteTable(self.Entities)
        net.Broadcast()

        hook.Run("GlowLib:SendData")
    end
else
    net.Receive("GlowLib:SendData", function()
        GlowLib.Entities = net.ReadTable()
    end)

    local nextThink = 0
    GlowLib:Hook("Think", "ClearEyesClientside", function()
        if ( nextThink > CurTime() ) then
            return
        end

        local ply = LocalPlayer()
        if not ( IsValid(ply) ) then
            return
        end

        local cl_enabled = GetConVar("cl_glowlib_enabled"):GetBool() or true
        if not ( cl_enabled ) then
            GlowLib:HideAll()
        end

        local glow_eyes = ply:GetGlowingEye()
        if ( IsValid(glow_eyes) and hook.Run("ShouldDrawLocalPlayer", ply) == false ) then
            glow_eyes:SetNoDraw(true)
        end

        nextThink = CurTime() + 1
    end)

    concommand.Add("glowlib_print_attachments", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if not ( IsValid(ent) ) then
            return
        end

        local attachments = ent:GetAttachments()
        for k, v in ipairs(attachments) do
            print(k, v.name)
        end
    end)

    concommand.Add("glowlib_goto_nearest", function(ply)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            if ( v == ply ) then
                continue
            end

            if not ( v:GetGlowingEye() ) then
                continue
            end

            print(v:GetGlowingEye())
        end
    end)
end

MsgC("\n", Color(255, 95, 0), "GlowLib by eon (bloodycop) has been loaded!\n")