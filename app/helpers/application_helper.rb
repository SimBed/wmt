module ApplicationHelper
  def format_score(score)
    return "—" if score.nil?

    format("%.2f%%", score)
  end
end
