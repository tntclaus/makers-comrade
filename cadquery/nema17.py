from typing import Optional, Dict, Any

from cadquery import Workplane, Color, Location
from cadquery.assembly import Assembly, AssemblyObjects

from part import Part, PartExportType, PartObjects, BOM


class NemaMotor(Part):
    width: float  # ! Width of the square face
    length: float  # ! Body length

    radius: float  # ! End cap radius
    body_radius: float  # ! Body radius
    boss_radius: float  # ! Boss around the spindle radius
    boss_height: float  # ! Boss height
    shaft_dia: float  # ! Shaft diameter
    shaft_length: float  # ! Shaft length above the face, if a list then a leadscrew: length, lead, starts
    hole_pitch: float  # ! Screw hole pitch
    cap_heights: (float, float)  # ! Height of the end cap at the corner and the side

    holes: (float, float)  # ! Screw positions for for loop
    big_hole: float  # ! Clearance hole for the big boss

    def draw_part(self) -> PartObjects:
        middle_height = self.height - 10
        edge_shape_top_height = self.cap_heights[0]
        edge_shape_bottom_height = self.cap_heights[1]

        edge_offset_top = edge_shape_top_height / 2 + middle_height / 2
        edge_offset_bottom = edge_shape_bottom_height / 2 + middle_height / 2

        bottom_shape = (Workplane("XY")
                        .box(self.width, self.width, edge_shape_bottom_height)
                        .intersect(Workplane("XY").cylinder(height=edge_shape_bottom_height, radius=self.radius)))

        top_shape = (Workplane("XY")
                     .box(self.width, self.width, edge_shape_top_height)
                     .tag("top")
                     .intersect(Workplane("XY").cylinder(height=edge_shape_top_height, radius=self.radius))
                     .faces(">Z").workplane()
                     .rect(xLen=self.hole_pitch, yLen=self.hole_pitch, forConstruction=True)
                     .vertices()
                     .cboreHole(cboreDiameter=3, diameter=3, cboreDepth=5)
                     .add(Workplane("XY")
                          .cylinder(height=self.shaft_length,
                                    radius=self.shaft_dia / 2)
                          .translate((0, 0, self.shaft_length / 2 + edge_shape_top_height / 2))
                          )
                     .add(Workplane("XY")
                          .cylinder(height=self.boss_height,
                                    radius=self.boss_radius)
                          .translate((0, 0, self.boss_height / 2 + edge_shape_top_height / 2))
                          )
                     )

        part = (Workplane("XY")
                .box(self.width, self.width, middle_height)
                .intersect(Workplane("XY").cylinder(height=middle_height, radius=self.body_radius))
                )
        return (Assembly(part.tag("body"), color=Color("black"))
                .add(top_shape.translate((0, 0, edge_offset_top)), color=Color("lightsteelblue"))
                .add(bottom_shape.translate((0, 0, -edge_offset_bottom)), color=Color("lightsteelblue"))
                )

    def __init__(
            self,
            name: str,
            model: str,
            width: float,
            height: float,
            radius: float,
            body_radius: float,
            boss_radius: float,
            boss_height: float,
            shaft_dia: float,
            shaft_length: float,
            hole_pitch: float,
            cap_heights: (float, float),
            obj: AssemblyObjects = None,
            loc: Optional[Location] = None,
            color: Optional[Color] = None,
            metadata: Optional[Dict[str, Any]] = None,
    ):
        self.width = width
        self.height = height

        self.radius = radius
        self.body_radius = body_radius
        self.boss_radius = boss_radius
        self.boss_height = boss_height
        self.shaft_dia = shaft_dia
        self.shaft_length = shaft_length
        self.hole_pitch = hole_pitch
        self.cap_heights = cap_heights

        self.holes = (-self.hole_pitch / 2, self.hole_pitch / 2)
        self.big_hole = self.boss_radius + 0.2

        super().__init__(
            name=name,
            model=model,
            export_type=PartExportType.VITAMIN,
            obj=obj,
            loc=loc,
            color=color,
            metadata=metadata)

    def _copy(self) -> Assembly:
        """
                Make a deep copy of an assembly
                """
        BOM().add_to_bom(self)

        rv = self.__class__(
            model=self.model,
            width=self.width,
            height=self.height,
            radius=self.radius,
            body_radius=self.body_radius,
            boss_radius=self.boss_radius,
            boss_height=self.boss_height,
            shaft_dia=self.shaft_dia,
            shaft_length=self.shaft_length,
            hole_pitch=self.hole_pitch,
            cap_heights=self.cap_heights,
            obj=self.obj,
            loc=self.loc,
            name=self.name,
            color=self.color,
            metadata=self.metadata)

        for ch in self.children:
            ch_copy = ch._copy()
            ch_copy.parent = rv

            rv.children.append(ch_copy)
            rv.objects[ch_copy.name] = ch_copy
            rv.objects.update(ch_copy.objects)

        return rv


class Nema17(NemaMotor):
    def __init__(
            self,
            name: str,
            model: str,
            height: float,
            shaft_dia: float,
            shaft_length: float,
            cap_heights: (float, float),
            obj: AssemblyObjects = None, loc: Optional[Location] = None,
            color: Optional[Color] = None, metadata: Optional[Dict[str, Any]] = None):
        super().__init__(
            model=model,
            width=42.3,
            height=height,
            radius=53.6 / 2,
            body_radius=25,
            boss_radius=11,
            boss_height=2,
            shaft_dia=shaft_dia,
            shaft_length=shaft_length,
            hole_pitch=31,
            cap_heights=cap_heights,
            obj=obj,
            loc=loc,
            name=name,
            color=color,
            metadata=metadata
        )

    def _copy(self) -> Assembly:
        """
                Make a deep copy of an assembly
                """
        BOM().add_to_bom(self)

        rv = self.__class__(
            model=self.model,
            height=self.height,
            shaft_dia=self.shaft_dia,
            shaft_length=self.shaft_length,
            cap_heights=self.cap_heights,
            obj=self.obj,
            loc=self.loc,
            name=self.name,
            color=self.color,
            metadata=self.metadata)

        for ch in self.children:
            ch_copy = ch._copy()
            ch_copy.parent = rv

            rv.children.append(ch_copy)
            rv.objects[ch_copy.name] = ch_copy
            rv.objects.update(ch_copy.objects)

        return rv
