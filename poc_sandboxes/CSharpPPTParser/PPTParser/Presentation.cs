using System.Xml.Linq;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Presentation;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;


namespace LunaPresentationParser
{
   public class Presentation : IDisposable
   {
      private PresentationDocument _presentation;


      public Presentation(String filepath)
      {
         _presentation = PresentationDocument.Open(filepath, false);
      }

      public void Dispose()
      {
         _presentation.Dispose();

      }

      public int SlideCount
      {
         get
         {
            PresentationPart? part = _presentation.PresentationPart;
            OpenXmlElementList slideIds = part?.Presentation?.SlideIdList?.ChildElements ?? default;
            return slideIds.Count;
         }
      }

      public SlidePart GetSlide(int index)
      {
         PresentationPart? part = _presentation.PresentationPart;
         OpenXmlElementList slideIds = part?.Presentation?.SlideIdList?.ChildElements ?? default;

         string? relId = ((SlideId)slideIds[index]).RelationshipId;
         return (SlidePart)part.GetPartById(relId);
      }

      public string getSlideJSON(SlidePart slide)
      {
         XDocument xmlDoc = XDocument.Parse(slide.Slide.OuterXml);
         //RemoveNamespaces(xmlDoc.Root);
         //string jsonString = JsonConvert.SerializeXNode(xmlDoc, Formatting.Indented, omitRootObject: true);
         string jsonString = JsonConvert.SerializeXNode(xmlDoc, Formatting.Indented);
         return jsonString;
      }

      public string getSlideJSON(int slideIndex)
      {
         return getSlideJSON(GetSlide(slideIndex));
      }

      public ShapeTree getSlideShapeTree(SlidePart slide)
      {
         var slideChildren = slide.Slide.Descendants();
         return slide.Slide.CommonSlideData.ShapeTree;
      }

      public void serializeShapeTree(ShapeTree tree)
      {
         foreach (var shape in tree.Descendants<Shape>())
         {
            string name = shape.LocalName;
            string json = JsonConvert.SerializeObject(shape);
         }
      }

      private static void RemoveNamespaces(XElement element)
      {
         // Remove namespaces from the current element
         element.Name = element.Name.LocalName;

         // Remove namespaces from child elements recursively
         foreach (var child in element.Elements())
         {
            RemoveNamespaces(child);
         }
      }
   }
}



