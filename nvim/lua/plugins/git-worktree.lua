return {
	"polarmutex/git-worktree.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.g.git_worktree = {
			change_directory_command = "cd",
			update_on_change_command = "e .",
			clearjumps_on_change = true,
			autopush = false,
		}

		local Hooks = require("git-worktree.hooks")
		Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
	end,
	keys = function()
		-- Custom helper functions for worktree management using vim.ui.select/input
		local function run_cmd(cmd)
			local result = vim.fn.systemlist(cmd)
			if vim.v.shell_error ~= 0 then
				return nil
			end
			return result
		end

		local function get_worktrees()
			local lines = run_cmd("git worktree list")
			if not lines then
				return {}
			end
			local worktrees = {}
			for _, line in ipairs(lines) do
				-- Output formats:
				-- /path/to/worktree commit [branch]
				-- or /path/to/worktree commit (detached HEAD)
				local path = line:match("^(%S+)")
				local branch = line:match("%[(%S+)%]$")
				if path then
					local display_name = vim.fn.fnamemodify(path, ":t")
					if display_name == "" or display_name == "." then
						display_name = path
					end
					table.insert(worktrees, {
						path = path,
						branch = branch,
						display = string.format("%s %s", display_name, branch and ("[" .. branch .. "]") or ""),
					})
				end
			end
			return worktrees
		end

		local function switch_worktree()
			local worktrees = get_worktrees()
			if #worktrees == 0 then
				vim.notify("No worktrees found", vim.log.levels.WARN, { title = "Git Worktree" })
				return
			end

			local displays = {}
			local lookup = {}
			for _, wt in ipairs(worktrees) do
				table.insert(displays, wt.display)
				lookup[wt.display] = wt
			end

			vim.ui.select(displays, {
				prompt = "Switch to Git Worktree:",
			}, function(choice)
				if not choice then return end
				local wt = lookup[choice]
				vim.notify("Switching to worktree: " .. choice, vim.log.levels.INFO, { title = "Git Worktree" })
				require("git-worktree").switch_worktree(wt.path)
			end)
		end

		local function create_worktree()
			vim.ui.input({ prompt = "New worktree path (relative/absolute): " }, function(path)
				if not path or path == "" then return end
				vim.ui.input({ prompt = "Branch name (new or existing): " }, function(branch)
					if not branch or branch == "" then return end
					vim.ui.input({ prompt = "Upstream remote (optional, e.g. origin): " }, function(upstream)
						if upstream == "" then upstream = nil end
						vim.notify(string.format("Creating worktree '%s' on branch '%s'...", path, branch), vim.log.levels.INFO, { title = "Git Worktree" })
						require("git-worktree").create_worktree(path, branch, upstream)
					end)
				end)
			end)
		end

		local function delete_worktree()
			local worktrees = get_worktrees()
			if #worktrees == 0 then
				vim.notify("No worktrees found", vim.log.levels.WARN, { title = "Git Worktree" })
				return
			end

			local displays = {}
			local lookup = {}
			for _, wt in ipairs(worktrees) do
				table.insert(displays, wt.display)
				lookup[wt.display] = wt
			end

			vim.ui.select(displays, {
				prompt = "Delete Git Worktree:",
			}, function(choice)
				if not choice then return end
				local wt = lookup[choice]
				vim.ui.select({ "No", "Yes" }, {
					prompt = string.format("Are you sure you want to delete worktree '%s'?", choice),
				}, function(confirm)
					if confirm == "Yes" then
						vim.notify("Deleting worktree: " .. choice, vim.log.levels.INFO, { title = "Git Worktree" })
						require("git-worktree").delete_worktree(wt.path)
					end
				end)
			end)
		end

		return {
			{ "<leader>gws", switch_worktree, desc = "Switch Git Worktree" },
			{ "<leader>gwc", create_worktree, desc = "Create Git Worktree" },
			{ "<leader>gwd", delete_worktree, desc = "Delete Git Worktree" },
		}
	end,
}
