class ChangeMassPayCorrelationIdToCorrelationIdInPayouts < ActiveRecord::Migration
  def change
    rename_column :payouts, :paypal_masspay_correlation_id, :paypal_correlation_id
  end
end
