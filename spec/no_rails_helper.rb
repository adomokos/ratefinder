require 'pry'
require 'active_model'

$LOAD_PATH << 'app/models'
$LOAD_PATH << 'app/models/entities'

Dir[File.join(__dir__, '../app/models/entities', '**/*.rb')].each do |file|
  require file
end
