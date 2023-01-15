@set 

-- alter session set events '10046 trace name context forever, level 12';
alter session set "_fix_control"='12341619:off';

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
<codicePrestazione>0195414</codicePrestazione>
<listaMetodiche>
<metodica>
<codiceMetodica/>
</metodica>
</listaMetodiche>
<listaDistretti/>
</prestazione>
<prestazione>
<codicePrestazione>389542</codicePrestazione>
<listaMetodiche>
<metodica>
<codiceMetodica/>
</metodica>
</listaMetodiche>
<listaDistretti/>
</prestazione>
</listaPrestazioni>
<codiceQuesitoDiagnostico/>
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
<eta>48</eta>
<sesso>M</sesso>
<ruoloOperatore>1</ruoloOperatore>
<flagSospensione>N</flagSospensione>
<flagEsposizioneSiss>S</flagEsposizioneSiss>
<regimeErogazione>1</regimeErogazione>
<dataInizio/>
<dataFine/>
<raggioRicerca>
</raggioRicerca>
<codiceProvincia>015</codiceProvincia>
<codiceComuneCentroide>
</codiceComuneCentroide>
<codiceAsl>030308</codiceAsl>nullnullnullnull</parametriRicerca>
</profiloRicercaAgende>';

  PKG_GP_RICERCHE.CALL_RICERCA_AGENDE(
    P_IN, P_OUT
  );
DBMS_OUTPUT.PUT_LINE('P_OUT = ' || P_OUT);
rollback;
END;
/

exit
