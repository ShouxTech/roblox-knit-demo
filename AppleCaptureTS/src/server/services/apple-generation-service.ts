import { KnitServer as Knit, Maid } from '@rbxts/knit';
import { Players, ServerStorage, Workspace } from '@rbxts/services';

let RoundService: typeof Knit.Services.RoundService;

const applePrefab = ServerStorage.FindFirstChild('Apple') as BasePart;
const appleHalfHeight = applePrefab.Size.Y * 0.5;

const baseplate: BasePart = Workspace.FindFirstChild('Baseplate') as BasePart;
const baseplateHalfWidth: number = baseplate.Size.X / 2;
const baseplateHalfHeight: number = baseplate.Size.Y / 2;

declare global {
    interface KnitServices {
        AppleGenerationService: typeof AppleGenerationService;
    }
}

const AppleGenerationService = Knit.CreateService({
    Name: 'AppleGenerationService',

    appleCollectors: new Map<Player, number>(),
    maid: new Maid(),

    Client: {},

    resetAppleCollectors() {
        this.appleCollectors.clear();
    },

    startGeneration() {
        for (let i = 0; i < 45; i++) {
            let collected: boolean = false;
            let apple: BasePart = applePrefab.Clone();
            let applePos: Vector3 = new Vector3(math.random(-baseplateHalfWidth, baseplateHalfWidth), baseplateHalfHeight + appleHalfHeight, math.random(-baseplateHalfWidth, baseplateHalfWidth));
            apple.Position = applePos;
            apple.Parent = Workspace;
            apple.Touched.Connect((instance: BasePart) => {
                if ((instance.Position.sub(apple.Position).Magnitude > 5) || (collected)) return;
                let plr: Player | undefined = Players.GetPlayerFromCharacter(instance.Parent);
                if (!plr) return;
                collected = true;
                apple.Destroy();
                let collectedApples: number | undefined = this.appleCollectors.get(plr);
                collectedApples = collectedApples ? collectedApples + 1 : 1;
                this.appleCollectors.set(plr, collectedApples);
                RoundService.appleCollected(plr, collectedApples);
            });
            this.maid.GiveTask(apple);
        }
    },

    stopGenerationAndClearApples() {
        this.maid.DoCleaning();
    },

    KnitInit() {
        RoundService = Knit.Services.RoundService;
    }
});

export = AppleGenerationService;
