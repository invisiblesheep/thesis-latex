
# PDF/A conformance and metadata

The PDF/A generation mechanism is described in more detail in the
[pdfx manual](ftp://ftp.funet.fi/pub/TeX/CTAN/macros/latex/contrib/pdfx/pdfx.pdf).

## Configuration

- First, compile the document using `version=final` in the document class parameters
- The PDF/A conformance level can be configured with the `pdfaconformance` parameter
- The default conformance level is `a-2b` (*PDF/A-2b: PDF/A-2b – Level B (basic) conformance*)
  - other supported values: `a-1b`, `a-2u`, `a-3b`, `a-3u`, `a-1a`, `a-2a`, `a-3a`, and `none`
  - the values `a-1a`, `a-2a`, and `a-3a` are still marked as experimental
  - the default conformance level should be sufficient for most thesis documents
  - `none` disables pdfx

## Metadata file (thesis.xmpdata)

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
- The following code (`thesis.xmpdata`) is provided as an example:
```
\Title{Baking through the ages}
\Author{A. Baker\sep C. Kneader}
\Language{en-GB}
\Keywords{cookies\sep muffins\sep cakes}
\Publisher{University of Turku}
```

## Tools

Note that PDF/A support is a rather new feature in LaTeX, e.g. the pdfx
1.6.3 library was announced 2019/2/27. If the document fails to validate,
consider compiling with a more recent LaTeX distribution. The template
has been tested with TeXLive 2017+.

A free [VeraPDF](https://verapdf.org/) tool can be used to test if the
resulting PDF files are PDF/A conformant. Unfortunately, the official
VeraPDF distribution may not build. Use the 1.15-SNAPSHOT
[version hosted at UTU gitlab](https://gitlab.utu.fi/jmjmak/veraPDF-apps)
instead.

The following script shows how to invoke the VeraPDF tool:

```bash
$ wget https://gitlab.utu.fi/jmjmak/veraPDF-apps/raw/integration/greenfield-apps-1.15.0-SNAPSHOT.jar?inline=false -O validator.jar
$ latexmk -pdf -shell-escape thesis.tex
$ java -cp validator.jar org.verapdf.apps.GreenfieldCliWrapper --format text -v thesis.pdf
```

The UTU build of the VeraPDF tool is also included in the
[LaTeX Docker image](web/docker.md) and can be run by simply invoking
`pdfa-validate <file.pdf>`. The [gitlab CI script](.gitlab-ci-simple.yml)
in this project demonstrates the validation of CI/CD generated PDFs with
this tool.
  
## Limitations

- pdfTeX should not have any significant limitations
- luaLaTeX expects all input documents to be encoded using utf-8 (mainly
  a problem for Windows users)
- XeLaTeX generated documents may fail when using OTF fonts (see the
  [pdfx manual](ftp://ftp.funet.fi/pub/TeX/CTAN/macros/latex/contrib/pdfx/pdfx.pdf)
  section 3.1.1).
- XeLaTeX requires the extra parameter (`-output-driver="xdvipdfmx -z 0"`)
  which is included in the provided `latexmkrc`.
- XeLaTeX will not generate conforming PDF/A documents when the
  output-directory is changed in `latexmk`.
- Configuring a default action (hyperref) when opening the PDF will
  produce non-conforming PDF files.

## What are these PDF/A conformance rules?

The VeraPDF page contains a list of validation rules:

  * https://github.com/veraPDF/veraPDF-validation-profiles/wiki/PDFA-Part-1-rules
  * https://github.com/veraPDF/veraPDF-validation-profiles/wiki/PDFA-Parts-2-and-3-rules

Related:
  * https://utuguides.fi/opinnayte/pdfa  
  * https://coursepages.uta.fi/mtta1-latex/pdf-a/
