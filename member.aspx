<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
<%@ Register Src="menu.ascx" TagName="MyUserControl" TagPrefix="inc3" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Page Language="VB" ContentType="text/html" %>

<script runat="server">

    Sub Page_Load(sender As Object, e As EventArgs)

        'Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
        End If

        If Not Page.IsPostBack() Then
            BindData()
            DropDownListRole()
        End If

    End Sub

    Sub DropDownListRole()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT * FROM system_role where enable='T'"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.grole
            .DataSource = dt
            .DataTextField = "role_name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        grole.Items.Insert(0, New ListItem("-- โปรดเลือกบทบาท --", "0"))
        grole.SelectedIndex = grole.Items.IndexOf(grole.Items.FindByValue(0))  '*** By DataValueField ***'

        '*** DropDownlist Create New User***'
        With Me.grole1
            .DataSource = dt
            .DataTextField = "role_name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        grole1.Items.Insert(0, New ListItem("-- โปรดเลือกบทบาท --", "0"))
        grole1.SelectedIndex = grole1.Items.IndexOf(grole1.Items.FindByValue(0))  '*** By DataValueField ***'

    End Sub

    Private Sub BindData(Optional ByVal searchName As String = Nothing, Optional ByVal searchSurname As String = Nothing, Optional ByVal searchUsername As String = Nothing)

        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT"
        strSQL = strSQL & " gmember.GID,"
        strSQL = strSQL & " gmember.GNAME,"
        strSQL = strSQL & " gmember.GSURNAME,"
        strSQL = strSQL & " gmember.GEMAIL,"
        strSQL = strSQL & " gmember.Gcreate_date,"
        strSQL = strSQL & " system_role.role_name"
        strSQL = strSQL & " FROM"
        strSQL = strSQL & " gmember"
        strSQL = strSQL & " LEFT OUTER JOIN system_role ON gmember.GROLE = system_role.id "
        strSQL = strSQL & " where genable='T' "
        If Not String.IsNullOrEmpty(searchName) Then
            strSQL = strSQL & " and gmember.GNAME like '%" & searchName & "%' "
        End If
        If Not String.IsNullOrEmpty(searchSurname) Then
            strSQL = strSQL & " and gmember.GSURNAME like '%" & searchSurname & "%' "
        End If
        If Not String.IsNullOrEmpty(searchUsername) Then
            strSQL = strSQL & " and gmember.Gemail like '%" & searchUsername & "%' "
        End If
        strSQL = strSQL & "order by gmember.gcreate_date desc"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        GridView1.DataSource = dt
        GridView1.DataBind()

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing
    End Sub

    Sub modDeleteCommand(ByVal sender As Object, ByVal e As EventArgs)
        Dim userID As String = (TryCast(sender, Button)).CommandArgument

        Dim objConn As MySqlConnection
        Dim strConnString, strSQL As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "update gmember set genable='F' WHERE GID = '" & userID & "'"

        Dim objCmd As MySqlCommand
        objCmd = New MySqlCommand(strSQL, objConn)
        objCmd.ExecuteNonQuery()

        BindData()

        objConn.Close()
        objConn = Nothing
    End Sub

    Sub newuser()

        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand
        Dim strConnString, strSQL As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        Dim intNumRows As Integer
        strSQL = "SELECT COUNT(*) FROM Gmember WHERE gemail = '" & gusername1.Text & "' "

        objCmd = New MySqlCommand(strSQL, objConn)
        intNumRows = objCmd.ExecuteScalar()

        If intNumRows > 0 Then

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal2", "CloseModal2();", True)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup4", "ShowPopup4();", True)

            objConn.Close()
            objConn = Nothing
        Else

            strSQL = "insert into gmember (gname, gsurname, grole, gemail, gpassword, gcreate_date, genable, gcreate_by) values ("
            strSQL = strSQL & "'" & Request.Form("gname1") & "', "
            strSQL = strSQL & "'" & Request.Form("gsurname1") & "', "
            strSQL = strSQL & "'" & Request.Form("grole1") & "', "
            strSQL = strSQL & "'" & Request.Form("gusername1") & "', "
            strSQL = strSQL & "'" & Request.Form("gpassword1") & "', "
            strSQL = strSQL & "'" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "', "
            strSQL = strSQL & "'T', "
            strSQL = strSQL & "'" & Session("strGID") & "'"
            strSQL = strSQL & ")"

            objCmd = New MySqlCommand(strSQL, objConn)
            objCmd.ExecuteNonQuery()

            objConn.Close()
            objConn = Nothing

            BindData()

            '##################Clear Field
            gname1.Text = ""
            gsurname1.Text = ""
            grole1.Text = "0"
            gusername1.Text = ""
            gpassword1.Text = ""
            grepassword1.Text = ""
            '##################Clear Field

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal2", "CloseModal2();", True)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup3", "ShowPopup3();", True)

        End If

    End Sub

    Sub UpdateData()
        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand
        Dim strConnString, strSQL As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "UPDATE gmember SET"
        strSQL = strSQL & " gname = '" & Request.Form("gname") & "'"
        strSQL = strSQL & ", gsurname = '" & Request.Form("gsurname") & "'"
        strSQL = strSQL & ", grole = '" & Request.Form("grole") & "'"
        strSQL = strSQL & ", gemail = '" & Request.Form("gusername") & "'"
        strSQL = strSQL & ", gpassword = '" & Request.Form("gpassword") & "'"
        strSQL = strSQL & ", gupdate_date = '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "' "
        strSQL = strSQL & ", gupdate_by = '" & Session("strGID") & "'"
        strSQL = strSQL & " WHERE gid = '" & Request.Form("gid") & "'"


        objCmd = New MySqlCommand(strSQL, objConn)
        With objCmd
            .Connection = objConn
            .CommandText = strSQL
            .CommandType = CommandType.Text
        End With

        objCmd.ExecuteNonQuery()

        objConn.Close()
        objConn = Nothing

        BindData()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal", "CloseModal();", True)

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup3", "ShowPopup3();", True)

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

    Protected Sub OnPreview(ByVal sender As Object, ByVal e As EventArgs)
        Dim userID As String = (TryCast(sender, Button)).CommandArgument

        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT * from gmember where gid='" & userID & "'"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        gid.Text = dt.Rows(0)("gid").ToString
        gname.Text = dt.Rows(0)("Gname").ToString
        gsurname.Text = dt.Rows(0)("Gsurname").ToString
        gusername.Text = dt.Rows(0)("Gemail").ToString
        gpassword.Text = dt.Rows(0)("Gpassword").ToString
        grepassword.Text = dt.Rows(0)("Gpassword").ToString
        grole.Text = dt.Rows(0)("Grole").ToString

        gpassword.Attributes("value") = gpassword.Text
        grepassword.Attributes("value") = gpassword.Text

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup", "ShowPopup();", True)

    End Sub

    Protected Sub Search(ByVal sender As Object, ByVal e As EventArgs)
        BindData(name.Text, surname.Text, username.Text)
    End Sub

    Protected Sub OnPageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        GridView1.PageIndex = e.NewPageIndex
        BindData(name.Text, surname.Text, username.Text)
    End Sub

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

        <script type="text/javascript">
            function ShowPopup() {
                $('#myModal').modal('show');
            };

            function ShowPopup3() {
                $('#myModal3').modal('show');
            };

            function ShowPopup4() {
                $('#myModal4').modal('show');
            };

            function CloseModal() {
                $('#myModal').modal('hide');
            }

            function CloseModal2() {
                $('#myModal2').modal('hide');
            }
        </script>

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
         <main class="container">
             <br />
        <div class="row">
    <div class="col-lg-3 col-sm-12">
        <inc3:MyUserControl id="Menu1" runat="server" />

    </div>


        <div class="col-lg-9 col-sm-12">

            <div class="card">
  <h5 class="card-header bg-info text-white">ข้อมูลผู้ใช้งาน</h5>
  <div class="card-body">

      

        <asp:UpdatePanel runat="server" ID="updatepanel1">
        <ContentTemplate>

            <div class="alert alert-primary" role="alert">
                <div class="row">
                    <div class="col">
                        <label for="name">ชื่อ:</label>
                      <asp:TextBox ID="name" runat="server" placeholder="" CssClass="form-control"/>
                        </div>
                    <div class="col">
                         <label for="surname">นามสกุล:</label>
                      <asp:TextBox ID="surname" runat="server" placeholder="" CssClass="form-control"/>
                        </div>
                    <div class="col">
                         <label for="username">Username:</label>
                      <asp:TextBox ID="username" runat="server" placeholder="" CssClass="form-control"/>
                        </div>
                    </div>
                <asp:Button runat="server" ID="btnSearch" Text="ค้นหา" CssClass="btn btn-info" OnClick="search" />
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#myModal2">เพิ่ม +</button>
            </div>

           <asp:GridView id="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="GID" CssClass="table table-hover table-bordered table-sm" PageSize="10" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom">

	<Columns>

	<asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
		<%# Container.DataItemIndex + 1 %>
		</ItemTemplate>
	</asp:TemplateField>

	<asp:TemplateField HeaderText="ชื่อ - นามสกุล" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-left">
		<ItemTemplate>
			<asp:Label id="lblName" runat="server" Text='<%# Eval("gname") %>'></asp:Label>
            <asp:Label id="lbSurname" runat="server" Text=' <%# Eval("gsurname") %>'></asp:Label>
		</ItemTemplate>
	</asp:TemplateField>

        <asp:TemplateField HeaderText="ชื่อผู้ใช้ (Username)" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
			<asp:Label id="lblUsername" runat="server" Text='<%# Eval("gemail") %>'></asp:Label>&nbsp;
		</ItemTemplate>
	</asp:TemplateField>

        <asp:TemplateField HeaderText="วันที่สร้าง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
			<asp:Label id="lbCreateDate" runat="server" Text='<%# Eval("gcreate_date") %>'></asp:Label>&nbsp;
		</ItemTemplate>
	</asp:TemplateField>

        <asp:TemplateField HeaderText="ดำเนินการ" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
			<asp:Button Text="แก้ไข" ID="btnPreview" runat="server" OnClick="OnPreview" CommandArgument='<%#Eval("GID")%>' CssClass="btn btn-info btn-sm" CausesValidation="false"  />
            <asp:Button Text="ลบ" ID="btnDelete" runat="server" OnClick="modDeleteCommand" CommandArgument='<%#Eval("GID")%>' CssClass="btn btn-danger btn-sm" CausesValidation="false" OnClientClick="if(!confirm('Are you sure?')) return false;"  />
		</ItemTemplate>
	</asp:TemplateField>

	
	</Columns>
</asp:GridView>

               
                     </ContentTemplate>
                  <Triggers>
        	<asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
        </Triggers>

    </asp:UpdatePanel>

          <!-- Modal Edit User-->
          <div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" >
  <div class="modal-dialog modal-md modal-dialog-scrollable">
    <div class="modal-content">

        <asp:UpdatePanel runat="server" ID="updatepanel2" UpdateMode="Always">
        <ContentTemplate>
      <div class="modal-header bg-info"><h3>แก้ไขข้อมูลผู้ใช้งาน</h3>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">

        <div class="container">

            <div class="row">
             <div class="col">
                 <div style="display:none;">
                 <asp:TextBox ID="gid" runat="server" CssClass="form-control" />
                 </div>

                  <label for="gname">ชื่อ:</label>
                  <asp:TextBox ID="gname" runat="server" placeholder="" CssClass="form-control"/>
                  <asp:RequiredFieldValidator ID="Vgname" runat="server" ControlToValidate="gname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
              </div>

                  <div class="col">
                  <label for="gsurname">นามสกุล:</label>
                  <asp:TextBox ID="gsurname" runat="server" placeholder="" CssClass="form-control" />
                  <asp:RequiredFieldValidator ID="Vgsurname" runat="server" ControlToValidate="gsurname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                  </div>
            </div>

            <div class="row">
                  <div class="col">
                  <label for="gusername">ชื่อผู้ใช้:</label>
                  <asp:TextBox ID="gusername" runat="server" placeholder="" CssClass="form-control" Enabled="false" />
                  <asp:RequiredFieldValidator ID="Vuser" runat="server" ControlToValidate="gusername" ErrorMessage="โปรดระบุ" Display="Dynamic" ValidationGroup="v2"></asp:RequiredFieldValidator>
                  </div>

                 <div class="col">
                  <label for="grole">สิทธิ์การใช้งาน:</label>
                <asp:DropDownList ID="grole" runat="server"  CssClass="form-group form-select"></asp:DropDownList>
                  <asp:CompareValidator ControlToValidate="grole" ID="Vgrole"  ErrorMessage="โปรดเลือกสิทธิ์การใช้งาน" runat="server" Display="Dynamic" Operator="NotEqual" ValueToCompare="0" Type="Integer" ForeColor="#FF0000" ValidationGroup="v2" />
                 </div>
            </div>

            <div class="row">
                  <div class="col">
                  <label for="gpassword">รหัสผ่าน:</label>
                  <asp:TextBox ID="gpassword" runat="server" TextMode="Password" CssClass="form-control col-6" />	
                  <asp:RequiredFieldValidator ID="Vpassword" runat="server" ControlToValidate="gpassword" ErrorMessage="โปรดระบุรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                  </div>
    
                  <div class="col">
                  <label for="grepassword">ยืนยันรหัสผ่าน:</label>
                  <asp:TextBox ID="grepassword" runat="server"  TextMode="Password" CssClass="form-control col-6"/>
                  <asp:RequiredFieldValidator ID="Vrepassword" runat="server" ControlToValidate="grepassword" ErrorMessage="โปรดยืนยันรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                  <asp:CompareValidator ID="REVrepassword" runat="server" ControlToCompare="gpassword" ControlToValidate="grepassword" ErrorMessage="การยืนยันรหัสผ่านไม่ถูกต้อง" Display="Dynamic" ForeColor="#FF0000"></asp:CompareValidator>
                  </div>
            </div>
            </div>           


      </div>
      <div class="modal-footer">
          <asp:Button ID="btn1" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-md" CausesValidation="true" OnClick="UpdateData" ValidationGroup="v2" />

          <button type="button" class="btn btn-dark" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
      
      </div>
                </ContentTemplate>
        </asp:UpdatePanel>
    </div>
  </div>
</div>
        <!-- Modal Edit User-->


          <!-- Modal newcase -->
        <div class="modal fade" id="myModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" >
  <div class="modal-dialog modal-md modal-dialog-scrollable">
    <div class="modal-content">
           <asp:UpdatePanel runat="server" ID="updatepanel3" UpdateMode="Always">
        <ContentTemplate>
      <div class="modal-header bg-primary"><h3>เพิ่มข้อมูลผู้ใช้งาน</h3>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">

        <div class="container">

            <div class="row">
                <div class="col">
                  <label for="gname1">ชื่อ:</label>
                  <asp:TextBox ID="gname1" runat="server" placeholder="" CssClass="form-control"/>
                  <asp:RequiredFieldValidator ID="Vgname1" runat="server" ControlToValidate="gname1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                     </div>

                  <div class="col">
                  <label for="gsurname1">นามสกุล:</label>
                  <asp:TextBox ID="gsurname1" runat="server" placeholder="" CssClass="form-control" />
                  <asp:RequiredFieldValidator ID="Vgsurname1" runat="server" ControlToValidate="gsurname1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                  </div>
            </div>

            <div class="row">
                  <div class="col">
                  <label for="gusername1">ชื่อผู้ใช้:</label>
                  <asp:TextBox ID="gusername1" runat="server" placeholder="" CssClass="form-control" Enabled="true" />
                  <asp:RequiredFieldValidator ID="Vgusername1" runat="server" ControlToValidate="gusername1" ErrorMessage="โปรดระบุ" Display="Dynamic" ValidationGroup="v1" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                  </div>

                 <div class="col">
                  <label for="grole1">สิทธิ์การใช้งาน:</label>
                <asp:DropDownList ID="grole1" runat="server" CssClass="form-group form-select"></asp:DropDownList>
                  <asp:CompareValidator ControlToValidate="grole1" ID="Vgrole1"  ErrorMessage="โปรดเลือกสิทธิ์การใช้งาน" runat="server" Display="Dynamic" Operator="NotEqual" ValueToCompare="0" Type="Integer" ForeColor="#FF0000" ValidationGroup="v1"  />
                 </div>
        </div>

         <div class="row">
              <div class="col">
              <label for="gpassword1">รหัสผ่าน:</label>
              <asp:TextBox ID="gpassword1" runat="server" TextMode="Password" CssClass="form-control col-6" />	
              <asp:RequiredFieldValidator ID="Vgpassword1" runat="server" ControlToValidate="gpassword1" ErrorMessage="โปรดระบุรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
              </div>
    
              <div class="col">
              <label for="grepassword1">ยืนยันรหัสผ่าน:</label>
              <asp:TextBox ID="grepassword1" runat="server"  TextMode="Password" CssClass="form-control col-6"/>
              <asp:RequiredFieldValidator ID="Vgrepassword1" runat="server" ControlToValidate="grepassword1" ErrorMessage="โปรดยืนยันรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
              <asp:CompareValidator ID="Vgrepassword2" runat="server" ControlToCompare="gpassword1" ControlToValidate="grepassword1" ErrorMessage="การยืนยันรหัสผ่านไม่ถูกต้อง" Display="Dynamic" ForeColor="#FF0000"></asp:CompareValidator>
              </div>
        </div>

            </div>           


      </div>
      <div class="modal-footer">
          <h3><asp:Label runat="server" ID="lbUserDup" CssClass="text-danger"></asp:Label></h3>
          <asp:Button ID="btn3" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-md" CausesValidation="true" OnClick="newuser" ValidationGroup="v1" />

          <button type="button" class="btn btn-dark" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
      
      </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
  </div>
</div>
         <!-- Modal newcase-->

  </div>
</div>

        </div>
        </div>

</main>


        <!-- Modal Saved Datea-->
        <div class="modal fade" id="myModal3" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header bg-secondary">
                <h5 class="modal-title" id="exampleModalLabel">Message</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                จัดเก็บข้อมูลเสร็จเรียบร้อยแล้ว
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnClose2">Close</button>
              </div>
            </div>
          </div>
        </div>
        <!-- Modal Saved Datea-->
     
         <!-- Modal Saved Datea-->
        <div class="modal fade" id="myModal4" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header bg-danger">
                <h5 class="modal-title">Message</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                *** Username นี้ถูกใช้แล้ว กรุณาป้อนใหม่ ***
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnClose4">Close</button>
              </div>
            </div>
          </div>
        </div>
        <!-- Modal Saved Datea-->

<!-- End Content -->


                <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
             <!-- Footer  -->


        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
