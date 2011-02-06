Feature: Upload a video
  Scenario: Upload a video as an admin
    Given I have an admin account of "admin@example.com/admin123"
    When I go to the admin page
    Then I should be on login page
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "admin123"
    And press "Log In"
    Then I should be on admin page
    When I go to admin products page
    And I follow "New Product"
    And I fill in "Name" with "Test Video"
    And I fill in "Url" with "images/teste.png"
    And I fill in "Master Price" with "15,00"
    And I press "Create"
    Then I should see "Successfully created!"