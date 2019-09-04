require 'pp'
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
  def to_s; name; end
  def pp; name; end

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
tags.sort_by { |t| t.name.downcase }.each_with_index { |tag,i| tags_by_index[i + 1] = tag }
reached_starting_point = false

starting_point = ENV['STARTING_POINT']

Dir.new(root_dir).children.sort.each do |child|
  next unless child.downcase.end_with?('jpg') || child.downcase.end_with?('png')
  reached_starting_point = child == starting_point unless reached_starting_point
  next unless reached_starting_point

  file = TaggableFile.new(child, root_dir)
  `open '#{file.full_path}'`
  pp tags_by_index.map { |i,t| "#{i}:#{t.name}"}
  puts "enter tag indices separated by commas"
  puts child
  input_tags = gets.strip
  input_tags.split(',').map(&:to_i).reject(&:zero?).each do |index|
    tag = tags_by_index[index]
    tag.tag_file(file)
  end
end
