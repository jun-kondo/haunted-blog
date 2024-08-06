# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :my_blogs, ->(user) { Blog.where(user_id: user.id) }

  scope :published, -> { where(secret: false) }

  scope :search, lambda { |term|
    term = '' if term.nil? || term.strip.empty?
    sanitized_term = sanitize_sql_like(term)
    title_query = content_query = "%#{sanitized_term}%"
    where('title LIKE ? OR content LIKE ?', title_query, content_query)
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
