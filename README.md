# erdos-vim

A Lua-based Neovim configuration focused on project navigation, search, LSP support, and persistent project sessions.

## Requirements

- Neovim 0.10 or newer
- Git
- A terminal with true-color support
- `ripgrep` for Telescope live grep
- `lazygit` for the `gg` terminal shortcut
- `curl` for the optional Lombok download used by JDTLS
- Node.js for the JSON and YAML language servers installed by Mason
- A Java runtime, with `JAVA_HOME` set when it is not available at `/usr/lib/jvm/default-java`

The configuration expects the following Java tools when working on Java projects:

- Java 17 runtime
- Maven or Gradle, depending on the project

## Installation

Back up the existing Neovim configuration, then clone this repository into Neovim's configuration directory:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
git clone <repository-url> ~/.config/nvim
nvim
```

On the first launch, `lazy.nvim` is downloaded automatically and the configured plugins are installed. Mason installs `jdtls`, `jsonls`, and `yamlls` as configured in `lua/plugins/lsp.lua`.

To update plugins, use:

```vim
:Lazy sync
```

## Keymaps

The leader key is Space.

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle Neo-tree |
| `ff` | Find files with Telescope |
| `fg` | Search text with Telescope |
| `<leader>/` | Fuzzy-find text in the current buffer |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |
| `gg` | Open lazygit in a terminal split |
| `<leader>w` | Save the current file |
| `<leader>q` | Quit Neovim |
| `<leader>h` | Move to the left window |
| `<leader>j` | Move to the window below |
| `<leader>k` | Move to the window above |
| `<leader>l` | Move to the right window |
| `<leader>bd` | Delete the current buffer |

The following command-line abbreviations call their matching LSP or Copilot action:

| Command | Action |
| --- | --- |
| `:ca` | LSP code action |
| `:gi` | Go to implementation |
| `:gr` | Find references |
| `:gco` | Open Copilot Chat |
| `:po` | Choose a project directory |

## Project sessions

Use `:Po` to choose a directory from the current directory's parent. The working directory changes and Neo-tree follows it.

For project-like directories containing `.git`, `pom.xml`, `build.gradle`, `mvnw`, or `package.json`, the configuration automatically restores a session when entering the directory. Sessions are saved automatically before Neovim exits under:

```text
~/.local/share/nvim/sessions/<project-name>.vim
```

Session names use the directory name, so projects with identical directory names can share a session file.

## Java and LSP

Java buffers start JDTLS automatically. The project root is detected from `.git`, `pom.xml`, `build.gradle`, or `mvnw`. JDTLS is configured for Java 17 and uses Lombok when available.

To override the Java runtime, edit `lua/lspconfig/java-lsp.json`:

```json
{
	"java_home": "/path/to/java-17"
}
```

JSON and YAML language servers are enabled globally through `nvim-lspconfig`.

## Configuration layout

```text
init.lua                    Entry point
lua/config/options.lua      Editor options and diagnostics
lua/config/keymaps.lua      Keymaps and command abbreviations
lua/config/project.lua      Project picker and :Po command
lua/config/session.lua       Automatic project sessions
lua/config/ui.lua            Statusline, winbar, and colors
lua/plugins/                lazy.nvim plugin specifications
lua/lspconfig/              Language-specific configuration
```

## Troubleshooting

- Run `:checkhealth` to inspect Neovim dependencies.
- Run `:Lazy` to inspect plugin installation and errors.
- Run `:Mason` to inspect language-server installation.
- Check `:messages` after opening a Java buffer if JDTLS does not start.
- Verify `JAVA_HOME`, `curl`, and the Mason `jdtls` executable for Java setup issues.
