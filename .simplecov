SimpleCov.start 'rails' do
  add_group 'Serializers', 'app/serializers'
  add_group 'Scheduler', 'lib/scheduler'
  add_group 'Rhizome Interfaces', 'lib/rhizome_interfaces'
  add_group 'Utilities', 'lib/util'
  add_filter 'vendor' # Don't include vendored stuff
end
