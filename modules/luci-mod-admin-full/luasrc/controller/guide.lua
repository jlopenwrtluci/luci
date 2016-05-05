-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.guide", package.seeall)
--module("guide", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/guide") then
		return
	end
	
	local page

	page = node("admin", "guide")
	page.target = cbi("guide/guide")
	page.title = "安装向导"
	page.order = 10
	page.index = true
end
