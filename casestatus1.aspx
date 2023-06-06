<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="casestatus1.aspx.vb" Inherits="opm1111.casestatus1" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
<%@ Register Src="menu.ascx" TagName="MyUserControl" TagPrefix="inc3" %>
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
                        <h5 class="card-header bg-info text-white">สถานะของเรื่อง</h5>
                        <div class="card-body">
                            <asp:UpdatePanel runat="server" ID="updatepanel1">
                                <ContentTemplate>
                                    <div class="alert alert-primary" role="alert">
                                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#myModal2">เพิ่ม +</button>
                                    </div>
                                    <asp:GridView id="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" CssClass="table table-hover table-bordered table-sm" PageSize="10" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10" PagerSettings-FirstPageText="|<<" PagerSettings-LastPageText=">>|" PagerSettings-PreviousPageText="<<" PagerSettings-NextPageText=">>" PagerStyle-CssClass="GridPager" PagerSettings-Position="TopAndBottom">
	                                    <Columns>   
	                                        <asp:TemplateField HeaderText="ที่" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
		                                            <%# Container.DataItemIndex + 1 %>
		                                        </ItemTemplate>
	                                        </asp:TemplateField>
	                                        <asp:TemplateField HeaderText="สถานะของเรื่อง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-left">
		                                        <ItemTemplate>
			                                        <asp:Label id="lbstatusname" runat="server" Text='<%# Eval("status_name") %>'></asp:Label>
		                                        </ItemTemplate>
	                                        </asp:TemplateField>
                                            <asp:TemplateField HeaderText="วันที่สร้าง" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
			                                        <asp:Label id="lbCreatedate" runat="server" Text='<%# Eval("create_date") %>'></asp:Label>&nbsp;
		                                        </ItemTemplate>
	                                        </asp:TemplateField>
                                            <asp:TemplateField HeaderText="ดำเนินการ" HeaderStyle-CssClass="bg-info text-white text-center" ItemStyle-CssClass="text-center">
		                                        <ItemTemplate>
			                                        <asp:Button Text="แก้ไข" ID="btnPreview" runat="server" OnClick="OnPreview" CommandArgument='<%#Eval("ID")%>' CssClass="btn btn-info btn-sm" CausesValidation="false"  />
                                                    <asp:Button Text="ลบ" ID="btnDelete" runat="server" OnClick="modDeleteCommand" CommandArgument='<%#Eval("ID")%>' CssClass="btn btn-danger btn-sm" CausesValidation="false" OnClientClick="if(!confirm('Are you sure?')) return false;"  />
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
                                                <div class="modal-header bg-info"><h3>แก้ไขสถานะเรื่อง</h3>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="container">
                                                        <div class="row">
                                                            <div class="col">
                                                                <div style="display:none;">
                                                                    <asp:TextBox ID="id" runat="server" CssClass="form-control" />
                                                                </div>
                                                                <label for="channel_name">สถานะของเรื่อง:</label>
                                                                <asp:TextBox ID="statusname" runat="server" placeholder="" CssClass="form-control"/>
                                                                <asp:RequiredFieldValidator ID="Vstatusname" runat="server" ControlToValidate="statusname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v2"></asp:RequiredFieldValidator>
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
                                                <div class="modal-header bg-primary"><h3>เพิ่มสถานะของเรื่อง</h3>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="container">
                                                        <div class="row">
                                                            <div class="col">
                                                                <label for="statusname1">สถานะของเรื่อง:</label>
                                                                <asp:TextBox ID="statusname1" runat="server" placeholder="" CssClass="form-control"/>
                                                                <asp:RequiredFieldValidator ID="Vstatusname1" runat="server" ControlToValidate="statusname1" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000" ValidationGroup="v1"></asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <asp:Button ID="btn3" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-md" CausesValidation="true" OnClick="newuser" ValidationGroup="v1" />
                                                    <button type="button" class="btn btn-dark" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                            <!-- Modal newcase-->
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!-- Modal Saved Datea-->
        <div class="modal fade" id="myModal3" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-secondary">
                        <h5 class="modal-title" id="exampleModalLabel">Message</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        จัดเก็บข้อมูลเสร็จเรียบร้อยแล้ว
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnClose2">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal Saved Datea-->
        <!-- End Content -->
        <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
        <!-- Footer  -->
        <script src="bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
