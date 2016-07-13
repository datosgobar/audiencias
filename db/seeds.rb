if ENV['fake']
  require_relative './seeds/fake'
elsif ENV['historic']
  require_relative './seeds/historic'
end