class AssignmentEngine

  def self.call
    new.call
  end

  def call
    unassigned_issues.each do |issue|
      next if (cycling_users[issue.category_id].blank? || !cycling_users[issue.category_id].any?)
      next_user = cycling_users[issue.category_id].next
      issue.update(assignee_id: next_user)
    end
  end

  def assign(issue)
    #TODO: assign one issue to random user in scope of the category
  end

  private

  def users_by_category(category_id)
    User.by_category(category_id).pluck(:id)
  end

  def unassigned_issues
    Issue.unassigned.order(:created_at)
  end

  def categories
    unassigned_issues.map(&:category_id)
    # FYI: based on categories count the query can be optimized(if AR cache won't manage)
    # Category.pluck(:id)
  end

  def cycling_users
    @cycling_users ||= begin
      grouped_users = {}
      categories.each do |c_id|
        users_ids = users_by_category(c_id).cycle
        grouped_users[c_id] = users_ids if users_ids.any?
      end
      grouped_users
    end
  end
end
