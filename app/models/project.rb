# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :client

  validates :name, presence: true

  enum status: {
    created: 10,
    in_progress: 20,
    closed: 30
  }
end
