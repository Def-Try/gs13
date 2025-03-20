hook.Add("PreDrawHUD", "GS13_BODY_MakeBlind", function()
    if not GS13.Body.IsBlind() and CurTime()-GS13.Body.LastBlindChange() > 1 then return end
    cam.Start2D()
		surface.SetDrawColor(0, 0, 0,
            GS13.Body.IsBlind() and
                math.min(1, CurTime() - GS13.Body.LastBlindChange())*255 or
                math.max(0, 1 - (CurTime() - GS13.Body.LastBlindChange()))*255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	cam.End2D()
end)

local sounds = {}

thorium.gnet.Receive("GS13_BODY_Echolocation", function(handle)
    local data = handle:ReadTable()
    data.ReceiveTime = SysTime()
    data.Pos = data.Pos or (IsValid(data.Entity) and
        (data.Entity == LocalPlayer() and data.Entity:EyePos() or data.Entity:GetPos()))
    if not data.Pos then return end
    sounds[#sounds+1] = data
end)
hook.Add("EntityEmitSound", "GS13_BODY_Echolocation", function(data)
    data.ReceiveTime = SysTime()
    data.Pos = data.Pos or (IsValid(data.Entity) and
        (data.Entity == LocalPlayer() and data.Entity:EyePos() or data.Entity:GetPos()))
    if not data.Pos then return end
    sounds[#sounds+1] = data
end)

hook.Add("PreDrawHUD", "GS13_BODY_BlindEcholocation", function()
    if not GS13.Body.IsBlind() then return end
    if GS13.Body.IsDeaf() then return end
    render.SetColorMaterial()
    cam.Start3D()
        local rmoff = 0
        for _,data in ipairs(sounds) do
            local delta = math.max(0, math.ease.InBack(1-(SysTime()-data.ReceiveTime)/4))
            if delta <= 0 then
                table.remove(sounds, _ - rmoff)
                rmoff = rmoff + 1
                continue
            end
            render.DrawSphere(
                data.Pos,
                -256*(1-delta)*(data.SoundLevel/60)*data.Volume, 16, 16,
                Color(255*delta, 255*delta, 255*delta, 127*delta)
            )
            render.DrawSphere(
                data.Pos,
                256*(1-delta)*(data.SoundLevel/60)*data.Volume, 16, 16,
                Color(255*delta, 255*delta, 255*delta, 127*delta)
            )
        end
	cam.End3D()
end)