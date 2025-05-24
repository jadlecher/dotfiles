return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = function(_, filetypes)
		-- Render markdown in codecompanion buffers
		return vim.list_extend(filetypes, { "codecompanion" })
	end,
}
