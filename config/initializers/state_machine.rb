# Rails 4.1+ and StateMachine don't play well together
# https://github.com/pluginaweek/state_machine/issues/295

require 'state_machine/version'

unless StateMachine::VERSION == '1.2.0'
  Rails.logger.warn "Please remove config/initializers/state_machine.rb because StateMachine has changed."
end

module StateMachine::Integrations::ActiveModel
  public :around_validation
end
