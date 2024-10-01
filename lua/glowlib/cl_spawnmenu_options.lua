local GlowLib = GlowLib

surface.CreateFont("GlowLib:MenuFontSmall", {
    font = "Arial",
    size = 16,
    weight = 800,
    antialias = true
})

surface.CreateFont("GlowLib:MenuFontLarge", {
    font = "Arial",
    size = 27,
    weight = 800,
    antialias = true
})

hook.Add("AddToolMenuCategories", "GlowLib:AddToolMenuCategories", function()
    spawnmenu.AddToolCategory("Utilities", "GlowLib", "#GlowLib")
end)

local panel_color_bg = Color(0, 0, 0, 230)

hook.Add("PopulateToolMenu", "GlowLib:PopulateToolMenu", function()
    spawnmenu.AddToolMenuOption("Utilities", "GlowLib", "GlowLib_Settings", "#Settings", "", "", function(panel)
		panel:ClearControls()

        panel.Paint = function(this, width, height)
            surface.SetDrawColor(panel_color_bg)
            surface.DrawRect(0, 0, width, height)
        end

        local glowlib_Label = panel:Help("GlowLib Settings")
        glowlib_Label:SetTextColor(color_white)
        glowlib_Label:SetFont("GlowLib:MenuFontLarge")

        local checkbox = panel:CheckBox("Enable GlowLib (Serverside)", "sv_glowlib_enabled")
        checkbox:SetTextColor(color_white)
        checkbox:SetFont("GlowLib:MenuFontSmall")

        local checkbox = panel:CheckBox("Remove Glowing Eyes On Death (Serverside)", "sv_glowlib_remove_on_death")
        checkbox:SetTextColor(color_white)
        checkbox:SetFont("GlowLib:MenuFontSmall")

        local checkbox = panel:CheckBox("Enable GlowLib (Clientside)", "cl_glowlib_enabled")
        checkbox:SetTextColor(color_white)
        checkbox:SetFont("GlowLib:MenuFontSmall")

        local checkbox = panel:CheckBox("Remove Glowing Eyes On Death (Clientside)", "cl_glowlib_remove_on_death")
        checkbox:SetTextColor(color_white)
        checkbox:SetFont("GlowLib:MenuFontSmall")
	end)
end)