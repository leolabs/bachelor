FROM debian:stretch
LABEL maintainer="Leo Bernard <admin@leolabs.org>"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV HOME /

RUN apt-get update && \
  apt-get install -y pandoc pandoc-citeproc imagemagick

# needed for basic build rules
RUN apt-get install -y software-properties-common

# needed for asymptote to run
RUN apt-get install -y freeglut3 libglu1 libosmesa6 ghostscript

RUN apt-get update -q \
  && apt-get install -qy build-essential wget libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

# Install TexLive with scheme-medium
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
  mkdir /install-tl-unx; \
  tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
  echo "selected_scheme scheme-medium" >> /install-tl-unx/texlive.profile; \
  /install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
  rm -r /install-tl-unx; \
  rm install-tl-unx.tar.gz

ENV TEXLIVE_DIR="/usr/local/texlive/2019"
ENV TEXLIVE_BIN="${TEXLIVE_DIR}/bin/x86_64-linux"
ENV PATH="${TEXLIVE_BIN}:${PATH}"

# ghostscript links to export (https://packages.debian.org/jessie/amd64/ghostscript/filelist)
RUN ln -s /usr/bin/dvipdf /usr/bin/eps2eps /usr/bin/font2c /usr/bin/ghostscript /usr/bin/gs /usr/bin/gsbj /usr/bin/gsdj /usr/bin/gsdj500 /usr/bin/gslj /usr/bin/gslp /usr/bin/gsnd /usr/bin/pdf2dsc/usr/bin/pdf2ps /usr/bin/pdfopt /usr/bin/pf2afm /usr/bin/pfbtopfa /usr/bin/pphs /usr/bin/printafm /usr/bin/ps2ascii /usr/bin/ps2epsi /usr/bin/ps2pdf /usr/bin/ps2pdf12 /usr/bin/ps2pdf13 /usr/bin/ps2pdf14 /usr/bin/ps2pdfwr /usr/bin/ps2ps /usr/bin/ps2ps2 /usr/bin/ps2txt /usr/bin/wftopfa "${TEXLIVE_BIN}"

RUN tlmgr install biber latexmk varwidth logreq tabu geometry biblatex csquotes \
  blindtext chngcntr tikz-cd blindtext wrapfig tabu paralist

COPY build.sh /build.sh
RUN chmod +x build.sh

ENTRYPOINT [ "/build.sh" ]

WORKDIR /github/workspace

VOLUME ["/github/workspace"]
