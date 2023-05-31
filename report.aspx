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

        'Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
        End If

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

        <div class="container-fluid bg-light my-4"></div>

 <div class="progress" id="progressbar1" >
  <div class="progress-bar progress-bar-striped progress-bar-animated"  role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%"></div>
</div>

    <!-- Content-->         
         <div class="card text-dark bg-light mx-auto col-lg-10 col-sm-12">
              
             <div class="card-header bg-primary">
     <div class="d-flex justify-content-between">
            <h2><i class="bi bi-journal-text"></i> รายงาน</h2>
                </div>
  </div>
  <div class="card-body">
  <div class="card card-body bg-primary bg-opacity-10">
      
      <div class="list-group">
  <a href="report1.aspx" class="list-group-item list-group-item-action">1. รายงานตามประเภทหนังสือ (ข้อร้องทุกข์ ข้อหารือ แสดงความเห็น)</a>
  <a href="report2.aspx" class="list-group-item list-group-item-action">2. รายงานผลการดำเนินการ</a>
  <a href="report3.aspx" class="list-group-item list-group-item-action">3. รายงานตามพื้นที่ของปัญหา</a>
  <a href="report4.aspx" class="list-group-item list-group-item-action">4. รายงานตามผู้ขอใช้บริการ</a>
  <a href="report5.aspx" class="list-group-item list-group-item-action">5. รายงานตามช่องทางการใช้บริการ</a>
  <a href="report6.aspx" class="list-group-item list-group-item-action">6. รายงานการแจ้งผลการดำเนินงานตามหน่วยงานที่รับเรื่อง</a>
</div>


  </div>
      </div>
             </div>

<!-- End Content -->



                <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
             <!-- Footer  -->




        <!-- Modal -->
        

        <!-- Modal -->

        <script src="bootstrap.bundle.min.js"></script>

</form>
</body>
</html>
