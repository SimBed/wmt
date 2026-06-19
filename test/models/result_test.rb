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

    assert_equal BigDecimal("67.80"), stats[:highest_score]
    assert_equal BigDecimal("39.20"), stats[:lowest_score]
    assert_equal 2, stats[:longest_win_run]
    assert_equal 2, stats[:longest_loss_run]
  end

  test "win and loss are based on position 1" do
    result = Result.new(position: 1)
    assert result.win?
    refute result.loss?

    result.position = 2
    refute result.win?
    assert result.loss?
  end
end
