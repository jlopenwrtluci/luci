local uci = require("luci.model.uci")
require "string"

local _uci

local GUIDE_FILE = 'guide'
local NETWORK_FILE = 'network'


function debug(buf)
	--print(buf)
end
	
function init()
	_uci = uci.cursor()	
end

function copy_to(l_file, l_sec, l_opt, r_file, r_sec, r_opt)
	debug(string.format("%s:%s:%s -> %s:%s:%s", l_file, l_sec, l_opt, r_file, r_sec, r_opt))

	if not (l_file and l_sec and l_opt and r_file and r_sec and r_opt) then
		debug('\tnil arg')
		return
	end
	
	local tmp = _uci:get(l_file, l_sec, l_opt)
	if not tmp then
		debug('\tnil val')
		return
	end

	_uci:set(r_file, r_sec, r_opt, tmp)
	debug(string.format("\tchange value [%s] sucess!",tmp))
end

function set_guide_config_gate_lan()
	-- gate mode, lan config

	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'lan'

	l_opt = 'gate_lan_ip'
	r_opt = 'ipaddr'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'gate_lan_mask'
	r_opt = 'netmask'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_guide_config_gate_wan_pppoe()
	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'wan'

	l_opt = 'wan_type'
	r_opt = 'proto'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'pppoe_account'
	r_opt = 'username'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'pppoe_passwd'
	r_opt = 'password'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_guide_config_gate_wan_static()
	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'wan'

	l_opt = 'wan_type'
	r_opt = 'proto'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
	
	l_opt = 'wan_static_ip'
	r_opt = 'ipaddr'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'wan_static_mask'
	r_opt = 'netmask'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'wan_static_gateway'
	r_opt = 'gateway'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	l_opt = 'dns'
	r_opt = 'dns'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_guide_config_gate_wan_dynamic()
	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'wan'

	l_opt = 'wan_type'
	r_opt = 'proto'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_guide_config_gate_wan()
	-- gate mode, wan config

	local type = _uci:get(GUIDE_FILE, 'guide', 'wan_type')

	if type == 'pppoe' then
		set_guide_config_gate_wan_pppoe()
	end

	if type == 'static' then
		set_guide_config_gate_wan_static()
	end

	if type == 'dynamic' then
		set_guide_config_gate_wan_dynamic()
	end
end

function set_guide_config_gate()
	-- gate mode
	set_guide_config_gate_lan()
	set_guide_config_gate_wan()
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

	l_opt = 'dns'
	r_opt = 'dns'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)
end

function set_guide_config_span()
	local l_set, r_set, l_opt, r_opt
	l_sec = 'guide'
	r_sec = 'lan'

	l_opt = 'dns'
	r_opt = 'dns'
	copy_to(GUIDE_FILE, l_sec, l_opt, NETWORK_FILE, r_sec, r_opt)

	-- same with gate mode
	set_guide_config_gate_wan()
end

function set_guide_config_wifi()
end

function set_config_guide()
	local mode = _uci:get(GUIDE_FILE, 'guide', 'mode')

	if mode == 'bridge' then
		set_guide_config_bridge()
	end

	if mode == 'gate' then
		set_guide_config_gate()
	end

	if mode == 'span' then
		set_guide_config_span()
	end

	set_guide_config_wifi()
end

function enable_one_save(file)
	debug(string.format('[!]save %s', file))
	_uci:save(file)
end

function enable_one_apply(file)
	debug(string.format('[!]load %s', file))
	_uci:load(file)
	_uci:apply(file)
end

function enable_one_commit(file)
	debug(string.format('[!]commit %s', file))
	_uci:commit(file)
end

function enable_one(file)
	enable_one_save(file)
	enable_one_commit(file)
	-- TODO: close for debug
	-- enable_one_apply(file)
end
	
function enable()
	enable_one(NETWORK_FILE)
end

function main()
	init()

	set_config_guide()

	enable()
end

main()
