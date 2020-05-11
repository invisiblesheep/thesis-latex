
# Using the thesis template

## Structure

You're free to organize the project as you wish. A sane default structure
looks like this:

 - root
   - .gitlab-ci.yml: configures CI/CD
   - .gitignore: configures git to ignore temp files
   - utuftthesis.clss: document class description
   - thesis.xmpdata: metadata for PDF/A generation
   - latexmkrc: build instructions for latexmk
   - thesis.tex: main document (links to sub-documents)
   - bibliography.bib: biblioraphy data (multiple bibs also possible)
   - section-X.tex: sub-documents for sections
   - images/: embedded images
   - sources/: embedded source code listings

In case you're using LyX, the following extra files are needed (the tex
files can be generated from the lyx files):

 - root
   - utuftthesis.layout: document class configuration for LyX
   - thesis.lyx: main document (links to sub-documents)
   - section-X.lyx: sub-documents for sections

The standard files included in the template consist of:

- The `latex` directory contains the document root. Everything from
  this directory can be moved to the project root, but make sure you'll
  update the Gitlab CI, too.
- The `tests` directory can be deleted. It contains an extensive test
  suite for the template.
- The document class file `utuftthesis.cls` is always required.
- The `*.lyx` and `*.layout` files are only needed if you decide to
  use [LyX](https://www.lyx.org/), and can be deleted in other cases.

## Workflow

The documents are typically edited with
  - TeX editors
  - generic editors
  - LyX
  - hosted cloud services (ShareLaTeX, Overleaf, or even Gitlab Web IDE)

The documents are compiled with
  - TeX -> directly with TeX utilities (pdflatex/xelatex/tectonic) -> PDF
  - TeX -> LaTeX frontend (mklatex, arara etc.) -> PDF
  - LyX -> TeX -> one of the previous two -> PDF
  - LyX -> PDF
  - Integrated build system (ShareLaTeX / Overleaf) -> PDF
  - CI/CD pipeline (Gitlab) -> PDF artifact / publish site

Note that when using TeX utilities directly, you need to make sure the
document has been fully processed. Usually this requires multiple
compilation passes, interleaved with invocations of the auxiliary tools
(glossary & bibliography generation etc.). Using the LaTeX frontend
tools (latexmk) instead are highly recommended.

## Document class configuration

The thesis document class is described in [`utuftthesis.cls`](latex/utuftthesis.cls).

- Based on the standard LaTeX `report` class
- Proper page sizes as required by university guide for students:
  - proper font sizes as well as linespacings
  - proper size of margins
- Document parameters (command: `\documentclass[the,parameters]{utuftthesis}`)
  - `version`: `draft` / `final` (default: `draft`) shows/hides [draft] in the footer
  - `language`: `finnish` / `english` (default: `finnish`) defines the main document
    language, affects the general document appearance and hyphenation
  - `mainfont`: (default: `times`)
    - pdftex: main font package (`lmodern`, `fourier`, ...), special value: `times`, `none`
    - xetex: main font name (Arial, Comic Sans, ...), special value: `times` enables Times New Roman, `none`
    - note: use `none` in cloud/CI services in place of `times` unless you provide the
      fonts yourself. The copyrighted fonts cannot be included in free platform
      distributions due to licensing issues.
  - `hidechapters`: `true` / `false` (default: `true`) hides/shows the chapter/luku
    text at the beginning of each Chapter
  - `countbibpages`: `true` / `false` (default: `false`) include bibliography
    pages when calculating the total number of pages
  - `sharelatex`: `true` / `false` (default: `false`) don't attempt to locate
    copyright protected system fonts, instead read them from the project
    repository
  - `emptyfirstpages`: `true` / `false` (default: `true`) clear the headers/footers
    for the 1st pages of text chapters
- Extra document parameters (command: `\documentclass[extra,parameters]{utuftthesis}`)
  - `paper`: (default: `a4paper`) paper size
  - `pagecountdelta`: any integer (default: `-1`). Adjust the counting of app. pages
  - `pdfaconformance`: `a-1b`/ `a-2b` / `a-2u` / `a-3b` / `a-3u` / `none`
    (default: `a-2b`) PDF/A conformance level. A special parameter `mathxmp` can be
    also appended (see the PDF/A documentation).
  - `hidelinks`: `true` / `false` (default: `true`) hide the underlining of links
  - `minted`: `true` / `false` (default: `false`) use minted instead of listings
    for embedded code listings. Note that minted requires the use of `-shell-escape`
    build parameter.
  - `biburlbreak`: `ragged` / `split` / `none` (default: `split`) how to handle
    long urls in the bibliography
- Publication metadata
  - `\pubyear{2000}`: the year of the publication
  - `\pubmonth{6}`: the month of the publication
  - `\publab{labname}`: the name of the laboratory, e.g. tietojenkäsittely
  - `\publaben{labname}`: the name of the laboratory in english, e.g. computer science
  - `\pubtype{type}`: the type of the thesis, special type name (`tkk`,
    `luk`, `gradu`, `di`), or a custom string for both fi/en
  - `\title{titlename}`: the title of the publication
  - `\author{authorname}`: the author of the publication
- Abstract
  - `\abstract{text}`: abstract written in the main document language
  - `\abstracten{text}`: abstract written in english
  - `\keywords{kw1,kw2}`: list of keywords in the main document language
  - `\keywordsen{kw1,kw2}`: list of keywords in english
- Title page
  - `\maketitle`: the standard LaTeX command for creating a title page. This template
    also creates the pages for abstracts
- TOC and lists
  - `\tableofcontents`: generates the table of contents
  - `\listoffigures`: generates the list of figures
  - `\listoftables`: generates the list of tables
  - `\listofacronyms`: generates the list of acronyms (using the `nomencl` package)
- Main content
  - `\begin{document}`: begins the main content
  - `\end{document}`: ends the main content
  - `\chapter{name}`: generates a new chapter (1)
  - `\section{name}`: generates a new section (1.1)
  - `\subsection{name}`: generates a new section (1.1.1)
  - `\printbibliography`: generates the bibliography list
    (required even if no bibliography has been used!)
  - `\appchapter{name}`:  generates a new appendix chapter (A) after the bibliography list
- Entry environment:
  - the actual items are aligned to suit the widest label, which is
    given as an argument to the environment
```
\begin{entry}[widest label]
  \item[1st label text] ...
  \item[2nd label text] ...
\end{entry}
```

## PDF/A conformance and metadata

The PDF/A generation mechanism is described in more detail in the
[pdfx manual](ftp://ftp.funet.fi/pub/TeX/CTAN/macros/latex/contrib/pdfx/pdfx.pdf).

### Configuration

- First, compile the document using `version=final` in the document class parameters
- The PDF/A conformance level can be configured with the `pdfaconformance` parameter
- The default conformance level is `a-2b` (*PDF/A-2b: PDF/A-2b – Level B (basic) conformance*)
  - other supported values: `a-1b`, `a-2u`, `a-3b`, `a-3u`, `a-1a`, `a-2a`, `a-3a`, and `none`
  - the values `a-1a`, `a-2a`, and `a-3a` are still marked as experimental
  - the default conformance level should be sufficient for most thesis documents
  - `none` disables pdfx

### Metadata file

- The pdfx package explicitly disables the propagation of document metadata
  from the LaTeX preamble to PDF metadata fields (such aspdfauthor, pdftitle,
  pdfsubject, pdfkeywords, etc.). This should not be altered with hyperref
  as all the embedded metadata must be synchronized in conformant PDF/A
  documents.
- Instead, the embedded PDF/A metadata is provided in XMP format and read from
  `<maindoc>.xmpdata` (just replace `<maindoc>` here with the main tex file,
  e.g. `thesis`).
- For detailed documentation of the metadata fields and the process, please
  refer to the pdfx.pdf sections 2.2--2.3.
- The following code ([`thesis.xmpdata`](latex/thesis.xmpdata)) is provided as an example:
```
\Title{Baking through the ages}
\Author{A. Baker\sep C. Kneader}
\Language{en-GB}
\Keywords{cookies\sep muffins\sep cakes}
\Publisher{University of Turku}
```

## Using the template

Start by cloning the whole template repository.
The following command line instructions can be used for setting up
a new thesis (replace MYNAME with your utu username):

```bash
$ git clone https://gitlab.utu.fi/ttweb/thesis
$ cd thesis
$ git remote add mythesis https://gitlab.utu.fi/MYNAME/mythesis
$ git push -u mythesis master
```

If you'd like to use the Gitlab CI script, considering setting up
the simplified CI pipeline that does not run the full test suite
(invoke these commands in the thesis/ directory):

```bash
$ cp .gitlab-ci-simple.yml .gitlab-ci.yml
$ rm -fr tests
$ git add -A
$ git ci -m 'Removed unnecessary testing.'
$ git push
```

Changes to the project will be pushed to your `mythesis` repository
(invoke these commands in the thesis/ directory):

```bash
$ touch test
$ git add test
$ git ci -m 'Just testing'
$ git remote -v
$ git push
```

The project can be compiled with latexmk (pdfTeX):

```bash
$ latexmk -pdf -shell-escape thesis.tex
```
XeLaTeX version can be compiled like so (OpenType/TrueType fonts):

```bash
$ latexmk -xelatex -shell-escape thesis.tex
```
