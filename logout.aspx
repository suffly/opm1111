<%@ Page Language="VB" %>
<script runat="server">
	Sub Page_Load(sender As Object, e As EventArgs)
		Session.Abandon()
		Response.Redirect("index.aspx")
    End Sub
</script>
<html>
<head>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        
    </form>
</body>
</html>
