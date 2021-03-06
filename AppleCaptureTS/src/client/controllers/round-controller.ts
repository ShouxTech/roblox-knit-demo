import { KnitClient as Knit } from "@rbxts/knit";
import { Players } from "@rbxts/services";

const INTERMISSION_EVENT_NAME = 'Intermission';
const ROUND_EVENT_NAME = 'Round';
const COLLECTED_EVENT_NAME = 'Collected';
const WINNER_CHOSEN_EVENT_NAME = 'WinnerChosen';

const infoGUI = (Players.LocalPlayer.FindFirstChildOfClass('PlayerGui') as PlayerGui).WaitForChild('InfoGUI') as ScreenGui;
const infoLabel = infoGUI.WaitForChild('InfoLabel') as TextLabel;
const collectedApplesLabel = infoLabel.WaitForChild('CollectedApplesLabel') as TextLabel;

declare global {
    interface KnitControllers {
        RoundController: typeof RoundController;
    }
}

const RoundController = Knit.CreateController({
    Name: 'RoundController',

    KnitStart() {
        Knit.GetService('RoundService').RoundInfo.Connect((eventName: string, data: number | string | undefined, mostCollectedApples?: number) => {
            if ((eventName === ROUND_EVENT_NAME) || (eventName === INTERMISSION_EVENT_NAME)) {
                const secondsRemaining = data as number;
                infoLabel.Text = `${eventName}: ${tostring(secondsRemaining)}`;
            } else if (eventName === COLLECTED_EVENT_NAME) {
                const collectedApples = data as number;
                collectedApplesLabel.Text = tostring(collectedApples);
            } else if (eventName === WINNER_CHOSEN_EVENT_NAME) {
                let winner = data as string;
                if (winner) {
                    infoLabel.Text = `${winner} won the round with ${mostCollectedApples} ${(mostCollectedApples === 1) ? 'apple!' : 'apples!'}`;
                } else {
                    infoLabel.Text = 'Nobody won the round!';
                }
            }
        });
    }
});