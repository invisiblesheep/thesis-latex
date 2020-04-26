% version 2.3 2019/05/02 Bugfixes: PDF/A-1b support (via pdfx), moved chead to cfoot,
%                                  updated UTU logos
% version 2.2 2018/10/06 Bugfixes: Got rid of startappendices and startpages.
%                                  various fixes. cleanups
% version 2.1 2018/10/02 Bugfixes: removed redundant tutkielma.tex, fixed issues with
%                                  appendices, small caps, added an option to enable
%                                  the truetype times new roman font
% version 2.0 2018/08/29 new version using document classes, xelatex, biblatex, and
%                        additional TeX scripting. Jari-Matti Mäkelä (jmjm@iki.fi)
% version 1.3+ 2017/10/01 - 2016/9/22 additions marked "JH:", modified for use in
%                                     tex.soft.utu.fi, Johannes Holvitie (jjholv@utu.fi)
% version 1.3 2015/09/05 Sami Nuuttila (samnuutt@utu.fi)

% ------------------------------
% How to use? Store the file in
% 1) Windows XP C:\Documents and Settings\<user name>\texmf\tex\latex\local\
% 2) Windows Vista/7 C:\Users\<user name>\texmf\tex\latex\local\
% 3) Linux ~/texmf/tex/latex/local/
% 4) Mac OS X /Users/<user name>/Library/texmf/tex/latex/local/
% 5) Sharelatex: just copy this to the project folder
% 6) or in the same directory as the document
% ------------------------------

\NeedsTeXFormat{LaTeX2e}[2007/01/01]
\ProvidesClass{utuftthesis}[2018/10/06 UTU FT dept BSc/MSc thesis]

%% package requirements for this template
\RequirePackage{kvoptions}        % keyval-options, required by this class definition
\RequirePackage{adjustbox}        % front page box on the right
\RequirePackage{etoolbox}         % misc. tools
\RequirePackage{ifthen}           % misc. tools
\RequirePackage{ifxetex}          % for xelatex/pdflatex font selection
\RequirePackage{fancyhdr}         % customized headers/footers
\RequirePackage{xstring}          % string operations (number of pages etc.)
\RequirePackage[page]{totalcount} % the total number of pages
\RequirePackage{comment}          % LyX generated comments

%% not used by the class
% if you encounter package clashes, start by disabling these
\RequirePackage{graphicx}        % \includegraphics{file}, works without file extensions
\RequirePackage{sverb}           % enhanced handling of verbatim stuff

%% Custom package options
%\DeclareStringOption[00]{year}
\DeclareStringOption[draft]{version}
\DeclareStringOption[a4paper]{paper}
\DeclareStringOption[finnish]{language}
\DeclareBoolOption[true]{hidechapters}
\DeclareBoolOption[false]{includereferences}
\DeclareBoolOption[false]{realtimesnewroman}
\DeclareBoolOption[false]{sharelatex}
\DeclareBoolOption[true]{emptyfirstpages}


%% Process given options
\ProcessKeyvalOptions*

%% Fallback
%\DeclareOption*{}
%  \ClassWarning{myclass}{Unknown option '\CurrentOption'}
%\ProcessOptions\relax
%\RequirePackage{ifpdf}           % not used
%% automatically handle the appendix magic
%\AtEndDocument{\addtocounter{totalcount@page}{-2}}

%% Load base
\LoadClass[\utuftthesis@paper,12pt]{report}

%% Some language macros for choosing between content
%% the langchoose is now only good for \n@tivelang & english. easy to adjust
%% for swedish & english, but multiple choices requires the use of switch-case
\newcommand{\n@tivelang}{finnish}
\newcommand{\l@nguage}{\utuftthesis@language}
\newcommand{\thedoclanguage}{\utuftthesis@language}
%\newcommand{\langchoose}[3]{\expandafter\ifdefstrequal\expandafter{#1}{\n@tivelang}{#2}{#3}}
\newcommand{\langchoose}[3]{\ifthenelse{\equal{#1}{\n@tivelang}}{#2}{#3}}
\newcommand{\langfin}[2]{\langchoose{\l@nguage}{#1}{#2}}

%% Set up encoding/font/hyphenation stuff
\ifxetex
  \RequirePackage{fontspec}
  \RequirePackage{polyglossia}
  \setmainlanguage{\utuftthesis@language}
  \langfin{\setotherlanguage{english}}

  \ifutuftthesis@realtimesnewroman
    % can't use (C) TTF fonts when the ms corefonts are not installed
    \ifutuftthesis@sharelatex
      \setmainfont[BoldFont=timesbd.ttf,ItalicFont=timesi.ttf,BoldItalicFont=timesbi.ttf]{times.ttf}
    \else
      \setmainfont{Times New Roman}
    \fi
  \fi
\fi
\ifxetex
\else
  % JH: modified latin to UTF-8 encoding cues to make Scandinavian characters works
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage{lmodern}

  % load babel-package for automatic hyphenation
  \ifdefstring{\utuftthesis@language}{english}{
    \RequirePackage[english]{babel}
  }{
    \RequirePackage[english, \l@nguage]{babel}
  }

  % change default font to times-roman
  \renewcommand{\sfdefault}{phv}
  \renewcommand{\rmdefault}{ptm}
  \renewcommand{\ttdefault}{pcr}
\fi

%% the rest of the requirements listed here as they have
%% language specific definitions etc.
\RequirePackage[style=ieee,backend=biber]{biblatex} % bibliography, new engine
\RequirePackage{listings}               % handle inclusion of source code
\RequirePackage{csquotes}
\RequirePackage{amssymb,amsthm,amsmath} % load ams-packages for maths
\RequirePackage{empheq}
\RequirePackage{datetime2}              % month names
\RequirePackage{titlecaps}              % month names

%% switch-case used to select the thesis type
\newbool{default}
\newcommand{\case}{}
\newcommand{\default}{}
\newenvironment{switch}[1]{%
    \booltrue{default}
    \renewcommand{\case}[2]{\ifthenelse{\equal{#1}{##1}}{%
        \boolfalse{default}##2}{}}%
    \renewcommand{\default}[1]{\ifbool{default}{##1}{}}
}{}

%% these are used as global variables on the magic pages
%% feel free to modify for other languages / if the info is outdated
\newcommand{\ye@r}{\the\year}
\newcommand{\m@nth}{\the\month}
\newcommand{\p@blab}{Labra}
\newcommand{\p@blaben}{Laboratory}
\newcommand{\s@pervisors}{none}
\newcommand{\k@ywords}{not set}
\newcommand{\k@ywordstwo}{not set}

\ifdefstring{\utuftthesis@version}{draft}{
  \newcommand{\version}{[draft]}

}{
  \newcommand{\version}{}
  \RequirePackage[a-1b]{pdfx}
}

\newcommand\keywords[1]{\renewcommand\k@ywords{#1}}
\newcommand\keywordstwo[1]{\renewcommand\k@ywordstwo{#1}}
\newcommand\pubyear[1]{\renewcommand\ye@r{#1}}
\newcommand\pubmonth[1]{\renewcommand\m@nth{#1}}
\newcommand\publab[1]{\renewcommand\p@blab{#1}}
\newcommand\publaben[1]{\renewcommand\p@blaben{#1}}
\newcommand\pubtype[1]{\newcommand\p@btype{#1}}
\newcommand\supervisors[1]{\renewcommand\s@pervisors{#1}}
\newcommand{\department}[1]{\langchoose{#1}{Tulevaisuuden teknologioiden laitos}{Department of Future Technologies}}
\newcommand{\university}[1]{\langchoose{#1}{Turun yliopisto}{University of Turku}}
\newcommand{\University}[1]{\langchoose{#1}{\MakeUppercase{Turun yliopisto}}{\MakeUppercase{University of Turku}}}
\newcommand{\labname}[1]{\langchoose{#1}{\p@blab}{\p@blaben}}
\newcommand{\pagesname}[1]{\langchoose{#1}{s.}{p.}}
\newcommand{\apppagesname}[1]{\langchoose{#1}{liites.}{app. p.}}
\newcommand{\kwlabel}[1]{\langchoose{#1}{Asiasanat}{Keywords}}
\newcommand{\supervisorstext}{\langfin{Tarkastajat}{Supervisors}}
\newcommand{\runagain}[1]{\langchoose{#1}\langfin{aja LaTeX uudestaan}{please rerun LaTeX}}
\newcommand{\turnitin}{\langfin{Turun yliopiston laatujärjestelmän mukaisesti tämän julkaisun alkuperäisyys on tarkastettu Turnitin OriginalityCheck-järjestelmällä.}
{The originality of this thesis has been checked in accordance with the University of Turku quality assurance system using the Turnitin OriginalityCheck service.}}

%% needs to be implemented like this due to the initialization order
\langfin{
\newcommand{\refs}{Lähdeluettelo}
\newcommand{\appname}{Liitteet}
}{
\newcommand{\refs}{References}
\newcommand{\appname}{Appendices}
}

%% magic thesis types. more can be added
\newcommand*{\thesistype}[1]{
  \begin{switch}{\p@btype}
    \case{tkk}{\langchoose{#1}{TkK-tutkielma}{Bachelor's Thesis}}%
    \case{luk}{\langchoose{#1}{LuK-tutkielma}{Bachelor's Thesis}}%
    \case{gradu}{\langchoose{#1}{Pro gradu -tutkielma}{Master of Science Thesis}}%
    \case{di}{\langchoose{#1}{Diplomityö}{Master of Science Thesis}}%
    \default{\p@btype}%
  \end{switch}}

\newcommand{\monthname}[1]{\csname DTM#1monthname\endcsname}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% setup document appearance
%

% fix page size
%
%  - page width:
%     1inch             +
%      \hoffset         +
%      \oddsidemargin   +
%      \textwidth       +
%      \marginsep       +
%      \marginparwidth
%
%  - page height:
%     1inch             +
%      \voffset         +
%      \topmargin       +
%      \headheight      +
%      \headsep         +
%      \textheight      +
%      \footnotesep     +
%      \footheigth
%
%  - 1 pt == 1/72 inch == 0.35 mm
%
% page width... left margin 4cm, right 2cm
%
\setlength{\hoffset}{0mm}
\setlength{\marginparsep}{0mm}
\setlength{\marginparwidth}{0mm}
\setlength{\textwidth}{\paperwidth}
\addtolength\textwidth{-60 mm}
\setlength{\oddsidemargin}{-1 in}
\addtolength\oddsidemargin{40 mm}

% page height... textheight starts at ~4cm from top,
% i.e. 1 in + 12 pt + 24 pt = 1.5 in
%
\setlength{\voffset}{0 mm}
\setlength{\topmargin}{0 mm}
\setlength{\headheight}{14.5 pt}
\setlength{\headsep}{24 pt}
\setlength{\textheight}{230mm}
\setlength{\footnotesep}{12 pt}


% setup linespacings to suit to the (stupid) requirement of double spacing
%
% - fake 1.5 linespacing
%    \renewcommand{\baselinestretch}{1.241}
%
% - fake 2 linespacing
%
\renewcommand{\baselinestretch}{1.655}

%% Modify the \printbibliography command
\defbibheading{bibliography}{
  %\eofpages
  % label here if we don't include references
  \ifutuftthesis@includereferences
  \else
  \label{endofpages}
  \fi
  \chapter*{\refs}
  \addcontentsline{toc}{chapter}{\refs}
}

\let\oldprintbibliography\printbibliography

\renewcommand{\printbibliography}{
  \oldprintbibliography
  % label here if we also include references
  \ifutuftthesis@includereferences
    \label{endofpages}
  \fi
\langfin{
  \selectlanguage{finnish}
}{
  \selectlanguage{english}
}
}

%% Macro for hiding the chapter texts
\ifutuftthesis@hidechapters
  \renewcommand{\@chapapp}{\relax}
  \renewcommand{\@makechapterhead}[1]{%
    \vspace*{50\p@}%
    {\parindent \z@ \raggedright \normalfont
      \ifnum \c@secnumdepth >\m@ne
          \huge\bfseries \@chapapp\space \thechapter\space\space
      \fi
      \interlinepenalty\@M
      \Huge \bfseries #1\par\nobreak
      \vskip 40\p@
    }}
\fi

%% entry environment
\newenvironment{entry}[1]{\begin{list}{}{%
    \renewcommand{\makelabel}[1]{\textrm{##1:}\hfil}%
    \settowidth{\labelwidth}{\textrm{#1:}}%
    \setlength{\leftmargin}{\labelwidth}%
    \addtolength{\leftmargin}{\labelsep}}}
{\end{list}}


%% the first abstract
\langfin{
  \renewenvironment{abstract}{\@bstracth{finnish}}{\@bstractt{finnish}{\k@ywords}}

  %% the second abstract environment
  %% always in english - but can be omitted if the document uses a single language
  \newenvironment{abstracten}{\@bstracth{english}}{\@bstractt{english}{\k@ywordstwo}}
}{
  \renewenvironment{abstract}{\@bstracth{english}}{\@bstractt{english}{\k@ywords}}

  %% the second abstract environment
  %% always in english - just an alias for 'abstract'
  \newenvironment{abstracten}{\@bstracth{english}}{\@bstractt{english}{\k@ywords}}
}

%% title page, reuses the standard \maketitle
\renewcommand*{\maketitle}{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{\stretch{1}}
  \vspace{3mm}
  \noindent
  \rule{\linewidth}{1 mm}
  \renewcommand{\baselinestretch}{1.05}\normalsize
  \begin{flushright}
  \Huge{\@title}
  \end{flushright}
  \rule{\linewidth}{1 mm}
  \vspace*{\stretch{4}}

  \renewcommand{\baselinestretch}{1}\normalsize
  \begin{adjustbox}{minipage=65mm,right}
  \thesistype{\l@nguage}\\
  \university{\l@nguage}\\
  \department{\l@nguage}\\
  \labname{\l@nguage}\\
  \ye@r\\
  \@author
  \ifdefstring{\s@pervisors}{none}{}{\\
    \\
    \supervisorstext:
    \expandafter\forcsvlist\expandafter\\\expandafter{\s@pervisors}
  }
  \end{adjustbox}
  \vspace*{\stretch{1}}\\
  \scriptsize \turnitin

  \renewcommand{\baselinestretch}{1.655}\normalsize
  \clearpage
}

%% used to detect the empty \totalpages on the first latex run
\newcommand*{\IsInteger}[3]{\IfStrEq{#1}{ }{}{\IfInteger{#1}{#2}{#3}}}

%% top part of the abstract page (since we use environments)
\newcommand{\@bstracth}[1]{%
  \selectlanguage{#1}
  \setlength{\headheight}{0 pt}
  \setlength{\headsep}{0 pt}
  \addtolength\topmargin{-0.54 cm}
  \renewcommand{\baselinestretch}{1}\normalsize
  \clearpage
  \thispagestyle{empty}
  \noindent
  \begin{minipage}[\textheight]{\linewidth}
  \University{#1}\\
  \department{#1}
  \begin{entry}{}
  \item[\textsc{\@author}] \@title
  \end{entry}
  \thesistype{#1},
  \IsInteger{\totalpages}{
    \pageref{endofpages} \pagesname{#1}%
    \ifnum \totalpages > 0
      , \totalpages\ \apppagesname{#1} \\
    \else
      \\
    \fi
  }{ \runagain{#1} \\
  }
  \labname{#1}\\
  \titlecap{\monthname{#1}{\m@nth}} \ye@r\\
  \rule{\linewidth}{1 pt}
  \\
}

%% bottom part of the abstract page
\newcommand{\@bstractt}[2]{%
  \selectlanguage{#1}
  \bigskip
  \\
  \begin{entry}{}
    \item[\kwlabel{#1}] #2
  \end{entry}
  \end{minipage}
  \clearpage
  \setcounter{page}{0}
  \setlength{\headheight}{12 pt}
  \setlength{\headsep}{24 pt}
  \setlength{\topmargin}{0 mm}
  \renewcommand{\baselinestretch}{1.655}\normalsize

  % roman numbering for table of contents etc.
  \pagenumbering{roman}
}

%% define \figcaption and \tblcaption for use with non-floating figures and tables
\newcommand\figcaption{\def\@captype{figure}\caption}
\newcommand\tblcaption{\def\@captype{table}\caption}

%% compatible with old versions that required using \startpages
%% now optional
\newcommand{\startpages}{\initdocstyle}

%% initializes the settings for main document content
\newcommand{\initdocstyle}{%
  \renewcommand{\startpages}{}
\langfin{
  \selectlanguage{finnish}
}{
  \selectlanguage{english}
}
  \clearpage
  % clear 1st page headers/footers per request
  \ifutuftthesis@emptyfirstpages
  \fancypagestyle{plain}{\fancyhf{}\renewcommand{\headrulewidth}{0 pt}}
  \fi
  \pagenumbering{arabic}
  \setcounter{page}{1}
  \renewcommand{\baselinestretch}{1.655}
  \pagestyle{fancy}
  \renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{\chaptername\ \thechapter.\ ##1}}{}}
  \lhead{\leftmark}
  \chead{}
  \rhead{\thepage}
  \fancyfoot{}
  \cfoot{\version}
  % the totalcount counter is only used for appendices, set a bogus value now
  % fails if the document has over 1000 pages
  \setcounter{totalcount@page}{-1000}
}

%% postpone the doc style through these sections
\pretocmd{\tableofcontents}{\renewcommand{\startpages}{}}{}{}
\apptocmd{\tableofcontents}{\renewcommand{\startpages}{\initdocstyle}}{}{}
\pretocmd{\listoffigures}{\renewcommand{\startpages}{}}{}{}
\apptocmd{\listoffigures}{\renewcommand{\startpages}{\initdocstyle}}{}{}
\pretocmd{\listoftables}{\renewcommand{\startpages}{}}{}{}
\apptocmd{\listoftables}{\renewcommand{\startpages}{\initdocstyle}}{}{}

%% finally initialize the main document style
\pretocmd{\chapter}{\startpages}{}{}

%% compatible with old versions that required using \appendices
%% now optional
\newcommand{\appendices}{\startappendices}

%% initializes the settings for appendices
\newcommand{\startappendices}{%
  \renewcommand{\appendices}{}
  \clearpage
  \appendix
  \addtocontents{toc}{\protect\contentsline{chapter}{\appname}{}\relax}
  \renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{\appendixname\ \thechapter.\ ##1}}{}}
  \rhead{\thechapter-\arabic{page}}
  \setcounter{page}{0}
  \renewcommand\thepage{\thechapter-\arabic{page}}
  \setcounter{totalcount@page}{0}
}

%% use in place of \chapter
\newcommand{\appchapter}[1]{%
  \appendices
  \addtocounter{totalcount@page}{\value{page}}
  \clearpage
  \setcounter{page}{1}
  \chapter{#1}
}

\ifdefstring{\utuftthesis@version}{draft}{
}{
  \hypersetup{hidelinks} % can be customized if you don't want to hide links
}
