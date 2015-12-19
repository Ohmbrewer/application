require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.options = ['--title', 'Ohmbrewer Documentation',
               '--main', 'README.md']
end
