class Category < ActiveRecord::Base
	has_many :words
	has_many :requests
	has_many :collects
end
