Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Public Class case_detail1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
            Response.End()
        End If

        If Session("strRole") = "3" Then
            btnDeleteCase.Visible = True
            btnDeleteCase.Enabled = True
        End If

        If Not Page.IsPostBack() Then
            DropDownListChannel()
            DropDownFastLevel()
            DropDownCaseObjective()
            DropDownCaseType()
            DropDownCustomerType()
            DropDownPolitical_party()
            DropDownMHR_type()
            DropDownPolitical_type()
            DropDownContactProvince()
            DropDownCaseProvince()
            DropDownCaseStatus()
            Vcontact_id.Enabled = False
            Vconceal.Enabled = False
        End If

        BindData()
        BindGridView()

    End Sub

    Sub BindData()

        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt, dt2 As New DataTable

        Dim strConnString, strSQL, strSQL2 As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "Select"
        strSQL = strSQL & " case_inbox.case_id,"
        strSQL = strSQL & " case_inbox.case_code,"
        strSQL = strSQL & " case_inbox.doc_number,"
        strSQL = strSQL & " case_inbox.doc_date,"
        strSQL = strSQL & " case_inbox.consult_date,"
        strSQL = strSQL & " case_inbox.case_type,"
        strSQL = strSQL & " case_inbox.contact,"
        strSQL = strSQL & " case_inbox.contact_id,"
        strSQL = strSQL & " case_inbox.conceal,"
        strSQL = strSQL & " case_inbox.channel_id,"
        strSQL = strSQL & " case_inbox.case_objective,"
        strSQL = strSQL & " case_inbox.fast_level,"
        strSQL = strSQL & " case_inbox.secret_level,"
        strSQL = strSQL & " case_inbox.case_province,"
        strSQL = strSQL & " case_inbox.summary,"
        strSQL = strSQL & " case_inbox.remark,"
        strSQL = strSQL & " case_inbox.case_status,"
        strSQL = strSQL & " case_inbox.status,"
        strSQL = strSQL & " case_inbox.create_date,"
        strSQL = strSQL & " concat(createby.GNAME, ' ', createby.GSURNAME) As create_by,"
        strSQL = strSQL & " case_inbox.update_date,"
        strSQL = strSQL & " concat(updateby.GNAME, ' ', updateby.GSURNAME) as update_by"
        strSQL = strSQL & " FROM"
        strSQL = strSQL & " case_inbox"
        strSQL = strSQL & " Left OUTER JOIN gmember AS createby ON case_inbox.create_by = createby.GID"
        strSQL = strSQL & " Left OUTER JOIN gmember AS updateby ON case_inbox.update_by = updateby.GID"
        strSQL = strSQL & " where enable = 'T' and case_id='" & Decrypt(Request.QueryString("case_id")) & "'"


        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        lb1.Text = dt.Rows(0)("case_id").ToString
        If dt.Rows(0)("status").ToString = "T" Then
            lb2.Text = " (สปน. รับเรื่องแล้ว)"
            btngetjob.Enabled = False
            btnSave.Enabled = False
        End If

        Me.doc_number.Text = dt.Rows(0)("doc_number").ToString
        If dt.Rows(0)("doc_date").ToString <> "1/1/0544 0:00:00" Then
            Me.datepicker.Text = FormatDateTime(dt.Rows(0)("doc_date").ToString, 2)
        Else
            Me.datepicker.Text = ""
        End If
        If dt.Rows(0)("consult_date").ToString <> "1/1/0544 0:00:00" Then
            Me.datepicker2.Text = FormatDateTime(dt.Rows(0)("consult_date").ToString, 2)
        Else
            Me.datepicker2.Text = ""
        End If
        Me.case_code.Text = dt.Rows(0)("case_code").ToString
        Me.case_type.Text = dt.Rows(0)("case_type").ToString
        Me.contact.Text = dt.Rows(0)("contact").ToString
        Me.contact_id.Text = dt.Rows(0)("contact_id").ToString
        Me.conceal.Text = dt.Rows(0)("conceal").ToString
        Me.channel.Text = dt.Rows(0)("channel_id").ToString
        Me.case_objective.Text = dt.Rows(0)("case_objective").ToString
        Me.fast_level.Text = dt.Rows(0)("fast_level").ToString
        Me.case_province.Text = dt.Rows(0)("case_province").ToString
        Me.summary.Text = dt.Rows(0)("summary").ToString
        Me.remark.Text = dt.Rows(0)("remark").ToString
        Me.case_status.Text = dt.Rows(0)("case_status").ToString
        Me.lbCreateby.Text = dt.Rows(0)("create_by").ToString & " (" & dt.Rows(0)("create_date").ToString & ")"
        Me.lbUpdateby.Text = dt.Rows(0)("update_by").ToString & " (" & dt.Rows(0)("update_date").ToString & ")"

        If dt.Rows(0)("case_objective").ToString = "2" Then
            showdatepicker2.Style.Add("display", "block")
        End If

        If dt.Rows(0)("contact").ToString = "T" Then
            show_contactdetail.Style.Add("display", "block")
            showsearch_contact.Style.Add("display", "block")
            show_conceal.Style.Add("display", "block")
            Vconceal.Enabled = True
        Else
            show_contactdetail.Style.Add("display", "none")
            showsearch_contact.Style.Add("display", "none")
            show_conceal.Style.Add("display", "none")
            Vconceal.Enabled = False
        End If

        If dt.Rows(0)("status").ToString = "T" Then
            FileUpload1.Enabled = False
            GridView.Columns(3).Visible = False
        End If

        If Session("strRole") = "1" Then
            mergecase.Style.Add("display", "block")
            btngetjob.Visible = True
        End If

        strSQL2 = "Select contact.ID, contact.name, contact.surname, contact.phone, contact.email, customer_type.customer_typename FROM contact Left OUTER JOIN customer_type ON contact.customer_type = customer_type.id where contact.enable = 'T' and contact.id='" & dt.Rows(0)("contact_id").ToString & "'"

        dtAdapter = New MySqlDataAdapter(strSQL2, objConn)
        dtAdapter.Fill(dt2)
        GridView3.DataSource = dt2
        GridView3.DataBind()

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing

    End Sub

    Sub btnSave_Click()

        Dim case_id As String = Decrypt(Request.QueryString("case_id"))
        Try
            Dim objConn As MySqlConnection
            Dim dtAdapter As New MySqlDataAdapter
            Dim strConnString, strSQL1, strSQL2 As String

            strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

            objConn = New MySqlConnection(strConnString)
            objConn.Open()

            Dim objCmd As MySqlCommand

            ' Get the HttpFileCollection##############################################
            Dim hfc As HttpFileCollection = Request.Files
            For i As Integer = 0 To hfc.Count - 1
                'Upload File
                Dim hpf As HttpPostedFile = hfc(i)
                If hpf.ContentLength > 0 Then
                    Dim strdate = Now()
                    Dim strfilename = strdate.Day() & strdate.Month() & strdate.Year() & strdate.Hour() & strdate.Minute() & strdate.Second()
                    Dim savefilename As String = strfilename & System.IO.Path.GetFileName(hpf.FileName)
                    hpf.SaveAs(Server.MapPath("UploadFiles") & "\" & savefilename)
                    'Response.Write("<b>File: </b>" & hpf.FileName & " <b>Size:</b> " & hpf.ContentLength & " <b>Type:</b> " & hpf.ContentType & " Uploaded Successfully <br/>")

                    'Insert to DB
                    strSQL1 = "insert into attachment(Docname, Filename, Doctype, case_id, enable, create_by, create_date) values('" & hpf.FileName & "', '" & savefilename & "', '" & hpf.ContentType & "', '" & case_id & "', 'T', '" & Session("strGID") & "', '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "')"

                    objCmd = New MySqlCommand(strSQL1, objConn)
                    With objCmd
                        .Connection = objConn
                        .CommandText = strSQL1
                        .CommandType = CommandType.Text
                    End With

                    objCmd.ExecuteNonQuery()

                End If

            Next i

            'update content to Database##############################################
            Dim iDate As String = Request.Form("datepicker")
            Dim doc_date As String
            If iDate <> "" Then
                doc_date = Year(iDate) - 543 & "-" & Right("00" & Month(iDate), 2) & "-" & Right("00" & Day(iDate), 2) & " 00:00:00"
            Else
                doc_date = "0000-00-00 00:00:00"
            End If


            Dim iDate2 As String = Request.Form("datepicker2")
            Dim consult_date As String
            If iDate2 <> "" Then
                consult_date = Year(iDate2) - 543 & "-" & Right("00" & Month(iDate2), 2) & "-" & Right("00" & Day(iDate2), 2) & " 00:00:00"
            Else
                consult_date = "0000-00-00 00:00:00"
            End If

            strSQL2 = "update case_inbox set"
            strSQL2 = strSQL2 & " doc_number = '" & Request.Form("doc_number") & "'"
            strSQL2 = strSQL2 & " ,doc_date = '" & doc_date & "'"
            strSQL2 = strSQL2 & " ,consult_date = '" & consult_date & "'"
            strSQL2 = strSQL2 & " ,case_type = '" & Request.Form("case_type") & "'"
            strSQL2 = strSQL2 & " ,contact = '" & Request.Form("contact") & "'"
            strSQL2 = strSQL2 & " ,contact_id = '" & Request.Form("contact_id") & "'"
            strSQL2 = strSQL2 & " ,conceal = '" & Request.Form("conceal") & "'"
            strSQL2 = strSQL2 & " ,channel_id = '" & Request.Form("channel") & "'"
            strSQL2 = strSQL2 & " ,case_objective = '" & Request.Form("case_objective") & "'"
            strSQL2 = strSQL2 & " ,fast_level = '" & Request.Form("fast_level") & "'"
            strSQL2 = strSQL2 & " ,case_province = '" & Request.Form("case_province") & "'"
            strSQL2 = strSQL2 & " ,summary = '" & Request.Form("summary") & "'"
            strSQL2 = strSQL2 & " ,case_status = '" & Request.Form("case_status") & "'"
            strSQL2 = strSQL2 & " ,remark = '" & Request.Form("remark") & "'"
            strSQL2 = strSQL2 & " ,update_date = '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "'"
            strSQL2 = strSQL2 & " ,update_by = '" & Session("strGID") & "'"
            strSQL2 = strSQL2 & " WHERE case_id = '" & case_id & "'"


            objCmd = New MySqlCommand(strSQL2, objConn)
            With objCmd
                .Connection = objConn
                .CommandText = strSQL2
                .CommandType = CommandType.Text
            End With

            objCmd.ExecuteNonQuery()

            objConn.Close()
            objConn = Nothing

        Catch ex As Exception

        End Try

        Response.Redirect("case_detail.aspx?case_id=" & Encrypt(case_id) & "&updated=y")

    End Sub

    Sub BindGridView()
        Dim strFid = Decrypt(Request.QueryString("case_id"))

        Dim objConn As MySqlConnection
        Dim strConnString, strSQL As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT docid, docname, filename, case_id, create_date FROM attachment where enable='T' and case_id='" & strFid & "' order by create_date"

        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable
        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        '*** BindData to GridView ***'
        GridView.DataSource = dt
        GridView.DataBind()

        Dim Total As Integer
        Total = dt.Rows.Count + 0

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing
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

    Sub DropDownCaseType()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, case_typename FROM case_type where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.case_type
            .DataSource = dt
            .DataTextField = "case_typename"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        case_type.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        case_type.SelectedIndex = case_type.Items.IndexOf(case_type.Items.FindByValue(0))  '*** By DataValueField ***'

    End Sub

    Sub DropDownCaseObjective()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, objective_name FROM case_objective where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.case_objective
            .DataSource = dt
            .DataTextField = "objective_name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        case_objective.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        case_objective.SelectedIndex = case_objective.Items.IndexOf(case_objective.Items.FindByValue(0))  '*** By DataValueField ***'

    End Sub

    Sub DropDownCustomerType()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, customer_typename FROM customer_type where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.customer_type
            .DataSource = dt
            .DataTextField = "customer_typename"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        customer_type.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        customer_type.SelectedIndex = customer_type.Items.IndexOf(customer_type.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownPolitical_party()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, Political_partyname FROM Political_party where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.political_party
            .DataSource = dt
            .DataTextField = "Political_partyname"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        political_party.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        political_party.SelectedIndex = political_party.Items.IndexOf(political_party.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownMHR_type()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, mhr_typename FROM mhr_type where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.mhr_type
            .DataSource = dt
            .DataTextField = "mhr_typename"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        mhr_type.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        mhr_type.SelectedIndex = mhr_type.Items.IndexOf(mhr_type.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownPolitical_type()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, Political_typename FROM Political_type where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.political_type
            .DataSource = dt
            .DataTextField = "Political_typename"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        political_type.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        political_type.SelectedIndex = political_type.Items.IndexOf(political_type.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownContactProvince()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, name_th FROM province order by name_th"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.contact_province
            .DataSource = dt
            .DataTextField = "name_th"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        contact_province.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        contact_province.SelectedIndex = contact_province.Items.IndexOf(contact_province.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownCaseProvince()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, name_th FROM province order by name_th"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.case_province
            .DataSource = dt
            .DataTextField = "name_th"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        case_province.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        case_province.SelectedIndex = case_province.Items.IndexOf(case_province.Items.FindByValue(0))  '*** By DataValueField ***'
    End Sub

    Sub DropDownCaseStatus()
        Dim objConn As MySqlConnection
        Dim dtAdapter As MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "SELECT id, status_name FROM case_status where enable='T' order by id"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        dtAdapter = Nothing
        objConn.Close()
        objConn = Nothing

        '*** DropDownlist ***'
        With Me.case_status
            .DataSource = dt
            .DataTextField = "status_name"
            .DataValueField = "Id"
            .DataBind()
        End With

        '*** Default Value ***'
        case_status.Items.Insert(0, New ListItem("-- โปรดเลือก --", "0"))
        case_status.SelectedIndex = case_status.Items.IndexOf(case_status.Items.FindByValue(0))  '*** By DataValueField ***'
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

    Function SetFilename(str)
        Dim newfilename As String = str.replace("+", "_").replace(" ", "_").replace("!", "_").replace("@", "_").replace("#", "_").replace("$", "_").replace("%", "_").replace("^", "_").replace("&", "_").replace("*", "_").replace("-", "_").replace("<", "_").replace(">", "_").replace("?", "_").replace("'", "_").replace("/", "_").replace("\", "_").replace("'", "_").replace(";", "_")
        Return newfilename
    End Function


    Private Sub BindGrid(Optional ByVal searchname1 As String = Nothing, Optional ByVal searchsurname1 As String = Nothing)

        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "Select contact.ID, contact.name, contact.surname, contact.phone, contact.email, customer_type.customer_typename FROM contact Left OUTER JOIN customer_type ON contact.customer_type = customer_type.id where contact.enable = 'T' "
        If Not String.IsNullOrEmpty(searchname1) Then
            strSQL = strSQL & " and contact.name like '%" & searchname1 & "%' "
        End If
        If Not String.IsNullOrEmpty(searchsurname1) Then
            strSQL = strSQL & " and contact.surname like '%" & searchsurname1 & "%' "
        End If
        strSQL = strSQL & " order by contact.name"

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)
        GridView1.DataSource = dt
        GridView1.DataBind()

        Dim FilterRecord As Integer = dt.Rows.Count

        lbFilterRecord.Text = " พบ " & FilterRecord & " รายการ"

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing
        '*** BindGrid to GridView ***'

    End Sub

    Protected Sub Search(ByVal sender As Object, ByVal e As EventArgs)
        BindGrid(name1.Text, surname1.Text)
    End Sub

    Protected Sub OnPageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        GridView1.PageIndex = e.NewPageIndex
        BindGrid(name1.Text, surname1.Text)
    End Sub


    Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        If e.CommandName = "Select" Then
            'Determine the RowIndex of the Row whose Button was clicked.
            Dim rowIndex As Integer = Convert.ToInt32(e.CommandArgument)

            'Fetch value of id.
            Dim contactid As String = GridView1.Rows(rowIndex).Cells(1).Text

            Dim objConn As MySqlConnection
            Dim dtAdapter As New MySqlDataAdapter
            Dim dt3 As New DataTable

            Dim strConnString, strSQL As String
            strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
            objConn = New MySqlConnection(strConnString)
            objConn.Open()

            strSQL = "Select contact.ID, contact.name, contact.surname, contact.phone, contact.email, customer_type.customer_typename FROM contact Left OUTER JOIN customer_type ON contact.customer_type = customer_type.id where contact.enable = 'T' and contact.id='" & contactid & "'"

            dtAdapter = New MySqlDataAdapter(strSQL, objConn)
            dtAdapter.Fill(dt3)
            GridView2.DataSource = dt3
            GridView2.DataBind()

            'Response.Redirect("sql.aspx?sql=" & strSQL)

            dtAdapter = Nothing

            objConn.Close()
            objConn = Nothing

            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "HidePopup", "$('#Modal1').modal('hide')", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "ClickButton", "$('#btnupdate').click()", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "setcontactid", "$('#contact_id').val('" & contactid & "')", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "SetVcontactid", "ValidatorEnable($('[id*=Vcontact_id]')[0], true)", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "showConceal", "$('#show_conceal').fadeIn()", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "hideContactDetail", "$('#show_contactdetail').hide()", True)

        End If

    End Sub

    Sub SaveContact()
        ' Get contact_id#################################################
        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt, dt2 As New DataTable

        Dim strConnString, strSQL1, strSQL2, strSQL3, strSQL4, tmp_contactid, contactid As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL1 = "SELECT contact_id from case_config"
        dtAdapter = New MySqlDataAdapter(strSQL1, objConn)
        dtAdapter.Fill(dt)

        tmp_contactid = dt.Rows(0)("contact_id").ToString + 1
        contactid = "C65" & Format(dt.Rows(0)("contact_id").ToString + 1, "0000")


        Dim objCmd As MySqlCommand
        strSQL2 = "UPDATE case_config SET contact_id = '" & tmp_contactid & "'"

        objCmd = New MySqlCommand(strSQL2, objConn)
        With objCmd
            .Connection = objConn
            .CommandText = strSQL2
            .CommandType = CommandType.Text
        End With

        objCmd.ExecuteNonQuery()

        ' Save new contact#################################################
        strSQL3 = "insert into contact(id, customer_type, political_party, mhr_type, political_type, titlename, name, surname, phone, email, lineid, contact_province, enable, create_date, create_by) value ('" & contactid & "', '" & Request.Form("customer_type") & "', '" & Request.Form("political_party") & "', '" & Request.Form("mhr_type") & "', '" & Request.Form("political_type") & "', '" & Request.Form("titlename") & "', '" & Request.Form("contactname") & "', '" & Request.Form("contactsurname") & "', '" & Request.Form("phone") & "', '" & Request.Form("email") & "', '" & Request.Form("lineid") & "', '" & Request.Form("contact_province") & "', 'T', '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "', '" & Session("strGID") & "')"

        objCmd = New MySqlCommand(strSQL3, objConn)
        With objCmd
            .Connection = objConn
            .CommandText = strSQL3
            .CommandType = CommandType.Text
        End With

        objCmd.ExecuteNonQuery()


        strSQL4 = "Select contact.ID, contact.name, contact.surname, contact.phone, contact.email, customer_type.customer_typename FROM contact Left OUTER JOIN customer_type ON contact.customer_type = customer_type.id where contact.enable = 'T' and contact.id='" & contactid & "'"

        dtAdapter = New MySqlDataAdapter(strSQL4, objConn)
        dtAdapter.Fill(dt2)
        GridView2.DataSource = dt2
        GridView2.DataBind()

        dtAdapter = Nothing

        objConn.Close()
        objConn = Nothing

        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "HidePopup", "$('#Modal1').modal('hide')", True)
        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "ClickButton", "$('#btnupdate').click()", True)
        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "setcontactid", "$('#contact_id').val('" & contactid & "')", True)
        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "SetVcontactid", "ValidatorEnable($('[id*=Vcontact_id]')[0], true)", True)
        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "showConceal", "$('#show_conceal').fadeIn()", True)
        ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "hideContactDetail", "$('#show_contactdetail').hide()", True)

    End Sub

    Sub modDeleteCommand(sender As Object, e As GridViewDeleteEventArgs)

        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "update attachment set enable='F' WHERE docid = '" & GridView.DataKeys.Item(e.RowIndex).Value & "'"
        objCmd = New MySqlCommand(strSQL, objConn)
        objCmd.ExecuteNonQuery()

        objConn.Close()
        objConn = Nothing

        BindGridView()

    End Sub

    Protected Sub OnRowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim Filename As String = e.Row.Cells(2).Text
            For Each button As Button In e.Row.Cells(3).Controls.OfType(Of Button)()
                If button.CommandName = "Delete" Then
                    button.Attributes("onclick") = "if(!confirm('ลบไฟล์นี้ทันที คุณแน่ใจหรือไม่" & Filename & "?')){ return false; };"
                End If
            Next
        End If
    End Sub

    Sub getjob()
        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "update case_inbox set status='T', received_by='" & Session("strGid") & "', received_date='" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "' WHERE case_id = '" & Decrypt(Request.QueryString("case_id")) & "'"
        objCmd = New MySqlCommand(strSQL, objConn)
        objCmd.ExecuteNonQuery()

        objConn.Close()
        objConn = Nothing

        Response.Redirect("case_detail.aspx?case_id=" & Request.QueryString("case_id"))

    End Sub

    Sub save_mergecase()
        Dim objConn As MySqlConnection
        Dim objCmd As MySqlCommand

        Dim strConnString, strSQL As String
        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "update case_inbox set case_code='" & Request.Form("case_code") & "' WHERE case_id = '" & Decrypt(Request.QueryString("case_id")) & "'"
        objCmd = New MySqlCommand(strSQL, objConn)
        objCmd.ExecuteNonQuery()

        objConn.Close()
        objConn = Nothing

        BindData()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPopup2", "ShowPopup2();", True)

    End Sub

    Sub DeleteCase()
        Dim objConn As MySqlConnection
        Dim strConnString, strSQL As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        strSQL = "update case_inbox set enable='F' WHERE case_id = '" & Decrypt(Request.QueryString("case_id")) & "'"

        Dim objCmd As MySqlCommand
        objCmd = New MySqlCommand(strSQL, objConn)
        objCmd.ExecuteNonQuery()

        objConn.Close()
        objConn = Nothing

        Response.Redirect("case.aspx")

    End Sub

End Class