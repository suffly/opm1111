<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Net" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Page Language="VB" ContentType="text/html" %>

<script runat="server">

    Sub Page_Load(sender As Object, e As EventArgs)

        Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
        End If

        BindData()

    End Sub

    Sub BindData()
        'Dim objConn As MySqlConnection
        'Dim objCmd As MySqlCommand
        'Dim dtReader As MySqlDataReader
        'Dim ds1, ds2 As New DataSet

        'Dim strConnString, strSQL, strSQL2 As String
        'strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        'objConn = New MySqlConnection(strConnString)
        'objConn.Open()

        'strSQL = "SELECT distinct"
        'strSQL = strSQL & " case_operating.case_code,"
        'strSQL = strSQL & " case_operating.status_name,"
        'strSQL = strSQL & " case_operating.case_type,"
        'strSQL = strSQL & " case_operating.updated"
        'strSQL = strSQL & " FROM"
        'strSQL = strSQL & " case_operating"
        'strSQL = strSQL & " where case_code ='" & Decrypt(Request.QueryString("case_code")) & "'"

        'objCmd = New MySql.Data.MySqlClient.MySqlCommand(strSQL, objConn)
        'dtReader = objCmd.ExecuteReader()

        Dim token As String = "67E34BD8B0EC44A6B815A8B3D4B81208"
        Dim casecode As String = Decrypt(Request.QueryString("case_code"))
        Dim url As String = "http://180.180.244.31/opm1111/getcasedetail.aspx?api=getcase&token=" & token & "&casecode=" & casecode
        Dim client As WebClient = New WebClient()
        client.Encoding = Encoding.UTF8

        Dim json As String = client.DownloadString(url)

        Dim dt As DataTable = JsonConvert.DeserializeObject(Of DataTable)(json)

        listview1.DataSource = dt
        listview1.DataBind()
        'dtReader.Close()
        'dtReader = Nothing

        'strSQL2 = "SELECT * from case_operating where case_code ='" & Decrypt(Request.QueryString("case_code")) & "' order by create_date"
        'objCmd = New MySql.Data.MySqlClient.MySqlCommand(strSQL2, objConn)
        'dtReader = objCmd.ExecuteReader()

        'listview2.DataSource = dt2
        'listview2.DataBind()

        'dtReader.Close()
        'dtReader = Nothing
        'objConn.Close()
        'objConn = Nothing

        BindOperating()
    End Sub

    Sub BindOperating()

        Dim token As String = "67E34BD8B0EC44A6B815A8B3D4B81208"
        Dim casecode As String = Decrypt(Request.QueryString("case_code"))
        Dim url As String = "http://180.180.244.31/opm1111/getcasedetail.aspx?api=getoperating&token=" & token & "&casecode=" & casecode
        Dim client As WebClient = New WebClient()
        client.Encoding = Encoding.UTF8

        Dim json As String = client.DownloadString(url)

        Dim dt As DataTable = JsonConvert.DeserializeObject(Of DataTable)(json)
        listview2.DataSource = dt
        listview2.DataBind()

    End Sub

    Private Function Decrypt(cipherText As String) As String
        Dim EncryptionKey As String = "GECC2565"
        cipherText = cipherText.Replace(" ", "+")
        Dim cipherBytes As Byte() = Convert.FromBase64String(cipherText)
        Using encryptor As Aes = Aes.Create()
            Dim pdb As New Rfc2898DeriveBytes(EncryptionKey, New Byte() {&H49, &H76, &H61, &H6E, &H20, &H4D,
             &H65, &H64, &H76, &H65, &H64, &H65,
             &H76})
            encryptor.Key = pdb.GetBytes(32)
            encryptor.IV = pdb.GetBytes(16)
            Using ms As New MemoryStream()
                Using cs As New CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write)
                    cs.Write(cipherBytes, 0, cipherBytes.Length)
                    cs.Close()
                End Using
                cipherText = Encoding.Unicode.GetString(ms.ToArray())
            End Using
        End Using
        Return cipherText
    End Function

    Private Function Encrypt(clearText As String) As String
        Dim EncryptionKey As String = "GECC2565"
        Dim clearBytes As Byte() = Encoding.Unicode.GetBytes(clearText)
        Using encryptor As Aes = Aes.Create()
            Dim pdb As New Rfc2898DeriveBytes(EncryptionKey, New Byte() {&H49, &H76, &H61, &H6E, &H20, &H4D,
             &H65, &H64, &H76, &H65, &H64, &H65,
             &H76})
            encryptor.Key = pdb.GetBytes(32)
            encryptor.IV = pdb.GetBytes(16)
            Using ms As New MemoryStream()
                Using cs As New CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write)
                    cs.Write(clearBytes, 0, clearBytes.Length)
                    cs.Close()
                End Using
                clearText = Convert.ToBase64String(ms.ToArray())
            End Using
        End Using
        Return clearText
    End Function



	</script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
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

    <!--Loading Screen-->
        <script>
            $(document).ready(function () {
                $("#progressbar1").hide();
            });

        </script>

    <script type="text/javascript">
        window.onbeforeunload = function () {
            $("#progressbar1").show();
        };
    </script>
    <!--Loading Screen-->


</head>
<body>
    <form id="form1" runat="server">

            <!-- Header  -->
        <inc1:MyUserControl id="Header2" runat="server" />
        <!-- Header  -->

 <div class="progress" id="progressbar1" >
  <div class="progress-bar progress-bar-striped progress-bar-animated"  role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%"></div>
</div>

    <!-- Content-->         
         <div class="card text-dark bg-white mx-auto col-lg-7 col-sm-12 border-primary">
              
             <div class="card-header bg-success">
     <div class="d-flex justify-content-between">
            <h2><i class="bi bi-journal-text"></i> การดำเนินการ</h2>
                </div>
  </div>
  <div class="card-body">

      <asp:DataList runat="server" ID="listview1">
          <ItemTemplate>
  <div class="d-flex"><h6>รหัสเรื่อง : &nbsp;</h6><%# Eval("casecode") %></div>
    <div class="d-flex"><h6>ประเภทเรื่อง : &nbsp;</h6><%# Eval("casetype") %></div>
      <div class="d-flex"><h6>สถานะเรื่อง : &nbsp;</h6><%# Eval("statusname") %>&nbsp;<h6>ปรับปรุงล่าสุดเมื่อวันที่ :&nbsp; </h6><%# Eval("update_date") %></div>
   <div class="d-flex"><h6>สรุปผลการพิจารณา : &nbsp;</h6><%# Eval("summaryresult") %></div>
              </ItemTemplate>
      </asp:DataList>

   <div class="container mt-6 mb-3 ">
	<div class="row">
		<div class="col-md-12">
			<ul class="timeline">
                <asp:Repeater id="listview2" runat="server">
                    <ItemTemplate>
				<li>
					วันที่ &nbsp;<%#FormatDateTime(Eval("create_date"), 1) %>
					<p class="text-primary"><%# Eval("create_by") %>&nbsp; <%# Eval("oper_type") %>&nbsp;<%# Eval("receiver_by") %>&nbsp;<%# Eval("oper_objective") %></p>
                    <p><%# Eval("detail") %></p>
				</li>
            </ItemTemplate>
	        </asp:Repeater>
			</ul>
		</div>
	</div>
</div>

      </div>
             </div>

<!-- End Content -->



                <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
             <!-- Footer  -->

        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
