require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first
  @mems = node[:members]
  db_name = "#{app_name}_#{node[:environment][:framework_env]}"

case node[:instance_roll]

when "app"
if node[:instance_roll].to_s != "db_master"
  template "/data/#{app_name}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    owner user[:username]
    group user[:username]
    mode 0744
    variables({
        :app_name => app_name,
    })
  end

  template "/etc/conf.d/memcached" do
    owner 'root'
    group 'root'
    mode 0644
    source "memcached.erb"
    variables :memusage => 512,
              :port     => 11211
  end
end
end
