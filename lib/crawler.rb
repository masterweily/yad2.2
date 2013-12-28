class Crawler
  @instances = {}

  def initialize(query)
    @scraper = Scraper.new(query)
  end

  def start &after_visit
    @thread = Thread.new do
      loop do
        visit &after_visit
        sleep( (25 + rand(-15..15)).minutes + rand(0..59).seconds )
      end
    end
  end

  def stop
    @thread.kill
  end

  def visit &after_visit
    apartments = @scraper.get_new_apartments
    puts "found #{apartments.count} new apartments: #{apartments.map(&:id).join(' | ')}"
    after_visit.call(apartments) if block_given?
  end

  def self.instance_for(query)
    @instances[query.id] ||= Crawler.new(query)
  end
end