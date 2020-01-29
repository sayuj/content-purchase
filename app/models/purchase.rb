# frozen_string_literal: true

class Purchase < ApplicationRecord
  EXPIRY_DURATION = 2.days

  belongs_to :user
  belongs_to :content, polymorphic: true
  belongs_to :purchase_option

  before_create :set_expiry
  validate :check_duplicate, if: :new_record?

  private

  def set_expiry
    self.expire_at ||= EXPIRY_DURATION.from_now
  end

  def check_duplicate
    return unless Purchase.where(
      user_id: user_id,
      content_type: content_type,
      content_id: content_id
    ).where('expire_at >= ?', Time.now).exists?

    errors.add(:base, 'already purchased')
  end
end
