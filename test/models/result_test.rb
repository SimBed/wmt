require "test_helper"

class ResultTest < ActiveSupport::TestCase
  test "statistics returns score extremes and streaks ordered by number" do
    Result.delete_all

    [
      [ 1, 52.36, 1 ],
      [ 2, 48.10, 2 ],
      [ 3, 61.25, 1 ],
      [ 4, 55.00, 1 ],
      [ 5, 44.75, 3 ],
      [ 6, 39.20, 2 ],
      [ 7, 67.80, 1 ]
    ].each do |number, score, position|
      Result.create!(number:, score:, position:)
    end

    stats = Result.statistics

    assert_equal({ score: BigDecimal("67.8"), number: 7 }, stats[:highest_score])
    assert_equal({ score: BigDecimal("39.2"), number: 6 }, stats[:lowest_score])
    assert_equal({ length: 2, start_number: 5, end_number: 6 }, stats[:longest_losing_streak])
    assert_equal({ length: 2, start_number: 3, end_number: 4 }, stats[:longest_winning_streak])
  end

  test "win and loss are based on position 1" do
    result = Result.new(position: 1)
    assert result.win?
    refute result.loss?

    result.position = 2
    refute result.win?
    assert result.loss?
  end

  test "current_streak" do
    Result.delete_all

    assert_nil Result.current_streak

    Result.create!(number: 1, score: 50.0, position: 1)
    Result.create!(number: 2, score: 45.0, position: 2)
    Result.create!(number: 3, score: 60.0, position: 1)

    streak = Result.current_streak
    assert_equal :win, streak[:type]
    assert_equal 1, streak[:count]

    Result.create!(number: 4, score: 55.0, position: 1)

    streak = Result.current_streak
    assert_equal :win, streak[:type]
    assert_equal 2, streak[:count]

    Result.create!(number: 5, score: 40.0, position: 3)

    streak = Result.current_streak
    assert_equal :loss, streak[:type]
    assert_equal 1, streak[:count]
  end

  test "win_rate calculates the percentage of wins" do
    Result.delete_all

    assert_nil Result.win_rate

    Result.create!(number: 1, score: 50.0, position: 1)
    Result.create!(number: 2, score: 45.0, position: 2)
    Result.create!(number: 3, score: 60.0, position: 1)
    Result.create!(number: 4, score: 55.0, position: 3)

    assert_equal 50.0, Result.win_rate
  end

  test "average_score calculates the average score" do
    Result.delete_all

    assert_nil Result.average_score

    Result.create!(number: 1, score: 50.0, position: 1)
    Result.create!(number: 2, score: 45.0, position: 2)
    Result.create!(number: 3, score: 60.0, position: 1)
    Result.create!(number: 4, score: 55.0, position: 3)

    assert_equal BigDecimal("52.50"), Result.average_score
  end
end
