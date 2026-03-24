ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Adhoc
    @creation-date   18/03/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimaimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    ric01 06/11/2024 Rimosso classe ah-jquery-date ai campi data_ultima_dich e data_scad_dich se
    ric01            loggato come manutentore, non permetto la modifica delle date. (Ticket 11112)

    rom23 27/03/2024 Su richiesta di Salerno se un utente non manutentore sta mettendo l'impianto in stato
    rom23            Nonattivo, Annullato, Rottamato, ImpiantoChiuso, Respinto devo saltare i controlli sui campi obbligatori.

    but01 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid.

    sim20 14/06/2023 Se un amministratore di UCIT bypassava i controlli, veniva salvata la targa sull'impianto
    sim20            ma non veniva registrato l'utilizzo sul portale.
    sim20            Ora abbiamo fatto in modo che la registri sempre a meno che non superi i controlli sulla targa.

    rom22 22/02/2023 Regione Friuli ha richiesto che per gli utenti amministratori e dell'ente si saltino i controlli sui campi obbligatori.

    rom21 27/07/2022 Modifiche per allinemanto enti di ucit al nuovo cvs: i controlli sulle abilitazioni vengono fatti
    rom21            in base al parametro flag_controllo_abilitazioni.
    rom21            Sistemato link per forzare la targatura, andava in errore se nei vari paramaetri
    rom21            era presente un apice.

    rom20 30/11/2022 Corretta la query di controllo sull'associazione di una targa all'impianto:
    rom20            non teneva in considerazione solo l'impianto dove mi trovo e questo faceva saltare tutti i
    rom20            controlli sulle targhe perche' la targa poteva gia' essere associata ad un altro impianto.

    rom19 29/11/2022 Corretta anomalia per modifica di rom18, se si annullavano tutti i generatori per gli impianti del freddo
    rom19            il programma andava in errore perche' non trovava le potenze.

    rom18 22/11/2022 Corretta anomalia su potenze del freddo per Regione Marche: ci sono casi in cui le potenze del riscaldamento
    rom18            o raffrescamento sono nulle sul generatore e in questa schermata non devono dare messaggi di errore.

    mic03 08/07/2022 Corretto link per bonifica targa di mic01.

    mic02 07/07/2022 Su segnalazione di Sandro sono state inserite le query di ricalcolo delle potenze dalla coimgend all'inizio
    mic02            inizio del form is_valid; prima, infatti, ad ogni refresh della pagina venivano presi i valori dalla
    mic02            coimaimp mediante la query nel file postgresql, nella quale venivano estratti per targa e non per
    mic02            cod_impianto, il che generava strani incroci di valori in presenza di piu' impianti con la stessa targa.

    mic01 06/07/2022 Introdotta funzione di bonifica targa per Regione Marche: creato link bon_targa che punta a coimtarg-bon
    mic01            e aggiunto element refresh_targa. Da coimtarg-bon, alla conferma, viene restituito refresh_targa col
    mic01            valore 1 che fa entrare nella if di generazione della nuova targa.
    mic01            Aggiunta condizione su refresh_targa:
    mic01            quando si bonifica la targa non devo mostrare gli eventuali messaggi di errore
    mic01            sugli altri campi per evitare di generare dei buchi con la sequence coimaimp_est_s.
    
    rom17 20/05/2022 Coretta anomalia sul controllo della fascia di potenza che si presentava in
    rom17            alcuni casi per Regione Marche.
    rom17.1          Corretto intervento di rom17.
    
    rom16 04/05/2022 Su richiesta di Giuliodori fatta per mail "nuova nota campo ibrido e testo label" il 29/04
    rom16            modificata la label dal campo flag_ibrido per le Marche.

    rom15 27/04/2022 MEV Regione Marche per sistemi ibridi: dopo l'ennesima richiesta scritta di Giuliodori
    rom15            con mail "campo Ibrido/policombustibile/generatori misti: nota aggiornata" il 22 Apr 2022,
    rom15            Per Regione Marche il campo flag_ibrido e' sempre obbligatorio e aggiunta l'opzione
    rom15            "Nessun collegamento con altri impianti".
    
    rom14 20/04/2022 Modificato intervento di rom13 su richiesta di Regione Marche.

    rom13 22/03/2022 MEV Regione Marche per sistemi ibridi.

    rom12 10/02/2022 Corretto baco sul controllo delle targhe: se ho gia' la targa salvata sul db
    rom12            e in fase di modifica non la cambio, allora non devo richiamare il targhe-controllo.

    rom11 06/10/2021 Modificato intervento di sim19: il campo tipologia generatore veniva sbiancato
    rom11            anche per gli enti diversi dalle Marche e non si riusciva a cancellarlo.

    rom10 21/12/2020 Modifica per Regione Marche: aggiunto link "Inserisci" a fianco del campo
    rom10            targa che permette agli utenti non manutentori di inserire la targa sugli
    rom10            impianti che ne sono sprovvisti.

    rom09 25/11/2020 Corretto errore presente su impianti "sporchi" che non avevano il combustibile
    rom09            salvato sull'impianto.

    sim19 27/05/2020 In fase di cancellazione il campo Tipologia Generatore essendo una combo disabled
    sim19            veniva sbiancato e perdeva il suo valore.Idem per il campo Ibrido
    sim19            Questo faceva comparire un messaggio di errore. Ora è stato corretto
    sim19            Corretto anche il controllo sul flag_ibrido in caso Tipologia Generatore=Altro che
    sim19            va fatto solo per il caldo.

    sim18 06/04/2020 Se l'impianto è da validare, l'ente può modificare la pagina saltando i controlli
    sim18            in modo da poter inserire le note
    
    sim17 02/12/2019 Se un utente amministratore modifica una targa, deve in automatico bypassare i controlli

    gac06 25/11/2019 Le autorità competenti, per gli impianti del caldo, potranno visualizzare la
    gac06            tendina "Combustibile" con tutti i combustibili del caldo.
    gac06            Se si seleziona un tipo combustibile diverso dal combustibile precedente uscirà
    gac06            un warning non bloccante.

    gac05 25/11/2019 Le autorità competenti, viste le numerose segnalazioni derivanti da una non
    gac05            corretta gestione delle targhe pregresse, potranno modificare le targhe
    gac05            selezionando quelli tra quelle già presenti. 

    sim16 31/10/2019 Corretto visualizzazione del nome dell'ubicazione nel caso di un ente della provincia

    sim15 16/09/2019 Corretto errore su tipologia impianto che veniva sbiancata

    sim14 02/07/2019 Corretto errore sulle query dei combustibili che utilizzavano la descrizione e non
    sim14            il codice

    rom01 09/05/2019 Sviluppi per la BAT: aggiunti controlli che non permettono ad un manutentore
    rom01            di operare sulle tipologie d'Impianto su cui non e' abilitato.
    rom01            Ora la selezione del combustibile non e' piu' libera come prima ma va in base
    rom01            alla tipologia dell'impinato; questa modifica non valwe per le Marche perche'
    rom01            loro hannpo il campo non editabile e che viene preso in automatico.
    
    rom08 18/02/2019 Per le marche metto i campi cod_impianto_est, n_generatori, targa, potenza_utile,
    rom08            potenza, cod_combustibile e descr_potenza in readonly.
    rom08            Richiesta fatta dalla Regione nella call del 18/02/2019.

    rom07 07/01/2018 Aggiunte le options CLINV+PRACS, CLEST+CLINV, CLEST+CLINV+PRACS, CLEST+PRACS sul campo
    rom07            integrazione_per, Sandro ha detto che vanno bene per tutti gli enti

    gac04 17/12/2018 Nascosto campi data installazione e data costruzione, eliminato controllo sul valore
    gac04            massimo del campo superficie integrazione, fatto in modo che la options della tipologia
    gac04            generatore fosse congruo alla tipologia di impianto.

    rom06 21/11/2018 Per le Marche il campo cod_cted è stato messo in sola visualizzazione, è stato
    rom06            spostato in coimaimp-ubic. Spostati anche i campi "Data dismissione/Disattivazione",
    rom06            "Data dell'eventuale riattivazione" e "Stato" nella scheda 1.bis solo per le Marche.

    rom05 18/10/2018 Su richiesta delle Marche portati tutti i campi della scheda 1.2 
    rom05            Per ora li metto solo in visualizzazione e li faccio vedere solo alle Marche.

    rom04 07/08/2018 Aggiunto controllo sul campo altra_tipologia_generatore: può essere valorizzata solo
    rom04            se si seleziona la voce "Altro" in tipologia_generatore. 
    rom04.bis        Aggiunto nuovo campo flag_ibrido

    gac03 29/06/2018 Aggiunti campi integrazione, superficie_integrazione, nota_altra_integrazione e
    gac03            pot_utile_integrazione
    
    rom03 18/06/2018 Aggiunto campo tipologia_intervento. Sandro ha detto che il campo è obbligatorio 
    rom03            se data_libretto è valorizzata.

    gac02 07/06/2018 Aggiunti campi tipologia_generatore e integrazione_per 

    rom02 24/05/2018 Solo per le Marche messo il campo cod_cted 'Cat. edificio' obbligatorio.
    rom02            Cambiata la dicitura 'Targa' in 'Codice Catasto/Targa'.

    rom01M 05/05/2018 Aggiunto nuovo campo data_libretto che è visibile solo per la Regione Marche.
    rom01M            Se il campo non è valorizzato nessun ente della Regione può stampare il Libretto.
    rom01M            Su richiesta di Simone resi invisibili i campi flag_dpr412, portata, tariffa e
    rom01M            marc_effic_energ per la Regione Marche. Tolto momentaneamente il controllo della 
    rom01M            gestione dell'assegnazione della targa al manutentore.
    rom01Mbis         Sandro ha detto di mettere il campo data_libretto obbligatorio

    gac01 05/03/2018 Aggiunto link "Stampa Targa" visibile solo se la targa non è vuota 
    
    sim13 11/03/2019 Implementato nic06 anche per Taranto 

    sim12 17/01/2018 Gestisco in maniera differente la chiamata per poter usare il webservice anche con https

    sim11 02/08/2017 Per il freddo il controllo sulle potenze andrà fatto sul nuovo campo pot_utile_nom_freddo

    gab05 26/07/2017 Nella tendina delle potenze mostro solo quelle della tipologia di impianto.

    gab04 25/07/2017 Se un impianto viene respinto l'ente deve inserire nelle note obbligatoriamente
    gab04            la motivazione.

    gab03 10/07/2017 Se il flag_verifica_impianti è t il manutentore potrà solo mandare l'impianto
    gab03            in stato Annullato e non potrà mai riattivarlo
    gab03            Se il flag_verifica_impianti è t l'amministratore avrà nella combo degli stati
    gab03            anche gli stati Da controllare e Respinto. 

    sim10 22/05/2017 Personaliz. per Comune di Jesi: ricodificare gli impianti come da Legge
    sim10            Reg. Marche CMJE.
    sim10            Per Comune di Senigalli: CMSE

    san01 27/04/2017 Le targhe devono essere inserite solo su impianti attivi

    gab02 12/04/2017 Personaliz. per Provincia di Ancona: ricodificare gli impianti come da Legge
    gab02            Reg. Marche PRAN.

    gab01 08/02/2017 Personaliz. per Comune di Ancona: ricodificare gli impianti come da Legge 
    gab01            Reg. Marche CMAN.

    sim09 17/10/2016 I manutentori dei 4 enti della Regione Calabria, esclusa la Provincia di
    sim09            Reggio Calabria, non possono modificare la data intallazione a meno che
    sim09            questa non sia nulla.

    nic06 14/10/2016 I manutentori dei 4 enti della Regione Calabria, esclusa la Provincia di
    nic06            Reggio Calabria, non possono modificare lo stato dell'impianto.

    nic05 14/10/2016 Per qualche giorno, la Regione Calabria vuole togliere il controllo di
    nic05            obbligatorieta' della targa.

    sim08 27/09/2016 Taranto ha il cod. impianto composto dalle ultime 3 cifre del codice istat
    sim08            + un progressivo

    sim07 19/09/2016 Gli utenti amministratori possono lasciare la targa vuota mentre per gli
    sim07            utenti manutentori e' obbligatoria.

    sim06 06/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim06            visualizzo il campo targa e non il cod impianto princ.

    sim05 09/05/2016 Per gli impianti del freddo il controllo sulla potenza va fatto sulla
    sim05            potenza maggiore tra quella di raffreddamento e quella di riscaldamento.
    sim05            Vedi commento in coimgend-gest.tcl per maggiori dettagli.

    nic04 12/02/2016 Gestito parametro coimtgen(flag_potenza)

    nic03 04/02/2016 Gestito coimtgen.lun_num_cod_impianto_est per regione MARCHE

    nic02 03/12/2015 Per la provincia di massa, il cod_impianto_est va costruito in modo
    nic02            particolare

    sim04 28/09/2015 Da ottobre 2015 gli enti della regione marche devono costruire il codice
    sim04            impianto con una sigla imposta dalla regione (es: CMPS) + un progressivo
    sim04            di 6 cifre.

    nic01 07/09/2015 Personaliz. per Comune e Provincia di Pesaro: controllo potenza_utile
    nic01            e non potenza. Modificata valorizzazione di cod_impianto_est_new.

    sim03 07/04/2015 Corretto il controllo

    sim02 14/11/2014 Aggiunta del link al programma del trattamento acqua.
    sim02            Sandro ha aggiunto i campi pres_certificazione e certificazione

    sim01 10/09/2014 Aggiunta del nuovo campo cod_impianto_princ
} {
    {cod_impianto      ""}
    {last_cod_impianto ""}
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {extra_par         ""}
    {url_list_aimp2    ""}
    {url_list_aimp     ""}
    {url_aimp          ""}
    {flag_assegnazione ""}
    {conferma_inco     ""}
    {f_data_libretto   ""}
    {f_cod_via         ""}
    {msg_cod_combustibile ""}
    {is_forza_targa_p  "f"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


# funzione = C --> copy
# funzione = A --> Assegnazione
switch $funzione {
    "V" {set lvl 1}
    "C" {set lvl 2}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "R" {set lvl 3}
    "D" {set lvl 4}
}

#preparo il link al programma per gestione trattamento acqua
set link_coim_tratt_acqua [export_url_vars cod_impianto nome_funz_caller url_aimp url_list_aimp]&nome_funz=impianti;#sim02

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
#set id_ruolo [db_string sel_ruolo "select id_ruolo from coimuten where id_utente = :id_utente"]

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-GEST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-GEST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-GEST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

# Controlla lo user
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

#rom21set id_ruolo [db_string sel_ruolo "select id_ruolo from coimuten where id_utente = :id_utente"]

db_1row query "select id_settore
                    , id_ruolo
                 from coimuten
                where id_utente = :id_utente";#rom21

# controllo se l'utente e' un manutentore
#sim09 spostato all'inizio
set cod_manutentore [iter_check_uten_manu $id_utente]
set cod_ispettore   [iter_check_uten_opve $id_utente];#rom21


# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {[string equal $url_aimp ""]} {
    set url_aimp [list [ad_conn url]?[export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2"]]
}

if {![string equal $url_list_aimp2 ""]} {
    set url_list_aimp $url_list_aimp2
}

if {$nome_funz_caller == [iter_get_nomefunz coimmai2-filter] && $url_list_aimp == ""} {
    set url_list_aimp  [list coimmai2-filter?[export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2 nome_funz"]&nome_funz=[iter_get_nomefunz coimmai2-filter]]
}

db_1row sel_inco "select count(*) as count_inco from coiminco where cod_impianto = :cod_impianto and stato in ('0', '1', '2', '3', '4')"
if {$count_inco > 0} {
    set flag_ins_inco "S"
} else {
    set flag_ins_inco "N"
}

#sim14 db_1row sel_cod_comb "select cod_combustibile as cod_tele from coimcomb where descr_comb = 'TELERISCALDAMENTO'"
#sim14 db_1row sel_cod_comb "select cod_combustibile as cod_pomp from coimcomb where descr_comb = 'POMPA DI CALORE'"
db_1row sel_cod_comb "select cod_combustibile as cod_tele from coimcomb where cod_combustibile='7'";#sim14
db_1row sel_cod_comb "select cod_combustibile as cod_pomp from coimcomb where cod_combustibile='88'";#sim14

set link_gest [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp caller]

set link_mai2 [export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2 nome_funz"]&nome_funz=mai2

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp $extra_par]
set dett_tab [iter_tab_form $cod_impianto]

set current_date      [iter_set_sysdate]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_dimp ""
set link_cimp ""
set link_resp ""
set link_ubic ""
set link_resp ""
set link_util ""
set link_ricodifica ""

set classe           "func-menu"
set titolo           "Impianto"
switch $funzione {
    M {set button_label "Conferma Modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
	set page_title   "Cancellazione $titolo"}
    I {set button_label "Conferma Inserimento"
	set page_title   "Inserimento $titolo"}
    K {set button_label "Conferma copia"
	set page_title   "Conferma copia $titolo"
	set classe       "func-sel"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"}
    R {set button_label "Conferma ricodifica"
	set page_title   "Visualizzazione $titolo"}
}

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
			  [list "javascript:window.close()" "Torna alla Gestione"] \
			  [list $url_list_aimp               "Lista Impianti"] \
			  "$page_title"]
}

iter_get_coimtgen
set valid_mod_h         $coimtgen(valid_mod_h)
set flag_cod_aimp_auto  $coimtgen(flag_cod_aimp_auto)
set flag_codifica_reg   $coimtgen(flag_codifica_reg)
set cod_imst_annu_manu  $coimtgen(cod_imst_annu_manu)
set max_gg_modimp       $coimtgen(max_gg_modimp)
set lun_num_cod_imp_est $coimtgen(lun_num_cod_imp_est);#nic03
set flag_gest_targa     $coimtgen(flag_gest_targa);#sim06
set flag_viario         $coimtgen(flag_viario)
set flag_ente           $coimtgen(flag_ente)
set cod_provincia       $coimtgen(cod_provincia)
set provincia           $coimtgen(sigla_prov)
set cod_comune_ubic     $coimtgen(cod_comu)
if {$coimtgen(regione) eq "MARCHE"} {#rom05 if e contenuto

if {$flag_ente == "P"} {
	set cod_ente "P$cod_provincia"
    } else {
	set cod_ente "C$cod_comune_ubic"
    }
    set cod_dest_uso    ""
    set descr_dest_uso  ""
    db_1row q "select cod_cted
                 from coimaimp
                where cod_impianto = :cod_impianto"
    if {$cod_cted eq "E11a" ||
	$cod_cted eq "E11b" ||
	$cod_cted eq "E12"  ||
	$cod_cted eq "E13"} {
	set cod_dest_uso "A"
	set descr_dest_uso "Abitativo"
    } else {
	set cod_dest_uso "X"
	set descr_dest_uso "Altro"
    }
    set where_cod_tpdu "{{$descr_dest_uso} $cod_dest_uso}"
};#rom05

set cod_combustibile_contr [db_string q "select cod_combustibile from coimaimp where cod_impianto = :cod_impianto" -default ""]
    set tipo_comb [db_string q "select tipo
                                       from coimcomb
                                      where cod_combustibile = :cod_combustibile_contr" -default ""];#rom01
    set cod_coimtpin "";#rom01
    set descrizione_tpin "";#rom01


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp"
set focus_field  "";#rom13
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_cod "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set disabled_imp "disabled"
switch $funzione {
    "I" {
	set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set disabled_imp \{\}
        if {$flag_cod_aimp_auto == "F"
        ||  $coimtgen(ente) eq "PLI"
	} {
	    set readonly_cod \{\}
        }
    }
    "M" {
	set readonly_fld \{\}
        set disabled_fld \{\}
	set disabled_imp \{\}
        if {$coimtgen(ente) eq "PLI"} {
	    set readonly_cod \{\}
        }
    }
    "C" {
	set readonly_fld \{\}
        set disabled_fld \{\}
        if {$flag_cod_aimp_auto == "F"} {
	    set readonly_cod \{\}
        }
    }
}
if {![string equal $cod_impianto ""]} {
    set disabled_imp "disabled"
}

#sim06: la targa e' sempre readonly tranne quando e' vuota
set readonly_fld_targa "readonly";#sim06
if {$funzione ne "V"
&& [db_0or1row query "
    select 1 
      from coimaimp 
     where cod_impianto       = :cod_impianto 
       and coalesce(targa,'') = '' 
       and stato = 'A' --san01
     "]
} {#sim06: aggiunta if e suo contenuto
    set readonly_fld_targa \{\}
} else {#rom21 else e suo contenuto
set is_forza_targa_p "t"
}

if {$coimtgen(regione) eq "CALABRIA" && $coimtgen(ente) ne "PRC" && ![string equal $cod_manutentore ""]} {;#sim09 if e else e loro contenuto
    set readonly_dt_instal "readonly"
} else {
    set readonly_dt_instal $readonly_fld
}

if {$f_data_libretto eq "t"} {#rom01M if e contenuto
    element::set_error $form_name data_libretto "Inserire Data Intervento per poter stampare il libretto"
    element::set_error $form_name tipologia_intervento "Selezionare la Tipologia intervento per poter stampare il libretto"
    incr error_num
};#rom01M

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && ![string equal $cod_manutentore ""]} {#rom21 if else e loro contenuto
    set readonly_data_rottamaz "readonly"
} else {
    set readonly_data_rottamaz $readonly_fld
}


set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
    -html    $onsubmit_cmd

# Valorizzo il titolo in una variabile.
# In visualizzazion verra' valorizzata con un link.
set imp_provenienza "Imp. provenienza"
set html_cod_impianto_est $readonly_cod;#rom08
if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
    set html_cod_impianto_est $disabled_imp
}
element create $form_name cod_impianto_est \
    -label   "cod_impianto_est" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $html_cod_impianto_est {} class form_element" \
    -optional

if {$flag_gest_targa eq "F"} {#sim06: aggiunta if, else e contenuto dell'else
    element create $form_name cod_impianto_princ \
	-label   "Cod. Impianto principale" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
	-optional;#sim01

    element create $form_name targa -widget hidden -datatype text -optional;#sim02

} else {#sim06: aggiunta else e suo contenuto
    if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
	if {$cod_manutentore eq ""} {#gac05 aggiunta if else e contenuto di if
	    set readonly_fld_targa readonly
	} else {
	    set readonly_fld_targa $disabled_imp
	}
    }

    element create $form_name targa \
	-label   "Targa" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 16 $readonly_fld_targa {} class form_element tabindex 1" \
	-optional
    
    element create $form_name cod_impianto_princ -widget hidden -datatype text -optional

    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom21 Aggiunte if, else e il loro contenuto
	set label_targa "Targa"
    } else {
	set label_targa "Codice Catasto/Targa"
    }

} 

element create $form_name refresh_targa -widget hidden -datatype text -optional;#mic01

set bon_targa "";#mic01
if {($funzione == "I" || $funzione == "M") && $coimtgen(regione) eq "MARCHE" && $cod_manutentore eq ""} {#gac01 aggiunto if else e loro contenuto
    set cerca_targa  "[iter_search $form_name coimtarg-list [list dummy targa]] | "
    set testo_link "Gen. nuova targa";#mic01
    append bon_targa "[iter_search $form_name coimtarg-bon [list dummy targa] "" $testo_link] | ";#mic01
} else {
    set cerca_targa ""
}

element create $form_name cod_impianto_est_prov \
    -label   "cod impianto provenienza" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name provenienza_dati \
    -label   "provenienza_dati" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtppr cod_tppr descr_tppr]

set where_cod_combustibile "";#rom01
set label_combustibile "Combustibile";#rom01

if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom21 Aggiunta if ma non il suo contenuto
    
db_1row q "select flag_tipo_impianto from coimaimp where cod_impianto = :cod_impianto";#rom01
if {$flag_tipo_impianto eq "" || $flag_tipo_impianto eq "R"} {#rom01 aggiunte if, elseif e loro contenuto
    set where_cod_combustibile "where cod_combustibile not in ('7','20','88')"
} elseif {$flag_tipo_impianto eq "T"} {
    set where_cod_combustibile "where cod_combustibile='7'"
} elseif {$flag_tipo_impianto eq "C"} {
    set where_cod_combustibile "where cod_combustibile='20'"
} elseif {$flag_tipo_impianto eq "F"} {
    set label_combustibile "Alimentazione"
    set where_cod_combustibile "where cod_combustibile='88'"
};#rom01
if {$coimtgen(regione) eq "MARCHE"} {#rom07 aggiunta if, else e loro contenuto
    if {$cod_manutentore eq ""} {#gac06 aggiunta if else e contenuto di if
	set html_combustibile $disabled_fld
    } else {
	set html_combustibile $disabled_imp
    }
} else {
    set html_combustibile $disabled_fld
    set label_combustibile "Combustile"
};#rom07
} else {#rom21 Aggiunta else e il suo contenuto
    set html_combustibile $disabled_fld
    set label_combustibile "Combustile"
}

#rom01 Modificata -options, ora uso la proc iter_selbox_from_table_wherec con la condizione $where_cod_combustibile
#rom07 Modificato -html per le marche, loro hanno il campo non editabile.
element create $form_name cod_combustibile \
    -label   "cod_combustibile" \
    -widget   select \
    -datatype text \
    -html    "$html_combustibile {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimcomb cod_combustibile  descr_comb descr_comb "$where_cod_combustibile" ] 
    
set html_potenza $readonly_fld;#rom08
if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
    set html_potenza $disabled_imp
}
element create $form_name potenza \
    -label   "potenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $html_potenza {} class form_element" \
    -optional
set html_potenza_utile $readonly_fld;#rom08
if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
    set html_potenza_utile $disabled_imp
}

element create $form_name potenza_utile \
    -label   "potenza_utile" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $html_potenza_utile {} class form_element" \
    -optional

element create $form_name cod_tpim \
    -label   "tipologia" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtpim cod_tpim descr_tpim]

element create $form_name tariffa \
    -label   "tariffa" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{ } {{Riscald. superiore 100 kW} 03} {{Riscald.autonomo e acqua calda} 04} {{Riscald. centralizzato} 05} {{Riscald.central.piccoli condomini} 07}}

element create $form_name stato_conformita \
    -label   "stato_conformita" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {S&igrave; S} {No N}}

set cod_cted_html $disabled_fld;#rom06
if {$coimtgen(regione) eq "MARCHE"} {#rom06 if e contenuto
    set cod_cted_html "disabled"
}
element create $form_name cod_cted \
    -label   "cod_cted" \
    -widget   select \
    -datatype text \
    -html    "$cod_cted_html {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcted cod_cted "cod_cted||' '||descr_cted"] \

set html_n_generatori $readonly_fld;#rom08
if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
    set html_n_generatori $disabled_imp
}
element create $form_name n_generatori \
    -label   "n_generatori" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $html_n_generatori {} class form_element" \
    -optional

element create $form_name consumo_annuo \
    -label   "consumo_annuo" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 11 $readonly_fld {} class form_element" \
    -optional

#sim09 messo readonly_dt_instal al posto di readonly_fld
element create $form_name data_installaz \
    -label   "data_installaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_dt_instal {} class form_element $jq_date" \
    -optional

#rom21 messo readonly_data_rottamaz al posto di readonly_fld
element create $form_name data_rottamaz \
    -label   "data_rottamaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_data_rottamaz {} class form_element $jq_date" \
    -optional

element create $form_name data_attivaz \
    -label   "data_attivaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name flag_dichiarato \
    -label   "Flag dichiarazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options { {S&igrave; S} {No N} {N.C. C}}

element create $form_name data_prima_dich \
    -label   "data prima dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

if {$id_ruolo ==  "manutentore"} {
    #ric01 rimosso $jq_date nell'html
element create $form_name data_ultim_dich \
    -label   "data prima dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional
} else {
element create $form_name data_ultim_dich \
    -label   "data prima dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
}

if {$id_ruolo ==  "manutentore"} {
    #ric01 rimosso $jq_date nell'html
element create $form_name data_scad_dich \
    -label   "data scadenza dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element " \
    -optional
} else {
element create $form_name data_scad_dich \
    -label   "data scadenza dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
}


element create $form_name note \
    -label   "note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 70 rows 3 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_dpr412 \
    -label   "dpr 412" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {S&igrave; S} {No N}}

element create $form_name anno_costruzione \
    -label   "anno costruzione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name marc_effic_energ \
    -label   "marcatura efficienza energetica" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld {} class form_element" \
    -optional

element create $form_name volimetria_risc \
    -label   "Volimetria riscaldata" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_targa_stampata \
    -label   "targa stampata" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{S&igrave; S} {No N}}

element create $form_name portata \
    -label   "portata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name dati_scheda \
    -label   "Dati Scheda" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{No N} {Si S}}

element create $form_name data_scheda \
    -label   "Data Scheda" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name pres_certificazione \
    -label   "Pres. certificaz." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Sì S} {No N}}

element create $form_name certificazione \
    -label   "Certificazione" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional


set cerca_cod_impianto_princ [iter_search $form_name coimaimp-filter [list dummy dummy dummy dummy dummy dummy f_cod_impianto_est cod_impianto_princ]];#sim01

if {$flag_viario == "T"} {
    set indirizzo   [db_map sel_aimp_coimviae3]
    set coimviae    [db_map sel_aimp_coimviae1]
    set where_viae  [db_map sel_aimp_coimviae2]
} else {
    set indirizzo ", a.indirizzo as descr_via
                           , a.toponimo  as descr_topo"
    set coimviae   ""
    set where_viae ""
}

# inizializzo valore dropdown
if {[db_0or1row sel_aimp {}] == 0} {
    iter_return_complaint "Record non trovato"
}

set html_potenza "readonly";#rom08
if {$coimtgen(regione) eq "MARCHE"} {#rom08 if e contenuto
    set html_potenza $disabled_imp

    set cod_comune_display [db_string a "select denominazione from coimcomu where cod_comune=:cod_comune" -default ""];#sim16
    
}
if {$funzione != "M"} {
    element create $form_name descr_potenza \
	-label   "cod_potenza" \
	-widget   text \
	-datatype text \
	-html    "size 30 $html_potenza {} class form_element" \
	-optional
} else {
    #gab05 uso la proc iter_selbox_from_table_wherec
    #gab05 [iter_selbox_from_table coimpote cod_potenza descr_potenza potenza_min]
    element create $form_name cod_potenza \
	-label   "cod_potenza" \
	-widget   select \
	-datatype text \
	-html    "$html_potenza {} class form_element" \
	-optional \
	-options [iter_selbox_from_table_wherec coimpote cod_potenza descr_potenza potenza_min "where flag_tipo_impianto = '$flag_tipo_impianto'"]
}

set inserisci_targa "";#rom10
#gac01 aggiunto link stampa targa solo se la targa non è vuota
if {$targa ne ""} {
    set link_stampa_targa "<a href=\"print-qrcode-targa?targa=$targa&cod_impianto=$cod_impianto\" target=stampa>Stampa targa</a>"
} else {
    set link_stampa_targa ""

    if {$coimtgen(regione) eq "MARCHE" && $cod_manutentore eq ""} {#rom10 if e contenuto
	set inserisci_targa "<a href=\"coimaimp-inserisci-targa?funzione=$funzione&$link_gest\">Inserisci</a> |";#rom10
    }
}

#rom01M aggiunto campo data_libretto per la stampa del libretto della Regione Marche.
#rom01M Il libretto sarà stampabile solo se la data è valorizzata.
element create $form_name data_libretto \
    -label "data_libretto" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

#rom03
element create $form_name tipologia_intervento \
    -label    "tipologia_intervento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Nuova installazione" NUINS} {"Ristrutturazione" RISTR} {"Sostituzione del Generatore" SOSGE} {"Compilazione libretto impianto esistente" COLIE}} 

#gac04 aggiunta if else if e suo contenuto
if {$flag_tipo_impianto eq "R"} {
    set options_tipo_gen "{{} {}} {\"Generatore a combustione\" GCOMB} {Altro ALTRO}"
} elseif {$flag_tipo_impianto eq "F"} {
    #rom07set options_tipo_gen "{{} {}} {\"Pompa di calore\" PCALO} {\"Macchina frigorifera\" MFRIG} {Altro ALTRO}"
    set options_tipo_gen "{{} {}} {\"Pompa di calore\" PCALO} {\"Macchina frigorifera\" MFRIG}";#rom07 
} elseif {$flag_tipo_impianto eq "C"} {
    set options_tipo_gen "{{} {}} {\"Cogenerazione / trigenerazione\" COTRI} {Altro ALTRO}"
} elseif {$flag_tipo_impianto eq "T"} {
    set options_tipo_gen "{{} {}} {Teleriscaldamento TRISC} {Teleraffrescamento TRAFF} {Altro ALTRO}"
}
#vecchie options {"Generatore a combustione" GCOMB} {"Pompa di calore" PCALO} {"Macchina frigorifera" MFRIG} {Teleriscaldamento TRISC} {Teleraffrescamento TRAFF} {"Cogenerazione / trigenerazione" COTRI} {Altro ALTRO}
#gac04 aggiunto campi tipologia_generatore e integrazione per
element create $form_name tipologia_generatore \
    -label   "Tipologia Generatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_tipo_gen

element create $form_name altra_tipologia_generatore \
    -label   "Altro" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
    -optional

if {$coimtgen(regione) in [list "MARCHE"]} {#rom13 Aggiunte if, else e loro contenuto

    #Se sono gia' censito come impianto ibrido e ho almeno un altro impianto ibrido associato allora non devo poter cambiare il flag_ibrido.
    if {[db_0or1row q "select a.flag_ibrido as flag_ibrido_imp_princ_non_mod
                         from coimaimp a
                         left join coimaimp_ibrido i
                           on a.cod_impianto = i.cod_impianto_princ
                        where a.cod_impianto = :cod_impianto
                          and i.cod_impianto_princ = :cod_impianto
                        limit 1"]} {
	switch $flag_ibrido_imp_princ_non_mod {
	    "S" {set options_ibrido "{\"Sistema ibrido\" S}"}
	    "M" {set options_ibrido "{\"Generatori misti (con combustibili diversi)\" M}"}
	}
	#rom15 Regione Marche ha chiesto che il freddo sia trattato come il caldo
	#rom15 quindi ho cambiato le condizione dell'if e dell'elseif.
	if {$flag_tipo_impianto in [list "R" "F"]} {
	    #rom16set label_ibrido "Ibrido / Policombustibile / Generatori misti"
	    set label_ibrido "Ibrido / Policombustibile / Generatori misti /<font color=red>*</font><br>Nessun collegamento con altri impianti";#rom16
	} elseif {$flag_tipo_impianto eq "F" && 1 == 0} {
	    set label_ibrido "Ibrido / Policombustibile"
	} else {
	    set label_ibrido ""
	}
    } else {

	#rom14 Regione Marche ha chiesto che il freddo sia trattato come il caldo
	#rom14 quindi ho cambiato le condizione dell'if e dell'elseif.
	if {$flag_tipo_impianto in [list "R" "F"]} {

	    #rom15set options_ibrido "{{} {}} {\"Sistema ibrido\" S} {\"Unico generatore policombustibile\" P} {\"Generatori misti (con combustibili diversi)\" M}"
	    set options_ibrido "{{} {}} {\"Sistema ibrido\" S} {\"Unico generatore policombustibile\" P} {\"Generatori misti (con combustibili diversi)\" M} {\"Nessun collegamento con altri impianti\" N}";#rom15
	    #rom16set label_ibrido "Ibrido / Policombustibile / Generatori misti"
	    set label_ibrido "Ibrido / Policombustibile / Generatori misti /<font color=red>*</font><br>Nessun collegamento con altri impianti";#rom16
	    
	} elseif {$flag_tipo_impianto eq "F" && 1 == 0} {

	    set options_ibrido "{{} {}} {\"Sistema ibrido\" S} {\"Unico generatore policombustibile\" P}"
	    set label_ibrido "Ibrido / Policombustibile"
	    
	} else {
	    set options_ibrido "{{} {}}"
	    set label_ibrido ""
	}
	
    }

    set label_cod_impianto_ibrido       ""
    set label_cod_impianto_princ_ibrido ""
    set cod_impianto_ibrido             ""

    if {[db_0or1row q "select 1 from coimaimp_ibrido where cod_impianto_princ = :cod_impianto limit 1"]} {

	set label_cod_impianto_ibrido "Cod. impianto ibrido associato/i"
	set ls_impianti_ibridi_figlio [db_list q "select cod_impianto_ibrido 
                                                    from coimaimp_ibrido 
                                                   where cod_impianto_princ = :cod_impianto"]

	set ls_url_cod_impianto_ibrido [list]
	foreach  impianti_ibridi_figlio $ls_impianti_ibridi_figlio {

	    set link_cod_imp [export_url_vars nome_funz nome_funz_caller]
	    lappend ls_url_cod_impianto_ibrido "<a href=\"coimaimp-gest?cod_impianto=$impianti_ibridi_figlio&$link_cod_imp\">$impianti_ibridi_figlio</a>"

	}

	set cod_impianto_ibrido [join $ls_url_cod_impianto_ibrido " - "]
		
	element create $form_name cod_impianto_ibrido \
	    -label   "cod_impianto_ibrido" \
	    -widget   inform \
	    -datatype text \
	    -html    "size 20 maxlength 20 readonly {} class form_element" \
	    -optional
	
	element create $form_name cod_impianto_princ_ibrido -widget hidden -datatype text -optional

    } else {
	# In base all'impianto in cui mi trovo devo estrarre i cod_impianto che:
	# - Hanno la mia stessa targa
	# - Hanno il mio stesso flag_ibrido
	# - Non sono gia' associati ad altri impianti come impianti ibridi "figli"
	
    	set ls_impianti_padre [db_list_of_lists q "select padre.cod_impianto_est
                                                        , padre.cod_impianto 
                                                     from coimaimp as padre
                                                        , coimaimp as figlio
                                                    where padre.targa         = figlio.targa
                                                      and padre.cod_impianto != figlio.cod_impianto
                                                      and padre.flag_ibrido   = figlio.flag_ibrido
                                                      and figlio.cod_impianto = :cod_impianto
                                                      and padre.flag_ibrido  in ('S', 'M')
                                                      and padre.cod_impianto not in (select cod_impianto_ibrido
                                                                                       from coimaimp_ibrido
                                                                                      where cod_impianto_ibrido = padre.cod_impianto)
                                                    order by padre.cod_impianto_est"] 

	set ls_impianti_padre [linsert $ls_impianti_padre 0 [list "" ""]]

	#rom14set label_cod_impianto_princ_ibrido "Cod. impianto ibrido principale"
	set label_cod_impianto_princ_ibrido "Cod. impianto principale";#rom14
	
	set oc_cod_impianto_princ_ibrido "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_impianto_princ_ibrido';document.$form_name.submit.click()"
	element create $form_name cod_impianto_princ_ibrido \
	    -label   "cod_impianto_princ_ibrido" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element $oc_cod_impianto_princ_ibrido" \
	    -optional \
	    -options  $ls_impianti_padre \

	
	
	element create $form_name cod_impianto_ibrido -widget hidden -datatype text -optional
	    
    }
    
    element create $form_name is_regolazione_primaria_unica \
	-label   "Regolazione primaria (scheda 5.1)" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{Sì S} {No N}}
	
    element create $form_name is_coimaccu_aimp_unici \
	-label   "Sistemi di accumulo (scheda 8)" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{Sì S} {No N}}

    element create $form_name is_coimscam_calo_aimp_unici \
	-label   "Scambiatori di calore intermedi (scheda 9.3)" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{Sì S} {No N}}

    element create $form_name is_coimrecu_calo_aimp_unici \
	-label   "Recuperatori di calore (scheda 9.6)" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{Sì S} {No N}}
    
    set oc_flag_ibrido "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='flag_ibrido';document.$form_name.submit.click()"

} else {
    set options_ibrido "{{{} {}} {{S&igrave;} S} {{No} N}}"
    set label_ibrido "Ibrido"
    set oc_flag_ibrido ""

    element create $form_name cod_impianto_ibrido            -widget hidden -datatype text -optional
    element create $form_name cod_impianto_princ_ibrido      -widget hidden -datatype text -optional
    element create $form_name is_regolazione_primaria_unica -widget hidden -datatype text -optional
    element create $form_name is_coimaccu_aimp_unici        -widget hidden -datatype text -optional
    element create $form_name is_coimscam_calo_aimp_unici   -widget hidden -datatype text -optional
    element create $form_name is_coimrecu_calo_aimp_unici   -widget hidden -datatype text -optional
    
}

#rom04.bis aggiunto campo flag_ibrido, per ora è visibile solo sulle marche
element create $form_name flag_ibrido \
    -label   "ibrido" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element $oc_flag_ibrido" \
    -optional \
    -options $options_ibrido

#rom07 aggiunte le options CLINV+PRACS, CLEST+CLINV, CLEST+CLINV+PRACS, CLEST+PRACS
element create $form_name integrazione_per \
    -label   "Per" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Climatizzazione invernale" CLINV} {"Climatizzazione estiva" CLEST} {"Produzione acs" PRACS} {"Climatizzazioneinvernale + Produzione acs" CLINV+PRACS} {"Climatizzazione estiva + Climatizzazione invernale" CLEST+CLINV} {"Climatizzazione estiva + Climatizzazione invernale+ Produzione acs" CLEST+CLINV+PRACS} {"Climatizzazione estiva + Produzione acs" CLEST+PRACS}}

#gac03 aggiunto campi integrazione
element create $form_name integrazione \
    -label   "Integrazione con" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Pannelli solari termici superficie totale lorda" P} {Altro A}}

element create $form_name superficie_integrazione \
    -label   "Superficie" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name nota_altra_integrazione \
    -label   "Nota altra integrazione" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_utile_integrazione \
    -label   "Potenza utile (kW)" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 10 $readonly_fld {} class form_element" \
    -optional

#gab03
if {[string equal $cod_manutentore ""] && $coimtgen(flag_verifica_impianti) eq "t"} {;#gab03 aggiunta if else e contenuto
    set where_stat ""
} else {
    set where_stat "where cod_imst != 'F' and cod_imst != 'E'"
}

#gab03 set stato_options [iter_selbox_from_table coimimst cod_imst descr_imst cod_imst]
set stato_options [iter_selbox_from_table_wherec coimimst cod_imst descr_imst cod_imst $where_stat];#gab03
#calcolo la data entro cui posso annullare un impianto	
set max_hh_modimp [expr $max_gg_modimp * 24 ]
ns_log notice "Ore massime: $max_hh_modimp"
#aggiunta Luk : andava in errore perche' si aspettava di trovare la data valorizzata: ho messo una costante
if {[string equal $data_ins ""]} {
    set data_ins "27/03/2008"
}
#fine aggiunta Luk
set data_ins_check [iter_check_date $data_ins]
ns_log notice "Installazione impianto: $data_ins_check"
ns_log notice "Data installazione: $data_installaz"
set expireddate [clock scan "$max_hh_modimp hours" -base [clock scan [iter_check_date $data_ins]]]
set currentscandate [clock scan [iter_check_date $current_date]]
ns_log notice "Manutentore: $cod_manutentore"
ns_log notice "Data corrente: $currentscandate"
ns_log notice "Data scadenza: $expireddate"
if { ![string equal $cod_manutentore ""] && ($currentscandate > $expireddate) } {
    if {$coimtgen(flag_verifica_impianti) eq "f"} {;#gab03 aggiunta if
	set index 0
	set indextoremove 0
	foreach element $stato_options {
	    incr index
	    foreach elementinner $element {
		if [string equal $elementinner $cod_imst_annu_manu] { 
		    set indextoremove $index
		} 
	    }
	}

	#rom21	if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {}
	    # Richiesta di Ucit del 07/03/2013
#rom21	    set stato_options1 {{Attivo A} {Rottamato R} {Nonattivo N} }
#rom21	    set newList $stato_options1

	    #sim13 aggiunto condizione su Taranto
        if {($coimtgen(regione) eq "CALABRIA" && $coimtgen(ente) ne "PRC") || $coimtgen(ente) eq "PTA" || $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#nic06: aggiunta esleif e suo contenuto
	    # I manutentori dei 4 enti della Regione Calabria (esclusa la Provincia di Reggio
	    # Calabria) non possono modificare lo stato dell'impianto. Aggiunto anche Reggio il 18022020 da Sandro
	    if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	    } {
		set descr_imst ""
	    }
	    set newList [list [list $descr_imst $stato]];#nic06
	} else {
	    # Caso Standard
	    set newList [lreplace $stato_options [expr $indextoremove - 1] [expr $indextoremove - 1] ]
	}
	
    } else {
	#gab03 faccio vedere solo Annullato o solo Respinto o lo stato attuale (diverso da Annullato e Respinto) e Annullato
	if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	} {
	    set descr_imst ""
	}
	if {$stato eq "L" || $stato eq "E"} {
	    set newList [list [list $descr_imst $stato]]
	} else {
	    set newList [list [list $descr_imst $stato] [list "Annullato" "L"]]
	}
    }

} else { 
    if {$coimtgen(flag_verifica_impianti) eq "f"} {;#gab03 aggiunta if
	set newList $stato_options
    } else {;#gab03 aggiunta else e contenuto
	
	if {![string equal $cod_manutentore ""]} {
	    #gab03 faccio vedere solo Annullato o solo Respinto o lo stato attuale (diverso da Annullato e Respinto) e Annullato
	    if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	    } {
		set descr_imst ""
	    }
	    if {$stato eq "L" || $stato eq "E"} {
		set newList [list [list $descr_imst $stato]]
	    } else {
		set newList [list [list $descr_imst $stato] [list "Annullato" "L"]]
	    }
	    
	} else {
	    set newList $stato_options
	}
	
    }
}

element create $form_name stato \
    -label   "stato" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options $newList

if {$coimtgen(regione) eq "MARCHE"} {#rom05 aggiunta if e suo contenuto
    if {$flag_ente == "P"} {
	element create $form_name cod_comune_ubic \
	    -label   "Comune" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_imp {} class form_element" \
	    -optional \
	    -options [iter_selbox_from_comu]
    } else {
	element create $form_name cod_comune_ubic  -widget hidden -datatype text -optional  
	element create $form_name descr_comune \
	    -label   "Comune" \
	    -widget   text \
	    -datatype text \
	    -html    "$disabled_imp {} class form_element" \
	    -optional
	element set_properties $form_name cod_comune_ubic   -value $coimtgen(cod_comu)
	element set_properties $form_name descr_comune     -value $coimtgen(denom_comune)
    }

    #sim16 aggiunto cod_comune_display
    element create $form_name cod_comune_display \
	-label   "descr_comune" \
	-widget   text \
	-datatype text \
	-html    "disabled {} class form_element" \
	-value $cod_comune_display \
	-optional
    
    
    
    element create $form_name cod_qua \
	-label   "Quartiere" \
	-widget   select \
	-datatype text \
	-html    "$disabled_imp {} class form_element tabindex 4" \
	-optional \
	-options [iter_selbox_from_table coimcqua cod_qua descrizione]
    
    element create $form_name cod_urb \
	-label   "Unita urbana" \
	-widget   select \
	-datatype text \
	-html    "$disabled_imp {} class form_element" \
	-optional \
	-options [iter_selbox_from_curb]

    element create $form_name cod_tpdu \
	-label   "Destinazione d'uso" \
	-widget   select \
	-datatype text \
	-html    "$disabled_imp {} class form_element" \
	-optional \
	-options $where_cod_tpdu
    
    element create $form_name cap \
	-label   "cap" \
	-widget   text \
	-datatype text \
	-html    "size 5 maxlength 5 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name provincia \
	-label   "Prvincia" \
	-widget   text \
	-datatype text \
	-html    "size 2  2 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name numero \
	-label   "numero" \
	-widget   text \
	-datatype text \
	-html    "size 3 maxlength 8 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name esponente \
	-label   "esopnente" \
	-widget   text \
	-datatype text \
	-html    "size 2 maxlength 3 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name scala \
	-label   "scala" \
	-widget   text \
	-datatype text \
	-html    "size 2 maxlength 5 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name piano \
	-label   "paino"\
	-widget   text \
	-datatype text \
	-html    "size 2 maxlength 5 $disabled_imp {} class form_element" \
	-optional 
    
    element create $form_name interno \
	-label   "interno" \
	-widget   text \
	-datatype text \
	-html    "size 2 maxlength 3 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name descr_topo \
	-label   "toponimo" \
	-widget   text \
	-datatype text \
	-html    "size 5 maxlength 10 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name descr_via \
	-label   "via" \
	-widget   text \
	-datatype text \
	-html    "size 27 maxlength 80 $disabled_imp {} class form_element" \
-optional \
#but01 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid
    element create $form_name data_variaz \
	-label   "data_variaz" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $disabled_imp {} class form_element $jq_date" \
	-optional
    
    if {$funzione == "M"
	|| $funzione == "D"} {
	element create $form_name data_ini_valid \
	    -label   "data_ini_valid" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 maxlength 10 $disabled_imp {} class form_element $jq_date" \
	    -optional
    }
    
    element create $form_name gb_x \
	-label   "coordinate longitudine" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 50 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name gb_y \
	-label   "coordinate latitudine" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 50 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name foglio \
	-label   "foglio" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name mappale \
	-label   "mappale" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name subalterno \
	-label   "subalterno" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $disabled_imp {} class form_element" \
	-optional
    
    element create $form_name denominatore \
	-label   "denominatore" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $disabled_imp {} class form_element" \
	-optional

    element create $form_name cat_catastale \
	-label   "Cat.Catastale" \
	-widget   select \
	-datatype text \
	-html    "$disabled_imp {} class form_element" \
	-options { { } {{Catasto Terreni} CT} {{Catasto Fabbricati} CF} } \
	-optional
    
    element create $form_name sezione \
	-label    "Sezione" \
	-widget    text \
	-datatype text \
	-html    "size 20 maxlength 20 $disabled_imp {} class form_element" \
	-optional

    element create $form_name localita \
	-label   "localita" \
	-widget   text \
	-datatype text \
	-html    "size 40 maxlength 40 $disabled_imp {} class form_element" \
	-optional
element create $form_name f_cod_via     -widget hidden -datatype text -optional
};#rom05

# fine inizializzazione drop down

element create $form_name dummy            -widget hidden -datatype text -optional;#sim01
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name cod_comune       -widget hidden -datatype text -optional
element create $form_name cod_istat        -widget hidden -datatype text -optional
element create $form_name __refreshing_p   -widget hidden -datatype text -optional;#rom13
element create $form_name changed_field    -widget hidden -datatype text -optional;#rom13

if {$funzione == "C"
    && $flag_ins_inco == "S"}  {
    element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit" -html "onclick conferma_copia_impianto()"
} else {
    element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
}

element create $form_name last_cod_impianto -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name scaduto       -widget hidden -datatype text -optional
element create $form_name dpr412        -widget hidden -datatype text -optional
element create $form_name desc_conf     -widget hidden -datatype text -optional
element create $form_name conferma_inco -widget hidden -datatype text -optional -html "id conferma_inco"
if {$funzione != "M"} {
    element create $form_name cod_potenza  -widget hidden -datatype text -optional
}
if {$funzione != "I"} {
    if {[db_0or1row sel_aimp_stato ""] == 0} {
	set stato ""
    }
    #gab03 aggiunto colore al nuovo stato E
    #rom21 messo il grigio sullo stato U-ImpiantoChiuso e #cd853f sullo stato R-Rottamato
    switch $stato {
	"A"     {set color "green"}
	"D"     {set color "yellow"}
	"L"     {set color "red"}
	"N"     {set color "black"}
	"R"     {set color "#cd853f"}
        "U"     {set color "gray"}
        "E"     {set color "red"}
	default {set color "gainsboro"}
    }
} else {
    set color "gainsboro"
}


if {[form is_request $form_name]} {
    element set_properties $form_name cod_impianto      -value $cod_impianto
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name conferma_inco     -value $conferma_inco 
    element set_properties $form_name __refreshing_p   -value 0;#rom13
    element set_properties $form_name changed_field    -value "";#rom13    

    if {$funzione == "I"} {
	# TODO: settare eventuali default!!
        set scaduto ""
    } else {
	# leggo riga
        if {[db_0or1row sel_aimp {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

	set id_ruolo [db_string sel_ruolo "select id_ruolo from coimuten where id_utente = :id_utente"]

	set link_ricodifica ""
	if {[string equal $flag_codifica_reg "T"]
	    &&  [string equal $id_ruolo "admin"]
	    && ![string equal $cod_comune ""] && ![string equal $cod_istat ""] && [string length $cod_impianto_est] != 15
	    && ((![string equal $potenza "0.00"] && ![string equal $potenza ""])
		||
		(![string equal $cod_potenza "0"] && ![string equal $cod_potenza ""])
		)
	    && ![string equal $cod_combustibile $cod_tele]
	    && ![string equal $cod_combustibile $cod_pomp]} {
	    set link_ricodifica "<a href=\"coimaimp-gest?funzione=R&$link_gest\">Ricodifica</a>"
	} else {
	    set link_ricodifica ""
	}

	if {$funzione == "C"} {
	    # nella funzione di copia, metto codice impianto vecchio in
	    # codice impianto di provenienza
	    set cod_impianto_prov $cod_impianto
	}

	if {[db_0or1row sel_aimp_prov ""] == 0} {
	    set cod_impianto_est_prov ""
	} else {
	    if {$funzione == "V"} {
		# se trovo l'impianto di provenienza, metto nel suo titolo
		# il link alla visualizzazione.
		# non passo il parametro url_aimp perche' conterrebbe
		# il link di ritorno alla visualizzazione dell'impianto nuovo.
		# uso javascript per posizionare e dimensionare la finestra
		set imp_provenienza "<a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest?cod_impianto=$cod_impianto_prov&[export_url_vars last_cod_impianto nome_funz nome_funz_caller extra_par caller url_list_aimp]', 'Impianto_di_provenienza', 'scrollbars=yes, resizable=yes, width=760, height=500').moveTo(12,1)\">Imp. provenienza</a>"
		# questo era il link senza javascript di giulio
		# set imp_provenienza "<a href=\"coimaimp-gest?cod_impianto=$cod_impianto_prov&[export_url_vars last_cod_impianto nome_funz nome_funz_caller extra_par caller url_list_aimp]\" target=\"Impianto di provenienza\">Imp.provenienza</a>"
	    }
	}
	if {$coimtgen(regione) ne "MARCHE"} {#rom08 le marche usano campi diversi rispetto agli altri enti, quindi devo fare controlli differenti
	    # reperisco il numero dei generatori, la somma della potenza focolare
	    # nominael e la somma della potenza utile nominale dai generatori e se 
	    # non corrispondono a quelle inseriti visualizzo un messaggio di errore
	    db_1row sel_count_generatori ""
	    if {$flag_tipo_impianto eq "F" } {;#sim05 aggiunto if e suo contenuto
		set tot_pot_utile_nom $tot_pot_utile_nom_freddo;#sim11
		if {$tot_pot_focolare_lib > $tot_pot_focolare_nom} {
		    set tot_pot_focolare_nom $tot_pot_focolare_lib
		}
		
		if {$tot_pot_utile_lib > $tot_pot_utile_nom} {
		    set tot_pot_utile_nom $tot_pot_utile_lib
		}
	    }
	    if {$count_generatori != $n_generatori} {
		if {$flag_tipo_impianto eq "R"} {#rom07 aggiunta if ma non contenuto
		    element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza<br>generatori, Inserire i<br>generatori mancanti su<br>Scheda 4/4.1bis ($count_generatori)</b></font>"
		}
		if {$flag_tipo_impianto eq "F"} {#rom07 aggiunta if e contenuto
		    element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza<br>generatori, Inserire i<br>generatori mancanti su<br>Scheda 4.4 e 4.4bis ($count_generatori)</b></font>"
		};#rom07
		if {$flag_tipo_impianto eq "T"} {#rom07 aggiunta if e contenuto
		    element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i Scambiatori di calore mancanti su Scheda 4.5 e 4.5bis ($count_generatori)</b></font>"
		}
		if {$flag_tipo_impianto eq "C"} {#rom07 aggiunta if e contenuto
		    element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i Cogeneratori mancanti su Scheda 4.6 e 4.6bis $count_generatori)</b></font>"
		} 
		if {[iter_check_num $potenza 2] != $tot_pot_focolare_nom} {
		    element::set_error $form_name potenza "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_utile_nom} {
		    element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_utile_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_focolare_lib} {
		    element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_lib 2])"
		}
	    }
	} else {#rom08 aggiunta else e suo contenuto: controllo su generatori e potenze delle marche
	    #le marche non hanno piu' la possibilita' di modificare le potenze, quindi gli mostro sempre la somma delle relative potenze prese dai generatori. I messaggi di errore non servono piu'
	    db_1row sel_count_generatori_marche ""
	    if {$count_generatori != $n_generatori} {
		if {$flag_tipo_impianto eq "R"} {
		    #element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i generatori mancanti su Scheda 4/4.1bis ($count_generatori)</b></font>"
		}
		if {$flag_tipo_impianto eq "F"} {
		    #element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i Gruppi frigo/Pompe di calore mancanti su Scheda 4.4 e 4.4bis ($count_generatori)</b></font>"
		}
		if {$flag_tipo_impianto eq "T"} {
		    #element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i Scambiatori di calore mancanti su Scheda 4.5 e 4.5bis ($count_generatori)</b></font>"
		}
		if {$flag_tipo_impianto eq "C"} {
		    #element::set_error $form_name n_generatori "<font color=red><b>Attenzione: Incongruenza generatori, Inserire i Cogeneratori mancanti su Scheda 4.6 e 4.6bis $count_generatori)</b></font>"
		}
	    } 
	    if {$flag_tipo_impianto eq "R"} {
		if {[iter_check_num $potenza 2] != $tot_pot_utile_nom} {
		    #element::set_error $form_name potenza "Incongruenza generatori (kW [iter_edit_num $tot_pot_utile_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_focolare_nom} {
		    #element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
	    }
	    if {$flag_tipo_impianto eq "F"} {
		if {[iter_check_num $potenza 2] != $tot_pot_focolare_nom} {
		    #element::set_error $form_name potenza "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_focolare_lib} {
		    #element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_lib 2])"
		}
	    }
	    if {$flag_tipo_impianto eq "T"} {
		if {[iter_check_num $potenza 2] != $tot_pot_utile_nom} {
		    #element::set_error $form_name potenza "Incongruenza generatori (kW [iter_edit_num $tot_pot_utile_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_focolare_nom} {
		    #element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
	    }
	    if {$flag_tipo_impianto eq "C"} {
		if {[iter_check_num $potenza 2] != $tot_pot_focolare_nom} {
		    #element::set_error $form_name potenza "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
		if {[iter_check_num $potenza_utile 2] != $tot_pot_focolare_nom} {
		    #element::set_error $form_name potenza_utile "Incongruenza generatori (kW [iter_edit_num $tot_pot_focolare_nom 2])"
		}
	    }
	};#rom08
	if {$flag_dichiarato == "S"} {
	    if {[iter_check_date $data_scad_dich] < [iter_set_sysdate]
                && ![string equal $data_scad_dich ""]} {
		set scaduto "<font color=red><b>Scaduto</b></font>"
	    } else {
		set scaduto ""
	    }
	} else {
	    set scaduto ""
	}
	
	if {$stato_conformita == "N"} {
	    set desc_conf "<font color=red><b>Conformit&agrave;</b></font>"
	} else {
	    set desc_conf "Conformit&agrave;"
	}

	switch $flag_dpr412 {
	    "S" {set dpr412 "<font color=green><b>Sottopon. D.P.R. 412 e succ.mod.</b></font>" }
	    "N" {set dpr412 "<font color=red><b>Sottopon. D.P.R. 412 e succ.mod.</b></font>" }
	    default {set dpr412 "<font color=black><b>Sottopon. D.P.R. 412 e succ.mod.</b></font>" }
	}

	if {$funzione == "C"} {
	    if {$flag_cod_aimp_auto == "F"} {
		db_1row sel_cod_aimp_est ""
	    } else {
		set cod_impianto_est ""
	    }
	    set stato "A"
	    if {![string equal $data_rottamaz ""]} {
		set data_installaz $data_rottamaz
	    }
	    set data_rottamaz ""
	}

	element set_properties $form_name dati_scheda      -value $dati_scheda
	element set_properties $form_name data_scheda      -value $data_scheda

	element set_properties $form_name data_rottamaz    -value $data_rottamaz
	element set_properties $form_name stato            -value $stato
	element set_properties $form_name desc_conf        -value $desc_conf
        element set_properties $form_name scaduto          -value $scaduto
        element set_properties $form_name dpr412           -value $dpr412
	element set_properties $form_name cod_impianto_est -value $cod_impianto_est
	element set_properties $form_name cod_impianto_princ    -value $cod_impianto_princ;#sim01
	element set_properties $form_name targa                 -value $targa;#sim06
	element set_properties $form_name refresh_targa                 -value 0; #mic01
        element set_properties $form_name cod_impianto_est_prov -value $cod_impianto_est_prov
        element set_properties $form_name cod_impianto     -value $cod_impianto
        element set_properties $form_name provenienza_dati -value $provenienza_dati
        element set_properties $form_name cod_combustibile -value $cod_combustibile
	if {$coimtgen(regione) ne "MARCHE"} {#rom08 aggiunta if, aggiunte elseif, else e loro contenuto
	    element set_properties $form_name potenza          -value $potenza
	    element set_properties $form_name potenza_utile    -value $potenza_utile
	} else {
	    if {$flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "C"} {
		db_1row q "select iter_edit_num(coalesce(sum(pot_utile_nom),'0.00'), 2) as potenza_utile
                                , iter_edit_num(coalesce(sum(pot_focolare_nom),'0.00'), 2) as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"
		element set_properties $form_name potenza          -value $potenza
		element set_properties $form_name potenza_utile    -value $potenza_utile
	    }
	    if {$flag_tipo_impianto eq "F"} {
		db_1row q "select iter_edit_num(coalesce(sum(pot_focolare_lib),null), 2) as potenza_utile
                                , iter_edit_num(coalesce(sum(pot_focolare_nom),null), 2) as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"
		element set_properties $form_name potenza       -value $potenza
		element set_properties $form_name potenza_utile -value $potenza_utile
	    }
	    if {$flag_tipo_impianto eq "T"} {
		db_1row q "select iter_edit_num(coalesce(sum(pot_focolare_nom),'0.00'), 2) as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"
		element set_properties $form_name potenza          -value $potenza
	    } 
	}
	element set_properties $form_name portata          -value $portata	
	if {$coimtgen(regione) eq "MARCHE"} {#rom08 aggiunta if e scuo contenuto
	    if {$flag_tipo_impianto ne "T"} {

		if {$flag_tipo_impianto eq "F" } {
		    
		    if {[string is space $potenza] && [string is space $potenza_utile]} {#rom19 Aggiunta if e contenuto
			set pot_maggiore 0
			#rom19 Trasformata if in elseif, non toccato il contenuto
		    } elseif {[string is space $potenza]} {#rom18 Aggiunte if, elseif e il loro contenuto
			
			set pot_maggiore [iter_check_num $potenza_utile 2]
		    } elseif {[string is space $potenza_utile]} {
			set pot_maggiore [iter_check_num $potenza 2]
		    } else {#rom18 Aggiunta else ma non il suo contenuto
			if {[iter_check_num $potenza 2] > [iter_check_num $potenza_utile 2] } {
			    set pot_maggiore [iter_check_num $potenza 2]
			} else {
			    set pot_maggiore [iter_check_num $potenza_utile 2]
			}
		    };#rom18
		    
		} else {
		
		    if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {
			set pot_maggiore [iter_check_num $potenza_utile 2]
		    } else {
			set pot_maggiore [iter_check_num $potenza 2]
		    }
		    
		}		
	    } else {
		set pot_maggiore [iter_check_num $potenza 2]
	    }
	    if {[db_0or1row q "select cod_potenza
                                   , descr_potenza 
                                from coimpote
                               where :pot_maggiore between potenza_min and potenza_max
                                 and flag_tipo_impianto = :flag_tipo_impianto"] == 0} {
		switch $flag_tipo_impianto {
		    R {
			set cod_potenza "0"
			set descr_potenza "POTENZA NON NOTA"
		    } F {
			set cod_potenza "FO"
			set descr_potenza "POTENZA NON NOTA"
		    } T {
			set cod_potenza "TO"
			set descr_potenza "POTENZA NON NOTA"
		    } C {
			set cod_potenza "CA"
			set cod_potenza "POTENZA DA 0 A 999 KW"
		    }
		}
	    }
	}
        if {$funzione != "M"} {
	    element set_properties $form_name descr_potenza -value $descr_potenza
        }
        element set_properties $form_name cod_potenza      -value $cod_potenza
        element set_properties $form_name cod_tpim         -value $cod_tpim

        element set_properties $form_name tariffa          -value $tariffa
	element set_properties $form_name stato_conformita -value $stato_conformita
        element set_properties $form_name cod_cted         -value $cod_cted
        element set_properties $form_name n_generatori     -value $n_generatori
        element set_properties $form_name consumo_annuo    -value $consumo_annuo
        element set_properties $form_name data_installaz   -value $data_installaz

	#sim09 se è un manutentore della regione calabria deve porter modifcare la data_intalaz se è nulla
	if {($funzione eq "M" || $funzione eq "I") && 
             $coimtgen(regione) eq "CALABRIA"      && 
             $coimtgen(ente)    ne "PRC"           && 
             $data_installaz    eq ""              && 
             ![string equal $cod_manutentore ""]} {;#sim09
	    element set_properties $form_name data_installaz -html    "size 10 maxlength 10 class form_element"
	}

        element set_properties $form_name data_attivaz     -value $data_attivaz
        element set_properties $form_name flag_dichiarato  -value $flag_dichiarato
        element set_properties $form_name data_prima_dich  -value $data_prima_dich

        element set_properties $form_name data_ultim_dich  -value $data_ultim_dich
        element set_properties $form_name data_scad_dich   -value $data_scad_dich
 
        element set_properties $form_name note             -value $note 
        element set_properties $form_name flag_dpr412      -value $flag_dpr412
	element set_properties $form_name anno_costruzione -value $anno_costruzione
	element set_properties $form_name marc_effic_energ -value $marc_effic_energ
        element set_properties $form_name volimetria_risc  -value $volimetria_risc
        element set_properties $form_name flag_targa_stampata  -value $flag_targa_stampata
        element set_properties $form_name cod_comune           -value $cod_comune
        element set_properties $form_name cod_istat            -value $cod_istat
        element set_properties $form_name pres_certificazione  -value $pres_certificazione
        element set_properties $form_name certificazione       -value $certificazione
	element set_properties $form_name data_libretto        -value $data_libretto ;#rom01M
	element set_properties $form_name tipologia_generatore -value $tipologia_generatore ;#gac02
	element set_properties $form_name integrazione_per     -value $integrazione_per     ;#gac02
	element set_properties $form_name altra_tipologia_generatore -value $altra_tipologia_generatore ;#gac02
	element set_properties $form_name tipologia_intervento -value $tipologia_intervento  ;#rom03
	element set_properties $form_name integrazione         -value $integrazione         ;#gac03
	element set_properties $form_name superficie_integrazione -value $superficie_integrazione ;#gac03
        element set_properties $form_name nota_altra_integrazione -value $nota_altra_integrazione ;#gac03
        element set_properties $form_name pot_utile_integrazione  -value $pot_utile_integrazione  ;#gac03
	element set_properties $form_name flag_ibrido             -value $flag_ibrido             ;#rom04.bis
	
	if {$coimtgen(regione) eq "MARCHE"} {#rom05 if e contenuto

	    if {![db_0or1row q "select cod_impianto_princ as cod_impianto_princ_ibrido
                                     , is_regolazione_primaria_unica
                                     , is_coimaccu_aimp_unici
                                     , is_coimscam_calo_aimp_unici
                                     , is_coimrecu_calo_aimp_unici
	                          from coimaimp_ibrido
	                         where cod_impianto_ibrido = :cod_impianto"]} {#rom13 Aggiunta if e il suo contenuto
		
		set cod_impianto_princ_ibrido      ""
		set is_regolazione_primaria_unica ""
		set is_coimaccu_aimp_unici        ""
		set is_coimscam_calo_aimp_unici   ""
		set is_coimrecu_calo_aimp_unici   ""
	    }

	    element set_properties $form_name cod_impianto_ibrido           -value $cod_impianto_ibrido          ;#rom13
	    element set_properties $form_name cod_impianto_princ_ibrido     -value $cod_impianto_princ_ibrido    ;#rom13
	    element set_properties $form_name is_regolazione_primaria_unica -value $is_regolazione_primaria_unica;#rom13
	    element set_properties $form_name is_coimaccu_aimp_unici        -value $is_coimaccu_aimp_unici       ;#rom13
	    element set_properties $form_name is_coimscam_calo_aimp_unici   -value $is_coimscam_calo_aimp_unici  ;#rom13
	    element set_properties $form_name is_coimrecu_calo_aimp_unici   -value $is_coimrecu_calo_aimp_unici  ;#rom13
	    element set_properties $form_name localita         -value $localita   
	    element set_properties $form_name descr_via        -value $descr_via
	    element set_properties $form_name descr_topo       -value $descr_topo
	    element set_properties $form_name numero           -value $numero
	    element set_properties $form_name esponente        -value $esponente
	    element set_properties $form_name scala            -value $scala  
	    element set_properties $form_name piano            -value $piano
	    element set_properties $form_name interno          -value $interno
	    element set_properties $form_name cod_comune_ubic  -value $cod_comune_ubic
	    element set_properties $form_name cod_qua          -value $cod_qua
	    element set_properties $form_name cod_urb          -value $cod_urb
	    element set_properties $form_name cap              -value $cap
	    element set_properties $form_name cod_tpdu         -value $cod_tpdu
	    #data_installazione
	    element set_properties $form_name data_variaz      -value $data_variaz
	    element set_properties $form_name f_cod_via        -value $cod_via
	    element set_properties $form_name gb_x             -value $gb_x
	    element set_properties $form_name gb_y             -value $gb_y
	    element set_properties $form_name foglio           -value $foglio
	    element set_properties $form_name mappale          -value $mappale
	    element set_properties $form_name subalterno       -value $subalterno
	    element set_properties $form_name denominatore     -value $denominatore
	    element set_properties $form_name cat_catastale    -value $cat_catastale
	    element set_properties $form_name sezione          -value $sezione;#rom01M
	    #recupero ultima variazione effettuata
	    db_1row ultima_mod ""
	    if {![string equal $data_variaz ""]} {
		element set_properties $form_name data_variaz  -value $data_variaz
	    }
	};#rom05

    }

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set __refreshing_p   [element::get_value $form_name __refreshing_p];#rom13
    set changed_field    [element::get_value $form_name changed_field];#rom13
    
    set dati_scheda      [string trim [element::get_value $form_name dati_scheda]]
    set data_scheda      [string trim [element::get_value $form_name data_scheda]]
    if {$coimtgen(regione) ne "MARCHE"} {#rom08 aggiunta if, aggiunta else e contenuto
	set cod_impianto_est [string trim [element::get_value $form_name cod_impianto_est]]
    } else {
	element set_properties $form_name cod_impianto_est -value $cod_impianto_est
    }
    set cod_impianto     [string trim [element::get_value $form_name cod_impianto]]
    set cod_impianto_princ    [string trim [element::get_value $form_name cod_impianto_princ]];#sim01
    if {$coimtgen(regione) ne "MARCHE"} {#rom08 aggiunta if, aggiunta else e contenuto
	set targa                 [string trim [element::get_value $form_name targa]];#sim06
    } else {
	if {$cod_manutentore eq ""} {#gac05 aggiunto if else e contenuto di if
	    set targa             [string trim [element::get_value $form_name targa]]
	} else {
	    element set_properties $form_name targa -value $targa
	}
    }
    set refresh_targa [string trim [element::get_value $form_name refresh_targa]];#mic01
    set cod_impianto_est_prov [string trim [element::get_value $form_name cod_impianto_est_prov]]
    set provenienza_dati [string trim [element::get_value $form_name provenienza_dati]]
    set stato            [string trim [element::get_value $form_name stato]]
    set cod_tpim         [string trim [element::get_value $form_name cod_tpim]]
    
    set tariffa          [string trim [element::get_value $form_name tariffa]]
    set stato_conformita [string trim [element::get_value $form_name stato_conformita]]
    if {$coimtgen(regione) eq "MARCHE"} {#rom06 aggiunta if e contenuto, aggiunta else ma non contenuto
	element set_properties $form_name cod_cted         -value $cod_cted
    } else {
    set cod_cted         [string trim [element::get_value $form_name cod_cted]]
    };#rom06
    set consumo_annuo    [string trim [element::get_value $form_name consumo_annuo]]
    if {$coimtgen(regione) ne "MARCHE"} {#rom08 aggiunta if, aggiunta else e contenuto
	set n_generatori     [string trim [element::get_value $form_name n_generatori]]
	set cod_combustibile [string trim [element::get_value $form_name cod_combustibile]]
	set potenza          [string trim [element::get_value $form_name potenza]]
	set potenza_utile    [string trim [element::get_value $form_name potenza_utile]]
	set cod_potenza      [string trim [element::get_value $form_name cod_potenza]]
    } else {
	element set_properties $form_name n_generatori     -value $n_generatori;#rom08
	if {$cod_manutentore eq ""} {#gac06 aggiunta if else e contenuto di if
	    set cod_combustibile [string trim [element::get_value $form_name cod_combustibile]]
	} else {
	    element set_properties $form_name cod_combustibile -value $cod_combustibile;#rom08
	}
	#mic02element set_properties $form_name potenza          -value $potenza;#rom08
	#mic02element set_properties $form_name potenza_utile    -value $potenza_utile;#rom08
	if {$flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "C"} {#mic02 aggiunta if e suo contenuto

	    db_1row q "select iter_edit_num(coalesce(sum(pot_utile_nom),'0.00'), 2)    as potenza_utile
                            , iter_edit_num(coalesce(sum(pot_focolare_nom),'0.00'), 2) as potenza
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo  = 'S'"
	    
	    element set_properties $form_name potenza          -value $potenza
	    element set_properties $form_name potenza_utile    -value $potenza_utile
	}
	if {$flag_tipo_impianto eq "F"} {#mic02 aggiunta if e suo contenuto

	    db_1row q "select iter_edit_num(coalesce(sum(pot_focolare_lib),null), 2) as potenza_utile
                            , iter_edit_num(coalesce(sum(pot_focolare_nom),null), 2) as potenza
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo  = 'S'"

	    element set_properties $form_name potenza       -value $potenza
	    element set_properties $form_name potenza_utile -value $potenza_utile
	}
	if {$flag_tipo_impianto eq "T"} {#mic02 aggiunta if e suo contenuto

	    db_1row q "select iter_edit_num(coalesce(sum(pot_focolare_nom),'0.00'), 2) as potenza
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo  = 'S'"

	    element set_properties $form_name potenza          -value $potenza
	}

	if {$flag_tipo_impianto ne "T"} {#mic02 aggiunta if e suo contenuto
	    
	    if {$flag_tipo_impianto eq "F" } {

		if {[string is space $potenza] && [string is space $potenza_utile]} {#rom19 Aggiunta if e contenuto
		    set pot_maggiore 0
		    #rom19 Trasformata if in elseif, non toccato il contenuto
		} elseif {[string is space $potenza]} {#rom18 Aggiunte if, elseif e il loro contenuto
		    set pot_maggiore [iter_check_num $potenza_utile 2]
		} elseif {[string is space $potenza_utile]} {
		    set pot_maggiore [iter_check_num $potenza 2]
		} else {#rom18 Aggiunta else ma non il suo contenuto
		    if {[iter_check_num $potenza 2] > [iter_check_num $potenza_utile 2] } {
			set pot_maggiore [iter_check_num $potenza 2]
		    } else {
			set pot_maggiore [iter_check_num $potenza_utile 2]
		    }
		};#rom18
		
	    } else {
		
		if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {
		    set pot_maggiore [iter_check_num $potenza_utile 2]
		} else {
		    set pot_maggiore [iter_check_num $potenza 2]
		}
		
	    }
	} else {
	    set pot_maggiore [iter_check_num $potenza 2]
	}

	if {[db_0or1row q "select cod_potenza
                                , descr_potenza
                             from coimpote
                            where :pot_maggiore between potenza_min and potenza_max
                              and flag_tipo_impianto = :flag_tipo_impianto"] == 0} {#mic02 aggiunta if e suo contenuto
	    switch $flag_tipo_impianto {
		R {
		    set cod_potenza "0"
		    set descr_potenza "POTENZA NON NOTA"
		} F {
		    set cod_potenza "FO"
		    set descr_potenza "POTENZA NON NOTA"
		} T {
		    set cod_potenza "TO"
		    set descr_potenza "POTENZA NON NOTA"
		} C {
		    set cod_potenza "CA"
		    set cod_potenza "POTENZA DA 0 A 999 KW"
		}
	    }
	}
	element set_properties $form_name cod_potenza      -value $cod_potenza;#rom08        
    };#rom08
    
    set portata          [string trim [element::get_value $form_name portata]]
    if {$funzione != "M"} {
	set descr_potenza [string trim [element::get_value $form_name descr_potenza]]
    }
    set data_installaz   [string trim [element::get_value $form_name data_installaz]]
    set data_rottamaz    [string trim [element::get_value $form_name data_rottamaz]]
    set data_attivaz     [string trim [element::get_value $form_name data_attivaz]]
    set flag_dichiarato  [string trim [element::get_value $form_name flag_dichiarato]]
    set data_prima_dich  [string trim [element::get_value $form_name data_prima_dich]]
    set data_ultim_dich  [string trim [element::get_value $form_name data_ultim_dich]]
    set data_scad_dich   [string trim [element::get_value $form_name data_scad_dich]]
    set note             [string trim [element::get_value $form_name note]]
    set scaduto          [string trim [element::get_value $form_name scaduto]]
    set dpr412           [string trim [element::get_value $form_name dpr412]]
    set desc_conf        [string trim [element::get_value $form_name desc_conf]]
    set flag_dpr412      [string trim [element::get_value $form_name flag_dpr412]]
    # controlli standard su numeri e date, per Ins ed Upd
    set anno_costruzione [string trim [element::get_value $form_name anno_costruzione]]
    set marc_effic_energ [string trim [element::get_value $form_name marc_effic_energ]]
    set volimetria_risc  [string trim [element::get_value $form_name volimetria_risc]]
    set flag_targa_stampata  [string trim [element::get_value $form_name flag_targa_stampata]]
    set pres_certificazione  [string trim [element::get_value $form_name pres_certificazione]]
    set certificazione       [string trim [element::get_value $form_name certificazione]]
    set data_libretto        [string trim [element::get_value $form_name data_libretto]];#rom01M
    set tipologia_generatore [string trim [element::get_value $form_name tipologia_generatore]];#gac02
    set integrazione_per     [string trim [element::get_value $form_name integrazione_per]];#gac02
    set altra_tipologia_generatore [string trim [element::get_value $form_name altra_tipologia_generatore]];#gac02
    set tipologia_intervento [string trim [element::get_value $form_name tipologia_intervento]];#rom03
    set integrazione         [string trim [element::get_value $form_name integrazione]];#gac03
    set superficie_integrazione [string trim [element::get_value $form_name superficie_integrazione]];#gac03
    set nota_altra_integrazione [string trim [element::get_value $form_name nota_altra_integrazione]];#gac03
    set pot_utile_integrazione  [string trim [element::get_value $form_name pot_utile_integrazione]];#gac03
    set flag_ibrido             [string trim [element::get_value $form_name flag_ibrido]];#rom04.bis
    if {$coimtgen(regione) eq "MARCHE"} {#rom05 if e contenuto
	set cod_impianto_ibrido           [string trim [element::get_value $form_name cod_impianto_ibrido]]          ;#rom13
	set cod_impianto_princ_ibrido     [string trim [element::get_value $form_name cod_impianto_princ_ibrido]]    ;#rom13
	set is_regolazione_primaria_unica [string trim [element::get_value $form_name is_regolazione_primaria_unica]];#rom13
	set is_coimaccu_aimp_unici        [string trim [element::get_value $form_name is_coimaccu_aimp_unici]]       ;#rom13
	set is_coimscam_calo_aimp_unici   [string trim [element::get_value $form_name is_coimscam_calo_aimp_unici]]  ;#rom13
	set is_coimrecu_calo_aimp_unici   [string trim [element::get_value $form_name is_coimrecu_calo_aimp_unici]]  ;#rom13
	#rom05 Visto che i campi sono in disabled facendo element::get_value perdevano il loro valore
	#rom05 se in modifica, dando la conferma, si veniva bloccati da un controllo.
	element set_properties $form_name localita         -value $localita   
	element set_properties $form_name descr_via        -value $descr_via
	element set_properties $form_name descr_topo       -value $descr_topo
	element set_properties $form_name numero           -value $numero
	element set_properties $form_name esponente        -value $esponente
	element set_properties $form_name scala            -value $scala  
	element set_properties $form_name piano            -value $piano
	element set_properties $form_name interno          -value $interno
	element set_properties $form_name cod_comune_ubic  -value $cod_comune_ubic
	element set_properties $form_name cod_qua          -value $cod_qua
	element set_properties $form_name cod_urb          -value $cod_urb
	element set_properties $form_name cap              -value $cap
	element set_properties $form_name cod_tpdu         -value $cod_tpdu
	element set_properties $form_name data_variaz      -value $data_variaz
	element set_properties $form_name f_cod_via        -value $cod_via
	element set_properties $form_name gb_x             -value $gb_x
	element set_properties $form_name gb_y             -value $gb_y
	element set_properties $form_name foglio           -value $foglio
	element set_properties $form_name mappale          -value $mappale
	element set_properties $form_name subalterno       -value $subalterno
	element set_properties $form_name denominatore     -value $denominatore
	element set_properties $form_name cat_catastale    -value $cat_catastale
	element set_properties $form_name sezione          -value $sezione;#rom01M
	element set_properties $form_name data_variaz  -value $data_variaz

#rom11	if {$funzione eq "D"} {#sim19 if e suo contenuto
#	    db_0or1row q "select tipologia_generatore
#                               , flag_ibrido 
#                            from coimaimp 
#                           where cod_impianto = :cod_impianto"
#	    element set_properties $form_name tipologia_generatore -value $tipologia_generatore
#	    element set_properties $form_name tipologia_generatore -value $flag_ibrido
#rom11	}

	
    };#rom05

    if {$funzione eq "D"} {#rom11 if e suo contenuto: spostata fuori dalla if per le marche.
	db_0or1row q "select tipologia_generatore
                           , flag_ibrido 
                        from coimaimp 
                       where cod_impianto = :cod_impianto"
	element set_properties $form_name tipologia_generatore -value $tipologia_generatore
	element set_properties $form_name tipologia_generatore -value $flag_ibrido
    }

    if {[string equal $__refreshing_p "1"]} {#rom13 Aggiunta if e il suo contenuto
	
	if {$changed_field eq "flag_ibrido"} {
	    set focus_field "$form_name.flag_ibrido"
	    set cod_impianto_princ_ibrido "" 
	}
	    set ls_impianti_padre [db_list_of_lists q "select padre.cod_impianto_est
                                                            , padre.cod_impianto 
                                                         from coimaimp as padre
                                                            , coimaimp as figlio
                                                        where padre.targa         = figlio.targa
                                                          and padre.cod_impianto != figlio.cod_impianto
                                                          and figlio.cod_impianto = :cod_impianto
                                                          and (   padre.flag_ibrido   = :flag_ibrido
                                                              and padre.flag_ibrido  in ('S', 'M')
                                                              )
                                                          and padre.cod_impianto  not in (select cod_impianto_ibrido
                                                                                            from coimaimp_ibrido
                                                                                       where cod_impianto_ibrido = padre.cod_impianto)
                                                        order by padre.cod_impianto_est"] 

	    set ls_impianti_padre [linsert $ls_impianti_padre 0 [list "" ""]]

	    element set_properties $form_name cod_impianto_princ_ibrido     -options $ls_impianti_padre	    
	    
	
	
	if {$changed_field eq "cod_impianto_princ_ibrido"} {
	    set focus_field "$form_name.cod_impianto_princ_ibrido"
	    element set_properties $form_name cod_impianto_princ_ibrido -value $cod_impianto_princ_ibrido
	}

#	element set_properties $form_name cod_impianto_princ_ibrido -options $ls_impianti_padre

	
	element set_properties $form_name __refreshing_p -value 0;#rom13
	element set_properties $form_name changed_field  -value "";#rom13

	ad_return_template;#rom13
	return
	
    }

    set error_num 0
    if {$funzione == "I" ||  $funzione == "M" || $funzione == "C"} {
	
	if {$stato eq "E" && $note eq ""} {;#gab04
	    element::set_error $form_name note "Se l'impianto è stato respinto, bisogna indicare la motivazione nelle note "
            incr error_num
	}
	if {$coimtgen(regione) ne "MARCHE"} {#rom01M aggiunta if
	    if {[string equal $flag_dpr412 ""]} {
		element::set_error $form_name flag_dpr412 "Inserire"
		incr error_num	    
	    }
	};#rom01M
	if {$flag_cod_aimp_auto == "F"} {
	    if {[string equal $cod_impianto_est ""]} {
		element::set_error $form_name cod_impianto_est "Inserire il codice impianto"
		incr error_num
	    } else {
		if {[db_0or1row check_aimp ""] == 1} {
		    element::set_error $form_name cod_impianto_est "Esiste gi&agrave; un altro impianto con questo codice"
		    incr error_num
		}
	    }
	}

        if {[string equal $data_installaz ""]} {
#gac04	    element::set_error $form_name data_installaz "Inserire Data inst."
#gac04	    incr error_num
	} else {
            set data_installaz [iter_check_date $data_installaz]
            if {$data_installaz == 0} {
#gac04           element::set_error $form_name data_installaz "Data installazione deve essere una data"
#gac04           incr error_num
            } else {
		if {$data_installaz > $current_date} {
#gac04		    element::set_error $form_name data_installaz "Data deve essere anteriore alla data odierna"
#gac04		    incr error_num
		}
	    }
        }
	
	if {[string equal $data_libretto ""]} {#rom01Mbis if e suo contenuto
	    element::set_error $form_name data_libretto "Data intervento deve essere valorizzata"
	    incr error_num
	}
        if {![string equal $data_libretto ""]} {#rom01M if e suo contenuto
	    set data_libretto [iter_check_date $data_libretto]
	    if {$data_libretto == 0} {
		element::set_error $form_name data_libretto "Data intervento deve essere deve essere una data valida"
		incr error_num
	    }
	    if {[string equal $tipologia_intervento ""]} {#rom03 if e suo contenuto
		element::set_error $form_name tipologia_intervento "Selezionare la Tipologia Intervento"
                incr error_num
            };#rom03
	};#rom01M

        if {![string equal $data_rottamaz ""]} {
            set data_rottamaz [iter_check_date $data_rottamaz]
            if {$data_rottamaz == 0} {
                element::set_error $form_name data_rottamaz "Data rottamazione deve essere una data"
                incr error_num
            } else {
		if {$data_rottamaz > $current_date} {
		    element::set_error $form_name data_rottamaz "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	    set stato "R"
        }
	
        set flag_potenza_ok "f"
        if {![string equal $potenza ""]} {
            set potenza [iter_check_num $potenza 2]
            if {$potenza == "Error"} {
                element::set_error $form_name potenza "numerico con al massimo 2 decimali"
                incr error_num
            } else {
		if {$potenza < "0.01"} {
		    element::set_error $form_name potenza "deve essere > di 0,00"
		    incr error_num
		}	
                if {[iter_set_double $potenza] >=  [expr pow(10,7)]
		    ||  [iter_set_double $potenza] <= -[expr pow(10,7)]} {
                    element::set_error $form_name potenza "deve essere < di 10.000.000"
                    incr error_num
                } else {
		    set flag_potenza_ok "t"
		}
                set potenza_tot $potenza
                
		if {$flag_potenza_ok == "t"
		    &&  [db_0or1row check_fascia_pote ""]== 0} {
		    element::set_error $form_name potenza "non &egrave; compresa in nessuna fascia"
		    incr error_num
		}           
            }
        }
        set flag_potenza_ok "f"
        if {[string equal $potenza_utile ""]} {
	    set potenza_utile 0
	} else {
            set potenza_utile [iter_check_num $potenza_utile 2]
            if {$potenza_utile == "Error"} {
                element::set_error $form_name potenza_utile "numerico con al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $potenza_utile] >=  [expr pow(10,7)]
		    ||  [iter_set_double $potenza_utile] <= -[expr pow(10,7)]} {
                    element::set_error $form_name potenza_utile "deve essere < di 10.000.000"
                    incr error_num
                } else {
		    set flag_potenza_ok "t"
		}
                set potenza_tot $potenza_utile
		if {$flag_potenza_ok == "t"
		    &&  [db_0or1row check_fascia_pote ""]== 0} {
		    element::set_error $form_name potenza_utile "non &egrave; compresa in nessuna fascia"
		    incr error_num
		}           
            }
        }
	if {$coimtgen(regione) ne "MARCHE"} {#rom01M aggiunta if
	    if {[string equal $portata ""]} {
		set portata 0
	    } else {
		set portata [iter_check_num $portata 2]
		if {$portata == "Error"} {
		    element::set_error $form_name portata "numerico con al massimo 2 decimali"
		    incr error_num
		} else {
		    if {[iter_set_double $portata] >=  [expr pow(10,7)]
			||  [iter_set_double $portata] <= -[expr pow(10,7)]} {
			element::set_error $form_name portata "deve essere < di 10.000.000"
			incr error_num
		    }
		}
	    }
	};#rom01M
	set sw_controlla_totenza_tot "f"
	#nic04 if {$coimtgen(regione) eq "MARCHE"}
	if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic04 (cambiata if)
	    if {![string equal $potenza_utile ""] && $potenza_utile != "Error"} {#nic01: aggiunta if ed il suo contenuto
		set sw_controlla_totenza_tot "t"
		set potenza_tot              $potenza_utile
		set nome_campo_potenza       potenza_utile
	    }

	    if {$coimtgen(regione) eq "MARCHE" && $flag_tipo_impianto eq "F"} {#rom17 Aggiunta if e il suo contenuto
		#Per il freddo devo considerare la maggiore tra la potenza in riscaldamento e in  raffrescamento
		#rom17.1set potenza_tot [db_string q "select greatest(:potenza_utile, :potenza)"]
		if {$potenza > $potenza_utile} {#rom17.1 Aggiunte if, else e loro contenuto
		    set potenza_tot $potenza
		    set nome_campo_potenza potenza
		} else {
		    set potenza_tot $potenza_utile
		    set nome_campo_potenza potenza_utile
		}
	    }
	    
	    if {$coimtgen(regione) eq "MARCHE" && $flag_tipo_impianto eq "T"} {#il teleriscldamento della regione non ha mai la potenza utile ma la potenza
		if {![string equal $potenza ""] && $potenza != "Error"} {
		    set sw_controlla_totenza_tot "t"
		    set potenza_tot              $potenza
		    set nome_campo_potenza       potenza
		}	    
	    }


	} else {#nic01
	    if {![string equal $potenza ""] && $potenza != "Error"} {
		set sw_controlla_totenza_tot "t"
		set potenza_tot              $potenza
		set nome_campo_potenza       potenza
	    }
	};#nic01

	
        if {$sw_controlla_totenza_tot eq "t"} {
	    if {![string equal $cod_potenza ""]} {
		if {[db_0or1row check_fascia_pote2 ""]== 0} {
		    element::set_error $form_name $nome_campo_potenza "non compresa nella fascia di potenza"
		    incr error_num
		}
	    } else {
		if {[db_0or1row assegna_fascia ""]==0} {
		    element::set_error $form_name $nome_campo_potenza "nessuna fascia disponibile"
		    incr error_num		
		}
	    }
	} else {
	    if {[string equal $cod_potenza ""]} {
		element::set_error $form_name potenza "inserire potenza o fascia"
		incr error_num
	    }
	}

	if {![string equal $cod_potenza ""] && [string equal $potenza ""]} {
	    if {[db_0or1row sel_pote ""] == 0} {
		set potenza 0
	    }
	}

        if {![string equal $n_generatori ""]} {
            set n_generatori [iter_check_num $n_generatori 0]
            if {$n_generatori == "Error"} {
                element::set_error $form_name n_generatori "deve essere numerico"
                incr error_num
	    }
	}

        if {[string equal $consumo_annuo ""]} {
	    set consumo_annuo 0
	} else {
            set consumo_annuo [iter_check_num $consumo_annuo 2]
            if {$consumo_annuo == "Error"} {
                element::set_error $form_name consumo_annuo "numerico con al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $consumo_annuo] >=  [expr pow(10,7)]
		    ||  [iter_set_double $consumo_annuo] <= -[expr pow(10,7)]} {
                    element::set_error $form_name consumo_annuo "deve essere < di 10.000.000"
                    incr error_num
		}
            }
        }

        if {![string equal $data_attivaz ""]} {
            set data_attivaz [iter_check_date $data_attivaz]
            if {$data_attivaz == 0} {
                element::set_error $form_name data_attivaz "Data attivazione deve essere una data"
                incr error_num
            } else {
		if {$data_attivaz > $current_date} {
		    element::set_error $form_name data_attivaz "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }
#rom06 commentato controllo perchè il campo è stato spostato in coimaimp-ubic, qua è in sola visualizzazione per le Marche
#rom06	if {$coimtgen(regione) eq "MARCHE" && [string equal $cod_cted ""]} {#rom02 aggiunta if e suo contenuto
#rom06	    element::set_error $form_name cod_cted "Inserire Categoria edificio"
#rom06	    incr error_num
#rom06	};#rom02

	set flag_data "S"
        if {[string equal $data_prima_dich ""]
	&&  [string equal $flag_dichiarato "S"]
	&& ![string equal $cod_combustibile "9"]
	&& ![string equal $cod_combustibile "8"]
	} {
            element::set_error $form_name data_prima_dich "Inserire data"
            incr error_num
	    set flag_data "N"
	}

	#        if {![string equal $data_prima_dich ""]
	#          &&[string equal $flag_dichiarato "N"]} {
	#            element::set_error $form_name data_prima_dich "Non inserire"
	#            incr error_num
	#	    set flag_data "N"
	#	}

	#sim06: Sandro ha detto che il manutentore non ha l'obbligatorieta' altrimenti non
	#       riuscirebbe a inserire la targa
        if {[string equal $data_ultim_dich  ""]
	&&  [string equal $flag_dichiarato  "S"]
	&& ![string equal $cod_combustibile "9"]
	&& ![string equal $cod_combustibile "8"]
	&&  $cod_manutentore eq ""
	} {
            element::set_error $form_name data_ultim_dich "Inserire data"
            incr error_num
	}

	#        if {![string equal $data_ultim_dich ""]
	#          &&[string equal $flag_dichiarato "N"]} {
	#            element::set_error $form_name data_ultim_dich "Non inserire"
	#            incr error_num
	#	}

	#sim06: Sandro ha detto che il manutentore non ha l'obbligatorieta' altrimenti non
	#       riuscirebbe a inserire la targa
        if {[string equal $data_scad_dich   ""]
	&&  [string equal $flag_dichiarato  "S"]
	&& ![string equal $cod_combustibile "9"]
	&& ![string equal $cod_combustibile "8"]
        && $cod_manutentore eq ""
	} {
            element::set_error $form_name data_scad_dich "Inserire data"
            incr error_num
	}

        if {![string equal $data_prima_dich ""]} {
            set data_prima_dich [iter_check_date $data_prima_dich]
            if {$data_prima_dich == 0} {
                element::set_error $form_name data_prima_dich "Data non corretta"
                incr error_num
		set flag_data "N"
            } else {
		if {$data_prima_dich > $current_date} {
		    element::set_error $form_name data_prima_dich "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $data_ultim_dich ""]} {
            set data_ultim_dich [iter_check_date $data_ultim_dich]
            if {$data_ultim_dich == 0} {
                element::set_error $form_name data_ultim_dich "Data non corretta"
                incr error_num
            } else {
		if {$data_ultim_dich > $current_date} {
		    element::set_error $form_name data_ultim_dich "Data deve essere anteriore alla data odierna"
		    incr error_num
		} else {
		    if {$flag_data == "S"
			&& $data_prima_dich > $data_ultim_dich} {
			element::set_error $form_name data_ultim_dich "Non minore di data inizio"
			incr error_num
		    }
		}
	    }
        }

        if {![string equal $data_scad_dich ""]} {
            set data_scad_dich [iter_check_date $data_scad_dich]
            if {$data_scad_dich == 0} {
                element::set_error $form_name data_scad_dich "Data non corretta"
                incr error_num
            }
        }

	if {![string equal $cod_impianto_est_prov ""]} {
	    #sim03 messo eq al posto di ==
	    #sim03 if {$cod_impianto_est == $cod_impianto_est_prov} 
            if {$cod_impianto_est eq $cod_impianto_est_prov} {
		element::set_error $form_name cod_impianto_est_prov "Impianto di provenienza non pu&ograve; essere lo stesso impianto"
                incr error_num
	    } else {
		# oltre al controllo con questa query preparo la variabile
		# cod_impianto_prov che verra' inserita
		if {[db_0or1row check_aimp_prov ""] == 0} {
		    element::set_error $form_name cod_impianto_est_prov "Impianto inesistente"
		    incr error_num
		}
	    }
	} else {
	    set cod_impianto_prov ""
	}


        if {$funzione       == "M"
        &&  $coimtgen(ente) == "PLI"
        } {
            if {[db_0or1row sel_aimp_cod_est_old ""] == 0} {
                set cod_impianto_est_old ""
            }
            if {$cod_impianto_est != $cod_impianto_est_old} {
                db_1row sel_aimp_check_cod_est ""
                if {$conta_cod_est >= 1} {
                    element::set_error $form_name cod_impianto_est "Il codice inserito esiste gi&agrave; sul database"
                    incr error_num
                }
            }
        }

        if {![string equal $anno_costruzione ""]} {
            set anno_costruzione [iter_check_date $anno_costruzione]
            if {$anno_costruzione == 0} {
#                element::set_error $form_name anno_costruzione "Data non corretta"
#                incr error_num
            } else {
		if {$anno_costruzione > $current_date} {
#		    element::set_error $form_name anno_costruzione "Data deve essere anteriore alla data odierna"
#		    incr error_num
		}
	    }
        }
	
        if {![string equal $data_scheda ""]} {
            set data_scheda [iter_check_date $data_scheda]
            if {$data_scheda == 0} {
                element::set_error $form_name data_scheda "Data non corretta"
                incr error_num
            }
        }

        if {[string equal $volimetria_risc ""]} {
	    set volimetria_risc 0
	} else {
            set volimetria_risc [iter_check_num $volimetria_risc 2]
            if {$volimetria_risc == "Error"} {
                element::set_error $form_name volimetria_risc "numerico con al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $volimetria_risc] >=  [expr pow(10,7)]
		    ||  [iter_set_double $volimetria_risc] <= -[expr pow(10,7)]} {
                    element::set_error $form_name volimetria_risc "deve essere < di 10.000.000"
                    incr error_num
		}
            }
        }
    }

    if {$funzione == "D"} {
        set message ""
	db_1row sel_count_dimp ""
	if {$count_dimp > 0} {
	    append message "<br>dei modelli RCEE correlati;"
            incr error_num
	}

	db_1row sel_count_cimp ""
	if {$count_cimp > 0} {
	    append message "<br>dei rapporti di verifica correlati;"
            incr error_num
	}

	db_1row sel_count_gend ""
	if {$count_gend > 0} {
	    append message "<br>dei generatori correlati;"            
	    incr error_num
	}

	db_1row sel_count_inco ""
	if {$count_inco > 0} {
	    append message "<br>degli appuntamenti predisposti;"
            incr error_num
	}
	db_1row sel_count_prvv ""
	if {$count_prvv > 0} {
	    append message "<br>dei provvedimenti correlati;"
            incr error_num
	}
	db_1row sel_count_movi ""
	if {$count_movi > 0} {
	    append message "<br>dei pagamenti correlati;"
            incr error_num
	}

	db_1row sel_count_todo ""
	if {$count_todo > 0} {
	    append message "<br>delle attivit&agrave; sospese correlate"
            incr error_num
	}

	db_1row sel_count_docu ""
	if {$count_docu > 0} {
	    append message "<br>dei documenti correlati"
	}

	if {![string equal $message ""]} {
	    set message "L'impianto non si pu&ograve; cancellare, sono presenti: $message"
	    element::set_error $form_name note $message
	}
    }

    if {$cod_impianto_princ ne ""} {#sim01
	# Questa query converte anche il valore di cod_impianto_princ da cod_impianto_est
	# a cod_impianto
	if {![db_0or1row sel_aimp_princ ""]} {#sim01
	    element::set_error $form_name cod_impianto_princ "<font color=red><b>Codice impianto non trovato</b></font>";#sim01
	    incr error_num;#sim01
	};#sim01
    };#sim01

#ROM21 RIPORTATI I CONTROLLI DELLE ABILITAZIONI PRIMA DEI CONTROLLI PER LE TARGHE!!!!
    if {$coimtgen(flag_controllo_abilitazioni)} {#rom21 aggiunta if ma non il suo contenuto
    set tipo_comb [db_string q "select tipo
                                  from coimcomb
                                 where cod_combustibile = :cod_combustibile" -default ""];#rom01
    set cod_coimtpin "";#rom01
    set descrizione_tpin "";#rom01


    if {$coimtgen(regione) ne "MARCHE" && $flag_tipo_impianto ne "" && $cod_combustibile ne "" && $cod_manutentore ne ""} {#rom01 if e suo co\ntenuto
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
	    
	    #rom21element::set_error $form_name cod_combustibile "Utente non abilitato per l'inserimento<br>di \"$descrizione_tpin\""
	    element::set_error $form_name cod_combustibile "Utente non abilitato per la modifica<br>di \"$descrizione_tpin\"";#rom21
	    incr error_num
	}
	
    };#rom01
    };#rom21
    
    set inserire_targa "t";#sim20
    #rom01M aggiunta condizione temporanea $coimtgen(regione) ne "MARCHE" 
    if {$flag_gest_targa eq "T" && $coimtgen(regione) ne "MARCHE"} {#sim06: aggiunta if e suo contenuto
	if {$targa eq ""} {
	    if {$cod_manutentore ne ""} {#sim07: ho aggiunto solo l'if
		#nic05 element::set_error $form_name targa "Inserire la Targa"
		#nic05 incr error_num

                if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom21 Aggiunta if e contenuto
                    element::set_error $form_name targa "Inserire la Targa"
                    incr error_num
                }

	    };#sim07
        } elseif {[db_0or1row q "select 1
                                   from coimaimp
                                  where targa = :targa 
                                    and cod_impianto = :cod_impianto --rom20
                          --rom20 limit 1 --mic01 "]} {#rom04 Aggiunta elseif e il suo contenuto

	    # Se ho gia' una targa a db e in fase di modifica non la tocco
	    # non devo fare il controllo della targa perche' nel tempo il
	    # manutentore potrebbe essere cambiato e il controllo sull'associazione
	    # della targa potrebbe mostrare un messaggio di errore.
	    
	} else {
	    
	    if {![string equal $cod_ispettore ""]} {#rom21 Aggiunta if e contenuto
		db_1row query "
                 select cod_portale
                   from coimopve
                  where cod_opve = :cod_ispettore"
		set programma_dyn_url "targhe-insp-controllo?targa=$targa&iter_code=$cod_portale"
		set msg_err_targa "Targa non associata al'ispettore"
	    } else {#rom21 Aggiunta else ma non il suo contenuto
		
		set cod_manutentore_targa ""
		if {$cod_manutentore ne ""} {
		    set cod_manutentore_targa $cod_manutentore
		} else {
		    db_1row query "
                 select cod_manutentore as cod_manutentore_targa
                   from coimaimp
                  where cod_impianto = :cod_impianto" 
		}
		
		if {$id_settore in [list "ente" "system"] && [string equal $id_ruolo "admin"]} {#rom21 Aggiunte if, else e il loro contenuto
		    set ctrl_targa_manu "f"
		    set msg_err_targa "Targa inesistente"
		} else {
		    set ctrl_targa_manu "t"
		    set msg_err_targa "Targa non associata al manutentore"		

		}
		
		set programma_dyn_url "targhe-controllo?targa=$targa&cod_manutentore=$cod_manutentore_targa&ctrl_targa_manu=$ctrl_targa_manu";#rom21
		
	    };#rom21
	    

	    set nome_db     [db_get_database]
	    set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale]
	    #rom21set dyn_url    "$url_portale/iter-portal/targhe/targhe-controllo?targa=$targa&cod_manutentore=$cod_manutentore_targa"
	    set dyn_url    "$url_portale/iter-portal/targhe/$programma_dyn_url";#rom21

	    set spool_dir     [iter_set_spool_dir];#sim12
	    set nome_file_tmp "httpget_wallet";#sim12
	    set nome_file_tmp [iter_temp_file_name $nome_file_tmp];#sim12
	    
	    set path_file_response "$spool_dir/${nome_file_tmp}-response.txt";#sim12
	    set path_file_trace    "$spool_dir/${nome_file_tmp}-trace.txt";#sim12

	    #sim12 aggiunto with_catch
	    with_catch msg_err_curl {
		exec curl \
		    -vs \
		    -k \
		    -X GET \
		    --connect-timeout 100 \
		    --trace-ascii $path_file_trace \
		    $dyn_url > $path_file_response
	    } {
		#Non e' un errmsg ma un debug
		ns_log Notice "coimaimp-gest;msg_err_curl:$msg_err_curl"
	    }
	    
	    set file_id   [open $path_file_response r];#sim12
	    fconfigure    $file_id -encoding utf-8;#sim12
	    set response  [read $file_id];#sim12

	    set risultato [string range $response 0 [expr [string first " " $response] - 1]]

	    #sim12 set data         [ad_httpget -url $dyn_url -timeout 100]
	    #sim12 array set result $data
	    #sim12 set risultato    [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    #sim20set inserire_targa "t"

	    if {$error_num >0} {#sim20 if e suo contenuto
		#se ho errori precedenti non potrò inserire la targa
		set inserire_targa "f"
	    }

	    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && ($id_settore in [list "ente" "system"] && [string equal $id_ruolo "admin"])} {#sim20 if e suo contenuto
		#se sono un amministratore di UCIT bypasso i controlli quindi posso inserire la targa
		set inserire_targa "t"
	    }


	    #	    if {$risultato != "OK"} {}
	    #rom01M per il momento tolgo il controllo della targa assegnata al manutentore alla regione Marche.
	    if {$risultato != "OK" && $coimtgen(regione) ne "MARCHE"} {#rom01M aggiunta if
		#rom21element::set_error $form_name targa "Targa non assegnata al manutentore"
		
		element::set_error $form_name targa "$msg_err_targa";#rom21
		set inserire_targa "f"
		incr error_num
	    } else {
		
		#sim12 set parte_2                   [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set parte_2                   [string range $response [expr [string first " " $response] + 1] end];#sim12
		set nome_db_utilizzo_targa    [string range $parte_2 0 [expr [string first " " $parte_2] - 1]]
		set parte_3                   [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
		set cod_impianto_caldo_targa  [string range $parte_3 0 [expr [string first " " $parte_3] - 1]]
		set cod_impianto_freddo_targa [string range $parte_3 [expr [string first " " $parte_3] + 1] end]

		regsub -all "{" $nome_db_utilizzo_targa    "" nome_db_utilizzo_targa
		regsub -all "}" $nome_db_utilizzo_targa    "" nome_db_utilizzo_targa
		regsub -all "{" $cod_impianto_caldo_targa  "" cod_impianto_caldo_targa
		regsub -all "}" $cod_impianto_caldo_targa  "" cod_impianto_caldo_targa
		regsub -all "{" $cod_impianto_freddo_targa "" cod_impianto_freddo_targa
		regsub -all "}" $cod_impianto_freddo_targa "" cod_impianto_freddo_targa

		if {$nome_db_utilizzo_targa != ""} {

		    #il campo targa era gia' stato associato all'impianto su cui opero
		    if {$cod_impianto eq $cod_impianto_caldo_targa || $cod_impianto eq $cod_impianto_freddo_targa} {
			set inserire_targa "f"
		    } else {

			#verifico che la targa sia usata su un impianto di questa istanza
			if {$nome_db_utilizzo_targa ne $nome_db} {
			    
			    #e' su un'altra istanza
			    set inserire_targa "f"
			    element::set_error $form_name targa "Targa già associata ad un impianto"
			    incr error_num

			} else {

			    #e' sulla medesima istanza

			    set cod_impianto_est_freddo ""
			    set cod_responsabile_freddo ""
			    set cod_comune_freddo       ""
			    set cod_via_freddo          ""
			    set numero_freddo           ""
			    set esponente_freddo        ""

			    set cod_impianto_est_caldo  ""
			    set cod_responsabile_caldo  ""
			    set cod_comune_caldo        ""
			    set cod_via_caldo           ""
			    set numero_caldo            ""
			    set esponente_caldo         ""

			    #ricavo i dati dell'eventuale impianto del freddo associato
			    db_0or1row query "
                                  select cod_impianto_est as cod_impianto_est_freddo
                                       , cod_responsabile as cod_responsabile_freddo 
                                       , cod_comune       as cod_comune_freddo
                                       , cod_via          as cod_via_freddo
                                       , numero           as numero_freddo
                                       , esponente        as esponente_freddo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_freddo_targa"

			    #ricavo i dati dell'eventuale impianto del caldo associato
			    db_0or1row query "
                                  select cod_impianto_est as cod_impianto_est_caldo
                                       , cod_responsabile as cod_responsabile_caldo
                                       , cod_comune       as cod_comune_caldo
                                       , cod_via          as cod_via_caldo
                                       , numero           as numero_caldo
                                       , esponente        as esponente_caldo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_caldo_targa"

			    #ricavo i dati dell'impianto su cui sto salvando
			    db_0or1row query "
                                  select cod_responsabile                            
                                       , cod_comune      
                                       , cod_via                            
                                       , numero           
                                       , esponente                           
                                    from coimaimp
                                   where cod_impianto = :cod_impianto"

			    #rom21 se sto forzando l'inesrimento salto questi controlli
			    if {$is_forza_targa_p eq "f"} {#rom21 aggiunto solo if

				set forza_targa_url [export_vars -base [ad_conn url] -entire_form -no_empty {{is_forza_targa_p t}}];#rom21
				set forza_targa_url [ad_quotehtml $forza_targa_url];#rom21
                                set forza_targa_url [string map {' &#39;} $forza_targa_url];#rom21
				
				#se lavoro su un impianto del freddo
				if {$flag_tipo_impianto eq "F" && $cod_impianto_freddo_targa ne ""} {
				    #ha gia' un impianto del freddo associato
				    
				    set inserire_targa "f"
				    element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_freddo"
				    
				    if {$cod_responsabile_freddo    eq $cod_responsabile
					&& $cod_comune_freddo       eq $cod_comune
					&& $cod_via_freddo          eq $cod_via
					&& $numero_freddo           eq $numero
					&& $esponente_freddo        eq $esponente} {#rom21 if e suo contenuto
                                        #permetto di forzare la targa solo se ho i medesimi dati
					element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_freddo. Se vuoi comunque forzare l'inserimento della targa premi <a href='$forza_targa_url'>QUI</a>"
				    }
				    incr error_num
				} else {

				    #la targa ha associato un impianto del caldo che non ha i medesimi dati ubicazione e resp del nostro
				    if {$cod_impianto_caldo_targa ne ""
					&& (   $cod_responsabile_caldo  ne $cod_responsabile
					       || $cod_comune_caldo        ne $cod_comune
					       || $cod_via_caldo           ne $cod_via
					       || $numero_caldo            ne $numero
					       || $esponente_caldo         ne $esponente
					       )
				    } {
					
					set inserire_targa "f"
					element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_caldo"
					incr error_num
				    }			    
				}
				
				#rom21 if {$flag_tipo_impianto eq "R" && $cod_impianto_caldo_targa ne ""} {}
				if {$flag_tipo_impianto ne "F"  && $cod_impianto_caldo_targa ne ""} {#sim21 modificato la if
				    set inserire_targa "f"
				    element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_caldo"

				    if {$cod_responsabile_caldo  eq $cod_responsabile
					&& $cod_comune_caldo        eq $cod_comune
					&& $cod_via_caldo           eq $cod_via
					&& $numero_caldo            eq $numero
					&& $esponente_caldo         eq $esponente} {#rom21 if e suo contenuto
					#permetto di forzare la targa solo se ho i medesimi dati
					element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_caldo. Se vuoi comunque forzare l'inserimento della targa premi <a href='$forza_targa_url'>QUI</a>"

				    }
				    incr error_num
				} else {
				
				    #la targa ha associato un impianto del freddo che non ha i medesimi dati ubicazione e resp del nostro
				    if {$cod_impianto_freddo_targa ne ""
					&& (   $cod_responsabile_freddo ne $cod_responsabile
					       || $cod_comune_freddo       ne $cod_comune
					       || $cod_via_freddo          ne $cod_via
					       || $numero_freddo           ne $numero
					       || $esponente_freddo        ne $esponente
					       )
				    } {
				    
					set inserire_targa "f"
					element::set_error $form_name targa "Targa gi&agrave; associata all'impianto $cod_impianto_est_freddo"
					incr error_num
				    }
				}
			    };#rom21
			}
		    }
		}

	    }

	    #aggiorno la targa
	    #sim20 tolto $error_num ==0. MI baso solo sul inserire_targa gestito sopra 
	    if {$inserire_targa eq "t"} {

#rom21		if {$flag_tipo_impianto eq "R"} {
		    set cod_impianto_targa $cod_impianto
#rom21		}

#rom21		if {$flag_tipo_impianto eq "F"} {
#rom21		    set cod_impianto_targa $cod_impianto
#rom21		}

		set dyn_url "$url_portale/iter-portal/targhe/targhe-associa?targa=$targa&nome_db_utilizzo=$nome_db&cod_impianto_targa=$cod_impianto_targa&flag_tipo_impianto=$flag_tipo_impianto"

			    #simone

		set spool_dir     [iter_set_spool_dir];#sim12
		set nome_file_tmp "httpget_wallet";#sim12
		set nome_file_tmp [iter_temp_file_name $nome_file_tmp];#sim12
		
		set path_file_response "$spool_dir/${nome_file_tmp}-response.txt";#sim12
		set path_file_trace    "$spool_dir/${nome_file_tmp}-trace.txt";#sim12
		
		#sim12 aggiunto with_catch
		with_catch msg_err_curl {
		    exec curl \
			-vs \
			-k \
			-X GET \
			--connect-timeout 100 \
			--trace-ascii $path_file_trace \
			$dyn_url > $path_file_response
		} {
		    #Non e' un errmsg ma un debug
		    ns_log Notice "coimaimp-gest;msg_err_curl:$msg_err_curl"
		}
	    
		set file_id   [open $path_file_response r];#sim12
		fconfigure    $file_id -encoding utf-8;#sim12
		set response  [read $file_id];#sim12
		
		#rom21 set risultato [string range $response 0 [expr [string first " " $response] - 1]]
		#rom21 la risposta del ws è solo OK senza altri dati. Come veniva letto prima non salva correttamente la
		#rom21 risposta e quindi poi non aggiornava la targa sull'impianto
		set risultato $response;#rom21

		#sim12 set data [ad_httpget -url $dyn_url -timeout 100]
		#sim12 array set result $data
		#set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
		#sim12 set risultato $result(page)

		if {$risultato ne "OK"} {
		    element::set_error $form_name targa "$risultato"
		    incr error_num
		}

	    }
	}
    }

#ROM21 Spostati i controlli delle abilitazioni prima dei controlli della targa.
#    set tipo_comb [db_string q "select tipo
#                                  from coimcomb
#                                 where cod_combustibile = :cod_combustibile" -default ""];#rom01
#    set cod_coimtpin "";#rom01
#    set descrizione_tpin "";#rom01
#
#
#    if {$coimtgen(regione) ne "MARCHE" && $flag_tipo_impianto ne "" && $cod_combustibile ne "" && $cod_manutentore ne ""} {#rom01 if e suo co\ntenuto
#	if {[db_0or1row q "select 1
#                             from coimtpin_abilitazioni
#                            where flag_tipo_impianto = :flag_tipo_impianto
#                              and tipo_combustibile is not null
#                            limit 1"]} {
#	    
#	    db_0or1row q "select a.cod_coimtpin
#                               , b.descrizione as descrizione_tpin
#                            from coimtpin_abilitazioni a
#                               , coimtpin b
#                           where a.flag_tipo_impianto = :flag_tipo_impianto
#                             and a.tipo_combustibile  = :tipo_comb
#                             and a.cod_coimtpin       = b.cod_coimtpin"
#	    
#	} else {
#	    
#	    db_0or1row q "select a.cod_coimtpin
#                               , b.descrizione as descrizione_tpin
#                            from coimtpin_abilitazioni a
#                               , coimtpin b
#                           where a.flag_tipo_impianto = :flag_tipo_impianto
#                             and a.cod_coimtpin = b.cod_coimtpin"
#	    
#	}
#
#	if {![db_0or1row q "select 1
#                              from coimtpin_manu
#                             where cod_coimtpin    = :cod_coimtpin
#                               and cod_manutentore = :cod_manutentore"]} {
#	    
#	    element::set_error $form_name cod_combustibile "Utente non abilitato per l'inserimento<br>di \"$descrizione_tpin\""
#	    incr error_num
#	}
#	
#    };#rom01   

    ###########
    
    #se tipologia_generatore è selezionato altro bisogna perforza scrivere qualcosa
    if {$tipologia_generatore eq ""} {
        element::set_error $form_name tipologia_generatore "Selezionare tipologia generatore"
        incr error_num
    }
    #mic02 Aggiunta condizione su Regione Marche
    if {$flag_ibrido eq "" && $flag_tipo_impianto in [list "R" "F"] && $coimtgen(regione) eq "MARCHE"} {#rom15 Aggiunta if e il suo contenuto
	element::set_error $form_name flag_ibrido "Campo obbligatorio."
	incr error_num
    }
    
    if {$tipologia_generatore ne ""} {#rom04
	if {$tipologia_generatore ne "ALTRO"} {
	    if {$altra_tipologia_generatore ne ""} {
		element::set_error $form_name altra_tipologia_generatore "Compilare solo se la \"Tipologia generatore\" &egrave; \"Altro\""
		incr error_num
	    }
	    if {$coimtgen(regione) eq "MARCHE"} {
		#rom14 Aggiunta condizione 1 == 0 perche' le Marche hanno chiesto che il flag_ibrido non sia vincolato dalla tipologia_generatore.
		if {$flag_ibrido ne "" && $flag_tipo_impianto eq "R" && 1 == 0} {#rom04.bis if e contenuto
		    element::set_error $form_name flag_ibrido "Compilare solo se la<br>\"Tipologia generatore\" &egrave; \"Altro\""
		    incr error_num
		}
	    }
	}
	if {$coimtgen(regione) eq "MARCHE"} {
	    if {$tipologia_generatore eq "ALTRO"} {
		#sim19 aggiunto condizione su flag_tipo_impianto
		if {$flag_ibrido eq "" && $flag_tipo_impianto eq "R"} {
		    #rom15element::set_error $form_name flag_ibrido "Indicare se &egrave; un Ibrido"
		    element::set_error $form_name flag_ibrido "Campo obbligatorio.";#rom15
		    incr error_num
		}
		if {$flag_ibrido eq "S" && $altra_tipologia_generatore ne "" } {
		    element::set_error $form_name altra_tipologia_generatore "Se &egrave; un Ibrido non compilare campo Altro"
		incr error_num
		}
		if {$flag_ibrido eq "N" && $altra_tipologia_generatore eq ""} {#rom04.bis if e contenuto
		    element::set_error $form_name altra_tipologia_generatore "Se non &egrave; un Ibrido compilare campo Altro"
		    incr error_num
		}
	    }
	}
    };#rom04
    
    #gac03 aggiunto controlli sull'integrazione
    #se si  seleziona pannelli solari bisogna perforza scrivere la superficie
    if {$integrazione eq "P" && $superficie_integrazione eq ""} {#gac03
        element::set_error $form_name superficie_integrazione "Compilare campo Superficie"
        incr error_num
    } elseif {$integrazione ne "P" && $superficie_integrazione ne ""} {
	element::set_error $form_name superficie_integrazione "Compilare solo per eventuale integrazione con Pannelli solari"
	incr error_num
    };#gac03

    #se si  seleziona altro bisogna perforza compilare il campo altro
    if {$integrazione eq "A" && $nota_altra_integrazione eq ""} {#gac03
        element::set_error $form_name nota_altra_integrazione "Compilare campo Altro"
        incr error_num
    };#gac03
    if {$integrazione ne "A"  && $nota_altra_integrazione ne ""} {#il campo altro va compilato solo se si seleziona altro
	element::set_error $form_name nota_altra_integrazione "Compilare solo se si seleziona \"Altro\""
	incr error_num
    }

    #se si  seleziona altro bisogna perforza compilare il campo Potenza utile
    if {$integrazione eq "A" && $pot_utile_integrazione eq ""} {#gac03
        element::set_error $form_name pot_utile_integrazione "Compilare campo Potenza utile"
	incr error_num
    };#gac03
    if {$integrazione ne "A"  && $pot_utile_integrazione ne ""} {#il campo Potenza utile va compilato solo se si seleziona altro
	element::set_error $form_name pot_utile_integrazione "Compilare solo se si seleziona \"Altro\""
	incr error_num
    }
    if {$superficie_integrazione ne ""} {#gac03
	set superficie_integrazione [iter_check_num $superficie_integrazione 2];#gac03
	if {$superficie_integrazione == "Error"} {#gac03
	    element::set_error $form_name superficie_integrazione "Deve essere numerico con al massimo 2 decimali"
	    incr error_num
	} else {
#gac04	    if {[iter_set_double $superficie_integrazione] >=  [expr pow(10,3)]
#gac04	    ||  [iter_set_double $superficie_integrazione] <= -[expr pow(10,3)]} {
#gac04		element::set_error $form_name superficie_integrazione "deve essere < di 1.000"
#gac04		incr error_num
#gac04	    }
	}
    };#gac03
    
    if {$pot_utile_integrazione ne ""} {#gac03
        set pot_utile_integrazione [iter_check_num $pot_utile_integrazione 2];#gac03
        if {$pot_utile_integrazione == "Error"} {#gac03
	    element::set_error $form_name pot_utile_integrazione "Deve essere numerico con al massimo 2 decimali"
	    incr error_num
        } else {#gac03
	    if {[iter_set_double $pot_utile_integrazione] >=  [expr pow(10,3)]
		||  [iter_set_double $pot_utile_integrazione] <= -[expr pow(10,3)]} {
		element::set_error $form_name pot_utile_integrazione "Deve essere < di 1.000"
		incr error_num
	    }
	};#gac03
    };#gac03

    if {$funzione eq "M" && $coimtgen(regione) eq "MARCHE"} {#gac06 aggiunta if e suo contenuto

	#tipo combustibile selezionato
	set tipo_comb [db_string q "select tipo
                                      from coimcomb
                                     where cod_combustibile = :cod_combustibile" -default ""]

	set tipo_comb_old        ""
	set cod_combustibile_old ""
	#rom09 faccio il left join su coimcomb perche' in alcuni casi non avendo il tipo_combustibile la query 
	#rom09 non tirava su niente e questo faceva andare in errore il programma

	#rom09 db_0or1row q "select tipo as tipo_comb_old
        #rom09                   , i.cod_combustibile as cod_combustibile_old
        #rom09                   , targa as targa_old --sim17
        #rom09                   , stato as stato_old --sim18
        #rom09                from coimaimp i
        #rom09                left join coimcomb c on i.cod_combustibile = c.cod_combustibile
        #rom09               where i.cod_impianto     = :cod_impianto"
	
	db_0or1row q "select tipo as tipo_comb_old
                           , i.cod_combustibile as cod_combustibile_old
                           , targa as targa_old --sim17
                           , stato as stato_old --sim18
                        from coimaimp i
                        left join coimcomb c on i.cod_combustibile = c.cod_combustibile
                       where i.cod_impianto     = :cod_impianto";#rom09
	
	#gac06 se il tipo combustibile selezionato è diverso da quello del combustibile precedente
	#gac06 mostro il warning
	if {$tipo_comb_old ne $tipo_comb} {
	    set msg_cod_combustibile "Attenzione: il tipo di combustibile selezionato è differente dal combustibile precedente"
	} else {
	    set msg_cod_combustibile ""
	}

	#sim17 aggiunto condizione su targa
	#sim18 aggiunto condizione sullo stato
	if {$cod_manutentore eq "" && ($cod_combustibile ne $cod_combustibile_old || $targa ne $targa_old || $stato_old eq "F")} {
	    set error_num 0
	}
    }
    
    if {$funzione eq "M" && [db_0or1row q "select 1 
                                             from coimaimp 
                                            where cod_impianto = :cod_impianto 
                                              and stato='F'"]} {
	#Se sto attivando un'impianto in stato Da controllare vado a saltare tutti i controlli
	set error_num 0
    }

    if {$coimtgen(ente) in [list "PSA"] && $cod_manutentore eq "" && $stato in [list "N" "L" "R" "U" "E"]} {#rom23 Aggiunta if e il suo contenuto
	set error_num 0
    }

    #sim20 aggiunto $inserire_targa eq "t". Se la targa non è corretta blocco anche se è un amministratore 
    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && ($id_settore in [list "ente" "system"] && [string equal $id_ruolo "admin"]) && $inserire_targa eq "t"} {#rom22 Aggiunta if e il suo contenuto
	set error_num 0
    }

    #[template::form::get_errors $form_name]
    # se sono in assegnazione dell'impianto (funzione per manutentori) 
    # aggiorno il manutentore e aggiorno lo storico dei soggetti
    #mic01 Aggiunta condizione su refresh_targa:
    #mic01 quando si bonifica la targa non devo mostrare gli eventuali messaggi di errore
    #mic01 sugli altri campi per evitare di generare dei buchi con la sequence coimaimp_est_s. 
    if {$error_num > 0 && $refresh_targa eq 0} {
        ad_return_template
        return
    }

    if {$coimtgen(regione) eq "MARCHE"} {

	#rileggo il campo cod_tpim dalla tabella perchè altrimenti verrebbe sbiancato
	db_0or1row q "select cod_tpim from coimaimp where cod_impianto = :cod_impianto";#sim15 
	
	#ricalcolo le potenze perchè con i campi desabled mi vengono passati sempre a 0 e quindi non posso fare il element::get_value
	
	if {$flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "C"} {
		db_1row q "select coalesce(sum(pot_utile_nom),'0.00') as potenza_utile
                                , coalesce(sum(pot_focolare_nom),'0.00') as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"

	}
	if {$flag_tipo_impianto eq "F"} {
	    db_1row q "select coalesce(sum(pot_focolare_lib),'0.00') as potenza_utile
                                , coalesce(sum(pot_focolare_nom),'0.00') as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"

	}
	if {$flag_tipo_impianto eq "T"} {
	    db_1row q "select coalesce(sum(pot_focolare_nom),'0.00') as potenza
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo = 'S'"
	} 

    }

    switch $funzione {
        M {
	    if {$flag_cod_aimp_auto == "F"
            ||  $coimtgen(ente)     == "PLI"
	    } {
		set cod_aimp_est [db_map upd_aimp_est]
	    } else {
		set cod_aimp_est ""
	    }

	    if {$coimtgen(regione) eq "MARCHE"} {
		db_1row q "select stato
                                , data_installaz
                                , targa as targa_old --gac05
                             from coimaimp where cod_impianto = :cod_impianto"


		if {$targa ne $targa_old} {#gac05 if e suo contenuto
		    #se è cambiata la targa vado a inserire una riga di log
		    set id_log_new [db_string q "select coalesce(max(id_log),0) +1 from coimtarg_log"]
		    db_dml q "insert into coimtarg_log
                              values ( :id_log_new
                                     , :cod_impianto
                                     , :targa_old
                                     , :targa
                                     , :id_utente
                                     , current_timestamp)"
		    
		}
		
		#per regione modifico la data intervento e la tipologia su tutti gli impianti collegati
		db_dml q "update coimaimp
                             set tipologia_intervento = :tipologia_intervento
                               , data_libretto       = :data_libretto
                           where targa= :targa"

		if {![string equal $cod_impianto_princ_ibrido ""]} {#rom13 Aggiunta if e il suo contenuto

		    # Se il cod_impianto in cui mi trovo non e' gia' associato ad un altro cod_impianto_princ_ibrido
		    # allora vado a inserire un nuovo record sulla tabella coimaimp_ibrido.
		    if {![db_0or1row q "select 1
                                          from coimaimp_ibrido
                                         where cod_impianto_ibrido = :cod_impianto"]} {

			db_dml q "insert into coimaimp_ibrido 
                                            ( cod_impianto_princ
                                            , cod_impianto_ibrido
                                            , is_regolazione_primaria_unica
                                            , is_coimaccu_aimp_unici
                                            , is_coimscam_calo_aimp_unici
                                            , is_coimrecu_calo_aimp_unici
                                            , data_ins
                                            , utente_ins
                                            ) values
                                            ( :cod_impianto_princ_ibrido
                                            , :cod_impianto
                                            , :is_regolazione_primaria_unica
                                            , :is_coimaccu_aimp_unici
                                            , :is_coimscam_calo_aimp_unici
                                            , :is_coimrecu_calo_aimp_unici                                            
                                            , current_date
                                            , :id_utente
                                            )"
			
		    } else {
			
			# Nel caso in cui si modifichi qualche dato riferito all'ibrido vado ad aggiornare la tabella coimaimp_ibrido.
			db_dml q "update coimaimp_ibrido
                                     set cod_impianto_princ             = :cod_impianto_princ_ibrido
                                       , is_regolazione_primaria_unica  = :is_regolazione_primaria_unica
                                       , is_coimaccu_aimp_unici         = :is_coimaccu_aimp_unici
                                       , is_coimscam_calo_aimp_unici    = :is_coimscam_calo_aimp_unici
                                       , is_coimrecu_calo_aimp_unici    = :is_coimrecu_calo_aimp_unici
                                       , data_mod                       = current_date
                                       , utente_mod                     = :id_utente
                                   where cod_impianto_ibrido = :cod_impianto"

		    }
		} else {
		    # Se ho lasciato il campo cod_impianto_princ_ibrido vuoto ma il cod_impianto in cui mi trovo e' gia' associato
		    # ad un altro cod_impianto_princ_ibrido vado a cancellare il record su comaimp_ibrido		    
		    if {[db_0or1row q "select 1
                                         from coimaimp_ibrido
                                        where cod_impianto_ibrido = :cod_impianto"]} {
		    
			db_dml q "delete from coimaimp_ibrido where cod_impianto_ibrido = :cod_impianto"
		    }
		}
	    }
	    if {$refresh_targa == "1"} {#mic01 Aggiunta if e contenuto
		#Generazione nuova targa prima dell'update
		if {$flag_codifica_reg == "T"} {
		    if {$coimtgen(regione) eq "MARCHE"} {
			if {$coimtgen(ente) eq "CPESARO"} {
			    set sigla_est "CMPS"
			} elseif {$coimtgen(ente) eq "CFANO"} {
			    set sigla_est "CMFA"
			} elseif {$coimtgen(ente) eq "CANCONA"} {
			    set sigla_est "CMAN"
			} elseif {$coimtgen(ente) eq "PAN"} {
			    set sigla_est "PRAN"
			} elseif {$coimtgen(ente) eq "CJESI"} {
			    set sigla_est "CMJE"
			} elseif {$coimtgen(ente) eq "CSENIGALLIA"} {
			    set sigla_est "CMSE"
			} elseif {$coimtgen(ente) eq "PPU"} {
			    set sigla_est "PRPU"
			} elseif {$coimtgen(ente) eq "PMC"} {
			    set sigla_est "PRMC"
			} elseif {$coimtgen(ente) eq "CMACERATA"} {
			    set sigla_est "CMMC"
			} elseif {$coimtgen(ente) eq "CCIVITANOVA MARCHE"} {
			set sigla_est "CMCM"
			} elseif {$coimtgen(ente) eq "CASCOLI PICENO"} {
			    set sigla_est "CMAP"
			} elseif {$coimtgen(ente) eq "CSAN BENEDETTO DEL TRONTO"} {
			    set sigla_est "CMSB"
			} elseif {$coimtgen(ente) eq "PAP"} {
			    set sigla_est "PRAP"
			} elseif {$coimtgen(ente) eq "PFM"} {
			    set sigla_est "PRFM"
			} else {
			    set sigla_est ""
			}
			
			set progressivo_est [db_string sel "select nextval('coimaimp_est_s')"]
			
			# devo fare l'lpad con una seconda query altrimenti mi va in errore
			set progressivo_est [db_string sel "select lpad(:progressivo_est,:lun_num_cod_imp_est,'0')"]
			
			set targa "$sigla_est$progressivo_est"
		    }
		}
	    }
	    set dml_sql  [db_map upd_aimp]
	}
        D {set dml_sql  [db_map del_aimp]}
        C { 
	    if {$flag_cod_aimp_auto == "T"} {
		if {$flag_codifica_reg == "T"} {
		    if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA"} {;#gab01 aggiunto alle condizioni il comune di Ancona ;#gab02 aggiunto alle condizioni la provincia di Ancona
			    
			if {$coimtgen(ente) eq "CPESARO"} {
			    set sigla_est "CMPS"
			} elseif {$coimtgen(ente) eq "CFANO"} {
			    set sigla_est "CMFA"
			} elseif {$coimtgen(ente) eq "CANCONA"} {;#gab01
                            set sigla_est "CMAN"
			} elseif {$coimtgen(ente) eq "PAN"} {;#gab02
			    set sigla_est "PRAN"
			} elseif {$coimtgen(ente) eq "CJESI"} {;#sim10
                            set sigla_est "CMJE"
			} elseif {$coimtgen(ente) eq "CSENIGALLIA"} {;#sim10
                            set sigla_est "CMSE"
			} else {
			    set sigla_est "PRPU"
			}
			
			set progressivo [db_string sel "select nextval('coimaimp_est_s')"]
			# devo fare l'lpad con una seconda query altrimenti mi andava in errore
			#nic03 set progressivo [db_string sel "select lpad(:progressivo,6,'0')"]
			set progressivo [db_string sel "select lpad(:progressivo,:lun_num_cod_imp_est,'0')"];#nic03
			set cod_impianto_est "$sigla_est$progressivo"
			
		    } else {

			# caso standard
			db_1row sel_dati_codifica ""
			if {$coimtgen(ente) eq "PMS"} {#nic02: aggiunta if. Originale nell'else
			    set progressivo [db_string query "select lpad(:progressivo, 5, '0')"];#nic02
			    set cod_istat  "[string range $cod_istat 5 6]/";#nic02
			} elseif {$coimtgen(ente) eq "PTA"} {#sim08: aggiunta if e suo contenuto
			    set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
			    set fine_istat  [string length $cod_istat]
			    set iniz_ist    [expr $fine_istat -3]
			    set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
			} else {#nic02
			    set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
			};#nic02

			if {![string equal $potenza "0.00"]
			&&  ![string equal $potenza ""]
			} {
			    if {$potenza < 35} {
				set tipologia "IN"
			    } else {
				set tipologia "CT"
			    }
			    set cod_impianto_est "$cod_istat$progressivo"
			    set dml_comu         [db_map upd_prog_comu]
			} else {
			    if {![string equal $cod_potenza "0"]
			    &&  ![string equal $cod_potenza ""]} { 
				switch $cod_potenza {
				    "B"  {set tipologia "IN"}
				    "A"  {set tipologia "CT"}
				    "C"  {set tipologia "CT"}
				    "MA" {set tipologia "CT"}
				    "MB" {set tipologia "CT"}
				}
				
				set cod_impianto_est "$cod_istat$progressivo"
				set dml_comu         [db_map upd_prog_comu]
			    } else {
				set cod_impianto_est "$cod_istat$progressivo"
				set dml_comu         [db_map upd_prog_comu]
			    }
			}
		    }
		} else {
		    db_1row get_cod_impianto_est ""
		}
	    }
	    db_1row sel_cod_aimp     ""
	    set dml_sql  [db_map ins_aimp]
	    set dml_gend [db_map ins_gend]
	    if {$conferma_inco == "T"} {
		set dml_inco [db_map ins_inco]
	    }
	}
        R {
            if {![string equal $potenza "0.00"]
	    &&  ![string equal $potenza ""]} {
		if {$potenza < 35} {
                    set tipologia "IN"
                } else {
                    set tipologia "CT"
                }
	    } else {
		switch $cod_potenza {
		    "B"  {set tipologia "IN"}
		    "A"  {set tipologia "CT"}
                    "C"  {set tipologia "CT"}
		    "MA" {set tipologia "CT"}
		    "MB" {set tipologia "CT"}
		}
	    }
            
	    #gab02 aggiunto alle condizioni la provincia di Ancona
	    #gab01 aggiunto alle condizioni il comune di Ancona
            if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA"} {#nic01
		#sim04 set cod_istat            [string range $cod_istat 3 5];#nic01 (fatto da Sandro)
		#sim04 set cod_impianto_est_new "$cod_istat$progressivo";#nic01 (fatto da Sandro)
		#sim04: aggiunte tutte le seguenti istruzioni
		if {$coimtgen(ente) eq "CPESARO"} {
		    set sigla_est "CMPS"
		} elseif {$coimtgen(ente) eq "CFANO"} {
		    set sigla_est "CMFA"
		}  elseif {$coimtgen(ente) eq "CANCONA"} {;#gab01
                    set sigla_est "CMAN"
                } elseif {$coimtgen(ente) eq "PAN"} {;#gab02
		    set sigla_est "PRAN"
		} elseif {$coimtgen(ente) eq "CJESI"} {;#sim10
		    set sigla_est "CMJE"
		} elseif {$coimtgen(ente) eq "CSENIGALLIA"} {;#sim10
		    set sigla_est "CMSE"
		} else {
		    set sigla_est "PRPU"
		}
		
		set progressivo [db_string sel_prog "select nextval('coimaimp_est_s')"]
		# devo fare l'lpad con una seconda query altrimenti mi andava in errore
		#nic03 set progressivo [db_string sel_prog "select lpad(:progressivo, 6, '0')"]
		set progressivo [db_string sel_prog "select lpad(:progressivo,:lun_num_cod_imp_est,'0')"];#nic03
		
		set cod_impianto_est_new "$sigla_est$progressivo"
						
	    } else {#nic01
		db_1row sel_dati_codifica ""

		if {$coimtgen(ente) eq "PMS"} {#nic02: aggiunta if. Originale nell'else
		    set progressivo [db_string query "select lpad(:progressivo, 5, '0')"];#nic02
		    set cod_istat  "[string range $cod_istat 5 6]/";#nic02
		} elseif {$coimtgen(ente) eq "PTA"} {#sim08: aggiunta if e suo contenuto
		    set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
		    set fine_istat  [string length $cod_istat]
		    set iniz_ist    [expr $fine_istat -3]
		    set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
		} else {#nic02
		    set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
		};#nic02

		set cod_impianto_est_new "$cod_istat$progressivo"
	    };#nic01

	    set dml_comu [db_map upd_prog_comu]
	    set dml_sql  [db_map upd_aimp_cod]}
    }


    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimaimp $dml_sql
                if {[info exists dml_gend]} {
		    db_dml dml_coimaimp $dml_gend
		}
                if {[info exists dml_comu]} {
		    db_dml dml_coimcomu $dml_comu
		}
                if {[info exists dml_inco]} {
		    db_dml dml_coiminco $dml_inco
		}
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    #gac06 aggiunto msg_cod_combustibile
    set link_gest [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp caller msg_cod_combustibile]
    
    if {$nome_funz_caller != [iter_get_nomefunz coimaimp-isrt-veloce]} {
	set link_del $url_list_aimp
    } else {
        set link_del "coimaimp-isrt-veloce?nome_funz=$nome_funz_caller"
    }

    switch $funzione {
        M {set return_url   "coimaimp-gest?funzione=V&$link_gest"}
        D {set return_url   $link_del}
        I {set return_url   "coimaimp-gest?funzione=V&$link_gest"}
        C {set cod_impianto $cod_aimp
	    set link_copy [export_url_vars cod_impianto nome_funz_caller nome_funz last_cod_impianto  extra_par url_list_aimp]
	    set return_url   "coimaimp-gest?funzione=V&$link_copy"} 
        V {set return_url   $url_list_aimp}
        R {set return_url   "coimaimp-gest?funzione=V&$link_gest"}
    }

    ad_returnredirect $return_url    
    ad_script_abort
}

ad_return_template
