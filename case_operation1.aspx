<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="case_operation1.aspx.vb" Inherits="opm1111.case_operation1" %>
<%@ Register Src="header2.ascx" TagName="MyUserControl" TagPrefix="inc1" %>
<%@ Register Src="footer2.ascx" TagName="MyUserControl" TagPrefix="inc2" %>
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
        <div class="card text-dark bg-white mx-auto col-lg-7 col-sm-12 border-primary">  
            <div class="card-header bg-success">
                <div class="d-flex justify-content-between">
                    <h2><i class="bi bi-journal-text"></i> การดำเนินการ</h2>
                </div>
            </div>
            <div class="card-body">
                <asp:DataList runat="server" ID="listview1">
                    <ItemTemplate>
                        <div class="d-flex"><h6>รหัสเรื่อง : &nbsp;</h6><%#Eval("casecode") %></div>
                        <div class="d-flex"><h6>ประเภทเรื่อง : &nbsp;</h6><%#Eval("casetype") %></div>
                        <div class="d-flex"><h6>สถานะเรื่อง : &nbsp;</h6><%#Eval("statusname") %>&nbsp;<h6>ปรับปรุงล่าสุดเมื่อวันที่ :&nbsp; </h6><%#Eval("update_date") %></div>
                        <div class="d-flex"><h6>สรุปผลการพิจารณา : &nbsp;</h6><%#Eval("summaryresult") %></div>
                    </ItemTemplate>
                </asp:DataList>

                <div class="container mt-6 mb-3 ">
                    <div class="row">
		                <div class="col-md-12">
			                <ul class="timeline">
                                <asp:Repeater id="listview2" runat="server">
                                    <ItemTemplate>
				                        <li>
					                        วันที่ &nbsp;<%#FormatDateTime(Eval("create_date"), 1) %>
					                        <p class="text-primary"><%# Eval("create_by") %>&nbsp; <%# Eval("oper_type") %>&nbsp;<%# Eval("receiver_by") %>&nbsp;<%# Eval("oper_objective") %></p>
                                            <p><%# Eval("detail") %></p>
				                        </li>
                                    </ItemTemplate>
	                            </asp:Repeater>
			                </ul>
		                </div>
	                </div>
                </div>
            </div>
        </div>
        <!-- End Content -->
        <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
        <!-- Footer  -->
        <script src="bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
