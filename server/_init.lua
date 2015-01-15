self = {}
self.requests = {}

Timeout = 2.1

socket = require("socket")

function DispatchRequests()
	local connections = {}

	for k, thread in ipairs(self.requests) do
		local success, result = coroutine.resume(thread)

		if success and result then
			table.insert(connections, result)
		else
			table.remove(self.requests, k)
		end
	end
end

function MakeRequest(host, uri, port, callback)
	local uri = uri or "/"
	local port = port or 80
	local callback = callback

	table.insert(self.requests, coroutine.create(function()
		local status, err = pcall(function()
			local data = false
			local connection = socket.tcp()

			connection:settimeout(2.1)

			local status, err = connection:connect(host, port)

			if status then
				connection:settimeout(0)
				connection:send("GET http://" .. host .. uri .. " HTTP/1.0\r\n\r\n")

				while true do
					local timer = Timer()
					local buffer, status, overflow = connection:receive(1024)

					data = (data or "") .. (buffer or overflow)

					if status == "closed" then
						break
					end

					coroutine.yield(connection)
				end

				connection:close()
			else
				print("Connection failed: " .. err)
			end

			pcall(callback, data and data:sub(data:find("\r\n\r\n") + 4, #data)) -- We don't really care if this succeeds, we just want to avoid an error
		end)

		if not status then
			print(err)
		end
	end))
end

Events:Subscribe("PostTick", DispatchRequests)

Events:Subscribe("ModuleLoad", function()
    Timeout = GlobalSettings.Timeout
end)