local fs = require("@lune/fs") :: any
local process = require("@lune/process") :: any

local osName = type(process.os) == "function" and process.os() or process.os
local separator = osName == "windows" and "\\" or "/"

local function joinPath(...)
	local parts = { ... }
	return table.concat(parts, separator)
end

local function ensureDir(path)
	if fs.isDir(path) then
		return
	end
	fs.writeDir(path)
end

local root = type(process.cwd) == "function" and process.cwd() or process.cwd
local outputRoot = joinPath(root, "build")

ensureDir(outputRoot)

do
	local bundleConfig = joinPath(root, "tools", "configs", "darklua.bundle.json5")
	local bundleOutput = joinPath(outputRoot, "loader.luau")
	local result = process.exec("darklua", {
		"process",
		"--format",
		"dense",
		"-c",
		bundleConfig,
		joinPath(root, "src", "core", "Init.luau"),
		bundleOutput,
	})
	if not result.ok or result.code ~= 0 then
		error(("darklua bundle failed\n%s"):format(result.stderr or ""))
	end
end

print("darklua bundle complete -> " .. outputRoot)
