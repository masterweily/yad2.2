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
  field :last_seen, type: Time, default: 1.second.ago
  field :archived, type: Boolean, default: false
  field :notes, type: String, default: ''

  embedded_in :query

  validates :yad2_id, uniqueness: true

  def new?
    created_at > last_seen
  end

  def updated?
    updated_at > last_seen
  end

  def archive!
    update_attribute(:archived,true)
  end

  def seen!
    update_attribute :last_seen, Time.now
  end

end
