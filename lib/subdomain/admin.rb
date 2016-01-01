module Subdomain
  class Admin
    def self.match?(request)
      request.subdomain == 'admin'
    end
  end
end
