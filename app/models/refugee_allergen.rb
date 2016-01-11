class RefugeeAllergen < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :allergen
end
