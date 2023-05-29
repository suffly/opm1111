<%@ Application Language="VB" %>

<script runat="server">

    Sub Application_OnStart(Sender As Object, E As EventArgs)
        ' Set user count to 0 when start the application 
        Application("ActiveUsers") = 0
    End Sub

    Sub Session_OnStart(Sender As Object, E As EventArgs)
        Application.Lock()
        Application("ActiveUsers") = CInt(Application("ActiveUsers")) + 1
        Application.UnLock()
    End Sub

    Sub Session_OnEnd(Sender As Object, E As EventArgs)
        Application.Lock()
        Application("ActiveUsers") = CInt(Application("ActiveUsers")) - 1
        Application.UnLock()
    End Sub

</script>