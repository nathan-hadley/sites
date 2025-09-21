# This initializer disables ActiveRecord in the application
# since we're running a database-free Rails application

# Skip connecting to the database during initialization
Rails.application.config.after_initialize do
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection = proc {}
    ActiveRecord::Base.connection = proc {}
    ActiveRecord::Base.configurations = {}
  end
end

# Patch ActiveRecord::Railtie to skip database initialization
ActiveRecord::Railtie.class_eval do
  def self.check_attr_method_and_respond_to
    true
  end

  def self.create_database; end

  def self.load_console; end

  def self.establish_connection; end
end if defined?(ActiveRecord::Railtie) 