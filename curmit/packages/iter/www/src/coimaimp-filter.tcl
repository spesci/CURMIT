ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   18/03/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, serve per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimaimp-filter.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    ric02 25/11/2024 MEV Regione Marche ordine 63/2022 riga 3

    but01 06/06/2023 Aggiunta classe 'ah-jquery-date' per la scelta della data col datepicker.

    ric01 09/06/2023 Aggiunti element per criteri aggiuntivi di ricerca impianti.
    
    rom06 13/01/2023 Sviluppo per Palermo Energia: aggiunto filro "Per Soggetto presente nello storico RCEE".

    rom05 05/05/2022 Per un caso segnalato da un ente di Regione Marche il campo f_matricola potrebbe
    rom05            contenere i caratteri < e > quindi devo trattare il campo come html altrimenti
    rom05            le proc di controllo di OpenAcs bloccano il programma.

    rom04 10/01/2022 Aggiunto nuovo campo di ricerca POD su segnealazione di Regione Marche.

    rom03 21/10/2020 Su segnalazione di Salerno modificato page_title per renderlo
    rom03            uguale al nome del menu', Sandro ha detto che va bene per tutti.

    rom02 08/03/2019 La Regione Marche ha richiesto la modifica dei filtri di ricerca di un Impianto.

    rom01 19/07/2018 Su richiesta di Sandro aggiunto un bottone che sbianca i filtri inseriti.

    gab01 25/07/2017 Se il flag_verifica_impianti è t l'amministratore avrà nella combo degli stati
    gab01            anche gli stati Da controllare e Respinto.

    sim02 06/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim02            visualizzo il campo targa e non il cod impianto princ.

    sim01 10/09/2014 Aggiunto nuovo campo cod_impianto_princ (e receiving_element)

} {
    
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {receiving_element    ""}
    {f_cod_impianto_est   ""}
    {f_cod_impianto_princ ""}
    {f_targa              ""}
    {f_resp_cogn          ""} 
    {f_resp_nome          ""} 
    {f_resp_cogn_rcee     ""} 
    {f_resp_nome_rcee     ""}
    
    {f_comune             ""}
    {f_quartiere          ""}

    {f_cod_via            ""}
    {f_desc_via           ""}
    {f_desc_topo          ""}
    {f_civico_da          ""}
    {f_civico_a           ""}

    {f_manu_cogn          ""}
    {f_manu_nome          ""}

    {f_data_mod_da        ""}
    {f_data_mod_a         ""}
    {f_utente             ""}

    {f_potenza_da         ""}
    {f_potenza_a          ""}
    {f_data_installaz_da  ""}
    {f_data_installaz_a   ""}
    {f_flag_dichiarato    ""}
    {f_stato_conformita   ""}
    {f_cod_combustibile   ""}
    {f_cod_cost           ""}
    {f_cod_tpim           ""}
    {f_cod_tpdu           ""}
    {f_stato_aimp         ""}
    {f_mod_h              ""}

    {f_dpr_412            ""}
    {f_cod_utenza         ""}
    {f_pod                ""}
    {f_cod_impianto_old   ""}
    {f_matricola:html     ""}
    {f_prov_dati          ""}
    {cerca_multivie       ""}
    {f_da_data_verifica   ""}
    {f_a_data_verifica    ""}
    {f_bollino            ""}
    {f_flag_tipo_impianto    ""}
    {f_impianto_inserito     ""}
    {f_impianto_modificato   ""}
    {f_soggetto_modificato   ""}
    {f_generatore_sostituito ""}

    {f_ibrido                ""}
    {f_pagato                ""}
    {f_tprc                  ""}
    {f_dich_conformita       ""}
    {f_dfm_manu              ""}
    {f_dfm_resp_mod          ""}
    
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}
#iter_blocca_doppio_click
# B80: RECUPERO LO USER - INTRUSIONE

set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-FILTER-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
#if {$id_utente != $id_utente_loggato_vero} {
#    set login [ad_conn package_url]
#    ns_log Notice "********AUTH-CHECK-FILTER-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#    return 0
#} else {
#    ns_log Notice "********AUTH-CHECK-FILTER-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#}
# ***

# Controlla lo user
if {![string is space $nome_funz]} {#sim01
    set lvl 1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {#sim01
    # se il filtro viene chiamato da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    set id_utente [iter_get_id_utente];#sim01
};#sim01

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# controllo se l'utente � un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# leggo l'utente e prendo il ruolo per vedere se admin
db_1row query "select id_ruolo from coimuten where id_utente = :id_utente"

# controllo se l'utente � un comune
set cod_comune_chk [iter_check_uten_comu $id_utente]
if {$cod_comune_chk ne ""} {
    set user_is_comu "T"
} else {
    set user_is_comu ""
}
# controllo se l'utente e' un ente verificatore o un verificatore
set cod_enve [iter_check_uten_enve $id_utente]
set cod_opve [iter_check_uten_opve $id_utente]

if {[string range $id_utente 0 1] == "AM"} {
    set cod_amministratore $id_utente
} else {
    set cod_amministratore ""
}

# Personalizzo la pagina
#rom03set titolo       "Selezione Impianti"
set titolo       "Estrazione singolo impianto per controllo";#rom03
set button_label "Seleziona"
set button_sbianca "Pulisci Ricerca";#rom01
#rom03set page_title   "Selezione Impianti"
set page_title "Estrazione singolo impianto per controllo";#rom03

iter_get_coimtgen
set flag_ente       $coimtgen(flag_ente)
set flag_viario     $coimtgen(flag_viario)
set cod_comune      $coimtgen(cod_comu)
set sigla_prov      $coimtgen(sigla_prov)
set flag_gest_targa $coimtgen(flag_gest_targa);#sim02

db_1row sel_flag_multi "select flag_multivie from coimtgen"

if {$caller == "index"} {#sim01
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 
} else {#sim01
    set context_bar [iter_context_bar \
			 [list "javascript:window.close()" "Torna alla Gestione"] \
			 "$page_title"];#sim01
};#sim01

if {[db_0or1row sel_stato_att ""] == 0} {
    set f_stato_aimp ""
} else {
    set f_stato_aimp $cod_imst
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set jq_date "";#but01
if {$funzione in "V M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
    -html    $onsubmit_cmd

element create $form_name f_cod_impianto_est \
    -label   "Codice impianto esterno" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
    -optional

if {$flag_gest_targa eq "F"} {#sim02: ho aggiunto solo l'if
    element create $form_name f_cod_impianto_princ \
	-label   "Codice impianto principale" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
	-optional;#sim01
    
    element create $form_name f_targa -widget hidden -datatype text -optional;#sim02

} else {#sim02: aggiunta else e suo contenuto

    element create $form_name f_targa \
	-label   "Targa" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 16 $readonly_fld {} class form_element tabindex 1" \
	-optional

    element create $form_name f_cod_impianto_princ -widget hidden -datatype text -optional

} 

element create $form_name f_resp_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 2" \
    -optional

element create $form_name f_resp_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 3" \
    -optional

set readonly_fld2 \{\};#rom06
#rom06
element create $form_name f_resp_cogn_rcee \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 2" \
    -optional
#rom06
element create $form_name f_resp_nome_rcee \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 3"\
    -optional

#ric01 inizio aggiunta criteri aggiuntivi di ricerca, li mostro solo per le Marche 
set options_ibrido "{{} {}} {\"Sistema ibrido\" S} {\"Unico generatore policombustibile\" P} {\"Generatori misti (con combustibili diversi)\" M} {\"Nessun collegamento con altri impianti\" N}"

element create $form_name f_ibrido \
    -label   "ibrido" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_ibrido

set options_fl_pagato [list "{} {}" "S&igrave; S" "{No, perchè non dovuto} N" "{No, per rifiuto del responsabile} C"]

element create $form_name f_pagato \
    -label   "Pagato" \
    -widget   select \
    -options  $options_fl_pagato\
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

set options_cod_tprc "[list \"\"] "

append options_cod_tprc [db_list_of_lists sel_lol "select substr(descr_tprc, 1, 42) as descr_tprc
                                                         , cod_tprc
                                                      from coimtprc"]

element create $form_name f_tprc \
    -label   "Tipo controllo" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element " \
    -optional \
    -options  $options_cod_tprc

#ric01 fine

if {$flag_ente == "P"} {
    if {$user_is_comu eq ""} {
	element create $form_name f_comune \
	    -label   "Comune" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element tabindex 4" \
	    -optional \
	    -options [iter_selbox_from_comu]
    } else {
	set disabled_comu "disabled"
	element create $form_name f_comune \
            -label   "Comune" \
            -widget   text \
            -datatype text \
            -html    "$disabled_comu {} class form_element tabindex 4" \
            -optional 
	element create $form_name cod_comune_chk -widget hidden -datatype text -value $cod_comune_chk
	element set_properties $form_name f_comune -value $id_utente
    }
} else {
    element create $form_name f_comune -widget hidden -datatype text -optional
    element create $form_name f_quartiere \
	-label   "Quartiere" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element tabindex 4" \
	-optional \
	-options [iter_selbox_from_table coimcqua cod_qua descrizione]
}

element create $form_name f_desc_topo \
    -label   "topos" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 5" \
    -optional \
    -options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name f_desc_via \
    -label   "Via" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element tabindex 6" \
    -optional


if {$flag_viario == "T"} {
    if {$user_is_comu eq ""} { 	
	set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_desc_via dummy f_desc_topo cod_comune f_comune dummy dummy dummy dummy]]
    } else {
	set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_desc_via dummy f_desc_topo cod_comune cod_comune_chk dummy dummy dummy dummy]]
    }
    regsub {<a href} $cerca_viae {<a tabindex=7 href} cerca_viae
} else {
    set cerca_viae ""
}

element create $form_name f_civico_da \
    -label   "Civico da" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld {} class form_element tabindex 8" \
    -optional

element create $form_name f_civico_a \
    -label   "Civico a" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld {} class form_element tabindex 9" \
    -optional

if {[string equal $cod_manutentore ""]} {
    set sw_manu "f"
    set readonly_fld2 \{\}
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
} else {
    set sw_manu "t"
    set readonly_fld2 "readonly"
    set cerca_manu ""
}

#ric02 inizio aggiunta criteri aggiuntivi di ricerca, li mostro solo per le Marche
element create $form_name f_dich_conformita \
    -label   "Dichiarazione Conformita" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {S&igrave; S} {No N}}

if {$sw_manu} {
    element create $form_name f_dfm_manu \
	-label   "DFM inserita da manutentore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element tabindex 57" \
	-optional \
	-options { {{} {}} {S&igrave; S} {No N}}

    element create $form_name f_dfm_resp_mod \
	-label   "DFM inserita per cambio responsabile" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element tabindex 57" \
	-optional \
	-options { {{} {}} {No N}}
    
} else {
    element create $form_name f_dfm_manu        -widget hidden -datatype text -optional
    element create $form_name f_dfm_resp_mod    -widget hidden -datatype text -optional
}
#ric02 fine

element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 10" \
    -optional

element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 11"\
    -optional

element create $form_name f_data_mod_da \
    -label   "Da data modifica" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
    -optional

element create $form_name f_data_mod_a \
    -label   "A data modifica" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 13 $jq_date" \
    -optional

element create $form_name f_utente \
    -label   "Utente di modifica" \
    -widget   select \
    -options  [iter_selbox_from_table coimuten id_utente id_utente] \
    -datatype text \
    -html    "class form_element tabindex 14" \
    -optional

element create $form_name f_potenza_da \
    -label   "Potenza da" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 51" \
    -optional

element create $form_name f_potenza_a \
    -label   "Potenza a" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 52" \
    -optional

element create $form_name f_data_installaz_da \
    -label   "data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 53 $jq_date" \
    -optional

element create $form_name f_data_installaz_a \
    -label   "data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 54 $jq_date" \
    -optional


element create $form_name f_flag_dichiarato \
    -label   "Stato dichiarazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 56" \
    -optional \
    -options { {{} {}} {S&igrave; S} {No N} {N.C. C}}

element create $form_name f_stato_conformita \
    -label   "Stato Conformita" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {S&igrave; S} {No N}}

element create $form_name f_cod_combustibile \
    -label   "combustibile" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 58" \
    -optional \
    -options [iter_selbox_from_table coimcomb cod_combustibile descr_comb cod_combustibile]

set l_of_l  [db_list_of_lists query "select descr_cost, cod_cost from coimcost order by descr_cost"]
set l_of_l  [linsert $l_of_l 0 [list "" ""]]

element create $form_name f_cod_cost \
    -label   "costruttore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 58" \
    -optional \
    -options $l_of_l

element create $form_name f_cod_tpim  \
    -label   "Tipologia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 59" \
    -optional \
    -options [iter_selbox_from_table coimtpim cod_tpim descr_tpim cod_tpim]

element create $form_name f_prov_dati \
    -label   "Provenienza dati" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtppr cod_tppr descr_tppr]

element create $form_name f_cod_tpdu \
    -label   "destinazione uso" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 60" \
    -optional \
    -options [iter_selbox_from_table coimtpdu cod_tpdu descr_tpdu cod_tpdu]

#gab01
if {$coimtgen(flag_verifica_impianti) eq "t"} {;#gab01 aggiunta if else e contenuto
    set where_stat ""
} else {
    set where_stat "where cod_imst != 'F' and cod_imst != 'E'"
}

#gab01 [iter_selbox_from_table coimimst cod_imst descr_imst cod_imst]
element create $form_name f_stato_aimp \
    -label   "stato dell'impianto" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 61" \
    -optional \
    -options [iter_selbox_from_table_wherec coimimst cod_imst descr_imst cod_imst $where_stat]

element create $form_name f_mod_h \
    -label   "Situazione Mod.G" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {{Non presente} 1} {Scaduto 2}}

element create $form_name f_dpr_412 \
    -label   "f_dpr_412" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {S&igrave; S} {No N}}

element create $form_name f_cod_utenza \
    -label   "f_cod_utenza" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
    -optional

#rom04 Aggiunto campo f_pod 
element create $form_name f_pod \
    -label   "POD" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
    -optional

element create $form_name f_cod_impianto_old \
    -label   "f_cod_impianto_old" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
    -optional

element create $form_name f_matricola \
    -label   "matricola" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 35 $readonly_fld {} class form_element" \
    -optional

element create $form_name cerca_multivie \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si S}}

element create $form_name f_da_data_verifica \
    -label   "Da data verifica" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name f_a_data_verifica \
    -label   "A data verifica" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name f_bollino \
-label   "Rif. bollino" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element " \
-optional
# inizio dpr74
element create $form_name f_flag_tipo_impianto \
    -label   "f_flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element " \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}

#rom02 
element create $form_name f_impianto_inserito \
    -label "Impianto inserito" \
    -widget select \
    -datatype text \
    -html "$disabled_fld {} class form_element " \
    -optional \
    -options { {No N} {Si S}}
#rom02
element create $form_name f_impianto_modificato \
    -label "Impianto modificato" \
    -widget select \
    -datatype text \
    -html "$disabled_fld {} class form_element " \
    -optional \
    -options { {No N} {Si S}}
#rom02
element create $form_name f_soggetto_modificato \
    -label "Soggetto Modificato" \
    -widget select \
    -datatype text \
    -html "$disabled_fld {} class form_element " \
    -optional \
    -options { {No N} {Si S}}
#rom02
element create $form_name f_generatore_sostituito \
    -label "Generatore modificato" \
    -widget select \
    -datatype text \
    -html "$disabled_fld {} class form_element " \
    -optional \
    -options { {No N} {Si S}}

# fine dpr74
element create $form_name f_cod_via         -widget hidden -datatype text -optional
element create $form_name f_cod_manu        -widget hidden -datatype text -optional
element create $form_name funzione          -widget hidden -datatype text -optional
element create $form_name caller            -widget hidden -datatype text -optional
element create $form_name nome_funz         -widget hidden -datatype text -optional
element create $form_name receiving_element -widget hidden -datatype text -optional;#sim01
element create $form_name dummy             -widget hidden -datatype text -optional
element create $form_name submit            -widget submit -datatype text -label "$button_label" -html "class form_submit tabindex 62"
element create $form_name submit_sbianca    -widget submit -datatype text -label "$button_sbianca" -html "class form_submit tabindex 62";#rom01

if {[form is_request $form_name]} {
    # solo se l'utente e' un manutentore valorizzo il relativo campo.
    if {![string equal $cod_manutentore ""]} {
	element set_properties $form_name f_cod_manu    -value $cod_manutentore
	if {[db_0or1row get_nome_manu ""] == 0} {
	    set f_manu_cogn ""
	    set f_manu_nome ""
	}
    }

    # valorizzo i campi di mappa con i parametri ricevuti.
    # serve quando la lista ritorna al filtro.
    element set_properties $form_name f_cod_impianto_est   -value $f_cod_impianto_est
    element set_properties $form_name f_cod_impianto_princ -value $f_cod_impianto_princ;#sim01
    element set_properties $form_name f_targa              -value $f_targa;#sim02
    element set_properties $form_name f_resp_cogn          -value $f_resp_cogn
    element set_properties $form_name f_resp_nome          -value $f_resp_nome
    element set_properties $form_name f_resp_cogn_rcee     -value $f_resp_cogn_rcee;#rom06
    element set_properties $form_name f_resp_nome_rcee     -value $f_resp_nome_rcee;#rom06
    element set_properties $form_name f_ibrido             -value $f_ibrido;#ric01
    element set_properties $form_name f_pagato             -value $f_pagato;#ric01
    element set_properties $form_name f_tprc               -value $f_tprc;#ric01
    element set_properties $form_name f_dich_conformita    -value $f_dich_conformita;#ric02
    element set_properties $form_name f_dfm_manu           -value $f_dfm_manu;#ric02
    element set_properties $form_name f_dfm_resp_mod       -value $f_dfm_resp_mod;#ric02
    
    if {$flag_ente == "P"} {
	if {$user_is_comu eq ""} {
	    element set_properties $form_name f_comune   -value $f_comune
	} else {
	    element set_properties $form_name f_comune   -value $id_utente
	}
    } else {
	element set_properties $form_name f_quartiere    -value $f_quartiere
	element set_properties $form_name f_comune       -value $cod_comune
    }

    element set_properties $form_name f_cod_via          -value $f_cod_via
    element set_properties $form_name f_civico_da        -value $f_civico_da
    element set_properties $form_name f_civico_a         -value $f_civico_a
    element set_properties $form_name f_desc_topo        -value $f_desc_topo
    element set_properties $form_name f_desc_via         -value $f_desc_via

    element set_properties $form_name f_manu_cogn        -value $f_manu_cogn
    element set_properties $form_name f_manu_nome        -value $f_manu_nome

    element set_properties $form_name f_cod_impianto_old -value $f_cod_impianto_old
    element set_properties $form_name f_cod_utenza       -value $f_cod_utenza
    element set_properties $form_name f_pod              -value $f_pod;#rom04
    element set_properties $form_name f_dpr_412          -value $f_dpr_412

    element set_properties $form_name f_data_mod_da      -value [iter_edit_date $f_data_mod_da]
    element set_properties $form_name f_data_mod_a       -value [iter_edit_date $f_data_mod_a]
    element set_properties $form_name f_utente           -value $f_utente

    element set_properties $form_name f_potenza_da       -value $f_potenza_da
    element set_properties $form_name f_potenza_a        -value $f_potenza_a
    element set_properties $form_name f_mod_h            -value $f_mod_h

    element set_properties $form_name f_data_installaz_da -value [iter_edit_date $f_data_installaz_da]
    element set_properties $form_name f_data_installaz_a  -value [iter_edit_date $f_data_installaz_a]
    element set_properties $form_name f_flag_dichiarato   -value $f_flag_dichiarato
    element set_properties $form_name f_stato_conformita  -value $f_stato_conformita
    element set_properties $form_name f_cod_combustibile -value $f_cod_combustibile
    element set_properties $form_name f_cod_cost          -value $f_cod_cost
    element set_properties $form_name f_cod_tpim          -value $f_cod_tpim 
    element set_properties $form_name f_matricola         -value $f_matricola
    element set_properties $form_name cerca_multivie      -value $cerca_multivie

    element set_properties $form_name f_cod_tpdu          -value $f_cod_tpdu
    element set_properties $form_name f_prov_dati         -value $f_prov_dati
    element set_properties $form_name f_stato_aimp        -value $f_stato_aimp
    element set_properties $form_name funzione            -value $funzione
    element set_properties $form_name caller              -value $caller
    element set_properties $form_name nome_funz           -value $nome_funz
    element set_properties $form_name f_da_data_verifica  -value $f_da_data_verifica
    element set_properties $form_name f_a_data_verifica   -value $f_a_data_verifica
    element set_properties $form_name f_bollino           -value $f_bollino
    element set_properties $form_name f_flag_tipo_impianto -value $f_flag_tipo_impianto;#dpr74
    element set_properties $form_name receiving_element   -value $receiving_element;#sim01
    element set_properties $form_name f_impianto_inserito     -value $f_impianto_inserito;#rom02
    element set_properties $form_name f_impianto_modificato   -value $f_impianto_modificato;#rom02
    element set_properties $form_name f_soggetto_modificato   -value $f_soggetto_modificato;#rom02
    element set_properties $form_name f_generatore_sostituito -value $f_generatore_sostituito;#rom02
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set submit               [string trim [element::get_value $form_name submit]];#rom01
    set submit_sbianca       [string trim [element::get_value $form_name submit_sbianca]];#rom01
    if {![string is space $submit_sbianca]} {#rom01 aggiunta if e contenuto
        set return_url "coimaimp-filter?nome_funz=impianti"
	 ad_returnredirect $return_url
	ad_script_abort
    };#rom01
    set f_cod_impianto_est   [string trim [element::get_value $form_name f_cod_impianto_est]]
    set f_cod_impianto_princ [string trim [element::get_value $form_name f_cod_impianto_princ]];#sim01
    set f_targa              [string trim [element::get_value $form_name f_targa]];#sim02    
    set f_resp_cogn          [string trim [element::get_value $form_name f_resp_cogn]]
    set f_resp_nome          [string trim [element::get_value $form_name f_resp_nome]]
    set f_resp_cogn_rcee     [string trim [element::get_value $form_name f_resp_cogn_rcee]];#rom06
    set f_resp_nome_rcee     [string trim [element::get_value $form_name f_resp_nome_rcee]];#rom06
    set f_ibrido             [string trim [element::get_value $form_name f_ibrido]];#ric01
    set f_pagato             [string trim [element::get_value $form_name f_pagato]];#ric01
    set f_tprc               [string trim [element::get_value $form_name f_tprc]];#ric01
    set f_dich_conformita    [string trim [element::get_value $form_name f_dich_conformita]];#ric02
    set f_dfm_manu           [string trim [element::get_value $form_name f_dfm_manu]];#ric02
    set f_dfm_resp_mod       [string trim [element::get_value $form_name f_dfm_resp_mod]];#ric02
    
    if {$user_is_comu eq "" } {
	set f_comune       [string trim [element::get_value $form_name f_comune]]
    } else {
	set f_comune       $cod_comune_chk
    }
    if {$flag_ente != "P"} {
	set f_quartiere    [string trim [element::get_value $form_name f_quartiere]]
    }
    set f_cod_via          [string trim [element::get_value $form_name f_cod_via]]
    set f_desc_topo        [string trim [element::get_value $form_name f_desc_topo]]
    set f_desc_via         [string trim [element::get_value $form_name f_desc_via] ] 
    set f_civico_da        [string trim [element::get_value $form_name f_civico_da]]
    set f_civico_a         [string trim [element::get_value $form_name f_civico_a]]

    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]

    set f_data_mod_da      [string trim [element::get_value $form_name f_data_mod_da]]
    set f_data_mod_a       [string trim [element::get_value $form_name f_data_mod_a]]
    set f_utente           [string trim [element::get_value $form_name f_utente]]

    set f_potenza_da       [string trim [element::get_value $form_name f_potenza_da]]
    set f_potenza_a        [string trim [element::get_value $form_name f_potenza_a]]
    set f_data_installaz_da [string trim [element::get_value $form_name f_data_installaz_da]]
    set f_data_installaz_a [string trim [element::get_value $form_name f_data_installaz_a]]
    set f_flag_dichiarato  [string trim [element::get_value $form_name f_flag_dichiarato]]
    set f_stato_conformita [string trim [element::get_value $form_name f_stato_conformita]]
    set f_cod_combustibile [string trim [element::get_value $form_name f_cod_combustibile]]
    set f_cod_cost         [string trim [element::get_value $form_name f_cod_cost]]
    set f_cod_tpim         [string trim [element::get_value $form_name f_cod_tpim]]
    set f_cod_tpdu         [string trim [element::get_value $form_name f_cod_tpdu]]
    set f_stato_aimp       [string trim [element::get_value $form_name f_stato_aimp]]
    set f_mod_h            [string trim [element::get_value $form_name f_mod_h]]
    set f_dpr_412          [string trim [element::get_value $form_name f_dpr_412]]
    set f_cod_utenza       [string trim [element::get_value $form_name f_cod_utenza]]
    set f_pod              [string trim [element::get_value $form_name f_pod]];#rom04
    set f_cod_impianto_old [string trim [element::get_value $form_name f_cod_impianto_old]]
    set f_matricola        [string trim [element::get_value $form_name f_matricola]]
    set f_prov_dati        [string trim [element::get_value $form_name f_prov_dati]]
    set cerca_multivie     [string trim [element::get_value $form_name cerca_multivie]]
    set f_da_data_verifica [string trim [element::get_value $form_name f_da_data_verifica]]
    set f_a_data_verifica  [string trim [element::get_value $form_name f_a_data_verifica]]
    set f_bollino          [string trim [element::get_value $form_name f_bollino]]
#inizio dpr74
    set f_flag_tipo_impianto [string trim [element::get_value $form_name f_flag_tipo_impianto]]
#fine dpr74 
    set f_impianto_inserito     [string trim [element::get_value $form_name f_impianto_inserito]];#rom02
    set f_impianto_modificato   [string trim [element::get_value $form_name f_impianto_modificato]];#rom02
    set f_soggetto_modificato   [string trim [element::get_value $form_name f_soggetto_modificato]];#rom02
    set f_generatore_sostituito [string trim [element::get_value $form_name f_generatore_sostituito]];#rom02

    set error_num 0
    
    if {($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
    &&   $f_cod_impianto_est != ""
    } {#Nicola 20/08/2014
	set f_cod_impianto_est [db_string query "select lpad(:f_cod_impianto_est, 15,0)"];#Nicola 20/08/2014
    };#Nicola 20/08/2014

    set sw_filtro_ind "t"
    # per capire se si e' cercato di fare un filtro per indirizzo,
    # per la Provincia e' sufficiente sapere se e' indicato il comune
    # per il Comune    e' necessario sapere se e' indicato il quartiere o la via

    if {$flag_ente == "P"} {
        if {[string equal $f_comune ""]} {
            set sw_filtro_ind "f"
        }
    } else {
        if {[string equal $f_desc_via  ""] && [string equal $f_desc_topo ""] && [string equal $f_quartiere ""]} {
            set sw_filtro_ind "f"
	}
    }
    #sim01 aggiunto f_cod_impianto_princ sul controllo
    #sim02 aggiunto f_targa sul controllo
    #rom04 aggiunto f_pod sul controllo
    #rom06 Aggiunti f_resp_cogn_rcee e f_resp_nome_rcee sul controllo
    if {[string equal $f_cod_impianto_est ""] && [string equal $f_resp_cogn ""]
	&&  [string equal $f_resp_nome ""]    && [string equal $f_manu_cogn ""]
	&&  [string equal $f_manu_nome ""]    && $sw_filtro_ind == "f"
	&&  [string equal $f_data_mod_da ""]  && [string equal $f_data_mod_a ""]
	&&  [string equal $f_utente ""]       && [string equal $f_cod_impianto_old ""]
	&&  [string equal $f_cod_utenza ""]   && [string equal $f_matricola ""]
	&&  [string equal $f_bollino ""]      && [string equal $f_cod_impianto_princ ""]
	&&  [string equal $f_targa ""]         && [string equal $f_pod ""]
	&& [string equal $f_resp_cogn_rcee ""] &&  [string equal $f_resp_nome_rcee ""]
    } {
        if {$flag_ente == "P"} {
            set errore_indirizzo "comune"
	} else {
	    set errore_indirizzo "indirizzo"
	}
	#sim01: aggiunto "o codice impianto principale"
	element::set_error $form_name f_cod_impianto_est "Indicare almeno codice impianto o responsabile o $errore_indirizzo o manutentore o data modifica o utente o matricola generatore o codice impianto principale"
	incr error_num
    }
    #ric01 aggiunto il campo f_ibrido, f_pagato, f_tprc
    #rom02 aggiunti i campi impianto_inserito, impianto_modificato, soggetto_modificato e generatore_sostituito
    #rom04 aggiunto il campo f_pod
    #rom06 Aggiunti i campi f_resp_cogn_rcee e f_resp_nome_rcee
    #ric02 aggiunto il campo f_dich_conformita, f_dfm_manu, f_dfm_resp_mod 
    if {![string equal $f_cod_impianto_est ""]
	&& (![string equal $f_resp_cogn ""]
	    ||  ![string equal $f_resp_nome ""]
	    ||  $sw_filtro_ind == "t"
	    || ![string equal $f_manu_cogn ""]
	    || ![string equal $f_manu_nome ""]
	    || ![string equal $f_data_mod_da ""]
	    || ![string equal $f_data_mod_a ""]
	    || ![string equal $f_utente ""]
	    || ![string equal $f_potenza_da ""]
	    || ![string equal $f_potenza_a ""]
	    || ![string equal $f_data_installaz_da ""]
	    || ![string equal $f_data_installaz_a ""]
	    || ![string equal $f_flag_dichiarato ""]
	    || ![string equal $f_stato_conformita ""]
	    || ![string equal $f_cod_combustibile ""]
	    || ![string equal $f_cod_tpim ""]
	    || ![string equal $f_cod_utenza ""]
	    || ![string equal $f_pod ""]
	    || ![string equal $f_cod_impianto_old ""]
	    || ![string equal $f_dpr_412 ""]
	    || ![string equal $f_cod_tpdu ""]
	    || ![string equal $f_matricola ""]
	    || ![string equal $f_prov_dati ""]
	    || ![string equal $f_impianto_inserito "N"]
	    || ![string equal $f_impianto_modificato "N"]
	    || ![string equal $f_soggetto_modificato "N"]
	    || ![string equal $f_generatore_sostituito "N"]
	    || ![string equal $f_resp_cogn_rcee ""]
	    || ![string equal $f_resp_nome_rcee ""]
	    || ![string equal $f_ibrido ""]
	    || ![string equal $f_pagato ""]
	    || ![string equal $f_tprc   ""]
	    || ![string equal $f_dich_conformita ""]
	    || ![string equal $f_dfm_manu ""]
	    || ![string equal $f_dfm_resp_mod ""])
	&&  $sw_manu == "f" } {
	element::set_error $form_name f_cod_impianto_est "Con la selezione per codice non &egrave; possibile indicare nessun altro criterio di selezione"
	incr error_num
    } else {
	#ric01 aggiunto il campo f_ibrido, f_pagato, f_tprc
	#rom02 aggiunti i campi impianto_inserito, impianto_modificato, soggetto_modificato e generatore_sostituito
	#rom04 aggiunto il campo f_pod
	#rom06 Aggiunti i campi f_resp_cogn_rcee e f_resp_nome_rcee
	#ric02 aggiunto il campo f_dich_conformita, f_dfm_manu, f_dfm_resp_mod
	if {![string equal $f_cod_impianto_old ""]
	    && (![string equal $f_resp_cogn            ""]
		||  ![string equal $f_resp_nome        ""]
		||  $sw_filtro_ind == "t"
		|| ![string equal $f_manu_cogn         ""]
		|| ![string equal $f_manu_nome         ""]
		|| ![string equal $f_data_mod_da       ""]
		|| ![string equal $f_data_mod_a        ""]
		|| ![string equal $f_utente            ""]
		|| ![string equal $f_potenza_da        ""]
		|| ![string equal $f_potenza_a         ""]
		|| ![string equal $f_data_installaz_da ""]
		|| ![string equal $f_data_installaz_a  ""]
		|| ![string equal $f_flag_dichiarato   ""]
		|| ![string equal $f_stato_conformita  ""]
		|| ![string equal $f_cod_combustibile  ""]
		|| ![string equal $f_cod_tpim          ""]
		|| ![string equal $f_cod_utenza        ""]
		|| ![string equal $f_pod               ""]
		|| ![string equal $f_cod_impianto_est  ""]
		|| ![string equal $f_dpr_412           ""]
		|| ![string equal $f_cod_tpdu          ""]
		|| ![string equal $f_matricola         ""]
		|| ![string equal $f_prov_dati         ""]
		|| ![string equal $f_impianto_inserito "N"]
		|| ![string equal $f_impianto_modificato "N"]
		|| ![string equal $f_soggetto_modificato "N"]
		|| ![string equal $f_generatore_sostituito "N"]
		|| ![string equal $f_resp_cogn_rcee ""]
		|| ![string equal $f_resp_nome_rcee ""]
		|| ![string equal $f_ibrido ""]
		|| ![string equal $f_pagato ""]
		|| ![string equal $f_tprc   ""]
		|| ![string equal $f_dich_conformita  ""]
		|| ![string equal $f_dfm_manu ""]
		|| ![string equal $f_dfm_resp_mod ""])
	    &&  $sw_manu == "f"} {
	    element::set_error $form_name f_cod_impianto_old "Con la selezione per codice non &egrave; possibile indicare nessun altro criterio di selezione"
	    incr error_num
	} else {
	    #ric01 aggiunto il campo f_ibrido, f_pagato, f_tprc
	    #rom02 aggiunti i campi impianto_inserito, impianto_modificato, soggetto_modificato e generatore_sostituito
	    #rom06 Aggiunti i campi f_resp_cogn_rcee e f_resp_nome_rcee
	    #ric02 aggiunto il campo f_dich_conformita, f_dfm_manu, f_dfm_resp_mod
	    if {(![string equal $f_cod_utenza ""] || ![string equal $f_pod ""])
		&& (![string equal $f_resp_cogn            ""]
		    ||  ![string equal $f_resp_nome        ""]
		    ||  $sw_filtro_ind == "t"
		    || ![string equal $f_manu_cogn         ""]
		    || ![string equal $f_manu_nome         ""]
		    || ![string equal $f_data_mod_da       ""]
		    || ![string equal $f_data_mod_a        ""]
		    || ![string equal $f_utente            ""]
		    || ![string equal $f_potenza_da        ""]
		    || ![string equal $f_potenza_a         ""]
		    || ![string equal $f_data_installaz_da ""]
		    || ![string equal $f_data_installaz_a  ""]
		    || ![string equal $f_flag_dichiarato   ""]
		    || ![string equal $f_stato_conformita  ""]
		    || ![string equal $f_cod_combustibile  ""]
		    || ![string equal $f_cod_tpim          ""]
		    || ![string equal $f_cod_impianto_old  ""]
		    || ![string equal $f_cod_impianto_est  ""]
		    || ![string equal $f_dpr_412           ""]
		    || ![string equal $f_cod_tpdu          ""]
		    || ![string equal $f_matricola         ""]
		    || ![string equal $f_prov_dati         ""]
		    || ![string equal $f_impianto_inserito "N"]
		    || ![string equal $f_impianto_modificato "N"]
		    || ![string equal $f_soggetto_modificato "N"]
		    || ![string equal $f_generatore_sostituito "N"]
		    || ![string equal $f_resp_cogn_rcee ""]
		    || ![string equal $f_resp_nome_rcee ""]
		    || ![string equal $f_ibrido ""]
		    || ![string equal $f_pagato ""]
		    || ![string equal $f_tprc   ""]
		    || ![string equal $f_dich_conformita   ""]
		    || ![string equal $f_dfm_manu ""]
		    || ![string equal $f_dfm_resp_mod ""])		
		&&  $sw_manu == "f" } {
		element::set_error $form_name f_cod_utenza "Con la selezione per codice non &egrave; possibile indicare nessun altro criterio di selezione"
		incr error_num
	    } else {
		if {[string equal $f_resp_cogn ""] && ![string equal $f_resp_nome ""]} {
		    element::set_error $form_name f_resp_cogn "Indicare anche il cognome"
		    incr error_num
		}
		
		if {[string equal $f_manu_cogn ""] && ![string equal $f_manu_nome ""]} {
		    element::set_error $form_name f_manu_cogn "Indicare anche il cognome"
		    incr error_num
		}
	    }
	}
    }
    
    # se sono provincia di mantova e l'utente e' o un ente verificatore o 
    # un verificatore, obbligo l'inserimento del comune.
    if {$flag_ente  == "P" &&  $sigla_prov == "MN" && (![string equal $cod_enve ""] || ![string equal $cod_opve ""]) } {
	if {[string equal $f_comune ""]} {
	    element::set_error $form_name f_comune "Inserire il comune"
	    incr error_num
	}
    }
    
    # si controlla la via solo se il primo test e' andato bene.
    # in questo modo si e' sicuri che f_comune e' stato valorizzato.
    if {$error_num ==  0 && $flag_viario == "T" } {
	if {[string equal $f_desc_via  ""] && [string equal $f_desc_topo ""]} {
	    set f_cod_via ""
	} else {
	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $f_desc_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:f_desc_topo)"
	    }
	    if {[string equal $f_desc_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:f_desc_via)"
	    }
	    db_foreach sel_viae "" {
		incr ctr_viae
		if {$cod_via == $f_cod_via} {
		    set chk_out_cod_via $cod_via
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_viae {
		0 { set chk_out_msg "Via non trovata"}
		1 { set chk_out_cod_via $cod_via
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovate pi&ugrave; vie: usa il link cerca"
		    }
		}
	    }
	    set f_cod_via $chk_out_cod_via
	    if {$chk_out_rc == 0} {
		element::set_error $form_name f_desc_via $chk_out_msg
		incr error_num
	    }
	}
    } else {
	set f_cod_via ""
    }
    
    if {( [string equal $f_desc_topo ""]
	  &&  [string equal $f_desc_via  ""]
	  &&  [string equal $f_cod_via   ""])
	&& (![string equal $f_civico_da ""]
	    || ![string equal $f_civico_a  ""]) } {
	element::set_error $form_name f_desc_via "La selezione per numero civico viene effettuata solo insieme alla selezione per via"
	incr error_num
    }
    set err_civico ""
    set check_civico_da "f"
    if {![string equal $f_civico_da ""]} {
	if {![string is integer $f_civico_da]} {
	    append err_civico "Civico di Inizio deve essere un numero intero"
	    element::set_error $form_name f_civico_da $err_civico
	    incr error_num
	} else {
	    set check_civico_da "t"
	}
    }
    
    set check_civico_a  "f"
    if {![string equal $f_civico_a ""]} {
	if {![string is integer $f_civico_a]} {
	    if {![string equal $err_civico ""]} {
		append err_civico "<br>"
	    }
	    append err_civico "Civico di Fine deve essere un numero intero"
	    element::set_error $form_name f_civico_da $err_civico
	    incr error_num
	} else {
	    set check_civico_a  "t"
	}
    }
    
    if {$check_civico_a  == "t" && $check_civico_da == "t" &&  $f_civico_a < $f_civico_da} {
	if {![string equal $err_civico ""]} {
	    append err_civico "<br>"
	}
	append err_civico "Civico iniziale deve essere minore del civico finale"
	element::set_error $form_name f_civico_da $err_civico
	incr error_num
    }
    
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

	db_foreach sel_manu "" {
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
    
    if {[string equal $f_manu_cogn ""] && [string equal $f_manu_nome ""]} {
	set cod_manutentore ""
    } else {
	set chk_inp_cod_manu $f_cod_manu
	set chk_inp_cognome  $f_manu_cogn
	set chk_inp_nome     $f_manu_nome
	eval $check_cod_manu
	set f_cod_manu  $chk_out_cod_manu
	if {$chk_out_rc == 0} {
	    element::set_error $form_name f_manu_cogn $chk_out_msg
	    incr error_num
	}
    }
    
    set check_data_mod_da "f"
    if {![string equal $f_data_mod_da ""]} {
	set f_data_mod_da [iter_check_date $f_data_mod_da]
	if {$f_data_mod_da == 0} {
	    element::set_error $form_name f_data_mod_da "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_data_mod_da "t"
	}
    }
    set check_data_mod_a "f"
    if {![string equal $f_data_mod_a ""]} {
	set f_data_mod_a [iter_check_date $f_data_mod_a]
	if {$f_data_mod_a == 0} {
	    element::set_error $form_name f_data_mod_a "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_data_mod_a "t"
	}
    }
    if {$check_data_mod_a  == "t" && $check_data_mod_da == "t" &&  $f_data_mod_da > $f_data_mod_a} {
	element::set_error $form_name f_data_mod_da "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }

    if {(![string equal $f_data_mod_da ""] || ![string equal $f_data_mod_a ""])
	&& ($f_impianto_inserito eq "N"
	    && $f_impianto_modificato eq "N"
	    && $f_soggetto_modificato eq "N"
	    && $f_generatore_sostituito eq "N") } {#rom02 aggiunta if e suo contenuto
	element::set_error $form_name f_impianto_inserito "Indicare almeno un tipo di ricerca"
	incr error_num
    }
    
    set check_da_data_verifica "f"
    if {![string equal $f_da_data_verifica ""]} {
	set f_da_data_verifica [iter_check_date $f_da_data_verifica]
	if {$f_da_data_verifica == 0} {
	    element::set_error $form_name f_da_data_verifica "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_da_data_verifica "t"
	}
    }
    set check_a_data_verifica "f"
    if {![string equal $f_a_data_verifica ""]} {
	set f_a_data_verifica [iter_check_date $f_a_data_verifica]
	if {$f_a_data_verifica == 0} {
	    element::set_error $form_name f_a_data_verifica "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_a_data_verifica "t"
	}
    }
    if {$check_a_data_verifica  == "t" && $check_da_data_verifica == "t" &&  $f_da_data_verifica > $f_a_data_verifica} {
	element::set_error $form_name f_da_data_verifica "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }
    
    set check_potenza_da "f"
    if {![string equal $f_potenza_da ""]} {
	set f_potenza_da [iter_check_num $f_potenza_da 0]
	if {$f_potenza_da == "Error"} {
	    element::set_error $form_name f_potenza_da "Potenza di Inizio deve essere un numero intero"
	    incr error_num
	} else {
	    set check_potenza_da "t"
	}
    }
    
    set check_potenza_a  "f"
    if {![string equal $f_potenza_a ""]} {
	set f_potenza_a [iter_check_num $f_potenza_a 0]
	if {$f_potenza_a == "Error"} {
	    element::set_error $form_name f_potenza_a "Potenza di Fine deve essere un numero intero"
	    incr error_num
	} else {
	    set check_potenza_a  "t"
	}
    }
    
    if {$check_potenza_a  == "t" && $check_potenza_da == "t" &&  $f_potenza_da > $f_potenza_a} {
	element::set_error $form_name f_potenza_da "Potenza di inizio deve essere minore di Potenza di fine"
	incr error_num
    }
    
    set check_data_inst_da "f"
    if {![string equal $f_data_installaz_da ""]} {
	set f_data_installaz_da [iter_check_date $f_data_installaz_da]
	if {$f_data_installaz_da == 0} {
	    element::set_error $form_name f_data_installaz_da "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_data_inst_da "t"
	}
    }
    
    set check_data_inst_a "f"
    if {![string equal $f_data_installaz_a ""]} {
	set f_data_installaz_a [iter_check_date $f_data_installaz_a]
	if {$f_data_installaz_a == 0} {
	    element::set_error $form_name f_data_installaz_a "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_data_inst_a "t"
	}
    }
    
    if {$check_data_inst_a  == "t" &&  $check_data_inst_da == "t" &&  $f_data_installaz_da > $f_data_installaz_a} {
	element::set_error $form_name f_data_installaz_da "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }
    
    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {![string equal $f_cod_impianto_est ""]} {
	set f_resp_cogn ""
	set f_resp_nome ""
	set f_comune ""
	set f_quartiere ""
	set f_cod_via ""
	set f_desc_via ""
	set f_desc_topo ""
	set f_civico_da ""
	set f_civico_a ""
	set f_manu_cogn ""
	set f_manu_nome ""
	set f_cod_manu ""
	set f_data_mod_da ""
	set f_data_mod_a ""
	set f_utente ""
	set f_potenza_da ""
	set f_potenza_a ""
	set f_data_installaz_da ""
	set f_data_installaz_a ""
	set f_flag_dichiarato ""
	set f_stato_conformita ""
	set f_cod_combustibile ""
	set f_cod_cost ""
	set f_cod_tpim ""
	set f_cod_tpdu ""
	set f_stato_aimp ""
	set f_matricola ""
	set f_prov_dati ""
	set f_da_data_verifica ""
	set f_a_data_verifica ""
	set f_impianto_inserito "";#rom02
	set f_impinto_modificato "";#rom02
	set f_soggetto_modificato "";#rom02
	set f_generatore_sostituito "";#rom02
	set f_resp_cogn_rcee "";#rom06
	set f_resp_nome_rcee "";#rom06
	set f_ibrido "";#ric01
	set f_pagato "";#ric01
	set f_tprc "";#ric01
	set f_dich_conformita "";#ric02
	set f_dfm_manu "";#ric02
	set f_dfm_resp_mod "";#ric02
    }
    #dpr74 aggiunto f_flag_tipo_impianto
    #sim01 aggiunto receiving_element e f_cod_impianto_princ
    #sim02 aggiunto f_targa
    #rom02 aggiunti i campi f_impianto_inserito, f_impianto_modificato, f_soggetto_modificato e f_generatore_sostituito
    #rom04 aggiunto campo f_pod
    #rom06 Aggiunti campi f_resp_cogn_rcee f_resp_nome_rcee
    #ric02 aggiunto il campo f_dich_conformita, f_dfm_manu, f_dfm_resp_mod
    set link_list [export_url_vars receiving_element f_cod_impianto_est f_cod_impianto_princ f_targa f_resp_cogn f_resp_nome f_resp_cogn_rcee f_resp_nome_rcee f_comune f_quartiere f_cod_via f_desc_via f_desc_topo f_civico_da f_civico_a f_manu_cogn f_manu_nome f_cod_manu f_data_mod_da f_data_mod_a f_utente f_potenza_da f_potenza_a f_data_installaz_da f_data_installaz_a f_flag_dichiarato f_stato_conformita f_cod_combustibile f_cod_cost f_cod_tpim f_cod_tpdu f_stato_aimp caller funzione nome_funz_caller f_mod_h f_cod_utenza f_pod f_cod_impianto_old f_dpr_412 f_matricola f_prov_dati cerca_multivie cod_manutentore cod_amministratore f_da_data_verifica f_a_data_verifica f_bollino f_flag_tipo_impianto f_impianto_inserito f_impianto_modificato f_soggetto_modificato f_generatore_sostituito f_ibrido f_pagato f_tprc f_dich_conformita f_dfm_manu f_dfm_resp_mod]&nome_funz=impianti

    set return_url "coimaimp-list?$link_list"
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
