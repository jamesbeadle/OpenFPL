
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Everton v Brighton."
SUMMARY="Add Fixture Data for Everton v Brighton (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 4:nat32;
    playerEventData = vec {

        record {
            fixtureId = 4:nat32;
            playerId = 241:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 249:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 246:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 247:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 248:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 66:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 257:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 57:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 260:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 254:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 63:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 596:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 63:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 693:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 85:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 470:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 85:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 261:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 76:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 264:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 76:nat8;
            eventEndMinute = 90:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 247:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 77:nat8;
            eventEndMinute = 77:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 248:nat16;
            eventType = variant { RedCard };
            eventStartMinute = 66:nat8;
            eventEndMinute = 66:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 241:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 241:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 9:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 122:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 141:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 127:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 76:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 126:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 76:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 128:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 130:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 578:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 132:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 82:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 134:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 82:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 139:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 89:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 680:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 89:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 142:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 82:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 576:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 82:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 581:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 47:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 145:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 47:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 144:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 132:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 31:nat8;
            eventEndMinute = 31:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 122:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 139:nat16;
            eventType = variant { Goal };
            eventStartMinute = 25:nat8;
            eventEndMinute = 25:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 581:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 25:nat8;
            eventEndMinute = 25:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 144:nat16;
            eventType = variant { Goal };
            eventStartMinute = 56:nat8;
            eventEndMinute = 56:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 578:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 56:nat8;
            eventEndMinute = 56:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 145:nat16;
            eventType = variant { Goal };
            eventStartMinute = 87:nat8;
            eventEndMinute = 87:nat8;
            clubId = 5:nat16;
        };

        record {
            fixtureId = 4:nat32;
            playerId = 144:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 87:nat8;
            eventEndMinute = 87:nat8;
            clubId = 5:nat16;
        };


    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"