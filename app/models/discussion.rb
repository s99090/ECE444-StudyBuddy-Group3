class Discussion < ApplicationRecord
    belongs_to :course
    has_many :comments
end