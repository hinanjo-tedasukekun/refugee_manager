# vim: filetype=ruby
json.timestamp(@timestamp)

json.(@shelter, :num, :name, :address)
json.postal_code(@shelter.formatted_postal_code)
json.refugees do
  json.total(@num_of_refugees)
  json.registered(@num_of_registered_refugees)
  json.present(@num_of_present_refugees)
end
