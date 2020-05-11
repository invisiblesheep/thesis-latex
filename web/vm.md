
# LaTeX virtual machine

The Department of Future Technologies provides a set of virtual machines for
software development and other tasks via https://ftdev.utu.fi/. The `utuvm-latex`
virtual machine is especially preconfigured for generating LaTeX documents.
The virtual machine has been tested to build this document template without
any issues.

The `utuvm-latex` virtual machine contains preinstalled versions of
  * TeX Live (popular Linux/Unix LaTeX distribution)
  * LyX (for WYSIWYM editing)
  * Pandoc for generating LaTeX documents from markdown sources
  * TeX editors (Gummy, Texworks, Texmaker, Texstudio)
  * Generic editors (Emacs, Vim, Geany, nano )
  * PDF reader (Evince)
  * Pygments for syntax highlighting (minted)
  * Seafile client for storing the documents in the University's
    Seafile server.
  * Docker, systemd-nspawn

The virtual machine also comes with a modern browser (Chromium) for editing
documents in ShareLaTeX and Overleaf.

Extra applications can be easily installed from deb packages. 

![](web/vm.png)

## Using the virtual machine

Please refer to the instructions on the virtual machine site for
setting up the platform.

The TeX tools in the VM are standard without further customizations.
The [general instructions on using the template](web/config.md)
should cover the usage of the provided tools.
