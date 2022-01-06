class Event < ApplicationRecord
    validates :name, {presence: true}
    validates :description, {presence: true}  
    validates :rec_starttime, {presence: true}  
    validates :sdata1, {presence: true}  
end
