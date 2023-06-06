<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="gmember_edit1.aspx.vb" Inherits="opm1111.gmember_edit1" %>
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
    <%If Request.QueryString("status") = "success" Then%>
        <script type="text/javascript">
            $(window).on('load', function () {
                $('#myModal1').modal('show');
            });
        </script>
    <%End If%>
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
        <div class="card text-dark bg-light mx-auto col-lg-6 col-sm-12"> 
            <div class="card-header bg-dark">
                <div class="d-flex justify-content-between">
                    <h2><i class="bi bi-journal-text"></i> ข้อมูลผู้ใช้งาน</h2>
                </div>
            </div>
            <div class="card-body">
                <div class="row col-lg-5 col-sm-12">
                    <label for="gname">ชื่อ :</label>
                    <asp:TextBox ID="gname" runat="server" placeholder="" CssClass="form-control" Enabled="true"/>
                    <asp:RequiredFieldValidator ID="Vgname" runat="server" ControlToValidate="gname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                </div>
                <div class="row col-lg-5 col-sm-12">
                    <label for="gsurname">นามสกุล :</label>
                    <asp:TextBox ID="gsurname" runat="server" placeholder="" CssClass="form-control" enabled="true" />
                    <asp:RequiredFieldValidator ID="Vgsurname" runat="server" ControlToValidate="gsurname" ErrorMessage="โปรดระบุ" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                </div>
                <div class="row col-lg-5 col-sm-12">
                    <label for="gemail">ชื่อผู้ใช้ :</label>
                    <asp:TextBox ID="gemail" runat="server" placeholder="" CssClass="form-control" Enabled="false" />
                    <asp:RequiredFieldValidator ID="Vemail" runat="server" ControlToValidate="gemail" ErrorMessage="โปรดระบุ" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REVemail" runat="server" ErrorMessage="อีเมล์ไม่ถูกต้อง" ControlToValidate="gemail" Display="Dynamic" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </div>
                <div class="row col-lg-5 col-sm-12">
                    <label for="gpassword">รหัสผ่าน :</label>
                    <asp:TextBox ID="gpassword" runat="server" placeholder="6 อักขระขึ้นไป (มีทั้งตัวเลข และตัวอักษร)" TextMode="Password" CssClass="form-control col-6" />	
                    <asp:RequiredFieldValidator ID="Vpassword" runat="server" ControlToValidate="gpassword" ErrorMessage="โปรดระบุรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REVcheckmail" runat="server" ControlToValidate="gpassword" ErrorMessage="รหัสผ่าน 6 ตัวอักขระขึ้นไป (มีทั้งตัวเลข และตัวอักษร)" ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>
                <div class="row col-lg-5 col-sm-12">
                    <label for="grepassword">ยืนยันรหัสผ่าน :</label>
                    <asp:TextBox ID="grepassword" runat="server"  placeholder="ป้อนรหัสผ่านอีกครั้ง" TextMode="Password" CssClass="form-control col-6"/>
                    <asp:RequiredFieldValidator ID="Vrepassword" runat="server" ControlToValidate="grepassword" ErrorMessage="โปรดยืนยันรหัสผ่าน" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="REVrepassword" runat="server" ControlToCompare="gpassword" ControlToValidate="grepassword" ErrorMessage="การยืนยันรหัสผ่านไม่ถูกต้อง" Display="Dynamic"></asp:CompareValidator>
                </div>
            </div>
            <div class="card-footer text-center">
                <asp:Label id="lblStatus" runat="server" visible="False" ForeColor="#FF0000"></asp:Label>
                <asp:Button ID="Button1" runat="server" Text="บันทึกข้อมูล"  CssClass="btn btn-success btn-lg" CausesValidation="true" OnClick="save_profile" />                     
                <input type="reset" name="Reset" id="button" value="กลับสู่หน้าหลัก" class="btn btn-danger btn-lg" onclick="location.href = 'case.aspx'" />
            </div>
        </div>
        <!-- End Content -->
        <!-- Footer  -->
        <inc2:MyUserControl id="MyUserControl" runat="server" />
        <!-- Footer  -->
        <script src="bootstrap.bundle.min.js"></script>
        <!-- Modal -->
        <div class="modal fade" id="myModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">ข้อความแจ้งเตือน!</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <h3>บันทึกข้อมูลเรียบร้อยแล้ว <i class="fa fa-check" aria-hidden="true"></i></h3>
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
