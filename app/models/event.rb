class Event < ApplicationRecord
    validates :name, {presence: true}
    validates :description, {presence: true}  
    validates :rec_starttime, {presence: true}  
    validates :sdata1, {presence: true}  
    validate :rec_starttime_range_check

    def rec_starttime_range_check
        now = DateTime.now 
        if self.rec_starttime <= now
            errors.add(:rec_starttime, "日時時刻は現在より未来の時間を設定してください。過去時間は設定できません")
        end
    end
end
