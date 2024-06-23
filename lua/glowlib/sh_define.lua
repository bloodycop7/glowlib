local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Size = 0.2,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(180, 100, 25)
    },
    ColorAlpha = 120,
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Size = 0.2,
    Color = {
        [0] = Color(255, 200, 0),
        [1] = Color(255, 70, 0)
    },
    ColorAlpha = 120,
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    AttachmentOffset = function(ent)
        return ent:GetUp() * 1
    end,
    Size = 0.15,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 150,
})

GlowLib:Define("models/combine_scanner.mdl", {
    AttachmentOffset = function(self)
        return self:GetForward() * -0.5
    end,
    Size = 0.2,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})