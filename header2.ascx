<script runat="server">
    Sub Page_Load(Sender As Object, e As EventArgs)
        Dim intNumber As Integer = Application("ActiveUsers")
        Me.lbUseronline.Text = intNumber
        Me.lbUser.Text = Session("strUser")
    End Sub
</script>
<asp:ScriptManager ID="ScriptManager1" runat="server"/>
  <!-- NAV bar -->
<nav class="navbar fixed-top navbar-expand-md navbar-light bg-primary shadow">
    <div class="container-fluid">
        <a class="navbar-brand text-white" href="case1.aspx">
            <img src="images/pmlogo.png" alt="" width="60" height="60">
        </a>
        <div class="nav-item">
            <p class="my-0" style="font-size: 16px;">ระบบจัดการข้อปรึกษาหารือของสมาชิกสภาผู้แทนราษฎร</p>
            <p class="my-0" style="font-size: 13px;">Consultation Management System for Members of the House of Representatives (C4M)</p>
        </div>
        <div class="collapse navbar-collapse" id="navbarScroll">
            <ul class="navbar-nav me-auto my-2 my-lg-0 navbar-nav-scroll" style="--bs-scroll-height: 100px;">
                <%If Session("strUser") <> "" Then %>
                    <li class="nav-item">
                        <a class="nav-link" href="case1.aspx"><i class="bi bi-briefcase text-white"></i> ข้อปรึกษาหารือ</a>
                    </li>

                    <%--<%If Session("strRole") = "2" Then %>--%>
                    <li class="nav-item">
                        <a class="nav-link" href="newcase1.aspx"><i class="bi bi-file-earmark-plus text-white"></i> เพิ่มข้อปรึกษาหารือ</a>
                    </li>
                    <%--<%End if %>--%>

                    <li class="nav-item">
                        <a class="nav-link" href="report0.aspx"><i class="bi bi-journal-richtext text-white"></i>  รายงาน</a>
                    </li>

                    <%--<%If Session("strRole") = "3" Then %>--%>
                    <li class="nav-item">
                        <a class="nav-link" href="setting1.aspx"><i class="bi bi-gear text-white"></i>  ตั้งค่าระบบ</a>
                    </li>
                    <%--<%End if %>--%>

                    <li class="nav-item">
                        <a class="nav-link" href="index1.aspx"><i class="bi bi-gear text-white"></i>  ทดสอบ</a>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarScrollingDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-grid-3x3-gap text-white"></i> 
                            <asp:Label ID="lbUser" runat="server"></asp:Label>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarScrollingDropdown">
                            <li><a class="dropdown-item" href="gmember_edit.aspx"><i class="bi bi-journal-richtext"></i> ข้อมูลผู้ใช้งาน </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.aspx"><i class="bi bi-x-circle-fill"></i> ออกจากระบบ </a></li>
                        </ul>
                    </li>
                <%End if %>
            </ul>
        </div>
        <span class="navbar-text">
            <span class="badge rounded-pill bg-light text-primary">      
                <asp:UpdatePanel ID="UpdateSession" runat="server">
                    <ContentTemplate>
                                Rf. <%=FormatDateTime(Now.AddMinutes(15),4)%>
                        <asp:Timer ID="SessionTimer" runat="server" Interval="1020000"/>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <i class="bi bi-wifi-2"></i> 
                <asp:Label ID="lbUseronline" runat="server"></asp:Label>
            </span>
        </span>
    </div>
</nav>
<!--End NAV bar -->
 <br />  <br />  <br />