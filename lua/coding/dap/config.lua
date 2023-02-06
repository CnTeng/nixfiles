return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = "mfussenegger/nvim-dap",
  keys = {
    { "<f5>", function() require("dap").continue() end, desc = "Debugger: Start" },
    { "<f17>", function() require("dap").terminate() end, desc = "Debugger: Stop" }, -- Shift+F5
    { "<f29>", function() require("dap").restart_frame() end, desc = "Debugger: Restart" }, -- Control+F5
    { "<f6>", function() require("dap").pause() end, desc = "Debugger: Pause" },
    { "<f9>", function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" },
    { "<f10>", function() require("dap").step_over() end, desc = "Debugger: Step Over" },
    { "<f11>", function() require("dap").step_into() end, desc = "Debugger: Step Into" },
    { "<f12>", function() require("dap").step_out() end, desc = "Debugger: Step Out" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
    { "<leader>dB", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Start/Continue (F5)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (F11)" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over (F10)" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out (F12)" },
    { "<leader>dq", function() require("dap").close() end, desc = "Close Session" },
    { "<leader>dQ", function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause (F6)" },
    { "<leader>dr", function() require("dap").restart_frame() end, desc = "Restart (C-F5)" },
    { "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
    { "<leader>dh", function() require("dapui").eval() end, desc = "Debugger Hover" },
  },
  opts = {
    signs = {
      { name = "DapBreakpoint", text = "" },
      { name = "DapBreakpointCondition", text = "" },
      { name = "DapLogPoint", text = ".>" },
      { name = "DapStopped", text = "" },
      { name = "DapBreakpointRejected", text = "" },
    },
    floating = {
      border = "none",
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "left",
        size = 0.25,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 0.25,
      },
    },
  },
  config = function(_, opts)
    require("core.utils.dap").setup_dap_signs(opts.signs)

    local dap, dapui = require "dap", require "dapui"

    dapui.setup {
      floating = opts.floating,
      layouts = opts.layouts,
    }

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- TODO:finsh config cpp dap
    -- require "coding.dap.servers.cpp"
    require "coding.dap.servers.python"
  end,
}
