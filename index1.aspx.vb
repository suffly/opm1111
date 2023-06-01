Imports System.Data
Imports MySql.Data.MySqlClient
Imports System.Security.Cryptography
Imports System.IO

Public Class index1
    Inherits System.Web.UI.Page

    Sub login_onClick(ByVal sender As Object, ByVal e As EventArgs)
        Dim objConn As MySqlConnection
        Dim dtAdapter As New MySqlDataAdapter
        Dim dt As New DataTable
        Dim strConnString, strSQL, strSQL4 As String

        strConnString = System.Configuration.ConfigurationManager.ConnectionStrings("MyConnectionString").ConnectionString

        objConn = New MySqlConnection(strConnString)
        objConn.Open()

        'strSQL = "SELECT gid,grole,gemail FROM Gmember WHERE gemail = '" & Request.Form("gemail") & "' and gpassword='" & Request.Form("gpassword") & "' "
        strSQL = $"SELECT gid,grole,gemail FROM Gmember WHERE gemail = '{Request.Form("gemail")}' and gpassword='{Request.Form("gpassword")}' "
        'strSQL = "SELECT gid,grole,gemail FROM Gmember WHERE gemail = '" & Me.RFVgemail.ToString & "' and gpassword='" & Me.RFVgpassword.ToString & "' "
        'strSQL = "SELECT gid,grole,gemail FROM Gmember WHERE gemail = '" & RFVgemail.Text & "' and gpassword='" & Me.RFVgpassword.Text & "' "

        dtAdapter = New MySqlDataAdapter(strSQL, objConn)
        dtAdapter.Fill(dt)

        If dt.Rows.Count <> 0 Then
            Session("strUser") = Request.Form("gemail")
            Session("strRole") = dt.Rows(0)("Grole").ToString
            Session("strGID") = dt.Rows(0)("Gid").ToString

            '#############ตรวจสอบ IPaddress และ session################
            Dim strSession, strIPaddress As String
            strSession = HttpContext.Current.Session.SessionID
            strIPaddress = Request.ServerVariables("HTTP_X_FORWARDED_FOR")

            If strIPaddress = "" Or strIPaddress Is Nothing Then
                strIPaddress = Request.ServerVariables("REMOTE_ADDR")
            End If

            '############Keep Log################
            strSQL4 = "insert into user_log(SessionID, IPaddress, Gid) values('" & strSession & "', '" & strIPaddress & "', " & Session("strGID") & ")"

            Dim objCmd = New MySqlCommand()
            With objCmd
                .Connection = objConn
                .CommandType = CommandType.Text
                .CommandText = strSQL4
            End With

            objCmd.ExecuteNonQuery()
            objCmd = Nothing
            dtAdapter = Nothing
            objConn.Close()
            objConn = Nothing

            '############Login Complete################
            Response.Redirect("case1.aspx")
        Else
            dtAdapter = Nothing
            objConn.Close()
            objConn = Nothing
            Me.lbLogin.Visible = True
            Me.lbLogin.Text = "อีเมล์หรือรหัสผ่านไม่ถูกต้อง โปรดลองใหม่อีกครั้ง"
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

End Class