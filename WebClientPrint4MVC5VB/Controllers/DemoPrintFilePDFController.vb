Imports System.Web.Mvc

Imports Neodynamic.SDK.Web


Namespace Controllers
    Public Class DemoPrintFilePDFController
        Inherits Controller

        ' GET: DemoPrintFilePDF
        Function Index() As ActionResult

            ViewData("WCPScript") = Neodynamic.SDK.Web.WebClientPrint.CreateScript(Url.Action("ProcessRequest", "WebClientPrintAPI", Nothing, HttpContext.Request.Url.Scheme), Url.Action("PrintFile", "DemoPrintFilePDF", Nothing, HttpContext.Request.Url.Scheme), HttpContext.Session.SessionID)

            Return View()
        End Function


        <AllowAnonymous> Public Sub PrintFile(printerName As String, trayName As String, paperName As String, printRotation As String, pagesRange As String, printAnnotations As String, printAsGrayscale As String, printInReverseOrder As String)

            Dim fileName As String = Guid.NewGuid().ToString("N")
            Dim filePath As String = "~/files/GuidingPrinciplesBusinessHR_EN.pdf"

            Dim File As New PrintFilePDF(System.Web.HttpContext.Current.Server.MapPath(filePath), fileName)
            File.PrintRotation = [Enum].Parse(GetType(PrintRotation), printRotation)
            File.PagesRange = pagesRange
            File.PrintAnnotations = (printAnnotations = "true")
            File.PrintAsGrayscale = (printAsGrayscale = "true")
            File.PrintInReverseOrder = (printInReverseOrder = "true")

            Dim cpj As New ClientPrintJob()
            cpj.PrintFile = File
            If (printerName = "null") Then
                cpj.ClientPrinter = New DefaultPrinter()
            Else
                If (trayName = "null") Then trayName = ""
                If (paperName = "null") Then paperName = ""

                cpj.ClientPrinter = New InstalledPrinter(printerName, True, trayName, paperName)
            End If

            System.Web.HttpContext.Current.Response.ContentType = "application/octet-stream"
            System.Web.HttpContext.Current.Response.BinaryWrite(cpj.GetContent())
            System.Web.HttpContext.Current.Response.End()

        End Sub

    End Class
End Namespace