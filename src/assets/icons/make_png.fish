for input in (ls *.svg)
  set output (path change-extension .png $input)
  inkscape -w 540 -h 540 ./$input -o ./$output
end