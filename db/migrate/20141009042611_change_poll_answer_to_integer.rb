class ChangePollAnswerToInteger < ActiveRecord::Migration
  def change
    change_column :polls, :answer_1, 'integer USING CAST(answer_1 AS integer)', :default => 0
    change_column :polls, :answer_2, 'integer USING CAST(answer_2 AS integer)', :default => 0
    change_column :polls, :answer_3, 'integer USING CAST(answer_3 AS integer)', :default => 0
  end
end
