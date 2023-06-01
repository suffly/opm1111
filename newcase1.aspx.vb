Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO
Public Class newcase1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Buffer = True

        If Session("strUser") = "" Then
            Response.Redirect("index.aspx")
            Response.End()
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
    End Sub

    Sub btnSave_Click()
        Try
            ' Get case_id#################################################
            Dim objConn As MySqlConnection
            Dim dtAdapter As New MySqlDataAdapter
            Dim dt As New DataTable

            Dim strConnString, strSQL1, strSQL2, strSQL3, strSQL4, tmp_case_id, case_id As String

            strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

            objConn = New MySqlConnection(strConnString)
            objConn.Open()

            strSQL1 = "SELECT case_id from case_config"
            dtAdapter = New MySqlDataAdapter(strSQL1, objConn)
            dtAdapter.Fill(dt)

            tmp_case_id = dt.Rows(0)("case_id").ToString + 1
            case_id = "65" & Format(dt.Rows(0)("case_id").ToString + 1, "0000")


            Dim objCmd As MySqlCommand
            strSQL2 = "UPDATE case_config SET case_id = '" & tmp_case_id & "'"

            objCmd = New MySqlCommand(strSQL2, objConn)
            With objCmd
                .Connection = objConn
                .CommandText = strSQL2
                .CommandType = CommandType.Text
            End With

            objCmd.ExecuteNonQuery()


            ' Get the HttpFileCollection##############################################
            Dim hfc As HttpFileCollection = Request.Files
            For i As Integer = 0 To hfc.Count - 1
                'Upload File
                Dim hpf As HttpPostedFile = hfc(i)
                If hpf.ContentLength > 0 Then
                    Dim strdate = Now()
                    Dim strfilename = strdate.Day() & strdate.Month() & strdate.Year() & strdate.Hour() & strdate.Minute() & strdate.Second()
                    Dim savefilename As String = strfilename & SetFilename(System.IO.Path.GetFileName(hpf.FileName))
                    hpf.SaveAs(Server.MapPath("UploadFiles") & "\" & savefilename)
                    'Response.Write("<b>File: </b>" & hpf.FileName & " <b>Size:</b> " & hpf.ContentLength & " <b>Type:</b> " & hpf.ContentType & " Uploaded Successfully <br/>")

                    'Insert to DB
                    strSQL3 = "insert into attachment(Docname, Filename, Doctype, case_id, enable, create_by, create_date) values('" & hpf.FileName & "', '" & savefilename & "', '" & hpf.ContentType & "', '" & case_id & "', 'T', '" & Session("strGID") & "', '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "')"


                    objCmd = New MySqlCommand(strSQL3, objConn)
                    With objCmd
                        .Connection = objConn
                        .CommandText = strSQL3
                        .CommandType = CommandType.Text
                    End With

                    objCmd.ExecuteNonQuery()

                End If

            Next i

            'Save content to Database##############################################
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


            strSQL4 = "insert into case_inbox(case_id, doc_number,"
            strSQL4 = strSQL4 & " doc_date,"
            strSQL4 = strSQL4 & " consult_date,"
            strSQL4 = strSQL4 & " case_type, contact, contact_id, conceal, channel_id, case_objective, fast_level, case_province, summary, remark, create_date, create_by, case_status, status, enable, update_date, update_by)"
            strSQL4 = strSQL4 & " values('" & case_id & "', '" & Request.Form("doc_number") & "',"
            strSQL4 = strSQL4 & " '" & doc_date & "',"
            strSQL4 = strSQL4 & " '" & consult_date & "',"
            strSQL4 = strSQL4 & " '" & Request.Form("case_type") & "', '" & Request.Form("contact") & "', '" & Request.Form("contact_id") & "', '" & Request.Form("conceal") & "', '" & Request.Form("channel") & "', '" & Request.Form("case_objective") & "', '" & Request.Form("fast_level") & "', '" & Request.Form("case_province") & "', '" & Request.Form("summary") & "', '" & Request.Form("remark") & "', '" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "', '" & Session("strGID") & "', '" & Request.Form("case_status") & "', 'F', 'T','" & Now.Year() & "-" & Now.Month() & "-" & Now.Day() & " " & Now.Hour() & ":" & Now.Minute() & ":" & Now.Second() & "', '" & Session("strGID") & "')"

            'Response.Redirect("sql.aspx?sql=" & strSQL4)
            'Response.End()

            objCmd = New MySqlCommand(strSQL4, objConn)
            With objCmd
                .Connection = objConn
                .CommandText = strSQL4
                .CommandType = CommandType.Text
            End With

            objCmd.ExecuteNonQuery()

            objConn.Close()
            objConn = Nothing

            Response.Redirect("case.aspx?case_code=" & case_id & "&saved=y")

        Catch ex As Exception

        End Try

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
        Me.case_status.Text = "2"
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
            Dim dt As New DataTable

            Dim strConnString, strSQL As String
            strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString
            objConn = New MySqlConnection(strConnString)
            objConn.Open()

            strSQL = "Select contact.ID, contact.name, contact.surname, contact.phone, contact.email, customer_type.customer_typename FROM contact Left OUTER JOIN customer_type ON contact.customer_type = customer_type.id where contact.enable = 'T' and contact.id='" & contactid & "'"

            dtAdapter = New MySqlDataAdapter(strSQL, objConn)
            dtAdapter.Fill(dt)
            GridView2.DataSource = dt
            GridView2.DataBind()

            dtAdapter = Nothing

            objConn.Close()
            objConn = Nothing

            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "HidePopup", "$('#Modal1').modal('hide')", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "ClickButton", "$('#btnupdate').click()", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "setcontactid", "$('#contact_id').val('" & contactid & "')", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "SetVcontactid", "ValidatorEnable($('[id*=Vcontact_id]')[0], true)", True)
            ScriptManager.RegisterStartupScript(Me, Me.[GetType](), "showConceal", "$('#show_conceal').fadeIn()", True)

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

    End Sub



End Class