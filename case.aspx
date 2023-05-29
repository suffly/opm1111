<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
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

        If Not Page.IsPostBack() Then
            DropDownListChannel()
            DropDownFastLevel()
            DropDownListCreateby()
        End If

        BindGrid()

    End Sub

    '*** DropDownList & DataTable ***'
    Sub DropDownListChannel()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, channel_name FROM channel where enable='T' order by channel_name"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.channel
            .DataSource = dt
            .DataTextField = "channel_Name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        channel.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        channel.SelectedIndex = channel.Items.IndexOf(channel.Items.FindByValue(0))  '*** By DataValueField ***'

    End Sub

    Sub DropDownFastLevel()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, fast_name FROM fast_level where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.fast_level
            .DataSource = dt
            .DataTextField = "fast_Name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        fast_level.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        fast_level.SelectedIndex = fast_level.Items.IndexOf(fast_level.Items.FindByValue(0))  '*** By DataValueField ***'

    End Sub

    Sub DropDownListCreateby()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT gid, concat(gname, ' ', gsurname) as gname  FROM Gmember where genable='T' order by gname"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.createby
            .DataSource = dt
            .DataTextField = "gname"
            .DataValueField = "gid"
            .DataBind()
        End With

        '*** Default Value ***'
        createby.Items.Insert(0, New ListItem("-- ผู้บันทึกข้อมูล --", "0"))
        createby.SelectedIndex = createby.Items.IndexOf(createby.Items.FindByValue(0))  '*** By DataValueField ***'

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

    Private Property SortDirection As String
        Get
            Return If(ViewState("SortDirection") IsNot Nothing, ViewState("SortDirection").ToString(), "ASC")
        End Get
        Set(ByVal value As String)
            ViewState("SortDirection") = value
        End Set
    End Property

    Private Sub BindGrid(Optional ByVal sortExpression As String = Nothing, Optional ByVal searchCaseCode As String = Nothing, Optional ByVal searchDoc_number As String = Nothing, Optional ByVal searchDatepicker As String = Nothing, Optional ByVal searchContactname As String = Nothing, Optional ByVal searchContactsurname As String = Nothing, Optional ByVal searchChannel As String = Nothing, Optional ByVal searchFast_level As String = Nothing, Optional ByVal searchSummary As String = Nothing, Optional ByVal searchRemark As String = Nothing, Optional ByVal searchCreateby As String = Nothing, Optional ByVal searchChkStatus As String = Nothing)


        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()


        strSQL = "SELECT case_inbox.case_id, case_inbox.case_code, case_inbox.doc_number, case_inbox.doc_date, case_inbox.contact, contact.name, contact.surname, concat(left(case_inbox.summary,150), if (LENGTH(case_inbox.summary) > 150,'...','')) as summary, case_inbox.create_date, case_inbox.status FROM case_inbox LEFT OUTER JOIN contact ON case_inbox.contact_id = contact.id where case_inbox.enable='T'"
        If Not String.IsNullOrEmpty(searchCaseCode) Then
            strSQL = strSQL & " and (case_inbox.case_code = '" & searchCaseCode & "' or case_inbox.case_id = '" & searchCaseCode & "')"
        End If
        If Not String.IsNullOrEmpty(searchDoc_number) Then
            strSQL = strSQL & " and case_inbox.doc_number like '%" & searchDoc_number & "%' "
        End If
        If Not String.IsNullOrEmpty(searchDatepicker) Then
            strSQL = strSQL & " and case_inbox.create_date = '" & searchDatepicker & "' "
        End If
        If Not String.IsNullOrEmpty(searchContactname) Then
            strSQL = strSQL & " and contact.name like '%" & searchContactname & "%' "
        End If
        If Not String.IsNullOrEmpty(searchContactsurname) Then
            strSQL = strSQL & " and contact.surname like '%" & searchContactsurname & "%' "
        End If
        If Not String.IsNullOrEmpty(searchChannel) And searchChannel <> "0" Then
            strSQL = strSQL & " and case_inbox.channel_id = '" & searchChannel & "' "
        End If
        If Not String.IsNullOrEmpty(searchFast_level) And searchFast_level <> "0" Then
            strSQL = strSQL & " and case_inbox.fast_level = '" & searchFast_level & "' "
        End If
        If Not String.IsNullOrEmpty(searchSummary) Then
            strSQL = strSQL & " and case_inbox.summary like '%" & searchSummary & "%' "
        End If
        If Not String.IsNullOrEmpty(searchRemark) Then
            strSQL = strSQL & " and case_inbox.remark like '%" & searchRemark & "%' "
        End If
        If Not String.IsNullOrEmpty(searchCreateby) And searchCreateby <> "0" Then
            strSQL = strSQL & " and case_inbox.create_by = '" & searchCreateby & "' "
        End If
        If Not String.IsNullOrEmpty(searchChkStatus) And searchChkStatus <> "0" Then
            strSQL = strSQL & " and case_inbox.status = '" & searchChkStatus & "' "
        End If
        strSQL = strSQL & " order by case_inbox.create_date desc"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        'Response.Write("<br /><br /><br /><br /><br />" & strSQL)

        '*** BindGrid to GridView ***'

        If sortExpression IsNot Nothing Then
            Dim dv As DataView = dt.AsDataView()
            Me.SortDirection = If(Me.SortDirection = "ASC", "DESC", "ASC")
            dv.Sort = sortExpression & " " & Me.SortDirection
            Me.GridView1.DataSource = dv
        Else
            Me.GridView1.DataSource = dt
        End If

        GridView1.DataBind()

        Dim TotalRecord As Integer = dt.Rows.Count
        Dim FilterRecord As Integer = dt.Rows.Count

        lbTotalRecord.Text = TotalRecord
        lbFilterRecord.Text = " พบ " & FilterRecord & " รายการ"

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing

    End Sub

    Protected Sub Search(ByVal sender As Object, ByVal e As EventArgs)
        BindGrid(Nothing, casecode.Text, doc_number.Text, datepicker.Text, contactname.Text, contactsurname.Text, channel.SelectedItem.Value, fast_level.SelectedItem.Value, summary.Text, remark.Text, createby.Text, chkstatus.Text)
    End Sub

    Protected Sub OnPageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        GridView1.PageIndex = e.NewPageIndex
        BindGrid(Nothing, casecode.Text, doc_number.Text, datepicker.Text, contactname.Text, contactsurname.Text, channel.SelectedItem.Value, fast_level.SelectedItem.Value, summary.Text, remark.Text, createby.Text, chkstatus.Text)
    End Sub

    Protected Sub OnSorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        BindGrid(e.SortExpression, casecode.Text, doc_number.Text, datepicker.Text, contactname.Text, contactsurname.Text, channel.SelectedItem.Value, fast_level.SelectedItem.Value, summary.Text, remark.Text, createby.Text, chkstatus.Text)
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

     <%If Request.QueryString("saved") = "y" Then%>
              <script type="text/javascript">
                  $(window).on('load', function () {
                      $('#myModal1').modal('show');
                  });
              </script>
    <%          End If%>


    <script type="text/javascript">
        window.onbeforeunload = function () {
            $("#progressbar1").show();
        };
    </script>
    <!--Loading Screen-->

      <!-- Jquery DatePicker -->
 	    <link rel="stylesheet" href="jquery.datetimepicker.css">
    <script src="jquery.datetimepicker.full.js"></script>
    <script type="text/javascript">   
        $(function () {

            $.datetimepicker.setLocale('th'); // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.


            // กรณีใช้แบบ input
            $("#datepicker").datetimepicker({
                timepicker: false,
                format: 'd/m/Y',  // กำหนดรูปแบบวันที่ ที่ใช้ เป็น 00-00-0000            
                lang: 'th',  // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.
                onSelectDate: function (dp, $input) {
                    var yearT = new Date(dp).getFullYear() - 0;
                    var yearTH = yearT + 543;
                    var fulldate = $input.val();
                    var fulldateTH = fulldate.replace(yearT, yearTH);
                    $input.val(fulldateTH);
                },
            });
            // กรณีใช้กับ input ต้องกำหนดส่วนนี้ด้วยเสมอ เพื่อปรับปีให้เป็น ค.ศ. ก่อนแสดงปฏิทิน
            $("#datepicker").on("mouseenter mouseleave", function (e) {
                var dateValue = $(this).val();
                if (dateValue != "") {
                    var arr_date = dateValue.split("/"); // ถ้าใช้ตัวแบ่งรูปแบบอื่น ให้เปลี่ยนเป็นตามรูปแบบนั้น
                    // ในที่นี้อยู่ในรูปแบบ 00-00-0000 เป็น d-m-Y  แบ่งด่วย - ดังนั้น ตัวแปรที่เป็นปี จะอยู่ใน array
                    //  ตัวที่สอง arr_date[2] โดยเริ่มนับจาก 0 
                    if (e.type == "mouseenter") {
                        var yearT = arr_date[2] - 543;
                    }
                    if (e.type == "mouseleave") {
                        var yearT = parseInt(arr_date[2]) + 543;
                    }
                    dateValue = dateValue.replace(arr_date[2], yearT);
                    $(this).val(dateValue);
                }
            });


            // กรณีใช้แบบ input
            $("#datepicker2").datetimepicker({
                timepicker: false,
                format: 'd/m/Y',  // กำหนดรูปแบบวันที่ ที่ใช้ เป็น 00-00-0000            
                lang: 'th',  // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.
                onSelectDate: function (dp, $input) {
                    var yearT = new Date(dp).getFullYear() - 0;
                    var yearTH = yearT + 543;
                    var fulldate = $input.val();
                    var fulldateTH = fulldate.replace(yearT, yearTH);
                    $input.val(fulldateTH);
                },
            });
            // กรณีใช้กับ input ต้องกำหนดส่วนนี้ด้วยเสมอ เพื่อปรับปีให้เป็น ค.ศ. ก่อนแสดงปฏิทิน
            $("#datepicker2").on("mouseenter mouseleave", function (e) {
                var dateValue = $(this).val();
                if (dateValue != "") {
                    var arr_date = dateValue.split("/"); // ถ้าใช้ตัวแบ่งรูปแบบอื่น ให้เปลี่ยนเป็นตามรูปแบบนั้น
                    // ในที่นี้อยู่ในรูปแบบ 00-00-0000 เป็น d-m-Y  แบ่งด่วย - ดังนั้น ตัวแปรที่เป็นปี จะอยู่ใน array
                    //  ตัวที่สอง arr_date[2] โดยเริ่มนับจาก 0 
                    if (e.type == "mouseenter") {
                        var yearT = arr_date[2] - 543;
                    }
                    if (e.type == "mouseleave") {
                        var yearT = parseInt(arr_date[2]) + 543;
                    }
                    dateValue = dateValue.replace(arr_date[2], yearT);
                    $(this).val(dateValue);
                }
            });

        });
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
         <div class="card text-dark bg-light mx-auto col-lg-10 col-sm-12">
              
             <div class="card-header bg-primary">
     <div class="d-flex justify-content-between">
            <h2><i class="bi bi-list-stars"></i> รายการเรื่องร้องทุกข์ <span class="badge rounded-pill bg-info text-white"><asp:Label ID="lbTotalRecord" runat="server"></asp:Label></span></h2>
                </div>
  </div>
  <div class="card-body">


  <div class="card card-body bg-primary bg-opacity-10">
      <div class="row">
           <div class="col-sm-2">
      <label for="casecode">รหัสเรื่อง:</label>
              <asp:TextBox ID="casecode" runat="server" CssClass="form-control" />
          </div>
      <div class="col-sm-2">
      <label for="doc_number">เลขที่หนังสือ:</label>
              <asp:TextBox ID="doc_number" runat="server" CssClass="form-control" />
          </div>
      <div class="col-sm-2">
       <label for="datepicker">ลงวันที่:</label>
              <asp:TextBox ID="datepicker" runat="server" CssClass="form-control" AutoCompleteType="Disabled"  />
          </div>
      <div class="col-sm-2">
     <label for="contactname">ชื่อผู้ร้อง :</label>
              <asp:TextBox ID="contactname" runat="server" CssClass="form-control" />
          </div>
      <div class="col-sm-2">
      <label for="contactsurname">นามสกุล :</label>
              <asp:TextBox ID="contactsurname" runat="server" CssClass="form-control" />
          </div>
      <div class="col-sm-2">
       <label for="channel">ที่มา :</label>
         <asp:DropDownList ID="channel" runat="server" CssClass="form-select" AutoPostBack="false"></asp:DropDownList>
          </div>
      <div class="col-sm-2">
      <label for="fast_level">ความเร่งด่วน :</label>
              <asp:DropDownList ID="fast_level" runat="server" CssClass="form-select" AutoPostBack="false"></asp:DropDownList>
          </div>
      <div class="col-sm-2">
       <label for="summary">สาระสำคัญของเรื่อง :</label>
              <asp:TextBox ID="summary" runat="server" CssClass="form-control" />
          </div>
      <div class="col-sm-2">
        <label for="remark">หมายเหตุ :</label>
              <asp:TextBox ID="remark" runat="server" CssClass="form-control" />
          </div>
                <div class="col-sm-3">
        <label for="createby">ผู้บันทึก :</label>
              <asp:DropDownList ID="createby" runat="server" CssClass="form-select" ></asp:DropDownList>
          </div>
                <div class="col-sm-2">
        <label for="remark">สถานะรับเรื่อง :</label>
               <asp:DropDownList ID="chkstatus" runat="server" CssClass="form-select" AutoPostBack="false">
                   <asp:ListItem Text="ทั้งหมด" Value="0"></asp:ListItem>
                   <asp:ListItem Text="รับเรื่องแล้ว" Value="T"></asp:ListItem>
                   <asp:ListItem Text="รอรับเรื่อง" Value="F"></asp:ListItem>
               </asp:DropDownList>
          </div>
          </div>
  </div>

                 <div class="d-flex p-0 justify-content-center"> 
                     <asp:Button ID="button1" runat="server" CssClass="btn btn-warning btn-md" OnClick="search" Text="ค้นหา" />
                       <button id="Button2" Class="btn btn-secondary btn-md" runat="server" type="reset" >ล้าง</button>
             </div>

        <asp:UpdateProgress ID="updateProgress1" DynamicLayout="true" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                          <div class="spinner-border text-danger" role="status">
                          <span class="visually-hidden">Loading...</span>
                        </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

                  <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
          <ContentTemplate>

          <div class="d-flex p-1 bg-light justify-content-center"> 
            	 <asp:Label ID="lbFilterRecord" runat="server" ForeColor="#0000FF" Font-Bold="true" CssClass="p-1"></asp:Label>
           </div>

      <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-bordered table-sm" PageSize="10" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" AllowSorting="True" OnSorting="OnSorting" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom" >

                 <Columns>
         <asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-primary text-white text-center" >
            <ItemTemplate>
                <%# Container.DataItemIndex + 1 %>
            </ItemTemplate>
            <itemstyle HorizontalAlign="center" Width="3%" />
        </asp:TemplateField>

              <asp:TemplateField HeaderText="รหัสเรื่อง"  HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:HyperLink ID="HyperLink1"  runat="server" NavigateUrl='<% # String.Format("case_detail.aspx?case_id={0}", Encrypt(Eval("case_id").ToString()))%>' Text='<%# DataBinder.Eval(Container, "DataItem.case_id") %>'></asp:HyperLink>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="5%" />
              </asp:TemplateField>

               <asp:TemplateField HeaderText="เลขรับคำร้อง"  HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# If(Eval("doc_number") = "", "-", Eval("doc_number")) %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="8%" />
              </asp:TemplateField>

                      <asp:TemplateField HeaderText="ลงวันที่"  HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# If(Eval("doc_date").ToString() = "1/1/0544 0:00:00", "-", FormatDateTime(DataBinder.Eval(Container, "DataItem.doc_date"), 2)) %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="5%" />
              </asp:TemplateField>
              
             <asp:TemplateField HeaderStyle-CssClass="bg-primary text-white text-center" HeaderText="ผู้ร้อง">
                  <ItemTemplate>
                  <asp:Label ID="Label1" runat="server" Text='<%#If(Eval("contact") = "T", DataBinder.Eval(Container, "DataItem.name") & " " & DataBinder.Eval(Container, "DataItem.surname"), "ไม่ระบุ") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="left" Width="15%" />
              </asp:TemplateField>

                      <asp:TemplateField HeaderStyle-CssClass="bg-primary text-white text-center" HeaderText="รายละเอียด">
                  <ItemTemplate>
                  <asp:Label ID="Label1" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.summary") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="left" Width="20%" />
              </asp:TemplateField>
              
              <asp:TemplateField HeaderText="วันที่บันทึกข้อมูล"  HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label3" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.CREATE_DATE") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="8%" />
              </asp:TemplateField>
              
              <asp:TemplateField HeaderText="สถานะ"  HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label4" runat="server" CssClass="text-success bi bi-envelope-open" Visible='<%#If(DataBinder.Eval(Container, "DataItem.STATUS").ToString() = "T", True, False) %>'></asp:Label>
                       <asp:Label ID="Label5" runat="server" CssClass="text-danger bi bi-envelope" Visible='<%#If(DataBinder.Eval(Container, "DataItem.STATUS").ToString() = "F", True, False) %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="5%" />
              </asp:TemplateField>
              
                    <asp:TemplateField HeaderText="การดำเนินการ" HeaderStyle-CssClass="bg-primary text-white text-center">
                  <ItemTemplate>
                      <asp:HyperLink ID="HyperLink3"  runat="server" NavigateUrl='<%# String.Format("case_operation.aspx?case_code={0}", Encrypt(Eval("case_code").ToString())) %>' CssClass="bi bi-pencil-square" Target="_blank" Visible='<%# if(Eval("case_code").ToString() = "", False, True) %>' ></asp:HyperLink>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="8%" />
              </asp:TemplateField>

          </Columns>
      </asp:GridView>
              
  </ContentTemplate>
            <Triggers>
        	<asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
            <asp:AsyncPostBackTrigger ControlID="button1" EventName="click" />
        </Triggers>
        </asp:UpdatePanel>

      </div>

         </div>

<!-- End Content -->



                <!-- Footer  -->
        <inc2:MyUserControl id="MyUserControl" runat="server" />
             <!-- Footer  -->




        <!-- Modal -->
        <div class="modal fade" id="myModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">ข้อความแจ้งเตือน!</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center">
         <% If Request.QueryString("saved") = "y" Then%>
         <i class="bi bi-save2"></i> <h3>บันทึกข้อมูลเรียบร้อยแล้ว</h3><br /> <h2>เลขที่รับเรื่อง <%=Request.QueryString("case_code")%></h2>
		  <%End If%>
      </div>
      <div class="modal-footer">
           <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
      </div>
    </div>
  </div>
</div>

        <!-- Modal -->

        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
