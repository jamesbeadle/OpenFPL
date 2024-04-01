#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

#Register generic proposal functions

echo "Register Generic Proposal Function 1 with SNS"

PROPOSAL="(
    record {
        title = \"Create CreateDAONeuron Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for creating the DAO controlled neuron.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 19000 : nat64;
                name = \"Add CreateDAONeuron Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function for creating the DAO controlled neuron.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateCreateDAONeuron\";                         
                        target_method_name = opt \"executeCreateDAONeuron\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 2 with SNS"

PROPOSAL="(
    record {
        title = \"Create ExecuteManageNeuron Callback Function.\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for managing the DAO controlled neuron.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 20000 : nat64;
                name = \"Add ManageDAONeuron Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function for managing the DAO controlled neuron.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateManageDAONeuron\";                         
                        target_method_name = opt \"executeManageDAONeuron\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 3 with SNS"

PROPOSAL="(
    record {
        title = \"Create RevaluePlayerUp Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for increasing a Premier League player's value.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 1000 : nat64;
                name = \"Add RevaluePlayerUp Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function for increasing a Premier League player's value.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateRevaluePlayerUp\";                         
                        target_method_name = opt \"executeRevaluePlayerUp\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 4 with SNS"

//Revalue Players Down

PROPOSAL="(
    record {
        title = \"Create RevaluePlayerDown Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for decreasing a Premier League player's value.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 2000 : nat64;
                name = \"Add RevaluePlayerDown Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function for decreasing a Premier League player's value.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateRevaluePlayerDown\";                         
                        target_method_name = opt \"executeRevaluePlayerDown\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 5 with SNS"

//submit fixture data

PROPOSAL="(
    record {
        title = \"Create SubmitFixtureData Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function for submitting Premier League match fixture data.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 3000 : nat64;
                name = \"Add SubmitFixtureData Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function for submitting Premier League match fixture data.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateSubmitFixtureData\";                         
                        target_method_name = opt \"executeSubmitFixtureData\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 6 with SNS"

//add initial fixtures

PROPOSAL="(
    record {
        title = \"Create AddIntitialFixtures Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to add the initial fixtures of the season.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 4000 : nat64;
                name = "Add AddIntitialFixtures Callback Function";
                description = opt \"Proposal to create the endpoint for adding the callback function to add the initial fixtures of the season.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateAddInitialFixtures\";                         
                        target_method_name = opt \"executeAddInitialFixtures\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 7 with SNS"

//Move Fixture

PROPOSAL="(
    record {
        title = \"Create MoveFixture Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to move a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 5000 : nat64;
                name = \"Add MoveFixture Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function to move a fixture.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateMoveFixture\";                         
                        target_method_name = opt \"executeMoveFixture\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 8 with SNS"

//postpone fixture

PROPOSAL="(
    record {
        title = \"Create PostponeFixture Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to postpone a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 6000 : nat64;
                name = \"Add PostponeFixture Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function to postpone a fixture.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validatePostponeFixture\";                         
                        target_method_name = opt \"executePostponeFixture\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 9 with SNS"

//Reschedule Fixture

PROPOSAL="(
    record {
        title = \"Create RescheduleFixture Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to reschedule a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 7000 : nat64;
                name = \"Add RescheduleFixture Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function to reschedule a fixture.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateRescheduleFixture\";                         
                        target_method_name = opt \"executeRescheduleFixture\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 10 with SNS"

//Transfer Player

PROPOSAL="(
    record {
        title = \"Create TransferPlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to transfer a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 8000 : nat64;
                name = \"Add TransferPlayer Callback Function.\";
                description = opt \"Proposal to create the endpoint for adding the callback function to transfer a player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateTransferPlayer\";                         
                        target_method_name = opt \"executeTransferPlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 11 with SNS"

//Loan Player

PROPOSAL="(
    record {
        title = \"Create LoanPlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to loan a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 9000 : nat64;
                name = \"Add LoanPlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to loan a player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateLoanPlayer\";                         
                        target_method_name = opt \"executeLoanPlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 12 with SNS"

//Recall Player

PROPOSAL="(
    record {
        title = \"Create RecallPlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to recall a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 10000 : nat64;
                name = \"Add RecallPlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to recall a player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateRecallPlayer\";                         
                        target_method_name = opt \"executeRecallPlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 13 with SNS"

//Create Player

PROPOSAL="(
    record {
        title = \"Create CreatePlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to create a new player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 11000 : nat64;
                name = \"Add CreatePlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to create a new player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateAddNewPlayer\";                         
                        target_method_name = opt \"executeAddNewPlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 14 with SNS"

//Update Player

PROPOSAL="(
    record {
        title = \"Create UpdatePlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to update a new player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 12000 : nat64;
                name = \"Add UpdatePlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to update a new player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateUpdatePlayer\";                         
                        target_method_name = opt \"executeUpdatePlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 15 with SNS"

//Set Player Injury

PROPOSAL="(
    record {
        title = \"Create SetPlayerInjury Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to set a players injury.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 13000 : nat64;
                name = \"Add SetPlayerInjury Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to set a players injury.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateSetPlayerInjury\";                         
                        target_method_name = opt \"executeSetPlayerInjury\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 16 with SNS"

//Player Retirement Proposal

PROPOSAL="(
    record {
        title = \"Create RetirePlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to retire a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 14000 : nat64;
                name = \"Add RetirePlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to retire a player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateRetirePlayer\";                         
                        target_method_name = opt \"executeRetirePlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 17 with SNS"

//Unretire Player Proposal

PROPOSAL="(
    record {
        title = \"Create UnretirePlayer Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to unretire a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 15000 : nat64;
                name = \"Add UnretirePlayer Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to unretire a player.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateUnretirePlayer\";                         
                        target_method_name = opt \"executeUnretirePlayer\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 18 with SNS"

//Promote Former Team

PROPOSAL="(
    record {
        title = \"Create PromoteFormerTeam Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to promote a former club into the Premier League.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 16000 : nat64;
                name = \"Add PromoteFormerTeam Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to promote a former club into the Premier League.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validatePromoteFormerTeam\";                         
                        target_method_name = opt \"executePromoteFormerTeam\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 19 with SNS"

//Promote New Team

PROPOSAL="(
    record {
        title = \"Create PromoteNewTeam Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to promote a new club into the Premier League.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 17000 : nat64;
                name = \"Add PromoteNewTeam Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to promote a new club into the Premier League.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validatePromoteNewTeam\";                         
                        target_method_name = opt \"executePromoteNewTeam\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"

echo "Register Generic Proposal Function 20 with SNS"

//Update Team

PROPOSAL="(
    record {
        title = \"Create UpdateTeam Callback Function\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to update a Premier League club's details.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 18000 : nat64;
                name = \"Add UpdateTeam Callback Function\";
                description = opt \"Proposal to create the endpoint for adding the callback function to update a Premier League club's details.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateUpdateTeam\";                         
                        target_method_name = opt \"executeUpdateTeam\";
                    } 
                };
            }
        };
    }
)"

../utils/submit_proposal.sh "$PROPOSAL"
