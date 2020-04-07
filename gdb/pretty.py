# afficheur dedié pour les points
class PointPrinter(object):
    def __init__(self, val):
        self.val = val
    def to_string(self):
        return ("("+str(self.val["x"])+", "+str(self.val["y"])+")")

def Point_lookup(val):
    if str(val.type) == 'Type point':
        return PointPrinter(val)
    return None

gdb.pretty_printers.append(Point_lookup)

# afficheur dedié pour les triangles
class TrianglePrinter(object):
    def __init__(self, val):
            self.val = val
    def to_string(self):
        return "".join(map((lambda x : str(self.val["t"][x]["index"])+" "), [1, 2, 3]))

def Triangle_lookup(val):
    if str(val.type) == 'Type triangle':
        return TrianglePrinter(val)
    return None

gdb.pretty_printers.append(Triangle_lookup)
