class Issue < ApplicationRecord
  belongs_to :category
  include AASM

  aasm do
    state :open, initial: true
    state :working, :finished, :declined, :closed, :assigned

    event :to_open do
      transitions from: [:finished, :declined], to: :open
    end
    event :assign do
      transitions from: [:open, :working], to: :assigned
    end
    event :work do
      transitions from: :assigned, to: :working
    end
    event :finish do
      transitions from: :working, to: :finished
    end
    event :decline do
      transitions from: :working, to: :declined
    end
    event :close do
      transitions from: :finished, to: :closed
    end
  end
end
