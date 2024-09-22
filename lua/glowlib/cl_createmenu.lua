local GlowLib = GlowLib

if ( !CLIENT ) then return end

file.CreateDir("glowlib")
file.CreateDir("glowlib/presets")

local color_gray = Color(50, 50, 50)

function GlowLib:ShowCreatingMenu()
    if ( IsValid(self.creationMenu) ) then
        self.creationMenu:Remove()
    end

    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return self:Remove() end
    if ( !ply:IsAdmin() ) then return self:Remove() end

    self.creationMenu = vgui.Create("DFrame")
    self.creationMenu:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self.creationMenu:Center()
    self.creationMenu:SetTitle("GlowLib Creation Menu")
    self.creationMenu:MakePopup()
    self.creationMenu.editingEnt = ent

    self.creationMenu.glowEyeCount = 1
    self.creationMenu.eyeData = {}
    table.insert(self.creationMenu.eyeData, {color = color_white})

    self.leftPanel = self.creationMenu:Add("DPanel")
    self.leftPanel:Dock(LEFT)
    self.leftPanel:SetWide(self.creationMenu:GetWide() / 4)
    self.leftPanel:SetBackgroundColor(color_black)
    self.leftPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, 225))
    end

    self.leftPanel.modelLabel = self.leftPanel:Add("DLabel")
    self.leftPanel.modelLabel:Dock(TOP)
    self.leftPanel.modelLabel:SetTall(20)
    self.leftPanel.modelLabel:SetText("Model")
    self.leftPanel.modelLabel:SetTextColor(color_white)
    self.leftPanel.modelLabel:SetContentAlignment(4)

    self.leftPanel.modelEntry = self.leftPanel.modelLabel:Add("DTextEntry")
    self.leftPanel.modelEntry:Dock(RIGHT)
    self.leftPanel.modelEntry:SetTall(20)
    self.leftPanel.modelEntry:SetWide(self.leftPanel:GetWide() - self.leftPanel.modelLabel:GetWide())
    self.leftPanel.modelEntry:SetText("models/combine_soldier.mdl")
    self.leftPanel.modelEntry:SetPlaceholderText("Enter model path here...")
    self.leftPanel.modelEntry:SetTextColor(color_white)
    self.leftPanel.modelEntry:SetEnterAllowed(true)
    self.leftPanel.modelEntry:SetUpdateOnType(false)
    self.leftPanel.modelEntry:SetTextColor(color_black)

    self.leftPanel.modelEntry.OnEnter = function(s, value)
        local modelPath = value:lower()
        if ( !modelPath or modelPath == "" ) then return end

        local model = self.leftPanel.modelPreview

        if ( IsValid(model) ) then
            model:SetModel(modelPath, 0)

            if ( IsValid(model.Entity) and model.Entity:LookupBone("ValveBiped.Bip01_Head1") ) then
                local eyePos = model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
                if ( eyePos ) then
                    eyePos:Add(Vector(0, 0, 2))

                    model:SetLookAt(eyePos)
                    model:SetCamPos(eyePos - Vector(-12, 0, 0))	-- Move cam in front of eyes

                    model.Entity:SetEyeTarget(eyePos - Vector(-12, 0, 0))
                end
            end
        end
    end

    self.leftPanel.modelPreview = self.leftPanel:Add("DAdjustableModelPanel")
    self.leftPanel.modelPreview:Dock(FILL)
    self.leftPanel.modelPreview:SetModel("models/combine_soldier.mdl", 0)
    self.leftPanel.modelPreview:SetFirstPerson(true)

    function self.leftPanel.modelPreview:LayoutEntity(ent)
		local sequence = ent:SelectWeightedSequence(ACT_IDLE)
		if (sequence <= 0) then
			sequence = ent:LookupSequence("idle_unarmed")
		end

		if (sequence > 0) then
			ent:ResetSequence(sequence)
		else
			local found = false

            for i = 0, ent:GetSequenceCount() do
                local name = ent:GetSequenceName(i)

                if (name:lower():find("idle") or name:lower():find("fly")) then
                    ent:ResetSequence(i)
                    found = true

                    break
                end
            end

			if ( !found ) then
				ent:ResetSequence(4)
			end
		end
    end

    self.rightPanel = self.creationMenu:Add("DPanel")
    self.rightPanel:Dock(FILL)
    self.rightPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, color_gray)
    end

    local function updateGlowCount()
        self.rightPanel.scroll:Clear()

        for i = 1, self.creationMenu.glowEyeCount do
            local glowEyeLabel = self.rightPanel.scroll:Add("DLabel")
            glowEyeLabel:Dock(TOP)
            glowEyeLabel:SetText("Glowing Eye #" .. i)
            glowEyeLabel:SetContentAlignment(5)
            glowEyeLabel:SetTextColor(color_white)
            glowEyeLabel:SetFont("Trebuchet24")
            glowEyeLabel:SizeToContents()

            local glowPanel = self.rightPanel.scroll:Add("DPanel")
            glowPanel:Dock(TOP)
            glowPanel:SetTall(150)

            local glowEyeColor = self.rightPanel.scroll:Add("DColorMixer")
            glowEyeColor:Dock(TOP)
            glowEyeColor:SetTall(150)
            glowEyeColor:SetPalette(false)
            glowEyeColor:SetAlphaBar(true)
            glowEyeColor:SetWangs(true)
            glowEyeColor:SetColor(color_white)
            glowEyeColor:SizeToContents()

            glowEyeColor.ValueChanged = function(s, color)
                self.creationMenu.eyeData[i].color = color
            end
        end
    end

    self.rightPanel.scroll = self.rightPanel:Add("DScrollPanel")
    self.rightPanel.scroll:Dock(FILL)

    self.rightPanel.button1 = self.rightPanel:Add("DButton")
    self.rightPanel.button1:Dock(TOP)
    self.rightPanel.button1:SetTall(25)
    self.rightPanel.button1:SetText("Add Glowing Eye")
    self.rightPanel.button1:SetTextColor(color_white)
    self.rightPanel.button1:SetFont("DermaDefault")
    self.rightPanel.button1:SetContentAlignment(5)
    self.rightPanel.button1.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, color_black)
    end

    self.rightPanel.button1.DoClick = function(s)
        self.creationMenu.glowEyeCount = self.creationMenu.glowEyeCount + 1
        self.creationMenu.eyeData[self.creationMenu.glowEyeCount] = {}

        if ( self.creationMenu.glowEyeCount == 1 ) then
            self.rightPanel.button2:SetDisabled(true)
        else
            self.rightPanel.button2:SetDisabled(false)
        end

        updateGlowCount()
    end

    self.rightPanel.button2 = self.rightPanel:Add("DButton")
    self.rightPanel.button2:Dock(TOP)
    self.rightPanel.button2:SetTall(25)
    self.rightPanel.button2:SetText("Remove Glowing Eye")
    self.rightPanel.button2:SetTextColor(color_white)
    self.rightPanel.button2:SetFont("DermaDefault")
    self.rightPanel.button2:SetContentAlignment(5)
    self.rightPanel.button2.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, color_black)
    end

    self.rightPanel.button2.DoClick = function(s)
        self.creationMenu.eyeData[self.creationMenu.glowEyeCount] = nil
        self.creationMenu.glowEyeCount = math.max(1, self.creationMenu.glowEyeCount - 1)

        if ( self.creationMenu.glowEyeCount == 1 ) then
            s:SetDisabled(true)
        else
            s:SetDisabled(false)
        end

        updateGlowCount()
    end

    updateGlowCount()
end

if ( IsValid(GlowLib.creationMenu) ) then
    GlowLib.creationMenu:Remove()
    GlowLib:ShowCreatingMenu()
end

concommand.Add("glowlib_create", function()
    GlowLib:ShowCreatingMenu()
end)