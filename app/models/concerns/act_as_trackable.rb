module ActAsTrackable
  extend ActiveSupport::Concern

  def track(options)
    event = AssignmentEvent.new
    event.title = 'Assign user'
    event.source_cls = options[:cls]
    event.source_id = options[:issue_id]
    event.action = options[:method]
    if options[:issues_assignees]
      event.options = options[:issues_assignees].map do |i_u|
        { issue: i_u[0], assignee: i_u[1] }
      end
    end
    event.save
  end
end
