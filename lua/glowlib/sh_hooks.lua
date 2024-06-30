local GlowLib = GlowLib

if ( SERVER ) then
    local function initFunc(ent, timeOverride)
        if not ( IsValid(ent) ) then
            return
        end

        timeOverride = timeOverride or 0.3

        timer.Simple(timeOverride, function()
            if not ( IsValid(ent) ) then
                return
            end

            GlowLib:Initialize(ent)
        end)
    end

    local function checkForEntities(ent, glowData, glowEyes)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            return
        end

        if ( IsValid(ent:GetGlowingEye()) ) then
            return
        end

        initFunc(ent, 0.1)
    end

    local function updateEntities(ent, glowData, glowEyes)
        local saveTable = ent:GetTable()
        if ( !saveTable ) then return end

        local last_mdl = saveTable.GlowLib_LastModel or ""
        local model = ent:GetModel()

        local last_skin = saveTable.GlowLib_LastSkin or 0
        local skinEnt = ent:GetSkin()

        local last_bodygroups = table.ToString(saveTable.GlowLib_LastBodygroups or {}) or ""
        local bodygroups = table.ToString(ent:GetBodyGroups() or {}) or ""

        local last_mats = table.ToString(saveTable.GlowLib_LastMaterials or {}) or ""
        local materials = table.ToString(ent:GetMaterials() or {}) or ""

        local modelChanged, skinChanged, bodygroupsChanged, materialsChanged, colorIsChanged = false, false, false, false, false
        if ( IsValid(glowEyes) ) then
            local glowEyeColor = glowEyes:GetColor()
            local spriteColor = saveTable.GlowLib_LastSpriteColor or color_white
            local spriteAlpha = spriteColor.a or 255

            if ( glowData["CustomColor"] ) then
                glowEyeColor = glowData:CustomColor(ent, glowEyeColor)
            end

            if ( glowEyeColor != spriteColor or glowEyeColor.a != spriteColor.a ) then
                colorIsChanged = true
            end
        end

        if ( last_mdl != model ) then
            modelChanged = true
        end

        if ( last_skin != skinEnt ) then
            skinChanged = true
        end

        if ( last_bodygroups != bodygroups ) then
            bodygroupsChanged = true
        end

        if ( last_mats != materials ) then
            materialsChanged = true
        end

        local shouldReNew = false
        if ( modelChanged or skinChanged or bodygroupsChanged or materialsChanged or colorIsChanged ) then
            shouldReNew = true
        end

        if ( shouldReNew ) then
            GlowLib:Remove(ent)
            GlowLib:Initialize(ent)
        end

        saveTable.GlowLib_LastModel = ent:GetModel()
        saveTable.GlowLib_LastSkin = ent:GetSkin()
        saveTable.GlowLib_LastMaterials = ent:GetMaterials()
        saveTable.GlowLib_LastBodygroups = ent:GetBodyGroups()
        if ( IsValid(glowEyes) ) then
            saveTable.GlowLib_LastSpriteColor = glowEyes:GetColor()
        end

        GlowLib:SendData()
    end

    GlowLib:Hook("PlayerDisconnected", "RemovePlayerEyes", function(ply)
        GlowLib:Remove(ply)
        GlowLib:SendData()
    end)

    GlowLib:Hook("OnReloaded", "RemoveAllEyes", function()
        GlowLib:RemoveAll()

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            GlowLib:Initialize(v)
        end
    end)

    local nextThink = 0
    GlowLib:Hook("Think", "UpdateEyes", function()
        if ( nextThink > CurTime() ) then
            return
        end

        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsNPC() or v:IsPlayer() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            local model = v:GetModel()
            if not ( model ) then
                print("No model")
                continue
            end

            model = model:lower()
            local glowData = GlowLib.Glow_Data[model]
            local glowEyes = v:GetGlowingEye()

            if not ( glowData ) then
                GlowLib:Remove(v)

                continue
            end

            if ( hook.Run("GlowLib:ShouldDraw", v) == false ) then
                if ( IsValid(glowEyes) ) then
                    GlowLib:Hide(v)
                end

                continue
            end

            checkForEntities(v, glowData, glowEyes)
            updateEntities(v, glowData, glowEyes)
        end

        nextThink = CurTime() + 1
    end)

    GlowLib:Hook("PlayerNoClip", "NoClipEyes", function(ply, state)
        if ( state ) then
            GlowLib:Hide(ply)
        else
            GlowLib:Show(ply)
        end
    end)

    GlowLib:Hook("DoPlayerDeath", "RemovePlayerEyes", function(ply)
        GlowLib:Remove(ply)
        GlowLib:SendData()
    end)

    GlowLib:Hook("GlowLib:ShouldDraw", "ShouldDrawHook", function(ent)
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool()
        if not ( sv_enabled ) then
            return false
        end

        if ( ent:GetNoDraw() ) then
            return false
        end

        return true
    end)
end