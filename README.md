# A template for BSc / MSc theses

## Why
- No need for anyone to invent the wheel again. You can of course do that
if you wish - TeX'll even let you invent many different kinds of wheels
- That said, if you come up with a great new wheel, we would like to hear about 
it - it might even end up being used here. Merge requests are welcome!

## Short introduction

- Based on the standard LaTeX `report` class
- Proper page sizes as required by university guide for students:
  - proper font sizes as well as linespacings
  - proper size of margins
- Extra document parameters (command: `\documentclass[extra,parameters]{utuftthesis}`)
  - `version`: `draft` / `final` (default: draft) shows/hides [draft] in the footer
  - `language`: `finnish` / `english` (default: finnish) defines the main document
    language, affects the general document appearance and hyphenation
  - `hidechapters`: `true` / `false` (default: true) hides/shows the chapter/luku
    text at the beginning of each Chapter
  - `includereferences`: `true` / `false` (default: false) include reference
    pages when calculating the total number of pages
  - `realtimesnewroman`: `true` / `false` (default: false) use TrueType *Times New Roman*
    instead of Type 1/3 LaTeX fonts (requires XeLaTeX). Requires the font to be installed
    on the system / provided in the document directory. Other fonts can
    be defined with `\setmainfont`.
  - `sharelatex`: `true` / `false` (default: false) don't attempt to locate
    copyright protected system fonts, instead read them from the project
    repository
  - `emptyfirstpages`: `true` / `false` (default: true) clear the headers/footers
    for the 1st pages of text chapters
- Publication metadata
  - `\pubyear{2000}`: the year of the publication
  - `\pubmonth{6}`: the month of the publication
  - `\publab{labname}`: the name of the laboratory, e.g. tietojenkäsittely
  - `\publaben{labname}`: the name of the laboratory in english, e.g. computer science
  - `\pubtype{type}`: the type of the thesis, e.g. tkk, luk, gradu, di, or a hard-coded string for both fi/en
  - `\title{titlename}`: the title of the publication
  - `\author{authorname}`: the author of the publication
- Abstract
  - `\abstract{text}`: abstract written in the main document language
  - `\abstracten{text}`: abstract written in english
  - `\keywords{kw1,kw2}`: list of keywords in the main document language
  - `\keywordstwo{kw1,kw2}`: list of keywords in english
- Title page
  - `\maketitle`: the standard LaTeX command for creating a title page. This template
    also creates the pages for abstracts
- TOC and lists
  - `\tableofcontents`: generates the table of contents
  - `\listoffigures`: generates the list of figures
  - `\listoftables`: generates the list of tables
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

## Using the template

- Start by cloning the whole template repository
```
git clone https://gitlab.utu.fi/ttweb/thesis
```
- The `latex` directory contains the document root
- `utuftthesis.cls` is always required
- `*.lyx` and `*.layout` files are only needed if you decide to use [LyX](https://www.lyx.org/)
- Tthe project can be compiled with latexmk:
```
latexmk -pdf -shell-escape thesis.tex
```
- XeLaTeX version (TrueType fonts)
```
latexmk -pdf -xelatex -shell-escape thesis.tex
```
- The project can also be imported directly (as a .zip) to ShareLaTeX / Overleaf.
  The zip is automatically generated if you [click the cloud icon in Gitlab](https://gitlab.utu.fi/ttweb/thesis/-/archive/master/thesis-master.zip).
  * ShareLaTeX platform hosted @ UTU: https://tex.soft.utu.fi/


## Extra features
- Consultation of the manuals of these packages is strongly
encouraged 

### R

- https://www.tidyverse.org/
- https://ggplot2.tidyverse.org/
- https://yihui.name/knitr/
- https://joshldavis.com/2014/04/12/beginners-tutorial-for-knitr/
- https://gitlab.utu.fi/jmjmak/knitr-examples

### Source code

- https://ctan.org/pkg/minted (preferred)
- https://ctan.org/pkg/listingsutf8 (does not support full unicode)
- https://ctan.org/pkg/sverb (still relevant?)

### PDF/A

- The template automatically enables
  *PDF/A-1b: PDF/A-1b – Level B (basic) conformance* via pdfx when compiling
  the `version=final` version. The [gitlab CI script](https://gitlab.utu.fi/ttweb/thesis/blob/master/.gitlab-ci.yml) of this project explains
  how the resulting PDF can be validated with [VeraPDF](https://verapdf.org/).
  Unfortunately, the official VeraPDF distribution requires an outdated Java 7,
  so the script uses a [custom UTU version](https://gitlab.utu.fi/jmjmak/veraPDF-apps) compatible with Java 11 LTS or later.

## Miscellaneous
- Report bugs via https://gitlab.utu.fi/ttweb/thesis/issues
- Should a required package be missing, see http://www.ctan.org/ 
- LaTeX tutorial: http://www.ctan.org/tex-archive/info/lshort/english/lshort.pdf
