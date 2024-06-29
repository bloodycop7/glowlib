local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(180, 100, 25)
    },
    ColorAlpha = 120,
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Position = function(ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 200, 0),
        [1] = Color(255, 70, 0)
    },
    ColorAlpha = 120,
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    Position = function(ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.15,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 150,
})

GlowLib:Define("models/combine_scanner.mdl", {
    Position = function(ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 135, 0),
    },
    ColorAlpha = 255,
})