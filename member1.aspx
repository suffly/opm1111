<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="member1.aspx.vb" Inherits="opm1111.member1" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
<%@ Register Src="menu.ascx" TagName="MyUserControl" TagPrefix="inc3" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="shortcut icon" href="images/c4mlogo.png" type="image/png" />
    <title> C4M </title>
    <!-- Bootstrap core CSS -->
    <link href="bootstrap.css" rel="stylesheet"/>
    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style1.css"/>
    <!-- Jquery -->
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>
    <!-- Icon-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css"/>
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
    <script type="text/javascript">
        function ShowPopup() {
            $('#myModal').modal('show');
        };
        function ShowPopup3() {
            $('#myModal3').modal('show');
        };
        function ShowPopup4() {
            $('#myModal4').modal('show');
        };
        function CloseModal() {
            $('#myModal').modal('hide');
        }
        function CloseModal2() {
            $('#myModal2').modal('hide');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header  -->
        <inc1:MyUserControl id="Header2" runat="server" />
        <!-- Header  -->
        <div class="container-fluid bg-light my-4"></div>
        <div class="progress" id="progressbar1" >
            <div class="progress-bar progress-bar-striped progress-bar-animated"  role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%"></div>
        </div>
        <!-- Content-->         
        <main class="container">
            <br />
            <div class="row">
                <div class="col-lg-3 col-sm-12">
                    <inc3:MyUserControl id="Menu1" runat="server" />
                </div>
                <div class="col-lg-9 col-sm-12">
                    <div class="card">
                        <h5 class="card-header bg-info text-white">ข้อมูลผู้ใช้งาน</h5>
                        <div class="card-body">
                            <asp:UpdatePanel runat="server" ID="updatepanel1">
                                <ContentTemplate>
                                    <div class="alert alert-primary" role="alert">
                                        <div class="row">
                                            <div class="col">
                                                <label for="name">ชื่อ:</label>
                                                <asp:TextBox ID="name" runat="server" placeholder="" CssClass="form-control"/>
                                            </div>
                                            <div class="col">
                                                <label for="surname">นามสกุล:</label>
                                                <asp:TextBox ID="surname" runat="server" placeholder="" CssClass="form-control"/>
                                            </div>
                                            <div class="col">
                                                <label for="username">Username:</label>
                                                <asp:TextBox ID="username" runat="server" placeholder="" CssClass="form-control"/>
                                            </div>
                                        </div>
                                        <asp:Button runat="server" ID="btnSearch" Text="ค้นหา" CssClass="btn btn-info" OnClick="search" />
                                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#myModal2">เพิ่ม +</button>
                                    </div>
                                    <asp:GridView id="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="GID" CssClass="table table-hover table-bordered table-sm" PageSize="10" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom">
	                                    <Columns>
	                                        <asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
		                                            <%# Container.DataItemIndex + 1 %>
		                                        </ItemTemplate>
	                                        </asp:TemplateField>
	                                        <asp:TemplateField HeaderText="ชื่อ - นามสกุล" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-left">
		                                        <ItemTemplate>
			                                        <asp:Label id="lblName" runat="server" Text='<%# Eval("gname") %>'></asp:Label>
                                                    <asp:Label id="lbSurname" runat="server" Text=' <%# Eval("gsurname") %>'></asp:Label>
		                                        </ItemTemplate>
	                                        </asp:TemplateField>

                                            <asp:TemplateField HeaderText="ชื่อผู้ใช้ (Username)" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
			                                        <asp:Label id="lblUsername" runat="server" Text='<%# Eval("gemail") %>'></asp:Label>&nbsp;
		                                        </ItemTemplate>
	                                        </asp:TemplateField>

                                            <asp:TemplateField HeaderText="วันที่สร้าง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
			                                        <asp:Label id="lbCreateDate" runat="server" Text='<%# Eval("gcreate_date") %>'></asp:Label>&nbsp;
		                                        </ItemTemplate>
	                                        </asp:TemplateField>

                                            <asp:TemplateField HeaderText="ดำเนินการ" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
			                                        <asp:Button Text="แก้ไข" ID="btnPreview" runat="server" OnClick="OnPreview" CommandArgument='<%#Eval("GID")%>' CssClass="btn btn-info btn-sm" CausesValidation="false"  />
                                                    <asp:Button Text="ลบ" ID="btnDelete" runat="server" OnClick="modDeleteCommand" CommandArgument='<%#Eval("GID")%>' CssClass="btn btn-danger btn-sm" CausesValidation="false" OnClientClick="if(!confirm('Are you sure?')) return false;"  />
		                                        </ItemTemplate>
	                                        </asp:TemplateField>
	                                    </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
        	                        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
                                </Triggers>
                            </asp:UpdatePanel>
                            <!-- Modal Edit User-->
                            <div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" >
                                <div class="modal-dialog modal-md modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <asp:UpdatePanel runat="server" ID="updatepanel2" UpdateMode="Always">
                                            <ContentTemplate>
                                                <div class="modal-header bg-info"><h3>แก้ไขข้อมูลผู้ใช้งาน</h3>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="container">
                                                        <div class="row">
                                                            <div class="col">
                                                                <div style="display:none;">
                                                                    <asp:TextBox ID="gid" runat="server" CssClass="form-control" />
                                                                </div>
                                                                <label for="gname">ชื่อ:</label>
                                                                <asp:TextBox ID="gname" runat="server" placeholder="" CssClass="form-control"/>
                                                                <asp:RequiredFieldValidator ID="Vgname" runat="server" ControlToValidate="gname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                                <label for="gsurname">นามสกุล:</label>
                                                                <asp:TextBox ID="gsurname" runat="server" placeholder="" CssClass="form-control" />
                                                                <asp:RequiredFieldValidator ID="Vgsurname" runat="server" ControlToValidate="gsurname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="gusername">ชื่อผู้ใช้:</label>
                                                                <asp:TextBox ID="gusername" runat="server" placeholder="" CssClass="form-control" Enabled="false" />
                                                                <asp:RequiredFieldValidator ID="Vuser" runat="server" ControlToValidate="gusername" ErrorMessage="โปรดระบุ" Display="Dynamic" ValidationGroup="v2"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                                <label for="grole">สิทธิ์การใช้งาน:</label>
                                                                <asp:DropDownList ID="grole" runat="server"  CssClass="form-group form-select"></asp:DropDownList>
                                                                <asp:CompareValidator ControlToValidate="grole" ID="Vgrole"  ErrorMessage="โปรดเลือกสิทธิ์การใช้งาน" runat="server" Display="Dynamic" Operator="NotEqual" ValueToCompare="0" Type="Integer" ForeColor="#FF0000" ValidationGroup="v2" />
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="gpassword">รหัสผ่าน:</label>
                                                                <asp:TextBox ID="gpassword" runat="server" TextMode="Password" CssClass="form-control col-6" />	
                                                                <asp:RequiredFieldValidator ID="Vpassword" runat="server" ControlToValidate="gpassword" ErrorMessage="โปรดระบุรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                            <label for="grepassword">ยืนยันรหัสผ่าน:</label>
                                                                <asp:TextBox ID="grepassword" runat="server"  TextMode="Password" CssClass="form-control col-6"/>
                                                                <asp:RequiredFieldValidator ID="Vrepassword" runat="server" ControlToValidate="grepassword" ErrorMessage="โปรดยืนยันรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
                                                                <asp:CompareValidator ID="REVrepassword" runat="server" ControlToCompare="gpassword" ControlToValidate="grepassword" ErrorMessage="การยืนยันรหัสผ่านไม่ถูกต้อง" Display="Dynamic" ForeColor="#FF0000"></asp:CompareValidator>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <asp:Button ID="btn1" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-md" CausesValidation="true" OnClick="UpdateData" ValidationGroup="v2" />
                                                    <button type="button" class="btn btn-dark" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                            <!-- Modal Edit User-->
                            <!-- Modal newcase -->
                            <div class="modal fade" id="myModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" >
                                <div class="modal-dialog modal-md modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <asp:UpdatePanel runat="server" ID="updatepanel3" UpdateMode="Always">
                                            <ContentTemplate>
                                                <div class="modal-header bg-primary"><h3>เพิ่มข้อมูลผู้ใช้งาน</h3>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="container">
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="gname1">ชื่อ:</label>
                                                                <asp:TextBox ID="gname1" runat="server" placeholder="" CssClass="form-control"/>
                                                                <asp:RequiredFieldValidator ID="Vgname1" runat="server" ControlToValidate="gname1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                                <label for="gsurname1">นามสกุล:</label>
                                                                <asp:TextBox ID="gsurname1" runat="server" placeholder="" CssClass="form-control" />
                                                                <asp:RequiredFieldValidator ID="Vgsurname1" runat="server" ControlToValidate="gsurname1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="gusername1">ชื่อผู้ใช้:</label>
                                                                <asp:TextBox ID="gusername1" runat="server" placeholder="" CssClass="form-control" Enabled="true" />
                                                                <asp:RequiredFieldValidator ID="Vgusername1" runat="server" ControlToValidate="gusername1" ErrorMessage="โปรดระบุ" Display="Dynamic" ValidationGroup="v1" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                                <label for="grole1">สิทธิ์การใช้งาน:</label>
                                                                <asp:DropDownList ID="grole1" runat="server" CssClass="form-group form-select"></asp:DropDownList>
                                                                <asp:CompareValidator ControlToValidate="grole1" ID="Vgrole1"  ErrorMessage="โปรดเลือกสิทธิ์การใช้งาน" runat="server" Display="Dynamic" Operator="NotEqual" ValueToCompare="0" Type="Integer" ForeColor="#FF0000" ValidationGroup="v1"  />
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="gpassword1">รหัสผ่าน:</label>
                                                                <asp:TextBox ID="gpassword1" runat="server" TextMode="Password" CssClass="form-control col-6" />	
                                                                <asp:RequiredFieldValidator ID="Vgpassword1" runat="server" ControlToValidate="gpassword1" ErrorMessage="โปรดระบุรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col">
                                                                <label for="grepassword1">ยืนยันรหัสผ่าน:</label>
                                                                <asp:TextBox ID="grepassword1" runat="server"  TextMode="Password" CssClass="form-control col-6"/>
                                                                <asp:RequiredFieldValidator ID="Vgrepassword1" runat="server" ControlToValidate="grepassword1" ErrorMessage="โปรดยืนยันรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                                                                <asp:CompareValidator ID="Vgrepassword2" runat="server" ControlToCompare="gpassword1" ControlToValidate="grepassword1" ErrorMessage="การยืนยันรหัสผ่านไม่ถูกต้อง" Display="Dynamic" ForeColor="#FF0000"></asp:CompareValidator>
                                                            </div>
                                                        </div>
                                                    </div>           
                                                </div>
                                                <div class="modal-footer">
                                                    <h3><asp:Label runat="server" ID="lbUserDup" CssClass="text-danger"></asp:Label></h3>
                                                    <asp:Button ID="btn3" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-md" CausesValidation="true" OnClick="newuser" ValidationGroup="v1" />
                                                    <button type="button" class="btn btn-dark" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>
</body>
</html>
