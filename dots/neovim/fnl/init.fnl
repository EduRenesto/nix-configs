(module init 
  {autoload {core aniseed.core
             nvim aniseed.nvim}})

(set nvim.g.mapleader " ")
 
(let 
  [options {
            :sw 2
            :ts 2
            :expandtab true
            :relativenumber true
            }]
  (each [option value (pairs options)]
    (core.assoc nvim.o option value)))

(require :plugins)
