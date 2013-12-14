class Query
  include Mongoid::Document

  field :to_s, type: String
  embeds_many :apartments

  validates :to_s, uniqueness: true, presence: true, allow_nil: false

  def self.fetch params
    to_s = params.is_a?(Hash) ? create_url(params) : params.to_s
    find_or_create_by to_s: to_s
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
    true # todo
  end

  index "apartments.yad2_id" => 1
  index({ to_s: 1 }, { unique: true, name: "to_s_index" })
end
