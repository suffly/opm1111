Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Imports Newtonsoft.Json
Imports System.Net

Public Class case_operation1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

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

End Class