
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Man United v Fulham."
SUMMARY="Add Fixture Data for Man United v Fulham (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 1:nat32;
    playerEventData = vec {

        record {
            fixtureId = 1:nat32;
            playerId = 376:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 376:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 376:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 382:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 379:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 378:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 81:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 378:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 40:nat8;
            eventEndMinute = 40:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 697:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 81:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 394:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 84:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 393:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 397:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 389:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 61:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 389:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 18:nat8;
            eventEndMinute = 18:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 392:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 61:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 390:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 386:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 81:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 698:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 81:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 394:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 84:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 603:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 61:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 603:nat16;
            eventType = variant { Goal };
            eventStartMinute = 87:nat8;
            eventEndMinute = 87:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 399:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 61:nat8;
            eventEndMinute = 90:nat8;
            clubId = 14:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 399:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 87:nat8;
            eventEndMinute = 87:nat8;
            clubId = 14:nat16;
        };

        

        record {
            fixtureId = 1:nat32;
            playerId = 268:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 268:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 268:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 268:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 268:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 277:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 271:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 271:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 25:nat8;
            eventEndMinute = 25:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 276:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 270:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 282:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 280:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 280:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 70:nat8;
            eventEndMinute = 70:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 289:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 15:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 64:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 285:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 78:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 287:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 78:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 278:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 90:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 279:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 64:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 284:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 78:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        record {
            fixtureId = 1:nat32;
            playerId = 283:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 78:nat8;
            eventEndMinute = 90:nat8;
            clubId = 10:nat16;
        };

        

    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"