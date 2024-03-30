

#Simulate SNS Sale

SNS_TESTING_INSTANCE=$(
   docker run -p 8000:8000 -p 8080:8080 -v "`pwd`":/dapp -d ghcr.io/dfinity/sns-testing:main dfx start --clean
)
while ! docker logs $SNS_TESTING_INSTANCE 2>&1 | grep -m 1 'Dashboard:'
do
   echo "Awaiting local replica ..."
   sleep 3
done

docker exec -it $SNS_TESTING_INSTANCE bash setup_locally.sh

./cleanup.sh

./deploy_canisters.sh
./let_nns_control_dapp.sh
./propose_sns.sh

./participate_sns_swap.sh 10 100 
./participate_sns_swap.sh 10 200 
./participate_sns_swap.sh 10 300 
./participate_sns_swap.sh 10 400 
./participate_sns_swap.sh 10 500 
./participate_sns_swap.sh 10 600 
./participate_sns_swap.sh 10 700 
./participate_sns_swap.sh 10 800 
./participate_sns_swap.sh 10 900 
./participate_sns_swap.sh 10 1000 


