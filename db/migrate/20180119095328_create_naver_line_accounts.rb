class CreateNaverLineAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :naver_line_accounts do |t|
      t.integer :user_id, index: true
      t.string :line_user_id
      t.string :display_name
      t.string :picture_url
    	t.string :status_message
      t.time :line_time_at
      t.timestamps
    end
  end
end
