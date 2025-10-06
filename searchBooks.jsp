<%@ page import="javax.xml.parsers.*, org.w3c.dom.*, java.io.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    String query = request.getParameter("query");
    if (query == null) query = "";
    query = query.toLowerCase();

    File xmlFile = new File(application.getRealPath("books.xml"));
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    Document doc = builder.parse(xmlFile);
    doc.getDocumentElement().normalize();

    NodeList themeList = doc.getElementsByTagName("theme");

    StringBuilder json = new StringBuilder("[");
    boolean first = true;

    for (int i = 0; i < themeList.getLength(); i++) {
        Element theme = (Element) themeList.item(i);
        NodeList books = theme.getElementsByTagName("book");

        for (int j = 0; j < books.getLength(); j++) {
            Element book = (Element) books.item(j);

            String bname = book.getElementsByTagName("name").item(0).getTextContent();
            String author = book.getElementsByTagName("author").item(0).getTextContent();
            String price = book.getElementsByTagName("price").item(0).getTextContent();
            String discount = book.getElementsByTagName("discount").item(0).getTextContent();
            String img = book.getElementsByTagName("img").item(0).getTextContent();

            if (bname.toLowerCase().contains(query) || author.toLowerCase().contains(query)) {
                if (!first) json.append(",");
                json.append("{")
                    .append("\"name\":\"").append(bname).append("\",")
                    .append("\"author\":\"").append(author).append("\",")
                    .append("\"price\":").append(price).append(",")
                    .append("\"discount\":").append(discount).append(",")
                    .append("\"img\":\"").append(img).append("\"")
                    .append("}");
                first = false;
            }
        }
    }
    json.append("]");
    out.print(json.toString());
%>
