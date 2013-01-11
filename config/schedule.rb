# http://github.com/javan/whenever

every 1.day, :at => '6pm' do
  set :output, File.expand_path("#{File.dirname(__FILE__)}/../../../shared/sphinx_rebuilds.log")
  rake "ts:index -t"
end

every 1.hour do
  rake "nutribox:xero"
end

every 1.day, :at => '4am' do
  rake "nutribox:ship"
end