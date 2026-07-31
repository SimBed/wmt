require "test_helper"

class ResultTest < ActiveSupport::TestCase
  def setup
    @stats_all = Result.statistics(Result.order_by_number)
    @stats_full_team = Result.statistics(Result.order_by_number.where(full_team: true))
  end
  test "statistics returns score extremes and streaks ordered by number" do
    # Result.delete_all

    # [
    #   [ 1, 52.36, 1, true ],
    #   [ 2, 48.10, 2, false ],
    #   [ 3, 61.25, 1, true ],
    #   [ 4, 55.00, 1, true ],
    #   [ 5, 44.75, 3, true ],
    #   [ 6, 39.20, 2, true ],
    #   [ 7, 67.80, 1, false ]
    # ].each do |number, score, position, full_team|
    #   Result.create!(number:, score:, position:, full_team:)
    # end

    assert_equal({ score: BigDecimal("67.8"), number: 7 }, @stats_all[:highest_score])
    assert_equal({ score: BigDecimal("39.2"), number: 6 }, @stats_all[:lowest_score])
    assert_equal({ length: 2, runs: [ { start_number: 5, end_number: 6 } ] }, @stats_all[:longest_losing_streak])
    assert_equal({ length: 2, runs: [ { start_number: 3, end_number: 4 } ] }, @stats_all[:longest_winning_streak])

    assert_equal({ score: BigDecimal("61.25"), number: 3 }, @stats_full_team[:highest_score])
    assert_equal({ score: BigDecimal("39.2"), number: 6 }, @stats_full_team[:lowest_score])
    assert_equal({ length: 2, runs: [ { start_number: 5, end_number: 6 } ] }, @stats_full_team[:longest_losing_streak])
    assert_equal({ length: 3, runs: [ { start_number: 1, end_number: 4 } ] }, @stats_full_team[:longest_winning_streak])
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
    assert_equal :win, @stats_all[:current_streak][:type]
    assert_equal 1, @stats_all[:current_streak][:count]

    assert_equal :loss, @stats_full_team[:current_streak][:type]
    assert_equal 2, @stats_full_team[:current_streak][:count]

    Result.delete_all

    assert_nil Result.current_streak(Result.order_by_number)
  end

  test "win_rate calculates the percentage of wins" do
    assert_equal 57.14, @stats_all[:win_rate]
    assert_equal 60.0, @stats_full_team[:win_rate]

    Result.delete_all

    assert_nil Result.win_rate(Result.order_by_number)
  end

  test "average_score calculates the average score" do
    assert_equal BigDecimal("52.64"), @stats_all[:average_score]
    assert_equal BigDecimal("50.51"), @stats_full_team[:average_score]

    Result.delete_all

    assert_nil Result.average_score(Result.order_by_number)
  end
  test "highest_score calculates the highest score" do
    assert_equal({ score: BigDecimal("67.80"), number: 7 }, @stats_all[:highest_score])
    assert_equal({ score: BigDecimal("61.25"), number: 3 }, @stats_full_team[:highest_score])

    Result.delete_all

    assert_nil Result.highest_score(Result.order_by_number)
  end
  test "lowest_score calculates the lowest score" do
    assert_equal({ score: BigDecimal("39.20"), number: 6 }, @stats_all[:lowest_score])
    assert_equal({ score: BigDecimal("39.20"), number: 6 }, @stats_full_team[:lowest_score])

    Result.delete_all

    assert_nil Result.lowest_score(Result.order_by_number)
  end
  test "tournament_count calculates the tournament count" do
    assert_equal 7, @stats_all[:tournament_count]
    assert_equal 5, @stats_full_team[:tournament_count]
  end
  test "board_count calculates the board count" do
    assert_equal 56, @stats_all[:board_count]
    assert_equal 40, @stats_full_team[:board_count]
  end
end
