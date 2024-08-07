# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :owned_by, ->(user) { where(user:) }

  scope :published, -> { where(secret: false) }

  scope :search, lambda { |term|
    sanitized_term = sanitize_sql_like(term.to_s)
    term_with_wildcard = "%#{sanitized_term}%"
    where('title LIKE ? OR content LIKE ?', term_with_wildcard, term_with_wildcard)
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
