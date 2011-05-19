require 'rake'

require 'thrust'

desc 'Start development server'
task :dev_server do
  Thrust::DevServer.new.run
end
