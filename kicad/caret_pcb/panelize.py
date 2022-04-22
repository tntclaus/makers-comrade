#!/Applications/Kicad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3

from kikit import panelize
import shapely
import pcbnew
from kikit.panelize_ui import Section
from kikit.units import mm
from pcbnew import LoadBoard
from kikit.panelize import Panel, extractSourceAreaByAnnotation, expandRect
import kikit.panelize_ui_impl as ki

import sys

input = sys.argv[1]
output = sys.argv[2]

tabWidth = panelize.fromMm(65)
slotWidth = panelize.fromMm(2.5)

panelRampsOrigin = pcbnew.wxPointMM(20, 42)
panelCaretOrigin = pcbnew.wxPointMM(46, 24)
panelRPiOrigin = pcbnew.wxPointMM(20, 119)

# from kikit.common import fakeKiCADGui
#
# app = fakeKiCADGui()

board = LoadBoard(input)

panel = Panel(output)
panel.inheritDesignSettings(board)
panel.inheritProperties(board)
panel.inheritTitleBlock(board)
panel.inheritPageSize(board)
panel.inheritCopperLayers(board)

# ramps_source = Section()
ramps_source = {"type": "rectangle", "tlx": "20mm", "tly": "42mm", "brx": "43mm", "bry": "118mm"}
caret_source = {"type": "rectangle", "tlx": "46mm", "tly": "24mm", "brx": "77mm", "bry": "118mm"}
rpi_source = {"type": "rectangle", "tlx": "20mm", "tly": "119mm", "brx": "77mm", "bry": "185mm"}


def pcb_source_area(source):
    preset = ki.obtainPreset([], validate=False, source=source, page=None)
    return ki.readSourceArea(preset["source"], board)


pos1 = panel.appendBoard(input,
                         panelRampsOrigin,
                         sourceArea=pcb_source_area(ramps_source),
                         origin=panelize.Origin.TopLeft)

pos2 = panel.appendBoard(input,
                         panelCaretOrigin,
                         sourceArea=pcb_source_area(caret_source),
                         origin=panelize.Origin.TopLeft)

pos3 = panel.appendBoard(input,
                         panelRPiOrigin,
                         sourceArea=pcb_source_area(rpi_source),
                         # shrink=True,
                         origin=panelize.Origin.TopLeft)

panel.buildPartitionLineFromBB()
panel.buildTabAnnotationsFixed(2, 2, 3 * mm, 3 * mm, 20 * mm, [])
cuts = panel.buildTabsFromAnnotations()

panel.makeMouseBites(cuts, diameter=panelize.fromMm(0.5), spacing=panelize.fromMm(1), offset=0.2 * mm)

panel.addMillFillets(panelize.fromMm(1))

panel.save()
