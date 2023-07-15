import math
import pcbnew
import shutil


def copy_template():
    shutil.rmtree("../out/heater_pcb", ignore_errors=True)
    shutil.copytree("../kicad/heatbed_template", "../out/heater_pcb")
    shutil.move("../out/heater_pcb/heatbed_template.kicad_pcb", "../out/heater_pcb/heater_pcb.kicad_pcb")
    shutil.move("../out/heater_pcb/heatbed_template.kicad_prl", "../out/heater_pcb/heater_pcb.kicad_prl")
    shutil.move("../out/heater_pcb/heatbed_template.kicad_pro", "../out/heater_pcb/heater_pcb.kicad_pro")
    shutil.move("../out/heater_pcb/heatbed_template.kicad_sch", "../out/heater_pcb/heater_pcb.kicad_sch")

    for file in ["heater_pcb.kicad_pro", "heater_pcb.kicad_prl"]:
        with open(f"../out/heater_pcb/{file}", "rt") as fin:
            data = fin.read()
            data = data.replace('heatbed_template', 'heater_pcb')

        with open(f"../out/heater_pcb/{file}", "wt") as fin:
            fin.write(data)


class ResistiveMaterial:

    def __init__(self,
                 name: str,
                 density: float,
                 temperature_coefficient: float,
                 resistance_ref: float,
                 temperature_ref: float = 20,
                 ):
        """
        :param name: materials' common name.
        :param density: material density in g/cm2.
        :param temperature_coefficient:  “alpha” (α) constant, is known as the temperature coefficient of resistance and
         symbolizes the resistance change factor per degree of temperature change.
        :param resistance_ref: resistance at reference temperature, Ohm.
        :param temperature_ref: reference temperature in ºC, defaults to 20ºC.


        Temperature coefficients info:
        http://www.allaboutcircuits.com/textbook/direct-current/chpt-12/temperature-coefficient-resistance/
        Resistivity info:
        https://www.engineeringtoolbox.com/resistivity-conductivity-d_418.html

        """
        self.resistance_ref = resistance_ref
        self.temperature_ref = temperature_ref
        self.name = name
        self.density = density
        self.temperature_coefficient = temperature_coefficient

    def resistivity(self, temperature: float):
        return self.resistance_ref * (1 + self.temperature_coefficient * (temperature - self.temperature_ref))


COPPER = ResistiveMaterial("Copper", 8.96, 0.00429, 0.01724)
ALUMINIUM = ResistiveMaterial("Aluminium", 2.7, 0.0038, 0.0265)
# http://thermalinfo.ru/svojstva-materialov/metally-i-splavy/udelnoe-elektricheskoe-soprotivlenie-stali-pri-razlichnyh-temperaturah
MILD_STEEL = ResistiveMaterial("Mild steel", 7.85, 0.0066, 0.15)
# http://thermalinfo.ru/svojstva-materialov/metally-i-splavy/udelnoe-soprotivlenie-nihroma-plotnost-teploprovodnost-teploemkost
NICHROME = ResistiveMaterial("Nichrome", 8.96, 0.0004, 1.130)
CONSTANTAN = ResistiveMaterial("Constantan", 8.96, 0.0003, 0.49)


def make_point(x, y):
    return pcbnew.wxPointMM(x, y)


def generate_board(
        pcb_width: int,
        pcb_height: int,
        target_temperature: int = 100,
        copper_thickness: int = 0.035,
        voltage: int = 220,
        power_per_cm2: float = 500 / 900,
        border_offset: int = 10,
        is_ac=True,
):
    """
    :param pcb_width:
    :param pcb_height:
    :param voltage: input voltage
    :param power_per_cm2: desired output power
    :param target_temperature:
    :param copper_thickness:
    :param border_offset:
    :param is_ac: AC or DC current
    :return:
    """
    width = pcb_width - border_offset
    height = pcb_height - border_offset
    material = COPPER
    total_power = power_per_cm2 * width * height / 100

    # step for wires
    # magic parameter
    st = 1.11 * width / 300 * height / 300

    if int(height / st) % 2 == 0:
        height += st

    power = total_power

    total_current = power / voltage
    total_resistance = voltage / total_current

    # // Stainless ohm*mm^2/mm
    material_resistance = material.resistivity(target_temperature) / 1000
    # //    h=0.572727;			//Copper foil height

    track_total_length_mm = (width / st) * (height / st) * st

    # //r=(p*l)/s
    # //s=(p*l)/r

    track_cross_section = (material_resistance * track_total_length_mm) / total_resistance

    track_width = track_cross_section / copper_thickness

    print("P ", material_resistance, "micro ohm / mm")
    print("Power ", power, "VA")
    print("Voltage ", voltage, "V")
    print("Current ", total_current, "A")
    print("Resistance ", total_resistance, "ohm")
    print("Wire S ", track_cross_section, "mm2")
    print("Wire length ", track_total_length_mm, "mm")
    print("Wire width ", track_width, "mm")
    print("Wire height ", copper_thickness, "mm")
    print("Wire spacing ", st - track_width, "mm")
    print("Lines count ", height / st, "pcs")

    # seconds = 120
    # weight = 1000
    # heatCapacityAl = 0.900
    # heatCapacityH2O = 4.186
    # energy = power * seconds

    # temp = energy / weight / heatCapacityH2O

    # PCB
    board = pcbnew.LoadBoard("../out/heater_pcb/heater_pcb.kicad_pcb")
    _, net = board.GetNetsByName().items()[0]
    layer = pcbnew.F_Cu

    def make_track(start, end):
        tr = pcbnew.PCB_TRACK(board)
        tr.SetStart(start)
        tr.SetEnd(end)
        tr.SetWidth(int(track_width * pcbnew.IU_PER_MM))
        tr.SetLayer(layer)
        tr.SetNetCode(net.GetNetCode())
        board.Add(tr)

    left_border = int(border_offset / 2 + st)

    max_lines = int(height / (st / 2)) + 1

    footprint_start_point = make_point(border_offset-1, pcb_height / 2 - 3.5 / 2)
    footprint_center = make_point(border_offset, pcb_height / 2)
    footprint_end_point = make_point(border_offset+1.5, pcb_height / 2 + 3.5 / 2)
    start_point = make_point(border_offset / 2, pcb_height / 2 - 3.5 / 2)
    end_point = make_point(border_offset / 2, pcb_height / 2 + 3.5 / 2)

    first_point = make_point(border_offset / 2, border_offset / 2)
    last_point = make_point(border_offset / 2, (max_lines+1)/2*st)

    make_track(footprint_start_point, start_point)
    make_track(start_point, first_point)

    make_track(footprint_end_point, end_point)
    make_track(end_point, last_point)

    previous_point = first_point
    previous_horizontal = False

    for i in range(max_lines):
        prev_y_mm = previous_point.y / pcbnew.IU_PER_MM
        if pcb_height / 2 - 3.5 < prev_y_mm < pcb_height / 2 + 3.5:
            margin_left = left_border + border_offset
        else:
            margin_left = left_border

        # print(previous_horizontal)
        if i+1 == max_lines:
            next_point = last_point
        elif previous_horizontal:
            # print("Делаем вертикальную линию")
            next_point = make_point(
                int(previous_point.x / pcbnew.IU_PER_MM),
                previous_point.y / pcbnew.IU_PER_MM + st
            )
        else:
            # print("Делаем горизонтальную линию")
            prev_x = int(previous_point.x / pcbnew.IU_PER_MM)
            # print(prev_x, left_border)
            if prev_x == left_border or prev_x == border_offset / 2 or prev_x == margin_left:
                x = pcb_width - border_offset / 2
            else:
                x = margin_left

            next_point = make_point(x, previous_point.y / pcbnew.IU_PER_MM)

        # print(next_point)
        make_track(
            previous_point,
            next_point
        )

        previous_point = next_point
        previous_horizontal = not previous_horizontal

    # Connector
    footprints = board.GetFootprints()
    for f in footprints:
        fprtRef = f.GetReference()
        if fprtRef == "J1":
            refDes = board.FindFootprintByReference(fprtRef)
            refDes.SetPosition(footprint_center)
            refDes.SetOrientation(90 * 30)  # rotate by 90 deg

    # Board edges
    edge = pcbnew.PCB_SHAPE(board)
    edge.SetShape(pcbnew.SHAPE_T_RECT)
    edge.SetFilled(False)
    edge.SetStart(pcbnew.wxPointMM(0, 0))
    edge.SetEnd(pcbnew.wxPointMM(pcb_width, pcb_height))
    edge.SetLayer(pcbnew.Edge_Cuts)
    edge.SetWidth(int(0.1 * pcbnew.IU_PER_MM))
    board.Add(edge)

    # fill zones
    points = (pcbnew.wxPointMM(border_offset / 8, border_offset / 8),
              pcbnew.wxPointMM(pcb_width - border_offset / 8, border_offset / 8),
              pcbnew.wxPointMM(pcb_width - border_offset / 8, pcb_height - border_offset / 8),
              pcbnew.wxPointMM(border_offset / 8, pcb_height - border_offset / 8)
              )

    zone = pcbnew.ZONE(board)
    zone.SetLayer(pcbnew.F_Cu)
    zone.AddPolygon(pcbnew.wxPoint_Vector(points))
    board.Add(zone)
    filler = pcbnew.ZONE_FILLER(board)
    zones = board.Zones()
    filler.Fill(zones)

    pcbnew.SaveBoard(board.GetFileName(), board)


copy_template()
generate_board(310, 310)
