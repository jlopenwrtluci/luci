jl_helper = {}

local os = require "os"
local nxo = require "nixio"
local uci = require("luci.model.uci")

local _uci

local GUIDE_FILE = 'guide'
local NETWORK_FILE = 'network'


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
	
function jl_helper.uci_set(file, sect, opt, val)
  os.execute("uci set " .. file .. "." .. sect .. "." .. opt .. "="  .. mac)
  os.execute("uci commit " .. file)
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

function init()
	_uci = uci.cursor()	
end

function set_guide_config_gate()
end

function copy_to(l_file, l_sec, l_opt, r_file, r_sec, r_opt)
	local tmp = _uci:get(l_file, l_sec, l_opt)
	_uic:set(r_file, r_sec, r_opt, tmp)
end

function set_guide_config_bridge()
	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'lan'

	l_opt = 'bridge_eth_1_2_ip'
	r_opt = 'ipaddr'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'bridge_eth_1_2_mask'
	r_opt = 'netmask'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'bridge_eth_1_2_gateway'
	r_opt = 'gateway'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_config_guide()
	set_guide_config_gate()
	set_guide_config_bridge()
	_uci:save(SECTION)
end


--main()

return jl_helper
