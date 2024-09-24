local ENTITY = FindMetaTable("Entity")

function ENTITY:GetGlowingEyes()
    local eyes = {}

    for k, v in ipairs(self:GetChildren()) do
        if ( !IsValid(v) ) then continue end

        if ( v:GetNW2String("GlowEyeName", "") == "GlowLib_Eye_" .. self:EntIndex() ) then
            table.insert(eyes, v)
        end
    end

    return eyes
end