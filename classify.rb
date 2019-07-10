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

def Tag
  attr_reader :name, :root_dir
  def initialize(name, root_dir)
    @name = name
    @root_dir = root_dir
    ensure_folder
  end

  def tag_file(taggable_file)
    File.link(taggable_file.full_path, "#{full_path}/#{taggable_file.file_name}")
  end

  private
  def ensure_folder
    Dir.mkdir(full_path) unless Dir.exists?(full_path)
  end

  def full_path
    "#{root_dir}/#{name}"
  end
end

