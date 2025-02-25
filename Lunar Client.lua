-- Nome do script e logo
local LunarGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Image = Instance.new("ImageLabel")
local FPSLabel = Instance.new("TextLabel")
local PingLabel = Instance.new("TextLabel")
local PlayersLabel = Instance.new("TextLabel")
local StorageLabel = Instance.new("TextLabel")

LunarGui.Name = "LunarClient"
LunarGui.Parent = game.CoreGui

Frame.Parent = LunarGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0, 10, 0, 10)

Title.Parent = Frame
Title.Text = "Lunar Client"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 20)

Image.Parent = Frame
Image.Size = UDim2.new(0, 50, 0, 50)
Image.Position = UDim2.new(0.5, -25, 0, 25)
Image.Image = "rbxassetid://10144096797" -- Ícone de Lua

FPSLabel.Parent = Frame
FPSLabel.Position = UDim2.new(0, 10, 0, 80)
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

PingLabel.Parent = Frame
PingLabel.Position = UDim2.new(0, 10, 0, 100)
PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

PlayersLabel.Parent = Frame
PlayersLabel.Position = UDim2.new(0, 10, 0, 120)
PlayersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

StorageLabel.Parent = Frame
StorageLabel.Position = UDim2.new(0, 10, 0, 140)
StorageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Função para calcular FPS
local RunService = game:GetService("RunService")
local fps = 60
RunService.RenderStepped:Connect(function(step)
    fps = math.floor(1 / step)
    FPSLabel.Text = "FPS: " .. fps
end)

-- Função para calcular o Ping
local function getPing()
    local stats = game:GetService("Stats")
    return math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
end

game:GetService("RunService").Stepped:Connect(function()
    PingLabel.Text = "Ping: " .. getPing() .. " ms"
    PlayersLabel.Text = "Players: " .. #game.Players:GetPlayers()
    
    local memory = collectgarbage("count") / 1024
    StorageLabel.Text = "Armazenamento: " .. string.format("%.2f", memory) .. " MB"
end)

-- Melhorando o desempenho
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic -- Reduz efeitos visuais
        obj.Reflectance = 0
    end
end

game.Lighting.GlobalShadows = false -- Desativa sombras
game.Lighting.FogEnd = 1000000 -- Remove neblina
game.Lighting.Brightness = 1 -- Ajusta brilho
game.Lighting.TimeOfDay = "14:00:00" -- Mantém iluminação fixa

-- Desativando efeitos que consomem desempenho
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("Texture") and v.Transparency < 1 then
        v.Transparency = 1
    end
end

print("[Lunar Client] Otimização ativada!")
