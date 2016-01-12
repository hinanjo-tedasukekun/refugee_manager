class RefugeeSkill < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :skill
end
