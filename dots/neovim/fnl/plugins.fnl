(module plugins
  {autoload {nvim aniseed.nvim
             a aniseed.core
             packer packer
             lualine lualine
             lsp lspconfig
             coq coq
             }})

(defn- safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :config.plugin. name))]
    (when (not ok?)
      (print (.. "config error: " val-or-err)))))

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (a.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (-?> (. opts :mod) (safe-require-plugin-config))
            (use (a.assoc opts 1 name)))))))
  nil)

(use
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}
  :catppuccin/nvim {}
  :nvim-lualine/lualine.nvim {}
  :shaunsingh/nord.nvim {}

  :nvim-lua/plenary.nvim {}
  :nvim-telescope/telescope.nvim {}

  :neovim/nvim-lspconfig {}
  :ms-jpq/coq_nvim {:branch :coq}
  )

(lualine.setup {:options {
                         :theme "nord"
                         }})

(vim.cmd "colorscheme nord")

(lsp.hls.setup (coq.lsp_ensure_capabilities {}))
