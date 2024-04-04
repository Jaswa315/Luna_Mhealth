using LunaPresentationParser;


Presentation myPresentation = new Presentation("Luna_sample_module.pptx");
var slide = myPresentation.GetSlide(1);
string json = myPresentation.getSlideJSON(slide);

for (int i = 0; i < myPresentation.SlideCount; i++)
{
   File.WriteAllText("output" + i + ".txt", myPresentation.getSlideJSON(i));
}


var tree = myPresentation.getSlideShapeTree(slide);

myPresentation.serializeShapeTree(tree);

myPresentation.Dispose();