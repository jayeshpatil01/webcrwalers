require 'selenium-webdriver'
require 'nokogiri'
require 'pry'
require 'awesome_print'

def hockey_teams()
  url = 'https://www.scrapethissite.com/pages/forms/'

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options

  driver.get(url)
  page_source = driver.page_source

  html = Nokogiri::HTML(page_source)

  teams = html.css('.team')

  next_page_link = 'https://www.scrapethissite.com/pages/forms/?page_num=2'

  per_page_option_selected = html.css('#per_page option[selected]')
  per_page_option_selected = html.css('#per_page option').first if per_page_option_selected.empty?
  per_page_option_selected = per_page_option_selected.text

  teams_with_minimun_losses = []
  i = 0

  while teams_with_minimun_losses.count < 20
    if teams_with_minimun_losses.count == 0
      teams.each do |team|
        next if team.at_css('.losses').text.strip.to_i > 25
        teams_with_minimun_losses << {
          name: team.at_css('.name').text.strip,
          year: team.at_css('.year').text.strip,
          wins: team.at_css('.wins').text.strip,
          losses: team.at_css('.losses').text.strip
        }
      end
    else
      driver.get(next_page_link)
      html = Nokogiri::HTML(driver.page_source)

      html.css('.team').each do |team|
        next if team.at_css('.losses').text.strip.to_i > 25
        teams_with_minimun_losses << {
          name: team.at_css('.name').text.strip,
          year: team.at_css('.year').text.strip,
          wins: team.at_css('.wins').text.strip,
          losses: team.at_css('.losses').text.strip
        }
      end
      next_page_link = getNextPageLink(next_page_link)
    end
  end
  teams_with_minimun_losses
end

def getNextPageLink(next_page_link)
  next_page_link + (next_page_link.slice!(-1).to_i + 1).to_s
end

puts ap hockey_teams()
