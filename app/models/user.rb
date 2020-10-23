class User < ApplicationRecord
  has_and_belongs_to_many :categories

  # FYI: in case of complex queries, move retrieve code to a service object
  scope :by_category, ->(category_id) { joins(:categories).where(categories: { id: category_id }) }
end
