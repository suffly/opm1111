<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
<%@ Import Namespace="iTextSharp.text"%>
<%@ Import Namespace="iTextSharp.text.html.simpleparser"%>
<%@ Import Namespace="iTextSharp.text.pdf"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Page Language="VB" ContentType="text/html" %>

<script runat="server">

    Sub Page_Load(sender As Object, e As EventArgs)

        Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
        End If

        BindData()
        'btnExport_Click()
    End Sub

    Sub BindData()
        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand
        Dim dtReader As MySqlDataReader
        Dim ds1, ds2 As New DataSet

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT"
        strSQL = strSQL & " case_inbox.case_id,"
        strSQL = strSQL & " case_inbox.case_code,"
        strSQL = strSQL & " case_inbox.summary,"
        strSQL = strSQL & " case_inbox.create_date,"
        strSQL = strSQL & " case_inbox.doc_number,"
        strSQL = strSQL & " case_inbox.doc_date,"
        strSQL = strSQL & " contact.titlename,"
        strSQL = strSQL & " contact.name,"
        strSQL = strSQL & " contact.surname,"
        strSQL = strSQL & " gmember.GNAME,"
        strSQL = strSQL & " gmember.GSURNAME"
        strSQL = strSQL & " FROM"
        strSQL = strSQL & " case_inbox"
        strSQL = strSQL & " LEFT OUTER JOIN contact ON case_inbox.contact_id = contact.id"
        strSQL = strSQL & " Left OUTER JOIN gmember ON case_inbox.create_by = gmember.GID"
        strSQL = strSQL & " where case_inbox.case_id='" & Decrypt(Request.QueryString("case_id")) & "'"

        objCmd = New MySql.Data.MySqlClient.MySqlCommand(strSQL, objConn)
        dtReader = objCmd.ExecuteReader()
        listview1.DataSource = dtReader
        listview1.DataBind()

        dtReader.Close()
        dtReader = Nothing

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



    Sub btnExport_Click()
        Dim tahoma As BaseFont = BaseFont.CreateFont("c:\windows\fonts\tahoma.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED)
        Dim Font = New Font(tahoma, 12)

        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename=TestPage.pdf")
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Dim sw As New StringWriter()
        Dim hw As New HtmlTextWriter(sw)
        Me.Page.RenderControl(hw)
        Dim sr As New StringReader(sw.ToString())
        Dim pdfDoc As New Document(PageSize.A4, 10.0F, 10.0F, 100.0F, 0.0F)
        Dim htmlparser As New HTMLWorker(pdfDoc)
        PdfWriter.GetInstance(pdfDoc, Response.OutputStream)
        pdfDoc.Open()
        htmlparser.Parse(sr)
        pdfDoc.Close()
        Response.Write(pdfDoc)
        Response.[End]()
    End Sub


	</script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="images/opm-logo.png" type="image/png" />
    <title></title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap.css" rel="stylesheet">

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style1.css">

    <!-- Jquery -->
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>

    <!-- Icon-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">

   <script src="bootstrap.bundle.min.js"></script>

   
</head>
<body>

    <asp:Panel runat="server" ID="panel1">
        <div class="container">
         <asp:DataList runat="server" ID="listview1">
          <ItemTemplate>

     <div class="row">
            <div class="col-2 mt-4">
              <img src="http://180.180.244.31/opm1111/images/image001.png" width="100" height="100">
            </div>
            <div class="col-10">
                    <h3 class="text-black mt-5">㺹�������ͧ��ͧ���¹</h3>
                        <h6 class="text-black">�ӹѡ�ҹ�ŢҸԡ����Ҽ��᷹��ɮ� �Ţ��� 1111 �������ʹ �ǧ�����������</h6> 
                    <h6 class="text-black">ࢵ���Ե ��ا෾� 10300 ��. 0 2242 5900 ��� 5041</h6>
            </div>
     </div>

<hr />

     <div class="row">
            <div class="col">
            </div>
            <div class="col text-black">
              �ѹ��� <%#FormatDateTime(Eval("create_date"), 1) %>
            </div>
    </div>

<p class="text-black">����ͧ �������䢻ѭ�Ҥ�����ʹ��͹�ͧ��ЪҪ�</p>
<p class="text-black">��Һ���¹ ��¡�Ѱ�����</p>


<p style="text-indent:50px" class="text-black">���� <%# Eval("titlename") %><%# Eval("name") %>&nbsp;<%# Eval("surname") %>&nbsp; ����˹ѧ��͡�Һ���¹��иҹ�Ѱ���/��иҹ��Ҽ��᷹��ɮ� ���͢������䢻ѭ������ͧ��ͧ���¹��ͧ�ء��ó� <%# Eval("summary") %> ��������´��ҡ�����͡��÷��Ṻ�Ҿ�������</p>

 <p style="text-indent:50px" class="text-black">㹡�ù�� �ӹѡ�ҹ�ŢҸԡ����Ҽ��᷹��ɮ� ��Ӥ�����Һ���¹��иҹ�Ѱ������;Ԩ�ó����� ��繤��������ͧ����ӹѡ�ҹ��Ѵ�ӹѡ��¡�Ѱ����� �֧��������ͧ�����;Ԩ�óҵ������������õ���</p>

<p style="text-indent:50px" class="text-black">�֧���¹�������ô�Ԩ�ó� ���繻�С��� �ô������Һ���� �ѡ�ͺ�س���</p>
              <br /><br /><br /><br /><br />
<p class="text-black">������ҹ�ҹ : <%# Eval("Gname") %> <%# Eval("Gsurname") %></p>
<p class="text-black">�Ţ���˹ѧ����Ѻ : <%# Eval("doc_number") %> ŧ�ѹ��� <%# formatdatetime(Eval("doc_date"), 2) %></p>
       </ItemTemplate>
      </asp:DataList>
            </div>
        </asp:Panel>

</body>
</html>
