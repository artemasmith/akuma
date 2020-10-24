class AssignmentEngine

  def self.call
    new.call
  end

  def self.assign(issue)
    new.assign(issue)
  end

  def call
    unassigned_issues.each do |issue|
      next if no_users_for_category?(issue.category_id)

      # FYI: Round robin for users in category
      next_user = cycling_users[issue.category_id].next
      issue.update(assignee_id: next_user)
    end
  end

  def assign(issue)
    user_id = User.by_category(issue.category_id).sample&.id if issue.category_id

    # FYI: No category => random assignee
    user_id ||= User.pluck(:id).sample
    issue.update(assignee_id: user_id)
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

  def no_users_for_category?(category_id)
    cycling_users[category_id].blank? || cycling_users[category_id].none?
  end
end
