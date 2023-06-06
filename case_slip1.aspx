<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="case_slip1.aspx.vb" Inherits="opm1111.case_slip1" %>
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
    <script src="bootstrap.bundle.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel runat="server" ID="panel1">
            <div class="container">
                <asp:DataList runat="server" ID="listview1">
                    <ItemTemplate>
                        <div class="row">
                            <div class="col-2 mt-4">
                                <%--เลือกรูปหัวใส่ในใบนำส่ง--%>
                                <img src="http://180.180.244.31/opm1111/images/image001.png" width="100" height="100">
                            </div>
                            <div class="col-10">
                                <h3 class="text-black mt-5">ใบนำส่งข้อปรึกษาหารือของสมาชิกสภาผู้แทนราษฎร</h3>
                                <h6 class="text-black">สำนักงานเลขาธิการสภาผู้แทนราษฎร</h6> 
                                <h6 class="text-black">เลขที่ 1111 ถนนสามเสน แขวงถนนนครไชยศรี เขตดุสิต กรุงเทพมหานคร 10300</h6> 
                                <h6 class="text-black">โทร. 0 2242 5900 ต่อ 5041</h6>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col">
                            </div>
                            <div class="col text-black">
                                วันที่ <%#FormatDateTime(Eval("create_date"), 1) %>
                            </div>
                        </div>
                        <%--Insert Topic--%>
                        <p class="text-black">เรื่อง ขอให้แก้ไขปัญหาความเดือดร้อนของประชาชน (<%# Eval("doc_number") %>)</p>
                        <%--Insert involed--%>
                        <p class="text-black">กราบเรียน นายกรัฐมนตรี (<%# Eval("Gname") %> <%# Eval("Gsurname") %>) </p>
                        <p style="text-indent:50px" class="text-black">ด้วย <%# Eval("titlename") %><%# Eval("name") %>&nbsp;<%# Eval("surname") %>&nbsp; ได้มีหนังสือกราบเรียนประธานรัฐสภา/ประธานสภาผู้แทนราษฎร เพื่อขอให้แก้ไขปัญหาเรื่องร้องเรียนร้องทุกข์กรณี <%# Eval("summary") %> รายละเอียดปรากฏตามเอกสารที่แนบมาพร้อมนี้</p>
                        <p style="text-indent:50px" class="text-black">ในการนี้ สำนักงานเลขาธิการสภาผู้แทนราษฎร ได้นำความกราบเรียนประธานรัฐสภาเพื่อพิจารณาแล้ว เห็นควรส่งเรื่องให้สำนักงานปลัดสำนักนายกรัฐมนตรี จึงได้ส่งเรื่องมาเพื่อพิจารณาตามที่เห็นสมควรต่อไป</p>
                        <p style="text-indent:50px" class="text-black">จึงเรียนมาเพื่อโปรดพิจารณา ผลเป็นประการใด โปรดแจ้งให้ทราบด้วย จักขอบคุณยิ่ง</p>
                        <br /><br /><br /><br /><br />
                        <p class="text-black">ผู้ประสานงาน : <%# Eval("Gname") %> <%# Eval("Gsurname") %></p>
                        <p class="text-black">เลขที่หนังสือรับ : <%# Eval("doc_number") %> ลงวันที่ <%# formatdatetime(Eval("doc_date"), 2) %></p>
                    </ItemTemplate>
                </asp:DataList>
            </div>
        </asp:Panel>
    </form>
</body>
</html>
