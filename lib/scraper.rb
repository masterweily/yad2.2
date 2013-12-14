class Scraper

  def initialize(query)
    @query = query
  end

  attr_reader :query

  def url
    @query.url
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


  def get_new_apartments
    apartments = if @query.fake?
      build_fake_apartments
    else
      Capybara.visit url
      table = Capybara.page.find '#main_table'
      trs = table.all "tr[class^='ActiveLink']"
      trs.map do |tr|
        cells = tr.all "td"
        build_appartment(cells)
      end
    end
    @query.sync apartments
    @query.new_apartments
  end

  def build_fake_apartments
    rand(0..3).times.map do
      {
        yad2_id:    rand(0xfffffffffffffffffffffffffffffffffff).to_s(16),
        title:      ['תל אביב','חולון','באר שבע'].sample + ' - לא באמת',
        price:      "#{rand(2..4)},#{rand(10..95)}0 ₪",
        room_count: "#{rand(1..4)}",
        entry_date: "#{[rand(1..30).days.from_now.strftime('%F'),'מיידית'].sample}",
        floor:      "#{[rand(1..4),'קרקע'].sample}",
        link:       'http://www.yad2.co.il?fake=true',
      }
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

end