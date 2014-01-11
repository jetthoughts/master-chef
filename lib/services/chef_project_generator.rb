class ChefProjectGenerator

  BASE_FOLDER = Rails.root.join('projects')

  attr_accessor :name

  def initialize(name: 'chef')
    @name = name
  end

  def process!
    FileUtils.mkdir_p BASE_FOLDER.join(name)
  end

end
