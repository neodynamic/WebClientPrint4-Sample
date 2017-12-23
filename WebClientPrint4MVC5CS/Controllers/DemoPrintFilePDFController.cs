using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Neodynamic.SDK.Web;

namespace WebClientPrint4MVC5CS.Controllers
{
    public class DemoPrintFilePDFController : Controller
    {
        // GET: DemoPrintFile
        public ActionResult Index()
        {
            ViewBag.WCPScript = Neodynamic.SDK.Web.WebClientPrint.CreateScript(Url.Action("ProcessRequest", "WebClientPrintAPI", null, HttpContext.Request.Url.Scheme), Url.Action("PrintFile", "DemoPrintFilePDF", null, HttpContext.Request.Url.Scheme), HttpContext.Session.SessionID);

            return View();
        }

        [AllowAnonymous]
        public void PrintFile(string printerName, string trayName, string paperName, string printRotation, string pagesRange, string printAnnotations, string printAsGrayscale, string printInReverseOrder)
        {
            string fileName = Guid.NewGuid().ToString("N");
            string filePath = filePath = "~/files/GuidingPrinciplesBusinessHR_EN.pdf";

            PrintFilePDF file = new PrintFilePDF(System.Web.HttpContext.Current.Server.MapPath(filePath), fileName);
            file.PrintRotation = (PrintRotation)Enum.Parse(typeof(PrintRotation), printRotation); ;
            file.PagesRange = pagesRange;
            file.PrintAnnotations = (printAnnotations == "true");
            file.PrintAsGrayscale = (printAsGrayscale == "true");
            file.PrintInReverseOrder = (printInReverseOrder == "true");
            
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

           
            System.Web.HttpContext.Current.Response.ContentType = "application/octet-stream";
            System.Web.HttpContext.Current.Response.BinaryWrite(cpj.GetContent());
            System.Web.HttpContext.Current.Response.End();
            
        }
    }
}