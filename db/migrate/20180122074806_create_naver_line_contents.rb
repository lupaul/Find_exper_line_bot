class CreateNaverLineContents < ActiveRecord::Migration[5.1]
  def change
    create_table :naver_line_contents do |t|
      t.string :line_user_id, index: true
      t.string :display_name
      t.string :content
      t.timestamps
    end
  end
end
