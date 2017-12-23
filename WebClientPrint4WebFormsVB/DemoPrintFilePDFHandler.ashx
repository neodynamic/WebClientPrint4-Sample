<%@ WebHandler Language="VB" Class="DemoPrintFilePDFHandler" %>

Imports System
Imports System.Web

Imports Neodynamic.SDK.Web

Public Class DemoPrintFilePDFHandler : Implements IHttpHandler


    '############### IMPORTANT!!! ############
    ' If your website requires AUTHENTICATION, then you MUST configure THIS Handler file
    ' to be ANONYMOUS access allowed!!!
    '######################################### 


    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        If WebClientPrint.ProcessPrintJob(context.Request.Url.Query) Then

            Dim printerName As String = context.Server.UrlDecode(context.Request("printerName"))
            Dim trayName As String = context.Server.UrlDecode(context.Request("trayName"))
            Dim paperName As String = context.Server.UrlDecode(context.Request("paperName"))

            Dim PrintRotation As String = context.Server.UrlDecode(context.Request("printRotation"))
            Dim pagesRange As String = context.Server.UrlDecode(context.Request("pagesRange"))

            Dim printAnnotations As Boolean = (context.Request("printAnnotations") = "true")
            Dim printAsGrayscale As Boolean = (context.Request("printAsGrayscale") = "true")
            Dim printInReverseOrder As Boolean = (context.Request("printInReverseOrder") = "true")

            Dim fileName As String = Guid.NewGuid().ToString("N")
            Dim filePath As String = "~/files/GuidingPrinciplesBusinessHR_EN.pdf"

            Dim file As New PrintFilePDF(context.Server.MapPath(filePath), fileName)
            file.PrintRotation = [Enum].Parse(GetType(PrintRotation), PrintRotation)
            file.PagesRange = pagesRange
            file.PrintAnnotations = printAnnotations
            file.PrintAsGrayscale = printAsGrayscale
            file.PrintInReverseOrder = printInReverseOrder


            Dim cpj As New ClientPrintJob()
            cpj.PrintFile = file
            If printerName = "null" Then
                cpj.ClientPrinter = New DefaultPrinter()
            Else
                If (trayName = "null") Then trayName = ""
                If (paperName = "null") Then paperName = ""
                cpj.ClientPrinter = New InstalledPrinter(printerName, True, trayName, paperName)
            End If

            context.Response.ContentType = "application/octet-stream"
            context.Response.BinaryWrite(cpj.GetContent())
            context.Response.End()


        End If

    End Sub


    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class