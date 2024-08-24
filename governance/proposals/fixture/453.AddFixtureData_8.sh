
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Brentford v Crystal Palace."
SUMMARY="Add Fixture Data for Brentford v Crystal Palace (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 8:nat32;
    playerEventData = vec {

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 99:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 95:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 100:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 101:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 104:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 107:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 111:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 108:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 103:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 116:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 120:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 106:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 599:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 119:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 98:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 90:nat8;
            eventEndMinute = 90:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 88:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 106:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 20:nat8;
            eventEndMinute = 20:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 119:nat16;
            eventType = variant { Goal };
            eventStartMinute = 29:nat8;
            eventEndMinute = 29:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 106:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 29:nat8;
            eventEndMinute = 29:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 106:nat16;
            eventType = variant { Goal };
            eventStartMinute = 76:nat8;
            eventEndMinute = 76:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 100:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 76:nat8;
            eventEndMinute = 76:nat8;
            clubId = 4:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 95:nat16;
            eventType = variant { OwnGoal };
            eventStartMinute = 57:nat8;
            eventEndMinute = 57:nat8;
            clubId = 4:nat16;
        };


        record {
            fixtureId = 8:nat32;
            playerId = 209:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 216:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 218:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 220:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 691:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 213:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 226:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 228:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 227:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 223:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 217:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 224:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 590:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 65:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 235:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 65:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 237:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 46:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 238:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 46:nat8;
            eventEndMinute = 90:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 209:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 209:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 209:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 216:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 45:nat8;
            eventEndMinute = 45:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 218:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 22:nat8;
            eventEndMinute = 22:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 220:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 58:nat8;
            eventEndMinute = 58:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 590:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 65:nat8;
            eventEndMinute = 65:nat8;
            clubId = 8:nat16;
        };

        record {
            fixtureId = 8:nat32;
            playerId = 590:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 57:nat8;
            eventEndMinute = 57:nat8;
            clubId = 8:nat16;
        };


    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"