local Players = game:GetService('Players');

local Knit = require(game:GetService('ReplicatedStorage').Knit);
local Maid = require(Knit.Util.Maid);
local RoundService;

local newVector3 = Vector3.new;
local mathRandom = math.random;

local applePrefab = game:GetService('ServerStorage').Apple;
local appleHalfHeight = applePrefab.Size.Y * 0.5;

local baseplate = workspace.Baseplate;
local baseplateHalfWidth = baseplate.Size.X * 0.5;
local baseplateHalfHeight = baseplate.Size.Y * 0.5;

local maid = Maid.new();

local AppleGenerationService = Knit.CreateService({
    Name = 'AppleGenerationService',
    AppleCollectors = {},
    Client = {}
});

function AppleGenerationService:ResetAppleCollectors()
    self.AppleCollectors = {};
end;

function AppleGenerationService:StartGeneration()
    for i = 1, 45 do
        local collected = false;
        local apple = applePrefab:Clone();
        local applePos = newVector3(mathRandom(-baseplateHalfWidth, baseplateHalfWidth), baseplateHalfHeight + appleHalfHeight, mathRandom(-baseplateHalfWidth, baseplateHalfWidth));
        apple.Position = applePos;
        apple.Parent = workspace;
        apple.Touched:Connect(function(instance)
            if ((instance.Position - apple.Position).Magnitude > 5) or (collected) then return; end;
            local plr = Players:GetPlayerFromCharacter(instance.Parent);
            if not plr then return; end;
            collected = true;
            apple:Destroy();
            local collectedApples = self.AppleCollectors[plr];
            collectedApples = collectedApples and collectedApples + 1 or 1
            self.AppleCollectors[plr] = collectedApples;
            RoundService:AppleCollected(plr, collectedApples);
        end);
        maid:GiveTask(apple);
    end;
end;

function AppleGenerationService:StopGenerationAndClearApples()
    maid:DoCleaning();
end;

function AppleGenerationService:KnitStart()

end;

function AppleGenerationService:KnitInit()
    RoundService = Knit.Services.RoundService;
end;

return AppleGenerationService;