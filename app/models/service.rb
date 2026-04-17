class Service < ApplicationRecord
  has_one_attached :image

  CATEGORIES = %w[therapy periodontology orthodontics implantology prosthodontics dental_lab xray].freeze

  CATEGORY_LABELS = {
    "therapy"        => "Терапия",
    "periodontology" => "Пародонтология",
    "orthodontics"   => "Ортодонтия",
    "implantology"   => "Имплантология",
    "prosthodontics" => "Ортопедия (протезирование)",
    "dental_lab"     => "Зуботехническая лаборатория",
    "xray"           => "Рентгенография"
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
    if price_rub.nil?
      "По запросу"
    elsif price_rub.zero?
      "Бесплатно"
    else
      formatted = price_rub.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1 ').reverse
      "от #{formatted} ₽"
    end
  end
end
