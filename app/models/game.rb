class Game < ActiveRecord::Base
	has_many :words
	has_and_belongs_to_many :users
end
