vim.opt.clipboard:append("unnamedplus")
vim.opt.number = true -- Mostra números de linha
vim.opt.tabstop = 2 -- Um tab é igual a 2 espaços
vim.opt.shiftwidth = 2 -- Indentação também de 2 espaços
vim.opt.expandtab = true -- Converte tabs para espaços
vim.opt.smartindent = true -- Indentação inteligente
vim.opt.wrap = false -- Não quebra linhas
vim.opt.swapfile = false -- Desabilita arquivos de swap
vim.opt.backup = false -- Desabilita backup
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Define o diretório para armazenar históricos de undo
vim.opt.undofile = true -- Habilita undo persistente
vim.opt.incsearch = true -- Busca à medida que digita
vim.opt.termguicolors = true -- Habilita suporte a cores no terminal

vim.opt.cursorline = true -- Destaca a linha do cursor
vim.opt.showmode = false -- Não mostra o modo no qual você está, pois a barra de status pode fazer isso
vim.opt.signcolumn = "yes" -- Sempre mostra a coluna de sinalização, evita que o texto se mova
