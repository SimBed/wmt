class Result < ApplicationRecord
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> { order(:number) }

  def win?
    position == 1
  end

  def loss?
    !win?
  end

  def self.statistics
    results = ordered.to_a

    {
      highest_score: results.map(&:score).max,
      lowest_score: results.map(&:score).min,
      longest_win_run: longest_streak(results) { |result| result.win? },
      longest_loss_run: longest_streak(results) { |result| result.loss? }
    }
  end

  def self.longest_streak(results)
    max_run = 0
    current_run = 0

    results.each do |result|
      if yield(result)
        current_run += 1
        max_run = current_run if current_run > max_run
      else
        current_run = 0
      end
    end

    max_run
  end
  private_class_method :longest_streak
end
