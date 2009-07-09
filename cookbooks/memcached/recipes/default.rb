require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first
  db_name = "#{app_name}_#{node[:environment][:framework_env]}"

case node[:instance_roll]
when "app"
  template "/data/#{app_name}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    owner user[:username]
    group user[:username]
    mode 0744
    variables({
        :app_name => app_name,
        :servers => node[:members]
    })
  end

  template "/etc/conf.d/memcached" do
    owner 'root'
    group 'root'
    mode 0644
    source "memcached.erb"
    variables :memusage => node[:memcached_size] || 512,
              :port     => node[:port] || 11211
  end
end
end
