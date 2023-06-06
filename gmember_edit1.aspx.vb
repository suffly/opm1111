Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Public Class gmember_edit1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
        End If

        BindData()

    End Sub

    Private Sub BindData()
        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT * FROM Gmember WHERE gid = '" & Session("strGID") & "' "

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        Me.gname.Text = dt.Rows(0)("Gname").ToString
        Me.gsurname.Text = dt.Rows(0)("GSurname").ToString
        Me.gemail.Text = dt.Rows(0)("Gemail").ToString
        Me.gpassword.Text = dt.Rows(0)("Gpassword").ToString
        gpassword.Attributes("value") = gpassword.Text
        Me.grepassword.Text = dt.Rows(0)("Gpassword").ToString
        grepassword.Attributes("value") = grepassword.Text

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

    Sub save_profile(sender As Object, e As EventArgs)
        If Session("strGid") = "" Then
            Response.Redirect("index.aspx")
        End If

        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "UPDATE Gmember SET "
        strSQL = strSQL & " Gpassword = '" & Request.Form("gpassword") & "'"
        strSQL = strSQL & " WHERE GID = '" & Session("strGid") & "'"

        objCmd = New MySqlCommand(strSQL, objConn)
        With objCmd
            .Connection = objConn
            .CommandText = strSQL
            .CommandType = CommandType.Text
        End With

        objCmd.ExecuteNonQuery()
        Response.Redirect("gmember_edit.aspx?status=success")

        objConn.Close()
        objConn = Nothing

    End Sub


End Class