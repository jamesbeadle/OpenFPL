#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR
../utils/submit_upgrade_proposal.sh "OpenFPL_backend" "1.6.5" "Update OpenFPL Backend Wasm" "https://github.com/jamesbeadle/OpenFPL" "Fix monthly bonus reducing on each save rather than each use of a bonus and refactor triggering of GW timers to after the current timers expire."

