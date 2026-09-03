# my neovim config


## spec

- moduláris legyen
- theme onedark theme https://github.com/navarasu/onedark.nvim.git

- p betűre legyen egy mappa választó amivel mappát lehet megnyitni mint egy project-et


legyen egy plugins mappa amibe custom lua file-okat feolvassa amit később oda teszek

legyen alapból telepítve: jdtls,json,yaml language servers
egy lspconfig mappa amiben :
java-lsp.json
{
    "java_home": "..",
    "formatter": "<ide a formatter binary kerül pl.: google-java-format,stb>"

}

ezt olvassa fel a jdtls config

a lazyvim billentyűzet kiosztása legyen definiálva ( https://www.lazyvim.org/ )

ha csak magában megnyitom a neovim-et akkor középen felül nagy betűkkel legyen az hogy ERDOS-VIM

billentyű parancsok:

f f: file find
f g : ripgrep
g g lazygit

a p betű project megnyitás az jónak néz ki de nem nyitja meg a választott mappát

