<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MyJustMeasuringUp.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    div.img {
        margin: 5px;
        border: 1px solid #ccc;
        float: left;
        width: 180px;
    }

    div.img:hover {
        border: 1px solid #777;
    }

    div.img img {
        width: 100%;
        height: auto;
    }

    div.desc {
        padding: 15px;
        text-align: center;
    }

    .imagePost {
        float: left;
        margin: 5px;
        width:440px;
        max-width:440px;
    }
    .imagePost img {
        width:180px;
    }

    .imagePostMobile {
        display:none;
    }

    @media screen and (max-width: 500px) {
        .imagePost {
            display:none;
        }

        .imagePostMobile {
            display:block;
            margin: 5px;
        }  

        .imagePostMobile img {
        width:100px;
        }
    }
    </style>

	<!-- Add fancyBox main JS and CSS files -->
	<script type="text/javascript" src="Resources/js/fancybox/jquery.fancybox.js?v=2.1.5"></script>
	<link rel="stylesheet" type="text/css" href="Resources/js/fancybox/jquery.fancybox.css?v=2.1.5" media="screen" />

	<!-- Add Button helper (this is optional) -->
	<link rel="stylesheet" type="text/css" href="Resources/js/fancybox/helpers/jquery.fancybox-buttons.css?v=1.0.5" />
	<script type="text/javascript" src="Resources/js/fancybox/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>

	<!-- Add Thumbnail helper (this is optional) -->
	<link rel="stylesheet" type="text/css" href="Resources/js/fancybox/helpers/jquery.fancybox-thumbs.css?v=1.0.7" />
	<script type="text/javascript" src="Resources/js/fancybox/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

	<!-- Add Media helper (this is optional) -->
	<script type="text/javascript" src="Resources/js/fancybox/helpers/jquery.fancybox-media.js?v=1.0.6"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('.fancybox').fancybox();
        });

        function showPostPicDiv() {
            $('.inputField').val('');
            $('.postPicButton').hide();
            $('.postPicDiv').show();
        }

        function closePostPicDiv() {
            $('.postPicButton').show();
            $('.postPicDiv').hide();
        }

        function posting() {
            var form = resources.dataFieldsToObject($('.postPicDiv'));
            if (resources.stringNullOrEmpty(form.file) || resources.stringNullOrEmpty(form.from) || resources.stringNullOrEmpty(form.name) || resources.stringNullOrEmpty(form.desc))
            {
                alert('Please provide all required information');
                return false;
            }

            $('.posting').show();
            $('.postPicButton').hide();
            $('.postPicDiv').hide();
            
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div id='wsite-content' class='wsite-elements wsite-not-footer'>
        <h2 class="wsite-content-title" style="text-align: left;"><font color="#626262">Community<span>&nbsp;</span></font></h2>

    We love to see what DIY projects the community has been working on.  Here are recent posts from you guys.  Thanks for sharing, and keep them coming!<br />
    <br />
    <button class="postPicButton" onclick="showPostPicDiv();return false;">Post my project!</button><br />
    <br />
    <div class="posting" style="display:none;">Please wait while your image is being uploaded...</div>
    <% if (UploadComplete)
       { %>
    <div class="postingComplete"><b>Thanks for your upload!</b>  Your project will show up shortly.</div>
    <% } %>
    <div class="postPicDiv" style="display:none;">
        <hr />
        <b>Please upload an image of your project:</b><br />
        <asp:FileUpload runat="server" CssClass="data-file" ID="FU_Image" /><br />
        <br />
        <b>Now we just need a small bit of info about your project:</b><br />
        Your Name <span style="color:#ff0000; font-weight:bold;">*</span>:<br />
        <asp:TextBox runat="server" CssClass="inputField data-from" ID="TB_From"></asp:TextBox><br />
        <br />
        Project Name <span style="color:#ff0000; font-weight:bold;">*</span>:<br />
        <asp:TextBox runat="server" ID="TB_Name" CssClass="inputField data-name"></asp:TextBox><br />
        <br />
        Web link for more details <i>(<b>optional</b>, but we appreciate backlinks to JustMeasuringUp.com)</i>:
        <br />http://<asp:TextBox Width="300" CssClass="inputField data-url" runat="server" ID="TB_SiteURL"></asp:TextBox><br />
        <br />
        Short Description <span style="color:#ff0000; font-weight:bold;">*</span>:<br />
        <asp:TextBox Columns="50" Rows="3" runat="server" CssClass="inputField data-desc" ID="TB_Desc" TextMode="MultiLine"></asp:TextBox><br />
        <br />
        <asp:Button runat="server" ID="BTN_Post" Text="Submit" OnClientClick="return posting();" OnClick="BTN_Post_Click" />&nbsp;&nbsp;&nbsp;<button onclick="closePostPicDiv();return false;">Cancel</button>
    </div>
    <hr />
    <br />

    <%
        foreach (MyJustMeasuringUp.DIYPost post in DIYPosts)
        {
    %>
    <div class="imagePost">
        <table style="border: 1px solid #ccc;" cellspacing="0" cellpadding="0">
            <tr>
                <td style=" border-right: 1px solid #ccc;text-align:center; width:180px;"><a class="fancybox" href="<% =post.ImageURL %>" ><img src="<% =post.ImageURL %>"/></a></td>
                <td rowspan="2" style="vertical-align:top; padding:5px; text-align:left; width:260px;">
                    <% =post.Desc.Replace("\r","").Replace("\n","<br/>") %>
                    <%
                        if (!String.IsNullOrEmpty(post.SiteURL))
                        { 
                    %>
                    <br /><br />
                    <a href="<% =post.SiteURL %>" target="_blank" style="font-size:12px;">read more...</a>
                    <%
                        }
                    %>                    
                </td>
            </tr>
            <tr>
                <td style="border-right: 1px solid #ccc;text-align:center;">
                    <span style="font-size:12px;"><b><% =post.Name %></b></span><br />
                    <span style="font-size:10px;">by <% =post.From %></span>
                </td>
            </tr>
        </table>
    </div>

    <div class="imagePostMobile">
        <table style="border: 1px solid #ccc;" cellspacing="0" cellpadding="0">
            <tr>
                <td style=" border-right: 1px solid #ccc;text-align:center;"><a class="fancybox" href="<% =post.ImageURL %>" ><img src="<% =post.ImageURL %>" /></a></td>
                <td style="vertical-align:top; padding:5px;">
                    <span style="font-size:12px;"><b><% =post.Name %></b></span><br />
                    <span style="font-size:10px;">by <% =post.From %></span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="border-top: 1px solid #ccc;text-align:left;">
                    <% =post.Desc.Replace("\r","").Replace("\n","<br/>") %>
                    <%
                        if (!String.IsNullOrEmpty(post.SiteURL))
                        { 
                    %>
                    <br /><br />
                    <a href="<% =post.SiteURL %>" target="_blank" style="font-size:12px;">read more...</a>
                    <%
                        }
                    %>
                </td>
            </tr>
        </table>
    </div>
    <%
        }
    %>

    <!--
<div class="img">
  <a target="_blank" href="http://www.w3schools.com/css/img_fjords.jpg">
    <img src="http://www.w3schools.com/css/img_fjords.jpg" alt="Fjords" width="300" height="200">
  </a>
  <div class="desc">Stone walkway<br />by Rob</div>
</div>
    -->


    </div>
</asp:Content>
