# borrowed from https://gist.github.com/2050259

Ohai.plugin(:VagrantNet) do
  provides 'ipaddress'
  depends "#{os}::network"
  depends "#{os}::virtualization"
  depends 'passwd'

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
