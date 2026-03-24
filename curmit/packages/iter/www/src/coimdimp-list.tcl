ad_page_contract {
    Lista tabella "coimdimp"

    @author                  Giulio Laurenzi
    @creation-date           06/04/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
                             serve per la navigation bar
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimdimp-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom17 26/09/2024 Apef di Frosinone deve vedere i link per gli rcee con Ravvedimento Operoso
    rom17            e devono poter inserire le DFM. Gli utenti dell'ente di Apef dvedono il nowallet.

    rom16 31/10/2024 Per l'ambiente demo aggiunto dfm, modificata visualizzazione link_aggiungi.

    rom15 01/03/2024 Solo per Terra di Lavoro di Caserta aggiunti link per rcee con Ravvedimento Operoso.

    but02  15/02/2024 Agguinto la condizione solo per gli impianti del freddo non possiamo
    but02             vedere il link di "Dichiarazione di Avvenuta manutenzione (DAM)"

    rom14 21/11/2023 Provincia di Rieti deve poter inserire le DFM

    rom13 26/09/2023 La somma delle potenze dei generatori deve tenere in considerazione tutti i generatori
    rom13            attivi e non solo quelli con potenza nominale maggiore di 10 kW.

    but01 14/07/2023 Aggiunta classe "link-button-2" nel actions "Selez","Mod.Gen", "Allega scansione"
    but01            ,"Vedi scansione","Elimina scansione","Ins. mod. sost","Richiedi storno","Rifiuta storno".

    rom12 26/04/2023 Aggiunto controllchiesto da Regione Marche ma valido per tutti gli enti:
    rom12            se si e' loggati come operatore di una ditta e questa non risulta associata
    rom12            come manutentore e/o installatore tolgo tutti i possibili link.

    rom11 01/02/2023 Riportati alcune modifiche fatte su Ucit sul vecchio cvs:
    rom11            Su segnalazione di Belluzzo per gli impianti del freddo non faccio piu'
    rom11            vedere il link del nowallet. Sandro ha detto che va bene per tutti.
    rom11            Su richiesta di Chiara Pavaran di UCIT per la regione Friuli non mostro
    rom11            piu' la funzione "Ins. mod. sost." che era visibile solo ai manutentori.
    rom11            Su richiesta di Belluzzo, per la regione Friuli non faccio piu'
    rom11            visualizzare il link "Richiedi storno".

    rom10 04/11/2022 Palermo ha il nowallet sia per il caldo che per il freddo.

    rom09 17/03/2022 16/03/2022 MEV Regione Marche punto 6. Stampa RCEE precompilato senza dati del
    rom09            Controllo del rendimento di combustione.    

    rom08 08/07/2020 Sandro ha detto che gli utenti non manutentori della Basilicata devono
    rom08            vedere il no wallet come per la Regione Marche: 
    rom08            sia per gli impianti del caldo che per gli impianti del freddo.

    rom07 06/07/2020 Sandro ha detto che gli enti della Basilicata devono poter inserire 
    rom07            DAM e DFM come gli enti della Regione Marche.

    rom06 12/01/2021 Le partiolarita' della Provincia di Salerno da ora sono sostiuite dalla
    rom06            condizione su tutta la Regione Campania.

    rom05 30/06/2020 Per la Regione Marche gli utentnti non manutentori possono inserire le DFM
    rom05            anche se mancano dei dati obbligatori dell'impianto.
    
    sim14 10/12/2019 Gestito 284 e nuovi 286 per la Regione Marche 

    sim13 05/12/2019 Aggiunto solo per le Marche anche il no wallet del freddo 

    sim12 28/11/2019 Il controllo per la dam va fatto solo sulla potenza del singolo impianto
    
    gac05 20/11/2019 Per regione marche devo fare tutti i redirect al programma coimaimp_warning
    
    sim11 20/11/2019 Corretto visualizzazione Art 284 in base alla potenza. Ora utilizza la somma della potenza
    sim11            utile dei generatori attivi
        
    sim10 23/05/2019 Su Taranto i manutentori non possono inserire Rcee senza bollino

    rom04 27/02/2019 Aggiunti i link per i file pdf inviati dalla Regione Marche

    gac04 16/11/2018 Aggiunta if per far vedere il link per aggiungere la DAM solo in casi
    gac04            particolari 
    
    gac03 13/07/2018 Aggiunto link_scheda4

    rom03 12/07/2018 Aggiunto link link_scheda13.

    gac02 02/07/2018 Modificate label

    rom02 08/05/2018 Rimosso il link per aggiungere un Allegato IX.

    rom03 26/11/2018 Riattivato solo per Provincia di Pordenone (UCIT) il link ai modelli g e f.

    rom02 14/11/2018 Riattivato solo per Provincia di Trieste (UCIT) il link ai modelli g e f.

    rom01 29/10/2018 Aggiunto link "Motivazione storno" (guardare il postgresql).

    sim09 11/12/2017 Riattivato solo per Taranto il link ai modelli g e tornati indietro rispetto la modifica sim07

    sim08 20/04/2018 Aggiunto per Ucit possibilità di fare RCEE senza portafoglio (momentaneo)

    sim07 01/12/2017 Tolto per Taranto la possibilità di fare RCEE senza portafoglio

    gac01 25/10/2017 Rimossi link per aggiungere modelli G e modelli F

    gab01 07/07/2017 Cambiato la label RCEE Tipo 1 Legna in: RCEE Tipo 1 biomassa

    sim07 05/05/2017 Solo per Firenze si può inserire sia un rct standard che un rct legna

    sim06 06/04/2017 Se la dichiarazione è riferita ad un impianto con teleriscaldamento
    sim06            devo puntare al programma coimdimp-r3-gest.

    sim05 09/03/2017 Per PLI inibiti link per inserimento modelli G ed F.

    sim04 25/10/2016 Anche per gli amministratori di iterprrc sarà presente il link
    sim04            per inserire rct senza il portafoglio

    sim03 18/10/2016 Solo per taranto ci sarà anche il flag_tracciato NW che è l'rct senza
    sim03            il portafoglio

    sim02 21/03/2016 I link Richiedi storno e Ins. mod. sost. devono essere visualizzati solo
    sim02            dal manutentore.
    sim02            Per il momento non visualizziamo il link Accetta storno.

    san01 14/01/2016 Per CPESARO e CFANO, inibiti link per inserimento modelli G ed F.

    nic02 17/09/2015 Aggiunti link per gestione dichiarazioni di avvenuta manutenzione per
    nic02            la regione Marche.

    ant01 16/09/2015 Aggiunta lista e link per gestione "dich. di freq. ed elenco oper. di
    ant01            contr. e manut." usata solo nella regione Marche.

    nic01 18/11/2014 D'accordo con Sandro, facciamo l'order by desc

    sim01 18/11/2014 correzione del link pagina successiva

} { 
   {search_word            ""}
   {rows_per_page          ""}
   {caller            "index"}
   {nome_funz              ""}
   {nome_funz_caller       ""} 
   {receiving_element      ""}
   {last_cod_dimp          ""}
   {cod_impianto           ""}
   {url_aimp               ""}
   {url_list_aimp          ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

db_1row query "select flag_portafoglio from coimtgen " 

iter_get_coimtgen;#ant01
set flag_gest_targa $coimtgen(flag_gest_targa)

set flag_cimp "S";#rom03
set link_scheda13 "[export_url_vars cod_impianto url_list_aimp url_aimp flag_cimp]&nome_funz=[iter_get_nomefunz coimcimp-list]";#rom03
set link_scheda4 "[export_url_vars cod_impianto ]";#gac03

#sim09 Spostato qui perchè mi serve nelle if sotto
set cod_manu [iter_check_uten_manu $id_utente];#sim04

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DIMPLIST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DIMPLIST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-DIMPLIST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

set ruolo [db_string query "select id_ruolo from coimuten where id_utente = :id_utente  "]

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

set db_name [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""];#rom16

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title      "Lista Allegati"

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimdimp-gest"
set gest_prog_2     "coimdimp-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Responsabile"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
#set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]\">Aggiungi</a>"

set link_aggiungi ""
set flag_sup ""
db_1row sel_aimp_potenza ""

if {$flag_tipo_impianto == "R"} {#dpr

    set potenza [db_string q "select sum(pot_utile_nom) from coimgend where cod_impianto = :cod_impianto and flag_attivo  = 'S'" -default "0"];#sim11

    if {$potenza >= 35} {
	#sim05 aggiunto condizione su PLI
	if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "PLI"} {#san01
	    set link_inserisci_modello_f "";#san01
	} else {#san01
      	    set link_inserisci_modello_f "
                                 Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=F&[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]\">Modello F</a>
                          <br> o "
	};#san01

#gac01	set link_aggiungi "$link_inserisci_modello_f
#gac01                           Aggiungi un <a href=\"coimnove-gest?funzione=I&[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]\">Allegato IX</a>
#gac01                    <br> o Aggiungi un <a href=\"coimnoveb-gest?funzione=I&[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]\">Allegato art 284</a>
#gac01                    <br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 1</a>"

	if {$coimtgen(regione) eq "MARCHE"} {#gac05 agggiunta if else e contenuto di if
	    set link [export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]
	
	    set link [export_url_vars link]%26funzione=I
	    #sim14 set link_aggiungi "Aggiungi <a href=\"coimaimp-warning?redirect=coimnoveb-gest&$link&cod_impianto=$cod_impianto&caller=dope&funzione=I\">dichiarazione art.284 del D.Lgs. 152/2006 (impianti superiori a 35 kW)</a> <a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest-help?caller=aggiungi-dich', 'help', 'scrollbars=yes, esizable=yes, width=520, height=280').moveTo(110,140)\"><b>Vedi nota</b></a>
	    #sim14 aggiungi 284 e 286
	    set link_aggiungi "Aggiungi <a href=\"coimaimp-warning?redirect=coimnove-284-gest&$link&cod_impianto=$cod_impianto&caller=dope&funzione=I\">dichiarazione art.284 del D.Lgs. 152/2006 (impianti superiori a 35 kW)</a> <a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest-help?caller=aggiungi-dich', 'help', 'scrollbars=yes, esizable=yes, width=520, height=280').moveTo(110,140)\"><b>Vedi nota</b></a>
                    <br> o Aggiungi <a href=\"coimaimp-warning?redirect=coimnove-286-gest&$link&cod_impianto=$cod_impianto&caller=dope&funzione=I\">dichiarazione art.286 del D.Lgs. 152/2006 - verifica periodica delle emissioni (impianti superiori a 35 kW)</a> <a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest-help?caller=aggiungi-dich-286', 'help', 'scrollbars=yes, esizable=yes, width=520, height=280').moveTo(110,140)\"><b>Vedi nota</b></a>
                    <br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 1</a>"
	} else {
	    set link_aggiungi "Aggiungi <a href=\"coimnoveb-gest?funzione=I&[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller]\">dichiarazione art.284 del D.Lgs. 152/2006 (impianti superiori a 35 kW)</a> <a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest-help?caller=aggiungi-dich', 'help', 'scrollbars=yes, esizable=yes, width=520, height=280').moveTo(110,140)\"><b>Vedi nota</b></a>
                    <br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 1</a>"
	}
	#rom03 Aggiunta condizione per Pordenone $coimtgen(ente) eq "PPN"
	if {($coimtgen(ente) eq "PTS" || $coimtgen(ente) eq "PPN") && $cod_manu eq ""} {#rom02 aggiunta if e suo contenuto
	    set link_aggiungi "$link_inserisci_modello_f
                           $link_aggiungi"
	}	
	set flag_sup "S"
    } else {
	#sim05 aggiunto condizione su PLI
        if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "PLI"} {#san01
            set link_inserisci_modello_g "";#san01
        } else {#san01
            set link_inserisci_modello_g "
                           Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=G&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Modello G</a>
                          <br> o "
	}

	#rom02 aggiunta condizione  || $coimtgen(ente) eq "PTS"
	#rom03 aggiunta condizione  || $coimtgen(ente) eq "PPN"
	if {($coimtgen(ente) eq "PTA" || $coimtgen(ente) eq "PTS" || $coimtgen(ente) eq "PPN") && $cod_manu eq ""} {#sim09
	    #sim09 tornato indietro rispetto gac01
	    set link_aggiungi "$link_inserisci_modello_g
                           Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 1</a>"
	} else {#sim09

#gac01	    set link_aggiungi "
#gac01                           Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 1</a>";#gac01


	    set link_aggiungi "
                           Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 1</a>";#gac01

	};#sim09

	set flag_sup "N"
    }

    if {$coimtgen(flag_gest_rcee_legna) eq "T" && $coimtgen(ente) eq "PFI"} {;#sim07

	#gab01 cambiata label RCEE Tipo 1 Legna
	append link_aggiungi "<br>o Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=1B&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 1 biomassa</a>"
	
    }

}

if {$flag_tipo_impianto == "F"} {#dpr
#gac02    set link_aggiungi  "Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=R2&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 2</a>"
    set link_aggiungi  "Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R2&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 2</a>";#gac02
   set flag_sup "N"
}

if {$flag_tipo_impianto == "T"} {#sim6 if e suo contenuto
#gac02    set link_aggiungi  "Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=R3&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 3</a>"
    set link_aggiungi  "Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R3&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 3</a>";#gac02
   set flag_sup "N"
}

if {$flag_tipo_impianto == "C"} {#rom01 if e suo contenuto
#gac02    set link_aggiungi  "Aggiungi <a href=\"$gest_prog?funzione=I&flag_tracciato=R4&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE Tipo 4</a>"
    set link_aggiungi  "Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=R4&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Rapporto di Controllo dell'Efficienza Energetica (RCEE) di Tipo 4</a>";#gac02
    set flag_sup "N"
};#rom01

#rom07 Aggiunta condizione per la Basilicata.
if {$coimtgen(regione) eq "MARCHE" || $coimtgen(regione) eq "BASILICATA"} {#nic02: aggiunta if e suo contenuto
    if {$flag_gest_targa eq "T"} {#gac04 aggiunta if else e loro contenuto
	
	db_1row q "select targa
                        , flag_tipo_impianto as flag_tipo_impianto_where
                 from coimaimp
                where cod_impianto = :cod_impianto"

	set join_padre "inner join coimaimp f      on f.cod_impianto      = a.cod_impianto"
	set where_padre "    f.cod_impianto != :cod_impianto
                     and upper(f.targa)  = upper(:targa) and f.stato='A' and f.flag_tipo_impianto = :flag_tipo_impianto_where "
	
    } else {#gac04
	
	set join_padre "left outer join coimaimp f on f.cod_impianto = a.cod_impianto
                 --    inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
                 --      and f.cod_impianto != h.cod_impianto"
	set where_padre "h.cod_impianto = :cod_impianto"
	
    };#gac04
    set potenza [db_list q "
       select sum(potenza) as tot_potenza
         from (
           select case when f.flag_tipo_impianto = 'F' then a.pot_utile_nom_freddo
                       else a.pot_utile_nom end as potenza
             from coimgend a
             inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
            where a.cod_impianto = :cod_impianto
--rom13       and case when f.flag_tipo_impianto = 'F' then a.pot_utile_nom_freddo
--rom13               else a.pot_utile_nom end >10
              and f.stato='A'
              and a.flag_attivo='S'
--sim12            union all

--sim12           select case when f.flag_tipo_impianto = 'F' then a.pot_utile_nom_freddo
--sim12                       else a.pot_utile_nom end as potenza
--sim12             from coimgend a
--sim12             $join_padre
--sim12            where $where_padre
--sim12              and a.flag_attivo='S'
--sim12              and case when f.flag_tipo_impianto = 'F' then a.pot_utile_nom_freddo
--sim12                      else a.pot_utile_nom end >10
           ) gen"];#gac04
    
		 

    set tipologia_generatore [db_string  q "select  tipologia_generatore from coimaimp where cod_impianto = :cod_impianto"];#gac04
    set tipo [db_string q "select a.tipo from coimcomb a, coimaimp b where b.cod_impianto = :cod_impianto and a.cod_combustibile = b.cod_combustibile" -default ""];#gac04

    #but02 Aggiunta condizione su flag_tipo_impianto ne "F"
    if {$tipo eq "G" && $tipologia_generatore ne "PCALO" && $potenza <= "100" && $potenza >= "10" && $flag_tipo_impianto ne "F"} {#gac04 aggiunta if 
	#gac02   append link_aggiungi "<br>o Aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=DA&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Dich. di Avvenuta manutenzione</a>"
	append link_aggiungi "<br>o Aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=DA&[export_url_vars last_cod_dimp caller url_lis_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">Dichiarazione di Avvenuta manutenzione (DAM)</a>";#gac02
    }
}

# ant01: aggiungo il link alle dichiarazioni di frequenza.
# rom07: aggiunta condizione per la Basilicata.
#rom14: Aggiunta condizione per Provincia di Rieti
#rom16: Aggiunta condizione per "iter2019-portal-dev"
#rom17: Modificata condizione di rom14 per aggiungere anche Provincia di Frosinone
if {$coimtgen(regione) eq "MARCHE" || $coimtgen(regione) eq "BASILICATA" || $coimtgen(ente) in [list "PRI" "PFR"] || $db_name eq "iter2019-portal-dev"} {#ant01: aggiunta if e suo contenuto
    set sw_dichiarazioni_frequenza "t"
} else {
    set sw_dichiarazioni_frequenza "f"
}

if {$sw_dichiarazioni_frequenza eq "t"} {#ant01: aggiunta if e suo contenuto
    #rom05 modificata if: il controllo sul warning deve essere fatto solo per i manutentori

    if {$coimtgen(regione) eq "MARCHE" && $cod_manu ne ""} {#gac05 aggiunta if else e contenuto di if
	set link "[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto flag_tipo_impianto nome_funz extra_par nome_funz_caller flag_tracciato funzione]"
	
	set link [export_url_vars link]%26funzione=I

	set coimdope_url "coimaimp-warning?redirect=coimdope-aimp-gest&$link&cod_impianto=$cod_impianto&caller=dope&funzione=I";#gac05 

	set js_function "return(confirm('Sono stati inseriti tutti i generatori?'));"

	append link_aggiungi "<br> o Aggiungi una <a href=\"$coimdope_url\" onclick=\"$js_function\">Dichiarazione di Frequenza ed elenco delle operazioni di controllo e manutenzione (DFM)</a>";#gac02

    } else {
	
	set coimdope_url "coimdope-aimp-gest?funzione=I&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto flag_tipo_impianto nome_funz extra_par nome_funz_caller flag_tracciato]"
	set js_function "return(confirm('Sono stati inseriti tutti i generatori?'));"
	#gac02    append link_aggiungi "<br> o Aggiungi una <a href=\"$coimdope_url\" onclick=\"$js_function\">Dich. di Freq. ed elenco oper. di contr. e man.</a>"
    append link_aggiungi "<br> o Aggiungi una <a href=\"$coimdope_url\" onclick=\"$js_function\">Dichiarazione di Frequenza ed elenco delle operazioni di controllo e manutenzione (DFM)</a>";#gac02

    }
}

if {$coimtgen(regione) eq "MARCHE"} {#rom04 aggiunta if e suo contenuto

    set is_only_print_p "t";#rom09
    
    switch $flag_tipo_impianto {
	R {
	    append link_aggiungi "<br> o Stampa/scarica il <a href=\"Info-aggiuntive-1bis_4.1bis-REE-Tipo-1.pdf\" target=\"_blank\"> modulo di rilevazione dati per la compilazione delle schede 1.bis e 4.1bis</a>"
	    append link_aggiungi "<br> o Stampa il <a href=\"coimdimp-rct-layout?[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto is_only_print_p nome_funz extra_par nome_funz_caller]\"> modello RCEE precompilato senza dati del Controllo del rendimento di combustione</a>";#rom09
	}
	F {
	    append link_aggiungi "<br> o Stampa/scarica il <a href=\"Info-aggiuntive-1bis_4.4bis-REE-Tipo-2.pdf\" target=\"_blank\"> modulo di rilevazione dati per la compilazione delle schede 1.bis e 4.4bis</a>"
	    append link_aggiungi "<br> o Stampa il <a href=\"coimdimp-fr-layout?[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto is_only_print_p nome_funz extra_par nome_funz_caller]\"> modello RCEE precompilato senza dati del Controllo del rendimento di combustione</a>";#rom09
	}
	T {
	    append link_aggiungi "<br> o Stampa/scarica il <a href=\"Info-aggiuntive-1bis_4.5bis-REE-Tipo-3.pdf\" target=\"_blank\"> modulo di rilevazione dati per la compilazione delle schede 1.bis e 4.5bis</a>"
	    append link_aggiungi "<br> o Stampa il <a href=\"coimdimp-r3-layout?[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto is_only_print_p nome_funz extra_par nome_funz_caller]\"> modello RCEE precompilato senza dati del Controllo del rendimento di combustione</a>";#rom09
	}
	C {
	    append link_aggiungi "<br> o Stampa/scarica il <a href=\"Info-aggiuntive-1bis_4.6bis-REE-Tipo-4.pdf\" target=\"_blank\"> modulo di rilevazione dati per la compilazione delle schede 1.bis e 4.6bis</a>"
	    append link_aggiungi "<br> o Stampa il <a href=\"coimdimp-r4-layout?[export_url_vars flag_tracciato last_cod_dimp caller url_list_aimp url_aimp cod_impianto is_only_print_p nome_funz extra_par nome_funz_caller]\"> modello RCEE precompilato senza dati del Controllo del rendimento di combustione</a>";#rom09
	}
    }
};#rom04

set cod_manu [iter_check_uten_manu $id_utente];#sim04
#sim09 set cod_manu [iter_check_uten_manu $id_utente];#sim04

#sim04 aggiunto || per PRC
#sim07 tolto $coimtgen(ente) eq "PTA" || 
#sim08 aggiunto if per PUD-PGO-PTS-PPN
#sim09 riaggiunto $coimtgen(ente) eq "PTA" ||
#sim10 modificato condizione su Taranto
#sim aggiunto condizione sulle marche
#rom06 sostiuito $coimtgen(ente) eq "PSA" con $coimtgen(regione) eq "CAMPANIA" 
#rom08 aggiunta condizione sulla Basilicata
#rom10 aggiunta condizione su Palermo
#rom11 Sostituite le varie condizioni degli enti di Ucit con un'unica condizione su tutta Regione
#rom14: Aggiunta condizione per Provincia di Rieti
#rom17: Aggiunta condizione per Provincia di Frosinone
if {($coimtgen(ente) eq "PRC" && $cod_manu eq "") ||
    ($coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $flag_tipo_impianto == "R") ||
    ($coimtgen(ente) eq "PTA" && $cod_manu eq "") ||
    ($coimtgen(regione) eq "CAMPANIA" && $cod_manu eq "" && $flag_tipo_impianto == "R") ||
    ($coimtgen(regione) eq "MARCHE" && $cod_manu eq "" && $flag_tipo_impianto == "R") ||
    ($coimtgen(regione) eq "BASILICATA" && $cod_manu eq "" && $flag_tipo_impianto == "R") ||
    ($coimtgen(ente) eq "PPA"  && $cod_manu eq "" && $flag_tipo_impianto == "R") ||
    ($coimtgen(ente) eq "PRI" && $cod_manu eq "" && $flag_tipo_impianto == "R") ||
    ($coimtgen(ente) eq "PFR" && $cod_manu eq "" && $flag_tipo_impianto == "R")} {;#sim03
    append link_aggiungi "<br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=NW&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE senza bollino virtuale</a>"
}

if {$coimtgen(ente) in [list "PCE" "PFR"] && $flag_tipo_impianto == "R"} {#rom15 Aggiunta if e il suo contenuto

    append link_aggiungi "<br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=O1&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE con Ravvedimento Operoso</a>"

}

#rom06 Sostiuitte condizioni su regione Marche ed ente PSA 
#rom06 con $coimtgen(regione) in [list "MARCHE" "CAMPANIA"]
#rom08 aggiunta condizione sulla Basilicata
#rom10 aggiunta condizione su Palermo
#rom14: Aggiunta condizione per Provincia di Rieti
#rom17: Aggiunta condizione per Provincia di Frosinone
if {($coimtgen(regione) in [list "MARCHE" "CAMPANIA" "BASILICATA"] || $coimtgen(ente) in [list "PPA" "PRI" "PFR"]) && $cod_manu eq "" && $flag_tipo_impianto == "F"} {;#sim13 if e suo contenuto
    append link_aggiungi "<br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=NF&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE senza bollino virtuale</a>"
}

if {$coimtgen(ente) in [list "PCE" "PFR"] && $flag_tipo_impianto == "F"} {#rom15 Aggiunta if e il suo contenuto

    append link_aggiungi "<br> o Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=O2&[export_url_vars last_cod_dimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_tracciato]\">RCEE con Ravvedimento Operoso</a>"

}


set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]


set link    "\[export_url_vars cod_dimp cod_impianto url_list_aimp url_aimp last_cod_dimp nome_funz nome_funz_caller extra_par\]" 
set link_scansionati  "\[export_url_vars cod_dimp  cod_impianto url_list_aimp url_aimp last_cod_dimp nome_funz nome_funz_caller extra_par \]"

#B80 Ticket 41448 - fix inserimento modello F/G - Start
if {$potenza >= 35} {
    if {[string range $id_utente 0 1] eq "MA"} {
	set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=F&$link\" class=\"link-button-2\">Selez.</a></td>"
    } else {
	if {$coimtgen(regione) ne "MARCHE"} {#but01
	    set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=F&$link\" class=\"link-button-2\">Selez.</a> - <a href=\"coimdimp-gen-chg?$link\" class=\"link-button-2\">Mod.Gen.</a></td>"
	} else {
	    set actions "
<td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=F&$link\" class=\"link-button-2\">Selez.</a></td>"
    }
    }
} else {
    if {[string range $id_utente 0 1] eq "MA"} {
	set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=G&$link\" class=\"link-button-2\">Selez.</a></td>"
    } else {
        if {$coimtgen(regione) ne "MARCHE"} {
	    set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=G&$link\" class=\"link-button-2\">Selez.</a> - <a href=\"coimdimp-gen-chg?$link\" class=\"link-button-2\">Mod.Gen.</a></td>"
	} else {            set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&flag_tracciato=G&$link\" class=\"link-button-2\">Selez.</a></td>"
	}
    }
}
#B80 Ticket 41448 - End


set js_function ""

set azioni_aggiuntive "
<td align=center><table cellpadding=0 cellspacing=0 border=0><tr>
    <td align=center nowrap><a href=\"coimdimp-alle-ins?tabella=coimdimp&$link_scansionati\" class=\"link-button-2\">Allega scansione</a></td>
    <td align=center nowrap>&nbsp;<a href=\"coimdimp-alle-view?tabella=coimdimp&$link_scansionati\" class=\"link-button-2\">Vedi scansione</a></td>
    <td align=center nowrap>&nbsp;<a href=\"coimdimp-alle-delete?tabella=coimdimp&$link_scansionati\"onClick=\"javascript:return(confirm('Confermi eliminazione scansionato allegato?'))\" class=\"link-button-2\">Elimina scansione</a></td>"
if {$flag_portafoglio == "T"} {

    if {$ruolo eq "manutentore"} {;#sim02
	if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom11 Aggiunta if ma non il suo contenuto
	    append azioni_aggiuntive "
    <td align=center>&nbsp;<a href=\"$gest_prog_2?funzione=M&$link&tabella=stn\"onClick=\"javascript:return(confirm('Confermi accesso alla gestione di una dichiarazione sostitutiva che storni la presente?'))\" class=\"link-button-2\">Ins. mod. sost.</a></td>
    <td align=center>&nbsp;<a href=\"coimdimp-ricmot-storno?$link\"onClick=\"javascript:return(confirm('Confermi richiesta?'))\" class=\"link-button-2\">Richiedi storno</a></td>
"
	};#rom11
    };#sim02

    if {$ruolo != "manutentore" && $ruolo != "ammin"} {
	
	#sim02 append azioni_aggiuntive "
        #sim02 <td align=center>&nbsp;<a href=\"coimdimp-acc-storno?$link\"onClick=\"javascript:return(confirm('Confermi accettazione storno?'))\">Accetta storno</a></td>"
        
	append azioni_aggiuntive "
        <td align=center nowrap>&nbsp;<a href=\"coimdimp-rif-storno?$link\"onClick=\"javascript:return(confirm('Confermi rifiuto storno?'))\" class=\"link-button-2\">Rifiuta storno</a></td>
        "
    }
}

append azioni_aggiuntive "</tr></table></td>"

#rom01 aggiunto [list link_stato_dich_code ""               no_sort {c}]
set table_def [list \
		   [list actions             "Azioni"          no_sort $actions] \
		   [list cod_dimp            "Cod.Int."        no_sort {c}] \
		   [list data_controllo_edit "Data"            no_sort {c}] \
		   [list desc_manutentore    "Manut."          no_sort {l}] \
		   [list desc_responsabile   "Resp."           no_sort {l}] \
		   [list flag_status         "Esito"           no_sort {c}] \
		   [list flag_tracciato_edit "Tipo"            no_sort {c}] \
		   [list cod_docu_distinta   "Distinta"        no_sort {c}] \
		   [list riferimento_pag     "Att.Pagam."      no_sort {c}] \
		   [list stato_storno        " "               no_sort {c}] \
		   [list link_stato_dich_code ""               no_sort {c}] \
		   [list azioni_aggiuntive   "Altre Azioni"    no_sort $azioni_aggiuntive] \
		  ]


# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(c.cognome) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_dimp]} {
    set data_controllo [lindex $last_cod_dimp 0]
    set cod_dimp       [lindex $last_cod_dimp 1]
    
    #nic01 set where_last " and (  (   a.data_controllo = :data_controllo 
    #nic01                  --sim01 or a.cod_dimp      >= :cod_dimp)
    #nic01                         and a.cod_dimp      >= :cod_dimp) --sim01
    #nic01                       or    a.data_controllo > :data_controllo)"

    set where_last " and (  (    a.data_controllo  = :data_controllo 
                             and a.cod_dimp       <= :cod_dimp)
                          or     a.data_controllo <  :data_controllo)";#nic01

} else {
    set where_last ""
}

# imposto filtro per impianto
if {![string is space $cod_impianto]} {
    set where_aimp "and a.cod_impianto = :cod_impianto"
} else {
    set where_aimp ""
}

set sel_dimp [db_map sel_dimp]

#sim01 aggiunto data_controllo altrimenti la pagina andava in errore 
set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_dimp data_controllo cod_impianto last_cod_dimp nome_funz nome_funz_caller extra_par url_list_aimp url_aimp flag_tracciato} go $sel_dimp $table_def]

# preparo url escludendo last_cod_dimp che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_dimp]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
# sim01: Visto che nella lista c'è un <tr>, devo cercare "<tr " e non <tr.
# sim01 set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
set ctr_rec [expr [regsub -all "<tr " $table_result "<tr " comodo] -1];#sim01

if {$ctr_rec == $rows_per_page} {
    #sim01 set last_cod_dimp [list data_controllo cod_dimp]
    set last_cod_dimp [list $data_controllo $cod_dimp];#sim01
    append url_vars "&[export_url_vars last_cod_dimp]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

if {$cod_manu ne ""} {#rom12 Aggiunta if e il suo contenuto
    if {![db_0or1row q "select 1
                          from coimaimp
                         where cod_impianto = :cod_impianto
                           and ( cod_manutentore  = :cod_manu
                              or cod_installatore = :cod_manu)"]} {
	set link_aggiungi ""
    }
}


# creo testata della lista
#rom16 tolto link_aggiungi e sostituito con ""
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              "" $link_altre_pagine $link_righe "Righe per pagina"]


if {$flag_sup == "S"} {
    ##lista allegati
    set link    "\[export_url_vars cod_nove cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par \]"
    set actions2 "<td nowrap><a href=\"coimnove-gest?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
    set js_function ""
    
    # imposto la struttura della tabella
    set table_def2 [list \
			[list actions             "Azioni"                  no_sort $actions2] \
			[list cod_nove            "Progressivo"             no_sort {l}] \
			[list data_consegna       "Data consegna"           no_sort {c}] \
			[list desc_manu           "Manutentore"             no_sort {l}] \
		       ]
    
    set sel_nove [db_map sel_nove]
    
    set table_result2 [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_nove cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp} go $sel_nove $table_def2]


    ##lista allegati
    set link    "\[export_url_vars cod_noveb cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par \]"
    set actions3 "<td nowrap><a href=\"coimnoveb-gest?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
    set js_function ""
    
    # imposto la struttura della tabella
    set table_def3 [list \
			[list actions             "Azioni"                  no_sort $actions3] \
			[list cod_noveb           "Progressivo"             no_sort {l}] \
			[list data_consegna       "Data consegna"           no_sort {c}] \
			[list desc_manu           "Manutentore"             no_sort {l}] \
		       ]

    set where_noveb "";#sim14

    if {$coimtgen(regione) eq "MARCHE"} {#sim14 if e suo contenuto
	set where_noveb "and flag_tracciato is null"
    }
    
    set sel_noveb [db_map sel_noveb]
    
    set table_result3 [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_noveb cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp} go $sel_noveb $table_def3]


}

#inizio gestione allegati 284 e 286 regione
if {$coimtgen(regione) eq "MARCHE" && $flag_sup == "S"} {#sim14 if e suo contenuto
    
    ##lista allegati 284
    set link    "\[export_url_vars cod_noveb cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par \]"
    set actions_284 "<td nowrap><a href=\"coimnove-284-gest?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
        
    # imposto la struttura della tabella
    set table_def_284 [list \
			[list actions             "Azioni"                  no_sort $actions_284] \
			[list cod_noveb           "Progressivo"             no_sort {l}] \
			[list data_consegna       "Data consegna"           no_sort {c}] \
			[list desc_manu           "Manutentore/soggetto responsabile"             no_sort {l}] \
		       ]
    
    set sel_noveb_284 "
                   select a.cod_noveb
                        , iter_edit_data(a.data_consegna) as data_consegna
                        , coalesce(coalesce(b.cognome,c.cognome),'') ||' '|| coalesce(coalesce(b.nome,c.nome),'') as desc_manu
                     from coimnoveb a
          left outer join coimmanu  b 
                       on b.cod_manutentore = a.cod_manutentore
          left outer join coimcitt c
                       on a.cod_manutentore = c.cod_cittadino
                    where a.cod_impianto = :cod_impianto
                      and a.flag_tracciato    = '284'
                 order by a.data_consegna desc
                        , a.cod_noveb desc"
    
    set table_result_284 [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_noveb cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp} go $sel_noveb_284 $table_def_284]

    ##lista allegati 286
    set link    "\[export_url_vars cod_noveb cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par \]"
    set actions_286 "<td nowrap><a href=\"coimnove-286-gest?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
        
    # imposto la struttura della tabella
    set table_def_286 [list \
			[list actions             "Azioni"                  no_sort $actions_286] \
			[list cod_noveb           "Progressivo"             no_sort {l}] \
			[list data_consegna       "Data consegna"           no_sort {c}] \
			[list desc_manu           "Manutentore/soggetto responsabile"             no_sort {l}] \
		       ]
    
    set sel_noveb_286 "
                 select a.cod_noveb
                        , iter_edit_data(a.data_consegna) as data_consegna
                        , coalesce(coalesce(b.cognome,c.cognome),'') ||' '|| coalesce(coalesce(b.nome,c.nome),'') as desc_manu
                     from coimnoveb a
          left outer join coimmanu  b 
                       on b.cod_manutentore = a.cod_manutentore
          left outer join coimcitt c
                       on a.cod_manutentore = c.cod_cittadino
                    where a.cod_impianto    = :cod_impianto
                      and a.flag_tracciato    = '286'
                 order by a.data_consegna desc
                        , a.cod_noveb desc"
    
    set table_result_286 [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_noveb cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp} go $sel_noveb_286 $table_def_286]
    
}
#fine gestione allegati 284 e 286 regione



if {$sw_dichiarazioni_frequenza eq "t"} {#ant01: aggiunta if ed il suo contenuto
    # Lista delle dichiarazioni di frequenza ed elenco operazioni di controllo
    set link "\[export_url_vars cod_dope_aimp cod_impianto url_list_aimp url_aimp last_cod_dimp nome_funz nome_funz_caller extra_par \]"
    set actions4 "<td nowrap><a href=\"coimdope-aimp-gest?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
    
    set table_def4 [list \
			[list actions        "Azioni"       no_sort $actions4] \
			[list cod_dope_aimp  "Cod.Int."     no_sort {r}] \
			[list data_dich      "Data Dich."   no_sort {c}] \
			[list desc_manu      "Manutentore"  no_sort {l}] \
			[list tipo_dich      "Tipo Dich."   no_sort {l}] \
		       ]

    set table_result4 [ad_table \
			   -Tmax_rows $rows_per_page \
			   -Tmissing_text "Nessun dato corrisponde ai criteri impostati." \
			   -Textra_vars {cod_dope_aimp cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp} \
			   go [db_map sel_coimdope] \
			   $table_def4]
} 

db_release_unused_handles
ad_return_template 
