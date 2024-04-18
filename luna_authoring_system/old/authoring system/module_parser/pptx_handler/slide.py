class Slide:
    def __init__(self, slide_number, title=None, notes=None, clickable_text=None, elements=None):
       self.slide_number = slide_number
       self.title = title
       self.notes = notes
       self.clickable_text = clickable_text or []
       self.elements = elements or []

    def add_element(self, element):
        # print(f"Adding element to slide {self.slide_number}: {element.to_dict()}")
        self.elements.append(element)

    def to_dict(self):
        return {
            'slide_number': self.slide_number,
            'title': self.title,
            'notes': self.notes,
            'clickable_text': self.clickable_text,
            'elements': [element.to_dict() for element in self.elements]
        }
