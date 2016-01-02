module Subdomain
  class Admin
    def self.matches?(request)
      request.subdomain == 'admin'
    end
  end
end
