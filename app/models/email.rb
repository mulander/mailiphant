class Email < ApplicationRecord
    has_many :replies, class_name: "Email", foreign_key: :in_reply_to
end
