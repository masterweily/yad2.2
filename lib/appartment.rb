require 'cgi'
require 'mongo_mapper'
configure do
  MongoMapper.connection = Mongo::MongoClient.new('localhost', 27017)
  MongoMapper.database = 'yad2'
end

class Apartment
  include MongoMapper::Document

  key :yad2_id, String, unique: true
  key :title, String
  key :rooms, String
  key :entry_date, String
  key :floor, String
  key :link, String
  timestamps!

  def self.sync(apartments)
    apartments.each(&:sync)
  end

  def sync
    unless save
      _id = Apartment.find_by_yad2_id(yad2_id)._id
      return save
    end
    true
  end

end
