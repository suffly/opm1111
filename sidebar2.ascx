<script runat="server">
    Sub Page_Load(Sender As Object, e As EventArgs)
        Dim intNumber As Integer = Application("ActiveUsers")
        Me.lbUseronline.Text = intNumber
        Me.lbUser.Text = Session("strUser")
    End Sub
</script>

<asp:ScriptManager ID="ScriptManager2" runat="server"/>

<div class="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark" style="width: 280px;">
        <a href="#" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">

            <span class="fs-4">Sidebar</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="#" class="nav-link active">
                    
                    Home
                </a>
            </li>
            <li>
                <a href="#" class="nav-link text-white">
                    
                    Dashboard
                </a>
            </li>

        </ul>
        <hr>
       <span class="badge rounded-pill bg-light text-primary bi bi-record2">Online: <asp:Label ID="lbUseronline" runat="server"></asp:Label></span>
        <div class="dropdown">
            <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="https://github.com/mdo.png" alt="" width="32" height="32" class="rounded-circle me-2">
                <strong><asp:Label runat="server" ID="lbUser"></asp:Label></strong>
            </a>
            <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser1">
                <li><a class="dropdown-item" href="#">Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="logout.aspx">Sign out</a></li>
            </ul>
        </div>
    <div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
            <span class="badge badge-primary">Refresh <%=FormatDateTime(Now.AddMinutes(15), 4)%></span>
            <asp:Timer ID="Timer1" runat="server" Interval="1020000"/>
            </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>




