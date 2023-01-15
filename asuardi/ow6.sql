VARIABLE B1 varchar2(32)
VARIABLE B2 varchar2(32)
VARIABLE B3 varchar2(32)
VARIABLE B4 varchar2(32)
VARIABLE B5 varchar2(32)
BEGIN
 :B1 :=NULL;
 :B2 :=NULL;
 :B3 :=NULL;
 :B4 :='BLLFNC98B54I577A';
 :B5 :=NULL;
END;
/

explain plan for
SELECT XMLELEMENT( "noteRegistrate", XMLELEMENT( "codiceFiscaleCittadino", :B4 ), XMLELEMENT( "cittadinoNonSiss", :B3 ), XMLAGG(XMLELEMENT( "nota", XMLELEMENT( "codicePrescrizione", CD_PRESCRIZIONE), XMLELEMENT( "codiceNota", COD.ID_CAUSALE_NOTA), XMLELEMENT( "codiceOperatore", COD.CD_OPERATORE), XMLELEMENT( "dataInserimento", TO_CHAR(COD.DT_INSERIMENTO, 'YYYYMMDDHH24MISS')), XMLELEMENT( "descCausale", CNO.DS_NOTA), XMLELEMENT( "tipoCausale", CNO.CD_TIPO_NOTA), XMLELEMENT( "testoNota", COD.TESTO)) ORDER BY COD.ID_CAUSALE_DETT DESC ) ) FROM GP_CAUSALI_OPER_DETT COD INNER JOIN GP_CAUSALI_NOTE_OPER CNO ON COD.ID_CAUSALE_NOTA = CNO.ID_CAUSALE_NOTA WHERE (COD.CD_FISCALE_CITTADINO = :B4 OR COD.CF_CITTADINO_NON_SISS=:B3 ) AND (COD.CD_PRESCRIZIONE IS NULL OR COD.CD_PRESCRIZIONE = NVL(:B2 ,COD.CD_PRESCRIZIONE)) AND COD.ID_CAUSALE_NOTA = NVL(:B1 , COD.ID_CAUSALE_NOTA) AND (COD.ID_CAUSALE_NOTA IN (1,2))
/
@?/rdbms/admin/utlxplp