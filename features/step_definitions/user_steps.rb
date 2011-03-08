Given /^the user "(.+)\/(.+)"$/ do |email, password|
  Factory(:user, :email => email, :password => password, :password_confirmation => password)
end

Given /a country/ do
  1.upto(214) do
    Country.create! :name => 'United States', :iso_name => 'UNITED STATES', :iso => 'US', :iso3 => "USA", :numcode => 840
  end
end

Given /a state/ do
  State.create! :name => 'Marylan', :country_id => 1, :abbr => 'MD'
end

Given /^the user already bought the videos "([^"]*)"$/ do |videos|
  videos = videos.split(",")
  videos.each do |video|
    When %{I go to "#{video}" product page}
    And %{I press "Add To Cart"}
    And %{I follow "Checkout"}
    And %{I fill in "First Name" with "User"}
    And %{I fill in "Last Name" with "Test"}
    And %{I fill in "Street Address" with "Test St."}
    And %{I fill in "City" with "Test"}
    And %{I fill in "Zip" with "111"}
    And %{I select "United States" from "Country"}
    And %{I fill in "Phone" with "000"}
    And %{I press "Save and Continue"}
    And %{I press "Save and Continue"}
    And %{I press "Place Order"}
  end
end
