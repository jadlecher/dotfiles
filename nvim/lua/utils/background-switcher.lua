local M = {}

local function read_xsettings()
	local xsettings_file = os.getenv("HOME")..'/.config/xsettingsd/xsettingsd.conf'
	local xsettings = nil
	if vim.fn.filereadable(xsettings_file) > 0 then
		xsettings = vim.fn.readfile(xsettings_file)
	end
	return xsettings
end

local function find(key, values)
	for _, value in pairs(values) do
		if value:find(key) then
			return value
		end
	end
	return nil
end

local function extract_quoted_value(text)
	local first = text:find('"')
	local last = #text - text:reverse():find('"') + 1
	if first and last and last - first >= 2 then
		return text:sub(first + 1, last - 1)
	else
		return nil
	end
end

local function get_gtk_theme()
	local value = nil
	local xsettings = read_xsettings()
	if xsettings then
		key = "Net/ThemeName"
		local match = find(key, xsettings)
		if match then
			value = extract_quoted_value(match)
		end
	end
	return value
end

local function background_value()
	local catppuccin = require("catppuccin")
	local light_value = catppuccin.options.background["light"]
	local dark_value = catppuccin.options.background["dark"]
	local gtk_theme = get_gtk_theme():lower()
	if gtk_theme:find(light_value) then
		return "light"
	elseif gtk_theme:find(dark_value) then
		return "dark"
	else
		return nil
	end
end

function M.switch()
	vim.opt.background = background_value()
end

return M
