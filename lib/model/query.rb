class Query
  include Mongoid::Document

  field :to_s, type: String
  embeds_many :apartments

  validates :to_s, uniqueness: true, presence: true, allow_nil: false

  def self.fetch to_s
    find_or_create_by to_s: to_s
  end

  def sync_apartments(hash_apartments)
    hash_apartments.each do |hash|
      apartment = apartments.find_or_initialize_by(yad2_id: hash.delete(:yad2_id))
      apartment.update_attributes(hash)
    end
  end

  index "apartments.yad2_id" => 1
  index({ to_s: 1 }, { unique: true, name: "to_s_index" })
end
