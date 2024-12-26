warn("[TEMPEST HUB] Loading Ui")
wait()
local repo = "https://raw.githubusercontent.com/TrilhaX/tempestHubUI/main/"

--Loading UI Library
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
Library:Notify("Welcome to Tempest Hub", 5)

--Configuring UI Library
local Window = Library:CreateWindow({
	Title = "Tempest Hub | Anime Adventures",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

Library:Notify("Loading Anime Adventures Script", 5)
warn("[TEMPEST HUB] Loading Function")
wait()
warn("[TEMPEST HUB] Loading Toggles")
wait()
warn("[TEMPEST HUB] Last Checking")
wait()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local speed = 1000

--START OF FUNCTIONS

function autoMatchmakingHolidayEvent()
    while getgenv().matchmakingHoliday == true do
        game:GetService("ReplicatedStorage").endpoints.client_to_server.request_matchmaking:InvokeServer("christmas_event")
        wait()
    end
end

function securityMode()
	local players = game:GetService("Players")
	local ignorePlaceIds = { 8304191830 }

	local function isPlaceIdIgnored(placeId)
		for _, id in ipairs(ignorePlaceIds) do
			if id == placeId then
				return true
			end
		end
		return false
	end

	while getgenv().securityMode do
		if #players:GetPlayers() >= 2 then
			local player1 = players:GetPlayers()[1]
			local targetPlaceId = 8304191830

			if game.PlaceId ~= targetPlaceId and not isPlaceIdIgnored(game.PlaceId) then
				game:GetService("TeleportService"):Teleport(targetPlaceId, player1)
			end
		end
		wait(1)
	end
end

function deletemap()
	if getgenv().deletemap == true then
		local map = workspace:FindFirstChild("_map")
		local bases = workspace:FindFirstChild("_BASES")
		local waterBlocks = workspace:FindFirstChild("_water_blocks")

		if map then
			map:Destroy()
		end

		if bases then
			bases:Destroy()
		end

		if waterBlocks then
			waterBlocks:Destroy()
		end

		wait(1)
	end
end

function hideInfoPlayer()
	if getgenv().deletemap == true then
		local player = game.Players.LocalPlayer
		if not player then
			return
		end

		local head = player.Character and player.Character:FindFirstChild("Head")
		if not head then
			return
		end

		local overhead = head:FindFirstChild("_overhead")
		if not overhead then
			return
		end

		local frame = overhead:FindFirstChild("Frame")
		if not frame then
			return
		end

		frame:Destroy()

		wait(0.1)
	end
end

function autostart()
	while getgenv().autostart == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
	end
end

function autoskipwave()
	while getgenv().autoskipwave == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_wave_skip:InvokeServer()
	end
end

function autoreplay()
	while getgenv().autoreplay == true do
		local args = {
			[1] = "replay",
		}

		game:GetService("ReplicatedStorage")
			:WaitForChild("endpoints")
			:WaitForChild("client_to_server")
			:WaitForChild("set_game_finished_vote")
			:InvokeServer(unpack(args))
	end
end

function autoleave()
	while getgenv().autoleave == true do
		game:GetService("ReplicatedStorage").endpoints.client_to_server.teleport_back_to_lobby:InvokeServer("leave")
	end
end

function autonext()
	while getgenv().autonext == true do
		local args = {
			[1] = "next_story",
		}

		game:GetService("ReplicatedStorage").endpoints.client_to_server.set_game_finished_vote
			:InvokeServer(unpack(args))
	end
end

-- START UI

local Tabs = {
	Main = Window:AddTab("Main"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Player")

LeftGroupBox:AddToggle("HPI", {
	Text = "Hide Player Info",
	Default = false,
	Callback = function(Value)
		getgenv().hideInfoPlayer = Value
		hideInfoPlayer()
	end,
})

LeftGroupBox:AddToggle("SM", {
	Text = "Security Mode",
	Default = false,
	Callback = function(Value)
		getgenv().securityMode = Value
		securityMode()
	end,
})

LeftGroupBox:AddToggle("DM", {
	Text = "Delete Map",
	Default = false,
	Callback = function(Value)
		getgenv().deletemap = Value
		deletemap()
	end,
})

LeftGroupBox:AddToggle("AL", {
	Text = "Auto Leave",
	Default = false,
	Callback = function(Value)
		getgenv().autoleave = Value
		autoleave()
	end,
})

LeftGroupBox:AddToggle("AR", {
	Text = "Auto Replay",
	Default = false,
	Callback = function(Value)
		getgenv().autoreplay = Value
		autoreplay()
	end,
})

LeftGroupBox:AddToggle("AN", {
	Text = "Auto Next",
	Default = false,
	Callback = function(Value)
		getgenv().autonext = Value
		autonext()
	end,
})

LeftGroupBox:AddToggle("AS", {
	Text = "Auto Start",
	Default = false,
	Callback = function(Value)
		getgenv().autostart = Value
		autostart()
	end,
})

LeftGroupBox:AddToggle("ASW", {
	Text = "Auto Skip Wave",
	Default = false,
	Callback = function(Value)
		getgenv().autoskipwave = Value
		autoskipwave()
	end,
})

LeftGroupBox:AddToggle("AMH", {
	Text = "Auto Matchmaking Holiday",
	Default = false,
	Callback = function(Value)
		getgenv().matchmakingHoliday = Value
		autoMatchmakingHolidayEvent()
	end,
})

--UI IMPORTANT THINGS
Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local StartTime = tick()

local WatermarkConnection

local function FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local seconds = math.floor(seconds % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function UpdateWatermark()
	FrameCounter = FrameCounter + 1

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter
		FrameTimer = tick()
		FrameCounter = 0
	end

	local activeTime = tick() - StartTime

	Library:SetWatermark(
		("Tempest Hub | %s fps | %s ms | %s"):format(
			math.floor(FPS),
			math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()),
			FormatTime(activeTime)
		)
	)
end

WatermarkConnection = game:GetService("RunService").RenderStepped:Connect(UpdateWatermark)

local TabsUI = {
	["UI Settings"] = Window:AddTab("UI Settings"),
}

local function Unload()
	WatermarkConnection:Disconnect()
	print("Unloaded!")
	Library.Unloaded = true
end

local MenuGroup = TabsUI["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("huwe", {
	Text = "Hide UI When Execute",
	Default = false,
	Callback = function(Value)
		getgenv().hideUIExec = Value
		hideUIExec()
	end,
})

MenuGroup:AddToggle("AUTOEXECUTE", {
	Text = "Auto Execute",
	Default = false,
	Callback = function(Value)
		getgenv().aeuat = Value
		aeuat()
	end,
})

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

--Save Settings
ThemeManager:SetFolder("Tempest Hub")
SaveManager:SetFolder("Tempest Hub/_AA_MMH_")

SaveManager:BuildConfigSection(TabsUI["UI Settings"])

ThemeManager:ApplyToTab(TabsUI["UI Settings"])

SaveManager:LoadAutoloadConfig()

local GameConfigName = "_AA_MMH_"
local player = game.Players.LocalPlayer
SaveManager:Load(player.Name .. GameConfigName)
spawn(function()
	while task.wait(1) do
		if Library.Unloaded then
			break
		end
		SaveManager:Save(player.Name .. GameConfigName)
	end
end)

--Anti AFK
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
warn("[TEMPEST HUB] Loaded")