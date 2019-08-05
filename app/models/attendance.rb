class Attendance < ApplicationRecord
	belongs_to :user
	belongs_to :event

	include Workflow
	workflow_column :state

	workflow do 
		state :request_sent do
			event :accept, :transitions_to => :accepted
			event :reject, :transitions_to => :rejected
		end
		state :accepted
		state :rejected
	end

	def self.show_accepted_attendees(event_id)
		Attendance.where(event_id: event_id, state: :accepted)
	end


	def self.join_event(user_id, event_id, state)
		self.create(user_id: user_id, event_id: event_id, state: state)
	end
end
