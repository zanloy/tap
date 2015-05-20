class Approval < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :approver
end
