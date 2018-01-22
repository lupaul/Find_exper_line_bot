class NaverLine::Content < ApplicationRecord
  belongs_to :account, class_name: "NaverLine::Account", foreign_key: :line_user_id
end
