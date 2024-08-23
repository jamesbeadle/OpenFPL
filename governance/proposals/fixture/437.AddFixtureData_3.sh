
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Arsenal v Wolves."
SUMMARY="Add Fixture Data for Arsenal v Wolves (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 3:nat32;
    playerEventData = vec {

        record {
            fixtureId = 3:nat32;
            playerId = 2:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 2:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 2:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 2:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 11:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 69:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 7:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 69:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 6:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 4:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 5:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 20:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 85:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 24:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 85:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 13:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 14:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 25:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 19:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 23:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 80:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 27:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 80:nat8;
            eventEndMinute = 90:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 23:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 60:nat8;
            eventEndMinute = 60:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 19:nat16;
            eventType = variant { Goal };
            eventStartMinute = 25:nat8;
            eventEndMinute = 25:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 23:nat16;
            eventType = variant { Goal };
            eventStartMinute = 74:nat8;
            eventEndMinute = 74:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 23:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 25:nat8;
            eventEndMinute = 25:nat8;
            clubId = 1:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 19:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 74:nat8;
            eventEndMinute = 74:nat8;
            clubId = 1:nat16;
        };




        record {
            fixtureId = 3:nat32;
            playerId = 536:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 540:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 542:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 546:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 711:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 539:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 547:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 549:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 557:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 614:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 75:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 712:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 75:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 551:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 57:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 555:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 57:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 554:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 613:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 713:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 546:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 38:nat8;
            eventEndMinute = 38:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 549:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 23:nat8;
            eventEndMinute = 23:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 536:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 536:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 536:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 20:nat16;
        };

        record {
            fixtureId = 3:nat32;
            playerId = 536:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 20:nat16;
        };



    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"