class Popularity < Reward 
  belongs_to :bar

  attr_accessible :guesses_attributes

  has_many :guesses

  accepts_nested_attributes_for :guesses, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end