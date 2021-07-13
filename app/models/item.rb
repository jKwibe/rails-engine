class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant_id, presence: true, numericality: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  scope :find_match_by_name, ->(name) do
    where('name Ilike ?', "%#{name}%")
      .order('LOWER(name)')
  end

  def self.top_items_by_revenue(quantity)
    joins(invoices: :transactions)
      .where({ transactions: { result: 'success' } }, { invoices: { status: 'shipped' } })
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .order('total_revenue desc')
      .limit(quantity)
  end

  def total_revenue
    invoices.joins(:transactions).where({ transactions: { result: 'success' } }, { invoices: { status: 'shipped' } })
            .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
