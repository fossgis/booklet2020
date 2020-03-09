all: master.pdf

clean: master.pdf
	rm master.pdf programme-a6-*.pdf programme-a6.pdf cropped.pdf programme-a0-*.pdf

master.pdf: *.tex */*.tex */*.lua images-print/*.pdf images-print/*.png
	lualatex master.tex -interaction=nonstopmode && lualatex -interaction=nonstopmode master.tex

publish: master.pdf
	scp master.pdf 1blu-rootserver:/var/www/html/fossgis/booklet20/

programme-a0: programme-a0.pdf

programme-a0.pdf: programme-a6.pdf
	pdfjam --outfile $@ --trim "0.5cm 0.7cm 0.9cm 0.7cm" --clip true --paper a0paper --landscape --nup 4x2 --column true $<

programme-a6.pdf: programme-a6-mittwoch.pdf programme-a6-donnerstag.pdf programme-a6-freitag.pdf
	pdfjam --outfile $@ --paper a6paper programme-a6-mittwoch.pdf - programme-a6-donnerstag.pdf - programme-a6-freitag.pdf -

programme-a6-mittwoch.pdf: cropped.pdf
	gs -sOutputFile=$@ -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dFirstPage=14 -dLastPage=16 $<

programme-a6-donnerstag.pdf: cropped.pdf
	gs -sOutputFile=$@ -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dFirstPage=30 -dLastPage=33 $<

programme-a6-freitag.pdf: cropped.pdf
	gs -sOutputFile=$@ -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dFirstPage=54 -dLastPage=55 $<

cropped.pdf: master.pdf
	gs -o cropped.pdf -sDEVICE=pdfwrite -c "[/CropBox [28.3464 28.3464 325.9836 447.87312]" -c " /PAGES pdfmark" -dPDFSETTINGS=/prepress -f master.pdf

cropped: cropped.pdf
