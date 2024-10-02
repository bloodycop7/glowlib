local GlowLib = GlowLib

if ( !CLIENT ) then return end

file.CreateDir("glowlib")
file.CreateDir("glowlib/presets")

function GlowLib:ShowEditMenu(ent)
    if ( IsValid(self.editMenu) ) then
        self.editMenu:Remove()
    end

    self.editMenu = vgui.Create("DFrame")
    self.editMenu:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self.editMenu:Center()
    self.editMenu:SetTitle("GlowLib Edit Menu")
    self.editMenu:MakePopup()
    self.editMenu.editingEnt = ent

    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return self.editMenu:Remove() end
    if ( !hook.Run("GlowLib_CanUseEditMenu", ply, ent, self.editMenu) ) then return self.editMenu:Remove() end

    local glowingEyes = ent:GetGlowingEyes()

    self.editMenu.leftPanel = self.editMenu:Add("DPanel")
    self.editMenu.leftPanel:Dock(LEFT)
    self.editMenu.leftPanel:SetWide(self.editMenu:GetWide() / 4)
    self.editMenu.leftPanel:SetBackgroundColor(color_black)
    self.editMenu.leftPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, 225))
    end

    local model = self.editMenu.leftPanel:Add("DModelPanel")
    model:Dock(FILL)
    model:SetTall(self.editMenu.leftPanel:GetTall() / 2)
    model:SetModel(ent:GetModel(), ent:GetSkin())
    model:SetFOV(10)

    local entModel = model.Entity
    if ( IsValid(entModel) ) then
        entModel:SetPos(Vector(-100, -100, -15))

        local bodygroups = ent:GetBodyGroups()
        for k, v in ipairs(bodygroups) do
            local bgID = v.id
            local bgName = v.name
            local bgValue = ent:GetBodygroup(bgID)

            entModel:SetBodygroup(bgID, bgValue)
        end
    end

    function model:LayoutEntity(entReal)
        entReal:SetAngles(Angle(0, 45, 0))
    end

    self.editMenu.rightPanel = self.editMenu:Add("DScrollPanel")
    self.editMenu.rightPanel:Dock(FILL)
    self.editMenu.rightPanel.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(color_black, 240))
    end

    local data = {}
    local files, folders = file.Find("glowlib/presets/*", "DATA")

    for k, v in ipairs(glowingEyes) do
        local scale = math.Round(v:GetInternalVariable("m_flSpriteScale", true), 2)

        data[v] = {}
        data[v]["size"] = scale
        data[v]["color"] = v:GetColor()

        local label = self.editMenu.rightPanel:Add("DLabel")
        label:Dock(TOP)
        label:SetText("Glowing Eye #" .. k)
        label:SetTextColor(color_white)
        label:SetFont("HudDefault")
        label:SetContentAlignment(5)
        label:SizeToContents()

        local glowSize = self.editMenu.rightPanel:Add("DTextEntry")
        glowSize:Dock(TOP)
        glowSize:SetTall(20)
        glowSize:SetText(data[v]["size"])
        glowSize:SetNumeric(true)
        glowSize:SetFont("HudDefault")
        glowSize:SetUpdateOnType(true)
        glowSize:SizeToContents()

        glowSize.OnChange = function(s)
            if ( !IsValid(ent) ) then return end
            if ( !IsValid(v) ) then return end
            if ( !data[v] ) then return end

            data[v]["size"] = tonumber(s:GetText())
        end

        local glowColor = self.editMenu.rightPanel:Add("DColorMixer")
        glowColor:Dock(TOP)
        glowColor:SetTall(250)
        glowColor:SetPalette(true)
        glowColor:SetAlphaBar(true)
        glowColor:SetWangs(true)
        glowColor:SetColor(data[v]["color"])
        glowColor:SizeToContents()

        glowColor.ValueChanged = function(s, color)
            if ( !IsValid(ent) ) then return end
            if ( !IsValid(v) ) then return end
            if ( !data[v] ) then return end

            data[v]["color"] = color
        end

        local saveButton = self.editMenu.rightPanel:Add("DButton")
        saveButton:Dock(TOP)
        saveButton:SetText("Save")
        saveButton:SetFont("HudDefault")
        saveButton:SetTall(30)
        saveButton.DoClick = function(s)
            if ( !IsValid(ent) ) then return end
            if ( !IsValid(v) ) then return end
            if ( !data[v] ) then return end

            net.Start("GlowLib:EditMenu:Save")
                net.WriteEntity(ent)
                net.WriteEntity(v)
                net.WriteTable(data[v])
            net.SendToServer()
        end

        local savePreset = self.editMenu.rightPanel:Add("DButton")
        savePreset:Dock(TOP)
        savePreset:SetText("Save Preset")
        savePreset:SetFont("HudDefault")
        savePreset:SetTall(30)
        savePreset.DoClick = function(s)
            if ( !IsValid(ent) ) then return end
            if ( !IsValid(v) ) then return end
            if ( !data[v] ) then return end

            local preset = Derma_StringRequest("Save Preset", "Enter a name for the preset", "", function(text)
                if ( !text or text == "" ) then return end

                local presetData = data[v]
                local presetPath = "glowlib/presets/" .. text .. ".txt"

                file.Write(presetPath, util.TableToJSON(presetData, true))
            end)
        end

        local loadPreset = self.editMenu.rightPanel:Add("DComboBox")
        loadPreset:Dock(TOP)
        loadPreset:SetTall(20)
        loadPreset:SetValue("Load Preset")
        loadPreset:SetFont("HudDefault")
        loadPreset:SetContentAlignment(5)

        for k, v in ipairs(files) do
            loadPreset:AddChoice(v)
        end

        loadPreset.OnSelect = function(s, index, value, data)
            local presetPath = "glowlib/presets/" .. value
            local presetData = util.JSONToTable(file.Read(presetPath, "DATA"))

            glowSize:SetText(presetData["size"])
            glowColor:SetColor(presetData["color"])
        end

        saveButton:SizeToContents()
    end
end

if ( IsValid(GlowLib.editMenu) ) then
    local ent = GlowLib.editMenu.editingEnt

    GlowLib.editMenu:Remove()
    GlowLib:ShowEditMenu(ent)
end