
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for West Ham v Aston Villa."
SUMMARY="Add Fixture Data for West Ham v Aston Villa (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 7:nat32;
    playerEventData = vec {

        record {
            fixtureId = 7:nat32;
            playerId = 513:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 523:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 611:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 519:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 518:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 85:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 719:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 85:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 720:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 85:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 532:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 85:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 527:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 525:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 524:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 530:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 533:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 73:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 721:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 73:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 531:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 73:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 722:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 73:nat8;
            eventEndMinute = 90:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 525:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 31:nat8;
            eventEndMinute = 31:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 513:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 525:nat16;
            eventType = variant { Goal };
            eventStartMinute = 37:nat8;
            eventEndMinute = 37:nat8;
            clubId = 19:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 530:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 37:nat8;
            eventEndMinute = 37:nat8;
            clubId = 19:nat16;
        };




        record {
            fixtureId = 7:nat32;
            playerId = 31:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 40:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 561:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 41:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 38:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 36:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 82:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 563:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 82:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 49:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 253:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 48:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 62:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 55:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 62:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 53:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 54:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 568:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 59:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 62:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 60:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 62:nat8;
            eventEndMinute = 90:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 54:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 8:nat8;
            eventEndMinute = 8:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 31:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 31:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 31:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 253:nat16;
            eventType = variant { Goal };
            eventStartMinute = 4:nat8;
            eventEndMinute = 4:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 49:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 4:nat8;
            eventEndMinute = 4:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 60:nat16;
            eventType = variant { Goal };
            eventStartMinute = 79:nat8;
            eventEndMinute = 79:nat8;
            clubId = 2:nat16;
        };

        record {
            fixtureId = 7:nat32;
            playerId = 55:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 79:nat8;
            eventEndMinute = 79:nat8;
            clubId = 2:nat16;
        };


    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"