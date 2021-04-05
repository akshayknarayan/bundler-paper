##

TARGETS = bundler-main
FINAL = bundler-eurosys21-camera-ready.pdf

TEXFILES = $(wildcard *.tex)
KNITRFILES = $(wildcard graphs/*.Rnw)
KNITRTARGETS = $(subst graphs/,,$(KNITRFILES:.Rnw=.tex))
PDFS = $(addsuffix .pdf,$(TARGETS))

arxiv:
	pdflatex --shell-escape "\\def\\forArxiv{1} \\input{bundler-main.tex}"
	bibtex bundler-main
	pdflatex --shell-escape "\\def\\forArxiv{1} \\input{bundler-main.tex}"
	pdflatex --shell-escape "\\def\\forArxiv{1} \\input{bundler-main.tex}"

all: $(PDFS)

final: $(PDFS)
	gs \
		-dCompatibilityLevel=1.4 \
	   -dPDFSETTINGS=/default \
	   -dCompressFonts=true \
	   -dSubsetFonts=true \
	   -dNOPAUSE \
	   -dBATCH \
	   -sDEVICE=pdfwrite \
	   -sOutputFile=$(FINAL) \
	   -c ".setpdfwrite <</NeverEmbed [ ]>> setdistillerparams" \
	   -f $?

%.pdf: %.tex $(TEXFILES) $(KNITRTARGETS) usenix2019_v3.sty ref.bib imgs
	pdflatex -shell-escape -shell-escape $*.tex
	bibtex $*
	pdflatex -shell-escape -shell-escape $*.tex
	pdflatex -shell-escape -shell-escape $*.tex

.SECONDARY: $(KNITRTARGETS)

%.tex: graphs/%.Rnw
	$(info $?)
	Rscript -e "library(knitr); knit('$?')"

ecmp_delay.tex: figure/ecmp_delay.pdf

figure/ecmp_delay.pdf: graphs/ecmp_delay_rolling.r
	Rscript graphs/ecmp_delay_rolling.r

imgs: $(wildcard imgs/*.pdf)

clean:
	/bin/rm -f *.dvi *.aux *.ps *~ *.log *.out *.lot *.lof *.toc *.blg *.bbl url.sty
	/bin/rm -rf cache
	/bin/rm -rf $(PDFS) # $(KNITRTARGETS)
	/bin/rm -rf _minted-$(TARGETS)

evince:
	pdflatex -shell-escape $(TARGETS).tex
	evince $(PDFS) &

acro:
	pdflatex -shell-escape $(TARGETS).tex
	acroread $(PDFS) &

osx:
	pdflatex -shell-escape $(TARGETS).tex
	open $(PDFS)

windows:
	pdflatex -shell-escape $(TARGETS).tex
	explorer.exe $(PDFS) &

home: osx

check:
	pdflatex -shell-escape $(TARGETS).tex | grep -i -e "undefined" -e "multiply"
