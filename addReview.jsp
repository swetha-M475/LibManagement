<%@ page import="java.io.*,javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.DOMSource,javax.xml.transform.stream.StreamResult" %>
<%
  String bookName = request.getParameter("book");
  String user = request.getParameter("user");
  String rating = request.getParameter("rating");
  String comment = request.getParameter("comment");


  String filePath = application.getRealPath("/reviews.xml");

  try {
    File xmlFile = new File(filePath);
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    Document doc;

    if (xmlFile.exists()) {
      doc = builder.parse(xmlFile);
      doc.getDocumentElement().normalize();
    } else {
      doc = builder.newDocument();
      Element root = doc.createElement("reviews");
      doc.appendChild(root);
    }

  
    NodeList books = doc.getElementsByTagName("book");
    Element targetBook = null;

    for (int i = 0; i < books.getLength(); i++) {
      Element b = (Element) books.item(i);
      if (b.getAttribute("name").equals(bookName)) {
        targetBook = b;
        break;
      }
    }

    if (targetBook == null) {
      targetBook = doc.createElement("book");
      targetBook.setAttribute("name", bookName);
      doc.getDocumentElement().appendChild(targetBook);
    }

    
    Element review = doc.createElement("review");
    review.setAttribute("user", user);
    review.setAttribute("rating", rating);
    review.setTextContent(comment);
    targetBook.appendChild(review);

    
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
    transformer.transform(new DOMSource(doc), new StreamResult(xmlFile));

    out.println("Review added successfully!");
  } catch (Exception e) {
    e.printStackTrace();
    out.println("Error: " + e.getMessage());
  }
%>
