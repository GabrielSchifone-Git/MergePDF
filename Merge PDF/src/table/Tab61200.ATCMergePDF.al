table 61200 "ATC_MergePDF"
{
    fields
    {
        field(1; ATC_PrimaryKey; Integer)
        {
            Caption = 'Primary Key', comment = 'ITA="Chiave primaria"';
        }
        field(2; ATC_DocumentNo; Code[20])
        {
            Caption = 'Document No.', comment = 'ITA="Numero documento"';
        }
        field(3; ATC_DocumentType; Enum ATC_DocumentType)
        {
            Caption = 'Document Type', comment = 'ITA="Tipo documento"';
        }
    }

    keys
    {
        key(PK; ATC_PrimaryKey)
        {
            Clustered = true;
        }
    }
}