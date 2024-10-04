page 61201 "ATC_ViewDocuments"
{
    ApplicationArea = all;
    Caption = 'View Documents', comment = 'ITA="View documents"';
    PageType = list;
    UsageCategory = Administration;
    SourceTable = ATC_MergePDF;

    layout
    {
        area(content)
        {
            repeater(Documents)
            {
                Caption = 'List of Documents to merge', comment = 'ITA="Lista Documenti da unire"';
                field(ATC_DocumentNo; Rec.ATC_DocumentNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ATC_DocumentType; Rec.ATC_DocumentType)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}

