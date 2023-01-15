set timing on
set serveroutput on
DECLARE
  P_IN CLOB;
  P_OUT CLOB;
BEGIN
  P_IN := '<profiloRicercaAgende>
<listaPrescrizioni>
<prescrizione>
<listaPrestazioni>
<prestazione>
<codicePrestazione>349502</codicePrestazione>
<listaMetodiche>
<metodica>
<codiceMetodica/>
</metodica>
</listaMetodiche>
<listaDistretti/>
</prestazione>
</listaPrestazioni>
<codiceQuesitoDiagnostico>Q00328</codiceQuesitoDiagnostico>
<flagAgendeSpecializzate>N</flagAgendeSpecializzate>
<flagUrgenza>N</flagUrgenza>
<flagPrioritaOrdinariaP>S</flagPrioritaOrdinariaP>
<flagPrioritaOrdinariaD>N</flagPrioritaOrdinariaD>
<flagAccessoProgrammabile>N</flagAccessoProgrammabile>
<flagIndicatorePrioritaAlta>N</flagIndicatorePrioritaAlta>
<tipoInviante/>
</prescrizione>
</listaPrescrizioni>
<parametriRicerca>
<eta>208</eta>
<sesso>F</sesso>
<ruoloOperatore>1</ruoloOperatore>
<flagSospensione>N</flagSospensione>
<flagEsposizioneSiss>S</flagEsposizioneSiss>
<regimeErogazione>1</regimeErogazione>
<dataInizio/>
<dataFine/>
<raggioRicerca></raggioRicerca>
<codiceProvincia>017</codiceProvincia>
<codiceComuneCentroide></codiceComuneCentroide>
<codiceAsl></codiceAsl>
</parametriRicerca>
</profiloRicercaAgende>';

  PKG_GP_RICERCHE.CALL_RICERCA_AGENDE(
    P_IN, P_OUT
  );
DBMS_OUTPUT.PUT_LINE('P_OUT = ' || P_OUT);
rollback;
END;
/

