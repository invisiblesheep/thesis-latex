FROM debian:buster-slim

WORKDIR /var/local

ENV DEBIAN_FRONTEND noninteractive

# combine into one run command to reduce image size
RUN mkdir -p /usr/share/man/man1 && apt-get update && \
    apt-get install -y perl wget libfontconfig1 openjdk-11-jre-headless poppler-utils python3-pygments && \
    wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh  && \
    apt-get clean
    
ENV PATH="${PATH}:/root/bin"

RUN tlmgr update --self && tlmgr install xetex scheme-small && fmtutil-sys --all

# install only the packages you need
RUN tlmgr install adjustbox collectbox biblatex tracklang biblatex-ieee csquotes datetime2 \
    datetime2-english datetime2-finnish biber xstring units lastpage comment genmisc \
    fontawesome chessboard skak glossaries datenumber datetime advdate multido todonotes \
    semantic syntax wasysym dashrule titlecaps pdfx ifnextok xmpincl blindtext minted \
    fvextra catchfile includernw algorithm2e shapepar hanging sectionbox euro nag nomencl \
    filecontents && tlmgr path add

RUN wget http://ftdev.utu.fi/downloads/resources/greenfield-apps-1.15.0-SNAPSHOT.jar -O /validator.jar && \
    echo 'java -cp /validator.jar org.verapdf.apps.GreenfieldCliWrapper --format text -v "$@"' > /root/bin/pdfa-validate && \
    chmod +x /root/bin/pdfa-validate

