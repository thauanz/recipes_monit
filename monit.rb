namespace :monit do
  desc "Install Monit"
  task :install do
    run "#{sudo} yum -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitrc", "/etc/monit.d/monitrc"
    postfix
    nginx
    mysqld
    puma
    redis
    elasticsearch
    monit_reload
  end
  after "deploy:setup", "monit:setup"
  
  task(:nginx, roles: :web) { monit_config "nginx" }
  task(:mysqld, roles: :db) { monit_config "mysqld" }
  task(:puma, roles: :app) { monit_config "puma" }
  task(:redis, roles: :app) { monit_config "redis" }
  task(:elasticsearch, roles: :app) { monit_config "elasticsearch" }
  task(:postfix, roles: :app) { monit_config "postfix" }
  task(:start_all) { monit_start_all }

  %w[start stop restart status reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end

def put_sudo(data, to)
  filename = File.basename(to)
  to_directory = File.dirname(to)
  put data, "/tmp/#{filename}"
end

def template_sudo(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put_sudo ERB.new(erb).result(binding), to
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit.d/#{name}.conf"
  template_sudo "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv -u /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end

def monit_reload
  run "#{sudo} monit reload"
end

def monit_start_all
  run "#{sudo} monit start all"
end