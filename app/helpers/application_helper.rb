module ApplicationHelper
  def format_score(score)
    return "—" if score.nil?

    format("%.1f%%", score)
  end
end
