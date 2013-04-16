# borrowed from https://gist.github.com/2050259

provide "ipaddress"
require_plugin "#{os}::network"
require_plugin "#{os}::virtualization"
require_plugin "passwd"

if virtualization["system"] == "vbox"
  if etc["passwd"].any? { |k,v| k == "vagrant"}
    if network["interfaces"]["eth1"]
      network["interfaces"]["eth1"]["addresses"].each do |ip, params|
        if params['family'] == ('inet')
          ipaddress ip
        end
      end
    end
  end
end
