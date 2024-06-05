// Static test data for JSON Utils Tests instead of using File IO and Authoring System Parsers to generate test data.
class JsonUtilsTestData {
  static Map<String, String> getJsonData() {
    return {
      "Empty": '''
{
  "presentation": {
    "type": "presentation",
    "moduleId": "113e1ab2-ef6e-437d-b4b2-ef8d84c258b0",
    "title": "PowerPoint Presentation",
    "language": "en-US",
    "author": "Wonwhoo A nah",
    "slideCount": 1,
    "section": {
      "Default Section": ["S256"]
    },
    "slides": [
      {
        "type": "slide",
        "slideId": "S256",
        "shapes": []
      }
    ]
  }
}
''',
      "HelloWorld": '''
{
  "presentation": {
    "type": "presentation",
    "moduleId": "e13b91dd-1774-42ca-88ae-a3ef6117924b",
    "title": "PowerPoint Presentation",
    "language": "en-US",
    "author": "Shaun Stangler",
    "slideCount": 1,
    "section": {
      "Default Section": ["S256"]
    },
    "slides": [
      {
        "type": "slide",
        "slideId": "S256",
        "shapes": [
          {
            "type": "textbox",
            "children": [
              {
                "type": "rectangle",
                "transform": {
                  "offset": {"x": 0.3486486220472441, "y": 0.26666666666666666},
                  "size": {"x": 0.2847973261154856, "y": 0.05385418489355497}
                },
                "children": []
              },
              {
                "type": "textbody",
                "wrap": "square",
                "paragraphs": [
                  {
                    "type": "paragraph",
                    "textgroups": [
                      {
                        "type": "text",
                        "uid": 1,
                        "italics": false,
                        "bold": false,
                        "underline": false,
                        "text": "Hello, World!"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
''',
      "Textboxes": '''
{
  "presentation": {
    "type": "presentation",
    "moduleId": "3124bbff-1bd1-4af5-9737-4a6e7deb5fbb",
    "title": "PowerPoint Presentation",
    "language": "en-US",
    "author": "Shaun Stangler",
    "slideCount": 1,
    "section": {
      "Default Section": ["S256"]
    },
    "slides": [
      {
        "type": "slide",
        "slideId": "S256",
        "shapes": [
          {
            "type": "textbox",
            "children": [
              {
                "type": "rectangle",
                "transform": {
                  "offset": {
                    "x": 0.3486486220472441,
                    "y": 0.26666666666666666
                  },
                  "size": {
                    "x": 0.2847973261154856,
                    "y": 0.05385418489355497
                  }
                },
                "children": []
              },
              {
                "type": "textbody",
                "wrap": "square",
                "paragraphs": [
                  {
                    "type": "paragraph",
                    "alignment": null,
                    "textgroups": [
                      {
                        "type": "text",
                        "uid": 1,
                        "italics": false,
                        "bold": false,
                        "underline": false,
                        "size": null,
                        "color": null,
                        "highlightcolor": null,
                        "text": "Thing1"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "type": "textbox",
            "children": [
              {
                "type": "rectangle",
                "transform": {
                  "offset": {
                    "x": 0.33839583333333334,
                    "y": 0.4730729075532225
                  },
                  "size": {
                    "x": 0.2847973261154856,
                    "y": 0.05385418489355497
                  }
                },
                "children": []
              },
              {
                "type": "textbody",
                "wrap": "square",
                "paragraphs": [
                  {
                    "type": "paragraph",
                    "alignment": null,
                    "textgroups": [
                      {
                        "type": "text",
                        "uid": 2,
                        "italics": false,
                        "bold": false,
                        "underline": false,
                        "size": null,
                        "color": null,
                        "highlightcolor": null,
                        "text": "Thing2"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "type": "textbox",
            "children": [
              {
                "type": "rectangle",
                "transform": {
                  "offset": {
                    "x": 0.3533194717847769,
                    "y": 0.7757802566345874
                  },
                  "size": {
                    "x": 0.2847973261154856,
                    "y": 0.05385418489355497
                  }
                },
                "children": []
              },
              {
                "type": "textbody",
                "wrap": "square",
                "paragraphs": [
                  {
                    "type": "paragraph",
                    "alignment": null,
                    "textgroups": [
                      {
                        "type": "text",
                        "uid": 3,
                        "italics": false,
                        "bold": false,
                        "underline": false,
                        "size": null,
                        "color": null,
                        "highlightcolor": null,
                        "text": "Thing3"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
''',
    };
  }
}
