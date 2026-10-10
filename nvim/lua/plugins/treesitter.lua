return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		local parsers = {
			"lua",
			"python",
			"javascript", "typescript", "tsx",
			"bash", "zsh",
			"json", "yaml",
		}
		require('nvim-treesitter').install(parsers):wait(300000)

		local filetypes = {}
		for _, lang in ipairs(parsers) do
			vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
		end

		vim.api.nvim_create_autocmd('FileType', {
			pattern = filetypes,
			callback = function()
				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"	
			end,
		})
	end
}
