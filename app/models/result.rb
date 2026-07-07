class Result < ApplicationRecord
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :order_by_number, -> { order(number: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }

  def win?
    position == 1
  end

  def loss?
    !win?
  end

  def self.current_streak
    results = Result.order_by_number

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
    results = Result.order_by_number.to_a
    current_streak = current_streak()

    {
      current_streak: current_streak,
      longest_winning_streak: longest_streak(results) { |result| result.win? },
      longest_losing_streak: longest_streak(results) { |result| result.loss? },
      highest_score:,
      lowest_score:,
      average_score:,
      win_rate:
    }
  end

  def self.longest_streak(results)
    max_run = 0
    max_start = nil
    max_end = nil

    current_run = 0
    current_start = nil

    results.each do |result|
      if yield(result)
        current_start ||= result.number
        current_run += 1

        if current_run > max_run
          max_run = current_run
          max_end = current_start
          max_start = result.number
        end
      else
        current_run = 0
        current_start = nil
      end
    end

    {
      length: max_run,
      start_number: max_start,
      end_number: max_end
    }
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

    result = Result.order(score: :desc).first

    {
      score: result.score,
      number: result.number
    }
  end

  def self.lowest_score
    return nil unless Result.any?

    result = Result.order(score: :asc).first

    {
      score: result.score,
      number: result.number
    }
  end

  def self.next_number
    return 1 unless Result.any?

    # maximum(:number) + 1
    order_by_created_at.first.number + 1
  end
end
