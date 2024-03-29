@set
-- alter session set optimizer_features_enable='11.2.0.2';
-- alter session set "_optim_peek_user_binds"=FALSE;
-- alter session set "_fix_control"='8560951:on';
explain plan for
INSERT  INTO GP_TEMP_RICERCA_AGENDE ( ID_PRESTAZIONE, ID_AZIENDA_SANITARIA, ID_PRESIDIO, ID_REPARTO, ID_UNITA_EROGANTE, CD_UNITA_PRENOTANTE, ID_AGENDA, ID_PRESTAZIONE_AGENDA, ID_COMBINATA, FL_VINCOLI_RISPETTATI )
--
SELECT /*+ opt_param('_fix_control' '8560951:on') opt_param('optimizer_features_enable' '11.2.0.2') */ DISTINCT
         PA.ID_PRESTAZIONE, PA.ID_AZIENDA_SANITARIA, PA.ID_PRESIDIO, PA.ID_REPARTO, PA.ID_UNITA_EROGANTE, PA.CD_UNITA_PRENOTANTE, PA.ID_AGENDA, PA.ID_PRESTAZIONE_AGENDA, PA.ID_COMBINATA, 'S'
  FROM GP_TEMP_RA_PRESCRIZIONI RA
  INNER JOIN V_GP_PRESTAZIONI_AGENDE PA ON RA.ID_PRESTAZIONE=PA.ID_PRESTAZIONE /* questa join appare fare tutta la differenza del mondo in innermost loop */
  INNER JOIN GP_AGENDE AG ON PA.ID_AGENDA=AG.ID_AGENDA
--
  WHERE ( EXISTS (
                   SELECT 0
                     FROM V_GP_DISTRETTI_PA DP
                     INNER JOIN GP_DISTRETTI_ANATOMICI DA ON DP.ID_DISTRETTO_ANATOMICO=DA.ID_DISTRETTO_ANATOMICO
                     INNER JOIN GP_TEMP_RA_PRESCRIZIONI TE ON DA.ID_DISTRETTO_ANATOMICO=TE.ID_DISTRETTO_ANATOMICO
                     WHERE
                           PA.ID_PRESTAZIONE_AGENDA=DP.ID_PRESTAZIONE_AGENDA
                       AND PA.ID_PRESTAZIONE=TE.ID_PRESTAZIONE
                       AND RA.ID_PRESCRIZIONE=TE.ID_PRESCRIZIONE
                       AND DP.CD_OPERATORE_LOGICO='U'
                       AND NOT EXISTS (
                                        SELECT 0
                                          FROM GP_TEMP_RA_PRESCRIZIONI T2
                                          WHERE
                                                T2.ID_PRESTAZIONE=TE.ID_PRESTAZIONE
                                            AND T2.ID_PRESCRIZIONE=TE.ID_PRESCRIZIONE
                                            AND T2.ID_DISTRETTO_ANATOMICO != TE.ID_DISTRETTO_ANATOMICO
                                            AND NOT EXISTS (
                                                             SELECT 0
                                                               FROM V_GP_DISTRETTI_PA D2
                                                               WHERE
                                                                     DP.ID_AGENDA=D2.ID_AGENDA
                                                                 AND D2.ID_PRESTAZIONE=T2.ID_PRESTAZIONE
                                                                 AND D2.ID_DISTRETTO_ANATOMICO=T2.ID_DISTRETTO_ANATOMICO
                                                                 AND D2.CD_OPERATORE_LOGICO='U'
                                                           )
                                      )
                 )
          OR ( NOT EXISTS ( 
                            SELECT 0
                              FROM V_GP_DISTRETTI_PA DP
                              INNER JOIN GP_DISTRETTI_ANATOMICI DA ON DP.ID_DISTRETTO_ANATOMICO=DA.ID_DISTRETTO_ANATOMICO
                              INNER JOIN GP_TEMP_RA_PRESCRIZIONI TE ON DA.ID_DISTRETTO_ANATOMICO=TE.ID_DISTRETTO_ANATOMICO
                              WHERE
                                    PA.ID_PRESTAZIONE_AGENDA=DP.ID_PRESTAZIONE_AGENDA
                                AND RA.ID_PRESCRIZIONE=TE.ID_PRESCRIZIONE
                                AND PA.ID_PRESTAZIONE=TE.ID_PRESTAZIONE
                                AND DP.CD_OPERATORE_LOGICO='D'
                          )
           AND NOT EXISTS (
                            SELECT 0
                              FROM V_GP_DISTRETTI_PA DP
                             WHERE
                                   PA.ID_PRESTAZIONE_AGENDA=DP.ID_PRESTAZIONE_AGENDA
                               AND DP.CD_OPERATORE_LOGICO='U'
                          )
             )
        )
--
    AND EXISTS ( SELECT 0 FROM GP_TEMP_RA_PRESCRIZIONI TE INNER JOIN GP_PRESTAZIONI_AGENDE PG ON TE.ID_PRESTAZIONE=PG.ID_PRESTAZIONE INNER JOIN ( SELECT PA.ID_PRESTAZIONE_AGENDA, PA.ID_AGENDA, NVL(MP.ID_METODICA, :B9 ) ID_METODICA FROM GP_PRESTAZIONI_AGENDE PA LEFT JOIN V_GP_METODICHE_PRESTAZ_AGENDE MP ON PA.ID_PRESTAZIONE_AGENDA=MP.ID_PRESTAZIONE_AGENDA ) MP ON PG.ID_PRESTAZIONE_AGENDA=MP.ID_PRESTAZIONE_AGENDA INNER JOIN GP_METODICHE ME ON MP.ID_METODICA=ME.ID_METODICA WHERE ME.ID_METODICA=NVL(TE.ID_METODICA, :B9 ) AND PA.ID_PRESTAZIONE_AGENDA=PG.ID_PRESTAZIONE_AGENDA AND RA.ID_PRESCRIZIONE=TE.ID_PRESCRIZIONE AND TE.ID_PRESTAZIONE=PA.ID_PRESTAZIONE AND NOT EXISTS ( SELECT 0 FROM GP_TEMP_RA_PRESCRIZIONI T2 WHERE T2.ID_PRESTAZIONE=TE.ID_PRESTAZIONE AND T2.ID_PRESCRIZIONE=TE.ID_PRESCRIZIONE AND T2.ID_METODICA!=TE.ID_METODICA AND NOT EXISTS ( SELECT 0 FROM ( SELECT PA.ID_PRESTAZIONE_AGENDA, PA.ID_PRESTAZIONE, PA.ID_AGENDA, NVL(MP.ID_METODICA, :B9 ) ID_METODICA FROM GP_PRESTAZIONI_AGENDE PA LEFT JOIN V_GP_METODICHE_PRESTAZ_AGENDE MP ON PA.ID_PRESTAZIONE_AGENDA=MP.ID_PRESTAZIONE_AGENDA ) M2 WHERE MP.ID_AGENDA=M2.ID_AGENDA AND M2.ID_PRESTAZIONE=T2.ID_PRESTAZIONE AND M2.ID_METODICA=T2.ID_METODICA ) ) )
--
    AND (
          CASE WHEN EXISTS (
                              SELECT 0
                                FROM GP_TEMP_RA_PRESCRIZIONI R2
                               WHERE R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE
                                 AND ID_QUESITO_DIAGNOSTICO IS NULL
                            )
               THEN CASE WHEN NOT EXISTS (
                                            SELECT 0
                                              FROM V_GP_QUESITI_DIAGNOSTICI QD
                                              INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO
                                             WHERE PA.ID_AGENDA=QA.ID_AGENDA AND QA.CD_OPERATORE_LOGICO='U'
                                         )
                         THEN 'S'
                         ELSE 'N'
                         END
                ELSE CASE WHEN EXISTS (
                                         SELECT 0
                                           FROM GP_TEMP_RA_PRESCRIZIONI R2
                                         WHERE R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE AND FL_AGENDE_SPECIALIZZATE='S'
                                      )
                     THEN CASE WHEN EXISTS (
                                              SELECT 0
                                                FROM GP_QUESITI_DIAGNOSTICI QD
                                                INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO
                                                INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO
                                              WHERE PA.ID_AGENDA=QA.ID_AGENDA
                                                AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE
                                                AND QA.CD_OPERATORE_LOGICO='U'
                                           )
                               THEN 'S'
                               ELSE 'N'
                               END
                     ELSE CASE WHEN ( EXISTS (
                                                SELECT 0
                                                  FROM GP_QUESITI_DIAGNOSTICI QD
                                                  INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO
                                                  INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO
                                                WHERE
                                                      PA.ID_AGENDA=QA.ID_AGENDA
                                                  AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE
                                                  AND QA.CD_OPERATORE_LOGICO='U'
                                             )
                                      OR ( NOT EXISTS (
                                                         SELECT 0
                                                           FROM GP_QUESITI_DIAGNOSTICI QD
                                                           INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO
                                                           INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO
                                                         WHERE
                                                               PA.ID_AGENDA=QA.ID_AGENDA
                                                           AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE
                                                           AND QA.CD_OPERATORE_LOGICO='D'
                                                      ) AND NOT EXISTS ( SELECT 0 FROM GP_QUESITI_DIAGNOSTICI QD INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO WHERE PA.ID_AGENDA=QA.ID_AGENDA AND QA.CD_OPERATORE_LOGICO='U' ) AND NOT EXISTS ( SELECT 0 FROM GP_QUESITI_DIAGNOSTICI QD INNER JOIN V_GP_QUESITO QDP ON QDP.CD_QUESITO_DIAGNOSTICO=QD.CD_QUESITO_DIAGNOSTICO_PADRE INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QDP.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO WHERE AG.ID_AGENDA=QA.ID_AGENDA AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE AND QA.CD_OPERATORE_LOGICO='D' ) ) OR ( EXISTS ( SELECT 0 FROM GP_QUESITI_DIAGNOSTICI QD INNER JOIN V_GP_QUESITO QDP ON QDP.CD_QUESITO_DIAGNOSTICO=QD.CD_QUESITO_DIAGNOSTICO_PADRE INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QDP.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO WHERE AG.ID_AGENDA=QA.ID_AGENDA AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE AND QA.CD_OPERATORE_LOGICO='U' ) AND NOT EXISTS ( SELECT 0 FROM GP_QUESITI_DIAGNOSTICI QD INNER JOIN V_GP_QUESITI_DIAGN_AGENDE QA ON QD.ID_QUESITO_DIAGNOSTICO=QA.ID_QUESITO_DIAGNOSTICO INNER JOIN GP_TEMP_RA_PRESCRIZIONI R2 ON QD.ID_QUESITO_DIAGNOSTICO=R2.ID_QUESITO_DIAGNOSTICO WHERE PA.ID_AGENDA=QA.ID_AGENDA AND R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE AND QA.CD_OPERATORE_LOGICO='D' ) ) ) THEN 'S' ELSE 'N' END END END ) = 'S'
--
   AND ( CASE WHEN PA.ID_COMBINATA IS NULL OR NOT EXISTS ( SELECT 0 FROM V_GP_PRESTAZIONI_AGENDE CO WHERE CO.ID_AGENDA=PA.ID_AGENDA AND CO.ID_PRESTAZIONE!=PA.ID_PRESTAZIONE AND CO.ID_COMBINATA IS NOT NULL AND CO.ID_COMBINATA=PA.ID_COMBINATA AND ID_PRESTAZIONE NOT IN ( SELECT ID_PRESTAZIONE FROM GP_TEMP_RA_PRESCRIZIONI ) ) THEN 'S' ELSE 'N' END ) = 'S'
--
   AND TO_NUMBER(NVL(:B8 , NVL(NR_ETA_MIN, 0))) BETWEEN NVL(PA.NR_ETA_MIN, 0) AND NVL(PA.NR_ETA_MAX, 9999999999)
--
   AND NVL(:B7 , NVL(PA.CD_SESSO, 'G')) = NVL(DECODE ( PA.CD_SESSO, 'G', NVL(:B7 , NVL(PA.CD_SESSO, 'G')), PA.CD_SESSO ), 'G')
--
   AND EXISTS ( SELECT 0 FROM GP_TEMP_RA_PRESCRIZIONI R2 WHERE R2.ID_PRESCRIZIONE=RA.ID_PRESCRIZIONE AND DECODE ( NVL(R2.FL_URGENZA, 'N'), 'N', NVL(PA.FL_URGENZA, 'N'), 'S' )=NVL(PA.FL_URGENZA, 'N') AND DECODE ( NVL(R2.FL_INDICATORE_PRIORITA_ALTA, 'N'), 'N', NVL(PA.FL_PRIORITA_ALTA, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ALTA, 'N') AND NVL(R2.TIPO_INVIANTE, NVL(PA.CD_INVIANTE, '0')) =NVL(PA.CD_INVIANTE, '0') AND ( CASE WHEN NVL(R2.FL_PRIORITA_ORDINARIA_D, 'N')|| NVL(R2.FL_PRIORITA_ORDINARIA_P, 'N')|| NVL(R2.FL_ACCESSO_PROGRAMMABILE, 'N')='SSS' THEN CASE WHEN DECODE ( NVL(R2.FL_PRIORITA_ORDINARIA_D, 'N'), 'N', NVL(PA.FL_PRIORITA_ORDINARIA_D, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ORDINARIA_D, 'N') OR DECODE ( NVL(R2.FL_PRIORITA_ORDINARIA_P, 'N'), 'N', NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N') OR DECODE ( NVL(R2.FL_ACCESSO_PROGRAMMABILE, 'N'), 'N', NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N'), 'S' )=NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N') THEN 'S' ELSE 'N' END ELSE CASE WHEN NVL(R2.FL_PRIORITA_ORDINARIA_P, 'N')|| NVL(R2.FL_ACCESSO_PROGRAMMABILE, 'N')='SS' THEN CASE WHEN DECODE ( NVL(R2.FL_PRIORITA_ORDINARIA_P, 'N'), 'N', NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N') OR DECODE ( NVL(R2.FL_ACCESSO_PROGRAMMABILE, 'N'), 'N', NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N'), 'S' )=NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N') THEN 'S' ELSE 'N' END ELSE CASE WHEN DECODE ( NVL(R2.FL_PRIORITA_ORDINARIA_D, 'N'), 'N', NVL(PA.FL_PRIORITA_ORDINARIA_D, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ORDINARIA_D, 'N') AND DECODE ( NVL(R2.FL_PRIORITA_ORDINARIA_P, 'N'), 'N', NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N'), 'S' )=NVL(PA.FL_PRIORITA_ORDINARIA_P, 'N') AND DECODE ( NVL(R2.FL_ACCESSO_PROGRAMMABILE, 'N'), 'N', NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N'), 'S' )=NVL(PA.FL_ACCESSO_PROGRAMMABILE, 'N') THEN 'S' ELSE 'N' END END END ) = 'S' )
--
   AND NVL(:B6 , PA.FL_SOSPENSIONE_TOTALE) =PA.FL_SOSPENSIONE_TOTALE
--
   AND NVL(:B5 , NVL(AG.CD_REGIME_EROGAZIONE, '1')) =NVL(AG.CD_REGIME_EROGAZIONE, '1')
--
   AND NVL(:B4 , PA.FL_PRENOTABILITA) =PA.FL_PRENOTABILITA 
--
   AND ( CASE WHEN :B4 ='S' THEN CASE WHEN EXISTS ( SELECT 0 FROM GP_RUOLI_PRESTAZIONI_AGENDE RP WHERE RP.ID_PRESTAZIONE_AGENDA=PA.ID_PRESTAZIONE_AGENDA AND RP.ID_RUOLO=NVL ( :B10 , RP.ID_RUOLO ) AND SYSDATE BETWEEN RP.DT_INIZIO_VALIDITA AND NVL (RP.DT_FINE_VALIDITA, SYSDATE+1) ) THEN 'S' ELSE 'N' END ELSE 'S' END ) = 'S'
--
   AND ( ( NOT EXISTS ( SELECT 0 FROM TABLE ( CAST(:B11 AS TYP_GP_AZIENDE_SANITARIE_LIST) ) ) AND NOT EXISTS ( SELECT 0 FROM TABLE ( CAST(:B12 AS TYP_GP_PRESIDI_LIST) ) ) AND NOT EXISTS ( SELECT 0 FROM TABLE ( CAST(:B13 AS TYP_GP_REPARTI_LIST) ) ) AND NOT EXISTS ( SELECT 0 FROM TABLE ( CAST(:B14 AS TYP_GP_UNITA_EROGANTI_LIST) ) ) ) OR ( PA.ID_AZIENDA_SANITARIA IN ( SELECT DISTINCT * FROM TABLE ( CAST(:B11 AS TYP_GP_AZIENDE_SANITARIE_LIST) ) ) OR PA.ID_PRESIDIO IN ( SELECT DISTINCT * FROM TABLE ( CAST(:B12 AS TYP_GP_PRESIDI_LIST) ) ) OR PA.ID_REPARTO IN ( SELECT DISTINCT * FROM TABLE ( CAST(:B13 AS TYP_GP_REPARTI_LIST) ) ) OR PA.ID_UNITA_EROGANTE IN ( SELECT DISTINCT * FROM TABLE ( CAST(:B14 AS TYP_GP_UNITA_EROGANTI_LIST) ) ) ) )
--
   AND ( :B3 IS NULL OR EXISTS ( SELECT 0 FROM COMUNI_RD CO INNER JOIN PROVINCIE_RD PR ON CO.PROV_KEY_ID=PR.PROV_KEY_ID INNER JOIN V_DC_COMUNI_ASL_STORICO CA ON CO.CD_COMUNE_ISTAT=CA.CD_COMUNE_ISTAT WHERE PA.CD_COMUNE=CO.CD_COMUNE_ISTAT AND PR.CD_PROVINCIA_ISTAT =:B3 AND ( :B15 IS NULL OR CA.CD_ASL=SUBSTR ( :B15 , 4 ) ) AND SYSDATE BETWEEN CO.DT_INIZIO_VALIDITA AND NVL(CO.DT_FINE_VALIDITA, SYSDATE+1) AND SYSDATE BETWEEN PR.DT_INIZIO_VALIDITA AND NVL(PR.DT_FINE_VALIDITA, SYSDATE+1) AND SYSDATE BETWEEN NVL(CA.DT_INIZIO_COMUNE, SYSDATE-1) AND NVL(CA.DT_FINE_COMUNE, SYSDATE+1) AND SYSDATE BETWEEN NVL(CA.DT_INIZIO_ASL, SYSDATE-1) AND NVL(CA.DT_FINE_ASL, SYSDATE+1) ) )
--
   AND ( :B2 IS NULL OR ( :B1 IS NOT NULL AND EXISTS ( SELECT 0 FROM DISTANZA_COMUNI DC WHERE DC.CD_COMUNE_ORIGINE=:B1 AND DC.CD_COMUNE_DESTINAZIONE=PA.CD_COMUNE AND DC.NETWORK <= :B2 * 1000 ) ) )
--
   AND EXISTS ( SELECT 0 FROM V_GP_CALENDARI_PA CA WHERE CA.ID_PRESTAZIONE_AGENDA=PA.ID_PRESTAZIONE_AGENDA AND NVL(CA.DT_FINE_CALENDARIO, :B16 ) >= :B16 )
/
@?/rdbms/admin/utlxplp
