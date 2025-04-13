GS13.Chat.Messages = {}

function GS13.Chat.SendMessage(text)
    table.insert(GS13.Chat.Messages, {text=text})
end

-- TODO: add receive for server sent message

GS13.Chat.SendMessage("first message")
GS13.Chat.SendMessage("test")
GS13.Chat.SendMessage("hello, world")
GS13.Chat.SendMessage("please help me")
GS13.Chat.SendMessage("\npre newline")
GS13.Chat.SendMessage("new line ->\n<- new line")
GS13.Chat.SendMessage("abc\ndef\nghi\n")
GS13.Chat.SendMessage("aaaaaaaaaaa")
GS13.Chat.SendMessage("last message")