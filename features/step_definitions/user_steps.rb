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