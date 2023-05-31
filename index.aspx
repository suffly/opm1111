<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
<%@ Page Language="VB" ContentType="text/html" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>

<script runat="server">

    Sub login_OnClick(sender As Object, e As EventArgs)

        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable


        Dim strConnString, strSQL, strSQL4 As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT gid, grole,gemail FROM Gmember WHERE gemail = '"& request.Form("gemail") &"' and gpassword='" & request.Form("gpassword") & "' "
        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        If dt.Rows.Count <> 0 Then
            Session("strUser") = request.Form("gemail")
            Session("strRole") = dt.Rows(0)("Grole").ToString
            Session("strGID") = dt.Rows(0)("Gid").ToString

            '#############ตรวจสอบ IPaddress และ session################
            Dim strSession, strIPaddress As String
            strSession = HttpContext.Current.Session.SessionID
            strIPaddress = Request.ServerVariables("HTTP_X_FORWARDED_FOR")

            If strIPaddress = "" Or strIPaddress Is Nothing Then
                strIPaddress = Request.ServerVariables("REMOTE_ADDR")
            End If


            '############Keep Log################

            strSQL4 = "insert into user_log(SessionID, IPaddress, Gid) values('" & strSession & "', '" & strIPaddress & "', " & Session("strGID") & ")"


            Dim objCmd = New MySqlCommand()
            With objCmd
                .Connection = objConn
                .CommandType = CommandType.Text
                .CommandText = strSQL4
            End With

            objCmd.ExecuteNonQuery()
            objCmd = Nothing

            dtAdapter = Nothing

            objConn.Close()
            objConn = Nothing


            '############Login Complete################

            Response.Redirect("case.aspx")

        Else

            dtAdapter = Nothing

            objConn.Close()
            objConn = Nothing

            Me.lbLogin.Visible = True
            Me.lbLogin.Text = "อีเมล์หรือรหัสผ่านไม่ถูกต้อง โปรดลองใหม่อีกครั้ง"
        End If

    End Sub


</script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%--Change Logo and title--%>
    <link rel="shortcut icon" href="images/c4mlogo.png" type="image/png" />
    <title> C4M </title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap.css" rel="stylesheet">

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style1.css">

    <!-- Jquery -->
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>

       <!-- Icon-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">


</head>
<body>
    <form id="form1" runat="server">

         <!-- Header  -->
        <inc1:MyUserControl id="Header2" runat="server" />
        <!-- Header  -->

    
    <!-- Login -->
        <br /><br /><br /> <br /><br /><br /> 

    <div id="login1" class="col d-flex justify-content-center ">

        <div class="card border-primary col-xs-12 col-md-3">
         <div class="card-header">Login</div>
        <div class="card-body">
          <div class="form-group align-content-center">
  		<label for="gemail">อีเมล :</label>
 				<asp:TextBox ID="gemail" runat="server"   CssClass="form-control" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFVgemail" runat="server" ErrorMessage="โปรดระบุ" ControlToValidate="gemail" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
      </div>

  <div class="form-group align-content-center mt-2">
  		<label for="gpassword">รหัสผ่าน :</label>
             <asp:TextBox ID="gpassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
              <asp:RequiredFieldValidator ID="RFVgpassword" runat="server" ErrorMessage="โปรดระบุ" ControlToValidate="gpassword" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
	</div>
            </div>

             <div class="card-footer">
                 <div class="align-content-center mt-2"><asp:Button ID="login" runat="server" Text="เข้าสู่ระบบ" OnClick="login_onClick" CssClass="btn btn-info btn-md" />                
     </div>
  <div>
       <asp:Label ID="lbLogin" runat="server" ForeColor="#FF0000"></asp:Label>
   </div>
  </div>
        </div>
  
    </div>
        <br /><br /><br /> <br /><br /><br /> 

              <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
             <!-- Footer  -->

        

<script src="bootstrap.bundle.min.js"></script>


</form>
</body>
</html>
