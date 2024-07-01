local GlowLib = GlowLib

if ( SERVER ) then
    function GlowLib:Remove(ent)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            return
        end

        local glow_eye = ent:GetGlowingEye()
        if ( IsValid(glow_eye) ) then
            glow_eye:Remove()
        end

        ent:SetNW2Entity("GlowLib_Eye", nil)
        self.Entities[ent] = nil
        hook.Run("GlowLib:Remove", ent)
    end

    function GlowLib:RemoveAll()
        for k, v in ents.Iterator() do
            if not ( IsValid(v) ) then
                continue
            end

            if not ( v:IsPlayer() or v:IsNPC() or v:IsNextBot() or v:IsRagdoll() ) then
                continue
            end

            self:Remove(v)
        end

        hook.Run("GlowLib:RemoveAll")
    end

    function GlowLib:Initialize(ent)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            return
        end

        local glow_eye = ent:GetGlowingEye()
        if ( IsValid(glow_eye) ) then
            glow_eye:Remove()
        end

        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool() or true
        if not ( sv_enabled ) then
            return
        end

        local model = ent:GetModel()
        if not ( model ) then
            return
        end

        model = model:lower()
        local glowData = self.Glow_Data[model]

        if ( glowData ) then
            local glowCol = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
            local renderMode = glowData.RenderMode or 9
            local colAlpha = glowData.ColorAlpha or ( glowCol.a or 255 )
            local glow_mat = glowData.GlowTexture or "sprites/light_glow02_add_noz.vmt"
            local glow_size = glowData.Size or 2
            local vec_sprite = ( glowData["Position"] and glowData:Position(ent, glowData) ) or vector_origin
            local attach = ent:LookupAttachment(glowData.Attachment or "eyes")

            if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
                glowCol = glowData:CustomColor(ent, glowCol)
            end

            local sprite = ents.Create("env_sprite")
            sprite:SetPos(vec_sprite)
            sprite:SetParent(ent, attach or 0)
            sprite:SetKeyValue("model", tostring(glow_mat))
            sprite:SetKeyValue("rendercolor", tostring(glowCol))
            sprite:SetKeyValue("renderamt", tostring(colAlpha))
            sprite:SetKeyValue("rendermode", tostring(renderMode))
            sprite:SetKeyValue("HDRColorScale", "0.5")
            sprite:SetKeyValue("scale", tostring(glow_size))
            sprite:Spawn()

            ent:SetNW2Entity("GlowLib_Eye", sprite)
            self.Entities[ent] = sprite

            ent:DeleteOnRemove(sprite)
            ent:CallOnRemove("GlowLibRemove", function(this)
                self:Remove(this)
            end)

            if ( glowData["OnInitialize"] and isfunction(glowData["OnInitialize"]) and !ent.glowlib_hasBeenInitalized ) then
                glowData:OnInitialize(ent, sprite)
                ent.glowlib_hasBeenInitalized = true
            end

            hook.Run("GlowLib:Initalize", ent)
        end
    end
end

function GlowLib:Hide(ent)
    if not ( IsValid(ent) ) then
        return
    end

    if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
        return
    end

    local glow_eye = ent:GetGlowingEye()
    if ( IsValid(glow_eye) ) then
        glow_eye:SetNoDraw(true)
    end
end

function GlowLib:HideAll()
    for k, v in ents.Iterator() do
        if not ( IsValid(v) ) then
            continue
        end

        if not ( v:IsPlayer() or v:IsNPC() or v:IsNextBot() or v:IsRagdoll() ) then
            continue
        end

        self:Hide(v)
    end
end

function GlowLib:Show(ent)
    if not ( IsValid(ent) ) then
        return
    end

    if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
        return
    end

    local glow_eye = ent:GetGlowingEye()
    if ( IsValid(glow_eye) ) then
        glow_eye:SetNoDraw(false)
    end
end

function GlowLib:ShowAll()
    for k, v in ents.Iterator() do
        if not ( IsValid(v) ) then
            continue
        end

        if not ( v:IsPlayer() or v:IsNPC() or v:IsNextBot() or v:IsRagdoll() ) then
            continue
        end

        self:Show(v)
    end
end