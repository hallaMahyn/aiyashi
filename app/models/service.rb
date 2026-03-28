class Service < ApplicationRecord
  has_one_attached :image

  CATEGORIES = %w[dentistry ophthalmology orthopedics oncology cosmetic checkup].freeze

  CATEGORY_LABELS = {
    "dentistry"     => "Стоматология",
    "ophthalmology" => "Офтальмология",
    "orthopedics"   => "Ортопедия",
    "oncology"      => "Онкология",
    "cosmetic"      => "Косметология",
    "checkup"       => "Чекап"
  }.freeze

  validates :name,     presence: true, length: { maximum: 120 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :price_rub, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active,      -> { where(active: true) }
  scope :ordered,     -> { order(:position, :name) }
  scope :by_category, ->(cat) { where(category: cat) }

  def category_label
    CATEGORY_LABELS[category] || category
  end

  def price_display
    if price_rub
      formatted = price_rub.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1 ').reverse
      "от #{formatted} ₽"
    else
      "По запросу"
    end
  end
end
