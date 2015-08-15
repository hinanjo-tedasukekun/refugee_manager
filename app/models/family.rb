class Family < ActiveRecord::Base
  enum at_home: {
    undefined: 0, # $BL$;XDj(B
    at_home: 1,   # $B:_BpHrFq(B
    in_refuge: 2  # $BHrFq=j$GHrFq$9$k(B
  }

  validates :num_of_members,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0
    }
  validates :at_home,
    presence: true
  validates :postal_code,
    allow_blank: false,
    format: { with: /\A(\d{7})?\Z/ }
end
