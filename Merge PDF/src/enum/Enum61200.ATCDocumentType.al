enum 61200 "ATC_DocumentType"
{
    Extensible = true;

    value(0; "ATC_SalesOrder")
    {
        Caption = 'Sales Order', comment = 'ITA="Ordine di vendita"';
    }
    value(1; "ATC_PostedSalesInvoice")
    {
        Caption = 'Posted Sales Invoice', comment = 'ITA="Fattura di vendita registrata"';
    }
    value(3; "ATC_UploadaedFromPc")
    {
        Caption = 'Uploaded From Pc', comment = 'ITA="Caricato dal pc"';
    }
    value(4; "ATC_SalesInvoice")
    {
        Caption = 'Sales Invoice', comment = 'ITA="Fattura di vendita"';
    }
}