require 'sidekiq'
require_relative 'import_from_csv'

class Worker
  include Sidekiq::Worker

  def perform(csv_content)
    import = ImportFromCsv.new(csv_content)
    import.call
  end
end