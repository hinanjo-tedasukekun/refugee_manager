class RefugeeSupply < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :supply
end
