./big_mm_switch $1/bundler.mm $1/bundler.switch
mv mm.png $1/bundler.png
./big_mm_noswitch $1/nobundler.mm
mv mm.png $1/nobundler.png
./big_fct $1/fcts.data
rm Rplots.pdf
