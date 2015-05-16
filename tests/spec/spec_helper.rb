require 'serverspec'
require 'net/ssh'
require 'tempfile'

host = ENV['TARGET_HOST']

if host == '.local'
  set :backend, :exec
else
  set :backend, :ssh

  if ENV['ASK_SUDO_PASSWORD']
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
  else
    set :sudo_password, ENV['SUDO_PASSWORD']
  end

  `vagrant up #{host}`

  config = Tempfile.new('', Dir.tmpdir)
  config.write(`vagrant ssh-config #{host}`)
  config.close

  options = Net::SSH::Config.for(host, [config.path])

  options[:user] ||= Etc.getlogin

  set :host,        options[:host_name] || host
  set :ssh_options, options

  # Disable sudo
  # set :disable_sudo, true
end
