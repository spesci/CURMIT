ad_page_contract {
    Lista tabelle accessorie per varie pagine del libretto di impianto

    @author          Gabriele Lo Vaglio - clonato da coimdimp-list
    @creation-date   30/06/2016
 
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================================
    but01 19/07/2023 Aggiunto class"link-button-2" nel actions"Selez"

    rom08 14/11/2022 Aggiunti link per schede 14.1 e 14.2, Sandro ha detto che possono essere visti da tutti gli enti.
    
    rom07 27/05/2022 Su richiesta di Giuliodori con mail "scheda 6 impianti misti/ibridi" del 18/05/2022 avvalata
    rom07            da Sandro se un impianto e' collegato ad un altro principale tramite il flag_ibrido la scheda
    rom07            6 e' inibita e si vedra' un messaggio che porta alla scheda 6 dell'impianto ibrido principale.

    rom06 30/03/2022 MEV Regione Marche per sistemi ibridi. Se sono un impianto ibrido associato ad un altro
    rom06            impianto ibrido "principale" e uno dei flag is_coimaccu_aimp_unici, is_coimscam_calo_aimp_unici
    rom06            o is_coimrecu_calo_aimp_unici sono stati valorizzati 'N' nella scheda 1 allora non si deve
    rom06            poter vedere/inserire i dati relativi alle schede 8, 9.3 e 9.6; al loro posto vedro' dei
    rom06            messaggi che spiegano che i dati relativi alla schede 8, 9.3 e 9.6 vanno visualizzati
    rom06            dall'impianto ibrido principale.

    rom05 16/11/2021 Aggiunti i link per schede 14.3 e 14.4: Sviluppate su richiesta di Regione
    rom05            Marche ma Sandro ha detto di renderle disponibili per tutti.
    
    rom04 21/12/2018 Le Marche non vedono più il campo portata_term_min per la Scheda 4.3

    gac01 11/12/2018 Modificati link: veniva messa una parentesi quadra ] nel link e perciò
    gac01            andava in errore quando si tornava su lista impianti. Corretto.

    rom03 08/11/2018 Aggiunti campi flag_sostituito e data_installaz_nuova_conf nella
    rom03            "Scheda 4.7: Campi Solari termici".

    rom02 04/09/2018 Aggiunto il campo flag_sostituito alle tabelle che hanno il campo "Data dismissione"

    rom01            Aggiunti link per "coimaimp-tratt-acqua-gest" "coimaimp-regol-contab-gest" 
    rom01            "coimaimp-sist-distribuz-gest" "coimaimp-sist-emissione-gest"

} { 
    
    {caller            "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {receiving_element ""}
    cod_impianto
    {url_aimp      ""}
    {url_list_aimp ""}
    
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

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title  "Altre schede"

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

iter_get_coimtgen;#rom04

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog_trat_acq  "coimaimp-tratt-acqua-gest"    ;#rom01
set gest_prog           "coimrecu-cond-aimp-gest"
set gest_prog_2         "coimcamp-sola-aimp-gest"
set gest_prog_3         "coimaltr-gend-aimp-gest"
set gest_prog_reg_cont  "coimaimp-regol-contab-gest"   ;#rom01
set gest_prog_sist_dist "coimaimp-sist-distribuz-gest" ;#rom01
set gest_prog_sist_emis "coimaimp-sist-emissione-gest" ;#rom01
set gest_prog_4         "coimaccu-aimp-gest"
set gest_prog_5         "coimtorr-evap-aimp-gest"
set gest_prog_6         "coimraff-aimp-gest"
set gest_prog_7         "coimscam-calo-aimp-gest"
set gest_prog_8         "coimcirc-inte-aimp-gest"
set gest_prog_9         "coimtrat-aria-aimp-gest"
set gest_prog_10        "coimrecu-calo-aimp-gest"
set gest_prog_11        "coimvent-aimp-gest"
set gest_prog_12        "coimcons-acqua-rein-gest"  ;#rom05
set gest_prog_13        "coimcons-prod-chimici-gest";#rom05
set gest_prog_14        "coimcons-comb-gest";#rom08
set gest_prog_15        "coimcons-elet-gest";#rom08


set link_sbagliati {#gac01 link errati in quanto hanno una parentesi quadra messa a caso
set url_vars_per_coimaimp_gest_e_list [export_url_vars cod_impianto nome_funz nome_funz_caller caller cod_impianto_url_aimp url_list_aimp]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_2 "<a href=\"$gest_prog_2?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_3 "<a href=\"$gest_prog_3?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_4 "<a href=\"$gest_prog_4?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_5 "<a href=\"$gest_prog_5?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_6 "<a href=\"$gest_prog_6?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_7 "<a href=\"$gest_prog_7?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_8 "<a href=\"$gest_prog_8?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_9 "<a href=\"$gest_prog_9?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_10 "<a href=\"$gest_prog_10?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"
set link_aggiungi_11 "<a href=\"$gest_prog_11?funzione=I&$url_vars_per_coimaimp_gest_e_list]\">Aggiungi</a>"


set link_modifica     "<a href=\"$gest_prog_trat_acq?funzione=V&$url_vars_per_coimaimp_gest_e_list]\">Modifica</a>"  ;#rom01
set link_modifica_2   "<a href=\"$gest_prog_reg_cont?funzione=V&$url_vars_per_coimaimp_gest_e_list]\">Modifica</a>"  ;#rom01
set link_modifica_3   "<a href=\"$gest_prog_sist_dist?funzione=V&$url_vars_per_coimaimp_gest_e_list]\">Modifica</a>" ;#rom01
set link_modifica_4   "<a href=\"$gest_prog_sist_emis?funzione=V&$url_vars_per_coimaimp_gest_e_list]\">Modifica</a>" ;#rom01
};#gac01

if {$coimtgen(regione) in [list "MARCHE"]} {#rom06 Aggiunte if, else e il loro contenuto
    if {![db_0or1row q "select a.cod_impianto_est   as cod_impianto_est_ibrido_princ
                             , a.cod_impianto       as cod_impianto_princ
                             , i.is_coimaccu_aimp_unici
                             , i.is_coimscam_calo_aimp_unici
                             , i.is_coimrecu_calo_aimp_unici
                          from coimaimp_ibrido i
                     left join coimaimp        a
                            on a.cod_impianto                  = i.cod_impianto_princ
                         where i.cod_impianto_ibrido           = :cod_impianto
                           and ( i.is_coimaccu_aimp_unici      = 'S'
                              or i.is_coimscam_calo_aimp_unici = 'S'
                              or i.is_coimrecu_calo_aimp_unici = 'S')" ]} {

	set cod_impianto_est_ibrido_princ ""
	set cod_impianto_princ            ""
	set is_coimaccu_aimp_unici        ""
	set is_coimscam_calo_aimp_unici   ""
	set is_coimrecu_calo_aimp_unici   ""
    }

} else {

    set cod_impianto_est_ibrido_princ ""
    set cod_impianto_princ            ""
    set is_coimaccu_aimp_unici        ""
    set is_coimscam_calo_aimp_unici   ""
    set is_coimrecu_calo_aimp_unici   ""
}

set url_vars_per_coimaimp_gest_e_list [export_url_vars cod_impianto nome_funz nome_funz_caller caller cod_impianto_url_aimp url_list_aimp]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
set link_aggiungi_2 "<a href=\"$gest_prog_2?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
set link_aggiungi_3 "<a href=\"$gest_prog_3?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"

if {[string equal $is_coimaccu_aimp_unici "S"]} {#rom06 Aggiunta if e il suo contenuto

    set link_aggiungi_4 "Nella scheda 1 i sistemi di accumulo sono stati indicati unici all'impianto ibrido principale con codice $cod_impianto_est_ibrido_princ a cui questo impianto &egrave; collegato.<br>Per visualizzare/modificare i dati della scheda 8 dell'impianto ibrido principale <a href=\"#\" onclick=\"javascript:window.open('coimaimp-altre-schede-list?[export_vars -url {{cod_impianto $cod_impianto_princ} caller {nome_funz impianti}}]', 'scrollbars=yes, resizable=yes')\">clicca qui</a>."
    set missing_text_4 ""
    set vis_table_4    "f"
} else {#rom06 Aggiunta else ma non il suo contenuto
    set link_aggiungi_4 "<a href=\"$gest_prog_4?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
    set missing_text_4 "Non &egrave; presente nessun Accumulo.";#rom06
    set vis_table_4    "t";#rom06
};#rom06

set link_aggiungi_5 "<a href=\"$gest_prog_5?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
set link_aggiungi_6 "<a href=\"$gest_prog_6?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"

if {[string equal $is_coimscam_calo_aimp_unici "S"]} {#rom06 Aggiunta if e il suo contenuto

    set link_aggiungi_7 "Nella scheda 1 i scambiatori di calore intermedi sono stati indicati unici all'impianto ibrido principale con codice $cod_impianto_est_ibrido_princ a cui questo impianto &egrave; collegato.<br>Per visualizzare/modificare i dati della scheda 9.3 dell'impianto ibrido principale <a href=\"#\" onclick=\"javascript:window.open('coimaimp-altre-schede-list?[export_vars -url {{cod_impianto $cod_impianto_princ} caller {nome_funz impianti}}]', 'scrollbars=yes, resizable=yes')\">clicca qui</a>."
    set missing_text_7 ""
    set vis_table_7    "f"

} else {#rom06 Aggiunta else ma non il suo contenuto
    set link_aggiungi_7 "<a href=\"$gest_prog_7?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
    set missing_text_7  "Non &egrave; presente nessuno Scambiatore di Calore Intermedio.";#rom06
    set vis_table_7     "t";#rom06
};#rom06

set link_aggiungi_8 "<a href=\"$gest_prog_8?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
set link_aggiungi_9 "<a href=\"$gest_prog_9?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"

if {[string equal $is_coimrecu_calo_aimp_unici "S"]} {#rom06 Aggiunta if e il suo contenuto

    set link_aggiungi_10 "Nella scheda 1 i recuperatori di calore sono stati indicati unici all'impianto ibrido principale con codice $cod_impianto_est_ibrido_princ a cui questo impianto &egrave; collegato.<br>Per visualizzare/modificare i dati della scheda 9.6 dell'impianto ibrido principale <a href=\"#\" onclick=\"javascript:window.open('coimaimp-altre-schede-list?[export_vars -url {{cod_impianto $cod_impianto_princ} caller {nome_funz impianti}}]', 'scrollbars=yes, resizable=yes')\">clicca qui</a>."
    set missing_text_10 ""
    set vis_table_10    "f"
} else {#rom06 Aggiunta else ma non il suo contenuto
    set link_aggiungi_10 "<a href=\"$gest_prog_10?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
    set missing_text_10  "Non &egrave; presente nessun recuperatore di calore.";#rom06
    set vis_table_10     "t";#rom06
};#rom06

set link_aggiungi_11 "<a href=\"$gest_prog_11?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
set link_aggiungi_12 "<a href=\"$gest_prog_12?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>";#rom05
set link_aggiungi_13 "<a href=\"$gest_prog_13?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>";#rom05
set link_aggiungi_14 "<a href=\"$gest_prog_14?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>";#rom08
set link_aggiungi_15 "<a href=\"$gest_prog_15?funzione=I&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>";#rom08



set link_modifica     "<a href=\"$gest_prog_trat_acq?funzione=V&$url_vars_per_coimaimp_gest_e_list\">Modifica</a>"  ;#rom01
set link_modifica_2   "<a href=\"$gest_prog_reg_cont?funzione=V&$url_vars_per_coimaimp_gest_e_list\">Modifica</a>"  ;#rom01

if {[db_0or1row q "select case a.flag_ibrido
                          when 'S' then 'Sistema Ibrido'
                          when 'G' then 'Generatore misti'
                          else ''  end as flag_ibrido_edit
                        , a.cod_impianto_est as cod_impianto_est_ibrido_princ_6
                     from coimaimp_ibrido i
                     left join coimaimp a on a.cod_impianto = i.cod_impianto_princ
                    where i.cod_impianto_ibrido = :cod_impianto"]} {#rom07 Aggiunta if e il suo contenuto
    
    set link_modifica_3   "Nella scheda 1 l'impianto &egrave; stato indicato come  $flag_ibrido_edit collegato all'impianto principale con codice $cod_impianto_est_ibrido_princ_6.<br>Per visualizzare/modificare i dati della scheda 6 dell'impianto ibrido principale <a href=\"#\" onclick=\"javascript:window.open('coimaimp-altre-schede-list?[export_vars -url {{cod_impianto $cod_impianto_princ} caller {nome_funz impianti}}]', 'scrollbars=yes, resizable=yes')\">clicca qui</a>."
    
} else {#rom07 Aggiunta else ma non tutto il suo contenuto

set link_modifica_3   "<a href=\"$gest_prog_sist_dist?funzione=V&$url_vars_per_coimaimp_gest_e_list\">Modifica</a>" ;#rom01
    
};#rom07

set link_modifica_4   "<a href=\"$gest_prog_sist_emis?funzione=V&$url_vars_per_coimaimp_gest_e_list\">Modifica</a>" ;#rom01

#set link_trat_acq "\export_url_vars "
set link    "\[export_url_vars cod_recu_cond_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_2  "\[export_url_vars cod_camp_sola_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_3  "\[export_url_vars cod_altr_gend_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_4  "\[export_url_vars cod_accu_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_5  "\[export_url_vars cod_torr_evap_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_6  "\[export_url_vars cod_raff_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_7  "\[export_url_vars cod_scam_calo_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_8  "\[export_url_vars cod_circ_inte_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_9  "\[export_url_vars cod_trat_aria_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_10  "\[export_url_vars cod_recu_calo_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_11 "\[export_url_vars cod_vent_aimp\]&$url_vars_per_coimaimp_gest_e_list"
set link_12 "\[export_url_vars cons_acqua_rein_id\]&$url_vars_per_coimaimp_gest_e_list";#rom05
set link_13 "\[export_url_vars cons_prod_chimici_id\]&$url_vars_per_coimaimp_gest_e_list";#rom05
set link_14 "\[export_url_vars cons_comb_id\]&$url_vars_per_coimaimp_gest_e_list";#rom08
set link_15 "\[export_url_vars cons_elet_id\]&$url_vars_per_coimaimp_gest_e_list";#rom08

#but01 Aggiunto class"link-button-2" nel actions"Selez" 
set actions     "<td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\" link-button-2\">Selez.</a>"
set actions_2 "<td nowrap><a href=\"$gest_prog_2?funzione=V&$link_2\" class=\" link-button-2\">Selez.</a>"
set actions_3 "<td nowrap><a href=\"$gest_prog_3?funzione=V&$link_3\" class=\" link-button-2\">Selez.</a>"
set actions_4 "<td nowrap><a href=\"$gest_prog_4?funzione=V&$link_4\" class=\" link-button-2\">Selez.</a>"
set actions_5 "<td nowrap><a href=\"$gest_prog_5?funzione=V&$link_5\" class=\" link-button-2\">Selez.</a>"
set actions_6 "<td nowrap><a href=\"$gest_prog_6?funzione=V&$link_6\" class=\" link-button-2\">Selez.</a>"
set actions_7 "<td nowrap><a href=\"$gest_prog_7?funzione=V&$link_7\" class=\" link-button-2\">Selez.</a>"
set actions_8 "<td nowrap><a href=\"$gest_prog_8?funzione=V&$link_8\" class=\" link-button-2\">Selez.</a>"
set actions_9 "<td nowrap><a href=\"$gest_prog_9?funzione=V&$link_9\" class=\" link-button-2\">Selez.</a>"
set actions_10 "<td nowrap><a href=\"$gest_prog_10?funzione=V&$link_10\" class=\" link-button-2\">Selez.</a>"
set actions_11 "<td nowrap><a href=\"$gest_prog_11?funzione=V&$link_11\" class=\" link-button-2\">Selez.</a>"
set actions_12 "<td nowrap><a href=\"$gest_prog_12?funzione=V&$link_12\" class=\" link-button-2\">Selez.</a>";#rom05
set actions_13 "<td nowrap><a href=\"$gest_prog_13?funzione=V&$link_13\" class=\" link-button-2\">Selez.</a>";#rom05
set actions_14 "<td nowrap><a href=\"$gest_prog_14?funzione=V&$link_14\" class=\" link-button-2\">Selez.</a>";#rom08
set actions_15 "<td nowrap><a href=\"$gest_prog_15?funzione=V&$link_15\" class=\" link-button-2\">Selez.</a>";#rom08

if {$coimtgen(regione) ne "MARCHE"} {#rom04 if, else e loro contenuto: le Marche non vedono più il campo portata_term_min
    #rom02 Aggiunto flag_sostituito
    set table_def [list \
		   [list actions                "Azioni"                    no_sort $actions] \
		   [list num_rc                 "Num"                       no_sort {l}] \
		   [list data_installaz         "Data Installazione"        no_sort {c}] \
		   [list data_dismissione       "Data Dismissione"          no_sort {c}] \
		   [list flag_sostituito        "Sostituito"                no_sort {c}] \
		   [list descr_cost             "Costruttore"               no_sort {l}] \
		   [list modello                "Modello"                   no_sort {l}] \
		   [list matricola              "Matricola"                 no_sort {l}] \
		   [list portata_term_max       "Port. termica<br>max nom." no_sort {c}] \
		   [list portata_term_min       "Port. termica<br>min nom." no_sort {c}] \
		  ]
} else {
    set table_def [list \
		   [list actions                "Azioni"                    no_sort $actions] \
		   [list num_rc                 "Num"                       no_sort {l}] \
		   [list data_installaz         "Data Installazione"        no_sort {c}] \
		   [list data_dismissione       "Data Dismissione"          no_sort {c}] \
		   [list flag_sostituito        "Sostituito"                no_sort {c}] \
		   [list descr_cost             "Costruttore"               no_sort {l}] \
		   [list modello                "Modello"                   no_sort {l}] \
		   [list matricola              "Matricola"                 no_sort {l}] \
		   [list portata_term_max       "Port. termica<br>max nom." no_sort {c}] \
		  ]
};#rom04

#rom03 Aggiunto flag_sostituito e data_installaz_nuova_conf
set table_def_2 [list \
		     [list actions_2            "Azioni"                    no_sort $actions_2] \
		     [list num_cs               "Num"                       no_sort {l}] \
		     [list data_installaz       "Data Installazione"        no_sort {c}] \
		     [list data_installaz_nuova_conf "Data Installazione nuova configurazione" no_sort {c}] \
		     [list flag_sostituito        "Sostituito"                no_sort {c}] \
		     [list descr_cost           "Costruttore"               no_sort {l}] \
		     [list collettori           "Collettori"                no_sort {c}] \
		     [list sup_totale           "Sup. Totale"               no_sort {c}] \
		]
#rom02 aggiunto flag_sostituito
set table_def_3 [list \
		     [list actions_3            "Azioni"                    no_sort $actions_3] \
		     [list num_ag               "Num"                       no_sort {l}] \
		     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
		     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
		     [list matricola            "Matricola"                 no_sort {l}] \
		     [list tipologia            "Tipologia"                 no_sort {l}] \
                     [list potenza_utile        "Potenza utile"             no_sort {c}] \
		    ]
#rom02 aggiunto flag_sostituito
set table_def_4 [list \
                     [list actions_4            "Azioni"                    no_sort $actions_4] \
                     [list num_ac               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
                     [list matricola            "Matricola"                 no_sort {l}] \
                     [list capacita             "Capacit&agrave"            no_sort {r}] \
                     [list utilizzo             "Utilizzo"                  no_sort {l}] \
                     [list coibentazione        "Coibentazione"             no_sort {c}] \
		     ]
#rom02 aggiunto flag_sostituito
set table_def_5 [list \
                     [list actions_5            "Azioni"                    no_sort $actions_5] \
                     [list num_te               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
                     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
                     [list matricola            "Matricola"                 no_sort {l}] \
                     [list capacita             "Capacit&agrave"            no_sort {r}] \
                     [list num_ventilatori      "Num. Ventilatori"          no_sort {r}] \
                     [list tipi_ventilatori     "Tipo Ventilatori"          no_sort {l}] \
                     ]
#rom02 aggiunto flag_sostituito
set table_def_6 [list \
                     [list actions_6            "Azioni"                    no_sort $actions_6] \
                     [list num_rv               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
                     [list matricola            "Matricola"                 no_sort {l}] \
                     [list num_ventilatori      "Num. Ventilatori"          no_sort {r}] \
                     [list tipi_ventilatori     "Tipo Ventilatori"          no_sort {l}] \
                     ]
#rom02 aggiunto flag_sostituito
set table_def_7 [list \
                     [list actions_7            "Azioni"                    no_sort $actions_7] \
                     [list num_sc               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
                     ]
#rom02 aggiunto flag_sostituito
set table_def_8 [list \
                     [list actions_8            "Azioni"                    no_sort $actions_8] \
                     [list num_ci               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list lunghezza            "Lunghezza"                 no_sort {r}] \
                     [list superficie           "Superficie"                no_sort {r}] \
                     [list profondita           "Profondit&agrave;"         no_sort {r}] \
                     ]
#rom02 aggiunto flag_sostituito
set table_def_9 [list \
                     [list actions_9            "Azioni"                    no_sort $actions_9] \
                     [list num_ut               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
                     [list data_dismissione     "Data Dismissione"          no_sort {c}] \
		     [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list descr_cost           "Costruttore"               no_sort {l}] \
                     [list modello              "Modello"                   no_sort {l}] \
                     [list matricola            "Matricola"                 no_sort {l}] \
		     		 [list portata_mandata      "Port. ventilatore<br> di mandata " no_sort {c}] \
                     [list potenza_mandata      "Pot. ventilatore<br> di mandata" no_sort {c}] \
                     [list portata_ripresa      "Port. ventilatore<br> di ripresa " no_sort {c}] \
                     [list potenza_ripresa      "Pot. ventilatore<br> di ripresa" no_sort {c}] \
                     ]
#rom02 ggiunto flag_sostituito
set table_def_10 [list \
                     [list actions_10           "Azioni"                    no_sort $actions_10] \
                     [list num_rc               "Num"                       no_sort {l}] \
                     [list data_installaz       "Data Installazione"        no_sort {c}] \
		     [list data_dismissione     "Data Dismissione"         no_sort {c}] \
		      [list flag_sostituito      "Sostituito"                no_sort {c}] \
                     [list tipologia            "Tipologia"                 no_sort {l}] \
                     [list installato_uta_vmc   "Installato in U.T.A. o V.M.C." no_sort {l}] \
                     [list indipendente         "Indipendente"               no_sort {l}] \
                     [list portata_mandata      "Port. ventilatore<br> di mandata " no_sort {c}] \
                     [list potenza_mandata      "Pot. ventilatore<br> di mandata" no_sort {c}] \
                     [list portata_ripresa      "Port. ventilatore<br> di ripresa " no_sort {c}] \
                     [list potenza_ripresa      "Pot. ventilatore<br> di ripresa" no_sort {c}] \
                     ]
					 

					 
					 
					 
#rom02 aggiunto flag_sostituito
set table_def_11 [list \
		      [list actions_11           "Azioni"                    no_sort $actions_11] \
		      [list num_vm               "Num"                       no_sort {l}] \
		      [list data_installaz       "Data Installazione"        no_sort {c}] \
		      [list data_dismissione     "Data Dismissione"         no_sort {c}] \
		      [list flag_sostituito      "Sostituito"                no_sort {c}] \
		      [list descr_cost           "Costruttore"               no_sort {l}] \
		      [list modello              "Modello"                   no_sort {l}] \
		      [list tipologia            "Tipologia"                 no_sort {l}] \
		      [list note_tipologia_altro "Altro"                     no_sort {l}] \
		      [list portata_aria         "Massima Portata Aria"              no_sort {c}] \
		      [list rendimento_rec       "Rendimento di recupero / COP"              no_sort {c}] \
                     ]
					 
set table_def_12 [list \
		      [list actions_12      "Azioni"                    no_sort $actions_12] \
		      [list esercizio       "Esercizio"                 no_sort {c}] \
		      [list lett_iniziale   "Lettura Iniziale"          no_sort {c}] \
		      [list lett_finale     "Lettura Finale"            no_sort {c}] \
		      [list consumo_tot     "Consumo Totale"            no_sort {c}] \
		     ];#rom05

set table_def_13 [list \
		      [list actions_13        "Azioni"                     no_sort $actions_13] \
		      [list esercizio         "Esercizio"                  no_sort {c}] \
		      [list circ_imp_term     "Circuito Impianto Termico"  no_sort {c}] \
		      [list circ_acs          "Circuito ACS"               no_sort {c}] \
		      [list altri_circ_ausi   "Altri Circuiti Ausiliari"   no_sort {c}] \
		      [list nome_prodotto     "Nome Prodotto"              no_sort {c}] \
		      [list qta_cons          "Quantit&agrave; consumata"  no_sort {c}] \
		      [list unita_misura      "Unit&agrave; misura"        no_sort {c}] \
		     ];#rom05
					 
set table_def_14 [list \
		      [list actions_12         "Azioni"                    no_sort $actions_14] \
		      [list esercizio_comb     "Esercizio"                 no_sort {c}] \
		      [list acquisti_comb      "Acquisti"                  no_sort {c}] \
		      [list lett_iniziale_comb "Lettura Iniziale"          no_sort {c}] \
		      [list lett_finale_comb   "Lettura Finale"            no_sort {c}] \
		      [list consumo_tot_comb   "Consumo Totale"            no_sort {c}] \
		     ];#rom08
					 
set table_def_15 [list \
		      [list actions_15           "Azioni"                    no_sort $actions_15] \
		      [list esercizio_elet       "Esercizio"                 no_sort {c}] \
		      [list lett_iniziale_elet   "Lettura Iniziale"          no_sort {c}] \
		      [list lett_finale_elet     "Lettura Finale"            no_sort {c}] \
		      [list consumo_tot_elet     "Consumo Totale"            no_sort {c}] \
		     ];#rom08

set sel_recu_cond_aimp [db_map sel_recu_cond_aimp]
set sel_camp_sola_aimp [db_map sel_camp_sola_aimp]
set sel_altr_gend_aimp [db_map sel_altr_gend_aimp]
set sel_accu_aimp      [db_map sel_accu_aimp]
set sel_torr_evap_aimp [db_map sel_torr_evap_aimp]
set sel_raff_aimp      [db_map sel_raff_aimp]
set sel_scam_calo_aimp [db_map sel_scam_calo_aimp]
set sel_circ_inte_aimp [db_map sel_circ_inte_aimp]
set sel_trat_aria_aimp [db_map sel_trat_aria_aimp]
set sel_recu_calo_aimp [db_map sel_recu_calo_aimp]
set sel_vent_aimp      [db_map sel_vent_aimp]
set sel_cons_acqua_rein   [db_map sel_cons_acqua_rein];#rom05
set sel_cons_prod_chimici [db_map sel_cons_prod_chimici];#rom05
set sel_cons_comb [db_map sel_cons_comb];#rom08
set sel_cons_elet [db_map sel_cons_elet];#rom08

set table_result   [ad_table -Tmissing_text "Non &egrave; presente nessun Recuperatore/Condensatore." -Textra_vars {cod_recu_cond_aimp caller cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_recu_cond_aimp $table_def]

set table_result_2 [ad_table -Tmissing_text "Non &egrave; presente nessun Campo Solare." -Textra_vars {cod_camp_sola_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_camp_sola_aimp $table_def_2]

set table_result_3 [ad_table -Tmissing_text "Non &egrave; presente nessun Altro Generatore." -Textra_vars {cod_altr_gend_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_altr_gend_aimp $table_def_3]

if {$vis_table_4 eq "t"} {#rom06 Aggiunta if ma non il suo contenuto
    set table_result_4 [ad_table -Tmissing_text $missing_text_4 -Textra_vars {cod_accu_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_accu_aimp $table_def_4]
} else {#rom06 Aggiunta else e il suo conenuto
    set table_result_4 ""
}

set table_result_5 [ad_table -Tmissing_text "Non &egrave; presente nessuna Torre Evaporativa." -Textra_vars {cod_torr_evap_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_torr_evap_aimp $table_def_5]

set table_result_6 [ad_table -Tmissing_text "Non &egrave; presente nessun Raffreddatore di Liquido." -Textra_vars {cod_raff_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_raff_aimp $table_def_6]

if {$vis_table_7 eq "t"} {#rom06 Aggiunta if ma non il suo contenuto
    set table_result_7 [ad_table -Tmissing_text $missing_text_7 -Textra_vars {cod_raff_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_scam_calo_aimp $table_def_7]
} else {#rom06 Aggiunta else e il suo conenuto
    set table_result_7 ""
}
set table_result_8 [ad_table -Tmissing_text "Non &egrave; presente nessun Circuito Interrato a Condensazione/Espansione Diretta." -Textra_vars {cod_circ_inte_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_circ_inte_aimp $table_def_8]

set table_result_9 [ad_table -Tmissing_text "Non &egrave; presente nessun Unità di Trattamento Aria." -Textra_vars {cod_trat_aria_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_trat_aria_aimp $table_def_9]

if {$vis_table_10 eq "t"} {#rom06 Aggiunta if ma non il suo contenuto
    set table_result_10 [ad_table -Tmissing_text $missing_text_10 -Textra_vars {cod_recu_calo_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_recu_calo_aimp $table_def_10]
} else {#rom06 Aggiunta else e il suo conenuto
    set table_result_10 ""
}
set table_result_11 [ad_table -Tmissing_text "Non &egrave; presente nessun impianto di ventilazione." -Textra_vars {cod_vent_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_vent_aimp $table_def_11]

set table_result_12 [ad_table -Tmissing_text "Non &egrave; presente nessun consumo di acqua di reintegro nel circuito dell'impainto termico." -Textra_vars {cod_vent_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_cons_acqua_rein $table_def_12];#rom05

set table_result_13 [ad_table -Tmissing_text "Non &egrave; presente nessun consumo di prodotti chimici per il trattamento acqua del circuito dell'impianto termico." -Textra_vars {cod_vent_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_cons_prod_chimici $table_def_13];#rom05

set table_result_14 [ad_table -Tmissing_text "Non &egrave; presente nessun consumo di combustibile nel circuito  dell'impainto termico." -Textra_vars {cod_vent_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_cons_comb $table_def_14];#rom08

set table_result_15 [ad_table -Tmissing_text "Non &egrave; presente nessun consumo di combustibile nel circuito dell'impainto termico." -Textra_vars {cod_vent_aimp cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_cons_elet $table_def_15];#rom08


db_release_unused_handles
ad_return_template 
