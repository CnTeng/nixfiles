local status_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not status_ok then
	vim.notify("mason_tool_installer not found!", "error")
	return
end

mason_tool_installer.setup {
	ensure_installed = {
		-- Linter
		"flake8",

		-- Formatter
		--[[ "prettier", ]]
		"stylua",
		"clang-format",
		"golines",
		"black",
	},
	auto_update = true,
	run_on_start = true,
	start_delay = 3000, -- 3 second delay
}
