local GlowLib = GlowLib

if ( !CLIENT ) then return end

file.CreateDir("glowlib")
file.CreateDir("glowlib/presets")

local color_gray = Color(50, 50, 50)
local color_green = Color(0, 150, 0)

local extraOptions = {
    {"Don't draw if Ragdoll", "if ( ent:IsRagdoll() ) then\n\t\t\treturn false\n\t\tend"},
    {"Don't draw if Player", "if ( ent:IsPlayer() ) then\n\t\t\treturn false\n\t\tend"},
    {"Don't draw if NPC", "if ( ent:IsNPC() ) then\n\t\t\treturn false\n\t\tend"},
    {"Use Player Color (Makes the \"Color\" table useless for player entities.)", "if ( ent:IsPlayer() ) then\n\t\t\treturn ent:GetPlayerColor():ToColor()\n\t\tend"}
}

local moreGlowingEyes = {
    [[OnInitialize = function(self, ent, sprite)
        if ( !IsValid(ent) ) then return end

        local glow_color = self.Color[ent:GetSkin()] or self.Color[0] or color_white

        local glowColCustom = self.CustomColor and isfunction(self.CustomColor) and self:CustomColor(ent, glow_color)
        if ( glowColCustom != nil ) then
            glow_color = self:CustomColor(ent, glow_color)
        end

        local attach = ent:LookupAttachment("other_attachment") // REPLACE
        local attachmentData = ent:GetAttachment(attach)
        if ( !attachmentData ) then return end

        local sprite = GlowLib:CreateSprite(ent, {
            Color = glow_color,
            Attachment = "other_attachment", // REPLACE
            Position = attachmentData.Pos + attachmentData.Ang:Forward() * -4 + attachmentData.Ang:Right() * 1 + attachmentData.Ang:Up() * 1, // You may need to change this, depends on the model.
            Size = 0.3, // You can change this
        })
end]]
}

function GlowLib:ShowCreatingMenu()
    if ( IsValid(self.creationMenu) ) then
        self.creationMenu:Remove()
    end

    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return self:Remove() end
    if ( !ply:IsAdmin() ) then return self:Remove() end

    self.creationMenu = vgui.Create("DFrame")
    self.creationMenu:SetSize(ScrW() * 0.35, ScrH() * 0.6)
    self.creationMenu:Center()
    self.creationMenu:SetTitle("GlowLib Creation Menu")
    self.creationMenu:MakePopup()

    local cMenu = self.creationMenu

    cMenu.leftPanel = cMenu:Add("DPanel")
    cMenu.leftPanel:Dock(LEFT)
    cMenu.leftPanel:SetWide(cMenu:GetWide() / 3)
    cMenu.leftPanel:SetBackgroundColor(color_black)

    cMenu.leftPanel.ent = cMenu.leftPanel:Add("DAdjustableModelPanel")
    cMenu.leftPanel.ent:Dock(FILL)
    cMenu.leftPanel.ent:SetModel("")
    cMenu.leftPanel.ent:SetFOV(30)
    function cMenu.leftPanel.ent:LayoutEntity(ent)
        ent:SetAngles(Angle(0, 45, 0))

        local sequence = ent:SelectWeightedSequence(ACT_IDLE)
		if (sequence <= 0) then
			sequence = ent:LookupSequence("idle_unarmed")
		end

		if ( sequence > 0 ) then
			ent:ResetSequence(sequence)
		else
			local found = false

			for k, v in ipairs(ent:GetSequenceList()) do
				if ( ( v:lower():find("idle") or v:lower():find("fly") ) and v != "idlenoise" ) then
					ent:ResetSequence(v)
					found = true

					break
				end
			end

			if ( !found ) then
				ent:ResetSequence(4)
			end
		end
    end

    cMenu.data = {
        model = "",
        color = color_white,
        size = 0.3,
        texture = "sprites/light_glow02.vmt",
        attachment = "other_attachment",
        extraOptions = {},
    }

    cMenu.model = cMenu:Add("DTextEntry")
    cMenu.model:Dock(TOP)
    cMenu.model:SetPlaceholderText("Enter model path...")
    cMenu.model:SetTall(20)
    cMenu.model:SetEnterAllowed(true)
    cMenu.model:SetUpdateOnType(true)
    cMenu.model:SetContentAlignment(5)
    cMenu.model.OnEnter = function(this)
        cMenu.data.model = this:GetValue()
        cMenu.leftPanel.ent:SetModel(this:GetValue())

        cMenu.options.attachmentList:Clear()

        for k, v in ipairs(cMenu.leftPanel.ent.Entity:GetAttachments()) do
            local attachment = cMenu.options.attachmentList:Add("DButton")
            attachment:Dock(TOP)
            attachment:DockMargin(5, 5, 5, 0)
            attachment:SetTall(15)
            attachment:SetText(v.name)
            attachment:SetFont("DermaDefault")
            attachment:SetTextColor(color_white)
            attachment:SetTooltip("Attachment ID: " .. v.id)
            attachment.DoClick = function()
                cMenu.data.attachment = v.name
            end
            attachment.Paint = function(s, w, h)
                surface.SetDrawColor(color_black)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end

            attachment.Think = function(this)
                if ( cMenu.data.attachment == v.name) then
                    this:SetTextColor(color_green)
                else
                    this:SetTextColor(color_white)
                end
            end
        end
    end

    cMenu.options = cMenu:Add("DPanel")
    cMenu.options:Dock(FILL)
    cMenu.options.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, color_gray)
    end

    cMenu.options.list = cMenu.options:Add("DScrollPanel")
    cMenu.options.list:Dock(TOP)
    cMenu.options.list:SetTall(20)
    cMenu.options.list.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, 225))
    end

    cMenu.options.list.label = cMenu.options.list:Add("DLabel")
    cMenu.options.list.label:Dock(TOP)
    cMenu.options.list.label:SetWide(100)
    cMenu.options.list.label:SetText("Options")
    cMenu.options.list.label:SetFont("DermaDefaultBold")
    cMenu.options.list.label:SetTextColor(color_white)
    cMenu.options.list.label:SetContentAlignment(5)

    // Color Mixer with skin support
    cMenu.options.colorMixer = cMenu.options:Add("DColorMixer")
    cMenu.options.colorMixer:Dock(TOP)
    cMenu.options.colorMixer:SetTall(200)
    cMenu.options.colorMixer:SetColor(color_white)
    cMenu.options.colorMixer:SetAlphaBar(true)
    cMenu.options.colorMixer:SetPalette(false)
    cMenu.options.colorMixer:SetWangs(false)

    cMenu.options.colorMixer.OnValueChanged = function(this, color)
        cMenu.data.color = color
    end

    cMenu.options.sizeText = cMenu.options:Add("DTextEntry")
    cMenu.options.sizeText:Dock(TOP)
    cMenu.options.sizeText:SetTall(20)
    cMenu.options.sizeText:SetPlaceholderText("Enter sprite size...")
    cMenu.options.sizeText:SetText("0.3")
    cMenu.options.sizeText:SetNumeric(true)
    cMenu.options.sizeText:SetUpdateOnType(true)
    cMenu.options.sizeText:SetContentAlignment(5)

    cMenu.options.sizeText.OnEnter = function(this)
        cMenu.data.size = tonumber(this:GetValue())
    end

    cMenu.options.spriteForwardOffset = cMenu.options:Add("DNumSlider")
    cMenu.options.spriteForwardOffset:Dock(TOP)
    cMenu.options.spriteForwardOffset:SetText("Sprite Forward Offset")
    cMenu.options.spriteForwardOffset:SetMin(-40)
    cMenu.options.spriteForwardOffset:SetMax(40)
    cMenu.options.spriteForwardOffset:SetDecimals(1)
    cMenu.options.spriteForwardOffset:SetValue(1)
    cMenu.options.spriteForwardOffset:SetTooltip("This is the front offset direction of the sprite from the attachment position. May not actually be forward for some models for some models.")

    cMenu.data.spriteForwardOffset = 1
    cMenu.options.spriteForwardOffset.OnValueChanged = function(this, value)
        cMenu.data.spriteForwardOffset = value
    end

    cMenu.options.spriteRightOffset = cMenu.options:Add("DNumSlider")
    cMenu.options.spriteRightOffset:Dock(TOP)
    cMenu.options.spriteRightOffset:SetText("Sprite Right Offset")
    cMenu.options.spriteRightOffset:SetMin(-40)
    cMenu.options.spriteRightOffset:SetMax(40)
    cMenu.options.spriteRightOffset:SetDecimals(1)
    cMenu.options.spriteRightOffset:SetValue(1)
    cMenu.options.spriteRightOffset:SetTooltip("This is the right offset direction of the sprite from the attachment position. May not actually be right for some models for some models.")

    cMenu.data.spriteRightOffset = 1
    cMenu.options.spriteRightOffset.OnValueChanged = function(this, value)
        cMenu.data.spriteRightOffset = value
    end

    cMenu.options.spriteUpOffset = cMenu.options:Add("DNumSlider")
    cMenu.options.spriteUpOffset:Dock(TOP)
    cMenu.options.spriteUpOffset:SetText("Sprite Up Offset")
    cMenu.options.spriteUpOffset:SetMin(-40)
    cMenu.options.spriteUpOffset:SetMax(40)
    cMenu.options.spriteUpOffset:SetDecimals(1)
    cMenu.options.spriteUpOffset:SetValue(1)
    cMenu.options.spriteUpOffset:SetTooltip("This is the up offset direction of the sprite from the attachment position. May not actually be up for some models for some models.")

    cMenu.data.spriteUpOffset = 1
    cMenu.options.spriteUpOffset.OnValueChanged = function(this, value)
        cMenu.data.spriteUpOffset = value
    end

    cMenu.options.textureText = cMenu.options:Add("DTextEntry")
    cMenu.options.textureText:Dock(TOP)
    cMenu.options.textureText:SetTall(20)
    cMenu.options.textureText:SetText("sprites/light_glow02.vmt")
    cMenu.options.textureText:SetUpdateOnType(true)
    cMenu.options.textureText:SetPlaceholderText("Enter texture path...")
    cMenu.options.textureText:SetContentAlignment(5)

    cMenu.options.textureText.OnEnter = function(this)
        cMenu.data.texture = this:GetValue()
    end

    for k, v in ipairs(extraOptions) do
        local option = cMenu.options:Add("DCheckBoxLabel")
        option:Dock(TOP)
        option:SetText(v[1])
        option:SetTextColor(color_white)
        option:SetFont("DermaDefault")
        option:SetContentAlignment(5)
        option:SetTooltip(v[2])
        option.OnChange = function(this, bool)
            cMenu.data.extraOptions[k] = bool
        end
    end

    cMenu.options.attachmentListLabel = cMenu.options:Add("DLabel")
    cMenu.options.attachmentListLabel:Dock(TOP)
    cMenu.options.attachmentListLabel:SetText("Attachments")
    cMenu.options.attachmentListLabel:SetFont("DermaDefaultBold")
    cMenu.options.attachmentListLabel:SetTextColor(color_white)
    cMenu.options.attachmentListLabel:SetContentAlignment(5)

    cMenu.options.attachmentList = cMenu.options:Add("DScrollPanel")
    cMenu.options.attachmentList:Dock(TOP)
    cMenu.options.attachmentList:SetTall(100)

    local function getCode(bCopy)
        bCopy = bCopy or false

        local model = cMenu.data.model
        local color = cMenu.data.color
        local size = cMenu.data.size
        local texture = cMenu.data.texture
        local sOF = math.Round(cMenu.data.spriteForwardOffset, 1)
        local sRO = math.Round(cMenu.data.spriteRightOffset, 1)
        local sUO = math.Round(cMenu.data.spriteUpOffset, 1)
        local extraOptionsData = cMenu.data.extraOptions

        local code = {'GlowLib:Define(\"' .. model .. '\", {'}
        table.insert(code, '\tAttachment = "' .. cMenu.data.attachment .. '",')
        table.insert(code, '\tPosition = function(self, ent)\n\t\tlocal attachmentData = ent:GetAttachment(ent:LookupAttachment("' .. cMenu.data.attachment .. '"))\n\n\t\treturn attachmentData.Pos + attachmentData.Ang:Forward() * ' .. sOF .. ' + attachmentData.Ang:Up() * ' .. sUO .. ' + attachmentData.Ang:Right() * ' .. sRO .. '\n\tend,')
        table.insert(code, '\tColor = {\n\t\t[0] = Color(' .. color.r .. ', ' .. color.g .. ', ' .. color.b .. ', ' .. color.a .. '), // [0] is the skin, do [1] = Color(200, 200, 200), for skin 1.\n\t},')
        table.insert(code, '\tSize = ' .. size .. ',')

        if ( texture != "sprites/light_glow02.vmt" ) then
            table.insert(code, '\tGlowTexture = "' .. texture .. '",')
        end

        if ( !table.IsEmpty(extraOptionsData) ) then
            table.insert(code, '\tShouldDraw = {\n\t\tif ( !IsValid(ent) ) then return false end\n')

            for k, v in ipairs(extraOptions) do
                if ( extraOptionsData[k] ) then
                    table.insert(code, '\t\t' .. v[2] .. '\n')
                end
            end

            table.insert(code, '\t},')
        end

        table.insert(code, '})')

        local codeStr = table.concat(code, "\n")
        MsgC(GlowLib.OutputColor, codeStr, "\n\n")

        if ( bCopy ) then
            SetClipboardText(codeStr)
        end

        chat.PlaySound()
    end

    cMenu.print = cMenu:Add("DButton")
    cMenu.print:Dock(BOTTOM)
    cMenu.print:SetText("Print Code")
    cMenu.print:SetTooltip("Left Click : Print Code\nRight Click : Print & Copy Code")
    cMenu.print.DoClick = function(this)
        getCode()
    end

    cMenu.print.DoRightClick = function(this)
        getCode(true)
    end

    cMenu.printMoreEyes = cMenu:Add("DButton")
    cMenu.printMoreEyes:Dock(BOTTOM)
    cMenu.printMoreEyes:SetText("Print More Eyes Code")
    cMenu.printMoreEyes:SetTooltip("Left Click : Print Code\nRight Click : Print & Copy Code")
    cMenu.printMoreEyes.DoClick = function(this)
        local codeStr = table.concat(moreGlowingEyes, "\n")
        MsgC(GlowLib.OutputColor, codeStr, "\n\n")

        chat.PlaySound()
    end

    cMenu.printMoreEyes.DoRightClick = function(this)
        local codeStr = table.concat(moreGlowingEyes, "\n")
        MsgC(GlowLib.OutputColor, codeStr, "\n\n")

        chat.PlaySound()
    end
end

if ( IsValid(GlowLib.creationMenu) ) then
    GlowLib.creationMenu:Remove()
    GlowLib:ShowCreatingMenu()
end

concommand.Add("cl_glowlib_creationmenu", function(ply)
    if ( !IsValid(ply) ) then return end
    if ( !ply:IsAdmin() ) then return end

    GlowLib:ShowCreatingMenu()
end)