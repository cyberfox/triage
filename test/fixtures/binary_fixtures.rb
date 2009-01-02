def fixture_data(name)
  render_binary("#{RAILS_ROOT}/test/fixtures/yaml/#{name}.yml")
end

def render_binary(filename)
  data = File.open(filename,'rb').read
  "!binary | #{[data].pack('m').gsub(/\n/,"\n    ")}\n"
end
