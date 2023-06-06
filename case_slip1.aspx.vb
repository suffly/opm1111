Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.text.html.simpleparser
Imports iTextSharp.text.pdf

Public Class case_slip1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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
        Dim Font = New iTextSharp.text.Font(tahoma, 12)

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


End Class