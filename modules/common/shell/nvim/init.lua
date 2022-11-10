local impatient_ok, impatient = pcall(require, "impatient")

if impatient_ok then
	impatient.enable_profile()
else
	vim.notify("impatient not found!", "error")
end

local config = {
	"core.options",
	"core.keymaps",
	"core.plugins",
	"core.colorscheme",
	"core.autocommands",
}

for _, source in ipairs(config) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end
