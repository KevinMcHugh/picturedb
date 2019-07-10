class TaggableFile
  attr_reader :file_name, :root_dir
  def initialize(file_name, root_dir)
    @file_name = file_name
    @root_dir = root_dir
  end

  def full_path
    "#{root_dir}/#{file_name}"
  end
end

class Tag
  attr_reader :name, :root_dir
  def initialize(name, root_dir)
    @name = name
    @root_dir = root_dir
    ensure_folder
  end

  def tag_file(taggable_file)
    new_file_path = "#{full_path}/#{taggable_file.file_name}"
    File.symlink(taggable_file.full_path, new_file_path) unless File.exists?(new_file_path)
  end

  private
  def ensure_folder
    Dir.mkdir(full_path) unless Dir.exists?(full_path)
  end

  def full_path
    "#{root_dir}/#{name}"
  end
end

root_dir = "/Users/kev/Dropbox/Camera Uploads"
existing_tags = Dir.new(root_dir).children.find_all { |child| Dir.exist?("#{root_dir}/#{child}") }
tags = existing_tags.map { |t| Tag.new(t, root_dir) }

tags_by_index = {}
tags.each_with_index { |tag,i| tags_by_index[i + 1] = tag }

Dir.new(root_dir).children.each do |child|
  file = TaggableFile.new(child, root_dir)
  `open '#{file.full_path}'`
  puts tags_by_index
  puts "enter tag indices separated by commas"
  input_tags = gets.strip
  input_tags.split(',').map(&:to_i).reject(&:zero?).each do |index|
    tag = tags_by_index[index]
    tag.tag_file(file)
  end
  raise "just testing."
end
