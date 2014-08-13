class ChangeTypeToFlagTypeInFlags < ActiveRecord::Migration
  def change
    rename_column :flags, :type, :flag_type
    rename_column :flags, :body, :flag_body
  end
end
