# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :name, presence: true
end
