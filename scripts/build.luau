local fs = require("@lune/fs")
local process = require("@lune/process")

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

local function minifyTree(inputRoot, outputRoot)
	ensureDir(outputRoot)

	local function walk(relativePath)
		local currentInput = relativePath == "" and inputRoot or joinPath(inputRoot, relativePath)
		for _, name in ipairs(fs.readDir(currentInput)) do
			local nextRelative = relativePath == "" and name or joinPath(relativePath, name)
			local inputPath = joinPath(inputRoot, nextRelative)
			local outputPath = joinPath(outputRoot, nextRelative)

			if fs.isDir(inputPath) then
				ensureDir(outputPath)
				walk(nextRelative)
			elseif inputPath:sub(-5) == ".luau" then
				local result = process.exec("darklua", { "minify", inputPath, outputPath })
				if not result.ok or result.code ~= 0 then
					error(("darklua failed for %s\n%s"):format(inputPath, result.stderr or ""))
				end
			end
		end
	end

	walk("")
end

local root = type(process.cwd) == "function" and process.cwd() or process.cwd
local outputRoot = joinPath(root, "Distribution")

minifyTree(joinPath(root, "src"), joinPath(outputRoot, "src"))
minifyTree(joinPath(root, "scripts"), joinPath(outputRoot, "scripts"))

print("darklua minify complete -> " .. outputRoot)
