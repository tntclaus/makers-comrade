import ezdxf
import math
import sys

dwg = ezdxf.readfile(sys.argv[1])
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


print('Total Length: '+ str(longitud_total))
