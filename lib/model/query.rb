class Query
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String

  embeds_many :apartments

  validates :url, uniqueness: true, presence: true, allow_nil: false

  def self.fetch arg
    url = arg.is_a?(Hash) ? create_url(arg) : arg.to_s
    find_or_create_by url: url
  end

  def self.create_url(params)
    uri = Addressable::URI.new
    uri.host = 'www.yad2.co.il'
    uri.path = "/Nadlan/rent.php"
    uri.scheme = 'http'
    uri.query_values = params
    url = uri.to_s
    url
  end

  def sync(hash_apartments)
    hash_apartments.each do |hash|
      apartment = apartments.find_or_initialize_by(yad2_id: hash.delete(:yad2_id))
      apartment.update_attributes(hash)
    end
  end

  def new_apartments
    apartments.select(&:new?) # TODO move filter into the db query
  end

  def fake?
    /fake=true/ === url
  end

  index "apartments.yad2_id" => 1
  index({ url: 1 }, { unique: true, name: "url_index" })
end
