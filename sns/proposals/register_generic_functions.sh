#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

#Register generic proposal functions

echo "Register Generic Proposal Function 1 with SNS"

PROPOSAL="(
    record {
        title = \"Add Generic Proposal type to create SNS controlled neuron\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that creates the DAO's neuron with 1 ICP to be funded by the DAO's treasury.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 19000 : nat64;
                name = \"Create DAO neuron.\";
                description = opt \"To create the callback functions for creating the DAO controlled neuron with 1 ICP.
                This proposal creates a neuron with 1 ICP.\";
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
        title = \"Add Generic Proposal type to create manage SNS controlled neuron endpoints.\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that creates the DAO's neuron with 1 ICP to be funded by the DAO's treasury.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 20000 : nat64;
                name = \"Manage DAO neuron.\";
                description = opt \"To create the callback functions for managing the DAO controlled neuron.
                This proposal creates a neuron with 1 ICP.\";
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
        title = \"Add a new custom SNS function to increase a Player's Value\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to increase a player's value.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 1000 : nat64;
                name = \"Increase Player Value.\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to decrease a Player's Value \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to decrease a player's value.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 2000 : nat64;
                name = \"Decrease Player Value\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Submit Fixture Data \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to submit fixture data.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 3000 : nat64;
                name = \"Submit Fixture Data\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Add Initial Fixtures \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to add the initial fixtures to a season.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 4000 : nat64;
                name = "Add Initial Fixtures";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Move a Fixture \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to move a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 5000 : nat64;
                name = \"Move a Fixture\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Postpone a Fixture \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to postpone a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 6000 : nat64;
                name = \"Postpone a Fixture\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Rescehdule a Fixture \";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to reschedule a fixture.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 7000 : nat64;
                name = \"Reschedule a Fixture\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Transfer a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to transfer a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 8000 : nat64;
                name = \"Transfer a Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Loan a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to loan a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 9000 : nat64;
                name = \"Loan a Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        validator_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        target_canister_id = opt principal \"bboqb-jiaaa-aaaal-qb6ea-cai\"; 
                        validator_method_name = opt \"validateLoanPlayer\";                         
                        target_method_name = opt \"executeTransferPlayer\";
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
        title = \"Add a new custom SNS function to Recall a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to recall a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 10000 : nat64;
                name = \"Recall a Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Create a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to create a new player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 11000 : nat64;
                name = \"Create Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Update Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to update a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 12000 : nat64;
                name = \"Update Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Set Player Injury\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to set a player's injury status.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 13000 : nat64;
                name = \"Set Player Injury\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Retire a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to retire a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 14000 : nat64;
                name = \"Retire Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Unretire a Player\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to unretire a player.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 15000 : nat64;
                name = \"Unretire Player\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Promote Former Team\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to promote a team has previously paritipated in an OpenFPL season.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 16000 : nat64;
                name = \"Promote Former Team\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Promote New Team\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to promote a new team to the Premier Legaue.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 17000 : nat64;
                name = \"Promote New Team\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
        title = \"Add a new custom SNS function to Update a Team\";          
        url = \"https://github.com/jamesbeadle/OpenFPL/blob/master/src/OpenFPL_backend/main.mo\";        
        summary = \"Adding a new generic proposal that allows the DAO to update an existing team.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 18000 : nat64;
                name = \"Update Team\";
                description = opt \"Import the specified proposals group into the specified community.\";
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
