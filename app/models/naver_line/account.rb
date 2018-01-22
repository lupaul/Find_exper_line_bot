class NaverLine::Account < ApplicationRecord
  has_many :contents, class_name: "NaverLine::Content", foreign_key: :line_user_id
end
