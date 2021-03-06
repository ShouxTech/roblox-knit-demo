-- Compiled with roblox-ts v1.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Knit = TS.import(script, TS.getModule(script, "knit").src).KnitClient
local Players = TS.import(script, TS.getModule(script, "services")).Players
local INTERMISSION_EVENT_NAME = "Intermission"
local ROUND_EVENT_NAME = "Round"
local COLLECTED_EVENT_NAME = "Collected"
local WINNER_CHOSEN_EVENT_NAME = "WinnerChosen"
local infoGUI = (Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")):WaitForChild("InfoGUI")
local infoLabel = infoGUI:WaitForChild("InfoLabel")
local collectedApplesLabel = infoLabel:WaitForChild("CollectedApplesLabel")
local RoundController = Knit.CreateController({
	Name = "RoundController",
	KnitStart = function(self)
		Knit.GetService("RoundService").RoundInfo:Connect(function(eventName, data, mostCollectedApples)
			if (eventName == ROUND_EVENT_NAME) or (eventName == INTERMISSION_EVENT_NAME) then
				local secondsRemaining = data
				infoLabel.Text = eventName .. ": " .. tostring(secondsRemaining)
			elseif eventName == COLLECTED_EVENT_NAME then
				local collectedApples = data
				collectedApplesLabel.Text = tostring(collectedApples)
			elseif eventName == WINNER_CHOSEN_EVENT_NAME then
				local winner = data
				if winner ~= "" and winner then
					infoLabel.Text = winner .. " won the round with " .. tostring(mostCollectedApples) .. " " .. ((mostCollectedApples == 1) and "apple!" or "apples!")
				else
					infoLabel.Text = "Nobody won the round!"
				end
			end
		end)
	end,
})
return nil
