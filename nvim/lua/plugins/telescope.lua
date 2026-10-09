return {
	'nvim-telescope/telescope.nvim', version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- optional but recommended
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	keys = {
		{ '<leader>pf', function() require('telescope.builtin').find_files() end, desc = 'Telescope find files' },
		{ '<C-p>', function()
			local builtin = require('telescope.builtin')
			if not pcall(builtin.git_files) then builtin.find_files() end
		end, desc = 'Telescope git files (all files outside git)' },
		{ '<leader>ps', function()
			local ok, search = pcall(vim.fn.input, "Grep > ")
			if ok and search ~= "" then require('telescope.builtin').grep_string({ search = search }) end
		end, desc = 'Telescope search text' },
	},
	config = function()
		require('telescope').setup({})
		require('telescope').load_extension('fzf')
	end,
}
