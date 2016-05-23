package.path = package.path .. ";/usr/lib/lua/luci/sys/jl_helper.lua"
jh = require("jl_helper")
require "string"

-----------------------------------------------------

local line = ">>>>>>>>>>>>>>>>>>>>>>>>>"
--local line = "=============================="

-----------------------------------------------------

m = Map("guide", "网络设置向导")

-----------------------------------------------------

s = m:section(TypedSection, "guide", "网络设置")
s.addremove = false
s.anonymous = true

-----------------------------------------------------
mode = s:option(ListValue, "mode", "工作模式")
mode:value("gate", "网关模式")
mode:value("bridge", "网桥模式")
mode:value("span", "旁听模式")

--part1 = s:option(DummyValue, "内网IP", "")
--mac.value = jh.get_addr_info()["eth0"]
--mac:depends("mode", "gate")

gate_lan_title = s:option(DummyValue, "1", "内网IP(LAN设置)")
gate_lan_title.value = line
gate_lan_title:depends("mode", "gate")

mac = s:option(DummyValue, "mac", "MAC地址")
mac.value = string.upper(jh.get_addr_info()["eth0"])
mac:depends("mode", "gate")


gate_lan_ip = s:option(Value, "gate_lan_ip", "IP地址:")
gate_lan_ip.datatype = "ip4addr"
gate_lan_ip:depends("mode", "gate")

gate_lan_mask = s:option(Value, "gate_lan_mask", "子网掩码:")
gate_lan_mask:depends("mode", "gate")
gate_lan_mask.datatype = "ip4addr"

----------------------------------------------------

dns_title = s:option(DummyValue, "888", "DNS属性")
dns_title.value = line

gate_dns = s:option(Value, "dns", "DNS服务器")
gate_dns.datatype = "ip4addr"

----------------------------------------------------

gate_wan_title = s:option(DummyValue, "2", "外网类型(WAN口设置)")
gate_wan_title.value = line
gate_wan_title:depends("mode", "gate")
gate_wan_title:depends("mode", "span")

wan_type = s:option(ListValue, "wan_type", "WAN口连接类型")
wan_type:depends("mode", "gate")
wan_type:depends("mode", "span")
wan_type:value("pppoe", "PPPoE")
wan_type:value("static", "静态IP")
wan_type:value("dhcp", "动态IP")

gate_pppoe_account = s:option(Value, "pppoe_account", "上网帐号:")
gate_pppoe_account:depends("wan_type", "pppoe")

gate_pppoe_passwd = s:option(Value, "pppoe_passwd", "上网密码")
gate_pppoe_passwd:depends("wan_type", "pppoe")

--gate_pppoe_retry_passwd = s:option(Value, "pppoe_retry_passwd", "确认密码")
--gate_pppoe_retry_passwd:depends("wan_type", "pppoe")

----------------------------------------------------

gate_static_wan_ip = s:option(Value, "wan_static_ip", "IP地址")
gate_static_wan_ip:depends("wan_type", "static")
gate_static_wan_ip.datatype = "ip4addr"

gate_static_wan_mask = s:option(Value, "wan_static_mask", "子网掩码")
gate_static_wan_mask:depends("wan_type", "static")
gate_static_wan_mask.datatype = "ip4addr"

gate_static_wan_gateway = s:option(Value, "wan_static_gateway", "网关")
gate_static_wan_gateway:depends("wan_type", "static")
gate_static_wan_gateway.datatype = "ip4addr"

--[[
gate_dns = s:option(Value, "gate_dns", "DNS服务器")
gate_dns:depends("wan_type", "static")
--]]

----------------------------------------------------


----------------------------------------------------

bridge_title = s:option(DummyValue, "44", "网桥(eth1, eth2)")
bridge_title:depends("mode", "bridge")
bridge_title.value = line

bridge_eth_1_2_ip = s:option(Value, "bridge_eth_1_2_ip", "IP地址")
bridge_eth_1_2_ip:depends("mode", "bridge")
bridge_eth_1_2_ip.datatype = "ip4addr"

bridge_eth_1_2_mask = s:option(Value, "bridge_eth_1_2_mask", "子网掩码")
bridge_eth_1_2_mask:depends("mode", "bridge")
bridge_eth_1_2_mask.datatype = "ip4addr"

bridge_eth_1_2_gateway = s:option(Value, "bridge_eth_1_2_gateway", "网关")
bridge_eth_1_2_gateway:depends("mode", "bridge")
bridge_eth_1_2_gateway.datatype = "ip4addr"

--[[
bridge_dns = s:option(Value, "bridge_dns", "DNS服务器")
bridge_dns:depends("mode", "bridge")
--]]

----------------------------------------------------

-- span
--[[
span_dns_title = s:option(DummyValue, "11", "DNS属性")
span_dns_title.value = line
span_dns_title:depends("mode", "span")

span_dns = s:option(Value, "span_dns", "DNS服务器")
span_dns:depends("mode", "span")
--]]

----------------------------------------------------

-- wifi
wifi_section = m:section(TypedSection, "guide_wifi", "无线网络基本设置")
wifi_section.addremove = false
wifi_section.anonymous = true

wifi_ssid = wifi_section:option(Value, "wifi_ssid", "SSID")
wifi_passwd = wifi_section:option(Value, "wifi_passwd", "密码")
wifi_channel = wifi_section:option(Value, "wifi_channel", "频段带宽")
wifi_mhz = wifi_section:option(Value, "wifi_channel", "频段带宽")

----------------------------------------------------
--o = s:option(Flag, "sync_flood", "gsfsd")
--s.addremove = false
--o.default = o.enabled
--f_proto = m:field(ListValue, "lan", translate("lan"))
--f_proto.default = translate("wan")
--m:field(ListValue, "wan", translate("wan")).default = "wan"
--m:field(ListValue, "wan", translate("wan")).default = "wan"
--f_proto = m:field(ListValue, "lan", translate("lan"))

--[[
s = m:section(NamedSection, "guide", "guide", "guide")
--s.addremove = true
s:option(DummyValue, "mac", translate("mac")).value = jh.get_addr_info()["eth0"]
s:option(Value, "addr", translate("IPv4 address"))
key=s:option(Value, "netmask", translate(""))

--m = Map("guide", "外网类型(WAN口设置)")
s1 = m:section(TypedSection, "wan")
s1:option(Value, "type", "type:")
account=s1:option(Value, "account", "account:")
pass1=s1:option(Value, "passwd", "passwd:")
pass2=s1:option(Value, "passwd", "confirm passwd:")

function s.cfgsections()
	return { "_pass" }
end

function action_ppoe_pass(pass)
	return true
end
--]]

function enable_action()
	os = require "os"

	-- copy /etc/config/guide to /etc/config/network
	os.execute("lua /usr/lib/lua/luci/sys/guide_config_dispatcher.lua")

	-- restart web ui
	os.execute("reboot")
end

function m.on_commit(map)
	enable_action()
end
		
function m.on_apply(map)
	enable_action()
end

return m
