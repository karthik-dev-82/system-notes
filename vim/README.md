# Vim Configuration

A `.vimrc` built around [Vundle](https://github.com/VundleVim/Vundle.vim)
for plugin management, with a Solarized dark colorscheme, sane defaults,
and a handful of leader-key shortcuts.

## Install

```bash
./install_vundle.sh                 # clones Vundle itself (idempotent)
cp .vimrc ~/.vimrc                  # or symlink it, your call
vim +PluginInstall +qall            # installs every plugin below
```

`install_vundle.sh` only bootstraps Vundle; `:PluginInstall` (run from
inside vim) is what actually fetches the plugins listed in `.vimrc`.

**Clipboard note:** `.vimrc` sets `clipboard=unnamedplus` so yank/paste
use the real system clipboard on Linux. That requires vim built with
`+clipboard` support -- the `vim-tiny` package (Debian/Ubuntu's default
`vim` in some minimal installs) does **not** have it. Install `vim-gtk3`
(or any vim build advertising `+clipboard` in `vim --version`) if
copy/paste to other applications doesn't work.

## Plugins

| Plugin | Purpose | Status |
| --- | --- | --- |
| [VundleVim/Vundle.vim](https://github.com/VundleVim/Vundle.vim) | Plugin manager (manages itself) | Active |
| [tpope/vim-sensible](https://github.com/tpope/vim-sensible) | Sane defaults everyone agrees on | Active |
| [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration (`:Gstatus`, `:Gblame`, etc.) | Active |
| [nanotech/jellybeans.vim](https://github.com/nanotech/jellybeans.vim) | Colorscheme (installed, not active by default) | Stable |
| [altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) | Colorscheme (the active one, see `.vimrc`) | Stable |
| [Lokaltog/vim-powerline](https://github.com/Lokaltog/vim-powerline) | Statusline | ⚠️ Unmaintained -- see below |
| [scrooloose/syntastic](https://github.com/scrooloose/syntastic) | Syntax checking on save | ⚠️ Maintenance mode -- see below |
| [preservim/nerdtree](https://github.com/preservim/nerdtree) | File tree sidebar (`<leader>n`) | Active |
| [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) | Fuzzy file finder (`t`) | Active |

Two plugins were updated from the original config because their
original repos are effectively frozen and the community moved to a
fork under new maintainership (same plugin, current home):

* `kien/ctrlp.vim` → `ctrlpvim/ctrlp.vim`
* `scrooloose/nerdtree` → `preservim/nerdtree`

Two more are flagged in `.vimrc` but **left as-is** since replacing them
changes actual editing behavior and needs its own setup, so it's a
choice to make deliberately, not something to swap silently:

* **vim-powerline → consider `vim-airline/vim-airline`** if you want an
  actively maintained statusline. Needs a patched/Nerd Font to look
  right with icons.
* **syntastic → consider `dense-analysis/ale`** for async, non-blocking
  linting (syntastic checks synchronously on save, which can be slow).
  Needs whatever linters you use for each language actually installed
  (e.g. `clang-tidy` for C++, `pylint`/`ruff` for Python).

## Key Bindings

Leader key is `,`.

| Keys | Effect |
| --- | --- |
| `jj` (insert mode) | Escape to normal mode |
| `j` / `k` (also arrow keys) | Move by *visual* line, not file line (better on wrapped lines) |
| `<leader>fef` | Reformat (`gg=G`) the entire file |
| `<leader>n` | Toggle NERDTree |
| `t` | Open CtrlP fuzzy finder |
| `<leader>s<Left>`/`<Right>`/`<Up>`/`<Down>` | Open a new split in that direction |

## Notes on the Config

* `syntastic_cpp_compiler_options` targets C++11 with `libc++` -- update
  this if you're compiling against a newer standard.
* `clipboard=unnamedplus`, `expandtab`/`shiftwidth=2`/`tabstop=2`, and
  `ignorecase`/`smartcase` are opinionated personal defaults; adjust to
  taste.
