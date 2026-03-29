-- ragebait hub loader
-- checks key against server before loading hub

local KEY_SERVER = "https://web-production-a59aa.up.railway.app/validate?key="
local HUB_URL = "https://raw.githubusercontent.com/Revixionary/RAGEBAITHUBNEWEST/main/output.lua"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playergui = player:WaitForChild("PlayerGui")

-- KEY UI
local sg = Instance.new("ScreenGui", playergui)
sg.Name = "RBKeySystem"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true

local bg = Instance.new("Frame", sg)
bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,8)
bg.BackgroundTransparency = 0.3; bg.BorderSizePixel = 0

local box = Instance.new("Frame", sg)
box.Size = UDim2.new(0,420,0,220)
box.Position = UDim2.new(0.5,-210,0.5,-110)
box.BackgroundColor3 = Color3.fromRGB(12,12,18)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", box)
stroke.Thickness = 1.5; stroke.Color = Color3.fromRGB(65,45,155)

local title = Instance.new("TextLabel", box)
title.Size = UDim2.new(1,0,0,50); title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1; title.Text = "ragebait hub"
title.Font = Enum.Font.GothamBold; title.TextSize = 28
title.TextColor3 = Color3.fromRGB(220,220,240)

local sub = Instance.new("TextLabel", box)
sub.Size = UDim2.new(1,0,0,20); sub.Position = UDim2.new(0,0,0,46)
sub.BackgroundTransparency = 1; sub.Text = "enter your key to continue"
sub.Font = Enum.Font.Gotham; sub.TextSize = 12
sub.TextColor3 = Color3.fromRGB(95,95,125)

local keyBox = Instance.new("TextBox", box)
keyBox.Size = UDim2.new(1,-40,0,38); keyBox.Position = UDim2.new(0,20,0,90)
keyBox.BackgroundColor3 = Color3.fromRGB(22,22,32)
keyBox.PlaceholderText = "RAGEBAIT-XXXX-XXXX-XXXX"
keyBox.PlaceholderColor3 = Color3.fromRGB(70,70,90)
keyBox.Font = Enum.Font.GothamBold; keyBox.TextSize = 13
keyBox.TextColor3 = Color3.fromRGB(220,220,240)
keyBox.ClearTextOnFocus = false; keyBox.Text = ""
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,6)
local ks = Instance.new("UIStroke", keyBox)
ks.Thickness = 1; ks.Color = Color3.fromRGB(40,40,60)
local kp = Instance.new("UIPadding", keyBox)
kp.PaddingLeft = UDim.new(0,10); kp.PaddingRight = UDim.new(0,10)

local statusLbl = Instance.new("TextLabel", box)
statusLbl.Size = UDim2.new(1,-40,0,20); statusLbl.Position = UDim2.new(0,20,0,136)
statusLbl.BackgroundTransparency = 1; statusLbl.Text = ""
statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 11
statusLbl.TextColor3 = Color3.fromRGB(95,95,125)
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local submitBtn = Instance.new("TextButton", box)
submitBtn.Size = UDim2.new(1,-40,0,38); submitBtn.Position = UDim2.new(0,20,0,162)
submitBtn.BackgroundColor3 = Color3.fromRGB(100,60,230)
submitBtn.Text = "Submit Key"; submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 13; submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
submitBtn.AutoButtonColor = false
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,6)

local function setStatus(msg, col)
    statusLbl.Text = msg
    statusLbl.TextColor3 = col or Color3.fromRGB(95,95,125)
end

local function checkKey(key)
    setStatus("Checking key...", Color3.fromRGB(95,95,125))
    submitBtn.Active = false; submitBtn.BackgroundColor3 = Color3.fromRGB(50,30,120)
    local ok, result = pcall(function()
        return game:HttpGet(KEY_SERVER .. key, true)
    end)
    if not ok then
        setStatus("Could not reach server. Try again.", Color3.fromRGB(210,60,70))
        submitBtn.Active = true; submitBtn.BackgroundColor3 = Color3.fromRGB(100,60,230)
        return
    end
    if result:find('"valid": true') or result:find('"valid":true') then
        setStatus("Key accepted! Loading hub...", Color3.fromRGB(50,210,110))
        task.wait(0.8)
        sg:Destroy()
        loadstring(game:HttpGet(HUB_URL, true))()
    else
        setStatus("Invalid key. Check your key and try again.", Color3.fromRGB(210,60,70))
        submitBtn.Active = true; submitBtn.BackgroundColor3 = Color3.fromRGB(100,60,230)
    end
end

submitBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text:gsub("%s", "")
    if key == "" then setStatus("Please enter a key.", Color3.fromRGB(210,60,70)); return end
    checkKey(key)
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.Return then
        local key = keyBox.Text:gsub("%s", "")
        if key ~= "" then checkKey(key) end
    end
end)
