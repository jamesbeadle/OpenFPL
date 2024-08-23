
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Newcastle v Southampton."
SUMMARY="Add Fixture Data for Newcastle v Southampton (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 5:nat32;
    playerEventData = vec {

        record {
            fixtureId = 5:nat32;
            playerId = 404:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 408:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 70:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 67:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 70:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 406:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 413:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 28:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 411:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 416:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 419:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 420:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 426:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 70:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 425:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 70:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 427:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 422:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 30:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 409:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 30:nat8;
            eventEndMinute = 90:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 404:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 404:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 404:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 408:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 9:nat8;
            eventEndMinute = 9:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 406:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 74:nat8;
            eventEndMinute = 74:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 413:nat16;
            eventType = variant { RedCard };
            eventStartMinute = 28:nat8;
            eventEndMinute = 28:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 655:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 662:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 656:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 81:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 666:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 81:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 659:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 714:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 81:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 715:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 81:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 667:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 70:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 716:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 70:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 669:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 671:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 663:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 46:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 670:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 46:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 717:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 71:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 482:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 71:nat8;
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 672:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;  
            eventEndMinute = 90:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 662:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 45:nat8;  
            eventEndMinute = 45:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 659:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 73:nat8;  
            eventEndMinute = 73:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 717:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 28:nat8;  
            eventEndMinute = 28:nat8;
            clubId = 23:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 416:nat16;
            eventType = variant { Goal };
            eventStartMinute = 45:nat8;  
            eventEndMinute = 45:nat8;
            clubId = 15:nat16;
        };

        record {
            fixtureId = 5:nat32;
            playerId = 427:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 45:nat8;  
            eventEndMinute = 45:nat8;
            clubId = 15:nat16;
        };


    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"