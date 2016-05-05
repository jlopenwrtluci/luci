package.path = package.path .. ";/usr/lib/lua/luci/sys/jl_helper.lua"
jh = require("jl_helper")

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
--mac.value = jh.get_addr_info()['eth0']
--mac:depends("mode", "gate")

mac = s:option(DummyValue, "mac", "MAC地址")
mac.value = jh.get_addr_info()['eth0']
mac:depends("mode", "gate")

gate_ip = s:option(Value, "gate_ip", "IP地址:")
gate_ip:depends("mode", "gate")

gate_mask = s:option(Value, "gate_mask", "子网掩码:")
gate_mask:depends("mode", "gate")

----------------------------------------------------

wan_type = s:option(ListValue, "wan_type", "WAN口连接类型")
wan_type:depends("mode", "gate")
wan_type:value("pppoe", "PPPoE")
wan_type:value("static", "静态IP")
wan_type:value("dynamic", "动态IP")

gate_pppoe_account = s:option(Value, "pppoe_account", "上网帐号:")
gate_pppoe_account:depends("wan_type", "pppoe")

gate_pppoe_passwd = s:option(Value, "pppoe_passwd", "上网密码")
gate_pppoe_passwd:depends("wan_type", "pppoe")

gate_pppoe_retry_passwd = s:option(Value, "pppoe_retry_passwd", "确认密码")
gate_pppoe_retry_passwd:depends("wan_type", "pppoe")

----------------------------------------------------

gate_static_wan_ip = s:option(Value, "wan_static_ip", "IP地址")
gate_static_wan_ip:depends("wan_type", "static")

gate_static_wan_mask = s:option(Value, "wan_static_mask", "子网掩码")
gate_static_wan_mask:depends("wan_type", "static")

gate_static_wan_gateway = s:option(Value, "wan_static_gateway", "网关")
gate_static_wan_gateway:depends("wan_type", "static")

gate_dns = s:option(Value, "gate_dns", "DNS服务器")
gate_dns:depends("mode", "gate")

----------------------------------------------------

bridge_eth_1_2_ip = s:option(Value, "bridge_eth_1_2_ip", "IP地址")
bridge_eth_1_2_ip:depends("mode", "bridge")

bridge_eth_1_2_mask = s:option(Value, "bridge_eth_1_2_mask", "子网掩码")
bridge_eth_1_2_mask:depends("mode", "bridge")

bridge_eth_1_2_gateway = s:option(Value, "bridge_eth_1_2_gateway", "网关")
bridge_eth_1_2_gateway:depends("mode", "bridge")

bridge_dns = s:option(Value, "bridge_dns", 'DNS服务器')
bridge_dns:depends("mode", "bridge")

----------------------------------------------------

-- span

----------------------------------------------------

-- wifi
wifi_section = m:section(TypedSection, "guide_wifi", "无线网络基本设置")
wifi_section.addremove = false
wifi_section.anonymous = true

wifi_ssid = wifi_section:option(Value, "wifi_ssid", "SSID")
wifi_passwd = wifi_section:option(Value, "wifi_passwd", "密码")
wifi_channel = wifi_section:option(Value, "wifi_channel", "频段带宽")

----------------------------------------------------
--o = s:option(Flag, "sync_flood", "gsfsd")
--s.addremove = false
--o.default = o.enabled
--f_proto = m:field(ListValue, "lan", translate("lan"))
--f_proto.default = translate('wan')
--m:field(ListValue, "wan", translate("wan")).default = "wan"
--m:field(ListValue, "wan", translate("wan")).default = "wan"
--f_proto = m:field(ListValue, "lan", translate("lan"))

--[[
s = m:section(NamedSection, "guide", "guide", "guide")
--s.addremove = true
s:option(DummyValue, "mac", translate("mac")).value = jh.get_addr_info()['eth0']
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

function m.on_commit(map)
	local v1 = pass1.formvalue("_pass")
	local v2 = pass2.formvalue("_pass")

	if v1 and v2 then
		if v1 == v2 then
			if action_ppoe_pass(v1) then
				m.message = "success!"
			else
				m.message = "err!!!!"
			end
		else
			m.message = "password not same"
		end
	end
end
			
		
--]]
return m
