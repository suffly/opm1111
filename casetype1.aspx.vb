Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Public Class casetype1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

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

End Class