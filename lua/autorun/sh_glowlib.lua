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
hook.Add("OnReloaded", "GlowLib:Reload", function()
    GlowLib:IncludeDir("glowlib")
end)

if ( SERVER ) then
    util.AddNetworkString("GlowLib:SendData")

    function GlowLib:SendData()
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
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

            local model = v:GetModel()
            if not ( model ) then
                return
            end

            if ( v == ply ) then
                continue
            end

            if not ( IsValid(v:GetGlowingEye()) ) then
                continue
            end

            print(v:GetGlowingEye())
        end
    end)
end

if ( CLIENT ) then
    MsgC(Color(255, 100, 0), "[ GlowLib ] by eon (bloodycop)", color_white, " has been loaded!\n")
end