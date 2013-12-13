class Apartment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :yad2_id, type: String
  field :title, type: String
  field :rooms, type: String
  field :entry_date, type: String
  field :floor, type: String
  field :link, type: String
  field :price, type: String

  embedded_in :query

  validates :yad2_id, uniqueness: true

end
