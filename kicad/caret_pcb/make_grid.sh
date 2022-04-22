#!/bin/bash


mkdir -p build
./panelize.py caret_pcb.kicad_pcb "build/test.kicad_pcb"

./python/bin/kikit panelize \
    --layout 'grid; rows: 1; cols: 3; space: 2mm' \
    --tabs 'fixed; width: 3mm; vcount: 3; hcount: 3' \
    --cuts 'mousebites; drill: 0.5mm; spacing: 1mm; offset: 0.2mm; prolong: 0.5mm' \
    --framing 'frame; width: 5mm; space: 2mm; cuts: both' \
    --post 'millradius: 1mm' \
    build/test.kicad_pcb build/panel.kicad_pcb

./python/bin/kikit fab oshpark --no-drc  build/panel.kicad_pcb build/pcb_set

