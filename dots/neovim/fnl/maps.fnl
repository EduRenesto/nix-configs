(module maps
  {autoload {nvim aniseed.nvim}})

(defn map-key [key cmd]
  (nvim.set_keymap :n key cmd {:noremap true}))

(map-key "<leader>," ":Telescope buffers<CR>")
(map-key "<leader>." ":Telescope find_files<CR>")
(map-key "<leader>ws" ":vsplit<CR>")
(map-key "<leader>wv" ":split<CR>")
(map-key ";" ":")
