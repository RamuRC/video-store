Given /^I have an admin account of "(.+)\/(.+)"$/ do |email, password|
  Factory(:admin_user, :email => email, :password => password, :password_confirmation => password)
end