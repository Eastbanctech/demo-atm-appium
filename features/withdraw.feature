Feature: Account Holder withdraws cash

User-story:
As an Account Holder
  I want to withdraw cash from an ATM
  So that I can get money when the bank is closed


Scenario: Savings account has sufficient funds
  Given I see the "Appium ATM > Withdraw" screen
  Then I see the "5000" text

  When I type "500" into the "amount" field
    And I tap on "Get cash" button

  Then I see the "Please take your money from the dispenser" alert
    And I confirm dialog
    And I see the "4500" text


Scenario: Savings account has insufficient funds
  Given I see the "Appium ATM > Withdraw" screen
    And I select "Savings account" in "accountType" field

  Then I see the "100" text

  When I type "200" into the "amount" field
    And I tap on "Get cash" button

    Then I see the "Insufficient funds" alert