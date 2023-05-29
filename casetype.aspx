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
          End If

      End Sub

      Private Sub BindData()

          Dim objConn As MySqlConnection
          Dim dtAdapter As New MySqlDataAdapter
          Dim dt As New DataTable

          Dim strConnString, strSQL As String
          strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
          objConn = New MySqlConnection(strConnString)
          objConn.Open()

          strSQL = "SELECT *"
          strSQL = strSQL & " FROM"
          strSQL = strSQL & " case_type"
          strSQL = strSQL & " where enable='T' "
          strSQL = strSQL & " order by case_typename"

          dtAdapter = New MySqlDataAdapter(strSQL, objConn)
          dtAdapter.Fill(dt)

          GridView1.DataSource = dt
          GridView1.DataBind()

          dtAdapter = Nothing

          objConn.Close()
          objConn = Nothing
      End Sub

      Sub modDeleteCommand(ByVal sender As Object, ByVal e As EventArgs)
          Dim casetypeID As String = (TryCast(sender, Button)).CommandArgument

          Dim objConn As MySqlConnection
          Dim strConnString, strSQL As String

          strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
          objConn = New MySqlConnection(strConnString)
          objConn.Open()

          strSQL = "update case_type set enable='F' WHERE ID = '" & casetypeID & "'"

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


          strSQL = "insert into case_type (case_typename, create_by, create_date, enable) values ("
          strSQL = strSQL & "'" & Request.Form("casetype1") & "', "
          strSQL = strSQL & "'" & Session("strGID") & "', "
          strSQL = strSQL & "'" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "', "
          strSQL = strSQL & "'T'"
          strSQL = strSQL & ")"

          objCmd = New MySqlCommand(strSQL, objConn)
          objCmd.ExecuteNonQuery()

          objConn.Close()
          objConn = Nothing

          BindData()

          '##################Clear Field
          casetype1.Text = ""

          '##################Clear Field

          ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal2", "CloseModal2();", True)

          ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup3", "ShowPopup3();", True)


      End Sub

      Sub UpdateData()
          Dim objConn As MySqlConnection
          Dim objCmd As MySqlCommand
          Dim strConnString, strSQL As String

          strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
          objConn = New MySqlConnection(strConnString)
          objConn.Open()

          strSQL = "UPDATE case_type SET"
          strSQL = strSQL & " case_typename = '" & Request.Form("casetype") & "'"
          strSQL = strSQL & ", update_date = '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "' "
          strSQL = strSQL & ", update_by = '" & Session("strGID") & "'"
          strSQL = strSQL & " WHERE id = '" & Request.Form("id") & "'"


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
          Dim casetypeID As String = (TryCast(sender, Button)).CommandArgument

          Dim objConn As MySqlConnection
          Dim dtAdapter As New MySqlDataAdapter
          Dim dt As New DataTable

          Dim strConnString, strSQL As String
          strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
          objConn = New MySqlConnection(strConnString)
          objConn.Open()

          strSQL = "SELECT * from case_type where id='" & casetypeID & "'"

          dtAdapter = New MySqlDataAdapter(strSQL, objConn)
          dtAdapter.Fill(dt)

          id.Text = dt.Rows(0)("id").ToString
          casetype.Text = dt.Rows(0)("case_typename").ToString


          dtAdapter = Nothing

          objConn.Close()
          objConn = Nothing

          ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup", "ShowPopup();", True)

      End Sub


      Protected Sub OnPageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
          GridView1.PageIndex = e.NewPageIndex
          BindData()
      End Sub

        </script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="images/opm-logo.png" type="image/png" />
    <title>PSC 1111 Web Portal</title>

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

            function CloseModal() {
                $('#myModal').modal('hide');
            }

            function CloseModal2() {
                $('#myModal2').modal('hide');
            }
        </script>


</head>
<body style="overflow:auto;">
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
  <h5 class="card-header bg-info text-white">ประเภทเรื่อง</h5>
  <div class="card-body">

      

        <asp:UpdatePanel runat="server" ID="updatepanel1">
        <ContentTemplate>

            <div class="alert alert-primary" role="alert">
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#myModal2">เพิ่ม +</button>
            </div>

           <asp:GridView id="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" CssClass="table table-hover table-bordered table-sm" PageSize="10" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom">

	<Columns>
       
	<asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
		<%# Container.DataItemIndex + 1 %>
		</ItemTemplate>
	</asp:TemplateField>

	<asp:TemplateField HeaderText="ประเภทเรื่อง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-left">
		<ItemTemplate>
			<asp:Label id="lbcastype" runat="server" Text='<%# Eval("case_typename") %>'></asp:Label>
		</ItemTemplate>
	</asp:TemplateField>

          <asp:TemplateField HeaderText="วันที่สร้าง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
			<asp:Label id="lbCreatedate" runat="server" Text='<%# Eval("create_date") %>'></asp:Label>&nbsp;
		</ItemTemplate>
	</asp:TemplateField>

        <asp:TemplateField HeaderText="ดำเนินการ" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		<ItemTemplate>
			<asp:Button Text="แก้ไข" ID="btnPreview" runat="server" OnClick="OnPreview" CommandArgument='<%#Eval("ID")%>' CssClass="btn btn-info btn-sm" CausesValidation="false"  />
            <asp:Button Text="ลบ" ID="btnDelete" runat="server" OnClick="modDeleteCommand" CommandArgument='<%#Eval("ID")%>' CssClass="btn btn-danger btn-sm" CausesValidation="false" OnClientClick="if(!confirm('Are you sure?')) return false;"  />
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

      <div class="modal-header bg-info"><h3>แก้ไขประเภทเรื่อง</h3>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">


        <div class="container">

            <div class="row">
             <div class="col">
                 <div style="display:none;">
                 <asp:TextBox ID="id" runat="server" CssClass="form-control" />
                 </div>

                  <label for="channel_name">ประเภทเรื่อง:</label>
                  <asp:TextBox ID="casetype" runat="server" placeholder="" CssClass="form-control"/>
                  <asp:RequiredFieldValidator ID="Vcasetype" runat="server" ControlToValidate="casetype" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
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
      <div class="modal-header bg-primary"><h3>เพิ่มประเภทเรื่อง</h3>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">

        <div class="container">

            <div class="row">
                <div class="col">
                  <label for="channel_name1">ประเภทเรื่อง:</label>
                  <asp:TextBox ID="casetype1" runat="server" placeholder="" CssClass="form-control"/>
                  <asp:RequiredFieldValidator ID="Vcasetype1" runat="server" ControlToValidate="casetype1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                     </div>
            </div>

            </div>           

      </div>
      <div class="modal-footer">

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
     

<!-- End Content -->


                <!-- Footer  -->
        <inc2:MyUserControl id="MyUserControl" runat="server" />
             <!-- Footer  -->


        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
