jl_helper = {}

local os = require "os"
local nxo = require "nixio"

function jl_helper.get_addr_info()
	local n, i
	local mac_info_dict = {}
	for n, i in ipairs(nxo.getifaddrs()) do
    local name = i.name:match("[^:]+")
		local addr = i.addr
		mac_info_dict[name] = addr
		--print(name .. addr)
	end
	return mac_info_dict
end
	
function test()
  addr_info = get_addr_info()
  mac = addr_info['eth0']

  print(mac)
  uci_set('guide', 'LAN', 'mac', mac)
end

function main()
  test()
end

--main()

return jl_helper
