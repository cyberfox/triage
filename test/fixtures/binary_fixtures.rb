require 'erb'
require 'ostruct'
require 'yaml'

def fixture_data(name)
  render_binary("#{RAILS_ROOT}/test/fixtures/yaml/#{name}.yml")
end

def render_binary(filename)
  original = File.open(filename,'rb').read
  data = eval(ERB.new(original).src)
  "!binary | #{[data].pack('m').gsub(/\n/,"\n    ")}\n"
end
