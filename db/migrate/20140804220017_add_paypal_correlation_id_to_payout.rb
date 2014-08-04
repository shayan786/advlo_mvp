class AddPaypalCorrelationIdToPayout < ActiveRecord::Migration
  def change
    add_column :payouts, :paypal_masspay_correlation_id, :string
  end
end
