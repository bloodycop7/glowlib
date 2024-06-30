local GlowLib = GlowLib

GlowLib:Define("models/combine_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(0, 140, 255),
        [1] = Color(205, 75, 0)
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/combine_soldier_prisonguard.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 200, 0),
        [1] = Color(255, 70, 0)
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/combine_super_soldier.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/combine_scanner.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * -1
    end,
    Attachment = "eyes",
    Size = 0.25,
    Color = {
        [0] = Color(255, 135, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/vortigaunt.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 3
    end,
    Attachment = "eyes",
    Size = 0.25,
    Color = {
        [0] = Color(255, 95, 0),
    },
    ColorAlpha = 255,
})



GlowLib:Define("models/dpfilms/metropolice/hl2concept.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 1.55
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(0, 175, 255),
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/dpfilms/metropolice/civil_medic.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 1.55
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 230, 0),
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/dpfilms/metropolice/elite_police.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 1.55 - attachmentData.Ang:Right() * 0
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 230, 0),
    },
    ColorAlpha = 200,
})

GlowLib:Define("models/dpfilms/metropolice/phoenix_police.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 1.55
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})

GlowLib:Define("models/dpfilms/metropolice/police_bt.mdl", {
    Position = function(self, ent)
        local attachmentData = ent:GetAttachment(ent:LookupAttachment("eyes"))
        return attachmentData.Pos + attachmentData.Ang:Forward() * 1.55
    end,
    Attachment = "eyes",
    Size = 0.2,
    Color = {
        [0] = Color(255, 0, 0),
    },
    ColorAlpha = 255,
})