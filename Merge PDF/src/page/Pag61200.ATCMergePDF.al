page 61200 "ATC_MergePDF"
{
    ApplicationArea = all;
    Caption = 'Merge PDF', comment = 'ITA="Unisci PDF"';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', comment = 'ITA="Generale"';
                usercontrol(pdf; PDF)
                {
                    ApplicationArea = all;

                    trigger DownloadPDF(pdfToNav: text)
                    var
                        TempBlob: Codeunit "Temp Blob";
                        Convert64: Codeunit "Base64 Convert";
                        FilenameLbl: Label 'PDF_%1_%2', comment = 'ITA="PDF_%1_%2"';
                        ExtLbl: Label '.pdf', comment = 'ITA=".pdf"';
                        CurrentDateTime: Text;
                        Ins: InStream;
                        Outs: OutStream;
                        Filename: Text;
                    begin
                        if pdfToNav <> '' then begin
                            CurrentDateTime := Format(CurrentDateTime());
                            Filename := StrSubstNo(FilenameLbl, CurrentDateTime, ExtLbl);
                            TempBlob.CreateInStream(Ins);
                            TempBlob.CreateOutStream(Outs);
                            Convert64.FromBase64(pdfToNav, Outs);
                            DownloadFromStream(Ins, 'Download', '', '', Filename);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ATC_SalesOrder)
            {
                ApplicationArea = All;
                Caption = 'Add Sales Order', comment = 'ITA="Aggiungi ordine di vendita"';
                Image = Order;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ATCMergePDF: Record ATC_MergePDF;
                    SalesOrderList: Page "Sales Order List";
                    Recref1: RecordRef;
                    LineNo: Integer;
                begin
                    Clear(SalesOrderList);
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesOrderList.SetTableView(SalesHeader);
                    SalesOrderList.LookupMode := true;
                    if (SalesOrderList.RunModal() = Action::LookupOK) then begin
                        SalesOrderList.GetRecord(SalesHeader);
                        Recref1.GetTable(SalesHeader);
                        Recref1.SetRecFilter();
                        //CuMergePDF.AddReportToMerge(Report::"ATC_PRP_Print Sales Order", Recref1);
                        CuMergePDF.AddReportToMerge(Report::"Standard Sales - Order Conf.", Recref1);

                        if ATCMergePDF.FindLast() then
                            LineNo := ATCMergePDF.ATC_PrimaryKey + 10000
                        else
                            LineNo := 10000;
                        ATCMergePDF.Init();
                        ATCMergePDF.ATC_PrimaryKey := LineNo;
                        ATCMergePDF.ATC_DocumentNo := SalesHeader."No.";
                        ATCMergePDF.ATC_DocumentType := ATCMergePDF.ATC_DocumentType::ATC_SalesOrder;
                        ATCMergePDF.Insert();
                        Message(DocumentAddedMsg, SalesHeader."No.");
                    end;

                end;
            }
            /* action(ATC_SalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'Add Sales Invoice', comment = 'ITA="Aggiungi fattura di vendita"';
                Image = Order;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ATCMergePDF: Record ATC_MergePDF;
                    SalesInvoiceList: Page "Sales Invoice List";
                    Recref2: RecordRef;
                    LineNo: Integer;
                begin
                    Clear(SalesInvoiceList);
                    SalesHeader.Reset();
                    SalesInvoiceList.SetTableView(SalesHeader);
                    SalesInvoiceList.LookupMode := true;
                    if (SalesInvoiceList.RunModal() = Action::LookupOK) then begin
                        SalesInvoiceList.GetRecord(SalesHeader);
                        Recref2.GetTable(SalesHeader);
                        Recref2.SetRecFilter();
                        CuMergePDF.AddReportToMerge(Report::"ATC_PRP_Print Sales Invoice", Recref2);

                        if ATCMergePDF.FindLast() then
                            LineNo := ATCMergePDF.ATC_PrimaryKey + 10000
                        else
                            LineNo := 10000;
                        ATCMergePDF.Init();
                        ATCMergePDF.ATC_PrimaryKey := LineNo;
                        ATCMergePDF.ATC_DocumentNo := SalesHeader."No.";
                        ATCMergePDF.ATC_DocumentType := ATCMergePDF.ATC_DocumentType::ATC_SalesInvoice;
                        ATCMergePDF.Insert();
                        Message(DocumentAddedMsg, SalesHeader."No.");
                    end;
                end;
            } */
            action(ATC_PostedSalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'Add Posted Sales Invoice', comment = 'ITA="Aggiungi fattura di vendita registrata"';
                Image = Order;
                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    ATCMergePDF: Record ATC_MergePDF;
                    PostedSalesInvoices: Page "Posted Sales Invoices";
                    Recref2: RecordRef;
                    LineNo: Integer;
                begin
                    Clear(PostedSalesInvoices);
                    SalesInvoiceHeader.Reset();
                    PostedSalesInvoices.SetTableView(SalesInvoiceHeader);
                    PostedSalesInvoices.LookupMode := true;
                    if (PostedSalesInvoices.RunModal() = Action::LookupOK) then begin
                        PostedSalesInvoices.GetRecord(SalesInvoiceHeader);
                        Recref2.GetTable(SalesInvoiceHeader);
                        Recref2.SetRecFilter();
                        CuMergePDF.AddReportToMerge(Report::"Standard Sales - Invoice", Recref2);

                        if ATCMergePDF.FindLast() then
                            LineNo := ATCMergePDF.ATC_PrimaryKey + 10000
                        else
                            LineNo := 10000;
                        ATCMergePDF.Init();
                        ATCMergePDF.ATC_PrimaryKey := LineNo;
                        ATCMergePDF.ATC_DocumentNo := SalesInvoiceHeader."No.";
                        ATCMergePDF.ATC_DocumentType := ATCMergePDF.ATC_DocumentType::ATC_SalesInvoice;
                        ATCMergePDF.Insert();
                        Message(DocumentAddedMsg, SalesInvoiceHeader."No.");
                    end;
                end;
            }
            action(ATC_UploadPDF)
            {
                Caption = 'Upload PDF', comment = 'ITA="Carica pdf"';
                ApplicationArea = all;
                Image = Import;

                trigger OnAction()
                begin
                    CuMergePDF.AddPDFToMerge('TestPDF.pdf');
                end;
            }
            action(ATC_ViewDocuments)
            {
                ApplicationArea = All;
                Image = Action;
                Caption = 'View Documents', comment = 'ITA="Visualizza documenti"';
                trigger OnAction()
                var
                    ATCMergePDF: Record ATC_MergePDF;
                    ViewDocuments: Page ATC_ViewDocuments;
                begin
                    Clear(ViewDocuments);
                    ATCMergePDF.Reset();
                    ViewDocuments.SetTableView(ATCMergePDF);
                    ViewDocuments.Editable(false);
                    ViewDocuments.RunModal();
                end;
            }
            action(Merge)
            {
                ApplicationArea = All;
                Caption = 'Merge Documents', comment = 'ITA="Unisci documenti"';
                Image = Print;
                trigger OnAction()
                begin
                    CurrPage.pdf.MergePDF(format(CuMergePDF.GetJArray()));
                end;
            }
            action(ATC_Clear)
            {
                ApplicationArea = All;
                Caption = 'Clear documents', comment = 'ITA="Elimina documenti"';
                Image = Delete;
                trigger OnAction()
                var
                    ATCMergePDF: Record ATC_MergePDF;
                    DeocumentRemovedMsg: Label 'All docments have been removed', comment = 'ITA="Tutti i docmenti sono stati eliminati"';
                begin
                    CuMergePDF.ClearPDF();
                    ATCMergePDF.DeleteAll();
                    Message(DeocumentRemovedMsg);
                end;
            }
        }
    }

    var
        CuMergePDF: Codeunit ATC_MergePDF;
        DocumentAddedMsg: Label 'Document %1 added', comment = 'ITA="Aggiunto documento %1"';
}