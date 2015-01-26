#
# Cookbook Name:: vagrant-ohai
# Recipe:: default
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PLUGIN_PATH = node['vagrant-ohai']['plugin_path']
FILE_MODIFIER = Ohai::VERSION.split('.')[0].to_i >= 7 ? '-ohai7' : ''

Ohai::Config[:plugin_path] << PLUGIN_PATH
Chef::Log.info("vagrant ohai plugins will be at: #{PLUGIN_PATH}")

# run_action() needed on this resource due to the run_action() we use on
# the cookbook_file resource below
directory PLUGIN_PATH do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end.run_action(:create)

cookbook_file File.join(PLUGIN_PATH, 'README.md') do
  source 'README.md'
  owner 'root'
  group 'root'
  mode 0755
end

cf = cookbook_file File.join(PLUGIN_PATH, 'vagrant-net.rb') do
  source "vagrant-net#{FILE_MODIFIER}.rb"
  owner 'root'
  group 'root'
  mode 0755
end

cf.run_action(:create)

# only reload ohai if new plugins were dropped off OR
# node['vagrant-ohai']['plugin_path'] does not exists in client.rb
if cf.updated? ||
   !(::IO.read(Chef::Config[:config_file]) =~ /Ohai::Config\[:plugin_path\]\s*<<\s*["']#{PLUGIN_PATH}["']/)

  ohai 'custom_plugins' do
    action :nothing
  end.run_action(:reload)

end
