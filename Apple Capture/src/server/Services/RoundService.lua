local Knit = require(game:GetService('ReplicatedStorage').Knit);
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal);
local AppleGenerationService;

local INTERMISSION_TIME = 10;
local ROUND_TIME = 30;
local INTERMISSION_EVENT_NAME = 'Intermission';
local ROUND_EVENT_NAME = 'Round';
local COLLECTED_EVENT_NAME = 'Collected';
local WINNER_CHOSEN_EVENT_NAME = 'WinnerChosen';

local RoundService = Knit.CreateService({
    Name = 'RoundService',
    Client = {
        RoundInfo = RemoteSignal.new();
    }
});

function RoundService:GetWinner()
    local winner;
    local mostCollectedApples = 0;

    for i, v in next, AppleGenerationService.AppleCollectors do
        if v > mostCollectedApples then
            winner = i;
            mostCollectedApples = v;
        end;
    end;

    return winner, mostCollectedApples;
end;

function RoundService:StartIntermission()
    local roundInfoEvent = self.Client.RoundInfo;
    for i = INTERMISSION_TIME, 1, -1 do
        roundInfoEvent:FireAll(INTERMISSION_EVENT_NAME, i);
        wait(1);
    end;
end;

function RoundService:StartRound()
    local roundInfoEvent = self.Client.RoundInfo;

    AppleGenerationService:StartGeneration();

    for i = ROUND_TIME, 1, -1 do
        roundInfoEvent:FireAll(ROUND_EVENT_NAME, i);
        wait(1);
    end;

    AppleGenerationService:StopGenerationAndClearApples();
    roundInfoEvent:FireAll(COLLECTED_EVENT_NAME, 0);

    local winner, mostCollectedApples = self:GetWinner();
    roundInfoEvent:FireAll(WINNER_CHOSEN_EVENT_NAME, winner and winner.Name, mostCollectedApples);

    AppleGenerationService:ResetAppleCollectors();
    wait(3);
end;

function RoundService:AppleCollected(plr, collectedApples)
    self.Client.RoundInfo:Fire(plr, COLLECTED_EVENT_NAME, collectedApples);
end;

function RoundService:KnitStart()
    coroutine.wrap(function()
        while true do
            self:StartIntermission();
            self:StartRound();
        end;
    end)();
end;

function RoundService:KnitInit()
    AppleGenerationService = Knit.Services.AppleGenerationService;
end;

return RoundService;