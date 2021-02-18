local Knit = require(game:GetService('ReplicatedStorage').Knit);

local INTERMISSION_EVENT_NAME = 'Intermission';
local ROUND_EVENT_NAME = 'Round';
local COLLECTED_EVENT_NAME = 'Collected';
local WINNER_CHOSEN_EVENT_NAME = 'WinnerChosen';

local infoGUI = game:GetService('Players').LocalPlayer.PlayerGui:WaitForChild('InfoGUI');
local infoLabel = infoGUI:WaitForChild('InfoLabel');
local collectedApplesLabel = infoLabel:WaitForChild('CollectedApplesLabel');

local RoundController = Knit.CreateController({
    Name = 'RoundController'
});

function RoundController:KnitStart()
    Knit.GetService('RoundService').RoundInfo:Connect(function(event, ...)
        if event == INTERMISSION_EVENT_NAME then
            local secondsRemaining = ...;
            infoLabel.Text = event .. ': ' .. secondsRemaining;
        elseif event == ROUND_EVENT_NAME then
            local secondsRemaining = ...;
            infoLabel.Text = event .. ': ' .. secondsRemaining;
        elseif event == COLLECTED_EVENT_NAME then
            local collectedApples = ...;
            collectedApplesLabel.Text = collectedApples;
        elseif event == WINNER_CHOSEN_EVENT_NAME then
            local winner, mostCollectedApples = ...;
            if winner then
                infoLabel.Text = winner .. ' won the round with ' .. mostCollectedApples .. ((mostCollectedApples == 1) and ' apple!' or ' apples!');
            else
                infoLabel.Text = 'Nobody won the round!';
            end;
        end;
    end);
end;

function RoundController:KnitInit()

end;

return RoundController;