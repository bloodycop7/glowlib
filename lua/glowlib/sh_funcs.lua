local GlowLib = GlowLib

if ( SERVER ) then
    function GlowLib:Remove(ent)
        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            return
        end

        local glow_eye = ent:GetNW2Entity("GlowLib_Eye", nil)
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

            if not ( IsValid(v:GetNW2Entity("GlowLib_Eye", nil)) ) then
                continue
            end

            self:Remove(v)
        end

        hook.Run("GlowLib:RemoveAll")
    end

    function GlowLib:Initialize(ent)
        local sv_enabled = GetConVar("sv_glowlib_enabled"):GetBool() or true
        if not ( sv_enabled ) then
            return
        end

        if not ( IsValid(ent) ) then
            return
        end

        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() or ent:IsRagdoll() ) then
            return
        end

        local model = ent:GetModel()
        if not ( model ) then
            return
        end

        model = model:lower()
        local glowData = self.Glow_Data[model]

        local glow_eye = ent:GetNW2Entity("GlowLib_Eye", nil)
        if ( IsValid(glow_eye) ) then
            glow_eye:Remove()
        end

        if ( glowData ) then
            local glowCol = glowData.Color[ent:GetSkin()] or glowData.Color[0] or color_white
            local renderMode = glowData.RenderMode or 9
            local colAlpha = glowData.ColorAlpha or glowCol.a
            local glow_mat = glowData.GlowTexture or "sprites/light_glow02_add_noz.vmt"
            local glow_size = glowData.Size or 2
            local vec_sprite = ( glowData["Position"] and glowData["Position"](ent) ) or vector_origin
            local attach_vec = ( glowData["AttachmentOffset"] and glowData["AttachmentOffset"](ent) ) or vector_origin
            local glow_attach = ent:LookupAttachment(glowData.Attachment or "eyes")
            local glow_attach_data = ent:GetAttachment(glow_attach)

            if ( glowData["CustomColor"] and isfunction(glowData["CustomColor"]) ) then
                glowCol = glowData["CustomColor"](ent, glowCol)
            end

            local sprite = ents.Create("env_sprite")
            sprite:SetPos( ( glow_attach_data.Pos + attach_vec ) or vec_sprite)
            sprite:SetParent(ent, glow_attach)
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

    local glow_eye = ent:GetNW2Entity("GlowLib_Eye", nil)
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

    local glow_eye = ent:GetNW2Entity("GlowLib_Eye", nil)
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