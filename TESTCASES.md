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

### Test Case 2: Team Selection

- **Test Case ID**: TC_002
- **Title**: User is able to select and save a football team.
- **Description**: This test case verifies that the user can select players to form a team and save it.
- **Preconditions**: User is logged in and has available budget for player selection.
- **Test Steps**:
  1. Navigate to the 'Select Team' section.
  2. Choose 11 players within the given budget.
  3. Click the 'Save Team' button.
- **Expected Results**: The team should be saved successfully, and the user should see their selected team in the 'My Team' section.
- **Actual Results**: 
- **Status**: 
- **Remarks**: Ensure that the budget is not exceeded and that the player positions meet the game rules.

---

Remember to update the **Actual Results** and **Status** after performing each test case. Additionally, you can add more test cases by following the structure provided in the template. For automated tests, you can include the test script location and execution commands.
