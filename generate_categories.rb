require 'yaml'

# 投稿からカテゴリ一覧を取得
posts_dir = "_posts"
puts "Checking posts in: #{posts_dir}"

# 投稿ファイル一覧を表示
posts = Dir.glob("#{posts_dir}/*.md")
puts "Found #{posts.size} posts: #{posts.join(', ')}"

categories = posts.map do |file|
  puts "Reading file: #{file}"
  content = File.read(file)
  # YAMLを安全に読み込み、Dateクラスを許可
  front_matter = YAML.safe_load(content.split("---")[1], permitted_classes: [Date])
  category = front_matter["category"]
  puts "Found category: #{category || 'None'}"
  category
end.uniq.compact

puts "Unique categories: #{categories.join(', ')}"

# カテゴリごとにファイル生成
categories.each do |category|
  filename = "category/#{category}.md"
  File.open(filename, "w") do |f|
    f.write <<~CONTENT
      ---
      layout: category
      category: "#{category}"
      permalink: /category/#{category}/
      ---
    CONTENT
  end
  puts "Generated: #{filename}"
end

puts "No categories found to generate." if categories.empty?