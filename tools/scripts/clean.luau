local fs = require("@lune/fs") :: any
local process = require("@lune/process") :: any

local osName = type(process.os) == "function" and process.os() or process.os
local separator = osName == "windows" and "\\" or "/"

local function joinPath(...)
	local parts = { ... }
	return table.concat(parts, separator)
end

local root = type(process.cwd) == "function" and process.cwd() or process.cwd
local buildDir = joinPath(root, "build")

if fs.isDir(buildDir) then
	fs.removeDir(buildDir)
end

print("clean complete -> " .. buildDir)
