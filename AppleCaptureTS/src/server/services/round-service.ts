import { KnitServer as Knit, RemoteSignal, Service, Maid } from '@rbxts/knit';

let AppleGenerationService: typeof Knit.Services.AppleGenerationService;

const INTERMISSION_TIME = 10;
const ROUND_TIME = 30;
const INTERMISSION_EVENT_NAME = 'Intermission';
const ROUND_EVENT_NAME = 'Round';
const COLLECTED_EVENT_NAME = 'Collected';
const WINNER_CHOSEN_EVENT_NAME = 'WinnerChosen';

declare global {
    interface KnitServices {
        RoundService: typeof RoundService;
    }
}

const RoundService = Knit.CreateService({
    Name: 'RoundService',

    Client: {
        RoundInfo: new RemoteSignal<(eventName: string, data: number | string | undefined, mostCollectedApples?: number) => void>()
    },

    getWinner(): [Player | undefined, number] {
        let winner: Player | undefined;
        let mostCollectedApples: number = 0;

        for (const [plr, collectedApples] of AppleGenerationService.appleCollectors) {
            if (collectedApples > mostCollectedApples) {
                winner = plr;
                mostCollectedApples = collectedApples;
            }
        }

        return [winner, mostCollectedApples];
    },

    startIntermission() {
        for (let i = INTERMISSION_TIME; i > 0; i--) {
            this.Client.RoundInfo.FireAll(INTERMISSION_EVENT_NAME, i);
            wait(1);
        }
    },

    startRound() {
        let roundInfoEvent = this.Client.RoundInfo;

        AppleGenerationService.startGeneration();

        for (let i = ROUND_TIME; i > 0; i--) {
            roundInfoEvent.FireAll(ROUND_EVENT_NAME, i);
            wait(1);
        }

        AppleGenerationService.stopGenerationAndClearApples();
        roundInfoEvent.FireAll(COLLECTED_EVENT_NAME, 0);

        let [winner, mostCollectedApples] = this.getWinner();
        roundInfoEvent.FireAll(WINNER_CHOSEN_EVENT_NAME, winner?.Name, mostCollectedApples);

        AppleGenerationService.resetAppleCollectors();
        wait(3);
    },

    appleCollected(plr: Player, collectedApples: number) {
        this.Client.RoundInfo.Fire(plr, COLLECTED_EVENT_NAME, collectedApples);
    },

    KnitStart() {
        coroutine.wrap(() => {
            while (true) {
                this.startIntermission();
                this.startRound();
            }
        })();
    },

    KnitInit() {
        AppleGenerationService = Knit.Services.AppleGenerationService;
    }
});

export = RoundService;
