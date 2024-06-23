local ENTITY = FindMetaTable("Entity")

function ENTITY:GetGlowingEye()
    return self:GetNW2Entity("GlowLib_Eye", nil)
end
