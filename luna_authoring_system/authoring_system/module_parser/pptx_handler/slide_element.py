from ...enums import ShapeType

class SlideElement:
    def __init__(self, type, text=None, text_properties=None, image_path=None, image_properties=None, position=None):
        self.type = type
        self.text = text
        self.text_properties = text_properties or {}
        self.image_path = image_path
        self.image_properties = image_properties or {}  
        self.position = position 

    def to_dict(self):
        element_dict = {
            'type': self.type,
            'position': self.position
        }

        if self.type == ShapeType.IMAGE.value:
            element_dict['image_path'] = self.image_path
            element_dict['image_properties'] = self.image_properties
        elif self.type == ShapeType.TEXT.value:
            element_dict['text'] = self.text
            element_dict['text_properties'] = self.text_properties

        return element_dict