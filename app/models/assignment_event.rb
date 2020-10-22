class AssignmentEvent < Event
  def issue
    Issue.find_by(id: options['issue'])
  end

  def assignee
    User.find_by(id: options['assignee'])
  end

  def solution
    options['solution']
  end
end