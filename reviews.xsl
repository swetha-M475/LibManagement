<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>Book Reviews</title>
        <style>
          body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #eef2f7;
            margin: 0;
            padding: 20px;
          }
          h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
          }
          .book-card {
            background: #ffffff;
            border-radius: 10px;
            padding: 20px;
            margin: 20px auto;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 80%;
          }
          .book-title {
            font-size: 22px;
            font-weight: bold;
            color: #2980b9;
            margin-bottom: 15px;
            border-bottom: 2px solid #2980b9;
            padding-bottom: 5px;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
          }
          th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
          }
          th {
            background-color: #3498db;
            color: white;
          }
          tr:nth-child(even) {
            background-color: #f9f9f9;
          }
          tr:hover {
            background-color: #f1f7ff;
          }
          .rating {
            color: #e67e22;
            font-weight: bold;
          }
          .no-review {
            color: #888;
            font-style: italic;
            padding: 10px;
          }
        </style>
      </head>
      <body>
        <h2> Book Reviews</h2>
        <xsl:for-each select="reviews/book">
          <div class="book-card">
            <div class="book-title">
              <xsl:value-of select="@name"/>
            </div>
            <xsl:choose>
              <xsl:when test="count(review) > 0">
                <table>
                  <tr>
                    <th>User</th>
                    <th>Rating</th>
                    <th>Comment</th>
                  </tr>
                  <xsl:for-each select="review">
                    <tr>
                      <td><xsl:value-of select="@user"/></td>
                      <td class="rating">⭐ <xsl:value-of select="@rating"/></td>
                      <td><xsl:value-of select="."/></td>
                    </tr>
                  </xsl:for-each>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <p class="no-review">No reviews yet</p>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>