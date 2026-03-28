class Inquiry < ApplicationRecord
  belongs_to :service, optional: true

  enum status: {
    new_inquiry:  0,
    in_progress:  1,
    completed:    2,
    cancelled:    3
  }

  validates :name,    presence: true, length: { maximum: 100 }
  validates :phone,   presence: true,
                      format: { with: /\A[\+\d\s\(\)\-]{7,20}\z/, message: "неверный формат" }
  validates :email,   format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :message, length: { maximum: 2000 }

  scope :recent, -> { order(created_at: :desc) }

  STATUS_LABELS = {
    "new_inquiry"  => { text: "Новая",      css: "bg-blue-100 text-blue-800" },
    "in_progress"  => { text: "В работе",   css: "bg-yellow-100 text-yellow-800" },
    "completed"    => { text: "Завершена",  css: "bg-green-100 text-green-800" },
    "cancelled"    => { text: "Отменена",   css: "bg-red-100 text-red-800" }
  }.freeze

  def status_label
    STATUS_LABELS[status] || { text: status, css: "bg-gray-100 text-gray-800" }
  end
end
