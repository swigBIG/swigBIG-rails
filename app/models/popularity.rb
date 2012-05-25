class Popularity < Reward 
  belongs_to :bar

  has_many :popularity_inviters
end