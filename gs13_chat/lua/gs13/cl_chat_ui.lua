hook.Add("HUDPaint", "GS13_CHAT_DrawChatTemp", function()
    -- local y = 0
    -- for line=1, math.min(#GS13.Chat.Messages-1, 5) do
    --     local message = GS13.Chat.Messages[#GS13.Chat.Messages-line]
    --     local font = "DermaDefault" or message.font
    --     local text = message.text
    --     local color = message.color or color_white
    --     surface.SetFont(font)
    --     local _, h = surface.GetTextSize(text)
    --     y = y + h
    --     draw.DrawText(text, font, 10, ScrH()-10-y, color)
    -- end
end)