-- install lazy.nvim if not present
local lazy_install_dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_install_dir) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_install_dir,
	})
end
vim.opt.rtp:prepend(lazy_install_dir) -- add lazy.nvim to rutime path
