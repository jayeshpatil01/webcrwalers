require 'selenium-webdriver'
require 'nokogiri'

url = 'https://www.scrapethissite.com/pages/forms/'
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options

driver.get(url)
page_source = driver.page_source

def hockey_teams(page_source, base_url)
  html = Nokogiri::HTML(page_source)
  teams = html.css('.team')
  next_page_link = html.css('.pagination li a').last['href']
  parsed_url = URI.parse(base_url)
  [parsed_url.scheme, parsed_url.host]
end

puts hockey_teams(page_source, url)