codeunit 61200 "ATC_MergePDF"
{
    //COME SI USA
    //Basta chiamare le funzioni AddReportToMerge, AddPDFToMerge o AddBase64pdf tutte le volte che è necessario e poi chiamare la funzione GetJArray.
    //Ottieni un array con tutti i tuoi pdf in base64 da fornire alla funzione javascript del controladd-in.
    procedure AddReportToMerge(ReportID: Integer; RecRef: RecordRef)
    var
        Tempblob: Codeunit "Temp Blob";
        Convert: Codeunit "Base64 Convert";
        Ins: InStream;
        Outs: OutStream;
        Parameters: Text;
    begin
        Tempblob.CreateInStream(Ins);
        Tempblob.CreateOutStream(Outs);
        Parameters := '';
        Report.SaveAs(ReportID, Parameters, ReportFormat::Pdf, Outs, RecRef);
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(Ins));
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure AddPDFToMerge(FileName: Text)
    var
        ATCMergePDF: Record ATC_MergePDF;
        Tempblob: Codeunit "Temp Blob";
        Convert: Codeunit "Base64 Convert";
        Outs: OutStream;
        FilePath: Text;
        LineNo: Integer;
        Ins: InStream;
        SelectFileLbl: Label 'Select a file', comment = 'ITA="Seleziona un file"';
        DocumentAddedMsg: Label 'Document %1 added', comment = 'ITA="Aggiunto documento %1"';
        Parameters: Text;
    begin
        if UploadIntoStream(SelectFileLbl, '', '', FilePath, Ins) then begin
            Tempblob.CreateOutStream(Outs);
            Parameters := '';
            Clear(JObjectPDFToMerge);
            JObjectPDFToMerge.Add('pdf', Convert.ToBase64(Ins));
            JArrayPDFToMerge.Add(JObjectPDFToMerge);

            if ATCMergePDF.FindLast() then
                LineNo := ATCMergePDF.ATC_PrimaryKey + 10000
            else
                LineNo := 10000;
            ATCMergePDF.Init();
            ATCMergePDF.ATC_PrimaryKey := LineNo;
            ATCMergePDF.ATC_DocumentNo := format(LineNo);
            ATCMergePDF.ATC_DocumentType := ATCMergePDF.ATC_DocumentType::ATC_UploadaedFromPc;
            ATCMergePDF.Insert();
            Message(DocumentAddedMsg, LineNo);
        end;
    end;

    procedure AddBase64pdf(base64pdf: text)
    begin
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', base64pdf);
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure ClearPDF()
    begin
        Clear(JArrayPDFToMerge);
    end;

    procedure GetJArray() JArrayPDF: JsonArray;
    begin
        JArrayPDF := JArrayPDFToMerge;
    end;

    var
        JObjectPDFToMerge: JsonObject;
        JArrayPDFToMerge: JsonArray;
}