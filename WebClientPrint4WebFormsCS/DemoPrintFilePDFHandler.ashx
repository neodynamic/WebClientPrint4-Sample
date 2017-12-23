<%@ WebHandler Language="C#" Class="DemoPrintFilePDFHandler" %>

using System;
using System.Web;

using Neodynamic.SDK.Web;

public class DemoPrintFilePDFHandler : IHttpHandler {

    /*############### IMPORTANT!!! ############
    If your website requires AUTHENTICATION, then you MUST configure THIS Handler file
    to be ANONYMOUS access allowed!!!
      ######################################### */

    public void ProcessRequest (HttpContext context) {

        if (WebClientPrint.ProcessPrintJob(context.Request.Url.Query))
        {

            string printerName = context.Server.UrlDecode(context.Request["printerName"]);
            string trayName = context.Server.UrlDecode(context.Request["trayName"]);
            string paperName = context.Server.UrlDecode(context.Request["paperName"]);

            string printRotation = context.Server.UrlDecode(context.Request["printRotation"]);
            string pagesRange = context.Server.UrlDecode(context.Request["pagesRange"]);

            bool printAnnotations = (context.Request["printAnnotations"] == "true");
            bool printAsGrayscale = (context.Request["printAsGrayscale"] == "true");
            bool printInReverseOrder = (context.Request["printInReverseOrder"] == "true");

            string fileName = Guid.NewGuid().ToString("N");
            string filePath = filePath = "~/files/GuidingPrinciplesBusinessHR_EN.pdf";

            PrintFilePDF file = new PrintFilePDF(context.Server.MapPath(filePath), fileName);
            file.PrintRotation = (PrintRotation)Enum.Parse(typeof(PrintRotation), printRotation);;
            file.PagesRange = pagesRange;
            file.PrintAnnotations = printAnnotations;
            file.PrintAsGrayscale = printAsGrayscale;
            file.PrintInReverseOrder = printInReverseOrder;
            

            ClientPrintJob cpj = new ClientPrintJob();
            cpj.PrintFile = file;
            if (printerName == "null")
                cpj.ClientPrinter = new DefaultPrinter();
            else
            {
                if (trayName == "null") trayName = "";
                if (paperName == "null") paperName = "";

                cpj.ClientPrinter = new InstalledPrinter(printerName, true, trayName, paperName);
            }

            context.Response.ContentType = "application/octet-stream";
            context.Response.BinaryWrite(cpj.GetContent());
            context.Response.End();



        }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}