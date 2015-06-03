require 'support/controllers/session_helpers'

RSpec.configure do |config|
  config.extend Controllers::SessionHelpers, type: :controller
end
