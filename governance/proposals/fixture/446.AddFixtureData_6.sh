
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Nottingham Forest v Bournemouth."
SUMMARY="Add Fixture Data for Nottingham Forest v Bournemouth (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 6:nat32;
    playerEventData = vec {

        record {
            fixtureId = 6:nat32;
            playerId = 432:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 443:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 54:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 436:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 54:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 442:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 440:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 435:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 450:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 15:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 449:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 15:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 444:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 453:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 72:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 418:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 72:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 446:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 454:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 54:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 447:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 54:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 452:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 72:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 451:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 72:nat8;
            eventEndMinute = 90:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 435:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 49:nat8;
            eventEndMinute = 49:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 432:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 432:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 432:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 452:nat16;
            eventType = variant { Goal };
            eventStartMinute = 23:nat8;
            eventEndMinute = 23:nat8;
            clubId = 16:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 449:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 23:nat8;
            eventEndMinute = 23:nat8;
            clubId = 16:nat16;
        };




        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 66:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 683:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 72:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 69:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 63:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 718:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 63:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 74:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 81:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 77:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 63:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 76:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 63:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 84:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 64:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 85:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 64:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 78:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 83:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 69:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 570:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 69:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 87:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 66:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 48:nat8;
            eventEndMinute = 48:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 74:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 45:nat8;
            eventEndMinute = 45:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 61:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };

        record {
            fixtureId = 6:nat32;
            playerId = 87:nat16;
            eventType = variant { Goal };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 3:nat16;
        };


    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"