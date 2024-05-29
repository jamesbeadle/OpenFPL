
#!/bin/bash

# Set current directory to the scripts root
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR/..

PROPOSAL="(
    record {  
        title = \"Add developer frontend prepare permission\";  
        url = \"https://github.com/jamesbeadle/OpenFPL\";  
        summary = \"
            This will add the developer frontend canister prepare permission for James Beadle, principal ID 4jijx-ekel7-4t2kx-32cyf-wzo3t-i4tas-qsq4k-ujnug-oxke7-o5aci-eae.
        \";
        action = opt variant { 
            Upgrade = record { 
                set_permissions = opt record { 
                    prepare = vec { 
                        principal \"4jijx-ekel7-4t2kx-32cyf-wzo3t-i4tas-qsq4k-ujnug-oxke7-o5aci-eae\"; 
                    }; 
                commit = vec { principal \"detjl-sqaaa-aaaaq-aacqa-cai\"; }; 
                manage_permissions = vec { principal \"detjl-sqaaa-aaaaq-aacqa-cai\"; 
                };
            } 
        } 
    })"

../utils/submit_proposal.sh "$PROPOSAL"
  