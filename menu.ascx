<nav class="nav flex-lg-column bg-info text-white">
    <a class="nav-link link-light" href="case1.aspx"><i class="fa fa-home" aria-hidden="true"></i> ˹���á </a>
    <a class="nav-link link-light" href="member1.aspx"><i class="fa fa-sticky-note-o" aria-hidden="true"></i> �����ҹ</a>
    <a class="nav-link link-light" href="partylist1.aspx"><i class="fa fa-user-circle-o" aria-hidden="true"></i> ��ä������ͧ</a>
    <a class="nav-link link-light" href="channel1.aspx"><i class="fa fa-user-circle-o" aria-hidden="true"></i> ��ͧ�ҧ</a>
    <a class="nav-link link-light" href="casetype1.aspx"><i class="fa fa-user-circle-o" aria-hidden="true"></i> ����������ͧ</a>
    <a class="nav-link link-light" href="casestatus1.aspx"><i class="fa fa-user-circle-o" aria-hidden="true"></i> ʶҹТͧ����ͧ</a>
</nav>
<div class="text-info">
    <asp:UpdatePanel ID="UpdateSession" runat="server">
        <ContentTemplate>
            <span class="badge badge-primary">Refresh <%=FormatDateTime(Now.AddMinutes(15), 4)%></span>
            <asp:Timer ID="SessionTimer" runat="server" Interval="1020000"/>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>