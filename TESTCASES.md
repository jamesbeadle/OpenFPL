# Test Cases for OpenFPL

This document provides detailed test cases for the OpenFPL application. Each test case is designed to verify the functionality and performance of the application under various conditions. Below are examples of test cases that can be used as a template for further testing.

## Test Case Template

- **Test Case ID**: TC_unique_number
- **Title**: Short descriptive name of the functionality to be tested.
- **Description**: A detailed description of the test case.
- **Preconditions**: Any prerequisites that must be met before the test can be executed.
- **Test Steps**: Step-by-step instructions on how to carry out the test.
- **Expected Results**: The expected outcome of the test.
- **Actual Results**: The actual outcome of the test (to be filled after the test execution).
- **Status**: Pass/Fail (to be filled after the test execution).
- **Remarks**: Any additional comments or observations.

## Example Test Cases

### Test Case 1: User Registration

- **Test Case ID**: TC_001
- **Title**: User is able to register a new account.
- **Description**: This test case ensures that the user can register a new account in the OpenFPL application.
- **Preconditions**: The application is installed and opened to the registration screen.
- **Test Steps**:
  1. Navigate to the registration screen.
  2. Enter a valid username, email, and password.
  3. Click the 'Register' button.
- **Expected Results**: The user should receive a confirmation message and be taken to the login screen.
- **Actual Results**: 
- **Status**: 
- **Remarks**: 


Setup Testing Procedure
- Auto generate fixtures
- Setup the system for each scenario

	


- double gameweek
- postponed game
	- result stands
	- replayed from minute
	- replayed
- Bonuses
- January Transfer Window
- Unlimited Transfers
- Captain Scenarios
- Leaderboards
	- Weekly
	- Monthly
	- Season
- Changing your favourite teams can only be done before the first gameweek begins
- Reward distributions
- Test all proposal types
    - Retired move to retirement canister
    - Unretired move back
    - Move to external club canister
    - Move back to Live players canister
    - Transfer a player to another premier league club
- canisters created
- canisters topped up
- Update parent club information effectively setting their transfer status loaned players
- cannot make more than available changes per week unless first gameweek or jan transfer wildcard played and they can never go below zero
- local storage data is managed and cleared up
    - - Ensuse a users cache is cleared when a new season starts by updating the cache hash values 
- ensuring the sequential order of ids on types that require them
- ensure that players can only be moved to the retired or former player canisters after they have been removed from all teams
- a teams bank balance and value accurate changes when players are added or removed
- The scenario of a new gameweek starting before the prior gameweek is verified (overlapping gameweeks)
- rolling over of seasons
    - Need to test season dropdown filters on all views when sesaon rolled over
- all invalid create fantasy team scenarios
- governance rewards are distributed in a spread out manner
- governance rewards are distributed at the correct %
- Large user volume testing
    - Calculation cycle usage
    - Pagination with cahcing
- All data caches update correctly when required

- Listed security concerns
