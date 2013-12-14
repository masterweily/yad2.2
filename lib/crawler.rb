class Crawler
  @instances = {}

  def initialize(query)
    @scraper = Scraper.new(query)
  end

  def start &after_visit
    puts 'start'
    @thread = Thread.new do
      loop do
        puts 'loop'
        # visit &after_visit
        sleep(40.seconds)
      end
    end
  end

  def stop
    puts 'stop'
    @thread.kill
  end

  def visit &after_visit
    puts 'visit'
    apartments = @scraper.get_new_apartments
    puts apartments
    after_visit.call(apartments) if block_given?
    puts 'after after_visit'
  end

  def self.instance_for(query)
    @instances[query.id] ||= Crawler.new(query)
  end
end