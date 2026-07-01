class Result < ApplicationRecord
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # scope :ordered, -> { order(number: :desc) }
  scope :ordered, -> { order(created_at: :desc) }

  def win?
    position == 1
  end

  def loss?
    !win?
  end

  def self.current_streak
    results = Result.ordered

    return nil if results.empty?

    first_is_win = results.first.win?
    count = 0

    results.each do |result|
      is_win = result.win?

      break if is_win != first_is_win

      count += 1
    end

    {
      type: first_is_win ? :win : :loss,
      count: count
    }
  end

  def self.statistics
    results = ordered.to_a
    current_streak = current_streak()

    {
      current_streak: current_streak,
      longest_win_run: longest_streak(results) { |result| result.win? },
      longest_loss_run: longest_streak(results) { |result| result.loss? },
      highest_score:,
      lowest_score:,
      average_score:,
      win_rate:
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

  def self.average_score
    return nil unless Result.any?

    Result.average(:score).to_f.round(2)
  end

  def self.win_rate
    return nil unless Result.any?

    wins = Result.where(position: 1).count
    total = Result.count

    (wins.to_f / total * 100).round(2)
  end

  def self.highest_score
    return nil unless Result.any?

    Result.maximum(:score)
  end

  def self.lowest_score
    return nil unless Result.any?

    Result.minimum(:score)
  end

  def self.next_number
    return 1 unless Result.any?

    # maximum(:number) + 1
    ordered.first.number + 1
  end
end
