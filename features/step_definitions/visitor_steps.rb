def new_user
  @user ||= { :email => "example@example.com",
    :password => "please", :password_confirmation => "please" }
end

def invitation_request user
  visit '/users/sign_up'
  click_button "Request invite"
  fill_in "Email", :with => user[:email]
  click_button "Request Invitation"
end

When /^I visit the home page$/ do
    visit root_path
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in field, with: value
end

When /^I click a button "([^"]*)"$/ do |arg1|
  click_button (arg1)
end

When /^I follow "(.*?)"$/ do |link|
  click_link(link)
end

Then /^I should see a form with a field "([^"]*)"$/ do |arg1|
  page.should have_content (arg1)
end

Then /^I should see a message "([^\"]*)"$/ do |arg1|
  page.should have_content (arg1)
end


Then /^I should see an invitation thank you message$/ do
  save_wait_time = Capybara.default_wait_time
  Capybara.default_wait_time = 60
  page.find('h1').should have_content ('Thank you')
  Capybara.default_wait_time = save_wait_time
end

Then /^my email address should be stored in the database$/ do
  test_user = User.find_by_email("example@example.com")
  test_user.should respond_to(:email)
end

Then /^my account should be unconfirmed$/ do
# Occasionally emits this message (when using webkit?):
# QNetworkReplyImplPrivate::error: Internal problem, this method must only be called once.

  test_user = User.find_by_email("example@example.com")
  test_user.confirmed_at.should be_nil
end

When /^I request an invitation with valid user data$/ do
  invitation_request new_user
end

When /^I request an invitation with an invalid email$/ do
  user = new_user.merge(:email => "notanemail")
  invitation_request user
end
