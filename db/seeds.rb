User.find_or_create_by!(email_address: "admin@wmt.local") do |user|
  user.password = "password"
end

[
  { number: 1, score: 52.36, position: 1, comment: "Strong start" },
  { number: 2, score: 48.10, position: 2 },
  { number: 3, score: 61.25, position: 1 },
  { number: 4, score: 55.00, position: 1 },
  { number: 5, score: 44.75, position: 3, comment: "Tough round" },
  { number: 6, score: 39.20, position: 2 },
  { number: 7, score: 67.80, position: 1 }
].each do |attrs|
  Result.find_or_create_by!(number: attrs[:number]) do |result|
    result.score = attrs[:score]
    result.position = attrs[:position]
    result.comment = attrs[:comment]
  end
end
