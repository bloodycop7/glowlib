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
        net.Start("GlowLib:SendData")
            net.WriteTable(self.Entities)
        net.Broadcast()

        hook.Run("GlowLib:SendData")
    end
else
    net.Receive("GlowLib:SendData", function()
        local ply = LocalPlayer()
        if not ( IsValid(ply) ) then
            return
        end

        GlowLib.Entities = net.ReadTable()

        local glow_eyes = ply:GetNW2Entity("GlowLib_Eye", nil)
        if ( IsValid(glow_eyes) and ply:GetViewEntity() == ply ) then
            glow_eyes:SetNoDraw(true)
        end
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
end

MsgC("\n", Color(255, 95, 0), "GlowLib by eon (bloodycop) has been loaded!\n")