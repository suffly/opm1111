<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="index1.aspx.vb" Inherits="opm1111.index1" %>
<%@Register Src = "header2.ascx" TagName="MyUserControl" TagPrefix="inc1"%>
<%@Register Src = "footer2.ascx" TagName="MyUserControl" TagPrefix="inc2"%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <%--Change Logo and title--%>
    <link rel="shortcut icon" href="images/c4mlogo.png" type="image/png" />
    <title> C4M </title>
    <!-- Bootstrap core CSS -->
    <link href="bootstrap.css" rel="stylesheet">
    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="style1.css">
    <!-- Jquery -->
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>
    <!-- Icon-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">

</head>
<body>
    <form id="form1" runat="server">
        
        <!-- Header  -->
        <inc1:MyUserControl id="Header2" runat="server" />
        <!-- Header  -->
        <!-- Login -->
        <br /><br /><br /><br /><br /><br />
        <div id="login1" class="col d-flex justify-content-center">
            <div class="card border-primary col-xs-12 col-md-4">
                <div class="card-header">Login</div>
                <div class="card-body">
                    <div class="form-group align-content-center">
  		                <label for="gemail">อีเมล :</label>
 				            <asp:TextBox ID="gemail" runat="server"   CssClass="form-control" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RFVgemail" runat="server" ErrorMessage="โปรดระบุ" ControlToValidate="gemail" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
                        <div class="form-group align-content-center mt-2">
  		                    <label for="gpassword">รหัสผ่าน :</label>
                                <asp:TextBox ID="gpassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RFVgpassword" runat="server" ErrorMessage="โปรดระบุ" ControlToValidate="gpassword" Display="Dynamic" ForeColor="#FF0000"></asp:RequiredFieldValidator>
	                    </div>
                    </div>
                    <div class="card-footer">
                        <div class="align-content-center mt-2">
                            <asp:Button ID="login" runat="server" Text="เข้าสู่ระบบ" OnClick="login_onClick" CssClass="btn btn-info btn-md"/>                
                            <%--<asp:Button ID="login" runat="server" Text="เข้าสู่ระบบ" CssClass="btn btn-info btn-md"/>--%>                
                        </div>
                        <div>
                           <asp:Label ID="lbLogin" runat="server" ForeColor="#FF0000"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br /><br /><br /><br /><br /><br />
        <!-- Footer  -->
        <%--<inc2:MyUserControl id="MyUserControl" runat="server" />--%>
        <inc2:MyUserControl id="footer2" runat="server" />
        <!-- Footer  -->
        <script src="bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
