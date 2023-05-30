﻿<%@ Import Namespace="System.Data"%>
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

    End Sub

    Sub BindData()

        Dim iDate As Date = Request.Form("datepicker")
        Dim start_date As String = Year(iDate) - 543 & "-" & Right("00" & Month(iDate), 2) & "-" & Right("00" & Day(iDate), 2)

        Dim iDate2 As Date = Request.Form("datepicker2")
        Dim end_date As String = Year(iDate2) - 543 & "-" & Right("00" & Month(iDate2), 2) & "-" & Right("00" & Day(iDate2), 2)

        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = " Select If(createdate Is null, 'รวมทั้งสิ้น', createdate) as createdate ,total, status1, status2, status3"
        strSQL = strSQL & " from(SELECT"
        strSQL = strSQL & " date_format(case_inbox.create_date,'%Y-%m-%d') AS CreateDate,"
        strSQL = strSQL & " Count(case_inbox.case_id) As Total, "
        strSQL = strSQL & " count(CASE WHEN case_inbox.case_status = '1' then 1 END) AS status1,"
        strSQL = strSQL & " count(CASE WHEN case_inbox.case_status = '2' then 1 END) AS status2,"
        strSQL = strSQL & " count(CASE WHEN case_inbox.case_status = '3' then 1 END) AS status3"
        strSQL = strSQL & " FROM  case_inbox"
        strSQL = strSQL & " Left OUTER JOIN case_status ON case_inbox.case_status = case_status.id"
        strSQL = strSQL & " where case_inbox.enable = 'T'"
        If start_date <> "" And end_date <> "" Then
            strSQL = strSQL & " and date_format(create_date,'%Y-%m-%d') between '" & start_date & "' and '" & end_date & "'"
        End If
        strSQL = strSQL & " Group by createDate asc with rollup) t"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        Me.gridview1.DataSource = dt
        gridview1.DataBind()

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

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

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        'Tell the compiler that the control is rendered
        'explicitly by overriding the VerifyRenderingInServerForm event.
    End Sub

    Protected Sub btntoExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.ClearContent()
        Response.AddHeader("content-disposition", "attachment; filename=report1.xls")
        Response.ContentType = "application/excel"
        Dim sw As New System.IO.StringWriter()
        Dim htw As New HtmlTextWriter(sw)
        gridview1.RenderControl(htw)
        Response.Write(sw.ToString())
        Response.[End]()
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

      <!--Jquery DatePicker -->
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
              
             <div class="card-header bg-success">
     <div class="d-flex justify-content-between">
            <h2><i class="bi bi-journal-text"></i> 2. รายงานตามช่องทางการใช้บริการ</h2>
                </div>
  </div>
  <div class="card-body">

      <div class="alert alert-success" role="alert">
   <div class="row">
           <div class="col-2">
                     <label for="datepicker">ตั้งแต่วันที่ :</label>
                <asp:TextBox ID="datepicker" runat="server" CssClass="form-control" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="Vdatepicker" runat="server" ControlToValidate="datepicker" ErrorMessage="ตั้งแต่วันที่" Text="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                  </div>

       <div class="col-2">
                     <label for="datepicker2">ถึงวันที่ :</label>
                <asp:TextBox ID="datepicker2" runat="server" CssClass="form-control" AutoCompleteType="Disabled" />
           <asp:RequiredFieldValidator ID="Vdatepicker2" runat="server" ControlToValidate="datepicker2" ErrorMessage="ถึงวันที่" Text="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                  </div>
                    <div class="col-4">
                   <asp:Button ID="btnReport" runat="server" Text="รายงานผล" CssClass="btn btn-primary btn-sm" OnClick="BindData" CausesValidation="true" ValidationGroup="v1" />
                   <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn btn-light btn-sm" CausesValidation="false" OnClick="btntoExcel_Click" />
                        </div>
       </div>
    </div>
  
      <asp:GridView ID="gridview1" runat="server" AutoGenerateColumns="false" CssClass="table table-hover table-sm">
          <Columns>

              <asp:TemplateField HeaderText="วันที่บันทึกข้อมูล"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# Eval("createdate") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="15%" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="จำนวน"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# Eval("total") %>' Font-Bold="true"></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="15%" />
              </asp:TemplateField>

               <asp:TemplateField HeaderText="อยู่ระหว่างดำเนินการ"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# Eval("status1") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="15%" />
              </asp:TemplateField>

               <asp:TemplateField HeaderText="ส่งให้หน่วยงานที่เกี่ยวข้อง"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# Eval("status2") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="15%" />
              </asp:TemplateField>

               <asp:TemplateField HeaderText="ยุติเรื่อง"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>
                      <asp:Label ID="Label1" runat="server" Text='<%# Eval("status3") %>'></asp:Label>
                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="15%" />
              </asp:TemplateField>

               <asp:TemplateField HeaderText="หมายเหตุ"  HeaderStyle-CssClass="bg-success text-white text-center">
                  <ItemTemplate>

                  </ItemTemplate>
                  <itemstyle HorizontalAlign="center" Width="25%" />
              </asp:TemplateField>

              
        </Columns>
      </asp:GridView>

      </div>
             </div>

<!-- End Content -->



                <!-- Footer  -->
        <inc2:MyUserControl id="MyUserControl" runat="server" />
             <!-- Footer  -->

        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
