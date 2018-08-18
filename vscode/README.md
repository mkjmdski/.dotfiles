# VS Code

## Plugins

In modern light-weight IDEs like `atom`, `sublime` or `vscode` plugins are the most important part of configuration because they create most of functionalities during development process. In this repository plugins are kept as a part of version control by hook located in `.hooks`. With each commit all extensions are listed in `installed_vs_extensions` so they can be installed in same configuration on the other machine

## Configuration and snippets

Snippets and settings are symlinked to the VCS so after pull on the other machine extensions configuration and your favourite snippets are loaded automatically. New extensions are installed thanks to `post-merge` hook in git. Those not listed in the directory aren't deleted!