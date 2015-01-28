require 'securerandom'
require 'erb'

namespace :secret do
  desc 'Generate config/secret.yml'
  task :generate do
    secret_key_dev = SecureRandom.hex(64)
    secret_key_test = SecureRandom.hex(64)

    b = binding
    b.local_variable_set(:secret_key_base_dev, secret_key_dev)
    b.local_variable_set(:secret_key_base_test, secret_key_test)

    tpl_filename = File.join(Rails.root, 'config', 'secrets.yml.erb')
    out_filename = tpl_filename.gsub '.erb', ''

    content = File.read tpl_filename
    renderer = ERB.new content
    output = renderer.result(b)

    f = File.new out_filename, 'wb'
    f.write output
    f.close
  end
end
