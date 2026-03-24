ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimgend"
    @author          Katia Coazzoli Adhoc
    @creation-date   02/04/2004
    
    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.
    
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.
    
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimgend-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== ====================================================================================================
    mat03 09/09/2025 Aggiunto l'invio di una mail se viene cambiata la matricola o se il generatore è attivo e l'impianto no.

    mat02 03/03/2025 Aggiustati gli element gen_prog e gen_prog_est nel form perche perdevano il valore nel submit

    mat01 27/01/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.

    rom41 28/02/2028 Corretto erroe sul mittente della mail inviata all'ente nei casi di generatori indicati con camera di
    rom41            combustione aperta e scarico fumi a camino collettivo.

    rom40 24/11/2023 Anche per Citta' Metropolitana di Napoli gli utenti dell'ente e amministratori i controlli sui campi
    rom40            sono sempre saltati come su Regione Friuli.

    but02 21/06/2023 Aggiunto la classe ah-jquery-date al campo: data_installaz, data_rottamaz, data_costruz_bruc
    but02            , data_installaz_bruc, data_costruz_gen

    rom39 06/07/2023 Modificata l'opzione del campo rif_uni_10389 per il teleriscaldamento su indicazione di Giuliodori.
    rom39            Con SAndro si e' deciso di far valere la modifica per tutti gli enti.

    rom38 29/06/2023 Gestito con if il mittente della mail per la Provincia di Fermo.

    rom37 22/05/2023 Modifica all'intervento di but01 su segnalazione di Belluzzo: Il controllo non va fatto per i combustibili solidi.

    rom36 08/05/2023 Committata vecchia modifica per Palermo, fluido_lato_utenze non e' piu' obbligatorio.

    but01 27/03/2023 Ho dovuto aggiungere un controllo de generatore a tiraggio naturale con data installazione > 01 01 2022
    but01            deve avere per forza il flag canna fumaria collettiva  per tutti gli enti (tranne le marche) 

    ric01 03/03/2023 Solo per UCIT, per gli impianti del freddo, mostro le potenze utili dei generatori in base alla loro
    ric01            destinazione d'uso e non piu la maggiore delle due.

    rom35 22/02/2023 Regione Friuli ha richiesto che per gli utenti dell'ente e amministratori i controlli sui campi obbligatori
    rom35            siano sempre saltati. Hanno richiesto che le potenze per il freddo siano sempre obbligatorie.
    rom35            Infine hanno chiesto do eliminare alcune voci della destinazione d'uso perche' considerate doppie rispetto ad altre.

    rom34 02/02/2023 Messo il sistema di azionamento obbligatorio anche per Regione Campania e Palermo sugli impianti del freddo.
    rom34            Il campo serve per calcolare la scadenza degli rcee quindi deve essere valorizzato per evitare server error.

    rom33 30/01/2023 Belluzzo ha richiesto con mail "Richiesta informativa normativa Dpr 660/96" del 20/01/2023 di rendere
    rom33            il campo Marcatura efficienza energetica (marc_effic_energ) non obbligatorio.

    rom32 25/01/2023 Belluzzo ha richiesto che il campo Marcatura efficienza energetica (marc_effic_energ) sia fatto a tendina
    rom32            come per Regione Marche, ho avvisato Sandro che chi aveva valorizzato in precedenza il campo con valori diversi
    rom32            da quelli prestabiliti da noi non vedra' piu' niente ma mi ha detto che va bene cosi'.

    rom31 24/01/2023 Modificato intervento di rom30, i controlli fatti per il Friuli sulla modifica del gen_prog non servono
    rom31            piu' perche' il gen_prog non e' piu' modificabile quindi li bypasso.

    mic01 05/08/2022 Creata variabile pot_max per visualizzare correttamente le potenze sugli impianti del freddo e per
                     selezionare la fascia di potenza corretta, prendendo in considerazione il valore massimo tra
                     tot_pot_focolare_nom e tot_pot_focolare_lib.

    rom30 27/07/2022 Modifiche per allinemanto enti di UCIT al nuovo cvs:
    rom30            Le modifiche e particolarita' fatte per i vari enti di UCIT ora vengono messi
    rom30            in un'unica condizione riguardante la Regione Friuli.
    rom30            I controlli sulle abilitazioni vengono fatti in base al parametro flag_controllo_abilitazioni.
    rom30            Modifica per UCIT: i manutentori non possono andare a modificare il gen_prog.
    rom30            Modifica per UCIT: non si puo modificare il gen_prog se ci al generatore ci
    rom30            sono gia' associati degli RCEE, rapoorti di ispezione e controlli di frequenza.
    rom30            Corretto un erore dpresente nella modifica di rom01.
    rom30            Ucit non deve piu' vedere la Potenza frigorifera utile (pot_utile_nom_freddo) sul freddo.


    rom29 20/04/2022 Su richiesta di regione Marche modificata MEV Stato impianto "Rottamato":
    rom29            se il manutentore disattiva il generatore, e non ce ne sono altri attivi,
    rom29            l'impianto va messo in stato NonAttivo. Se poi un generatore viene riattivato
    rom29            l'impianto va riportato in stato Attivo se a farlo e' un utente dell'ente,
    rom29            se la riattivazione viene fatta dal manutentore l'impianto non va riattivato.
    rom29            Queste modifiche sono state richieste e concordate nella call tra Sandro e regione.

    rom28 08/04/2022 Corretto intervento di rom24, siccome ora i bruciatori non sono piu' modificati
    rom28            o inseriti da qua, non devo piu' andare a modificare i loro dati da questo programma.

    rom27 07/04/2022 Su segnalazione di Regione Basilicata corretta anomalia sul campo mod_funz.
    rom27            Per gli impianti diversi dal caldo non era possibile indicare le note se si
    rom27            selezionava Altro dalla tendina. I controlli sull'obbligatorieta' vanno fatti anche
    rom27            per la cogenerazione, tutto questo vale se no si e' di Regione Marche che usa i campi
    rom27            in maniera diversa e non aveva l'anomalia.
    rom27            Regione Basilicata ha richiesto di non aver piu' il blocco dei combustibili
    rom27            per i manutentori come Regione Marche.
    
    rom26 31/03/2022 Su richiesta di Giuliodori con mail "MEV rilasciata in produzione." del 28/03/2022
    rom26            vado a modificare/implementare l'intervento di rom25 per la MEV Stato impianto "Rottamato".
    rom26            Aggiunto warning in caso di disattivazione del generatore e cambiato messaggio di errore per la data_rottamaz

    rom25 18/03/2022 Manutenzione evolutiva richiesta da regione Marche.
    rom25            25.  Stato impianto "Rottamato" in scheda 1.bis:
    rom25            Se vengono resi non attivi i generatori l'impianto assume lo stato di NON ATTIVO.
    rom25            Se l'impianto e' non Attivo e viene riattivato il generatore
    rom25            anche l'impianto passa in stato Attivo.
    
    rom24 02/03/2022 Regione Marche tramite mail di Giuliodori "sostituzione bruciatore" del 20/01/2022
    rom24            ha richiesto che per ogni generatore sia possibile sostituire il bruciatore.
    rom24            Con Sandro si e' deciso di dare la possibilita' di avere piu' bruciatori attivi
    rom24            per lo stesso generatore. Quando un generatore viene sostituito i bruciatori attivi
    rom24            collegati al generatore vanno disattivati. Il nuovo generatore attivo all'inizio non
    rom24            ha nessun bruciatore collegato.

    rom23 30/11/2021 In fase di cancellazione devo verificare se il gen_prog che sto eliminando
    rom23            figura come gen_prog_originario in un altro generatore dello stesso impianto e
    rom23            andare a sbiancare il campo, altrimenti la stampa del libretto non esce corretta.

    rom22 14/05/2021 Regione Basilicata ha gli stessi blocchi del combustibile come Regione Marche.
    rom22            Reso obbligatorio il sistema di azionamento 

    sim20 04/08/2021 Corretto errore su controlli dei campi cop e per

    rom21 20/04/2021 Su richiesta di Regione Marche vado ad implementare le modifiche fatte da sim19.
    rom21            Sandro ha detto che queste modifiche vanno bene per tutti gli enti.
    rom21            Per climatizzazione invernale ed estiva devono esserci tutte le potenze.
    rom21            Per climatizzazione invernale solo le potenze del caldo.
    rom21            Per climatizzazione estiva solo le potenze del freddo.

    sim19 12/04/2021 Modificato i controlli sulle potenze in modo che si possano inserire anche solo
    sim19            quelle del riscaldamento o solo quelle del raffrescamento.
    sim19            Non posso avere situazioni ibride dove indico solo uno dei campi relativi alle potenze.
    sim19            Corretto anche un errore della modifca gac08. Il numero circuiti sul freddo deve essere
    sim19            un errore bloccante.

    rom20 08/02/2021 Aggiunto controllo sul campo marc_effic_energ: non puo' contenere i caratteri
    rom20            < e > perche' poi in fase di stampa potrebbero essere considerati come apertura
    rom20            o chiusura dei tag html e, diconseguenza, fare visualizzare male la stampa.

    rom19 11/09/2020 Per un'anomalia segnalata sulla disattivazione di un generatore su Salerno 
    rom19            Sandro ha detto che il campo motivazione_disattivo va messo obbligatorio 
    rom19            solo per la Regione Marche. Sugli altri enti il campo non e visibile.

    rom18 21/05/2020 Aggiunto controllo sui campi cop e per su richiesta di Sandro: non possono
    rom18            superare il valore di 10

    sim18 17/03/2020 Implementato controllo sulla dimensione del campo rend_ter_max

    rom17 28/02/2020 Se sto facendo una sostituzione non devo tenere conto 
    rom17            nei conteggi del generatore sostituito.

    sim17 05/02/2020 Corretto errore su teleriscaldamento

    sim16 04/02/2020 La gestione del numero progressivo in fase di sostituzione usato per la Regione
    sim16            Marche ora diventa standard.

    sim15 04/12/2019 Le autorita competenti, devono poter modificare il combustibile anche se prima era
    sim15            vuoto. 

    gac08 25/11/2019 Le autorita competenti, per gli impianti del caldo, potranno visualizzare la
    gac08            tendina "Combustibile" con tutti i combustibili del caldo.
    gac08            Se si seleziona un tipo combustibile diverso dal combustibile precedente uscira
    gac08            un warning non bloccante.
    
    sim14 25/11/2019 Per calcolare la fascia di potenza usiamo la max tra Potenza frigorifera nominale
    sim14            e la  Potenza termica nominale
    
    sim13 22/11/2019 Corretto controlli su fascia di potenza sul teleriscaldamento.

    sim12 11/11/2019 Modifico le regole di controllo nel caso in cui l data costruzione sia successiva al 26/09/2015
    sim12            -Se Camera di combustione e uguale a "Stagna", allora Classif. DPR 660/96 deve essere
    sim12             uguale a "A gas a condensazione".
    sim12            -Se Camera di combustione e uguale a "Aperta", allora non ho vincoli su Classif. DPR 660/96. Pero
    sim12             se "Scarico fumi" e uguale a "Camino collettivo" va avvistata con una email la autorita
    sim12             competente.
    sim12            Il vecchio controllo e stato tolto.

    rom05B 09/04/2019 Per la BAT sono stati portati su iter standard i controlli sulla tipologia impianto
    rom05B           gia sviluppati per la regione ma non committati. Sono marcati come rom03M

    rom16 05/03/2019 Aggiunto il campo tel_alimentazione su richiesta della Regione Marche, Sandro
    rom16            ha detto che il campo puo' essere visualizzato da tutti gli enti, basta che
    rom16            l'impianto sia del teleriscaldamento.

    rom15 19/02/2019 Per gli impianti del freddo della Regione Marche non faccio piu visualizzare
    rom15            i campi flag_altro e funzione_grup_ter_note_altro. 
    rom15            Richiesta fatta dalla Regione dopo call del 18/02/2019.
    rom15            Richiesta di Sandro: per le marche in un impianto del freddo se il campo
    rom15            pot_focolare_lib e' valorizzato con 0.00, non si puo' fleggare a Si' il campo
    rom15            flag_prod_acqua_calda. Sandro ha detto di togliere il controllo sull'obbligatorieta'
    rom15            dell'Installatore dopo la data del 01-07-2018 per le marche.
    
    rom14 23/01/2019 Aggiunto warning richiesto dalle Marche sulla sostituzione: se si sostituisce
    rom14            un generatore e la Tipologia Intervento della Scheda1 e diveersa da
    rom14            "Sostituzione del generatore" mostro un messaggio in rosso non bloccante.
    rom14            La regione marche chiede di non avere piu obbligatorio il campo data_costruz_gen
    rom14            per gli impianti del freddo, del teleriscaldamento e la cogenerazione.
    
    rom13 08/01/2019 Modifiche per le Marche sul freddo.

    gac07 19/12/2018 Aggiunto controllo in caso di tipologia generatore Altro e flag_ibrido N non
    gac07            faccio inserire la scheda 4.1.
    
    gac06 18/12/2018 Modificato rom12 non devo far vedere la potenza nominale dell'impianto, ma
    gac06            quella del generatore.

    rom12 29/11/2018 Aggiunti i campi flag_clima_invernale, flag_clim_est, flag_prod_acqua_calda e flag_altro.
    rom12            I nuovi campi prendono il posto di funzione_grup_ter; Sandro ha detto di farlo
    rom12            per tutti gli enti. A fianco dei nuovi faccio vedere la potenza nominale
    rom12            dell'impianto se sono flaggati con "Si".
    rom12            Eliminando il generatore elimino anche le singole potenze delle prove fumi.

    rom11 15/11/2018 Gestisco la visualizzazione dei messagi di errore relativi al campo gen_prog.

    rom10 05/11/2018 Tolto il controllo sul campo cod_utgi per la Regione Marche che non visualizza
    rom10            piu il campo. Nella stampa del libretto la sezione 1.3 sara compilata in base al
    rom10            campo 

    rom09 24/10/2018 Su richiesta delle MARCHE aggiungo i campi cognome_inst e nome_inst dell'installatore.
    rom09            Li faccio vedere solo alla Regione Marche e lo metto obbligatorio solo se 
    rom09            data_installaz e maggiore del 01-07-2018.  
    rom09            Se un manutentore modifica, aggiunge o toglie l'Intestatario con la data_installaz
    rom09            maggiore del 01-07-2018 mando una mail all'autorita competente.
    rom09bis         Sandro mi ha detto che per ogni generatore di un impianto puo esserci un installatore
    rom09bis         differente, il cod_installatore verra qiondi preso e salvato sulla coimgend e non piu
    rom09bis         dalla coimaimp. (Aggiunta del 15/01/2019).
    
    rom08 17/10/2018 Su richiesta di Sandro faccio vedere gli asterischi rossi solo se sono in
    rom08            modifica o inserimento per i campi cod_emissione, pot_utile_nom e marc_effic_energ.

    rom07 17/09/2018 Aggiunta la gestione per la "Sostituzione del generatore" per la Regione Marche.
    rom07.bis        Sandro ha detto che in sostituzione il generatore sostituito non deve avere
    rom07.bis        gen_prog_est come max + 1 dei generatori in generale ma bisogna fare il max + 1
    rom07.bis        solo dei generatori sostituiti.

    sandro07082018   aggiunto la possibilita di digitare solo la data nella data costruzione
    gac05 16/07/2018 Marcatura efficienza energetica obbligatorio solo dal 01/01/2015, quindi non 
    gac05            devo bloccare se inserito con data installazione anteriore.

    gac04 02/07/2018 Modificate label

    rom06 19/06/2018 Aggiunto link_coimgend_pote se il generatore ha piu' di una prova fumi.
    rom06            Solo per il freddo messi obbligatori i campi pot_utile_lib e pot_focolare_lib.

    sim09 13/06/2018 Se la data installazione e' successiva al 1 luglio 2018 l'installatore e'
    sim09            obbligatorio.

    rom05 07/06/2018 Su richiesta della Regione Marche, per il freddo, non faccio vedere i campi
    rom05            dpr_660_96, flag_caldaia_comb_liquid, funzione_grup_ter, funzione_grup_ter_note_altro.
    rom05            Messi obbligatori colo per le Marche i campi per e cop.

    rom04 28/05/2018 Aggiunto il campo altro _funz e warning sul campo "Rendimento termico utile a PN max"
    rom04            Solo per le marche il combustibile dei generatori deve essere dello stesso tipo
    rom04            in inserimento di un nuovo generatore e modifica dello stesso.

    gac03 07/05/2018 Aggiunti campi riferimento UNI-10389-1 e altro
    
    rom03M 24/04/2018 Per le Marche: aggiunti i controlli in fase di inserimento e modifica per fare  
    rom03M            in modo che un manutentore possa inserire o modificare i generatori solo sulle  
    rom03M            tipologie per cui e' abilitato. 

    rom04 20/12/2018 UCIT e Comune di Trieste non possono modificare le prove fumi per il caldo e  
    rom04            il numero circuiti per il freddo.

    rom03 16/10/2018 Sui generatori di un impianto del freddo non faccio piu vedere il campo dpr_660_96.

    sim10 10/09/2018 Corretto modifica rom02 che faceva la if sulla potenza non in formato numerico

    rom02 11/04/2018 Fatte modifiche della nuova scheda 4.1bis per Regione Marche 

    sim09 27/06/2018 Va tenuto conto della potenza del generatore in cui sto operando solo se e
    sim09            attivo

    rom02 15/06/2018 UCIT e Comune Trieste possono avere solo una prova fumi se su un impianto del 
    rom02            caldo il generatore ha la pot_focolare_nom minore di 35 (kw).

    gac02 12/02/2018 Gestiti nuovi campi del cogeneratore
    
    sim08 24/01/2018 Aggiunto i nuovi campi per e cop sul generatore del freddo
    
    rom01 23/01/2018 Gestito il nuovo campo num_prove_fumi sul generatore del caldo.
    rom01            num_prove_fumi deve essere sempre maggiore di 0.
    
    gac01 16/01/2018 Aggiunto controllo per fare in modo che non si possa cancellare un generatore
    gac01            nel caso in cui ci siano dichiarazioni.
    
    sim07 13/11/2017 Concordato con Sandro che il controllo sulla potenza diventa blocante in
    sim07            caso di modifica e inserimento. Sandro ha detto che in fase di cancellazione
    sim07            non deve essere bloccante

    sim06 03/11/2017 num_circuiti deve essere sempre maggiore di 0
    
    sim05 19/10/2017 Gestito il nuovo campo num_circuiti sul generatore del freddo.
    sim05            Richiesto per la DAM delle Marche ma va bene per tutti gli enti e di default e' 1
    
    sim04 01/08/2017 Aggiunto la potenza utile del freddo che in un primo momento non era stata
    sim04            prevista.
    sim04            Dato che si era deciso di riusare il campo pot_utile_nom per la potenza di
    sim04            assorbimento ho dovuto usare il nuovo campo pot_utile_nom_freddo
    sim04            Per il freddo il controllo sulle potenze andra' fatto sul nuovo campo.
    sim04            Anche il totale sulla coimaimp sara' calcolato sul nuovo campo.
    sim04            Aggiunto controllo per verificare che esista la fascia di potenza.
    
    gab03 11/07/2017 In fase di cancellazione controllo che non esistano righe sulla tabella
    gab03            coimdope_gend
    
    gab02 10/04/2017 Nella tendina del combustibile faccio vedere solo il teleriscaldamento 
    gab02            quando si tratta di un impianto teleriscaldamento.
    gab02            Inoltre ho aggiunto delle if per non eseguire dei controlli di obbligatorieta' 
    gab02            (nel caso di un impianto teleriscaldamento) su campi che non sono
    gab02            presenti nella form del generatore quando il flag_tipo_impianto e' "T". 
    
    sim03 17/11/2016 Gestito la potenza in base al flag_tipo_impianto
    
    gab01 07/10/2016 Aggiunti asterischi (*) davanti ai campi obbligatori
    
    sim02 04/10/2016 Aggiunto Non noto a locale
    
    san04 08/09/2016 I controlli di obbligatorieta' vanno fatti solo per i generatori attivi.
    
    san03 06/09/2016 Aggiunto controllo: la potenza utile deve essere <= a quella nominale.
    san03            Richiesta obbligatorieta' di altri campi.
    
    sim01 09/05/2016 Aggiunta sul generatore del freddo la Potenza Nominale in riscaldamento e
    sim01            Potenza Utile in riscaldamento. 
    sim01            Per gli impianti del freddo, va salvata sull'impianto la potenza maggiore
    sim01            tra quella del freddo e quella del caldo (la somma di tutti i gen. attivi)
    sim01            Bisogna confrontare la somma delle potenze del freddo di tutti i
    sim01            generatori attivi con la somma delle potenze del caldo di tutti i
    sim01            generatori attivi e la potenza massima deve essere salvata sulla
    sim01            rispettiva colonna della coimaimp
    sim01            (una somma per la nominale ed una per la utile).
    
    nic03 12/02/2016 Gestito parametro coimtgen(flag_potenza)
    
    san02 14/01/2016 Calcolo cod_potenza usando potenza_utile per la regione marche.
    
    san01 05/01/2015 Aggiunto il campo gruppo termico
    
    nic01 17/03/2014 Comune di Rimini: se e' attivo il parametro flag_gest_coimmode, deve
    nic01            comparire un menu' a tendina con l'elenco dei modelli relativi al
    nic01            costruttore selezionato (tale menu' a tendina deve essere rigenerato
    nic01            quando si cambia la scelta del costruttore).
    nic01            Ho dovuto aggiungere la gestione dei campi __refreshing_p e changed_field.
   
} {
    
    {cod_impianto     ""}
    {gen_prog         ""}
    {last_gen_prog    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {url_list_aimp    ""}
    {url_aimp         ""}
    {evidenzia_rend_ter ""}
    {gen_prog_est     ""}
    {gen_prog_old     ""}
    {msg_cod_combustibile ""}
} -properties {    
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
    focus_field:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
set cod_manutentore [iter_check_uten_manu $id_utente];#rom03M
# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-GENDGEST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-GENDGEST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-GENDGEST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

db_1row query "select id_settore
                    , id_ruolo
                 from coimuten
                where id_utente = :id_utente";#rom35

# Controlla lo user

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}  
    "M" {set lvl 3}   
    "D" {set lvl 4}
    "S" {set lvl 2}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

iter_get_coimtgen;#nic01

set gen_prog_old $gen_prog;#rom07

set link_gest [export_url_vars cod_impianto gen_prog last_gen_prog gen_prog_est gen_prog_old nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

if {$funzione eq "S"} {
    set func_s "func-sel"
} else {
    set func_s "func-menu"
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina

set link_list_script {[export_url_vars cod_impianto last_gen_prog caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set funzione_caller $funzione;#rom24
set sel_gend_bruc [db_map sel_gend_bruc];#rom24
set gest_prog_1 "coimgend-bruc-gest";#rom24
set link_aggiungi_1 "<a href=\"$gest_prog_1?funzione=I&gen_prog=$gen_prog&funzione_caller=$funzione_caller&$link_list\" class=\"link-button-2\">Aggiungi</a>";#rom24
set link_1 "\[export_url_vars  numero_bruc gen_prog\]&$link_list";#rom24
set actions_1 "<td nowrap><a href=\"$gest_prog_1?funzione=V&funzione_caller=$funzione_caller&$link_1\" class=\"link-button-2\">Selez.</a>";#rom24

set table_def_1 [list \
		     [list actions_1                   "Azioni"             no_sort $actions_1] \
		     [list numero_bruc                 "Bruc. n."           no_sort {c}] \
		     [list data_installaz_bruc_edit    "Data inst."         no_sort {c}] \
		     [list data_rottamaz_bruc_edit     "Data rott."         no_sort {c}] \
		     [list flag_sostituito_bruc_edit   "Sostituito?"        no_sort {c}] \
		     [list fabbricante_bruc            "Fabbricante"        no_sort {c}] \
		     [list modello_bruc                "Modello"            no_sort {c}] \
		     [list matricola_bruc              "Matricola"          no_sort {c}] \
		     [list tipo_bruciatore             "Tipologia"          no_sort {c}] 
		];#rom24

if {$coimtgen(regione) eq "MARCHE"} {#rom24 Aggiunta if e suo contenuto
    lappend table_def_1 [list campo_funzion_max_edit      "Pot. term. max"     no_sort {c}] \
	[list campo_funzion_min_edit      "Pot. term. min"     no_sort {c}]
   
}

set table_result_1 [ad_table -Tmissing_text "Non &egrave; presente nessun bruciatore." -Textra_vars {numero_bruc cod_impianto gen_prog caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_gend_bruc $table_def_1];#rom24

set current_date      [iter_set_sysdate]

set titolo              "generatore"
switch $funzione {
    M {set button_label "Conferma modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma cancellazione"
	set page_title   "Cancella $titolo"}
    I {set button_label "Conferma inserimento"
	set page_title   "Inserisci $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizza $titolo"}
    S {set button_label "Conferma sostituzione"
	set page_title   "Sostituzione $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

if {$coimtgen(regione) eq "MARCHE"} {
    set label_tipo_foco "Camera di combustione"
    set label_tiraggio  "Evacuazione fumi"
} else {
    set label_tipo_foco "Tipo generatore"
    set label_tiraggio  "Tiraggio"
}

if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunta if e suo contenuto
#rom14    set tipologia_generatore [db_string q "select tipologia_generatore 
#rom14                                             from coimaimp 
#rom14                                            where cod_impianto = :cod_impianto" -default ""]
#rom14    set flag_ibrido [db_string q "select flag_ibrido 
#rom14                                    from coimaimp 
#rom14                                   where cod_impianto = :cod_impianto" -default ""]
    db_1row q "select coalesce(tipologia_generatore, '') as tipologia_generatore
                    , coalesce(flag_ibrido, '')          as flag_ibrido
                    , coalesce(tipologia_intervento, '') as tipologia_intervento
                    , case tipologia_intervento
                      when 'RISTR' then 'Ristrutturazione'
                      when 'NUINS' then 'Nuova Installazione'
                      when 'COLIE' then 'Compilazione libretto impianto esistente'
                      else ''
                       end as tipologia_intervento_edit
                 from coimaimp
                where cod_impianto = :cod_impianto";#rom14
    
    if {$tipologia_generatore eq "ALTRO" && $flag_ibrido eq "N"} {
	#iter_return_complaint "Dati inseriti nella Scheda 1 incongruenti, passare ad \"Altre schede libretto\""
	iter_return_complaint "&egrave; stata compilata la scheda 1.5 in modo incongruente, passare ad \"Altre schede libretto\"."
    }
    if {$funzione eq "S" } {#rom14 aggiunta if, else e loro contenuto
	if {$tipologia_intervento eq ""} {
	    set warning_sostituzione "<font color=red>WARNING: Manca la Tipologia Intervento sulla Scheda 1.1</font>"
	} elseif {$tipologia_intervento ne "SOSGE"} {
	    set warning_sostituzione "<font color=red>WARNING: La Tipologia intervento selezionata sulla Scheda 1.1 &egrave; $tipologia_intervento_edit.<br>Si prega di correggere selezionando \"Sostituzione del generatore\"</font>"
	} else {
	    set warning_sostituzione ""
	}
    } else {
	set warning_sostituzione ""
    };#rom14

}
#gab02 ho spostato questa parte di codice dove viene estratto il flag_tipo_impianto qui perche la variabile mi serve per settare where_cod_comb
if {![db_0or1row query "select flag_tipo_impianto
                          from coimaimp
                         where cod_impianto = :cod_impianto"]
} {;#dpr74
    iter_return_complaint "Impianto non trovato";#dpr74
};#dpr74

if {$flag_tipo_impianto eq "T"} {#gab02 aggiunta if, else e contenuto
    set where_cod_comb "and cod_combustibile = '7'"
} else {
    set where_cod_comb ""
}
#rom22if {($coimtgen(regione) eq "MARCHE")} {}#rom02 if e suo contenuto
#rom27 Rimossa la BASILICATA dalla lista
if {$coimtgen(regione) in [list "MARCHE"]} {#rom22 Aggiunta if ma non il suo contenuto
    if {$funzione eq "V" || $funzione eq "D"} {
        set where_tipo_comb ""
    }
    if {$funzione eq "I" || $funzione eq "S"} {#rom04 if e suo contenuto
	
	set tipo_comb_where ""
	if {[db_0or1row q "select coalesce(c.tipo, '&nbsp') as tipo_comb_where
                                      from coimcomb c
                                         , coimgend g
                                     where c.cod_combustibile = g.cod_combustibile
                                       and g.cod_impianto = :cod_impianto
                                     order by gen_prog
                                     limit 1"]} {
	    #gac08set where_tipo_comb "and tipo = '$tipo_comb_where'"
	} else {
	    #se sull'impianto ho cancellato tutti i generatori vado a prendere il tipo combustibile dal combustibile 
	    #dell'impianto
	    db_0or1row q "select coalesce(c.tipo, '&nbsp') as tipo_comb_where
                            from coimcomb c
                               , coimaimp i
                           where c.cod_combustibile = i.cod_combustibile
                             and i.cod_impianto = :cod_impianto
                            limit 1"
	}
	
	#gac08set where_tipo_comb "and tipo = '$tipo_comb_where'"

	
    };#rom04

    if {$funzione eq "M"} {#rom04 if e suo contenuto
	set tipo_comb_where [db_string q "select coalesce(c.tipo, '&nbsp')
                                      from coimcomb c
                                         , coimgend g
                                     where c.cod_combustibile = g.cod_combustibile
                                       and g.cod_impianto = :cod_impianto
                                       and g.gen_prog = :gen_prog
                                     limit 1" -default ""]
	#sim15 aggiunto condizione su cod_manutentore
	if {$tipo_comb_where eq "" && $cod_manutentore ne ""} {
	    iter_return_complaint "Impianto non inserito correttamente. In fase di inserimento non &egrave; stato specificato nessun combustibile. Contattare l'ente per bonificare i dati."
	}

	#gac08set where_tipo_comb "and tipo = '$tipo_comb_where'"
    };#rom04

    set where_cod_comb "and cod_combustibile not in ( '0','2')"

    if {$funzione eq "M" || $funzione eq "I" || $funzione eq "S"} {#gac08 aggiunta if else e loro contenuto

	if {$cod_manutentore eq ""} {
	    set where_tipo_comb ""
	    #gac08 escludo i combustibili che non si riferiscono all'impianto del caldo
	    set where_cod_comb "and cod_combustibile not in ( '0','2','7','20','88')"
	} else {
	    if {$flag_tipo_impianto eq "R"} {
		set where_tipo_comb "and cod_combustibile not in ('88') and tipo = '$tipo_comb_where'"
	    } else {
		set where_tipo_comb "and tipo = '$tipo_comb_where'"
	    }
	}
    }

} else {#rom04 else e suo contenuto
    set where_tipo_comb ""
}


if {$funzione eq "V"} {
    if {$flag_tipo_impianto eq "F"} {
	set select_potenza "coalesce(iter_edit_num(pot_focolare_nom,2),'0,00') as potenza_utile
                              , coalesce(iter_edit_num(pot_focolare_lib,2),'0,00') as potenza_termica_nominale"
    } elseif {$flag_tipo_impianto eq "T"} {#rom14 aggiunta elseif e contenuto
	    set select_potenza "coalesce(iter_edit_num(pot_focolare_nom,2),'0,00') as potenza_utile"
    } else {
	set select_potenza "coalesce(iter_edit_num(pot_utile_nom, 2),'0,00') as potenza_utile"
    }
    
    if {![db_0or1row q "select $select_potenza --rom13
         --rom13          coalesce(iter_edit_num(pot_utile_nom, 2),'&nbsp;') as potenza_utile --gac06
         --gac06          coalesce(iter_edit_num(g.potenza_utile, 2),'&nbsp;') as potenza_utile 
                        , coalesce(c.descr_comb, '&nbsp;') as label_combustibile --rom13 
                        , coalesce(g.cod_tpco, '0') as cod_tpco --rom13
                     from coimaimp a
                     join coimgend g on a.cod_impianto = g.cod_impianto--gac06
          left outer join coimcomb c on c.cod_combustibile = a.cod_combustibile--rom13
                    where g.cod_impianto = :cod_impianto
                      and g.gen_prog = :gen_prog --gac06"]} {#rom12 if e contentuto
	set potenza_utile "0,00"
	set label_combustibile ""
	set potenza_termica_nominale "0,00"
	set cod_tpco "0"
    }
    if {[db_0or1row q "select flag_clima_invernale
                             from coimgend
                            where cod_impianto = :cod_impianto
                              and gen_prog = :gen_prog
	                      and flag_clima_invernale = 'S'"] ==1} {
	set pot_utile_inv "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_utile"
	if {$flag_tipo_impianto eq "F"} {#rom14 per il freddo mostro la maggiore tra la potenza nominale frigorifera e termica
	    set potenza_nominale_fr [iter_check_num $potenza_utile 2]
	    set potenza_nominale_ri [iter_check_num $potenza_termica_nominale 2]
   
	    if {$potenza_nominale_ri > $potenza_nominale_fr} {
		set pot_utile_inv "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_termica_nominale"
	    }
	    
	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#ric01 aggiunta if e suo contenuto
		set pot_utile_inv "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_termica_nominale"
	    }
	}
    } else {
	set pot_utile_inv ""
    }
    if {[db_0or1row q "select flag_clim_est
                             from coimgend
                            where cod_impianto = :cod_impianto
                              and gen_prog = :gen_prog
                              and flag_clim_est = 'S'"] ==1} {
	set pot_utile_est "&nbsp;<b>Potenza Utile:</b>&nbsp;$potenza_utile"
	if {$flag_tipo_impianto eq "F"} {#rom14 per il freddo mostro la maggiore tra la potenza nominale frigorifera e termica
	    set potenza_nominale_fr [iter_check_num $potenza_utile 2]
	    set potenza_nominale_ri [iter_check_num $potenza_termica_nominale 2]
	    
	    if {$potenza_nominale_ri > $potenza_nominale_fr} {
		set pot_utile_est "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_termica_nominale"
	    }
	    
	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#ric01 aggiunta if e suo contenuto
		set pot_utile_est "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_utile"
	    }
	}
    } else {
	set pot_utile_est ""
    }
    if {[db_0or1row q "select flag_prod_acqua_calda
                             from coimgend
                            where cod_impianto = :cod_impianto
                              and gen_prog = :gen_prog
                              and flag_prod_acqua_calda = 'S'"] ==1} {
	if {$flag_tipo_impianto eq "F"} {#rom14 aggiunta if e contenuto, aggiunta else ma non contenuto
	    set pot_utile_acq "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_termica_nominale"
	} else {
	    set pot_utile_acq "&nbsp;<b>Potenza utile:</b>&nbsp;$potenza_utile"
	};#rom14
    } else {
	set pot_utile_acq ""
    }
    if {$cod_tpco eq 1 } {#rom13 if, else e contenuto
	set label_combustibile "&nbsp;con combustibile&nbsp;<b>$label_combustibile</b>"
    } else {
	set label_combustibile ""
    }
} else {
    set pot_utile_inv ""
    set pot_utile_est ""
    set pot_utile_acq ""
    set label_combustibile "";#rom13
}



#gac02 aggiunta if e suo contenuto se l'impianto e un cogeneratore come combustibile posso scegliere sono cogeneratore
if {$flag_tipo_impianto eq "C"} {#gac02 aggiunta if, else e contenuto
    set where_cod_comb "and cod_combustibile = '20'"
    set where_tipo_comb ""
}
#se l'impianto e del teleriscaldamento come combustibile posso scegliere solo teleriscaldamento
if {$flag_tipo_impianto eq "T"} {
    set where_cod_comb "and cod_combustibile = '7'"
    set where_tipo_comb ""
}
if {$flag_tipo_impianto eq "F"} {#se l'impianto e' del freddo posso scegliere solo pompa di calore
    set where_cod_comb "and cod_combustibile = '88'"
    set where_tipo_comb ""
}
set ast "<font color=red>*</font>";#rom05
set ast_MARCHE "";#rom05
set ast_freddo "";#rom06
if {$coimtgen(regione) eq "MARCHE"} {#rom05 if e contenuto
    set ast_MARCHE $ast
};#rom05
if {$flag_tipo_impianto eq "F"} {#rom06 if e contenuto
    set ast_freddo $ast
};#rom06

#sim16 set link_sost_gen "";#rom07
#sim16 if {$coimtgen(regione) eq "MARCHE"} {#rom07 if e contenuto
    set link_sost_gen "S"
    if {[db_0or1row q "select 1 
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and gen_prog     = :gen_prog
                          and flag_attivo  = 'N'
                          and flag_sostituito = 'S'"]} {
	set link_sost_gen "N"
    }
#sim16}
if {[db_0or1row q "select flag_attivo as gen_attivo
                     from coimgend 
                    where cod_impianto = :cod_impianto
                      and gen_prog = :gen_prog
                      and flag_attivo = 'N'"]==0} {#rom13 if e contenuto
    set gen_attivo "S"
};#rom13

if {$gen_attivo eq "N"} {#rom13
    if {$flag_tipo_impianto eq "R"} {
	set msg_dismesso "<b>GT dismesso</b>"
    }
    if {$flag_tipo_impianto eq "F"} {
	set msg_dismesso "<b>GF dismesso</b>"
    }
    if {$flag_tipo_impianto eq "T"} {
	set msg_dismesso "<b>SC dismesso</b>"
    }
    if {$flag_tipo_impianto eq "C"} {
	set msg_dismesso "<b>CG dismesso</b>"
    }
} else {
    set msg_dismesso ""
};#rom13

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimgend"
set focus_field  "";#nic01
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set readonly_cod "readonly";#rom12
set onsubmit_cmd ""
switch $funzione {
    "I" {
	set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
    }
    "M" {
	set readonly_fld \{\}
        set disabled_fld \{\}
    }
    "S" {
        set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
    }
}
set fld_gen_prog $readonly_fld;#rom30
#rom30if {$coimtgen(ente) eq "PUD" ||
#rom30$coimtgen(ente) eq "PGO" ||
#rom30$coimtgen(ente) eq "PPN" ||
#rom30$coimtgen(ente) eq "PTS" ||
#rom30$coimtgen(ente) eq"CTRIESTE"} {}#rom04 aggiunte if, else e loro contenuto
if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom30 Aggiunta if ma non contenuto
    set fld_pr_fumi "readonly"
    #rom30set fld_nr_circ "readonly"
    set fld_nr_circ $readonly_fld;#rom30
    if {$cod_manutentore ne "" } {#rom30 aggiunta if e suo contenuto
        set fld_gen_prog "readonly"
    }
} else {
    set fld_pr_fumi $readonly_fld
    set fld_nr_circ $readonly_fld
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}


form create $form_name \
    -html    $onsubmit_cmd

#sim16 if {$coimtgen(regione) ne "MARCHE" && $coimtgen(ente) ne "PSA"} {#rom07 aggiunta if, else e contenuto dell'else
#sim16    element create $form_name gen_prog \
#sim16	-label   "numero" \
#sim16	-widget   text \
#sim16	-datatype text \
#sim16	-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
#sim16	-optional

#sim16    element create $form_name gen_prog_est -widget hidden -datatype text -optional
#sim16} else {
#mat02 In riferimento a gen_prog cambiato -widget da hidden a text perche altrimenti perdeva il valore con il submit. Aggiunto  -html "style=\"display:none\""
    element create $form_name gen_prog -widget text -datatype text -html "style=\"display:none\" \"\""  -optional 

#mat02 In riferimento a gen_prog_est cambiato -widget da inform a text perche altrimenti perdeva il valore con il submit . Aggiunto -mode display
    element create $form_name gen_prog_est \
	-label   "numero gen" \
	-widget   text \
	-datatype text \
        -html    "size 8 maxlength 8 $fld_gen_prog {} class form_element" \
        -optional \
        -mode display \
        
#sim16};#rom07
#rom07

element create $form_name descrizione \
    -label   "descrizione" \
    -widget   text \
    -datatype text \
    -html    "size 56 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_grup_term \
    -label   "tipo gruppo termico" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtipo_grup_termico cod_grup_term desc_grup_term order_grup_term];#san01

if {$flag_tipo_impianto eq "R"} {#rom01 aggiunta if else e loro contenuto
    #rom04 sostituito nell' -html $readonly_fld con $fld_pr_fumi
    element create $form_name num_prove_fumi \
	-label   "Num. prove fumi" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 8 $fld_pr_fumi {} class form_element" \
	-optional
} else {
    element create $form_name num_prove_fumi -widget hidden -datatype text -optional
}
set link_coimgend_pote "" ;#rom06

element create $form_name matricola \
    -label   "matricola" \
    -widget   text \
    -datatype text \
    -optional \
    -html    "size 20 maxlength 35 $readonly_fld {} class form_element"

if {$coimtgen(flag_gest_coimmode) eq "F"} {;#nic01
    element create $form_name modello \
	-label   "modello" \
	-widget   text \
	-datatype text \
	-optional \
	-html    "size 18 maxlength 40 $readonly_fld {} class form_element"

    element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01

    set html_per_cod_cost "";#nic01
} else {;#nic01
    element create $form_name modello -widget hidden -datatype text -optional;#nic01

    element create $form_name cod_mode \
	    -label   "modello" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options "";#nic01
    
    set html_per_cod_cost "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_cost';document.$form_name.submit.click()";#nic01
};#nic01

element create $form_name cod_cost \
    -label   "costruttore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element $html_per_cod_cost" \
    -optional \
    -options [iter_selbox_from_table coimcost cod_cost descr_cost] \

#rom02 modificato il valore {Chiuso C} con {Stagna C} solo per la Reg. Marche
if {($coimtgen(regione) eq "MARCHE")} {#rom02 if, else e loro contenuto
    element create $form_name tipo_foco \
	-label   "camera di Combustione" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {Aperta A} {Stagna C}}
} else {
    element create $form_name tipo_foco \
	-label   "Tipo Generatore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {Aperto A} {Chiuso C}}
};#rom02

element create $form_name mod_funz \
    -label   "funzionamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimfuge cod_fuge descr_fuge cod_fuge] 
#rom04
element create $form_name altro_funz \
    -label   "Altro" \
    -widget   textarea \
    -datatype text \
    -html    "cols 20 rows 1 maxlength 20 $readonly_fld {} class form_element" \
    -optional

#gac04 aggiunta if else e contenuto di else 
if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom35 Aggiunta if e il contenuto.
    element create $form_name cod_utgi \
        -label   "cod_utgi" \
        -widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
        -optional \
	-options [iter_selbox_from_table_wherec coimutgi cod_utgi descr_utgi cod_utgi "where cod_utgi != 'D' and cod_utgi != 'I'"]
} elseif {$coimtgen(regione) ne "MARCHE"} {#rom35 Trasformata if in elseif, il contenuto e' rimasto invariato.
    element create $form_name cod_utgi \
	-label   "cod_utgi" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options [iter_selbox_from_table_obblig coimutgi cod_utgi descr_utgi cod_utgi] 
} else {
    element create $form_name cod_utgi \
        -label   "cod_utgi" \
        -widget   select \
        -datatype text \
        -html    "$disabled_fld {} class form_element" \
        -optional \
        -options [iter_selbox_from_table_wherec coimutgi cod_utgi descr_utgi cod_utgi "where cod_utgi != '0'                                                                                                                          and cod_utgi != 'A'"]
}

element create $form_name tipo_bruciatore \
    -label   "tipo bruciatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Atmosferico A} {Pressurizzato P} {Premiscelato M}}

element create $form_name tiraggio \
    -label   "tipo tiraggio" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Forzato F} {Naturale N}}

element create $form_name matricola_bruc\
    -label   "matricola_bruc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 35 $readonly_fld {} class form_element" \
    -optional

if {$coimtgen(flag_gest_coimmode) eq "F"} {;#nic01
    element create $form_name modello_bruc \
	-label   "modello_bruc" \
	-widget   text \
	-datatype text \
	-html    "size 18 maxlength 40 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name cod_mode_bruc -widget hidden -datatype text -optional;#nic01
    
    set html_per_cod_cost_bruc "";#nic01
} else {;#nic01
    element create $form_name modello_bruc -widget hidden -datatype text -optional;#nic01

    element create $form_name cod_mode_bruc \
	    -label   "modello bruc." \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options "";#nic01

    set html_per_cod_cost_bruc "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_cost_bruc';document.$form_name.submit.click()";#nic01
};#nic01

element create $form_name cod_cost_bruc \
    -label   "costruttore_bruc" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element $html_per_cod_cost_bruc" \
    -optional \
    -options [iter_selbox_from_table coimcost cod_cost descr_cost] \

#rom02 tolta la tipologia {{Non noto} N} e modificato il tipo T da Tecnico a Locale ad uso esclusivo
if {($coimtgen(regione) eq "MARCHE")} { #rom02 if, else e loro contenuto
    element create $form_name locale \
	-label   "tipo locale" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {{Locale ad uso esclusivo} T} {Esterno E} {Interno I} }
} else {
    element create $form_name locale \
        -label   "tipo locale" \
        -widget   select \
        -datatype text \
        -html    "$disabled_fld {} class form_element" \
        -optional \
        -options {{{} {}} {Tecnico T} {Esterno E} {Interno I} {{Non noto} N}}
};#rom02
element create $form_name cod_emissione \
    -label   "cod_emissione combust." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_obblig coimtpem cod_emissione descr_emissione cod_emissione] 

#gab02 cambiate options, uso la proc con la condizione
#-options [iter_selbox_from_table coimcomb cod_combustibile descr_comb]

element create $form_name cod_combustibile \
    -label   "combustibile" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimcomb cod_combustibile descr_comb  "" "where 1 = 1 $where_cod_comb $where_tipo_comb"] \
 #but02 Aggiunto la classe ah-jquery-date al campo: data_installaz, data_rottamaz, data_costruz_bruc, data_installaz_bruc, data_costruz_gen
element create $form_name data_installaz \
    -label   "data installaz" \
    -widget   text \
    -datatype text \
    -optional \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date"

if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
    element create $form_name cognome_inst \
	-label   "Cognome installatore" \
	-widget   text \
	-datatype text \
	-html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name nome_inst \
	-label   "Nome installatore" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
	-optional

    element create $form_name cod_installatore  -widget hidden -datatype text -optional
    #rom13 aggiunto $funzione == "S"
    if {$funzione == "I"
    ||  $funzione == "M"
    ||  $funzione == "S"
    } {
	set cerca_inst [iter_search $form_name coimmanu-list [list dummy cod_installatore dummy cognome_inst dummy nome_inst] [list f_ruolo "I"]]
    } else {
	set cerca_inst ""
    }
} else {;#rom09
    element create $form_name cod_installatore  -widget hidden -datatype text -optional
}
    
element create $form_name data_rottamaz \
    -label   "data rottamaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name pot_focolare_lib \
    -label   "potenza focolare libretto" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_utile_lib \
    -label   "potenza utile libretto" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_focolare_nom \
    -label   "potenza focolare nomin" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_utile_nom \
    -label   "potenza utile nomin" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
    -optional

#sim04
element create $form_name pot_utile_nom_freddo \
    -label   "potenza utile nomin del freddo" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_attivo \
    -label   "flag attivo" \
    -widget   select \
    -datatype text \
    -html    "class form_element onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='flag_attivo';document.$form_name.submit.click();" \
    -optional \
    -options {{Si S} {No N} }

element create $form_name flag_attivo_db -widget hidden -datatype text -optional;#rom26

#rom12
if {$flag_tipo_impianto eq "F"} {
    set label_motivazione_disattivo "Motivazione GF inattivo"
} elseif {$flag_tipo_impianto eq "C"} {
    set label_motivazione_disattivo "Motivazione CG inattivo"
} elseif {$flag_tipo_impianto eq "T"} {
    set label_motivazione_disattivo "Motivazione SC inattivo"
} else {
    set label_motivazione_disattivo "Motivazione GT inattivo"
}
element create $form_name motivazione_disattivo \
    -label "GT inattivo perche" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {{Dichiarato tale mediante apposita comunicazione} A} {{Attivato solo in sostituzione di un altro} B} {{Inserito in immobile nuovo mai abitato} C} {{In edificio crollato/inagibile/sgomberato} D} {{Distaccato dalla rete per motivi di sicurezza} E}}


element create $form_name note \
    -label   "note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 110 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_costruz_gen \
    -label   "data costruzione generatore" \
    -widget   text \
    -datatype text \
    -optional \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date"

element create $form_name data_costruz_bruc \
    -label   "data costruzione bruciatore" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_installaz_bruc \
    -label   "data installaz bruciatore" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_rottamaz_bruc \
    -label   "data rottamazione bruciatore" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

#rom32 Modificata if per aggiungere Regione Friuli
if {$coimtgen(regione) in [list "MARCHE" "FRIULI-VENEZIA GIULIA"]} {

element create $form_name marc_effic_energ \
    -label   "marcatura efficenza energetica" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {{1 stella} {1*}} {{2 stelle} {2*}} {{3 stelle} {3*}} {{4 stelle} {4*}} {{5 stelle} {5*}}}

} else { 

element create $form_name marc_effic_energ \
    -label   "marcatura efficenza energetica" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld {} class form_element" \
    -optional
}

element create $form_name campo_funzion_max \
    -label   "Campo di funzionamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name campo_funzion_min \
    -label   "Campo di funzionamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name dpr_660_96 \
    -label   "Classificazione DPR 660/96" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Standard S} {{A bassa temperatura} B} {{A gas a condensazione} G}}

element create $form_name cod_tpco \
    -label   "cod_tpco" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtpco cod_tpco descr_tpco];#dpr74

element create $form_name cod_flre \
    -label   "cod_flre" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimflre cod_flre sigla];#dpr74

element create $form_name carica_refrigerante \
    -label   "carica_refrigerante" \
    -widget   text \
    -datatype text \
    -html    "size 13 maxlength 13 $readonly_fld {} class form_element" \
    -optional;#dpr74

element create $form_name sigillatura_carica \
    -label   "sigillatura_carica" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {No N} {S&igrave; S}};#dpr74

#sim08 aggiunti per e cop
if {$flag_tipo_impianto eq "F"} {#sim05: aggiunta if e suo contenuto
    #rom04 sostituito nell' -html $readonly_fld con $fld_nr_circ
    element create $form_name num_circuiti \
	-label   "Numero circuiti" \
	-widget   text \
	-datatype text \
	-html    "size 4 $fld_nr_circ {} class form_element" \
	-optional

    element create $form_name per \
        -label   "EER (o GUE)" \
        -widget   text \
        -datatype text \
        -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
        -optional

    element create $form_name cop \
        -label   "COP" \
        -widget   text \
        -datatype text \
        -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
        -optional

} else {
    element create $form_name num_circuiti -widget hidden -datatype text -optional
    element create $form_name per -widget hidden -datatype text -optional
    element create $form_name cop -widget hidden -datatype text -optional
}

#gac02 gestiti nuovi campi cogeneratore
element create $form_name tipologia_cogenerazione \
    -label   "Tipologia Cogeneratore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{Altro} A} {{Motore Endotermico} M} {{Caldaia Cogenerativa} C} {{Turbogas} T}}

element create $form_name temp_h2o_uscita_min \
    -label   "Temperatura acqua in uscita minima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_h2o_uscita_max \
    -label   "Temperatura acqua in uscita massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_h2o_ingresso_min \
    -label   "Temperatura acqua in ingresso mimima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_h2o_ingresso_max \
    -label   "Temperatura acqua in ingresso massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_h2o_motore_min \
    -label   "Temperatura acqua motore minima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_h2o_motore_max \
    -label   "Temperatura acqua motore massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_fumi_valle_min \
    -label   "Temperatura fumi valle minima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_fumi_valle_max \
    -label   "Temperatura fumi valle massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_fumi_monte_min \
    -label   "Temperatura fumi monte minima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_fumi_monte_max \
    -label   "Temperatura fumi monte massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name emissioni_monossido_co_min \
    -label   "Emissioni monossido di carbonio minima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name emissioni_monossido_co_max \
    -label   "Emissioni monossido di carbonio massima" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

#rom012
element create $form_name flag_clima_invernale \
    -label   "flag climatizzazione invernale" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}
#rom012
element create $form_name flag_clim_est \
    -label   "flag climatizzazione estiva" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}
#rom012
element create $form_name flag_prod_acqua_calda \
    -label   "flag produzione acqua sanitaria" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}
#rom012
element create $form_name flag_altro \
    -label   "flag altro" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}
if {$flag_tipo_impianto eq "R"} {#rom14 aggiunta if e suo contenuto
    set options_rif_uni_10389 "{{norma UNI-10389-1} {U}} {{Altro} {A}}"
}
if {$flag_tipo_impianto eq "F"} {#rom14 aggiunta if e suo contenuto
    set options_rif_uni_10389 "{{}} {{norma UNI-10389-3} {U}} {{Altro} {A}}"
}
#rom39 Tolta condizione || $flag_tipo_impianto eq "T"
if {$flag_tipo_impianto eq "C"} {#rom014 aggiunta if e suo contenuto
    set options_rif_uni_10389 "{{}} {{In attesa di definizione} {U}} {{Altro} {A}}"
}

if {$flag_tipo_impianto eq "T"} {#rom39 Aggiunta if e il suo contenuto
    set options_rif_uni_10389 "{{}} {{norma UNI-10389-4} {U}} {{Altro} {A}}"
}

element create $form_name rif_uni_10389 \
    -label   "Riferimento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_rif_uni_10389

element create $form_name altro_rif \
    -label   "Altro" \
    -widget   textarea \
    -datatype text \
    -html    "cols 20 rows 1 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name funzione_grup_ter_note_altro \
    -label   "Note Funzione Gruppo Termico" \
    -widget   textarea \
    -datatype text \
    -html    "cols 20 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_caldaia_comb_liquid \
    -label   "Flag caldaia a condensazione che utilizza combustibile liquido" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {{Si} S} {{No} N}}

if {$flag_tipo_impianto eq "R" } {#rom02 if e suo contenuto
    element create $form_name rend_ter_max \
	-label   "rendimento termico massimo" \
	-widget   text \
	-datatype text \
	-html    "size 9 maxlength 9 $readonly_fld {} class form_element" \
	-optional
    
} else {;#rom02
    element create $form_name rend_ter_max -widget hidden -datatype text -optional
}

if {$flag_tipo_impianto eq "F"} {#rom13 aggiunta if, else e loro contenuto
    element create $form_name sorgente_lato_esterno\
	-label   "Sorgente lato esterno" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {{Aria} {AR}} {{Acqua} {AC}}}

    element create $form_name fluido_lato_utenze \
	-label   "Fluido lato utenze" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {{Aria} {AR}} {{Acqua} {AC}}}
} else {
    element create $form_name sorgente_lato_esterno -widget hidden -datatype text -optional
    element create $form_name fluido_lato_utenze    -widget hidden -datatype text -optional
};#rom13

#rom16: Aggiunto campo tel_alimentazione
element create $form_name tel_alimentazione \
    -label "Alimentazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Acqua calda" A} {"Acqua surriscaldata" B} {Vapore C} {Altro Z}} \

element create $form_name conferma_rend_ter     -widget hidden -datatype text -optional;#rom04

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name url_list_aimp    -widget hidden -datatype text -optional
element create $form_name url_aimp         -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_gen_prog    -widget hidden -datatype text -optional
element create $form_name gen_prog_old     -widget hidden -datatype text -optional
element create $form_name __refreshing_p   -widget hidden -datatype text -optional;#nic01
#mat00 13/10/2025
#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
#element set_properties $form_name __refreshing_p -values 0;#mat01
element create $form_name changed_field    -widget hidden -datatype text -optional;#nic01
element create $form_name evidenzia_rend_ter -widget hidden -datatype text -optional
element create $form_name matricola_old     -widget hidden -datatype text -optional;#mat03
#gab01
set cod_cost_asterisco "<font color=red>*</font>"
set data_installaz_asterisco "<font color=red>*</font>"
set data_costruz_gen_asterisco ""
set data_costruz_gen_messaggio "<font color=blue><small>Se data non nota inserire solo l'anno</small></font>";#rom14
if {($coimtgen(regione) eq "MARCHE") && $flag_tipo_impianto ne "R"} {#rom14 aggiunta if e contenuto
    set data_costruz_gen_messaggio ""
}
set dpr_660_96_asterisco "*"          
set tiraggio_asterisco "*"
set tipo_foco_asterisco "*"
set mod_funz_asterisco "*"
set cod_utgi_asterisco "*"
set locale_asterisco "<font color=red>*</font>"
set cod_combustibile_asterisco "<font color=red>*</font>"
if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom33 Aggiunta if ma non il suo contenuto
    set marc_effic_energ_asterisco "*";#rom08
} else {#rom33 Aggiunta else e il suo contenuto
    set marc_effic_energ_asterisco ""
}
set pot_utile_nom_asterisco    "*";#rom08
set cod_emissione_asterisco    "*";#rom08
set cod_tpco_asterisco "<font color=red>*</font>";#rom13
set sorgente_lato_esterno_asterisco "<font color=red>*</font>";#rom13
set cod_flre_asterisco "<font color=red>*</font>";#rom13
set fluido_lato_utenze_asterisco "<font color=red>*</font>";#rom13
if {[form is_request $form_name]} {
    
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name cod_impianto      -value $cod_impianto
    element set_properties $form_name gen_prog          -value $gen_prog
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name last_gen_prog     -value $last_gen_prog
    element set_properties $form_name __refreshing_p    -value 0;#nic01
    element set_properties $form_name changed_field     -value "";#nic01
    element set_properties $form_name conferma_rend_ter -value "s";#rom04
    if {$funzione == "I" || $funzione == "S"} {#rom07 aggiunta condizione $funzione =="S"
	
	#set flag_attivo          "S";#[element::get_value $form_name flag_attivo]

	element set_properties $form_name flag_attivo    -value "S"
	set flag_attivo "S"
	element set_properties $form_name flag_attivo_db $flag_attivo

	# propongo il numero del nuovo generatore con il max + 1
        db_1row sel_gend_next_prog_x "select coalesce(max(gen_prog),0) + 1 as next_prog 
                                        from coimgend
                                       where cod_impianto = :cod_impianto"
        element set_properties $form_name gen_prog -value $next_prog

	if {$flag_tipo_impianto eq "F"} {#sim05: aggiunta if e suo contenuto
	    element set_properties $form_name num_circuiti        -value "1"
	}
	
	if {$flag_tipo_impianto eq "R"} {#rom01: aggiunta if e suo contenuto
            element set_properties $form_name num_prove_fumi      -value "1"
	}
	
	if {$coimtgen(regione) eq "MARCHE" && $funzione ne "I"} {#rom09 if e contenuto: propongo l'installatore
	    db_1row q "select coalesce(a.cod_installatore, '') as cod_installatore
                            , coalesce(i.cognome,'')           as cognome_inst 
                            , coalesce(i.nome,'')              as nome_inst
                         from coimgend a --rom09bis
                   --rom09bis coimaimp a
     left outer join coimmanu i  on i.cod_manutentore = a.cod_installatore
              where a.cod_impianto = :cod_impianto
                and a.gen_prog     = :gen_prog --rom09bis"
	    element set_properties $form_name nome_inst           -value $nome_inst
            element set_properties $form_name cognome_inst        -value $cognome_inst
            element set_properties $form_name cod_installatore    -value $cod_installatore
	}

	# Sandro, 30/06/2014. Imposto alcuni default per il Comune di Rimini
	if {$coimtgen(ente) eq "CRIMINI"} {
	    element set_properties $form_name cod_combustibile    -value "5"
	    element set_properties $form_name cod_emissione       -value "I"
	    element set_properties $form_name locale              -value "I"
	    element set_properties $form_name cod_utgi            -value "E"
	    element set_properties $form_name mod_funz            -value "1"
	}
 	
	if {$funzione eq "S"} {
	    #Se sono in sostituzione il nuovo impianto deve essere quello dell'impianto che sto sostituendo
	    set old_gen_prog_est [db_string q "select coalesce(gen_prog_est, '1')
                                                 from coimgend 
                                                where cod_impianto = :cod_impianto
                                                  and gen_prog     = :gen_prog_old"]
	    element set_properties $form_name gen_prog_est        -value $old_gen_prog_est
	}
	if {$funzione eq "I"} {
	    
	    set new_gen_prog_est [db_string q "select coalesce(max(gen_prog_est + 1), '1') 
                                         from coimgend 
                                        where cod_impianto = :cod_impianto
                                          and flag_attivo = 'S'" ]
	    element set_properties $form_name gen_prog_est        -value $new_gen_prog_est
	}
	element set_properties $form_name gen_prog_old        -value $gen_prog_old

    } else {

	# leggo riga
        if {[db_0or1row sel_gend_x "select g.cod_impianto
                  , g.gen_prog
                  , g.descrizione
                  , g.matricola
                  , g.modello
                  , g.cod_cost
                  , g.matricola_bruc
                  , g.modello_bruc
                  , g.cod_cost_bruc
                  , g.tipo_foco
                  , g.mod_funz
                  , g.cod_utgi
                  , g.tipo_bruciatore
                  , g.tiraggio
                  , g.locale
                  , g.cod_emissione
                  , g.cod_combustibile
                  , iter_edit_data(g.data_installaz)     as data_installaz
                  , iter_edit_data(g.data_rottamaz)      as data_rottamaz
                  , iter_edit_num(g.pot_focolare_lib, 2) as pot_focolare_lib
                  , iter_edit_num(g.pot_utile_lib, 2)    as pot_utile_lib
                  , iter_edit_num(g.pot_focolare_nom, 2) as pot_focolare_nom
                  , iter_edit_num(g.pot_utile_nom, 2)    as pot_utile_nom
                  , iter_edit_num(g.pot_utile_nom_freddo, 2) as pot_utile_nom_freddo --sim04
                  , g.flag_attivo
                  , g.flag_attivo as flag_attivo_db --rom26
                  , g.motivazione_disattivo --rom12
                  , g.note
		  , g.gen_prog_est
                  , iter_edit_data(g.data_costruz_gen)   as data_costruz_gen
                  , iter_edit_data(g.data_costruz_bruc)  as data_costruz_bruc
                  , iter_edit_data(g.data_installaz_bruc) as data_installaz_bruc
                  , iter_edit_data(g.data_rottamaz_bruc) as data_rottamaz_bruc
                  , g.marc_effic_energ
                  , iter_edit_num(g.campo_funzion_max,2) as campo_funzion_max
                  , iter_edit_num(g.campo_funzion_min,2) as campo_funzion_min
                  , g.dpr_660_96
                  , g.cod_tpco            --dpr74
                  , g.cod_flre            --dpr74
                  , iter_edit_num(g.carica_refrigerante,2) as carica_refrigerante --dpr74
                  , g.sigillatura_carica  --dpr74
                  , g.cod_mode            -- nic01
                  , g.cod_mode_bruc       -- nic01
                  , g.cod_grup_term       -- san01
                  , g.num_circuiti        -- sim05
                  , g.num_prove_fumi      -- rom01
                  , iter_edit_num(g.per,2) as per  -- sim08
                  , iter_edit_num(g.cop,2) as cop  -- sim08
                  , g.tipologia_cogenerazione    --gac02
                  , iter_edit_num(g.temp_h2o_uscita_min,2)        as temp_h2o_uscita_min        --gac02
                  , iter_edit_num(g.temp_h2o_uscita_max,2)        as temp_h2o_uscita_max        --gac02
                  , iter_edit_num(g.temp_h2o_ingresso_min,2)      as temp_h2o_ingresso_min      --gac02
                  , iter_edit_num(g.temp_h2o_ingresso_max,2)      as temp_h2o_ingresso_max      --gac02
                  , iter_edit_num(g.temp_h2o_motore_min,2)        as temp_h2o_motore_min        --gac02
                  , iter_edit_num(g.temp_h2o_motore_max,2)        as temp_h2o_motore_max        --gac02
                  , iter_edit_num(g.temp_fumi_valle_min,2)        as temp_fumi_valle_min        --gac02
                  , iter_edit_num(g.temp_fumi_valle_max,2)        as temp_fumi_valle_max        --gac02
                  , iter_edit_num(g.temp_fumi_monte_min,2)        as temp_fumi_monte_min        --gac02
                  , iter_edit_num(g.temp_fumi_monte_max,2)        as temp_fumi_monte_max        --gac02
                  , iter_edit_num(g.emissioni_monossido_co_max,2) as emissioni_monossido_co_max --gac02
                  , iter_edit_num(g.emissioni_monossido_co_min,2) as emissioni_monossido_co_min --gac02
          --rom12 , g.funzione_grup_ter            --rom02
                  , g.flag_clima_invernale                --rom12
                  , g.flag_clim_est                --rom12
                  , g.flag_prod_acqua_calda            --rom12
                  , g.flag_altro                   --rom12
                  , g.funzione_grup_ter_note_altro --rom02
                  , g.flag_caldaia_comb_liquid     --rom02
                  , g.rif_uni_10389                --gac03
                  , g.altro_rif                    --gac03
                  , iter_edit_num(g.rend_ter_max,2) as rend_ter_max --rom02
                  , g.rend_ter_max as check_rend_ter_max
                  , g.altro_funz    --rom04
                  , c.tipo as tipo_comb
     --rom09bis   , a.cod_installatore        --rom09
                  , g.cod_installatore        --rom09bis
                  , i.cognome as cognome_inst --rom09 
                  , i.nome    as nome_inst    --rom09
                  , g.sorgente_lato_esterno   --rom13
                  , g.fluido_lato_utenze      --rom13
                  , g.tel_alimentazione            --rom16
               from coimgend g
    left outer join coimmanu i --rom09bis
                 on i.cod_manutentore = g.cod_installatore --rom09bis
    left outer join  coimcomb c
                 on c.cod_combustibile = g.cod_combustibile
              where g.cod_impianto = :cod_impianto
                and g.gen_prog     = :gen_prog"] == 0} {
            iter_return_complaint "Record non trovato"
	}
	set matricola_old $matricola;#mat03
	set evidenzia_rend_ter "f"
	if {$coimtgen(regione) eq "MARCHE"} {#rom04 if e suo contenuto
	    if {$flag_tipo_impianto ne "F"} {#rom05 aggiunta if
		if {(($dpr_660_96 eq "B" || $dpr_660_96 eq "G") && ($check_rend_ter_max <= "85" || $check_rend_ter_max >= "120"))
		    ||  (($tipo_comb eq "L" || $tipo_comb eq "G") && $dpr_660_96 eq "S" && ($check_rend_ter_max <="78"  || $check_rend_ter_max >="100"))
		    || ($tipo_comb eq "S" && $dpr_660_96 eq "S" && ($check_rend_ter_max <="50" || $check_rend_ter_max >="100"))
		} {
		    set evidenzia_rend_ter "t" 
		} 
	    };#rom05
	};#rom04 
	if {[db_0or1row q "select 1 
                             from coimgend 
                            where cod_impianto   = :cod_impianto
                              and gen_prog       = :gen_prog
                              and :num_prove_fumi > 1"]} {#rom06 if, else e loro contenuto 
	    set  link_coimgend_pote "<a href=\"../src/coimgend-pote?nome_funz=$nome_funz&nome_funz_caller=$nome_funz_caller&cod_impianto=$cod_impianto&gen_prog=$gen_prog&caller=$caller\">Inserisci potenze singolo modulo</a>"
	} else {
	    set link_coimgend_pote ""
	};#rom06

        element set_properties $form_name gen_prog_old        -value $gen_prog
        element set_properties $form_name gen_prog            -value $gen_prog
	element set_properties $form_name gen_prog_est        -value $gen_prog_est;#rom07
        element set_properties $form_name descrizione         -value $descrizione
        element set_properties $form_name matricola           -value $matricola
        element set_properties $form_name modello             -value $modello
        element set_properties $form_name cod_cost            -value $cod_cost
        element set_properties $form_name tipo_foco           -value $tipo_foco
        element set_properties $form_name mod_funz            -value $mod_funz
        element set_properties $form_name cod_utgi            -value $cod_utgi
        element set_properties $form_name tipo_bruciatore     -value $tipo_bruciatore
        element set_properties $form_name tiraggio            -value $tiraggio
        element set_properties $form_name matricola_bruc      -value $matricola_bruc
        element set_properties $form_name modello_bruc        -value $modello_bruc
        element set_properties $form_name cod_cost_bruc       -value $cod_cost_bruc
        element set_properties $form_name locale              -value $locale
        element set_properties $form_name cod_emissione       -value $cod_emissione
        element set_properties $form_name cod_combustibile    -value $cod_combustibile
        element set_properties $form_name data_installaz      -value $data_installaz
        element set_properties $form_name data_rottamaz       -value $data_rottamaz
        element set_properties $form_name pot_focolare_lib    -value $pot_focolare_lib
        element set_properties $form_name pot_utile_lib       -value $pot_utile_lib
        element set_properties $form_name pot_focolare_nom    -value $pot_focolare_nom
        element set_properties $form_name pot_utile_nom       -value $pot_utile_nom
	element set_properties $form_name pot_utile_nom_freddo -value $pot_utile_nom_freddo;#sim04
        element set_properties $form_name flag_attivo         -value $flag_attivo
	element set_properties $form_name flag_attivo_db      -value $flag_attivo_db;#rom26
	element set_properties $form_name motivazione_disattivo -value $motivazione_disattivo;#rom12
        element set_properties $form_name note                -value $note
	element set_properties $form_name data_costruz_gen    -value $data_costruz_gen
        element set_properties $form_name data_costruz_bruc   -value $data_costruz_bruc
        element set_properties $form_name data_installaz_bruc -value $data_installaz_bruc
        element set_properties $form_name data_rottamaz_bruc  -value $data_rottamaz_bruc
        element set_properties $form_name marc_effic_energ    -value $marc_effic_energ
        element set_properties $form_name campo_funzion_max   -value $campo_funzion_max
        element set_properties $form_name campo_funzion_min   -value $campo_funzion_min
        element set_properties $form_name dpr_660_96          -value $dpr_660_96
	element set_properties $form_name cod_tpco            -value $cod_tpco;#dpr74
	element set_properties $form_name cod_flre            -value $cod_flre;#dpr74
	element set_properties $form_name carica_refrigerante -value $carica_refrigerante;#dpr74
	element set_properties $form_name sigillatura_carica  -value $sigillatura_carica;#dpr74
        element set_properties $form_name cod_grup_term       -value $cod_grup_term;#san01
	element set_properties $form_name num_circuiti        -value $num_circuiti;#sim05
	element set_properties $form_name num_prove_fumi      -value $num_prove_fumi;#rom01
	element set_properties $form_name per                 -value $per;#sim08
	element set_properties $form_name cop                 -value $cop;#sim08
	element set_properties $form_name tipologia_cogenerazione     -value $tipologia_cogenerazione    ;#gac02
	element set_properties $form_name temp_h2o_uscita_min         -value $temp_h2o_uscita_min        ;#gac02
	element set_properties $form_name temp_h2o_uscita_max         -value $temp_h2o_uscita_max        ;#gac02
	element set_properties $form_name temp_h2o_ingresso_min       -value $temp_h2o_ingresso_min      ;#gac02
	element set_properties $form_name temp_h2o_ingresso_max       -value $temp_h2o_ingresso_max      ;#gac02
	element set_properties $form_name temp_h2o_motore_min         -value $temp_h2o_motore_min        ;#gac02
	element set_properties $form_name temp_h2o_motore_max         -value $temp_h2o_motore_max        ;#gac02
	element set_properties $form_name temp_fumi_valle_min         -value $temp_fumi_valle_min        ;#gac02
	element set_properties $form_name temp_fumi_valle_max         -value $temp_fumi_valle_max        ;#gac02
	element set_properties $form_name temp_fumi_monte_min         -value $temp_fumi_monte_min        ;#gac02
	element set_properties $form_name temp_fumi_monte_max         -value $temp_fumi_monte_max        ;#gac02
	element set_properties $form_name emissioni_monossido_co_max  -value $emissioni_monossido_co_max ;#gac02
	element set_properties $form_name emissioni_monossido_co_min  -value $emissioni_monossido_co_min ;#gac02
#rom12	element set_properties $form_name funzione_grup_ter            -value $funzione_grup_ter           ;#rom02
	element set_properties $form_name flag_clima_invernale                -value $flag_clima_invernale               ;#rom12
	element set_properties $form_name flag_clim_est                -value $flag_clim_est               ;#rom12
	element set_properties $form_name flag_prod_acqua_calda            -value $flag_prod_acqua_calda           ;#rom12
	element set_properties $form_name flag_altro                   -value $flag_altro                  ;#rom12
	element set_properties $form_name funzione_grup_ter_note_altro -value $funzione_grup_ter_note_altro;#rom02
	element set_properties $form_name flag_caldaia_comb_liquid     -value $flag_caldaia_comb_liquid    ;#rom02
	element set_properties $form_name rend_ter_max                 -value $rend_ter_max                ;#rom02
	element set_properties $form_name rif_uni_10389                -value $rif_uni_10389             ;#gac03
	element set_properties $form_name altro_rif                    -value $altro_rif                 ;#gac03
        element set_properties $form_name altro_funz                   -value $altro_funz                ;#rom04
	element set_properties $form_name evidenzia_rend_ter           -value $evidenzia_rend_ter
	if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
	    element set_properties $form_name nome_inst           -value $nome_inst
	    element set_properties $form_name cognome_inst        -value $cognome_inst
	    element set_properties $form_name cod_installatore    -value $cod_installatore
	};#rom09
	element set_properties $form_name sorgente_lato_esterno -value $sorgente_lato_esterno;#rom13
	element set_properties $form_name fluido_lato_utenze    -value $fluido_lato_utenze;#rom13
	element set_properties $form_name tel_alimentazione     -value $tel_alimentazione;#rom16
	element set_properties $form_name matricola_old     -value $matricola_old;#mat03
	# Imposto ora le options di cod_mode perche solo adesso ho a disposiz. la var. cod_cost
	if {$cod_mode eq ""} {
	    set or_cod_mode ""
	} else {
	    # Devo esporre comunque il vecchio modello disattivato
	    set or_cod_mode "or cod_mode = $cod_mode"
	}
	element set_properties $form_name cod_mode            -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $cod_cost]' and (flag_attivo <> 'N' $or_cod_mode)" cod_mode descr_mode];#nic01
        element set_properties $form_name cod_mode            -value $cod_mode;#nic01

	# Imposto ora le options di cod_mode_bruc perche solo adesso ho a disposiz. la var. cod_cost_bruc
	if {$cod_mode_bruc eq ""} {
	    set or_cod_mode ""
	} else {
	    # Devo esporre comunque il vecchio modello disattivato
	    set or_cod_mode "or cod_mode = $cod_mode_bruc"
	}
	element set_properties $form_name cod_mode_bruc       -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $cod_cost_bruc]' and (flag_attivo <> 'N' $or_cod_mode)" cod_mode descr_mode];#nic01
        element set_properties $form_name cod_mode_bruc       -value $cod_mode_bruc;#nic01

    }
    
    #gab01
    ############inizio controlli campi obbligatori
    if {$funzione ne "V"} {
	set flag_attivo          [element::get_value $form_name flag_attivo]
	#set flag_tipo_impianto   [element::get_value $form_name flag_tipo_impianto]   	

	if {$flag_attivo eq "S" } {
	    set cod_cost_asterisco "*"
	    set data_installaz_asterisco "*"
	    set data_costruz_gen_asterisco "*"
	    if {$coimtgen(regione) eq "MARCHE" && $flag_tipo_impianto ne "R"} {#rom14 if e contenuto
		set data_costruz_gen_asterisco ""
	    }
	    set dpr_660_96_asterisco "*"
	    set mod_funz_asterisco "*"
            set cod_utgi_asterisco "*"
            set locale_asterisco "*"
            set cod_combustibile_asterisco "*"
	    if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom33 Aggiunta if ma non il suo contenuto
		set marc_effic_energ_asterisco "*";#rom08
	    } else {#rom33 Aggiunta else e il suo contenuto
		set marc_effic_energ_asterisco ""
	    }
	    set pot_utile_nom_asterisco    "*";#rom08
	    set cod_emissione_asterisco    "*";#rom08

	    if {$flag_tipo_impianto eq "R"} {
		set tiraggio_asterisco "*"
		set tipo_foco_asterisco "*"
	    }
	    if {$flag_tipo_impianto eq "F"} {#rom13 aggiunta if e suo contenuto
		#rom34 Aggiunte condizioni su Campania e Palermo.
		if {$coimtgen(regione) in [list "MARCHE" "BASILICATA" "CAMPANIA"] || $coimtgen(ente) eq "PPA"} {#rom22 Aggiunta if ma non il suo contenuto
		    set cod_tpco_asterisco "<font color=red>*</font>"
		    set sorgente_lato_esterno_asterisco "<font color=red>*</font>"
		    set cod_flre_asterisco "<font color=red>*</font>"
		    set fluido_lato_utenze_asterisco "<font color=red>*</font>"
		} else {#rom22 Aggiunta else e il suo contenuto
		    set cod_tpco_asterisco ""
		    set sorgente_lato_esterno_asterisco ""
		    set cod_flre_asterisco ""
		    set fluido_lato_utenze_asterisco ""
		}
	    }
	} else {#rom26 Aggiunto else e il suo contenuto
	    if {$coimtgen(regione) eq "MARCHE" &&
		$funzione eq "M" &&
		$flag_attivo_db eq "S"} {
		element::set_error $form_name flag_attivo "Attenzione se si disattiva il generatore (ed &egrave; unico) verr&agrave; disattivato anche l'impianto, che potr&agrave; essere riattivato solo dal soggetto esecutore. Inoltre si precisa che nel caso il soggetto esecutore disattivi/chiuda/rottami l'impianto la procedura metter&agrave; in automatico il generatore in stato Non Attivo.";#rom26
	    }
	}
    }
    
    #####################fine controlli campi obbligatori	
    
    
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    #sim19 setto i default delle variabili che usero dopo nei controlli
    set is_null_per_p 0;#sim19
    set is_null_cop_p 0;#sim19
    set is_null_pot_focolare_nom_p 0;#sim19
    set is_null_pot_utile_nom_freddo_p 0;#sim19
    set is_null_pot_focolare_lib_p 0;#sim19
    set is_null_pot_utile_lib_p 0;#sim19   
    set is_null_pot_utile_nom_p 0;#sim19 flag valido solo per gli enti diversi dalle marche
    
    set __refreshing_p       [element::get_value $form_name __refreshing_p];#nic01
    set changed_field        [element::get_value $form_name changed_field];#nic01
    set cod_impianto         [element::get_value $form_name cod_impianto]
    set gen_prog             [element::get_value $form_name gen_prog]
    set gen_prog_est         [element::get_value $form_name gen_prog_est];#rom07
    set gen_prog_old         [element::get_value $form_name gen_prog_old]
    set descrizione          [element::get_value $form_name descrizione]
    set matricola            [element::get_value $form_name matricola]
    set modello              [element::get_value $form_name modello]
    set cod_cost             [element::get_value $form_name cod_cost]
    set tipo_foco            [element::get_value $form_name tipo_foco]
    set mod_funz             [element::get_value $form_name mod_funz]
    set cod_utgi             [element::get_value $form_name cod_utgi]
    set tipo_bruciatore      [element::get_value $form_name tipo_bruciatore]
    set tiraggio             [element::get_value $form_name tiraggio]
    set matricola_bruc       [element::get_value $form_name matricola_bruc]
    set modello_bruc         [element::get_value $form_name modello_bruc]
    set cod_cost_bruc        [element::get_value $form_name cod_cost_bruc]
    set locale               [element::get_value $form_name locale]
    set cod_emissione        [element::get_value $form_name cod_emissione]
    set cod_combustibile     [element::get_value $form_name cod_combustibile]
    set data_installaz       [element::get_value $form_name data_installaz]
    set data_rottamaz        [element::get_value $form_name data_rottamaz]
    set pot_focolare_lib     [element::get_value $form_name pot_focolare_lib]
    set pot_utile_lib        [element::get_value $form_name pot_utile_lib]
    set pot_focolare_nom     [element::get_value $form_name pot_focolare_nom]
    set pot_utile_nom        [element::get_value $form_name pot_utile_nom]
    set pot_utile_nom_freddo [element::get_value $form_name pot_utile_nom_freddo];#sim04
    set flag_attivo          [element::get_value $form_name flag_attivo]
    set flag_attivo_db       [element::get_value $form_name flag_attivo_db];#rom26
    set motivazione_disattivo [element::get_value $form_name motivazione_disattivo];#rom12
    set note                 [element::get_value $form_name note]
    set data_costruz_gen     [element::get_value $form_name data_costruz_gen]
    set data_costruz_bruc    [element::get_value $form_name data_costruz_bruc]
    set data_installaz_bruc  [element::get_value $form_name data_installaz_bruc]
    set data_rottamaz_bruc   [element::get_value $form_name data_rottamaz_bruc]
    set marc_effic_energ     [element::get_value $form_name marc_effic_energ]
    set campo_funzion_max    [element::get_value $form_name campo_funzion_max]
    set campo_funzion_min    [element::get_value $form_name campo_funzion_min]
    set dpr_660_96           [element::get_value $form_name dpr_660_96]
    set cod_tpco             [element::get_value $form_name cod_tpco];#dpr74
    set cod_flre             [element::get_value $form_name cod_flre];#dpr74
    set carica_refrigerante  [element::get_value $form_name carica_refrigerante];#dpr74
    set sigillatura_carica   [element::get_value $form_name sigillatura_carica];#dpr74
    set cod_grup_term        [element::get_value $form_name cod_grup_term];#san01
    set num_circuiti         [element::get_value $form_name num_circuiti];#sim05
    set num_prove_fumi       [element::get_value $form_name num_prove_fumi];#rom01
    set per                  [element::get_value $form_name per];#sim08
    set cop                  [element::get_value $form_name cop];#sim08
    set tipologia_cogenerazione    [element::get_value $form_name tipologia_cogenerazione]    ;#gac02
    set temp_h2o_uscita_min        [element::get_value $form_name temp_h2o_uscita_min]        ;#gac02
    set temp_h2o_uscita_max        [element::get_value $form_name temp_h2o_uscita_max]        ;#gac02
    set temp_h2o_ingresso_min      [element::get_value $form_name temp_h2o_ingresso_min]      ;#gac02
    set temp_h2o_ingresso_max      [element::get_value $form_name temp_h2o_ingresso_max]      ;#gac02
    set temp_h2o_motore_min        [element::get_value $form_name temp_h2o_motore_min]        ;#gac02
    set temp_h2o_motore_max        [element::get_value $form_name temp_h2o_motore_max]        ;#gac02
    set temp_fumi_valle_min        [element::get_value $form_name temp_fumi_valle_min]        ;#gac02
    set temp_fumi_valle_max        [element::get_value $form_name temp_fumi_valle_max]        ;#gac02
    set temp_fumi_monte_min        [element::get_value $form_name temp_fumi_monte_min]        ;#gac02
    set temp_fumi_monte_max        [element::get_value $form_name temp_fumi_monte_max]        ;#gac02
    set emissioni_monossido_co_max [element::get_value $form_name emissioni_monossido_co_max] ;#gac02
    set emissioni_monossido_co_min [element::get_value $form_name emissioni_monossido_co_min] ;#gac02
#rom12set funzione_grup_ter          [element::get_value $form_name funzione_grup_ter]           ;#rom02
    set flag_clima_invernale                [element::get_value $form_name flag_clima_invernale    ]           ;#rom12
    set flag_clim_est                [element::get_value $form_name flag_clim_est    ]           ;#rom12
    set flag_prod_acqua_calda            [element::get_value $form_name flag_prod_acqua_calda]           ;#rom12
    set flag_altro                   [element::get_value $form_name flag_altro       ]           ;#rom12
    set funzione_grup_ter_note_altro [element::get_value $form_name funzione_grup_ter_note_altro];#rom02
    set flag_caldaia_comb_liquid     [element::get_value $form_name flag_caldaia_comb_liquid]    ;#rom02
    set rend_ter_max                 [element::get_value $form_name rend_ter_max]                ;#rom02
    set rif_uni_10389                [element::get_value $form_name rif_uni_10389]               ;#gac03
    set altro_rif                    [element::get_value $form_name altro_rif]                   ;#gac03
    set altro_funz                   [element::get_value $form_name altro_funz]                  ;#rom04
    set conferma_rend_ter            [element::get_value $form_name conferma_rend_ter]           ;#rom04
    set matricola_old                [element::get_value $form_name matricola_old];#mat03
    if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
	set cognome_inst        [element::get_value $form_name cognome_inst ]
	set nome_inst           [element::get_value $form_name nome_inst]
    };#rom09
    set cod_installatore    [element::get_value $form_name cod_installatore];#rom09

    set sorgente_lato_esterno [element::get_value $form_name sorgente_lato_esterno];#rom13
    set fluido_lato_utenze    [element::get_value $form_name fluido_lato_utenze];#rom13
    set tel_alimentazione     [string trim [element::get_value $form_name tel_alimentazione]];#rom16
    
    set cod_mode             [element::get_value $form_name cod_mode];#nic01
    if {$cod_mode eq ""} {
	set or_cod_mode ""
    } else {
	# Devo esporre comunque il vecchio modello disattivato
	set or_cod_mode "or cod_mode = $cod_mode"
    }
    #Imposto ora le options di cod_mode perche solo adesso ho a disposizione la var. cod_cost
    element set_properties $form_name cod_mode -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $cod_cost]' and (flag_attivo <> 'N' $or_cod_mode)" cod_mode descr_mode];#nic01

    #Imposto ora le options di cod_mode_bruc perche solo adesso ho a disposizione la var. cod_cost_bruc
    set cod_mode_bruc        [element::get_value $form_name cod_mode_bruc];#nic01
    if {$cod_mode_bruc eq ""} {
	set or_cod_mode ""
    } else {
	# Devo esporre comunque il vecchio modello disattivato
	set or_cod_mode "or cod_mode = $cod_mode_bruc"
    }
    element set_properties $form_name cod_mode_bruc -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $cod_cost_bruc]' and (flag_attivo <> 'N' $or_cod_mode)" cod_mode descr_mode];#nic01


    if {$flag_attivo eq "S"} {;#gab01  
	set cod_cost_asterisco "*"
	set data_installaz_asterisco "*"
	set data_costruz_gen_asterisco "*"
	if {$coimtgen(regione) eq "MARCHE" && $flag_tipo_impianto ne "R"} {#rom14 if e contenuto
	    set data_costruz_gen_asterisco ""
	}
	set dpr_660_96_asterisco "*"
        set mod_funz_asterisco "*"
	set cod_utgi_asterisco "*"
	set locale_asterisco "*" 
	set cod_combustibile_asterisco "*"     
	if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom33 Aggiunta if ma non il suo contenuto
	    set marc_effic_energ_asterisco "*";#rom08
	} else {#rom33 Aggiunta else e il suo contenuto
	    set marc_effic_energ_asterisco ""
	}
	set pot_utile_nom_asterisco    "*";#rom08
	set cod_emissione_asterisco    "*";#rom08
    
	if {$flag_tipo_impianto eq "R"} {;#gab01
	    set tiraggio_asterisco "*"
	    set tipo_foco_asterisco "*"
	}
	if {$flag_tipo_impianto eq "F"} {#rom13 aggiunta if e suo contenuto
	    #rom34 Aggiunte condizioni su Campania e Palermo.
	    if {$coimtgen(regione) in [list "MARCHE" "BASILICATA" "CAMPANIA"] || $coimtgen(ente) eq "PPA"} {#rom22 aggiunta if ma non il suo contenuto
		set cod_tpco_asterisco "<font color=red>*</font>"
		set sorgente_lato_esterno_asterisco "<font color=red>*</font>"
		set cod_flre_asterisco "<font color=red>*</font>"
		set fluido_lato_utenze_asterisco "<font color=red>*</font>"
	    } else {#rom22 Aggiunta else e suo contenuto
		set cod_tpco_asterisco ""
		set sorgente_lato_esterno_asterisco ""
		set cod_flre_asterisco ""
		set fluido_lato_utenze_asterisco ""
	    }
	}
    }  else {#rom26 Aggiunto else e il suo contenuto
	if {$coimtgen(regione) eq "MARCHE" &&
	    $funzione eq "M" &&
	    $flag_attivo_db eq "S"} {

	   element::set_error $form_name flag_attivo "Attenzione se si disattiva il generatore (ed &egrave; unico) verr&agrave; disattivato anche l'impianto, che potr&agrave; essere riattivato solo dal soggetto esecutore. Inoltre si precisa che nel caso il soggetto esecutore disattivi/chiuda/rottami l'impianto la procedura metter&agrave; in automatico il generatore in stato Non Attivo."
	}
    }

    if {[string equal $__refreshing_p "1"]} {;#nic01
	if {$changed_field eq "cod_cost"} {;#nic01
	    set focus_field "$form_name.cod_mode";#nic01
	} elseif {$changed_field eq "cod_cost_bruc"} {;#nic01
	    set focus_field "$form_name.cod_mode_bruc";#nic01
	};#nic01


	element set_properties $form_name __refreshing_p -value 0;#nic01
	element set_properties $form_name changed_field  -value "";#nic01

	ad_return_template;#nic01
	return;#nic01
    };#nic01

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    set error_bloccante 0;#gac08
#sim16    set gen_prog_error "gen_prog"
#sim16    if {$coimtgen(regione) eq "MARCHE"} {#rom11 if e contenuto
	set gen_prog_error "gen_prog_est"
#sim16    }
    
    if {$funzione == "I" || $funzione == "M" || $funzione == "S"} {#rom07 aggiunta condizione $funzione =="S"
	if {$funzione ne "S"} {#rom07
	if {$gen_prog eq ""} {
	    #rom11element::set_error $form_name gen_prog "Inserire"
	    element::set_error $form_name $gen_prog_error "Inserire";#rom11
            incr error_num
	}
	    set gen_prog [iter_check_num $gen_prog 0]
	    if {$gen_prog == "Error"} {
		#rom11element::set_error $form_name gen_prog "Deve essere un numero intero"
		element::set_error $form_name $gen_prog_error "Deve essere un numero intero";#rom11
		incr error_num
	    }
	};#rom07
	
	set data_insta [iter_check_date $data_installaz]
	if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom33 Aggiunta if ma non il suo contenuto	    
	    if {[string equal $marc_effic_energ ""] && $flag_tipo_impianto ne "T" && $flag_tipo_impianto ne "C" &&  $flag_tipo_impianto ne "F" && $data_insta > "2015-01-01"} {#gac05 aggiunto && $data_insta > "2015-01-01" #rom13aggiunta cond per freddo
		element::set_error $form_name marc_effic_energ "Inserire"
		incr error_num
	    }
	};#rom33
    
	if {![string equal $marc_effic_energ ""]} {#rom20 Aggiunta if e suo contenuto
	    if {[string match "*<*" $marc_effic_energ] || [string match "*>*" $marc_effic_energ]} {
		element::set_error $form_name marc_effic_energ "Non pu&ograve; contenere i caratteri < e >"
		incr error_num
	    }
	}

	#rom22if {$flag_tipo_impianto eq "F" && $coimtgen(regione) eq "MARCHE"} {}#rom13 aggiunta if e contenuto
	#rom34 Aggiunte condizioni su Campania e Palermo
	if {$flag_tipo_impianto eq "F" && ($coimtgen(regione) in [list "MARCHE" "BASILICATA" "CAMPANIA"] || $coimtgen(ente) eq "PPA")} {#rom22 aggiunta if ma non il contenuto
	    if {$cod_tpco eq ""} {
		element::set_error $form_name cod_tpco "Inserire"
		incr error_num
	    }

	    if {[db_0or1row q "select 1 
                                 from coimgend 
                                where cod_tpco != :cod_tpco
                                  and gen_prog != :gen_prog
                                  and cod_impianto = :cod_impianto
                                  and flag_attivo = 'S'
                              limit 1"]} {
		element::set_error $form_name cod_tpco "Il sistema di azionamento selezionato non &egrave; coerente con quelli degli altri generatori"
		incr error_num
	    }
		
	    if {$sorgente_lato_esterno eq ""} {
		element::set_error $form_name sorgente_lato_esterno "Inserire"
		incr error_num
	    }
	    if {$coimtgen(ente) ne "PPA"} {#rom36 if ma non il contenuto
	    if {$fluido_lato_utenze eq ""} {
		element::set_error $form_name fluido_lato_utenze "Inserire"
		incr error_num
	    }
	    };#rom36
	    if {$cod_flre eq ""} {
		element::set_error $form_name cod_flre "Inserire"
		incr error_num
	    }
	};#rom13


	if {$flag_tipo_impianto eq "F"} {#sim05: aggiunta if e suo contenuto
	    set num_circuiti [iter_check_num $num_circuiti 0]
	    #sim06 aggiunto condizione num_circuiti < 1
	    if {$num_circuiti == "Error" || $num_circuiti < 1} {
		#sim06 element::set_error $form_name num_circuiti "Deve essere un numero intero"
		element::set_error $form_name num_circuiti "Deve essere un numero intero maggiore di 0";#sim06
		incr error_num
		incr error_bloccante;#sim19
	    }

	    if {$coimtgen(regione) eq "MARCHE"} {#rom05 if e suo contenuto
		if {[string equal $per ""]} {
		    set is_null_per_p 1;#sim19
		    #sim19 element::set_error $form_name per "Inserire"
                    #sim19 incr error_num
                }
		if {[string equal $cop ""]} {
		    set is_null_cop_p 1;#sim19
		    #sim19 element::set_error $form_name cop "Inserire"
                    #sim19 incr error_num
                }

	    };#rom05
		    
	    if {![string equal $per ""]} {#sim08 if e suo contenuto
		set per [iter_check_num $per 2]
		if {$per == "Error" || $per > "10.00" } {#rom18 aggiunta condizione > 10
		    #rom18element::set_error $form_name per "Deve essere numerico, max 2 dec"
		    element::set_error $form_name per "Deve essere numerico, max 2 dec e non deve essere maggiore di 10.";#rom18
		    incr error_num
		    incr error_bloccante;#sim20
		}
	    } else {#rom30 Aggiunta else e il suo contenuto
		if {$coimtgen(regione) ne "MARCHE"} {
		    element::set_error $form_name per "Campo obbligatorio"
		    incr error_num
		}
	    }

	    if {![string equal $cop ""]} {#sim08 if e suo contenuto
		set cop [iter_check_num $cop 2]
		if {$cop == "Error" || $cop > "10.00"} {#rom18 aggiunta condizione > 10
		    #rom18element::set_error $form_name cop "Deve essere numerico, max 2 dec"
		    element::set_error $form_name cop "Deve essere numerico, max 2 dec e non deve essere maggiore di 10.";#rom18
		    incr error_bloccante;#sim20
		    incr error_num
		}
	    } else {#rom30 Aggiunta else e il suo contenuto
		if {$coimtgen(regione) ne "MARCHE"} {
		    element::set_error $form_name cop "Campo obbligatorio"
		    incr error_num
		}
	    }

	}
	
	if {$flag_tipo_impianto eq "R"} {#rom01: aggiunta if e suo contenuto        
	    set num_prove_fumi [iter_check_num $num_prove_fumi 0]
	    if {$num_prove_fumi == "Error" || $num_prove_fumi < 1 || $num_prove_fumi>9} {
		element::set_error $form_name num_prove_fumi "Deve essere un numero intero maggiore di 0 e minonre di 9";#rom01
		incr error_num
	    }
	    if {$gen_prog ne "Error"} {#rom07 aggiunta if
		set conta_prove_fumi [db_string q  "select count(cod_pr_fumi) as conta_prove_fumi
                                                  from coimgend_pote
                                                 where cod_impianto      = :cod_impianto 
                                          and gen_prog          = :gen_prog"];#rom06
		
		if {($conta_prove_fumi ne "0") && ($conta_prove_fumi ne $num_prove_fumi) && ($num_prove_fumi ne "Error")} {#rom06 if e contenuto
		    element::set_error $form_name num_prove_fumi "Esistono gi&agrave; le potenze dei singoli moduli col numero prove fumi indicato.<br>Dismettere il generatore e aggiungerne uno nuovo."
		    incr error_num
		};#rom06
		if {$num_prove_fumi ne "Error"} {#rom06 if, else e loro contenuto
		    if {[db_0or1row q "select 1 
                                 from coimgend 
                                where cod_impianto    = :cod_impianto
                                  and gen_prog        = :gen_prog
                                  and num_prove_fumi  > 1
                                  and :num_prove_fumi = num_prove_fumi"]} { 
			set  link_coimgend_pote "<a href=\"../src/coimgend-pote?nome_funz=$nome_funz&nome_funz_caller=$nome_funz_caller&cod_impianto=$cod_impianto&gen_prog=$gen_prog&caller=$caller\">Inserisci potenze singolo modulo</a>"
			
		    } else {
			set  link_coimgend_pote ""
		    }
		} else {
		    
		    set  link_coimgend_pote ""
		};#rom06
		if {$funzione eq "M" && $num_prove_fumi > 0 && $link_coimgend_pote ne "" &&
		    [db_0or1row q "select count(a.progressivo_prova_fumi)
                                     from coimgend_pote a
                                        , coimgend      b 
                                    where a.cod_impianto = :cod_impianto
                                      and a.gen_prog     = b.gen_prog
                                      and a.cod_impianto = b.cod_impianto
                                      and a.gen_prog     = :gen_prog
                                   having count(a.progressivo_prova_fumi) != :num_prove_fumi"]} {

		    element::set_error $form_name num_prove_fumi "Inserire le potenze singolo modulo utilizzando il link "
		    incr error_num

		}
	    };#rom07
	    #rom02 UCIT e Comune Trieste possono avere solo una prova fumi se sul generatore del caldo pot_focolare_nom 
	    #rom02 e < 35 
	    #rom30if {$coimtgen(ente) eq "PUD" || 
	    #rom30$coimtgen(ente) eq "PGO" || 
	    #rom30$coimtgen(ente) eq "PPN" || 
	    #rom30$coimtgen(ente) eq "PTS" || 
	    #rom30$coimtgen(ente) eq "CTRIESTE"
	    #rom30} {}#rom02 if e suo contenuto
	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom30 aggiunta if ma non contenuto
		set pot_focolare_nom_controllo_pf [iter_check_num $pot_focolare_nom 2];#sim10

		#sim10 usato nuova variabile pot_focolare_nom_controllo_pf e aggiunto if su Error
		if {$num_prove_fumi > 1 && $pot_focolare_nom_controllo_pf != "Error" && $pot_focolare_nom_controllo_pf < 35} {
		    element::set_error $form_name num_prove_fumi "Se Potenza nominale focolare &egrave; minore di 35 (kW) si pu&ograve; inserire solo 1 prova fumi"
                incr error_num
		} 
	    };#rom02
	}

	if {$matricola eq ""} {
	    element::set_error $form_name matricola "Campo obbligatorio"
	    incr error_num
	}
        
	if {$coimtgen(flag_gest_coimmode) eq "F"} {;#nic01
	    if {$modello eq ""} {
		element::set_error $form_name modello "Campo obbligatorio"
		incr error_num
	    }
	} else {;#nic011
	    if {$cod_mode eq ""} {;#nic01
		element::set_error $form_name cod_mode "Campo obbligatorio";#nic01
		incr error_num;#nic01
	    } else {;#nic01
		# Devo comunque valorizzare la colonna coimgend.modello
		if {![db_0or1row query "select descr_mode as modello
                                          from coimmode
                                         where cod_mode = :cod_mode"]
		} {;#nic01
		    element::set_error $form_name cod_mode "Modello non trovato in anagrafica";#nic01
		    incr error_num;#nic01
		};#nic01
	    };#nic01
	};#nic01
	
	set tipo_comb [db_string q "select tipo 
                                      from coimcomb 
                                     where cod_combustibile = :cod_combustibile" -default ""]

	if {$flag_attivo eq "S" } {#san04: ho aggiunto solo questa if ma non il suo contenuto
	    if {$cod_cost eq ""} {
		element::set_error $form_name cod_cost "Campo obbligatorio"
		incr error_num
	    }
	    if {$data_installaz eq ""} {
		element::set_error $form_name data_installaz "Campo obbligatorio"
		incr error_num
	    }
	    if {$coimtgen(regione) eq "MARCHE" &&
		$flag_tipo_impianto eq "R" &&
		$data_costruz_gen eq ""} {#rom14 agguiunta if e contenuto, aggiunta else ma non contenuto
		#le marche vogliono il campo obbligatorio solamente per il caldo
		element::set_error $form_name data_costruz_gen "Campo obbligatorio"
		incr error_num
	    } elseif {$coimtgen(regione) ne "MARCHE" && $data_costruz_gen eq ""} {#rom14 sostituita if con elseif e aggiunta cond. x marche 
		element::set_error $form_name data_costruz_gen "Campo obbligatorio"
		incr error_num
	    }

	    #rom03 aggiunta condizione && $flag_tipo_impianto ne "F"
	    if {$flag_tipo_impianto ne "T" && $flag_tipo_impianto ne "C" && $flag_tipo_impianto ne "F"} {#gab02 aggiunta if
		    if {$dpr_660_96 eq "" && $tipo_comb ne "S"} {#san03: aggiunta if e suo contenuto #gac05 aggiunto && $tipo_comb ne "S" 
			element::set_error $form_name dpr_660_96 "Campo obbligatorio"
			incr error_num
		    } 
	    }
	    if {$flag_tipo_impianto eq "R"} {#san03: aggiunta if e suo contenuto 
		#Questi campi esistono solo per il caldo
		if {$tiraggio eq ""} {
		    element::set_error $form_name tiraggio "Campo obbligatorio"
		    incr error_num
		}
		if {$tipo_foco eq ""} {
		    element::set_error $form_name tipo_foco "Campo obbligatorio"
		    incr error_num
		}
	    } 
	    #rom27if {$flag_tipo_impianto ne "C"} {
	    #rom27 Il fluido termovettore e' visibile e obbligatorio anche per la cogenerazione
	    #rom27 Se scelgono altro devono valorizzare il campo note altro.
		if {$coimtgen(regione) ne "MARCHE"} {#rom13 aggiunta if, le marche non vedono il campo
		    if {$mod_funz eq ""} {#san03: aggiunta if e suo contenuto
			element::set_error $form_name mod_funz "Campo obbligatorio"
			incr error_num
		    }
		    if {$mod_funz eq "3" && [string is space $altro_funz]} {#rom04 aggiunta if e suo contenuto
			element::set_error $form_name altro_funz "Compilare \"Altro\""
			incr error_num
		    };#rom04
		};#rom13
	    #rom27}
	    
	    if {$coimtgen(regione) eq "MARCHE" && ($flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "T" || $flag_tipo_impianto eq "C")} {#rom13 aggiunta if e contenuto
		if {$mod_funz eq ""} {#san03: aggiunta if e suo contenuto
		    element::set_error $form_name mod_funz "Campo obbligatorio"
		    incr error_num
		}
		if {$flag_tipo_impianto eq "R"} {
		    if {$mod_funz eq "3" && $altro_funz eq ""} {
			element::set_error $form_name altro_funz "Compilare \"Altro\""
			incr error_num
		    }
		}
	    }
	    
	    if {$coimtgen(regione) ne "MARCHE"} {#rom10 La regione Marche non visualizza piu il campo
		if {$cod_utgi eq ""} {#san03: aggiunta if e suo contenuto
		    element::set_error $form_name cod_utgi "Campo obbligatorio"
		    incr error_num
		}
	    }
            if {$flag_tipo_impianto ne "T" && $flag_tipo_impianto ne "C"} {#gab02 aggiunta if
		if {$locale eq ""} {#san03: aggiunta if e suo contenuto
		    element::set_error $form_name locale "Campo obbligatorio"
		    incr error_num
		}
	    }
	};#san04

	#rom07 Simone ha detto che il conbustibile deve essere obbligatorio anche per un generatore disattivo 
        #rom07 quindi ho spostato qui il controllo che prima veniva fatto solo per gli impianti attivi. 
	if {$cod_combustibile eq ""} {#san03: aggiunta if e suo contenuto
	    element::set_error $form_name cod_combustibile "Campo obbligatorio"
	    incr error_num
	}

	    set cambiocodice "N"
	    if {$gen_prog != $gen_prog_old} {
		if {[db_0or1row query "select 1 
                                     from coimgend 
                                    where cod_impianto = :cod_impianto 
                                      and gen_prog     = :gen_prog"] == 1} {
		    #rom11element::set_error $form_name gen_prog "Il codice risulta gia' presente"
		    element::set_error $form_name $gen_prog_error "Il codice risulta gia' presente";#rom11
		    incr error_num
		}

		#rom31 Aggiunta condizione 1 == 0
		if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && 1 == 0} {#rom30 aggiunta if e il suo contenuto
		    db_0or1row sel_cimp_check_x "select count(*) as conta_cimp
                                                   from coimcimp
                                                  where cod_impianto = :cod_impianto
                                                    and gen_prog     = :gen_prog_old
                                                    and flag_tracciato <> 'MA'"
		    if {$conta_cimp > 0} {
			# controllo la presenza di rapporti verifica con questo generatore
			element::set_error $form_name gen_prog_est "Il codice risulta presente in uno o pi&ugrave; rapporti di ispezione"
			incr error_num
		    }
		
		    db_0or1row sel_dope_gend_check_x "select count(*) as conta_dope_gend
                                                        from coimdope_aimp a
                                                           , coimdope_gend g
                                                       where a.cod_dope_aimp = g.cod_dope_aimp
                                                         and a.cod_impianto = :cod_impianto
                                                         and g.gen_prog     = :gen_prog_old"
		    if {$conta_dope_gend > 0} {
			# controllo la presenza di record della tabella coimdope_gend con questo generatore
			element::set_error $form_name gen_prog "Il codice risulta presente in una o pi&ugrave; Dichiarazioni di Frequenza"
			incr error_num
		    }
		    if {[db_0or1row sel_dimp_dam_check_x "select 1
                                                            from coimdimp a
                                                           where a.cod_impianto = :cod_impianto
                                                             and a.gen_prog     = :gen_prog_old
                                                           limit 1"]} {
			# controllo la presenza di record della tabella coimdimp con questo generatore
			element::set_error $form_name gen_prog_est "Il codice risulta presente in una o pi&ugrave; Dichiarazioni"
			incr error_num
		    } 
		};#rom30
		
		set cambiocodice "S"
	    }	
	
        if {![string equal $data_installaz ""]} {
            set data_installaz [iter_check_date $data_installaz]
            if {$data_installaz == 0} {
                element::set_error $form_name data_installaz "Data installazione deve essere una data"
                incr error_num
            } else {

		#but01 controllo per tutti gli enti (tranne le marche)
		#rom37 Aggiunta condizione su tipo_comb
 		if {$flag_tipo_impianto eq "R" && $tipo_comb ne "S"} {#but01 if e suo contenuto
		    if {$coimtgen(regione) ne "MARCHE"} {
			if {$data_installaz >= "20220101" && $tiraggio eq "N" && $cod_emissione ne "C"} {
			    element::set_error $form_name cod_emissione "Per i generatori a tiraggio naturale lo scarico pu&ograve; essere solo camino collettivo"
			    incr error_num         
			}
		    }
		}

		if {$data_installaz > $current_date} {
		    element::set_error $form_name data_installaz  "Data deve essere anteriore alla data odierna"
		    incr error_num
		} else {#sim08 else e suo contenuto
		    
		    #rom09		    set cod_manu_inst ""
		    #  		     db_0or1row q "select cod_installatore as cod_manu_inst 
		    #                                from coimaimp
		    #rom09                          where cod_impianto = :cod_impianto"	
		    if {$coimtgen(regione) eq "MARCHE"} {#rom09 if e contenuto
			#routine generica per controllo codice manutentore
			set check_cod_manu {
			    set chk_out_rc       0
			    set chk_out_msg      ""
			    set chk_out_cod_manu ""
			    set ctr_manu         0
			    if {[string equal $chk_inp_cognome ""]} {
				set eq_cognome "is null"
			    } else {
				set eq_cognome "= upper(:chk_inp_cognome)"
			    }
			    if {[string equal $chk_inp_nome ""]} {
				set eq_nome    "is null"
			    } else {
				set eq_nome    "= upper(:chk_inp_nome)"
			    }
			    db_foreach sel_manu "select cod_manutentore as cod_manu_db
                                                   from coimmanu
                                                   where cognome $eq_cognome
                                                     and nome    $eq_nome" {
							 incr ctr_manu
							 if {$cod_manu_db == $chk_inp_cod_manu} {
							     set chk_out_cod_manu $cod_manu_db
							     set chk_out_rc       1
							 }
						     }
			    switch $ctr_manu {
				0 { set chk_out_msg "Soggetto non trovato"}
				1 { set chk_out_cod_manu $cod_manu_db
				    set chk_out_rc       1 }
				default {
				    if {$chk_out_rc == 0} {
					set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
				    }
				}
			    }
			}
			if {[string equal $cognome_inst ""]
			    &&  [string equal $nome_inst    ""]
			} {
			    set cod_installatore ""
			} else {
			    set chk_inp_cod_manu $cod_installatore
			    set chk_inp_cognome  $cognome_inst
			    set chk_inp_nome     $nome_inst
			    eval $check_cod_manu
			    set cod_installatore $chk_out_cod_manu
			    if {$chk_out_rc == 0} {
				element::set_error $form_name cognome_inst $chk_out_msg
				incr error_num
			    }
			}
			if {![string equal $cognome_inst ""]} {
			    if {[string equal $nome_inst ""]} {	
				set eq_nome_inst "and nome is null"
			    } else {
				set eq_nome_inst "and nome = upper(:nome_inst)"
			    }
			    if {[db_0or1row sel_ruolo_inst "select '1'
                                                              from coimmanu
                                                             where (cognome = upper(:cognome_inst) $eq_nome_inst)
                                                              and (flag_ruolo = 'I' or flag_ruolo = 'T' or flag_ruolo is null)
                                                            limit 1" ] == 0} {#rom09 copiata da coimaimp-tecn-postgresql.xql
				element::set_error $form_name cognome_inst "Installatore non trovato"
				incr error_num
			    }
			}
			if {$coimtgen(regione) ne "MARCHE"} {#rom15 aggiunta if ma non suo contenuto
			    #rom09 sostituito && $cod_manu_inst eq "" con && cod_installatore eq ""
			    #rom09  tolto $coimtgen(regione) eq "MARCHE"
			    if {$data_installaz >= "20180701" && $cod_installatore eq ""} {
				element::set_error $form_name cognome_inst "Inserire Installatore"
				incr error_num
			    }
			}
		    }
		}
	    }
	}
	if {![string equal $data_rottamaz ""]} {
	    set data_rottamaz [iter_check_date $data_rottamaz]
	    if {$data_rottamaz == 0} {
		element::set_error $form_name data_rottamaz "data rottamazione deve essere una data"
		incr error_num
	    } else {
		if {$data_rottamaz > $current_date} {
		    element::set_error $form_name data_rottamaz  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $data_installaz ""]
	    && ![string equal $data_rottamaz ""]} {
            if {$data_rottamaz < $data_installaz} {
                element::set_error $form_name data_rottamaz "Data rottamazione deve essere > di data installazione"
                incr error_num
	    }
	}
	
        if {[string equal $flag_attivo "S"]
	    && ![string equal $data_rottamaz ""]} {
	    #rom26element::set_error $form_name data_rottamaz "Non rottamabile se &egrave; attivo"
	    element::set_error $form_name data_rottamaz "La data di dismissione/disattivazione va inserita solo nel caso in cui il generatore sia dismesso o disattivo.<br>Nel caso in cui si stia riattivando il generatore il campo va lasciato vuoto.";#rom26
            incr error_num
	}

	if {$coimtgen(regione) eq "MARCHE"} {#rom19 aggiunta if ma non il suo contenuto
	    if {[string equal $flag_attivo "S"]
		&& ![string equal $motivazione_disattivo ""]} {#rom12 if e contenuto
		element::set_error $form_name motivazione_disattivo "Valorizzare solo se il generatore &egrave; disattivo"
		incr error_num
	    }
	    if {[string equal $flag_attivo "N"]
		&& [string equal $motivazione_disattivo ""]} {#rom12 if e contenuto
	    element::set_error $form_name motivazione_disattivo "Obbligatorio se il GT &egrave; inattivo"
		incr error_num
	    }
	};#rom19

	if {$coimtgen(flag_gest_coimmode) eq "T"} {;#nic01
	    # In questo caso, devo comunque valorizzare la colonna coimgend.modello_bruc
	    set modello_bruc ""

	    if {$cod_mode_bruc ne ""
            && ![db_0or1row query "select descr_mode as modello_bruc
                                     from coimmode
                                    where cod_mode = :cod_mode_bruc"]
	    } {;#nic01
		element::set_error $form_name cod_mode_bruc "Modello bruc. non trovato in anagrafica";#nic01
		incr error_num;#nic01
	    };#nic01
	};#nic01
	if {$flag_tipo_impianto eq "F"} {#rom06 if e contenuto
	    if {[string equal $pot_focolare_lib ""]} {
		set is_null_pot_focolare_lib_p 1;#sim19
		#sim19 element::set_error $form_name pot_focolare_lib "Inserire"
		#sim19 incr error_num
		#sim19 incr error_bloccante;#gac08
	    }
	    if {[string equal $pot_utile_lib ""]} {
		set is_null_pot_utile_lib_p 1;#sim19
		#sim19 element::set_error $form_name pot_utile_lib "Inserire"
                #sim19 incr error_num
		#sim19 incr error_bloccante;#gac08
            }
	};#rom06
        if {![string equal $pot_focolare_lib ""]} {
            set pot_focolare_lib [iter_check_num $pot_focolare_lib 2]
            if {$pot_focolare_lib == "Error"} {
                element::set_error $form_name pot_focolare_lib "Deve essere numerico, max 2 dec"
                incr error_num
		incr error_bloccante;#gac08
            } else {
                if {[iter_set_double $pot_focolare_lib] >=  [expr pow(10,5)]
		    ||  [iter_set_double $pot_focolare_lib] <= -[expr pow(10,5)]} {
                    element::set_error $form_name pot_focolare_lib "Deve essere inferiore di 100.000"
                    incr error_num
		    incr error_bloccante;#gac08
                }
            }
        }
        if {![string equal $pot_utile_lib ""]} {
            set pot_utile_lib [iter_check_num $pot_utile_lib 2]
            if {$pot_utile_lib == "Error"} {
                element::set_error $form_name pot_utile_lib "Deve essere numerico, max 2 dec"
                incr error_num
		incr error_bloccante;#gac08
            } else {
                if {[iter_set_double $pot_utile_lib] >=  [expr pow(10,5)]
		    ||  [iter_set_double $pot_utile_lib] <= -[expr pow(10,5)]} {
                    element::set_error $form_name pot_utile_lib "Deve essere inferiore di 100.000"
                    incr error_num
		    incr error_bloccante;#gac08
                }
            }
        }

	set flag_pot_focolare_nom_ok "f"
        if {[string equal $pot_focolare_nom ""]} {
	    if {$flag_tipo_impianto eq "F"} {#sim19
		set is_null_pot_focolare_nom_p 1;#sim19
	    } else {#sim19 else ma non suo contenuto
		element::set_error $form_name pot_focolare_nom "Inserire"
		incr error_num
		incr error_bloccante;#gac08
	    }
	} else {
            set pot_focolare_nom [iter_check_num $pot_focolare_nom 2]
            if {$pot_focolare_nom == "Error"} {
                element::set_error $form_name pot_focolare_nom "Deve essere numerico, max 2 dec"
                incr error_num
		incr error_bloccante;#gac08
            } elseif {$pot_focolare_nom <= 0} {
		element::set_error $form_name pot_focolare_nom "Deve essere > 0,00"
		incr error_num
		incr error_bloccante;#gac08
	    } elseif {[iter_set_double $pot_focolare_nom] >= [expr pow(10,5)]} {
		element::set_error $form_name pot_focolare_nom "Deve essere inferiore di 100.000"
		incr error_num
		incr error_bloccante;#gac08
	    } else {
		set flag_pot_focolare_nom_ok "t"
	    }
	}

	set flag_pot_utile_nom_ok "f"
	if {[string equal $pot_utile_nom ""]} {
	    #sim17 il teleriscaldamento non ha la potenza utile
	    if {($coimtgen(regione) ne "MARCHE" || $flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "C") && $flag_tipo_impianto ne "T"} {#rom13

		if {$flag_tipo_impianto eq "F"} {#sim19 if e suo contenuto
		    set is_null_pot_utile_nom_p 1
		} else {#sim19 else ma non il suo contenuto 	
		    element::set_error $form_name pot_utile_nom "Inserire"
		    incr error_num
		    incr error_bloccante;#gac08
		};#sim19 
	    }
	} else {
            set pot_utile_nom [iter_check_num $pot_utile_nom 2]
            if {$pot_utile_nom == "Error"} {
                element::set_error $form_name pot_utile_nom "Deve essere numerico, max 2 dec"
                incr error_num
		incr error_bloccante;#gac08
            } elseif {$pot_utile_nom <= 0} {
		element::set_error $form_name pot_utile_nom "Deve essere > 0,00"
		incr error_num
		incr error_bloccante;#gac08
	    } elseif {[iter_set_double $pot_utile_nom] >= [expr pow(10,5)]} {
		element::set_error $form_name pot_utile_nom "Deve essere inferiore di 100.000"
		incr error_num
		incr error_bloccante;#gac08
            } else {
		set flag_pot_utile_nom_ok "t"
	    }
	}

	if {$flag_tipo_impianto eq "F"} {#sim04 if e suo contenuto
	    
	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $error_bloccante == 0} {#rom30 Aggiunte if, else e il loro contenuto
		set pot_utile_nom [db_string q "select iter_edit_num(:pot_utile_nom, 2)"]
		set pot_freddo_da_contr $pot_utile_nom
		set nome_campo_pot_freddo pot_utile_nom
	    } else {
		set pot_freddo_da_contr $pot_utile_nom_freddo
		set nome_campo_pot_freddo pot_utile_nom_freddo
	    }

	    set flag_pot_utile_nom_freddo_ok "f";#sim04

	    #rom30 Rinominata variabile pot_utile_nom_freddo in pot_freddo_da_contr
	    #rom30 I messaggi di errore sulla potenza del freddo ora si basano sulla variabile nome_campo_pot_freddo, prima erano sempre sul campo pot_utile_nom_freddo
	    if {[string equal $pot_freddo_da_contr ""]} {#sim04 if else e loro contenuto
		set is_null_pot_utile_nom_freddo_p 1;#sim19
		#sim19 element::set_error $form_name pot_utile_nom_freddo "Inserire"
		#sim19 incr error_num
		#sim19 incr error_bloccante;#gac08
	    } else {

		set pot_freddo_da_contr [iter_check_num $pot_freddo_da_contr 2]

		if {$pot_freddo_da_contr == "Error"} {
		    element::set_error $form_name $nome_campo_pot_freddo "Deve essere numerico, max 2 dec"
		    incr error_num
		    incr error_bloccante;#gac08
		} elseif {$pot_freddo_da_contr <= 0} {
		    element::set_error $form_name $nome_campo_pot_freddo "Deve essere > 0,00"
		    incr error_num
		    incr error_bloccante;#gac08
		} elseif {[iter_set_double $pot_freddo_da_contr] >= [expr pow(10,5)]} {
		    element::set_error $form_name $nome_campo_pot_freddo "Deve essere inferiore di 100.000"
		    incr error_num
		    incr error_bloccante;#gac08
		} else {
		    set flag_pot_utile_nom_freddo_ok "t"
		}
	    }
	    
	    if {$flag_pot_focolare_nom_ok eq "t" && $flag_pot_utile_nom_freddo_ok eq "t"} {
		if {$pot_freddo_da_contr > $pot_focolare_nom} {
		    #rom30 Aggiunta Regione Friuli
		    if {!($coimtgen(regione) in [list "MARCHE" "FRIULI-VENEZIA GIULIA"])} {#rom13 aggiunta if ma non contenuto, aggiunta else e suo contenuto
			element::set_error $form_name $nome_campo_pot_freddo "Potenza utile deve essere <= alla potenza nominale"
		    } else {
			element::set_error $form_name $nome_campo_pot_freddo "Potenza assorbita deve essere <= alla potenza nominale"
		    };#rom13
		    incr error_num
		    incr error_bloccante;#gac08
		    set flag_potenza_utile_ok "f"
		}
	    }	    

	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom30 Aggiunte if, else e il loro contenuto
		set pot_utile_nom $pot_freddo_da_contr
	    } else {
		set pot_utile_nom_freddo $pot_freddo_da_contr
	    }

	} else {#sim04
	if {$flag_pot_focolare_nom_ok eq "t" && $flag_pot_utile_nom_ok eq "t"} {#san03: aggiunta if e suo contenuto
            if {$pot_utile_nom >= $pot_focolare_nom} { #gac04 modificato if e messaggio errore 
   	        element::set_error $form_name pot_utile_nom "Potenza utile deve essere < alla potenza nominale"
	        incr error_num
		incr error_bloccante;#gac08
                set flag_potenza_utile_ok "f"
            }
	} 

    };#sim04

	#sim19 per il freddo faccio i controlli incrociati sui campi delle potenze del caldo e del freddo.
	if {$flag_tipo_impianto eq "F"} {#sim19 if e suo contenuto
	    
	    set is_null_raffrescamento_p 0
	    set is_null_riscaldamento_p  0
	    
	    if {$coimtgen(regione) ne "MARCHE"} {

		#cop e per non sono obbligatori negli enti della regione marche. Vado quindi a settarli uguali ai flag
		# relativi alle potenze in modo che non siano piu significativi nei controlli sotto
		set is_null_cop_p $is_null_pot_focolare_lib_p
		set is_null_per_p $is_null_pot_focolare_nom_p

	    } else {

		#la pot_utile_nom e visibile solo per gli enti diversi dalla regione marche. Vado quindi a settarlo uguale
		#ai flag relativi alle potenze in modo che non sia piu significato nei controlli sotto
		set is_null_pot_utile_nom_p $is_null_per_p
	    }

	    #verifico se sono tutti nulli i campi relativi alla potenza del freddo
	    if {$is_null_per_p && $is_null_pot_focolare_nom_p && $is_null_pot_utile_nom_freddo_p && $is_null_pot_utile_nom_p} {

		set is_null_raffrescamento_p 1

	    } else {

		#se non sono tutti nulli devono essere tutti valorizzati.
		if {$is_null_per_p || $is_null_pot_focolare_nom_p || $is_null_pot_utile_nom_freddo_p || $is_null_pot_utile_nom_p} {

		    incr error_num
		    incr error_bloccante
		    element::set_error $form_name pot_focolare_nom "Inserire tutti i campi relativi al Raffrescamento"	    
		}
	    }
    
	    #verifico se sono tutti nulli i campi relativi alla potenza del caldo
	    if {$is_null_cop_p && $is_null_pot_focolare_lib_p && $is_null_pot_utile_lib_p} {

		set is_null_riscaldamento_p 1

	    } else {

		#se non sono tutti nulli devono essere tutti valorizzati.
		if {$is_null_cop_p || $is_null_pot_focolare_lib_p || $is_null_pot_utile_lib_p} {

		    incr error_num
		    incr error_bloccante
		    element::set_error $form_name pot_focolare_lib "Inserire tutti i campi relativi al Riscaldamento"
		}
	    }
	    
	    #se sia i dati del caldo che i dati del freddo sono nulli do un messaggio di errore
	    if {$is_null_riscaldamento_p && $is_null_raffrescamento_p} {
		incr error_num
		incr error_bloccante
		element::set_error $form_name pot_focolare_lib "Inserire i dati delle potenze di Raffrescamento e/o di Riscaldamento"
	    }

	}

        if {![string equal $data_costruz_gen ""]} {
           if {[string length $data_costruz_gen] == 4} {
                 set data_costruz_gen "01/01/$data_costruz_gen"
           };#sandro07082018
            set data_costruz_gen [iter_check_date $data_costruz_gen]
            if {$data_costruz_gen == 0} {
                element::set_error $form_name data_costruz_gen "Inserire correttamente"
                incr error_num
            } else {
		if {$data_costruz_gen > $current_date} {
		    element::set_error $form_name data_costruz_gen "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $data_costruz_bruc ""]} {
            set data_costruz_bruc [iter_check_date $data_costruz_bruc]
            if {$data_costruz_bruc == 0} {
                element::set_error $form_name data_costruz_bruc "Inserire correttamente"
                incr error_num
            } else {
		if {$data_costruz_bruc > $current_date} {
		    element::set_error $form_name data_costruz_bruc  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $data_installaz_bruc ""]} {
            set data_installaz_bruc [iter_check_date $data_installaz_bruc]
            if {$data_installaz_bruc == 0} {
                element::set_error $form_name data_installaz_bruc "Inserire correttamente"
                incr error_num
            } else {
		if {$data_installaz_bruc > $current_date} {
		    element::set_error $form_name data_installaz_bruc  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

	if {![string equal $data_costruz_bruc ""]
	    && ![string equal $data_installaz_bruc ""]} {
	    if {$data_costruz_bruc > $data_installaz_bruc} {
		element::set_error $form_name data_costruz_bruc  "Data deve essere anteriore alla data di installazione"
		incr error_num
	    }
	}

	if {![string equal $data_costruz_gen ""]
	    && ![string equal $data_installaz ""]} {
	    if {$data_costruz_gen > $data_installaz} {
		element::set_error $form_name data_costruz_gen  "Data deve essere anteriore alla data di installazione"
		incr error_num
	    }
	}
	if {($coimtgen(regione) eq "MARCHE") } {#rom02 if e suo contenuto
	    #rom02 se dpr_660_96 equivale a 'S'(Standard) , data_costruz_gen e successiva al 26/09/2015, 
	    #rom02 il combustibile e liquido o solido e tipo_foco non e 'A' (Aperta) do il messaggio di errore e blocco.
	    if {$flag_tipo_impianto ne "F"} {#rom05 aggiunta if
		#sim12 if { $dpr_660_96 eq "S" && $data_costruz_gen >"20150906" && [db_0or1row q "select 1 
                #sim12                                                                             from coimcomb 
                #sim12                                                                            where cod_combustibile = :cod_combustibile 
                #sim12                                                                              and tipo in ('L' , 'G')"] && $tipo_foco ne "A" 
		#sim12 } {
		#sim12    element::set_error $form_name dpr_660_96 "In base alla Direttiva 2005/32/CE \"Ecodesign\" se<br>la 'data costruzione' e successiva al 26/09/2015 il campo<br>'Classif. DPR 660/96' puo essere solo 'A gas a condensazione'.<br>A meno che alla voce 'Camera di combustione' non venga selezionata la tipologia  'Aperta'" 
		#sim12    incr error_num
		    
		#sim12}

		if {$data_costruz_gen >"20150926" && [db_0or1row q "select 1 
                                                                      from coimcomb 
                                                                     where cod_combustibile = :cod_combustibile 
                                                                       and tipo in ('L' , 'G')"]} {#sim12 if e suo contenuto
		    
		    if {$tipo_foco eq "C" && $dpr_660_96 ne "G"} {

			element::set_error $form_name dpr_660_96 "In base alla Direttiva 2005/32/CE \"Ecodesign\" se<br>la 'data costruzione' &egrave; successiva al 26/09/2015 e la Camera di combustione &egrave; uguale a \"Stagna\" il campo<br>'Classif. DPR 660/96' pu&ograve; essere solo 'A gas a condensazione'."
			incr error_num

		    }
		    
		}
		
		if {$dpr_660_96 eq "B" && $flag_caldaia_comb_liquid eq ""} {
		    element::set_error $form_name flag_caldaia_comb_liquid "Selezionare se si tratta di una caldaia a condensazione che utilizza combustibile liquido"
		    incr error_num
		}
		if {$dpr_660_96 ne "B" && $flag_caldaia_comb_liquid ne ""} {
		    element::set_error $form_name flag_caldaia_comb_liquid "Valorizzare solo per Classif. DPR 660/96 a bassa temperatura"
		    incr error_num
		}
	    };#rom05
	};#rom02
        if {![string equal $data_rottamaz_bruc ""]} {
            set data_rottamaz_bruc [iter_check_date $data_rottamaz_bruc]
            if {$data_rottamaz_bruc == 0} {
                element::set_error $form_name data_rottamaz_bruc "Inserire correttamente"
                incr error_num
            } else {
		if {$data_rottamaz_bruc > $current_date} {
		    element::set_error $form_name data_rottamaz_bruc  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

	if {![string equal $campo_funzion_max ""]
	    && [string equal $campo_funzion_min ""]} {
	    element::set_error $form_name campo_funzion_min "Inserire anche il valore minimo"
	    incr error_num
	}

	if {![string equal $campo_funzion_min ""]
	    && [string equal $campo_funzion_max ""]} {
	    element::set_error $form_name campo_funzion_max "Inserire anche il valore massimo"
	    incr error_num
	}

        if {![string equal $campo_funzion_max ""]} {
            set campo_funzion_max [iter_check_num $campo_funzion_max 2]
            if {$campo_funzion_max == "Error"} {
                element::set_error $form_name campo_funzion_max "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
                if {[iter_set_double $campo_funzion_max] >=  [expr pow(10,7)]
		    ||  [iter_set_double $campo_funzion_max] <= -[expr pow(10,7)]} {
                    element::set_error $form_name campo_funzion_max "Deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $campo_funzion_min ""]} {
            set campo_funzion_min [iter_check_num $campo_funzion_min 2]
            if {$campo_funzion_min == "Error"} {
                element::set_error $form_name campo_funzion_min "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
                if {[iter_set_double $campo_funzion_min] >=  [expr pow(10,7)]
		    ||  [iter_set_double $campo_funzion_min] <= -[expr pow(10,7)]} {
                    element::set_error $form_name campo_funzion_min "Deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }

	if {![string equal $campo_funzion_min ""]
	    && ![string equal $campo_funzion_max ""]
	    && $campo_funzion_min > $campo_funzion_max} {
            element::set_error $form_name campo_funzion_min "Il val. min deve essere < del val. max"
	    incr error_num
        }

	if {![string equal $data_installaz_bruc ""]
	    && ![string equal $data_rottamaz_bruc ""]} {
            if {$data_rottamaz_bruc < $data_installaz_bruc} {
                element::set_error $form_name data_rottamaz_bruc "Data rottamazione bruc deve. essere > di data installazione bruc."
                incr error_num
	    }
	}

        if {![string equal $carica_refrigerante ""]} {;#dpr74: aggiunta if ed il suo contenuto
            set carica_refrigerante [iter_check_num $carica_refrigerante 2]
            if {$carica_refrigerante == "Error"} {
                element::set_error $form_name carica_refrigerante "numerico, max 2 dec"
                incr error_num
            } else {
		if {$carica_refrigerante < "0.01"} {
		    element::set_error $form_name carica_refrigerante "deve essere &gt; di 0,00"
		    incr error_num
		} else {
		    if {[iter_set_double $carica_refrigerante] >=  [expr pow(10,8)]
		    ||  [iter_set_double $carica_refrigerante] <= -[expr pow(10,8)]} {
			element::set_error $form_name carica_refrigerante "Deve essere < di 100.000.000"
			incr error_num
		    }
                }
            }
        }
	if {($coimtgen(regione) eq "MARCHE")} {#rom02 if e suo contenuto
	    if {$flag_tipo_impianto ne "F"} {#rom05 aggiunta if
		#rom012if {$funzione_grup_ter eq "A" && $funzione_grup_ter_note_altro eq ""} {}
		if {$flag_altro eq "S" && $funzione_grup_ter_note_altro eq ""} {#rom12 sostituita precedente if
		    element::set_error $form_name funzione_grup_ter_note_altro "Compilare \"Note Altro\" specificando il tipo di funzione alternativo"
		    #element::set_error $form_name funzione_grup_ter_note_altro "Specificare Altro"
		    incr error_num
		}
		#rom012if {$funzione_grup_ter ne "A" && $funzione_grup_ter_note_altro ne ""} {}
		if {$flag_altro ne"S" && $funzione_grup_ter_note_altro ne ""} {#rom12 sostituita precedente if
		    element::set_error $form_name funzione_grup_ter_note_altro "Compilare solo se viene scelto \"Si\" alla voce \"Altro\""
		    #element::set_error $form_name funzione_grup_ter_note_altro "Per specificare le Note e necessario selezionare 'Altro' in 'Funzione del Gruppo Termico'"
		    incr error_num
		}
	    };#rom05
	    #gac03 aggiunta if e suo contenuto
	    if {$rif_uni_10389 eq "A" && $altro_rif eq ""} {#gac03
		element::set_error $form_name altro_rif "Compilare \"Altro\""
		incr error_num
	    };#gac03
	    if {$rif_uni_10389 ne "A" && $altro_rif ne ""} {#gac03
		element::set_error $form_name altro_rif "Compilare solo in caso di \"Riferimento = Altro\""
		incr error_num
            };#gac03
	};#rom02
	#rom15 tolta condizione su flag_altro
	if {$flag_prod_acqua_calda ne "S" && $flag_clima_invernale ne "S" && $flag_clim_est ne "S"} {#rom12 if e contenuto
	    element::set_error $form_name flag_prod_acqua_calda "Valorizzare a \"Si\" almeno uno dei seguenti campi"
	    incr error_num
	};#rom12
	if {$flag_prod_acqua_calda eq "" || $flag_clima_invernale eq "" || $flag_clim_est eq ""} {#rom12 if e suo contenuto
	    element::set_error $form_name flag_prod_acqua_calda "valorizzare ognuno dei seguenti campi"
	    incr error_num
	}
	
	if {$coimtgen(regione) eq "MARCHE"
	    && $flag_tipo_impianto eq "F"
	    && $pot_focolare_lib < "0.01"
	    && $flag_prod_acqua_calda eq "S"} {
	    element::set_error $form_name flag_prod_acqua_calda "Impossibile Valorizzare a \"Si\" il seguente campo con la potenza termica nominale a 0,00"
	    incr error_num
	}

	if {$flag_tipo_impianto eq "F"} {#rom21 aggiunta if e suo contenuto

	    if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom35 Aggiunta if ma non il suo contenuto
	    if {([string equal $flag_clima_invernale "S"] && [string equal $flag_clim_est "S"]) &&
		($is_null_riscaldamento_p || $is_null_raffrescamento_p )} {

		#Per climatizzazione invernale ed estiva devo avere
		#sia le potenze del caldo che le potenze del freddo.
		element::set_error $form_name flag_prod_acqua_calda "Valorizzare tutte le potenze del Raffrescamento e Riscaldamento."
		incr error_num
		incr error_bloccante
	    } elseif {[string equal $flag_clima_invernale "S"] && ![string equal $flag_clim_est "S"] &&
		      ($is_null_riscaldamento_p || !$is_null_raffrescamento_p )} {

		#Per climatizzazione invernale devo avere solo le potenze del caldo.
		element::set_error $form_name flag_prod_acqua_calda "Valorizzare solo le potenze del Riscaldamento."
		incr error_num
		incr error_bloccante
	    } elseif {![string equal $flag_clima_invernale "S"] && [string equal $flag_clim_est "S"] &&
		      ($is_null_raffrescamento_p || !$is_null_riscaldamento_p )} {

		#Per climatizzazione estiva devo avere solo le potenze del freddo.
		element::set_error $form_name flag_prod_acqua_calda "Valorizzare solo le potenze del Raffrescamento."
		incr error_num
		incr error_bloccante
	    } else {
	    }
	    } else {#rom35 Aggiunta else e il suo contenuto
		if {$is_null_riscaldamento_p || $is_null_raffrescamento_p} {
		    element::set_error $form_name per "Valorizzare tutte le potenze del Raffrescamento e Riscaldamento."
		    incr error_num
		    incr error_bloccante
		}	    
	    }
	}
	
	set cod_coimtpin ""
	set descrizione_tpin ""
	if {$coimtgen(flag_controllo_abilitazioni)} {#rom30 aggiunta if ma non il contenuto
	if {$flag_tipo_impianto ne "" && $cod_combustibile ne "" && $cod_manutentore ne ""} {#rom03M if e suo contenuto
	    
	    	if {$flag_tipo_impianto eq "F"} {#sim

	    	if {![db_0or1row q "select 1
                              from coimtpin_manu
                             where cod_coimtpin    in (3,8)
                               and cod_manutentore = :cod_manutentore limit 1"]} {
		    
		   element::set_error $form_name flag_tipo_impianto "Utente non abilitato per l'inserimento<br>di \"Pompe di calore\""
		   incr error_num
	       }

	    
	} else {#sim

	    if {[db_0or1row q "select 1
                             from coimtpin_abilitazioni
                            where flag_tipo_impianto = :flag_tipo_impianto
                              and tipo_combustibile is not null
                            limit 1"]} {
		
		db_0or1row q "select a.cod_coimtpin
                               , b.descrizione as descrizione_tpin
                            from coimtpin_abilitazioni a
                               , coimtpin b
                           where a.flag_tipo_impianto = :flag_tipo_impianto
                             and a.tipo_combustibile  = :tipo_comb
                             and a.cod_coimtpin       = b.cod_coimtpin"
		
	    } else {
		
		db_0or1row q "select a.cod_coimtpin
                               , b.descrizione as descrizione_tpin
                            from coimtpin_abilitazioni a
                               , coimtpin b
                           where a.flag_tipo_impianto = :flag_tipo_impianto
                             and a.cod_coimtpin = b.cod_coimtpin"
		
	    }                                 
	    
	    if {![db_0or1row q "select 1
                              from coimtpin_manu
                             where cod_coimtpin    = :cod_coimtpin
                               and cod_manutentore = :cod_manutentore"]} {
		
		element::set_error $form_name cod_combustibile "Utente non abilitato per l'inserimento<br>di \"$descrizione_tpin\""
		incr error_num
	    }

	};#sim
	    
	};#rom03M
	};#rom30
	if {$flag_tipo_impianto eq "R"} {#rom02 if e contenuto 
	    if {![string equal $rend_ter_max ""]} {#sim08 if e suo contenuto
		set rend_ter_max [iter_check_num $rend_ter_max 2]
		if {$rend_ter_max == "Error"} {
		    element::set_error $form_name rend_ter_max "Deve essere numerico, max 2 dec"
		    incr error_num
		} else {#sim18 else e suo contenuto
		    if {[iter_set_double $rend_ter_max] >=  [expr pow(10,7)]
			||  [iter_set_double $rend_ter_max] <= -[expr pow(10,7)]} {
			element::set_error $form_name rend_ter_max "Deve essere inferiore di 10.000.000"
			incr error_num
		    }
		}
	    }
	    if {[string equal $rend_ter_max ""]} {
		element::set_error $form_name rend_ter_max "Campo obbligatorio"
		incr error_num
	    }

	    set check_rend_ter_max $rend_ter_max
	    set evidenzia_rend_ter "f"
	    if {$coimtgen(regione) eq "MARCHE"} {#rom04 if e suo contenuto
		if {$flag_tipo_impianto ne "F"} {#rom05 aggiunta if
		    if {(($dpr_660_96 eq "B" || $dpr_660_96 eq "G") && ($check_rend_ter_max <= "85" || $check_rend_ter_max >= "120"))  
			|| (($tipo_comb eq "L" || $tipo_comb eq "G") && $dpr_660_96 eq "S" && ($check_rend_ter_max <= "78"  || $check_rend_ter_max >= "100") )
			|| ($tipo_comb eq "S" && $dpr_660_96 eq "S" && ($check_rend_ter_max <= "50" || $check_rend_ter_max >= "100"))
		    } {
			set evidenzia_rend_ter "t"

			if {$conferma_rend_ter == "s"} {
			    element::set_error $form_name dpr_660_96 "<big>Warning:</big> Valore del \"Rendimento termico utile a Pn max\" inserito nella Scheda 4.1 non congruo rispetto al tipo combustibile e al tipo \"Classif. DPR 660/96\" qui inserito: correggere il dato errato."
			    if {$error_num == 0} {
				element set_properties $form_name conferma_rend_ter -value "n"
			    }
			    incr error_num
			}
		    }
		};#rom05
	    };#rom04
	};#rom02
	element set_properties $form_name evidenzia_rend_ter           -value $evidenzia_rend_ter
    	
    }

    if {$funzione == "D"} {
	db_0or1row sel_cimp_check_x "select count(*) as conta_cimp
          from coimcimp
         where cod_impianto = :cod_impianto
           and gen_prog     = :gen_prog
           and flag_tracciato <> 'MA'"
	if {$conta_cimp > 0} {
	    # controllo la presenza di rapporti verifica con questo generatore
	    #rom11element::set_error $form_name gen_prog "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; rapporti di ispezione"
	    element::set_error $form_name $gen_prog_error "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; rapporti di ispezione";#rom11
	    incr error_num       
	}
	
	db_0or1row sel_dope_gend_check_x "select count(*) as conta_dope_gend
                                            from coimdope_aimp a
                                               , coimdope_gend g
                                           where a.cod_dope_aimp = g.cod_dope_aimp
                                             and a.cod_impianto = :cod_impianto
                                             and g.gen_prog     = :gen_prog";#gab03
	
	if {$conta_dope_gend > 0} {;#gab03
            # controllo la presenza di record della tabella coimdope_gend con questo generatore
            #rom11element::set_error $form_name gen_prog "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; Dichiarazioni di Frequenza"
	    element::set_error $form_name $gen_prog_error "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; Dichiarazioni di Frequenza";#rom11
            incr error_num
        }
	#gac01 fatto in modo che non si possa eliminare un generatore nel caso in cui ci siano dichiarazioni
	if {[db_0or1row sel_dimp_dam_check_x "select 1
                                               from coimdimp a
                                              where a.cod_impianto = :cod_impianto
                                                and a.gen_prog     = :gen_prog 
                                              limit 1"]} {#gac01
	    # controllo la presenza di record della tabella coimdimp con questo generatore
	    #rom11element::set_error $form_name gen_prog "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; Dichiarazioni"
	    element::set_error $form_name $gen_prog_error "Il generatore che stai tentando di eliminare &egrave; presente in uno o pi&ugrave; Dichiarazioni";#rom11
	    incr error_num
	} ;#gac01
	
	
    }

    #sim07 inizio:dato che il controllo diventa bloccante ho spostato qui il pezzo di codice che prima
    #sim07 si trovava in fondo al programma. Eseguo il controllo solo se non ho nessun errore sulle variepotenze
    #gac08 sostituito error_num con error_bloccante
    #rom40 Aggiunta condizione per Napoli
    if {($coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" || $coimtgen(ente) eq "PNA") && ($id_settore in [list "ente" "system"] && [string equal $id_ruolo "admin"])} {#rom35 Aggiunta if e il suo contenuto
        set error_num 0
	set error_bloccante 0
    }

    if {$error_bloccante == 0} {
	

	if {$funzione eq "S"} {#rom17 aggiunta if, else e loro contenuto
	    #se sto facendo una sostituzione non devo tenere conto nei conteggi del generatore sostituito
	    set where_escludi_sostitito "and gen_prog     != :gen_prog_old"
	} else {
	    set where_escludi_sostitito ""
	};#rom17

	# aggiorno l'impianto valorizzando il numero di generatori
	# le potenze e la fascia con la somma dei valori
	# corrispondenti di tutti i generatori attivi
	db_1row sel_gend_count_x "
                 select count(*)              as count_gend
                      , sum(pot_focolare_nom) as tot_pot_focolare_nom
                      , sum(pot_utile_nom)    as tot_pot_utile_nom
                      , sum(pot_utile_nom_freddo) as tot_pot_utile_nom_freddo --sim04
                      , sum(pot_focolare_lib) as tot_pot_focolare_lib --sim01 per il freddo e la potenza riscaldam. nominale
                      , sum(pot_utile_lib)    as tot_pot_utile_lib    --sim01 per il freddo e la potenza riscaldamento utile
                   from coimgend
                  where cod_impianto = :cod_impianto
                    and gen_prog != :gen_prog --sim07
                        $where_escludi_sostitito --rom17
                    and flag_attivo  = 'S'"
	    
	#sim09 aggiunto condizione su flag_attivo
	if {$funzione ne "D" && $flag_attivo eq  "S"} {#sim07 se sono in inserimento o modifica devo tener conto della potenza che sto aggiungendo o modificando
	    
	    set count_gend [expr $count_gend + 1]

	    db_1row q "select coalesce(:tot_pot_focolare_nom,0.00) + coalesce(:pot_focolare_nom,0.00) as tot_pot_focolare_nom
                            , coalesce(:tot_pot_utile_nom,0.00)    + coalesce(:pot_utile_nom,0.00)    as tot_pot_utile_nom
                            , coalesce(:tot_pot_utile_nom_freddo,0.00) + coalesce(:pot_utile_nom_freddo,0.00) as tot_pot_utile_nom_freddo 
                            , coalesce(:tot_pot_focolare_lib,0.00) + coalesce(:pot_focolare_lib,0.00) as tot_pot_focolare_lib
                            , coalesce(:tot_pot_utile_lib,0.00) + coalesce(:pot_utile_lib,0.00)    as tot_pot_utile_lib "
	}    	    
	 
	#sim01 Per i generatori del freddo, mettiamo nell'impianto la potenza maggiore
	#sim01 tra quella di raffreddamento e quella di riscaldamento
	#sim01 (viene valvata nella potenza libretto).
	if {$flag_tipo_impianto eq "F" } {#sim01 aggiunta if e suo contenuto 
	    set tot_pot_utile_nom $tot_pot_utile_nom_freddo;#sim04

	    #25/11/2019 Rivisto con Sandro. Per calcolare la fascia di potenza usiamo la max tra Potenza frigorifera nominale
	    #           e la  Potenza termica nominale
	    if {$tot_pot_focolare_lib > $tot_pot_focolare_nom} {
		#mic01 set tot_pot_focolare_nom $tot_pot_focolare_lib
		set tot_pot_utile_nom $tot_pot_focolare_lib;#sim14
		set pot_max $tot_pot_focolare_lib;#mic01
	    } else {#sim14 else e suo contenuto
		set tot_pot_utile_nom $tot_pot_focolare_nom
		set pot_max $tot_pot_focolare_nom;#mic01
	    }
	    
	    if {$tot_pot_utile_lib > $tot_pot_utile_nom} {
#sim14		set tot_pot_utile_nom $tot_pot_utile_lib
	    }

	    # In data 09/04/2019 abbiamo concordato con Sandro che il freddo deve prendere la maggiore tra
	    # la Potenza frigorifera nominale e la Potenza termica nominale.
	    # La if sotto non va bene nemmeno per il caldo che si basa sul parametro flag_potenza. Di conseguenza la commento
#	    if {$coimtgen(regione) eq "MARCHE" } {#rom13 per le marche va messa tot_pot_focolare_lib
#		set tot_pot_utile_nom $tot_pot_focolare_lib
#	    }

	    set tot_pot_focolare_nom $tot_pot_focolare_nom;#rom30
	    set tot_pot_utile_nom    $tot_pot_focolare_lib;#rom30

	}

	#nic03 if {$coimtgen(regione) eq "MARCHE"} #san02
	if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic03 (cambiata if)
	    if {$flag_tipo_impianto eq "F" } { #mic01 aggiunta if, else e suo contenuto
		set tot_potenza_chk $pot_max;
	    } else {
		set tot_potenza_chk $tot_pot_utile_nom;#san02
	    }
	    if {$flag_tipo_impianto eq "F" } {;#sim04 if else e loro contenuto
		set campo_potenza_per_errore "pot_utile_nom_freddo"
	    } else {
		set campo_potenza_per_errore "pot_utile_nom"
	    }
	} else {;#san02
	    set tot_potenza_chk $tot_pot_focolare_nom
	    set campo_potenza_per_errore "pot_focolare_nom";#sim04 
	};#san02
	
	#sim04
	if {$coimtgen(regione) eq "MARCHE"} {#rom13 aggiunta if e suo contenuto
	    set campo_potenza_per_errore "pot_focolare_nom"
	}
	#sim07 aggiunto condizione su funzione
	if {![string equal $tot_potenza_chk ""] &&
	    [db_0or1row check_fascia_pote ""]== 0 &&
	    $funzione ne "D"} {;#sim04
	    
	    element::set_error $form_name $campo_potenza_per_errore "non &egrave; compresa in nessuna fascia"
	    
	    incr error_num
	}
    
    #sim07 fine
    }
    
    #rom01 se esistono dichiarazini del caldo e del freddo non posso cambiare rispettivamente i campi num_prove_fumi e
    #rom01 num_circuiti.
    if {$funzione ==  "M" &&  [db_0or1row query "
                                select 1 
                                  from coimdimp b
                                 where b.cod_impianto   = :cod_impianto
                                   and b.gen_prog       = :gen_prog
                                   and flag_tracciato   in ('R1','R2','G','F')
                                 limit 1"]    
    } {#rom01 if e suo contenuto

	db_1row q "select num_prove_fumi as num_prove_fumi_old
                        , num_circuiti as num_circuiti_old 
                     from coimgend 
                    where cod_impianto = :cod_impianto 
                      and gen_prog     = :gen_prog"

	if {$flag_tipo_impianto eq "R" && $num_prove_fumi_old ne "" && $num_prove_fumi_old != $num_prove_fumi} {

	    element::set_error $form_name num_prove_fumi "Esistono gi&agrave; RCEE col numero prove fumi indicato.<br>Dismettere il generatore e aggiungerne uno nuovo."
	    incr error_num
	}

	if {$flag_tipo_impianto eq "F" && $num_circuiti_old ne "" && $num_circuiti_old != $num_circuiti} {

	    element::set_error $form_name num_circuiti "Esistono gi&agrave; RCEE col numero circuiti indicato.<br> Dismettere il generatore e aggiungerne uno nuovo."
	    incr error_num
	}
	

    }

    #gac02 controllo sui nuovi campi del cogeneratore
    if {![string equal $temp_h2o_uscita_min ""]} {
	set temp_h2o_uscita_min [iter_check_num $temp_h2o_uscita_min 2]
	if {$temp_h2o_uscita_min == "Error"} {
	    element::set_error $form_name temp_h2o_uscita_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $temp_h2o_uscita_max ""]} {
	set temp_h2o_uscita_max [iter_check_num $temp_h2o_uscita_max 2]
	if {$temp_h2o_uscita_max == "Error"} {
	    element::set_error $form_name temp_h2o_uscita_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$temp_h2o_uscita_max < $temp_h2o_uscita_min} {
	    element::set_error $form_name temp_h2o_uscita "Max deve essere >= Min"
	    incr error_num
	}
    }

    if {![string equal $temp_h2o_ingresso_min ""]} {
	set temp_h2o_ingresso_min [iter_check_num $temp_h2o_ingresso_min 2]
	if {$temp_h2o_ingresso_min == "Error"} {
	    element::set_error $form_name temp_h2o_ingresso_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $temp_h2o_ingresso_max ""]} {
	set temp_h2o_ingresso_max [iter_check_num $temp_h2o_ingresso_max 2]
	if {$temp_h2o_ingresso_max == "Error"} {
	    element::set_error $form_name temp_h2o_ingresso_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$temp_h2o_ingresso_max < $temp_h2o_ingresso_min} {
	    element::set_error $form_name temp_h2o_ingresso "Max deve essere >= Min"
	    incr error_num
	}
    }
    if {![string equal $temp_h2o_motore_min ""]} {
	set temp_h2o_motore_min [iter_check_num $temp_h2o_motore_min 2]
	if {$temp_h2o_motore_min == "Error"} {
	    element::set_error $form_name temp_h2o_motore_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $temp_h2o_motore_max ""]} {
	set temp_h2o_motore_max [iter_check_num $temp_h2o_motore_max 2]
	if {$temp_h2o_motore_max == "Error"} {
	    element::set_error $form_name temp_h2o_motore_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$temp_h2o_motore_max < $temp_h2o_motore_min} {
	    element::set_error $form_name temp_h2o_motore "Max deve essere >= Min"
	    incr error_num
	}
    }
    if {![string equal $temp_fumi_valle_min ""]} {
	set temp_fumi_valle_min [iter_check_num $temp_fumi_valle_min 2]
	if {$temp_fumi_valle_min == "Error"} {
	    element::set_error $form_name temp_fumi_valle_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $temp_fumi_valle_max ""]} {
	set temp_fumi_valle_max [iter_check_num $temp_fumi_valle_max 2]
	if {$temp_fumi_valle_max == "Error"} {
	    element::set_error $form_name temp_fumi_valle_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$temp_fumi_valle_max < $temp_fumi_valle_min} {
	    element::set_error $form_name temp_fumi_valle "Max deve essere >= Min"
	    incr error_num
	}
    }
    if {![string equal $temp_fumi_monte_min ""]} {
	set temp_fumi_monte_min [iter_check_num $temp_fumi_monte_min 2]
	if {$temp_fumi_monte_min == "Error"} {
	    element::set_error $form_name temp_fumi_monte_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $temp_fumi_monte_max ""]} {
	set temp_fumi_monte_max [iter_check_num $temp_fumi_monte_max 2]
	if {$temp_fumi_monte_max == "Error"} {
	    element::set_error $form_name temp_fumi_monte_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$temp_fumi_monte_max < $temp_fumi_monte_min} {
	    element::set_error $form_name temp_fumi_monte "Max deve essere >= Min"
	    incr error_num
	}
    }
    if {![string equal $emissioni_monossido_co_min ""]} {
	set emissioni_monossido_co_min [iter_check_num $emissioni_monossido_co_min 2]
	if {$emissioni_monossido_co_min == "Error"} {
	    element::set_error $form_name emissioni_monossido_co_min "Deve essere numerico, max 2 dec"
	    incr error_num
	}
    }
    if {![string equal $emissioni_monossido_co_max ""]} {
	set emissioni_monossido_co_max [iter_check_num $emissioni_monossido_co_max 2]
	if {$emissioni_monossido_co_max == "Error"} {
	    element::set_error $form_name emissioni_monossido_co_max "Deve essere numerico, max 2 dec"
	    incr error_num
	}
	if {$emissioni_monossido_co_max < $emissioni_monossido_co_min} {
	    element::set_error $form_name emissioni_monossido_co "Max deve essere >= Min"
	    incr error_num
	}
    }

    if {[db_0or1row q "select 1
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and gen_prog     = :gen_prog
                          and gen_prog_est = :gen_prog_est
                          and :flag_attivo = 'S'
                          and flag_attivo != :flag_attivo
                          and gen_prog_est = (select gen_prog_est 
                                                from coimgend
                                               where cod_impianto = :cod_impianto
                                                 and gen_prog_est = :gen_prog_est
                                                 and flag_attivo  = 'S'
                                               limit 1)" ] == 1} {#rom07 aggiunta if, elseif, else e loro contenuto
	#rom07 Se si mette un generatore da stato Disattivo ad Attivo bisogna controllare se 
	#rom07 esite un altro generatore attivo con lo stesso gen_prog_est.
	#rom07 Se esiste gen_prog_est viene calcolato facendo il max +1 dei generatori attivi.
	set gen_prog_est_dis [db_string q "select coalesce(max (gen_prog_est + 1) , '1')
                                             from coimgend
                                            where cod_impianto    = :cod_impianto
                                              and flag_attivo = 'S'"]
    } elseif {[db_0or1row q "select 1
                               from coimgend
                              where cod_impianto = :cod_impianto
                                and gen_prog     = :gen_prog
                                and gen_prog_est = :gen_prog_est
                                and :flag_attivo = 'N'
                                and flag_attivo != :flag_attivo
                                and gen_prog_est = (select gen_prog_est
                                                      from coimgend
                                                     where cod_impianto = :cod_impianto
                                                       and gen_prog_est = :gen_prog_est
                                                       and flag_attivo  = 'N'
                                                     limit 1)" ] == 1} {
	#rom07 Se si mette un generatore da stato Attivo a Disattivo bisogna controllare se
	#rom07 esiste un altro generatore disattivo con lo stesso gen_prog_est.
	#rom07 Se esiste gen_prog_est viene calcolato facendo il max +1 dei generatori non sostituiti.
        set gen_prog_est_dis [db_string q "select coalesce(max (gen_prog_est + 1) , '1')
                                             from coimgend
                                            where cod_impianto     = :cod_impianto
                                              and flag_sostituito != 'S'"]
    } else {
	#rom07 Altrimenti gen_prog_est rimane lo stesso che ha gia.
	set gen_prog_est_dis $gen_prog_est
    };#rom07
	
	
	
	#rom07 un generatore sostituito e disattivato non puo essere riattivato 
    if {[db_0or1row q "select 1 
                         from coimgend 
                        where cod_impianto    = :cod_impianto 
                          and gen_prog        = :gen_prog 
                          and gen_prog_est    = :gen_prog_est 
                          and flag_sostituito = 'S' 
                          and :flag_attivo   != 'N'"] && $funzione ne "I"} {#rom07 if e contenuto 
	element::set_error $form_name flag_attivo "Non si pu&ograve; riattivare un generatore che &egrave; stato sostituito e disattivato"
	incr error_num
    }
	
	if {$flag_tipo_impianto eq "T"} {#rom16 aggiunta if e suo contenuto
	    if {$tel_alimentazione eq ""} {
		element::set_error $form_name tel_alimentazione "Inserire"
		incr error_num
	    }
	}
    
    if {$coimtgen(regione) eq "MARCHE"} {#gac08 aggiunta if e suo contenuto
	
	#tipo combustibile selezionato
	set tipo_comb [db_string q "select tipo
                                      from coimcomb
                                     where cod_combustibile = :cod_combustibile" -default ""]
	
	#valore del tipo combustibile presente sul db
	set tipo_comb_old        ""
	set cod_combustibile_old ""
	db_0or1row q "select tipo as tipo_comb_old
                           , i.cod_combustibile as cod_combustibile_old
                        from coimcomb c
                           , coimaimp i
                       where i.cod_combustibile = c.cod_combustibile
                         and i.cod_impianto     = :cod_impianto"
	
	#gac08 se il tipo combustibile selezionato e diverso da quello del combustibile precedente
	#gac08 mostro il warning
	if {$tipo_comb_old ne $tipo_comb} {
	    set msg_cod_combustibile "Attenzione: il tipo di combustibile del generatore selezionato &egrave; differente dal combustibile dell'impianto"
	} else {
	    set msg_cod_combustibile ""
	}

	#se un ente sta cambiando il combustibile salto tutti i controlli
	if {$cod_manutentore eq "" && $cod_combustibile ne $cod_combustibile_old && $error_bloccante ==0} {
	    set error_num 0
	}	
	
    }

    #rom40 Aggiunta condizione per Napoli
    if {($coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" || $coimtgen(ente) eq "PNA") && ($id_settore in [list "ente" "system"] && [string equal $id_ruolo "admin"])} {#rom35 Aggiunta if e il suo contenuto
        set error_num 0
	set error_bloccante 0
    }

    #gac02 fine controlli

    if {$error_num > 0} {
	#ns_log notice "coimgend-gest LUCAR: [template::form::get_errors $form_name]"
        ad_return_template
        return
    }       
        
    if {$coimtgen(regione) ne "MARCHE" } {#rom09 if e suo contenuto
	if {$gen_prog_est eq ""} {
	    set gen_prog_est $gen_prog
	    set gen_prog_est_dis $gen_prog
	}
    }

    if {$flag_tipo_impianto eq "T" && $coimtgen(regione) eq "MARCHE"} {#sim13
	#in questo modo non dovro aggiornare i vari controlli sulle potenze
	set pot_utile_nom $pot_focolare_nom
	set tot_pot_utile_nom $tot_pot_focolare_nom
	set tot_potenza_chk $tot_pot_focolare_nom
    }
		

    
    # Lancio la query di manipolazione dati contenuta in dml_sql
    with_catch error_msg {
	db_transaction {
	    switch $funzione {
		I {
		    db_dml ins_gend_x "insert
                  into coimgend 
                     ( cod_impianto
                     , gen_prog
                     , descrizione
                     , matricola
                     , modello
                     , cod_cost
                     , matricola_bruc
                     , modello_bruc
                     , cod_cost_bruc
                     , tipo_foco
                     , mod_funz
                     , cod_utgi
                     , tipo_bruciatore
                     , tiraggio
                     , locale
                     , cod_emissione
                     , cod_combustibile
                     , data_installaz
                     , data_rottamaz
                     , pot_focolare_lib
                     , pot_utile_lib
                     , pot_focolare_nom
                     , pot_utile_nom
                     , pot_utile_nom_freddo --sim04
                     , flag_attivo
                     , motivazione_disattivo --rom12
                     , note
                     , data_ins 
                     , utente
		     , gen_prog_est
                     , data_costruz_gen
                     , data_costruz_bruc
                     , data_installaz_bruc
                     , data_rottamaz_bruc
                     , marc_effic_energ
                     , campo_funzion_max
                     , campo_funzion_min
                     , dpr_660_96
                     , cod_tpco            -- dpr74
                     , cod_flre            -- dpr74
                     , carica_refrigerante -- dpr74
                     , sigillatura_carica  -- dpr74
                     , cod_mode            -- nic01
                     , cod_mode_bruc       -- nic01
                     , cod_grup_term       -- san01
                     , num_circuiti        -- sim05
                     , num_prove_fumi      -- rom01
                     , per                 -- sim08
                     , cop                 -- sim08
                     , tipologia_cogenerazione    --gac02
                     , temp_h2o_uscita_min        --gac02
                     , temp_h2o_uscita_max        --gac02
                     , temp_h2o_ingresso_min      --gac02
                     , temp_h2o_ingresso_max      --gac02
                     , temp_h2o_motore_min        --gac02
                     , temp_h2o_motore_max        --gac02
                     , temp_fumi_valle_min        --gac02
                     , temp_fumi_valle_max        --gac02
                     , temp_fumi_monte_min        --gac02
                     , temp_fumi_monte_max        --gac02
                     , emissioni_monossido_co_max --gac02
                     , emissioni_monossido_co_min --gac02
             --rom12 , funzione_grup_ter            --rom02
                     , flag_clima_invernale     --rom12
                     , flag_clim_est     --rom12
                     , flag_prod_acqua_calda --rom12
                     , flag_altro        --rom12
                     , funzione_grup_ter_note_altro --rom02
                     , flag_caldaia_comb_liquid     --rom02
                     , rend_ter_max                 --rom02
                     , rif_uni_10389                --gac03
                     , altro_rif                    --gac03
                     , altro_funz                   --rom04
                     , cod_installatore             --rom09bis
                     , sorgente_lato_esterno        --rom13
                     , fluido_lato_utenze           --rom13
                     , tel_alimentazione            --rom16
		     )
                values 
                     (:cod_impianto
                     ,:gen_prog
                     ,:descrizione
                     ,:matricola
                     ,:modello
                     ,:cod_cost
                     ,:matricola_bruc
                     ,:modello_bruc
                     ,:cod_cost_bruc
                     ,:tipo_foco
                     ,:mod_funz
                     ,:cod_utgi
                     ,:tipo_bruciatore
                     ,:tiraggio
                     ,:locale
                     ,:cod_emissione
                     ,:cod_combustibile
                     ,:data_installaz
                     ,:data_rottamaz
                     ,:pot_focolare_lib
                     ,:pot_utile_lib
                     ,:pot_focolare_nom
                     ,:pot_utile_nom
                     ,:pot_utile_nom_freddo --sim04
                     ,:flag_attivo
                     ,:motivazione_disattivo --rom12
                     ,:note
                     , current_date
                     ,:id_utente
	--rom07	     ,:gen_prog
                     ,:gen_prog_est --rom07
                     ,:data_costruz_gen
                     ,:data_costruz_bruc
                     ,:data_installaz_bruc
                     ,:data_rottamaz_bruc
                     ,:marc_effic_energ
                     ,:campo_funzion_max
                     ,:campo_funzion_min
                     ,:dpr_660_96
                     ,:cod_tpco            -- dpr74
                     ,:cod_flre            -- dpr74
                     ,:carica_refrigerante -- dpr74
                     ,:sigillatura_carica  -- dpr74
                     ,:cod_mode            -- nic01
                     ,:cod_mode_bruc       -- nic01
                     ,:cod_grup_term       -- san01
                     ,:num_circuiti        -- sim05
                     ,:num_prove_fumi      -- rom01
                     ,:per                 -- sim08
                     ,:cop                 -- sim08
                     ,:tipologia_cogenerazione    --gac02
                     ,:temp_h2o_uscita_min        --gac02
                     ,:temp_h2o_uscita_max        --gac02
                     ,:temp_h2o_ingresso_min      --gac02
                     ,:temp_h2o_ingresso_max      --gac02
                     ,:temp_h2o_motore_min        --gac02
                     ,:temp_h2o_motore_max        --gac02
                     ,:temp_fumi_valle_min        --gac02
                     ,:temp_fumi_valle_max        --gac02
                     ,:temp_fumi_monte_min        --gac02
                     ,:temp_fumi_monte_max        --gac02
                     ,:emissioni_monossido_co_max --gac02
                     ,:emissioni_monossido_co_min --gac02
              --rom12, funzione_grup_ter            --rom02
                     ,:flag_clima_invernale     --rom12
                     ,:flag_clim_est     --rom12
                     ,:flag_prod_acqua_calda --rom12
                     ,:flag_altro        --rom12
                     ,:funzione_grup_ter_note_altro --rom02
                     ,:flag_caldaia_comb_liquid     --rom02
                     ,:rend_ter_max                 --rom02
                     ,:rif_uni_10389                --gac03
                     ,:altro_rif                    --gac03
                     ,:altro_funz                   --rom04
                     ,:cod_installatore             --rom09bis
                     ,:sorgente_lato_esterno        --rom13
                     ,:fluido_lato_utenze           --rom13
                     ,:tel_alimentazione            --rom16
		     )"
	#rom09bis   if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
	#rom09bis	db_dml upd_aimp_inst "update coimaimp
        #rom09bis                                 set cod_installatore = :cod_installatore 
        #rom09bis                                   , data_mod         =  current_date
        #rom09bis                                   , utente           = :id_utente
        #rom09bis                               where cod_impianto     = :cod_impianto"
	#rom09bis   }
		}
		M {

		    if {[string equal $flag_attivo "N"] && [string is space $data_rottamaz]} {#rom26 Aggiunta if e il suo contenuto.
			set data_rottamaz $current_date
		    }		    
		    
		    db_dml upd_gend_x "update coimgend
                   set gen_prog         = :gen_prog
                     , descrizione      = :descrizione
                     , matricola        = :matricola
                     , modello          = :modello
                     , cod_cost         = :cod_cost
          --rom28    , matricola_bruc   = :matricola_bruc
          --rom28    , modello_bruc     = :modello_bruc
          --rom28    , cod_cost_bruc    = :cod_cost_bruc
                     , tipo_foco        = :tipo_foco
                     , mod_funz         = :mod_funz
                     , cod_utgi         = :cod_utgi
          --rom28    , tipo_bruciatore  = :tipo_bruciatore
                     , tiraggio         = :tiraggio
                     , locale           = :locale
                     , cod_emissione    = :cod_emissione
                     , cod_combustibile = :cod_combustibile
                     , data_installaz   = :data_installaz
                     , data_rottamaz    = :data_rottamaz
                     , pot_focolare_lib = :pot_focolare_lib
                     , pot_utile_lib    = :pot_utile_lib
                     , pot_focolare_nom = :pot_focolare_nom
                     , pot_utile_nom    = :pot_utile_nom
                     , pot_utile_nom_freddo    = :pot_utile_nom_freddo --sim04
                     , flag_attivo      = :flag_attivo
                     , motivazione_disattivo = :motivazione_disattivo --rom12
                     , note             = :note
                     , data_mod         =  current_date
                     , utente           = :id_utente
		     , gen_prog_est     = :gen_prog_est_dis --rom07
                     , data_costruz_gen    = :data_costruz_gen
          --rom28    , data_costruz_bruc   = :data_costruz_bruc
          --rom28    , data_installaz_bruc = :data_installaz_bruc
          --rom28    , data_rottamaz_bruc  = :data_rottamaz_bruc
                     , marc_effic_energ    = :marc_effic_energ
          --rom28    , campo_funzion_max   = :campo_funzion_max
          --rom28    , campo_funzion_min   = :campo_funzion_min
                     , dpr_660_96          = :dpr_660_96
                     , cod_tpco            = :cod_tpco            -- dpr74
                     , cod_flre            = :cod_flre            -- dpr74
                     , carica_refrigerante = :carica_refrigerante -- dpr74
                     , sigillatura_carica  = :sigillatura_carica  -- dpr74
                     , cod_mode            = :cod_mode            -- nic01
                     , cod_mode_bruc       = :cod_mode_bruc       -- nic01
                     , cod_grup_term       = :cod_grup_term       -- san01
                     , num_circuiti        = :num_circuiti        -- sim05
                     , num_prove_fumi      = :num_prove_fumi      -- rom01
                     , per                 = :per                 -- sim08
                     , cop                 = :cop                 -- sim08
                     , tipologia_cogenerazione      = :tipologia_cogenerazione    --gac02
                     , temp_h2o_uscita_min          = :temp_h2o_uscita_min        --gac02
                     , temp_h2o_uscita_max          = :temp_h2o_uscita_max        --gac02
                     , temp_h2o_ingresso_min        = :temp_h2o_ingresso_min      --gac02
                     , temp_h2o_ingresso_max        = :temp_h2o_ingresso_max      --gac02
                     , temp_h2o_motore_min          = :temp_h2o_motore_min        --gac02
                     , temp_h2o_motore_max          = :temp_h2o_motore_max        --gac02
                     , temp_fumi_valle_min          = :temp_fumi_valle_min        --gac02
                     , temp_fumi_valle_max          = :temp_fumi_valle_max        --gac02
                     , temp_fumi_monte_min          = :temp_fumi_monte_min        --gac02
                     , temp_fumi_monte_max          = :temp_fumi_monte_max        --gac02
                     , emissioni_monossido_co_max   = :emissioni_monossido_co_max --gac02
                     , emissioni_monossido_co_min   = :emissioni_monossido_co_min --gac02
              --rom12, funzione_grup_ter            = funzione_grup_ter            --rom02
                     , flag_clima_invernale                = :flag_clima_invernale                --rom12
                     , flag_clim_est                = :flag_clim_est                --rom12
                     , flag_prod_acqua_calda            = :flag_prod_acqua_calda            --rom12
                     , flag_altro                   = :flag_altro                   --rom12
                     , funzione_grup_ter_note_altro = :funzione_grup_ter_note_altro --rom02
                     , flag_caldaia_comb_liquid     = :flag_caldaia_comb_liquid     --rom02
                     , rend_ter_max                 = :rend_ter_max                 --rom02
                     , rif_uni_10389                = :rif_uni_10389                --gac03
                     , altro_rif                    = :altro_rif                    --gac03
                     , altro_funz                   = :altro_funz                   --rom04
                     , cod_installatore             = :cod_installatore             --rom09bis
                     , sorgente_lato_esterno        = :sorgente_lato_esterno        --rom13
                     , fluido_lato_utenze           = :fluido_lato_utenze           --rom13
                     , tel_alimentazione            = :tel_alimentazione            --rom16
                 where cod_impianto = :cod_impianto
                   and gen_prog     = :gen_prog_old"

	#rom09bis   if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
	#rom09bis	db_dml upd_aimp_inst "update coimaimp
        #rom09bis                                set cod_installatore    = :cod_installatore 
        #rom09bis                                  , data_mod            =  current_date
        #rom09bis                                  , utente              = :id_utente
        #rom09bis                              where cod_impianto        = :cod_impianto"
        #rom09bis   }

		    if {$coimtgen(regione) eq "MARCHE"} {#rom25 Aggiunta if e il suo contenuto
			if {($flag_attivo eq "N" &&
			    ![db_0or1row q "select 1
                                              from coimgend
                                             where cod_impianto = :cod_impianto 
                                               and gen_prog    != :gen_prog_old
                                               and flag_attivo  = 'S'
                                             limit 1"])
			    && [db_0or1row q "select 1
                                                from coimaimp
                                               where cod_impianto = :cod_impianto
                                                 and stato        = 'A'"]
			} {
			    # Se vengono resi non attivi i generatori l'impianto assume lo stato di NON ATTIVO.

			    db_dml upd_aimp_dis "update coimaimp
                                                    set stato         = 'N'
                                                      , data_rottamaz = current_date
                                                      , data_mod      = current_date
                                                  where cod_impianto = :cod_impianto"
			}
			#rom29 Aggiunta condizione && $cod_manutentore eq ""
			if {$flag_attivo eq "S" &&
			    [db_0or1row q "select 1
                                             from coimaimp
                                            where cod_impianto = :cod_impianto
                                              and stato        = 'N'"] &&
			    $cod_manutentore eq ""} {
			    #Se l'impianto e' non Attivo e viene riattivato il generatore anche l'impianto passa in stato Attivo.
			    #rom29 La riattivazione dell'impianto viene fatta solo se il generatore e' stato riattivato dall'ente.
			    db_dml upd_aimp_att "update coimaimp
                                                   set stato          = 'A'
                                                     , data_attivaz   = current_date
                                                      , data_rottamaz = null
                                                     , data_mod       = current_date
                                                 where cod_impianto = :cod_impianto"
			}
			
		    }
		    
		}
		D {
		    db_dml del_gend_x "delete from coimgend
                 where cod_impianto = :cod_impianto
                   and gen_prog     = :gen_prog"
		    db_dml del_gend_pote "delete from coimgend_pote
                 where cod_impianto = :cod_impianto
                   and gen_prog     = :gen_prog";#rom26 elimino le potenze delle singole prove fumi.

		    if {[db_0or1row q "select gen_prog as gen_prog_sostituente
                                         from coimgend
                                        where cod_impianto = :cod_impianto
                                          and gen_prog_originario = :gen_prog"]} {#rom23 aggiunta if e suo contenuto

			db_dml upd_gen_sost "update coimgend
                                                 set gen_prog_originario = null
                                               where cod_impianto = :cod_impianto
                                                 and gen_prog     = :gen_prog_sostituente"
		    }		       
		    
		}
		S {
		    
		    #sim11 set gen_prog_est_new [db_string q "select coalesce(max(gen_prog_est + 1), '1') 
                    #sim11                                     from coimgend
                    #sim11                                    where cod_impianto = :cod_impianto
                    #sim11                                      and flag_attivo     = 'N' --rom07.bis
                    #sim11                                      and flag_sostituito = 'S' --rom07.bis "];#rom07


		    #sim11 dopo un'analisi successiva si e chiarito che il sostituito mantiene il suo numero est
		    db_dml upd_gend_sost "update coimgend
                   set flag_sostituito  = 'S' --rom07
                     , flag_attivo      = 'N' --rom07 il generatore sostituito non deve essere attivo 
	         --    , gen_prog_est     = gen_prog_est_new --rom07
                     , data_mod         = current_timestamp
                 where cod_impianto = :cod_impianto
                   and gen_prog     = :gen_prog_old"

		    db_dml sost_gend "insert
                  into coimgend 
                     ( cod_impianto
                     , gen_prog
                     , descrizione
                     , matricola
                     , modello
                     , cod_cost
                     , matricola_bruc
                     , modello_bruc
                     , cod_cost_bruc
                     , tipo_foco
                     , mod_funz
                     , cod_utgi
                     , tipo_bruciatore
                     , tiraggio
                     , locale
                     , cod_emissione
                     , cod_combustibile
                     , data_installaz
                     , data_rottamaz
                     , pot_focolare_lib
                     , pot_utile_lib
                     , pot_focolare_nom
                     , pot_utile_nom
                     , pot_utile_nom_freddo --sim04
                     , flag_attivo
                     , motivazione_disattivo --rom12
                     , note
                     , data_ins 
                     , utente
		     , gen_prog_est
                     , data_costruz_gen
                     , data_costruz_bruc
                     , data_installaz_bruc
                     , data_rottamaz_bruc
                     , marc_effic_energ
                     , campo_funzion_max
                     , campo_funzion_min
                     , dpr_660_96
                     , cod_tpco            -- dpr74
                     , cod_flre            -- dpr74
                     , carica_refrigerante -- dpr74
                     , sigillatura_carica  -- dpr74
                     , cod_mode            -- nic01
                     , cod_mode_bruc       -- nic01
                     , cod_grup_term       -- san01
                     , num_circuiti        -- sim05
                     , num_prove_fumi      -- rom01
                     , per                 -- sim08
                     , cop                 -- sim08
                     , tipologia_cogenerazione    --gac02
                     , temp_h2o_uscita_min        --gac02
                     , temp_h2o_uscita_max        --gac02
                     , temp_h2o_ingresso_min      --gac02
                     , temp_h2o_ingresso_max      --gac02
                     , temp_h2o_motore_min        --gac02
                     , temp_h2o_motore_max        --gac02
                     , temp_fumi_valle_min        --gac02
                     , temp_fumi_valle_max        --gac02
                     , temp_fumi_monte_min        --gac02
                     , temp_fumi_monte_max        --gac02
                     , emissioni_monossido_co_max --gac02
                     , emissioni_monossido_co_min --gac02
              --rom12, funzione_grup_ter            --rom02
                     , flag_clima_invernale                --rom12    
                     , flag_clim_est                --rom12    
                     , flag_prod_acqua_calda            --rom12
                     , flag_altro                   --rom12       
                     , funzione_grup_ter_note_altro --rom02
                     , flag_caldaia_comb_liquid     --rom02
                     , rend_ter_max                 --rom02
                     , rif_uni_10389                --gac03
                     , altro_rif                    --gac03
                     , altro_funz                   --rom04
                     , cod_installatore             --rom09bis
                     , sorgente_lato_esterno        --rom13
                     , fluido_lato_utenze           --rom13
                     , tel_alimentazione            --rom16
                     , gen_prog_originario          --sim11
		     )
                values 
                     (:cod_impianto
                     ,:gen_prog
                     ,:descrizione
                     ,:matricola
                     ,:modello
                     ,:cod_cost
                     ,:matricola_bruc
                     ,:modello_bruc
                     ,:cod_cost_bruc
                     ,:tipo_foco
                     ,:mod_funz
                     ,:cod_utgi
                     ,:tipo_bruciatore
                     ,:tiraggio
                     ,:locale
                     ,:cod_emissione
                     ,:cod_combustibile
                     ,:data_installaz
                     ,:data_rottamaz
                     ,:pot_focolare_lib
                     ,:pot_utile_lib
                     ,:pot_focolare_nom
                     ,:pot_utile_nom
                     ,:pot_utile_nom_freddo --sim04
                     ,'S' --rom07 nella sostituzione il nuovo generatore sara quello attivo
                     ,:motivazione_disattivo --rom12
                     ,:note
                     , current_date
                     ,:id_utente
		     ,:gen_prog_est --rom07 
                     ,:data_costruz_gen
                     ,:data_costruz_bruc
                     ,:data_installaz_bruc
                     ,:data_rottamaz_bruc
                     ,:marc_effic_energ
                     ,:campo_funzion_max
                     ,:campo_funzion_min
                     ,:dpr_660_96
                     ,:cod_tpco            -- dpr74
                     ,:cod_flre            -- dpr74
                     ,:carica_refrigerante -- dpr74
                     ,:sigillatura_carica  -- dpr74
                     ,:cod_mode            -- nic01
                     ,:cod_mode_bruc       -- nic01
                     ,:cod_grup_term       -- san01
                     ,:num_circuiti        -- sim05
                     ,:num_prove_fumi      -- rom01
                     ,:per                 -- sim08
                     ,:cop                 -- sim08
                     ,:tipologia_cogenerazione    --gac02
                     ,:temp_h2o_uscita_min        --gac02
                     ,:temp_h2o_uscita_max        --gac02
                     ,:temp_h2o_ingresso_min      --gac02
                     ,:temp_h2o_ingresso_max      --gac02
                     ,:temp_h2o_motore_min        --gac02
                     ,:temp_h2o_motore_max        --gac02
                     ,:temp_fumi_valle_min        --gac02
                     ,:temp_fumi_valle_max        --gac02
                     ,:temp_fumi_monte_min        --gac02
                     ,:temp_fumi_monte_max        --gac02
                     ,:emissioni_monossido_co_max --gac02
                     ,:emissioni_monossido_co_min --gac02
              --rom12,funzione_grup_ter            --rom02
                     ,:flag_clima_invernale                --rom12
                     ,:flag_clim_est                --rom12
                     ,:flag_prod_acqua_calda            --rom12
                     ,:flag_altro                   --rom12
                     ,:funzione_grup_ter_note_altro --rom02
                     ,:flag_caldaia_comb_liquid     --rom02
                     ,:rend_ter_max                 --rom02
                     ,:rif_uni_10389                --gac03
                     ,:altro_rif                    --gac03
                     ,:altro_funz                   --rom04
                     ,:cod_installatore             --rom09bis
                     ,:sorgente_lato_esterno        --rom13
                     ,:fluido_lato_utenze           --rom13
                     ,:tel_alimentazione            --rom16
                     ,:gen_prog_old                 --sim11
		     )"

        #rom09bis    if {$coimtgen(regione) eq "MARCHE"} {#rom09 aggiunta if e contenuto
        #rom09bis	db_dml upd_aimp_inst "update coimaimp
        #rom09bis                                set cod_installatore    = :cod_installatore 
        #rom09bis                                  , data_mod            =  current_date
        #rom09bis                                  , utente              = :id_utente
        #rom09bis                              where cod_impianto        = :cod_impianto"
        #rom09bis   }
		    
		}
	    }
	
	    if {$funzione != "V"} {

		#se regione marche aggiorno il combustibile sull'impianto prendendo il primo
		#attivo (lo considero come il principale)
		if {$coimtgen(regione) eq "MARCHE"} {
		    if {[db_0or1row q "select cod_combustibile as cod_combustibile_imp
                                    from coimgend
                                   where cod_impianto=:cod_impianto
                                     and flag_attivo='S'
                                     and flag_sostituito = 'N'                        
                                order by gen_prog 
                                    limit 1"]} {

			set update_cod_comb ", cod_combustibile = :cod_combustibile_imp"
		    } else {
			set update_cod_comb ""
		    }
		} else {
		    set update_cod_comb ""
		}


		
		#sim07 tolto da qui il controllo sulla fascia di potenza

		# aggiorno il numero generatori
		db_dml upd_aimp_x "
                update coimaimp
                   set n_generatori = :count_gend
                     , data_mod     =  current_date
                     , utente       = :id_utente
                     $update_cod_comb
                 where cod_impianto = :cod_impianto"

		# aggiorno la potenza focolare dell'impianto
		if {![string equal $tot_pot_focolare_nom ""]} {
		    db_dml upd_aimp_potenza_x "
                    update coimaimp
                       set potenza      = :tot_pot_focolare_nom
                     where cod_impianto = :cod_impianto"
		}
	    
		# aggiorno la potenza utile dell'impianto
		if {![string equal $tot_pot_utile_nom ""]} {
		    db_dml upd_aimp_potenza_utile_x "
                    update coimaimp
                       set potenza_utile = :tot_pot_utile_nom
                     where cod_impianto  = :cod_impianto"
		}

		# aggiorno la fascia di potenza dell'impianto
		if {![string equal $tot_potenza_chk ""]} {
		    if {[db_0or1row sel_pote_cod_x "
                        select cod_potenza 
                          from coimpote
                         where :tot_potenza_chk between potenza_min and potenza_max
                           and flag_tipo_impianto = :flag_tipo_impianto --sim03
                        "] == 1
		    } {
			db_dml upd_aimp_potenza_x "
                        update coimaimp
                           set cod_potenza  = :cod_potenza
                         where cod_impianto = :cod_impianto"
		    }
		}
		
	    }
	    
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }
    
    if {$error_num > 0} {;#sim04
        ad_return_template
        return
    }

    set invio_mail_2 "N";#mat03
    set testo_mail_2 "";#mat03
    if {$coimtgen(regione) eq "MARCHE"} {#rom09 if e contenuto
	set cod_manutentore [iter_check_uten_manu $id_utente]
	if {$cod_manutentore ne ""} {
	    set cod_installatore_new $cod_installatore
	    set installatore_new     "$cognome_inst $nome_inst"

	    db_1row q "select coalesce(a.cod_installatore,'')             as cod_installatore_old
                            , coalesce(i.cognome,'')||coalesce(i.nome,'') as installatore_old 
                            , (select coalesce(m.cognome,'')||coalesce(m.nome,'') 
                                 from coimmanu m
                                where m.cod_manutentore = :cod_manutentore) as denominazione_manutentore
                         from coimgend a --rom09bis
                         left outer join coimmanu i  on i.cod_manutentore = a.cod_installatore
                        where a.cod_impianto = :cod_impianto 
                          and a.gen_prog     = :gen_prog --rom09bis"
	    set testo_mail ""

	    if {$funzione eq "M" && $flag_attivo eq "S" && $flag_attivo_db ne "S" && [db_0or1row q "select 1
                                                                                                          from coimaimp
                                                                                                         where (stato = 'N' or stato = 'U')
                                                                                                           and cod_impianto = :cod_impianto
                                                                                                          limit 1"]} { #mat03 aggiunta if e contenuto

		set codice_impianto [db_string q "select cod_impianto_est from coimaimp where cod_impianto = :cod_impianto"]
		set invio_mail_2 "S"
		set testo_mail_2 "All'autorità competente si richiede l'attivazione dell'impianto $codice_impianto per inserimento RCEE."
	    }

	    if {$cod_installatore_new eq $cod_installatore_old} {
		set invio_mail "N"
	    } else {
		set codice_impianto [db_string q "select cod_impianto_est from coimaimp where cod_impianto = :cod_impianto"]
		set invio_mail "S"
		append testo_mail "ATTENZIONE: il Manutentore $denominazione_manutentore con codice $cod_manutentore ha modificato la \"Scheda 4.1: Dati del Gruppo Termico/Generatore\" del generatore numero $gen_prog_est dell'impianto con codice $codice_impianto.
"
		if {$cod_installatore_old eq "" && $cod_installatore_new ne ""} {
		    append testo_mail "E' stato aggiunto l'Installatore $installatore_new.
"
		}
		if {$cod_installatore_old ne "" && $cod_installatore_new eq ""} {
		    append testo_mail "Il vecchio Installatore $installatore_old &egrave; stato rimosso.
"
		}
		if {($cod_installatore_old ne "" && $cod_installatore_new ne "") && ($cod_installatore_old ne $cod_installatore_new)} {
		    append testo_mail "Il vecchio Installatore $installatore_old &egrave; stato cambiato con $installatore_new.
"
                }
		if {$funzione eq "M" && $matricola ne $matricola_old} { #mat03 aggiunta if e contenuto
		    append testo_mail "E' stata cambiata la matricola da $matricola_old a $matricola."
		}
		
	    }

	    if {$invio_mail eq "S" && $data_installaz >= "20180701"} {
		iter_get_coimdesc
		#proc per invio mail
		if {$coimtgen(ente) eq "PFM"} {#rom38 aggiunta if e suo contenuto
		    #rom38 La Provincia di Fermo ha problemi di ricezione delle mail
		    #rom38 quindi metto come mittente la mail di regione Marche
		    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "impiantitermici@regione.marche.it" -subject "Modifica Installatore ITER" -body $testo_mail
		} else {#rom38 Aggiunta else ma non il suo contenuto
		    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "$coimdesc(email)" -subject "Modifica Installatore ITER" -body $testo_mail
		};#rom38
	    }

	    if {$invio_mail_2 eq "S"} {#mat03 aggiunta if e contenuto
		iter_get_coimdesc
		#proc per invio mail
		if {$coimtgen(ente) eq "PFM"} {#rom38 aggiunta if e suo contenuto
		    #rom38 La Provincia di Fermo ha problemi di ricezione delle mail
		    #rom38 quindi metto come mittente la mail di regione Marche
		    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "impiantitermici@regione.marche.it" -subject "Richiesta attivazione impianto" -body $testo_mail_2
		} else {#rom38 Aggiunta else ma non il suo contenuto
		    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "$coimdesc(email)" -subject "Richiesta attivazione impianto" -body $testo_mail_2
		};#rom38
	    }
	}
    };#rom09 

    if {$data_costruz_gen >"20150926" && [db_0or1row q "select 1 
                                                          from coimcomb 
                                                         where cod_combustibile = :cod_combustibile 
                                                           and tipo in ('L' , 'G')"]} {#sim12 if e suo contenuto

	if {$tipo_foco eq "A" && $cod_emissione eq "C"} {
	    iter_get_coimdesc
	    set codice_impianto_mail [db_string q "select cod_impianto_est from coimaimp where cod_impianto = :cod_impianto"]
	    set invio_mail "S"
	    append testo_mail "ATTENZIONE: il generatore numero $gen_prog_est dell'impianto con codice $codice_impianto_mail è stato indicato con camera di combustione aperta e scarico fumi a camino collettivo."
	    if {$coimtgen(ente) eq "PFM"} {#rom41 aggiunta if ma non contenuto
		acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "impiantitermici@regione.marche.it" -subject "Modifica Generatore $gen_prog_est dell'impianto $codice_impianto_mail" -body $testo_mail
	    } else {#rom41 Aggiunta else e contenuto
		acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "$coimdesc(email)" -subject "Modifica Generatore $gen_prog_est dell'impianto $codice_impianto_mail" -body $testo_mail
	    }
	}
	

    }
    
    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I" || $funzione == "S"} {
        set last_gen_prog $gen_prog
    }
    set link_list      [subst $link_list_script]
    #gac08 aggiunto msg_cod_combustibile
    set link_gest      [export_url_vars cod_impianto gen_prog last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller msg_cod_combustibile]
    switch $funzione {
        M {set return_url   "coimgend-gest?funzione=V&$link_gest"}
        D {set return_url   "coimgend-list?$link_list"}
        I {set return_url   "coimgend-gest?funzione=V&$link_gest"}
        V {set return_url   "coimgend-list?$link_list"}
	S {set return_url   "coimgend-gest?funzione=V&$link_gest"}
    }
    set message "";#mat03
    if {$invio_mail_2 eq "S"} { #mat03 aggiunta if e contenuto
	set message "E' stata inviata all'ente la richiesta per la riattivazone dell'impianto."
    } 
    ad_returnredirect -message $message $return_url
    ad_script_abort
}

ad_return_template
