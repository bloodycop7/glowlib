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
    for _, fileName in ipairs(files) do
        self:IncludeFile(dir .. "/" .. fileName)
    end

    for _, folder in ipairs(folders) do
        self:IncludeDir(dir .. "/" .. folder)
    end
end

function GlowLib:IncludeCreations()
    local files, folders = fileFind("autorun/glowlib_creations/*", "LUA")

    for _, fileName in ipairs(files) do
        GlowLib:IncludeFile("autorun/glowlib_creations/" .. fileName)
    end

    for _, folder in ipairs(folders) do
        self:IncludeDir("autorun/glowlib_creations/" .. folder)
    end
end

function GlowLib:Define(entModel, glowData)
    if not ( entModel ) then
        return MsgC("GlowLib:Define - arg[1] entModel is a required argument!")
    end

    if not ( glowData ) then
        return print("GlowLib:Define - arg[2] glowData is a required argument!")
    end

    self.Glow_Data[entModel:lower()] = glowData
end

GlowLib:IncludeDir("glowlib")
GlowLib:IncludeCreations()

hook.Add("OnReloaded", "GlowLib:Reload", function()
    GlowLib:IncludeDir("glowlib")
    GlowLib:IncludeCreations()
end)

if ( CLIENT ) then
    local attachmentFormatOutput = "%s ( %s )"
    concommand.Add("cl_glowlib_print_attachments", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if ( !IsValid(ent) ) then return end

        local attachments = ent:GetAttachments()
        for k, v in ipairs(attachments) do
            MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Attachments ] ", color_white, attachmentFormatOutput:format(v.name, v.id), color_white, "\n")
        end
    end)

    local bodygroupsFormatOutput = "%s ( %s ) - %s"
    concommand.Add("cl_glowlib_print_bodygroups", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if ( !IsValid(ent) ) then return end

        local bodygroups = ent:GetBodyGroups()
        for k, v in ipairs(bodygroups) do
            if ( k == 1 ) then continue end

            MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Bodygroups ] ", color_white, bodygroupsFormatOutput:format(v.name, k - 1, ent:GetBodygroup(k)), color_white, "\n")
        end
    end)

    local boneFormatOutput = "%s ( %s )"
    concommand.Add("cl_glowlib_print_bones", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if ( !IsValid(ent) ) then return end

        local bones = ent:GetBoneCount()
        for i = 0, bones - 1 do
            MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Bones ] ", color_white, boneFormatOutput:format(ent:GetBoneName(i), i), color_white, "\n")
        end
    end)

    local childrenFormatOutput = "%s ( Entity(%s) ) %s"
    concommand.Add("cl_glowlib_print_children", function()
        local ent = LocalPlayer():GetEyeTrace().Entity
        if ( !IsValid(ent) ) then return end

        for k, v in ipairs(ent:GetChildren()) do
            if !IsValid(v) then continue end

            local addText = ""

            if ( v:GetNW2Bool("bIsGlowLib", false) ) then
                addText = "( GlowLib )"
            end

            MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Children ] ", color_white, childrenFormatOutput:format(v:GetClass(), v:EntIndex(), addText), color_white, "\n")
        end
    end)

    local toggle3D2D = false
    concommand.Add("cl_glowlib_toggle_3d2d", function()
        toggle3D2D = !toggle3D2D

        if ( toggle3D2D ) then
            return MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ 3D2D ] ", color_white, "3D2D has been enabled!\n")
        end

        MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ 3D2D ] ", color_white, "3D2D has been disabled!\n")
    end)

    local toggleShowAttachmentPos = false
    local attachmentToShow
    concommand.Add("cl_glowlib_toggle_show_attachment_pos", function(ply, cmd, args)
        toggleShowAttachmentPos = !toggleShowAttachmentPos

        if ( toggleShowAttachmentPos ) then
            return MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Attachment Pos ] ", color_white, "Attachment positions have been enabled!\n")
        end

        MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Attachment Pos ] ", color_white, "Attachment positions have been disabled!\n")
    end)

    concommand.Add("cl_glowlib_set_attachment_pos", function(ply, cmd, args)
        if !args or !args[1] or args[1] == "" then
            return MsgC(GlowLib.OutputColor, "[ GlowLib ] [ Debugging ] [ Attachment Pos ] ", color_white, "Please provide an attachment name!\n")
        end

        attachmentToShow = args[1]
    end)

    hook.Add("HUDPaint", "GlowLib:TextDev", function()
        local ply = LocalPlayer()
        if ( !IsValid(ply) ) then return end

        local ent = ply:GetEyeTrace().Entity
        if ( toggle3D2D ) then
            if ( !IsValid(ent) ) then return end

            local model = ent:GetModel()
            if ( !model ) then return end
            model = model:lower()

            local glowData = GlowLib.Glow_Data[model]
            if ( !glowData ) then return end

            local add = ""

            for k, v in ipairs(ent:GetChildren()) do
                if ( !IsValid(v) ) then continue end
                if ( v:GetClass() != "env_sprite" ) then continue end

                local pos = v:GetPos():ToScreen()
                draw.SimpleText("Sprite" .. ( v:GetNW2Bool("bIsGlowLib", false) and " ( GlowLib )" or "" ), "DermaDefault", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        if toggleShowAttachmentPos then
            if !attachmentToShow then return end

            if ( attachmentToShow == "*" ) then
                local attachments = ent:GetAttachments()
                for k, v in ipairs(attachments) do
                    local attachment_data = ent:GetAttachment(v.id)
                    if !attachment_data then return end

                    local pos = attachment_data.Pos:ToScreen()
                    draw.SimpleText("Attachment " .. v.name, "DermaDefault", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                return
            end

            local attachment = ent:LookupAttachment(attachmentToShow)
            if !attachment then return end

            local attachment_data = ent:GetAttachment(attachment)
            if !attachment_data then return end

            local pos = attachment_data.Pos:ToScreen()
            draw.SimpleText("Attachment " .. attachmentToShow, "DermaDefault", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)

    MsgC(GlowLib.OutputColor, "[ GlowLib ] by eon ( bloodycop )", color_white, " has been loaded!\n")
else
    file.CreateDir("glowlib")
end