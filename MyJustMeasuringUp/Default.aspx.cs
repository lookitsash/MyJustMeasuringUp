﻿using Foundation;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyJustMeasuringUp
{
    public partial class Default : System.Web.UI.Page
    {
        protected List<DIYPost> DIYPosts = new List<DIYPost>();
        protected bool UploadComplete = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            BindData();
        }

        private void BindData()
        {
            try
            {
                DIYPosts = new List<DIYPost>();
                foreach (DataRowAdapter dra in DataRowAdapter.Create(Statics.Access.GetDIYPosts()))
                {
                    DIYPost post = new DIYPost()
                    {
                        Desc = dra.Get<string>("Desc"),
                        From = dra.Get<string>("From"),
                        GUID = dra.Get<string>("ID"),
                        Date = dra.Get<string>("Date"),
                        ImageURL = ConfigAdapter.GetAppSetting("ImageURL") + "/" + dra.Get<string>("ID") + ".jpg",
                        Name = dra.Get<string>("Name"),
                        SiteURL = dra.Get<string>("SiteURL")
                    };
                    DIYPosts.Add(post);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void BTN_Post_Click(object sender, EventArgs e)
        {
            UploadComplete = true;
            try
            {
                if (FU_Image.HasFile)
                {
                    string guid = Guid.NewGuid().ToString();
                    string targetFile = Path.Combine(ConfigAdapter.GetAppSetting("ImagePath"), guid + ".jpg");
                    //FU_Image.SaveAs(targetFile);

                    using (System.Drawing.Image img = ResizeImage(Bitmap.FromStream(FU_Image.FileContent), 1000))
                    {
                        ImageCodecInfo jgpEncoder = GetEncoder(ImageFormat.Jpeg);
                        System.Drawing.Imaging.Encoder myEncoder = System.Drawing.Imaging.Encoder.Quality;
                        EncoderParameters myEncoderParameters = new EncoderParameters(1);
                        EncoderParameter myEncoderParameter = new EncoderParameter(myEncoder, 90L);
                        myEncoderParameters.Param[0] = myEncoderParameter;
                        img.Save(targetFile, jgpEncoder, myEncoderParameters);
                    }

                    DIYPost post = null;
                    Statics.Access.DIYPost(post = new DIYPost()
                    {
                        GUID = guid,
                        From = TB_From.Text.Trim(),
                        Name = TB_Name.Text.Trim(),
                        Desc = TB_Desc.Text.Trim(),
                        SiteURL = TB_SiteURL.Text.Trim()                        
                    }, Request.UserHostAddress);

                    try
                    {
                        string recipient = ConfigAdapter.GetAppSetting("EmailNotificationAddress");
                        SmtpClient smtpClient = new SmtpClient(ConfigAdapter.GetAppSetting("SMTPServer"));
                        smtpClient.Credentials = new System.Net.NetworkCredential(ConfigAdapter.GetAppSetting("SMTPServerUsername"), ConfigAdapter.GetAppSetting("SMTPServerPassword"));
                        smtpClient.EnableSsl = true;
                        smtpClient.Port = 587;
                        string emailBodyHtml = @"New community post pending approval<br/>
<br/>
Date: @DATE<br/>
IP: @IP<br/>
<br/>
From: @FROM<br/>
Name: @NAME<br/>
URL: @SITEURL<br/>
Description: @DESC<br/>
<br/>
<img src=""@IMGURL""/>
";
                        emailBodyHtml = emailBodyHtml.Replace("@DATE", DateTime.Now.ToString());
                        emailBodyHtml = emailBodyHtml.Replace("@IP", Request.UserHostAddress);
                        emailBodyHtml = emailBodyHtml.Replace("@FROM", post.From);
                        emailBodyHtml = emailBodyHtml.Replace("@NAME", post.Name);
                        emailBodyHtml = emailBodyHtml.Replace("@SITEURL", post.SiteURL);
                        emailBodyHtml = emailBodyHtml.Replace("@DESC", post.Desc.Replace("\r", "").Replace("\n", "<br/>"));
                        emailBodyHtml = emailBodyHtml.Replace("@IMGURL", ConfigAdapter.GetAppSetting("ImageURL") + "/" + guid + ".jpg");
                        MailMessage mailMessage = new MailMessage(recipient, recipient, "New Community Post", emailBodyHtml);
                        mailMessage.IsBodyHtml = true;
                        smtpClient.Send(mailMessage);
                    }
                    catch (Exception exc)
                    {

                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        private ImageCodecInfo GetEncoder(ImageFormat format)
        {
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                {
                    return codec;
                }
            }
            return null;
        }

        private System.Drawing.Image ResizeImage(System.Drawing.Image original, int targetWidth)
        {
            double percent = (double)original.Width / targetWidth;
            int destWidth = (int)(original.Width / percent);
            int destHeight = (int)(original.Height / percent);

            Bitmap b = new Bitmap(destWidth, destHeight);

            Graphics g = Graphics.FromImage((System.Drawing.Image)b);
            try
            {
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.CompositingQuality = CompositingQuality.HighQuality;

                g.DrawImage(original, 0, 0, destWidth, destHeight);
            }
            finally
            {
                g.Dispose();
            }

            return (System.Drawing.Image)b;
        }
    }
}