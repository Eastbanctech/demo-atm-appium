WAIT_TIMEOUT = (ENV['WAIT_TIMEOUT'] || 30).to_f
STEP_PAUSE = (ENV['STEP_PAUSE'] || 0.5 ).to_f


When(/^I select "(.*?)" in "(.*?)" field$/) do |value, field|
  if isIos?
    find_element(:xpath, "//UIAPicker[@name='#{field}']/UIAPickerWheel").send_keys(value)
  else
    id("com.eastbanctech.appuimatm:id/#{field}").click
    find(value).click
  end
end

When(/^I type "(.*?)" into the "(.*?)" field$/) do |value, field|
  if isIos?
    find_element(:xpath, "//UIATextField[@name='#{field}']").type(value)
  else
    textfield(field).type(value)
  end
end

Then(/^I confirm dialog((?: if asked)?)$/) do |asked|
  begin
    if isIos?
      driver.send(:bridge).acceptAlert
    else
      # acceptAlert not implemented in Android. Just click on the first button
      first_button.click
    end
  rescue Selenium::WebDriver::Error::UnknownError
    raise 'Can not confirm dialog' if asked.empty?
  end
end

Then(/^I dismiss dialog((?: if asked)?)$/) do |asked|
  begin
    if isIos?
      driver.send(:bridge).dismissAlert
    else
      # acceptAlert not implemented in Android. Just click on the last button
      last_button.click
    end
  rescue Selenium::WebDriver::Error::UnknownError
    raise 'Can not I dismiss dialog' if asked.empty?
  end
end


Then(/^I see the "(.*?)" (screen|text|button|image|alert)$/) do |value, item_type|
  # todo separate on button and image and screen
  $titleArray = value.split('|')
  $titleArray.each do |title|
    begin
      case item_type
        when 'text'
          find(title)
        when 'button'
          button(title)
        when 'image'
        when 'alert'
          if isIos?
            title = title.sub('*','.*')
            alertText = driver.send(:bridge).getAlertText
            if !alertText.match title
              raise 'The alert message was: "' + alertText + '" instead of: "' + title
            end
          else
            # getAlertText is not implemented for Android yet, so we just checking that text exists on the screen
            find(title)
          end

        when 'screen'
          find(title)
        else
          raise 'unknown item type'
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
      raise "Cell with title:'"+title+"' can not be found"
    end
  end

end

When(/^I tap on "(.*?)" (text|button|image)$/) do |value, item_type|
  # todo separate on button and image and screen
  case item_type
    when 'text'
      find(value).click
    when 'button'
      button(value).click
    when 'image'
      raise 'This step is not implemented'
    else
      raise 'unknown item type'
  end
end

Then(/^Scroll to the "(.*?)" (text|button|image)/) do |element_name, item_type|
  # todo separate on button and image and screen
  $driver.execute_script "au.getElementByName('#{element_name}').scrollToVisible()"
end

And(/^The list contains (<|<=|==|=>|>)(\d+) items$/) do |sign, number|
  pending
end

And(/^The list is populated$/) do
  raise 'Android not ready' unless self.isIos?

  cells_in_table = find_elements(:xpath, '//UIAApplication[1]/UIAWindow[1]/UIATableView[1]/UIATableCell')
  if cells_in_table.size == 0
    raise 'The table is empty.'
  end
end

Then(/^I tap back button$/) do
  back
end

Then(/^I swipe from bottom to top$/) do
  $driver.execute_script('mobile: scroll', direction: 'down')
end

Then(/^I swipe from top to bottom$/) do
  $driver.execute_script('mobile: scroll', direction: 'up')
end

And(/^I wait for (\d+(?:\.\d+)?) seconds$/) do |seconds|
  sleep seconds.to_f
end

And(/^I tap on the list item #(\d+)$/) do |rowNum|
  raise 'Android not ready' unless self.isIos?
  cells_in_table = find_elements(:xpath, '//UIAApplication[1]/UIAWindow[1]/UIATableView[1]/UIATableCell')
  cells_in_table[rowNum.to_i+1].click
  Selenium::WebDriver::Element
end


Given(/^I install application from scratch$/) do
  $driver.driver_quit
  if self.isIos?
    scriptFile = ENV['BASE_DIR']+'/utils/ios_uninstall.sh'
    system('sh ' + scriptFile)
  else
    package = $driver.caps[:appPackage]
    scriptFile = ENV['BASE_DIR']+'/utils/android_uninstall.sh'
    system('sh ' + scriptFile + ' ' + package)
  end
  $driver.start_driver
end

And(/^I hide the keyboard$/) do
  begin
    if self.isIos?
      hide_ios_keyboard
    else
      hide_keyboard
    end
  rescue Selenium::WebDriver::Error::TimeOutError
    #ignore timeout
  end
end

When(/^I type "([^"]*)" into the (\d+) textfield$/) do |value, txt_num|
  textfields[txt_num.to_i-1].type value
end