Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Public Class member1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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


End Class