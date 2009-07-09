require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first
  db_name = "#{app_name}_#{node[:environment][:framework_env]}"
  
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
end
