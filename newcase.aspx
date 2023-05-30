<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="MySql.Data.MySqlClient"%>
<%@ Import Namespace="System.Security.Cryptography"%>
<%@ Import Namespace="System.IO"%>
<%@ Page Language="VB" ContentType="text/html" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

    <script runat="server">
        Sub Page_Load(sender As Object, e As EventArgs)

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

    </script>
   


<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="images/c4mlogo.png" type="image/png" />
    <title> C4M</title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap.css" rel="stylesheet">

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style1.css">
    <link href="sidebars.css" rel="stylesheet">

    <!-- Jquery -->
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>

  <!-- Icon-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">


 <!-- Jquery DatePicker -->
          <link rel="stylesheet" href="jquery.datetimepicker.css">
    <script src="jquery.datetimepicker.full.js"></script>
    <script type="text/javascript">   
        $(function () {

            $.datetimepicker.setLocale('th'); // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.


            // กรณีใช้แบบ input
            $("#datepicker").datetimepicker({
                timepicker: false,
                format: 'd/m/Y',  // กำหนดรูปแบบวันที่ ที่ใช้ เป็น 00-00-0000            
                lang: 'th',  // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.
                onSelectDate: function (dp, $input) {
                    var yearT = new Date(dp).getFullYear() - 0;
                    var yearTH = yearT + 543;
                    var fulldate = $input.val();
                    var fulldateTH = fulldate.replace(yearT, yearTH);
                    $input.val(fulldateTH);
                },
            });
            // กรณีใช้กับ input ต้องกำหนดส่วนนี้ด้วยเสมอ เพื่อปรับปีให้เป็น ค.ศ. ก่อนแสดงปฏิทิน
            $("#datepicker").on("mouseenter mouseleave", function (e) {
                var dateValue = $(this).val();
                if (dateValue != "") {
                    var arr_date = dateValue.split("/"); // ถ้าใช้ตัวแบ่งรูปแบบอื่น ให้เปลี่ยนเป็นตามรูปแบบนั้น
                    // ในที่นี้อยู่ในรูปแบบ 00-00-0000 เป็น d-m-Y  แบ่งด่วย - ดังนั้น ตัวแปรที่เป็นปี จะอยู่ใน array
                    //  ตัวที่สอง arr_date[2] โดยเริ่มนับจาก 0 
                    if (e.type == "mouseenter") {
                        var yearT = arr_date[2] - 543;
                    }
                    if (e.type == "mouseleave") {
                        var yearT = parseInt(arr_date[2]) + 543;
                    }
                    dateValue = dateValue.replace(arr_date[2], yearT);
                    $(this).val(dateValue);
                }
            });


            // กรณีใช้แบบ input
            $("#datepicker2").datetimepicker({
                timepicker: false,
                format: 'd/m/Y',  // กำหนดรูปแบบวันที่ ที่ใช้ เป็น 00-00-0000            
                lang: 'th',  // ต้องกำหนดเสมอถ้าใช้ภาษาไทย และ เป็นปี พ.ศ.
                onSelectDate: function (dp, $input) {
                    var yearT = new Date(dp).getFullYear() - 0;
                    var yearTH = yearT + 543;
                    var fulldate = $input.val();
                    var fulldateTH = fulldate.replace(yearT, yearTH);
                    $input.val(fulldateTH);
                },
            });
            // กรณีใช้กับ input ต้องกำหนดส่วนนี้ด้วยเสมอ เพื่อปรับปีให้เป็น ค.ศ. ก่อนแสดงปฏิทิน
            $("#datepicker2").on("mouseenter mouseleave", function (e) {
                var dateValue = $(this).val();
                if (dateValue != "") {
                    var arr_date = dateValue.split("/"); // ถ้าใช้ตัวแบ่งรูปแบบอื่น ให้เปลี่ยนเป็นตามรูปแบบนั้น
                    // ในที่นี้อยู่ในรูปแบบ 00-00-0000 เป็น d-m-Y  แบ่งด่วย - ดังนั้น ตัวแปรที่เป็นปี จะอยู่ใน array
                    //  ตัวที่สอง arr_date[2] โดยเริ่มนับจาก 0 
                    if (e.type == "mouseenter") {
                        var yearT = arr_date[2] - 543;
                    }
                    if (e.type == "mouseleave") {
                        var yearT = parseInt(arr_date[2]) + 543;
                    }
                    dateValue = dateValue.replace(arr_date[2], yearT);
                    $(this).val(dateValue);
                }
            });

        });
    </script>

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


     <!--validateFileSize-->
    <script type="text/javascript">
        function upload(sender, args) {
            args.IsValid = true;
            var maxFileSize = 10 * 1024 * 1024; // 10MB
            var CurrentSize = 0;
            var fileUpload = $("[id$='FileUpload1']");
            for (var i = 0; i < fileUpload[0].files.length; i++) {
                CurrentSize = CurrentSize + fileUpload[0].files[i].size;
            }
            args.IsValid = CurrentSize < maxFileSize;
        }
    </script>


    <script>
        $(document).ready(function () {
            $("input[type='radio']").change(function () {
                if ($(this).val() == "T") {
                    $("#customer_type").removeAttr("disabled");
                    $("#political_type").removeAttr("disabled");
                    $("#political_party").removeAttr("disabled");
                    $("#mhr_type").removeAttr("disabled");
                    $("#conceal").removeAttr("disabled");
                    $("#titlename").removeAttr("disabled");
                    $("#contactname").removeAttr("disabled");
                    $("#contactsurname").removeAttr("disabled");
                    $("#phone").removeAttr("disabled");
                    $("#email").removeAttr("disabled");
                    $("#LineID").removeAttr("disabled");
                    $("#contact_province").removeAttr("disabled");
                    $("#showsearch_contact").fadeIn();
                    if ($("#contact_id").val() != '') {
                        $("#show_conceal").fadeIn();
                        ValidatorEnable($("[id*=Vconceal]")[0], true);
                    }
                    ValidatorEnable($("[id*=Vcontact_id]")[0], true);
                    ValidatorEnable($("[id*=Vcontactname]")[0], true);
                    ValidatorEnable($("[id*=Vcontactsurname]")[0], true);
                    ValidatorEnable($("[id*=Vcustomer_type]")[0], true);
                    ValidatorEnable($("[id*=Vcontact_province]")[0], true);
                    ValidatorEnable($("[id*=Vpolitical_type]")[0], true);
                    ValidatorEnable($("[id*=Vpolitical_party]")[0], true);
                    ValidatorEnable($("[id*=Vmhr_type]")[0], true);
                    $("#customer_type").focus();
                } else {
                    $("#customer_type").attr("disabled", "disabled");
                    $("#political_type").attr("disabled", "disabled");
                    $("#political_party").attr("disabled", "disabled");
                    $("#mhr_type").attr("disabled", "disabled");
                    $("#conceal").attr("disabled", "disabled");
                    $("#titlename").attr("disabled", "disabled");
                    $("#contactname").attr("disabled", "disabled");
                    $("#contactsurname").attr("disabled", "disabled");
                    $("#phone").attr("disabled", "disabled");
                    $("#email").attr("disabled", "disabled");
                    $("#LineID").attr("disabled", "disabled");
                    $("#contact_province").attr("disabled", "disabled");
                    $('#titlename').val('');
                    $('#contactname').val('');
                    $('#contactsurname').val('');
                    $('#phone').val('');
                    $('#email').val('');
                    $('#customer_type').val('');
                    $('#contact_province').val('0');
                    $("#showsearch_contact").fadeOut();
                    $("#show_conceal").fadeOut();
                    ValidatorEnable($("[id*=Vcontact_id]")[0], false);
                    ValidatorEnable($("[id*=Vconceal]")[0], false);
                    ValidatorEnable($("[id*=Vcontactname]")[0], false);
                    ValidatorEnable($("[id*=Vcontactsurname]")[0], false);
                    ValidatorEnable($("[id*=Vcustomer_type]")[0], false);
                    ValidatorEnable($("[id*=Vcontact_province]")[0], false);
                    ValidatorEnable($("[id*=Vpolitical_type]")[0], false);
                    ValidatorEnable($("[id*=Vpolitical_party]")[0], false);
                    ValidatorEnable($("[id*=Vmhr_type]")[0], false);
                }
            });
        });
    </script>

    <script>
        $(document).ready(function () {
            $("#case_objective").change(function () {
                if ($("#case_objective").val() == "2") {
                    $("#showdatepicker2").fadeIn();
                    $("#channel option[value='3']").attr("selected", "selected");
                } else {
                    $("#showdatepicker2").fadeOut();
                }
            });

            $("#customer_type").change(function () {
                if ($("#customer_type").val() == "2") {
                    ValidatorEnable($("[id*=Vpolitical_party]")[0], true);
                    ValidatorEnable($("[id*=Vpolitical_type]")[0], true);
                    ValidatorEnable($("[id*=Vmhr_type]")[0], true);
                    $("#showparty").fadeIn();
                } else {
                    $("#showparty").fadeOut();
                    ValidatorEnable($("[id*=Vpolitical_party]")[0], false);
                    ValidatorEnable($("[id*=Vpolitical_type]")[0], false);
                    ValidatorEnable($("[id*=Vmhr_type]")[0], false);
                }
            });

        });
    </script>


</head>
<body>
    <form id="form1" runat="server">


            <!-- Header  -->
        <inc1:MyUserControl id="Header2" runat="server" />
        <!-- Header  -->

<div class="progress" id="progressbar1" >
  <div class="progress-bar progress-bar-striped progress-bar-animated"  role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%"></div>
</div>

    <!-- Content-->         
         <div class="card text-dark bg-light mx-auto col-lg-10 col-sm-12">
              
             <div class="card-header bg-warning">
     <div class="d-flex justify-content-between">
            <h2><i class="bi bi-plus-circle"></i> บันทึกเรื่องใหม่ </h2>
                </div>
  </div>
  <div class="card-body">

         <div class="row">
                  <div class="col-3">
                    <label for="doc_number">เลขที่หนังสือรับ :</label>
              <asp:TextBox ID="doc_number" runat="server" CssClass="form-control" />

                  </div>
                  <div class="col-2">
                     <label for="datepicker">ลงวันที่ลงรับ :</label>
                <asp:TextBox ID="datepicker" runat="server" CssClass="form-control" AutoCompleteType="Disabled" />
                  </div>

               <div class="col-3">
            <label for="fast_level">ความเร่งด่วน :</label>
               <asp:DropDownList ID="fast_level" runat="server" CssClass="form-select" AutoPostBack="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vfast_level" ControlToValidate="fast_level"  ErrorMessage="ความเร่งด่วน" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="Integer" ValidationGroup="v1" />  
            </div>

            </div>

      <div class="row">
           <div class="col-3">
            <label for="case_objective">ประเภทหนังสือ :</label>
              <asp:DropDownList ID="case_objective" runat="server" CssClass="form-select" AutoPostBack="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vcaseobjective" ControlToValidate="case_objective"  ErrorMessage="ประเภทหนังสือ" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="Integer" ValidationGroup="v1" />  
            </div>

               <div id="showdatepicker2" style="display:none;" class="col-2">
                     <label for="datepicker2">วันที่หารือ :</label>
                    <asp:TextBox ID="datepicker2" runat="server" CssClass="form-control" AutoCompleteType="Disabled" />
                    <h5><span class="badge bg-danger"><i class="bi bi-exclamation-triangle"></i> ชี้แจงภายใน 30 วัน นับจากวันที่รับเรื่อง</span></h5>
            </div>


  
             <div class="col-4">
            <label for="case_type">ประเภทปัญหา :</label>
               <asp:DropDownList ID="case_type" runat="server" CssClass="form-select" AutoPostBack="false">
               </asp:DropDownList>
             <asp:CompareValidator ID="Vcasetype" ControlToValidate="case_type"  ErrorMessage="ประเภทปัญหา" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="Integer"  ValidationGroup="v1" />  
            </div>

         <div class="col-3">
            <label for="channel">ช่องทาง :</label>
         <asp:DropDownList ID="channel" runat="server" CssClass="form-select" AutoPostBack="false" ></asp:DropDownList>
             <asp:CompareValidator ID="CompareValidator1" ControlToValidate="channel"  ErrorMessage="ช่องทาง" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="Integer" ValidationGroup="v1" />  
           </div>

    </div>
            

      <div class="card bg-warning bg-opacity-10">
  <div class="card-body">

      <asp:RadioButtonList ID="contact" runat="server" CssClass="form-check form-check-inline" RepeatDirection="Horizontal" CellPadding="5" >
             <asp:ListItem Value="T" Text="ระบุข้อมูลผู้ร้อง" ></asp:ListItem>
               <asp:ListItem Value="F" Text="ไม่ระบุ"></asp:ListItem>
       </asp:RadioButtonList>
      <asp:RequiredFieldValidator ID="Vcontact" runat="server" ControlToValidate="contact" ErrorMessage="ข้อมูลผู้ร้อง" Text="โปรดเลือก" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>

      <div id="hide_btnupdate" style="display:none;">
          <asp:Button runat="server" ID="btnupdate" CausesValidation="false" />
          <asp:TextBox runat="server" ID="contact_id"></asp:TextBox>
          </div>
      <asp:RequiredFieldValidator ID="Vcontact_id" runat="server" ControlToValidate="contact_id" ErrorMessage="ข้อมูลผู้ร้อง" Text="โปรดระบุข้อมูลผู้ร้อง" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1" ></asp:RequiredFieldValidator>

      <div id="showsearch_contact" style="display:none;">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#Modal1">เพิ่มผู้ร้องเรียน</button>
          
       <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
          <ContentTemplate>
              <asp:GridView ID="GridView2" runat="server" CssClass="table table-hover bg-light" AutoGenerateColumns="false" >
                   <Columns>
                <asp:BoundField DataField="id" HeaderText="id" ItemStyle-Width="5%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="name" HeaderText="ชื่อ" ItemStyle-Width="20%"  HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="surname" HeaderText="นามสกุล" ItemStyle-Width="20%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="phone" HeaderText="โทรศัพท์" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="email" HeaderText="อีเมล" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="customer_typename" HeaderText="ประเภทผู้ร้อง" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                        </Columns>
              </asp:GridView>
    </ContentTemplate>
            <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnupdate" EventName="click" />
        </Triggers>
        </asp:UpdatePanel>
      </div>

      <div id="show_conceal" style="display:none;">
          <div class="col-2">
                       <label for="conceal">ปกปิดข้อมูลผู้ร้องหรือไม่ :</label>
               <asp:DropDownList ID="conceal" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="true" >
                   <asp:ListItem Value="0">--- โปรดเลือก ---</asp:ListItem>
                   <asp:ListItem Value="T">ปกปิด</asp:ListItem>
                    <asp:ListItem Value="F">เปิดเผย</asp:ListItem>
               </asp:DropDownList>
             <asp:CompareValidator ID="Vconceal" ControlToValidate="conceal" ErrorMessage="การปกปิดข้อมูล" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v1" />  
                      </div>
      </div>

</div></div>

 
            <div class="row">
                  <div class="col-3">
                       <label for="case_province">จังหวัดพื้นที่ปัญหา :</label>
               <asp:DropDownList ID="case_province" runat="server" CssClass="form-select" AutoPostBack="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vcase_province" ControlToValidate="case_province" ErrorMessage="จังหวัดพื้นที่ปัญหา" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v1" />  
                      </div>

                  <div class="col">
                    <label for="summary">สาระสำคัญของเรื่อง :</label>
              <asp:TextBox ID="summary" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"  />
              <asp:RequiredFieldValidator ID="Vsummary" runat="server" ControlToValidate="summary" ErrorMessage="สาระสำคัญของเรื่อง" Text="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                  </div>
            </div>

      <div class="alert alert-primary" role="alert">
      <label for="FileUpload1">เอกสารประกอบ : 100 MB/Total</label>
      <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" CssClass="form-control" />
            <asp:Label ID="Label1" runat="server" />
           <asp:RequiredFieldValidator ID="VFileupload" runat="server" ControlToValidate="FileUpload1" ErrorMessage="โปรดแนบไฟล์เอกสาร" Display="Dynamic" ForeColor="#FF0000"  ValidationGroup="v1" ></asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationExpression="(.)+(.pdf|.PDF)$" ControlToValidate="FileUpload1" runat="server" ForeColor="Red" ErrorMessage="แนบได้เฉพาะไฟล์ .pdf" Display="Dynamic" />
          <asp:CustomValidator ControlToValidate="FileUpload1" ClientValidationFunction="upload" runat="server" ErrorMessage="แต่ละไฟล์ต้องมีขนาดไม่เกิน 10 MB" ForeColor="Red" Display="Dynamic" />

      </div>

        <div class="row">

                 <div class="col-3">
                       <label for="case_province">สถานะของเรื่อง :</label>
               <asp:DropDownList ID="case_status" runat="server" CssClass="form-select" AutoPostBack="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vcase_status" ControlToValidate="case_status" ErrorMessage="สถานะของเรื่อง" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v1" />  
           </div>

                  <div class="col">
                    <label for="remark">หมายเหตุ :</label>
              <asp:TextBox ID="remark" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                  </div>
            </div>

      </div>

               <div class="card-footer">
                   <div class="d-flex p-0 justify-content-center">
                   <asp:Button ID="btnSave" runat="server" Text="บันทึกข้อมูล" CssClass="btn-success btn-lg" onclick="btnSave_Click" CausesValidation="true" ValidationGroup="v1" />
                       </div>
                   <div> <asp:ValidationSummary id="valSum" DisplayMode="BulletList" runat="server" HeaderText="คุณกรอกข้อมูลไม่ครบถ้วน :" ForeColor="Red" ValidationGroup="v1" /></div>
               </div>
         </div>

<!-- End Content -->

              <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
             <!-- Footer  -->


<script src="bootstrap.bundle.min.js"></script>



<!-- Modal -->
<div class="modal fade" id="Modal1" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel">ฐานข้อมูลผู้ร้อง</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="alert alert-danger" role="alert">
        กรุณาค้นหาและเลือกข้อมูลผู้ร้องจากฐานข้อมูล หากไม่มี กรุณาบันทึกข้อมูลผู้ร้องใหม่
              </div>
          <div class="row">
            <div class="col-2">
                    <label for="name1">ชื่อผู้ร้อง :</label>
              <asp:TextBox ID="name1" runat="server" CssClass="form-control" ValidationGroup="V2" />
                  </div>
                  <div class="col-2">
                     <label for="surname1">นามสกุล :</label>
              <asp:TextBox ID="surname1" runat="server" CssClass="form-control" ValidationGroup="V2"/>
                  </div>
          <div class="col-2">
             <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-warning btn-md" OnClick="search" Text="ค้นหา" CausesValidation="false" ValidationGroup="V2"  />
              </div>
              </div>

              <asp:UpdateProgress ID="updateProgress1" DynamicLayout="true" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                          <div class="spinner-border text-danger" role="status">
                          <span class="visually-hidden">Loading...</span>
                        </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

      <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
          <ContentTemplate>

          <div class="d-flex p-1 bg-light justify-content-center"> 
            	 <asp:Label ID="lbFilterRecord" runat="server" ForeColor="#0000FF" Font-Bold="true" CssClass="p-1"></asp:Label>
           </div>

      <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-bordered table-sm" PageSize="5" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom" OnRowCommand="GridView1_RowCommand" >

                 <Columns>
         <asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-primary text-white text-center" >
            <ItemTemplate>
                <%# Container.DataItemIndex + 1 %>
            </ItemTemplate>
            <itemstyle HorizontalAlign="center" Width="3%" />
        </asp:TemplateField>

                       <asp:BoundField DataField="id" HeaderText="id" ItemStyle-Width="5%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="name" HeaderText="ชื่อ" ItemStyle-Width="20%"  HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="surname" HeaderText="นามสกุล" ItemStyle-Width="20%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="phone" HeaderText="โทรศัพท์" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="email" HeaderText="อีเมล" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />
                     <asp:BoundField DataField="customer_typename" HeaderText="ประเภทผู้ร้อง" ItemStyle-Width="15%" HeaderStyle-CssClass="bg-primary text-white text-center" />

            <asp:ButtonField CommandName="Select" Text="เลือก" ButtonType="Button" ItemStyle-CssClass="btn btn-link" HeaderStyle-CssClass="bg-primary text-white text-center" />

          </Columns>
      </asp:GridView>


  </ContentTemplate>
            <Triggers>
        	<asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="click" />
        </Triggers>
        </asp:UpdatePanel>

                        <hr />
                  <!-- บันทึกข้อมูลผู้้ร้องใหม่--->
              <h4>บันทึกข้อมูลผู้ร้องรายใหม่</h4>
          <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
          <ContentTemplate>
          <div class="row">
                     <div class="col-4">
                       <label for="customer_type">ประเภทผู้ร้อง :</label>
               <asp:DropDownList ID="customer_type" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vcustomer_type" ControlToValidate="customer_type" ErrorMessage="ประเภทผู้ร้อง" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v3" />  
                      </div>

        <div id="showparty" style="display:none;" class="row">
             <div class="col-4">
                       <label for="political_party">พรรค :</label>
               <asp:DropDownList ID="political_party" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vpolitical_party" ControlToValidate="political_party" ErrorMessage="พรรค" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v3" />  
                      </div>

              <div class="col-4">
                       <label for="mhr_type">ประเภทสมาชิก :</label>
               <asp:DropDownList ID="mhr_type" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vmhr_type" ControlToValidate="mhr_type" ErrorMessage="พรรค" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v3" />  
                      </div>

              <div class="col-4">
                       <label for="political_type">ฝ่ายการเมือง :</label>
               <asp:DropDownList ID="political_type" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vpolitical_type" ControlToValidate="political_type" ErrorMessage="พรรค" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v3" />  
                      </div>
       </div>
</div>

              <div class="row">
                  

                  <div class="col-2">
                    <label for="titlename">คำนำหน้า :</label>
              <asp:TextBox ID="titlename" runat="server" CssClass="form-control" Enabled="false" />
                  </div>
                  <div class="col">
                    <label for="contactname">ชื่อผู้ร้อง :</label>
              <asp:TextBox ID="contactname" runat="server" CssClass="form-control" Enabled="false"  />
              <asp:RequiredFieldValidator ID="Vcontactname" runat="server" ControlToValidate="contactname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v3"></asp:RequiredFieldValidator>
                  </div>
                  <div class="col">
                     <label for="contactsurname">นามสกุล :</label>
              <asp:TextBox ID="contactsurname" runat="server" CssClass="form-control" Enabled="false"  />
              <asp:RequiredFieldValidator ID="Vcontactsurname" runat="server" ControlToValidate="contactsurname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v3"></asp:RequiredFieldValidator>
                  </div>
       
            </div>

                <div class="row">
                      <div class="col">
                    <label for="phone">โทรศัพท์ :</label>
              <asp:TextBox ID="phone" runat="server" CssClass="form-control" Enabled="false" />
                  </div>
                  <div class="col">
                     <label for="email">อีเมล :</label>
              <asp:TextBox ID="email" runat="server" CssClass="form-control" Enabled="false" />
                  </div>
                     <div class="col">
                     <label for="LineID">Line ID :</label>
              <asp:TextBox ID="LineID" runat="server" CssClass="form-control" Enabled="false" />
                  </div>
                     <div class="col-3">
                       <label for="contact_province">พื้นที่ผู้ร้อง :</label>
               <asp:DropDownList ID="contact_province" runat="server" CssClass="form-select" AutoPostBack="false" Enabled="false" ></asp:DropDownList>
             <asp:CompareValidator ID="Vcontact_province" ControlToValidate="contact_province" ErrorMessage="พื้นที่ผู้ร้อง" Text="โปรดเลือก" runat="server" Display="Dynamic" ForeColor="#FF0000" Operator="NotEqual" ValueToCompare="0" Type="String" ValidationGroup="v3" />  
                      </div>
                </div>

          <asp:Button ID="btnSaveContact" runat="server" Text="บันทึกข้อมูล" CssClass="btn-success btn-lg" onclick="SaveContact" CausesValidation="true" ValidationGroup="v3" />

               </ContentTemplate>
</asp:UpdatePanel>
          <!-- บันทึกข้อมูลผู้้ร้องใหม่--->
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
      </div>
    </div>
  </div>
</div>

</form>

</body>
</html>
