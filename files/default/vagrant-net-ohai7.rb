#
# Cookbook Name:: vagrant-ohai
# Attribute:: default
#
# Copyright 2014, PagerDuty, Inc.
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

Ohai.plugin(:VagrantNet) do
  provides 'ipaddress'
  depends 'ipaddress', 'network/interfaces'
  depends 'virtualization/system', 'etc/passwd'

  collect_data(:default) do
    if virtualization['system'] == 'vbox'
      if etc['passwd'].any? { |k, v| k == 'vagrant' }
        if network['interfaces']['eth1']
          network['interfaces']['eth1']['addresses'].each do |ip, params|
            ipaddress(ip) if params['family'] == ('inet')
          end
        end
      end
    end
  end
end
