
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Chelsea v Man City."
SUMMARY="Add Fixture Data for Chelsea v Man City (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 9:nat32;
    playerEventData = vec {

        record {
            fixtureId = 9:nat32;
            playerId = 175:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 180:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 80:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 689:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 80:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 186:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 188:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 187:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 197:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 66:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 688:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 66:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 195:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 204:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 58:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 553:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 58:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 191:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 202:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 205:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 66:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 585:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 66:nat8;
            eventEndMinute = 90:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 195:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 89:nat8;
            eventEndMinute = 89:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 175:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 175:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 7:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 175:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 7:nat16;
        };


        record {
            fixtureId = 9:nat32;
            playerId = 351:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 358:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 356:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 353:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 367:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 359:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 601:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 46:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 365:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 46:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 363:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 371:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 364:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 373:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 373:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 66:nat8;
            eventEndMinute = 66:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 351:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 351:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 351:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 373:nat16;
            eventType = variant { Goal };
            eventStartMinute = 18:nat8;
            eventEndMinute = 18:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 367:nat16;
            eventType = variant { Goal };
            eventStartMinute = 84:nat8;
            eventEndMinute = 84:nat8;
            clubId = 13:nat16;
        };

        record {
            fixtureId = 9:nat32;
            playerId = 371:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 18:nat8;
            eventEndMinute = 18:nat8;
            clubId = 13:nat16;
        };

    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"