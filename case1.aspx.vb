Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO

Public Class case1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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

    Public Function Decrypt(cipherText As String) As String
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

    Public Function Encrypt(clearText As String) As String
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


End Class