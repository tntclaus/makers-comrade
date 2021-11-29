import ezdxf
import math
import sys

import json

# Opening JSON file
f = open('bom/bom.json')
bom = json.load(f)

overall_length = 0
overall_price = 0

CUT_PRICE_STEEL = 50
CUT_PRICE_D16 = 150

for dxf in bom['routed']:
    # print(dxf)
    dxf_count = bom['routed'][dxf]['count']


    dwg = ezdxf.readfile("dxfs/"+dxf)
    msp = dwg.modelspace()
    longitud_total = 0
    for e in msp:
    #    print(e)
        if e.dxftype() == 'LINE':
            dl = math.sqrt((e.dxf.start[0]-e.dxf.end[0])**2 + (e.dxf.start[1]-
            e.dxf.end[1])**2)
    #        print('linea: '+str(dl))
            longitud_total = longitud_total + dl
        elif e.dxftype() == 'CIRCLE':
            dc = 2*math.pi*e.dxf.radius
    #        print('radio: '+str(e.dxf.radius))
    #        print('circulo: '+str(dc))
            longitud_total = longitud_total + dc
        elif e.dxftype() == 'SPLINE':
            puntos = e.get_control_points()
            for i in range(len(puntos)-1):
                ds = math.sqrt((puntos[i][0]-puntos[i+1][0])**2 + (puntos[i][1]-
                puntos[i+1][1])**2)
    #            print('curva: '+str(ds))
                longitud_total = longitud_total + ds

    cut_price = 50
    if(dxf.startswith("STEEL")):
        cut_price = CUT_PRICE_STEEL
    if(dxf.startswith("D16")):
        cut_price = CUT_PRICE_D16

    bom['routed'][dxf]['price'] = round(longitud_total/1000 * cut_price, 2)
    print(
        'Total Length of ' + dxf + ': ' +
        str(round(longitud_total * dxf_count,2)) +
        'mm (' + str(dxf_count) + ' pcs), price per pcs: ' + str(bom['routed'][dxf]['price']))
    overall_length += longitud_total * dxf_count
    overall_price += bom['routed'][dxf]['price'] * dxf_count

print('Overall length = ' + str(round(overall_length/1000, 2)) + ' m')
print('Approx laser cut price = ' + str(overall_price) + ' RUB')
