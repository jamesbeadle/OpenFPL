
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
            eventType = variant { Goal };
            eventStartMinute = 0:nat8;
            eventEndMinute = 55:nat8;
            clubId = 14:nat16;
        };

    }
} )"
FUNCTION_ID=3000

# Submit the proposal
./make_custom_function_proposal.sh $FUNCTION_ID "$TITLE" "$SUMMARY" "$URL" "$ARGS"