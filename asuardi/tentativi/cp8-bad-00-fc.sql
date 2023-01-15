@set

@set

-- alter session set events '10046 trace name context forever, level 12';
-- alter session set optimizer_features_enable='11.2.0.2';
-- alter session set "_optim_peek_user_binds"=FALSE;
alter session set "_fix_control"='8560951:on';
explain plan for
----
@?/rdbms/admin/utlxplp
-- alter session set events '10046 trace name context forever, level 12';
-- alter session set optimizer_features_enable='11.2.0.3'; -- bad
-- alter session set "_optim_peek_user_binds"=FALSE;       -- bad

-- alter session set optimizer_features_enable='11.2.0.2'; -- good, but wish to get the exact fc

-- alter session set "_fix_control"='12341619:off','8560951:on'; -- irrelevant, 8560951 still needs 11202 even with 12341619

-- alter session set "_fix_control"='8560951:on';

@fctest

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
<codicePrestazione>08897.08</codicePrestazione>
<listaMetodiche>
<metodica>
<codiceMetodica/>
</metodica>
</listaMetodiche>
<listaDistretti/>
</prestazione>
<prestazione>
<codicePrestazione>088952</codicePrestazione>
<listaMetodiche>
<metodica>
<codiceMetodica/>
</metodica>
</listaMetodiche>
<listaDistretti/>
</prestazione>
</listaPrestazioni>
<codiceQuesitoDiagnostico></codiceQuesitoDiagnostico>
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
<eta>402</eta>
<sesso>F</sesso>
<ruoloOperatore>1</ruoloOperatore>
<flagSospensione>N</flagSospensione>
<flagEsposizioneSiss>S</flagEsposizioneSiss>
<regimeErogazione>1</regimeErogazione>
<dataInizio/>
<dataFine/>
<raggioRicerca></raggioRicerca>
<codiceProvincia></codiceProvincia>
<codiceComuneCentroide></codiceComuneCentroide>
<codiceAsl></codiceAsl>
<listaStrutture>
<struttura>
<codiceStruttura>34</codiceStruttura>
</struttura>
</listaStrutture>
<listaPresidi/>
<listaReparti/>
<listaUE/>
</parametriRicerca>
</profiloRicercaAgende>';

  PKG_GP_RICERCHE.CALL_RICERCA_AGENDE(
    P_IN, P_OUT
  );
DBMS_OUTPUT.PUT_LINE('P_OUT = ' || P_OUT);
rollback;
END;
/

exit
