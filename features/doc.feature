Feature: Documentation
  Here is the list of commonly-used steps.

  @ignore
  Scenario: Documentation scenario
	Given I see the "MY STATEMENTS" screen
	#Given I see the "MY STATEMENTS" screen|text|button|image
	#screen - is navigation/action bar title

		And I tap on "Log In" text
	#And I tap on "Log In" text|button|image

		And I wait for 3 seconds

		And The list is populated
 	# list view is visible and contain elements (it can be list with 1 "empty list" element)

		And The list contains >1 items
		And The list contains ==2 items
		And The list contains <=2 items
	#covering all the situations when list have header and we need to sure that not empty view is there, or when we know the exact amount of rows

  		And I tap on the list item #1
	#tap on the Nth row in the list

		And I select "Business" in "Account Type" field
		And I type "Vasya" into the "Full Name" field
	#dealing with forms

		And Scroll to the "SUBMIT" text|button|image
		And I swipe from bottom to top
		And I swipe from top to bottom
	#scrolling and swiping

		And I see the "You are now enrolled in AutoPay. Please continue to pay your bill until your payment coupon on the billing statement says AUTOPAY." alert
		And I confirm dialog
		And I confirm dialog if asked
		And I dismiss dialog
		And I dismiss dialog if asked
	#dealing with alerts

  		And I tap back button
 	#dealing with phone controls

  #todo pickers, home button, swipe left/righ for menu panels

