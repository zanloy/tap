require 'support/features/session_helpers'

RSpec.configure do |config|
  config.extend Features::SessionHelpers, type: :feature
end
