class Scraper

  def initialize(ad_type,params)
    @ad_type = ad_type
    @params = params
  end

  Capybara.register_driver :poltergeist do |app|
    options = {
      phantomjs_options: ["--disk-cache=true", "--load-images=false"],#, "--ignore-host='(google.com|google-analytics.com)'"],
      js_errors: false
    }

    Capybara::Poltergeist::Driver.new(app, options)
  end

  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = :poltergeist

  Capybara.configure do |config|
    config.ignore_hidden_elements = true
    config.visible_text_only = true
    config.page.driver.add_headers( "User-Agent" =>
                                      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1" )
  end


  def load_apartments
    Capybara.visit url
    table = Capybara.page.find '#main_table'
    trs = table.all "tr[class^='ActiveLink']"
    trs.map do |tr|
      cells = tr.all "td"
      build_appartment(cells)
    end
  end

  def build_appartment(cells)
    link = "http://www.yad2.co.il/Nadlan/" + cells[24].all("a").last['href'].to_s
    {
      yad2_id:    CGI::parse(link).values.first.first,
      title:      cells[8].text,
      price:      cells[10].text,
      room_count: cells[12].text,
      entry_date: cells[14].text,
      floor:      cells[16].text,
      link:       link,
    }
  end

  def url
    @url ||= create_url
  end

  def create_url
    uri = Addressable::URI.new
    uri.host = 'www.yad2.co.il'
    uri.path = "/Nadlan/#{@ad_type}.php"
    uri.scheme = 'http'
    uri.query_values = @params
    url = uri.to_s
    url
  end


end