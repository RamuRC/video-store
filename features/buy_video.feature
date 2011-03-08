Feature: Buy a video
  Scenario: Buy a video as a client
    Given the user "user@example.com/password"
    And the product video
    | name  | url      | price |
    | Test  | test.mp4 | 15.00 |
    And a country
    And a state
    When I go to login page
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And press "Log In"
    And I go to the homepage
    When I follow "Test"
    Then I should be on "Test" product page
    When I press "Add To Cart"
    Then I should be on shopping cart page
    When I follow "Checkout"
    Then I should be on checkout page
    When I fill in "First Name" with "User"
    And I fill in "Last Name" with "Test"
    And I fill in "Street Address" with "Test St."
    And I fill in "City" with "Test"
    And I fill in "Zip" with "111"
    And I select "United States" from "Country"
    And I fill in "Phone" with "000"
    And I press "Save and Continue"
    Then I should be on checkout payment page
    When I press "Save and Continue"
    Then I should be on checkout confirm page
    When I press "Place Order"
    Then I should see "Your order has been processed successfully"
    When I follow "Watch now"
    Then I should be on watch now "Test" page
    And I should see "Test"

  Scenario: Try to watch a video not checked out
    Given the user "user@example.com/password"
    And the product video
    | name  | url      | price |
    | Test  | test.mp4 | 15.00 |
    And a country
    And a state
    When I go to login page
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And press "Log In"
    And I go to watch now "Test" page
    Then I should be on "Test" product page

  Scenario: Try to watch a video without being logged in
    Given the user "user@example.com/password"
    And the product video
    | name  | url      | price |
    | Test  | test.mp4 | 15.00 |
    And a country
    And a state
    When I go to watch now "Test" page
    Then I should be on login page

  Scenario: Dont let the user buy repeated videos
    Given the user "user@example.com/password"
    And the product video
    | name  | url      | price |
    | Test  | test.mp4 | 15.00 |
    And a country
    And a state
    When I go to login page
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And press "Log In"
    Given the user already bought the videos "Test"
    When I go to the homepage
    Then I should see "Watch now!" within "#product_1"
    When I follow "Test"
    Then I should be on watch now "Test" page
