import abc
from typing import Union, Optional, List, Dict, Any, overload, Tuple, Iterator, cast
from enum import Enum

from cadquery import Assembly
from cadquery.assembly import Assembly, AssemblyObjects, Color, Location


class PartExportType(Enum):
    ASSEMBLY = 1
    VITAMIN = 2
    STL = 3
    DXF = 4


PartObjects = Union[Assembly, AssemblyObjects, None]


class Part(Assembly):
    model: str
    export_type: PartExportType

    @classmethod
    def load(cls, path: str) -> "Part":
        pass

    def __init__(
            self,
            name: str,
            model: str,
            export_type: PartExportType,
            obj: AssemblyObjects = None,
            loc: Optional[Location] = None,
            color: Optional[Color] = None,
            metadata: Optional[Dict[str, Any]] = None, ):
        super().__init__(
            obj=obj,
            loc=loc,
            name=name,
            color=color,
            metadata=metadata
        )
        self.export_type = export_type
        self.model = model

        part_objects = self.draw_part()
        if isinstance(part_objects, Assembly):
            self.add(part_objects)
        else:
            self.obj = part_objects

    def _copy(self) -> Assembly:
        BOM().add_to_bom(self)
        return self

    @abc.abstractmethod
    def draw_part(self) -> PartObjects:
        return


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class BOM(metaclass=Singleton):
    parts: list[Part] = list()

    def add_to_bom(self, part: Part):
        # print("Added to bom: ", part.name)
        self.parts.append(part)
