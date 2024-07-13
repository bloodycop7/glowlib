GlowLib = GlowLib or {}
GlowLib.Glow_Data = {}
GlowLib.OutputColor = Color(255, 100, 0)

local fileFind, AddCSLuaFile, fileInclude = file.Find, AddCSLuaFile, include

function GlowLib:IncludeFile(fileName, realm)
    realm = (realm or ""):lower()
    fileName = fileName:lower()

    local realFileName = fileName:lower()
    if ( fileName:find("glowlib/") ) then
        realFileName = fileName:lower():gsub("glowlib/", "")
    end

    if ( ( realm:lower() == "server" or realFileName:find("sv_") ) and SERVER ) then
        return fileInclude(fileName)
	elseif ( realm:lower() == "shared" or realFileName:find("shared.lua") or realFileName:find("sh_") ) then
		if ( SERVER ) then
			AddCSLuaFile(fileName)
		end

		return fileInclude(fileName)
	elseif ( realm:lower() == "client" or realFileName:find("cl_") ) then
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
        return MsgC("GlowLib:Define - arg[1] entModel is a required argument!")
    end

    if not ( glowData ) then
        return print("GlowLib:Define - arg[2] glowData is a required argument!")
    end

    self.Glow_Data[entModel] = glowData
end

GlowLib:IncludeDir("glowlib")
hook.Add("OnReloaded", "GlowLib:Reload", function()
    GlowLib:IncludeDir("glowlib")
end)

if ( CLIENT ) then
    net.Receive("GlowLib:HideServerside", function(len)
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local bShouldDrawLocalPlayer = ply:ShouldDrawLocalPlayer() or hook.Run("ShouldDrawLocalPlayer", ply)
        if ( !bShouldDrawLocalPlayer ) then
            GlowLib:Hide(ply)
        else
            GlowLib:Show(ply)
        end
    end)

    local attachmentFormatOutput = "%s"
    concommand.Add("glowlib_print_attachments", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if ( !IsValid(ent) ) then return end

        local attachments = ent:GetAttachments()
        for k, v in ipairs(attachments) do
            MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Attachments ] ", color_white, attachmentFormatOutput:format(v.name), color_white, "\n")
        end
    end)

    MsgC(GlowLib.OutputColor, "[ GlowLib ] by eon ( bloodycop )", color_white, " has been loaded!\n")
else
    util.AddNetworkString("GlowLib:EditMenu:Save")
    util.AddNetworkString("GlowLib:HideServerside")

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

        ent.GlowLib_DisableUpdating = true

        local texture = data["texture"]
        local size = data["size"]
        local colorData = data["color"]

        local color = Color(colorData.r, colorData.g, colorData.b)
        color.a = color.a or 255

        sprite:SetKeyValue("model", tostring(texture))
        sprite:SetColor(color)
        sprite:SetKeyValue("scale", tostring(size))
    end)
end