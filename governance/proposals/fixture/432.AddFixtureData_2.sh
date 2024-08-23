
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

TITLE="Add Fixture Data for Ipswich v Liverpool."
SUMMARY="Add Fixture Data for Ipswich v Liverpool (2024/25)."
URL="https://openfpl.xyz"

ARGS="( record { 
    seasonId = 1:nat16;
    gameweek = 1:nat8;
    fixtureId = 2:nat32;
    playerEventData = vec {

        record {
            fixtureId = 2:nat32;
            playerId = 615:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 615:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 615:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 615:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 619:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 624:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 621:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 621:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 6:nat8;
            eventEndMinute = 6:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 623:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 710:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 628:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 65:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 627:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 65:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 625:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 633:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 633:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 13:nat8;
            eventEndMinute = 13:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 630:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 65:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 631:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 65:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 626:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 57:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 626:nat16;
            eventType = variant { YellowCard };
            eventStartMinute = 24:nat8;
            eventEndMinute = 24:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 515:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 57:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 635:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 74:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 632:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 74:nat8;
            eventEndMinute = 90:nat8;
            clubId = 22:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 292:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 292:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 292:nat16;
            eventType = variant { KeeperSave };
            eventStartMinute = 0:nat8;
            eventEndMinute = 0:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 299:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 79:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 298:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 79:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 296:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 303:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 46:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 297:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 46:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 302:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 77:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 304:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 77:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 308:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 311:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 314:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 307:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 316:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 318:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 0:nat8;
            eventEndMinute = 79:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 317:nat16;
            eventType = variant { Appearance };
            eventStartMinute = 79:nat8;
            eventEndMinute = 90:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 318:nat16;
            eventType = variant { Goal };
            eventStartMinute = 60:nat8;
            eventEndMinute = 60:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 316:nat16;
            eventType = variant { GoalAssisted };
            eventStartMinute = 60:nat8;
            eventEndMinute = 60:nat8;
            clubId = 11:nat16;
        };

        record {
            fixtureId = 2:nat32;
            playerId = 316:nat16;
            eventType = variant { Goal };
            eventStartMinute = 65:nat8;
            eventEndMinute = 65:nat8;
            clubId = 11:nat16;
        };

    }
} )"
FUNCTION_ID=3000

# Submit the proposal

../../utils/make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS" "validateSubmitFixtureData"