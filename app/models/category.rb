class Category < ActiveRecord::Base
	has_many :words
	has_many :requests
end
