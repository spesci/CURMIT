ad_page_contract {
    Add/Edit/Delete  form per le tabelle "coimdope_aimp" e "coimdope_gend"
    
    @author          Antonio Pisano, clonato da coim_as_manu-gest
    @creation-date   2015-09-07

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    mat02 13/03/2026 Aggiunta la gestione delle deleghe. Sandro ha detto di aggiungere il tecnico
    mat02            e il tecnico delegato.

    ric01 03/10/2025 Punto 4 MEV Marche: leggo storico ditta di manutenzione.

    mat01 27/01/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.

    rom07 17/12/2024 Su richiesta di Regione Marche messo controllo che impedisce l'inserimento di DFM
    rom07            se l'impianto non è attivo. Controllo copiato da quanti già fatto in coimdimp-rct-gest.
    rom07            Sandro ha detto che va been per tutti gli enti.

    mic01 24/08/2022 Estratti campi utente_ins e data_ins da coimdope_aimp e aggiunta select
    mic01            per estrarre nome e cognome dell'utente e formattare correttamente la data.

    rom06 07/02/2022 La DFM come potenza del teleriscaldamento deve prendere la somma della
    rom06            potenza focolare nominale (pot_focolare_nom) dei generatori attivi.
    
    rom05 15/11/2021 Portato il size e maxlength di reg_imprese da 15 a 20.

    rom04 30/06/2020 Modificato intervento di gac02, il redirect sul warning va fatto solo ai
    rom04            manutentori.

    gac02 22/11/2019 Per poter aggiungere o modificare una dichiarazione bisogna aver inserito
    gac02            tutti i dati obbligatori
    
    sim02 22/10/2019 La DFM come potenza del caldo deve prendere la somma della potenza utile dei generatori attivi

    rom03 13/02/2019 Ulteriori modifiche richieste dalla Regione Marche.

    rom02 15/11/2018 Modifiche sui campi chieste da Regione Marche; Sandro ha dedtto che solo
    rom02            la Regione usa i DFM quindi si fa senza mettere le solite if su coimtgen(regione).

    gac01 19/07/2018 Sandro mi ha chiesto di impostare il campo Operazione sia editabile che
    gac01            selezionabile.

    rom01 02/07/2018 Aggiunto controllo sul campo frequenza su ruchiesta di Sandro.
    rom01            IL campo può assumere valori da 04 a 48.

    sim01 06/08/2018 Correzione di un errore causato da uno switch sulla tipologia di impianto
    sim01            Prima gestiva solo il caldo e il freddo, ora gestisce anche Teleriscaldamento e 
    sim01            cogenerazione ed ha un default

    nic02 11/11/2015 Come chiesto dala provincia di pesaro ed urbino, bisogna aggiornare
    nic02            automaticamente i flag della ditta di manutenzione

    nic01 06/11/2015 Su richiesta della provincia di Pesaro e di Sandro, bisogna vietare
    nic01            l'inserimento di due dichiarazioni nella stessa data.
} {
    {cod_impianto         ""}
    {flag_tipo_impianto   ""}
    {cod_dope_aimp        ""}

    {last_cod_dimp        ""}

    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}

    {url_aimp             ""}
    {url_list_aimp        ""}
    {is_controllo_ok    "f"}    
    {is_only_view       "f"}
    {cod_manu_dele      ""}
    {rag_sociale_delegato   ""}
    {cod_opma             ""}
    {cod_opma_dele          ""}
    {nome_opma_delegato     ""}
    {cognome_opma_delegato  ""}
    {cognome_opma           ""}
    {nome_opma              ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

if {$is_only_view eq "t"} {#gac02 aggiunto if else e loro contenuto
    set menu 0
} else {
    set menu 1
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#set id_utente [ad_get_cookie iter_login_[ns_conn location]]

set cod_manutentore_da_id_utente [iter_check_uten_manu $id_utente]

# gli utenti manutentori non possono modificare una dichiarazione
if {$cod_manutentore_da_id_utente ne ""} {
    set flag_modifica "f"
} else {
    set flag_modifica "t"
}


if {$funzione eq "I"} {
    if {$cod_impianto eq ""} {
        iter_return_complaint "E' necessario specificare il codice impianto."
    }
    if {$flag_tipo_impianto eq ""} {
        iter_return_complaint "E' necessario specificare il tipo impianto."
    }
} else {
    if {$cod_dope_aimp eq ""} {
        iter_return_complaint "E' necessario specificare il codice dichiarazione."
    }
    if {![db_0or1row query "
        select flag_tipo_impianto
          from coimdope_aimp
         where cod_dope_aimp = :cod_dope_aimp
        "]
    } {
	iter_return_complaint "Dichiarazione di codice '$cod_dope_aimp' non trovata"
    }
}

set titolo "";#sim01
#sim01 aggiunto switch su teleriscaldamento e cogenerazione
switch $flag_tipo_impianto {
    "R" {set titolo "gen. a fiamma"}
    "F" {set titolo "macchine frigo/pompe calore"}
    "T" {set titolo "teleriscaldamento"}
    "C" {set titolo "cogenerazione"}
}

set titolo "dich. di freq. ed elenco oper. di contr. e manut. $titolo"

switch $funzione {
    M {set button_label "Conferma modifica"
       set page_title   "Modifica $titolo"}
    D {set button_label "Conferma cancellazione"
       set page_title   "Cancella $titolo"}
    I {set button_label "Conferma inserimento"
       set page_title   "Inserisci $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizza $titolo"}
}

set link_gest [export_url_vars cod_impianto cod_dope_aimp flag_tipo_impianto last_cod_dimp caller nome_funz nome_funz_caller extra_par url_aimp url_list_aimp]

# valorizzo pack_dir che sara' utilizzata sull'adp per fare i link.
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"


# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto la proc per i link e per il dettaglio impianto
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set link_list_script {[export_url_vars nome_funz_caller nome_funz cod_impianto url_list_aimp url_aimp last_cod_dope_aimp caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]


iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set cod_comu         $coimtgen(cod_comu)
set flag_viario      $coimtgen(flag_viario)

set context_bar      [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "addedit"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set readonly_cod "readonly";#rom02
set onsubmit_cmd ""
set jq_date "";#but01
switch $funzione {
    "I" {set readonly_key \{\}
	set readonly_fld \{\}
	set disabled_fld \{\}
	set jq_date "class ah-jquery-date";#but01
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
	set jq_date "class ah-jquery-date";#but01
    }
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name is_controllo_ok  -widget hidden -datatype text -optional;#gac02
# Identifico se questa richiesta e' dovuta ad un refresh
element create $form_name __refreshing_p -widget hidden -datatype text -optional
#mat00 13/10/2025
#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
#element set_properties $form_name __refreshing_p -values 0;#mat01
set is_refresh_p [expr {[element::get_value $form_name __refreshing_p] == 1}]

# Se vengo da una refresh, potrei avere il codice manutentore gia' popolato...
element create $form_name cod_manutentore -widget hidden -datatype text -optional
element create $form_name cod_manutentore_pre_refresh -widget hidden -datatype text -optional;#nic02
set cod_manutentore [element::get_value $form_name cod_manutentore]
set cod_manutentore_pre_refresh [element::get_value $form_name cod_manutentore_pre_refresh];#nic02
# ...altrimenti cerco di recuperarlo dall'utente.
if {$cod_manutentore eq ""} {
    set cod_manutentore $cod_manutentore_da_id_utente
}

element create $form_name cod_responsabile -widget hidden -datatype text -optional
set cod_responsabile [element::get_value $form_name cod_responsabile]

element create $form_name cognome_dichiarante \
    -label   "Cognome dichiarante" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element " \
    -optional

element create $form_name nome_dichiarante \
    -label   "Nome dichiarante" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional

element create $form_name flag_dichiarante \
    -label   "In qualita' di" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Legale rappresentante" "L"} {"Responsabile tecnico" "R"} {"Tecnico specializzato" "T"}}

element create $form_name flag_tipo_tecnico \
    -label   "In qualita' di" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"" ""} {"Installatore" "I"} {"Manutentore" "M"}}

element create $form_name cognome_legale \
    -label   "Cognome manutentore" \
    -widget   hidden \
    -datatype text \
    -optional

element create $form_name nome_legale \
    -label   "Nome manutentore" \
    -widget   hidden \
    -datatype text \
    -optional
#rom03 -html    "size 30 maxlength 100 $readonly_fld {} class form_element" 
element create $form_name cognome_resp \
    -label   "Cognome responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_cod {} class form_element" \
    -optional

element create $form_name nome_resp \
    -label   "Nome responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_cod {} class form_element" \
    -optional

#element create $form_name flag_resp \
#    -label   "In qualita' di" \
#    -widget   select \
#    -datatype text \
#    -html    "disabled {} class form_element" \
#    -optional \
#    -options {
#	{""                    ""} 
#	{"Occupante"          "O"} 
#	{"Proprietario"       "P"}
#	{"Amministratore"     "A"}
#	{"Terzo responsabile" "T"}
#    }
#rom02 
element create $form_name flag_resp_db widget hidden -datatype text -optional;#rom02
    
element create $form_name flag_resp \
    -label   "In qualita' di" \
    -widget   text \
    -datatype text \
    -html    "$readonly_cod {} class form_element" \
    -optional \

element create $form_name toponimo \
    -label   "toponimo" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name indirizzo \
    -label   "via" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 80 readonly {} class form_element" \
    -optional

element create $form_name localita \
    -label   "localita" \
    -widget   text \
    -datatype text \
    -html    "size 29 maxlength 40 readonly {} class form_element" \
    -optional

element create $form_name numero \
    -label   "numero" \
    -widget   text \
    -datatype text \
    -html    "size 3 maxlength 8 readonly {} class form_element" \
    -optional

element create $form_name esponente \
    -label   "esopnente" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 3 readonly {} class form_element" \
    -optional

element create $form_name scala \
    -label   "scala" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 5 readonly {} class form_element" \
    -optional

element create $form_name piano \
    -label   "piano"\
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 5 readonly {} class form_element" \
    -optional 

element create $form_name interno \
    -label   "interno" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 3 readonly {} class form_element" \
    -optional
#rom02 cambiata la options: non uso più la proc iter_selbox_from_table ma iter_selbox_from_table_wherec
set where_cod_utgi "where 1 = 1";#rom02
if {$flag_tipo_impianto eq "R"} {#rom02 if e cotenuto
    set where_cod_utgi "where cod_utgi in ('D', 'RA', 'RAD')"
}
if {$flag_tipo_impianto eq "F"} {#rom03 if e contenuto
    set where_cod_utgi "where cod_utgi in ('F', 'R', 'D', 'I', 'FD', 'E', 'FRD')"
}
element create $form_name cod_utgi \
    -label   "cod_utgi" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimutgi cod_utgi descr_utgi cod_utgi $where_cod_utgi]

if {$flag_ente eq "P"} {
    element create $form_name cod_comune \
	-label   "Comune" \
	-widget   select \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options [iter_selbox_from_comu]
} else {
    element create $form_name cod_comune  -widget hidden -datatype text -optional  
    element create $form_name descr_comune \
	-label   "Comune" \
	-widget   text \
	-datatype text \
	-html    "size 20 readonly {} class form_element" \
	-optional
    element set_properties $form_name cod_comune       -value $coimtgen(cod_comu)
    element set_properties $form_name descr_comune     -value $coimtgen(denom_comune)
}

element create $form_name reg_imprese \
    -label   "Reg. Imprese" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name localita_reg \
    -label   "localit&agrave;  reg imp." \
    -widget   text \
    -datatype text \
    -html    "size 31 maxlength 40 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_a \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_b \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_c \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_d \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_e \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_f \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_g \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_certif \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_altro \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name cert_uni_iso \
    -label   "cert_uni_iso" \
    -widget   text \
    -datatype text \
    -html    "size 25 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name cert_altro \
    -label   "cert_altro" \
    -widget   textarea \
    -datatype text \
    -html    "cols 75 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_inizio \
    -label   "Data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_fine \
    -label   "Data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name causale_fine \
    -label   "causale fine" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {{Revoca dell'incarico} R} {Dimissioni D}}

element create $form_name cod_impianto_est \
    -label   "cod_impianto_est" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name fornitore_energia \
    -label   "fornitore_energia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimdist cod_distr ragione_01]

element create $form_name pot_nom_risc \
    -label   "Potenza termica nominale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $readonly_cod {} class form_element" \
    -optional

element create $form_name pot_nom_raff \
    -label   "Potenza frigorifera nominale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $readonly_fld {} class form_element" \
    -optional

if {$flag_tipo_impianto eq "R"} {
    element create $form_name cod_combustibile \
	-label   "cod_combustibile" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options [iter_selbox_from_table coimcomb cod_combustibile descr_comb]
} else {
    element create $form_name cod_combustibile -widget hidden -datatype text -optional
}

element create $form_name flag_doc_tecnica \
    -label   "Vista la doc. tecnica" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Si" t} {"No" f}}

element create $form_name flag_istr_tecniche \
    -label   "Viste le istr. tecniche" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Si" t} {"No" f}}

element create $form_name flag_man_tecnici \
    -label   "Visti i manuali tecnici" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Si" t} {"No" f}}

element create $form_name flag_reg_locali \
    -label   "Visti i reg. locali" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Si" t} {"No" f}}

element create $form_name flag_norme_uni_cei \
    -label   "Viste le norme UNI CEI" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Si" t} {"No" f}}

element create $form_name altri_doc \
    -label   "Altro" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 3 maxlength 400 $readonly_fld {} class form_element" \
    -optional
    
element create $form_name data_dich \
    -label   "Data dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional 


#inizio mat02 copiato e aggiustato la parte di codice riguardante le deleghe negli rcee
set ast_delega "<font color=red>*</font>"
set delegation_active_p "f"
set delegation_warning ""

if {$coimtgen(regione) eq "MARCHE"} {#mat02 aggiunta if-else e contenuto

    element create $form_name cognome_opma \
	-label   "Cognome manutentore" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 200 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name nome_opma \
	-label   "Nome manutentore" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
	-optional

    element create $form_name cod_opma -widget hidden -datatype text -optional

    if {$funzione == "I" || $funzione == "M"} { 
	set fstato 0
	set cerca_opma [iter_search $form_name [ad_conn package_url]/src/coimopma-list [list cod_manutentore cod_manutentore dummy cod_opma f_cognome nome_opma f_nome cognome_opma] &fstato=$fstato]
	
    } else {
	set cerca_opma ""
    }

    if {$funzione eq "I"} {

	element create $form_name cod_manu_dele -widget hidden -datatype text -optional
	element create $form_name cod_opma_dele -widget hidden -datatype text -optional
	
	if {[db_0or1row q "select 1
                         from coimdele
                        where delegation_state = 'A'
                          and cod_manutentore = :cod_manutentore
                          and current_date between start_date and end_date
                         limit 1"]} {

	    set ast_delega ""
	    set delegation_active_p "t"
	    set delegation_warning "<font color=red><b>Nel caso ci sia una delega formale compilare i dati relativi alla delega in fondo alla pagina.</b></font>"

	    element create $form_name rag_sociale_delegato \
		-label   "Ditta installazione" \
		-widget   text \
		-datatype text \
		-html    "size 20 maxlength 100 $readonly_fld {} class form_element " \
		-optional

	    #cerca delle ditte delegate
	    set cerca_manu_dele [iter_search $form_name [ad_conn package_url]/src/coimmanu-dele-list [list rag_sociale_delegato rag_sociale_delegato cod_manu_dele cod_manu_dele cod_manutentore cod_manutentore]]

	    
		element create $form_name cognome_opma_delegato \
		    -label   "Tecnico che ha effettuato il controllo su delega" \
		    -widget text \
		    -datatype text \
		    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name nome_opma_delegato \
		    -label   "Tecnico che ha effettuato il controllo su delega" \
		    -widget   text \
		    -datatype text \
		    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
		    -optional
	    	set cerca_opma_dele      [iter_search $form_name [ad_conn package_url]/src/coimopma-list [list cod_manutentore cod_manutentore dummy cod_opma_dele nome_opma_delegato nome_opma_delegato cognome_opma_delegato cognome_opma_delegato] &fstato=$fstato]

	} else {

	    element create $form_name rag_sociale_delegato -widget hidden -datatype text -optional
	    element create $form_name nome_opma_delegato   -widget hidden -datatype text -optional
	    element create $form_name cognome_opma_delegato -widget hidden -datatype text -optional

	}
    } else {

	if {[db_0or1row q "select 1
                             from coimdope_aimp
                            where cod_dope_aimp = :cod_dope_aimp
                              and cod_manu_dele is not null"]} {
	    set delegation_active_p "t"

	    element create $form_name cod_manu_dele -widget hidden -datatype text -optional
	    element create $form_name cod_opma_dele -widget hidden -datatype text -optional
	    
	    if {$funzione eq "M"} {
		#cerca delle ditte delegate
		set cerca_manu_dele [iter_search $form_name [ad_conn package_url]/src/coimmanu-dele-list [list rag_sociale_delegato rag_sociale_delegato cod_manu_dele cod_manu_dele cod_manutentore cod_manutentore]]
		element create $form_name cod_opma_dele -widget hidden -datatype text -optional
	    } else {
		set cerca_manu_dele ""
		set cerca_opma_dele ""
	    }

	    element create $form_name rag_sociale_delegato \
		-label   "Ditta installazione" \
		-widget   text \
		-datatype text \
		-html    "size 20 maxlength 100 $readonly_fld {} class form_element " \
		-optional
	    	    element create $form_name nome_opma_delegato \
		-label   "Installatore" \
		-widget   text \
		-datatype text \
		-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
		-optional

	    element create $form_name cognome_opma_delegato \
		-label   "Tecnico che ha effettuato il controllo su delega" \
		-widget text \
		-datatype text \
		-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
		-optional


	} else {
	    
	    element create $form_name cod_manu_dele        -widget hidden -datatype text -optional
	    element create $form_name rag_sociale_delegato -widget hidden -datatype text -optional
	    element create $form_name cod_opma_dele        -widget hidden -datatype text -optional
	    element create $form_name nome_opma_delegato   -widget hidden -datatype text -optional
	    element create $form_name cognome_opma_delegato -widget hidden -datatype text -optional
	    set cerca_manu_dele ""
	    set cerca_opma_dele ""

	}
    }

} else {

    element create $form_name cod_manu_dele        -widget hidden -datatype text -optional
    element create $form_name rag_sociale_delegato -widget hidden -datatype text -optional
    element create $form_name cod_opma_dele        -widget hidden -datatype text -optional
    element create $form_name nome_opma_delegato   -widget hidden -datatype text -optional
    element create $form_name cognome_opma_delegato -widget hidden -datatype text -optional
    element create $form_name cognome_opma -widget hidden -datatype text -optional
    element create $form_name nome_opma -widget hidden -datatype text -optional
    element create $form_name cod_opma -widget hidden -datatype text -optional 
    set cerca_opma ""
    set cerca_opma_dele ""
}

;#fine mat02

# Generatori ed operazioni su di essi
set max_righe_generatori 12
set script_autocompletamento "";#gac01 script per campo autocompilabile
#rom02 aggiunto combustibile
#rom03 aggiunto fluido_frigorigeno, sistema_azionamento, cod_tpco, pot_focolare_nom e pot_focolare_lib
# In base al numero di generatori, creo i campi per le operazioni
multirow create campi_operazioni \
    gen_prog \
    data_installaz \
    flag_attivo \
    pot_utile_nom \
    modello \
    matricola \
    fabbricante \
    campo_operazione \
    campo_frequenza \
    attivo_p \
    combustibile \
    fluido_frigorigeno \
    sistema_azionamento \
    cod_tpco \
    pot_focolare_nom \
    pot_focolare_lib

# In inserimento, devo esporre solo i generatori attivi.
# In modifica, sia quelli attivi che quelli disattivi con coimdope_gend
# In visualizzazione e cancellazione, solo quelli con coimdope_gend
if {$funzione eq "I"} {
    set and_condizioni "and     g.flag_attivo = 'S'"
} elseif {$funzione eq "M"} {
    set and_condizioni "and (   g.flag_attivo = 'S'
                             or exists (select 1
                                          from coimdope_gend
                                         where cod_dope_aimp = :cod_dope_aimp
                                           and gen_prog      = g.gen_prog)
                            )"
} else {
    set and_condizioni "and (   exists (select 1
                                          from coimdope_gend
                                         where cod_dope_aimp = :cod_dope_aimp
                                           and gen_prog      = g.gen_prog)
                            )"
}

db_foreach query "
    select gen_prog, 
           iter_edit_data(data_installaz) as data_installaz, 
           flag_attivo,
           iter_edit_num(pot_utile_nom,2) as pot_utile_nom,
           modello,
           matricola,
          (select descr_cost 
             from coimcost 
            where cod_cost = g.cod_cost) as fabbricante
         ,(select descr_comb
             from coimcomb
            where cod_combustibile = g.cod_combustibile) as combustibile --rom02
         ,(select sigla
             from coimflre
            where cod_flre = g.cod_flre) as fluido_frigorigeno --rom03
         ,(select descr_tpco
             from coimtpco 
            where cod_tpco = g.cod_tpco) as sistema_azionamento --rom03
         , cod_tpco --rom03
         , coalesce(iter_edit_num(pot_focolare_nom,2),'0.00') as pot_focolare_nom --rom03
         , coalesce(iter_edit_num(pot_focolare_lib,2),'0.00') as pot_focolare_lib --rom03
      from coimgend g
     where cod_impianto = :cod_impianto
      $and_condizioni
  order by gen_prog asc
" {
    set attivo_p [expr {$flag_attivo eq "S"}]
    set n_righe $max_righe_generatori;#Nicola: se compare un generatore, espongo sempre tutte le 12 righe.
    # Per ogni generatore, creo un insieme di campi dove ospitare le operazioni
    for {set i 1} {$i <= $n_righe} {incr i} {
        set campo_operazione "operazione_${gen_prog}_${i}"

	#gac01 script per campo autocompilabile
	append script_autocompletamento "

Ext.onReady(function(){

    // Imposto il focus sul primo campo d'errore (se presente)
    ahFocusError();

    // AUTOCOMPLETAMENTO

    // array di elementi in forma \[ 'id_campo', '/url/del/webservice' \]
    var comboFields = \[\['$campo_operazione', '/iter/tabgen/coimoper?valore=' + $campo_operazione.value \]\];

    ahAutocomplete(comboFields);
});
"
        element create $form_name $campo_operazione \
	    -label   "Operazione" \
	    -widget   text \
	    -datatype text \
	    -html    "$readonly_fld {}" \
	    -optional 

        set campo_frequenza "frequenza_${gen_prog}_${i}"
        element create $form_name $campo_frequenza \
	    -label   "Frequenza" \
	    -widget   text \
	    -datatype text \
	    -html    "size 8 maxlength 50 $readonly_fld {} class form_element" \
	    -optional

	#rom02 aggiunto combustibile
	#rom03 aggiunto fluido_frigorigeno, sistema di azionamento, cod_tpco, pot_focolare_nom e pot_focolare_lib
        template::multirow append campi_operazioni \
            $gen_prog \
            $data_installaz \
            $flag_attivo \
            $pot_utile_nom \
            $modello \
            $matricola \
            $fabbricante \
            $campo_operazione \
            $campo_frequenza \
            $attivo_p \
	    $combustibile \
	    $fluido_frigorigeno \
	    $sistema_azionamento \
	    $cod_tpco \
	    $pot_focolare_nom \
	    $pot_focolare_lib
    }
}

append script_autocompletamento "
"
element create $form_name num_generatori \
    -label    "Num. generatori" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $readonly_cod {} class form_element" \
    -optional

element create $form_name cod_impianto       -widget hidden -datatype text -optional
element create $form_name flag_tipo_impianto -widget hidden -datatype text -optional
element create $form_name cod_dope_aimp      -widget hidden -datatype text -optional

element create $form_name last_cod_dimp      -widget hidden -datatype text -optional

element create $form_name funzione           -widget hidden -datatype text -optional
element create $form_name caller             -widget hidden -datatype text -optional
element create $form_name nome_funz          -widget hidden -datatype text -optional
element create $form_name nome_funz_caller   -widget hidden -datatype text -optional
element create $form_name extra_par          -widget hidden -datatype text -optional

element create $form_name url_aimp           -widget hidden -datatype text -optional
element create $form_name url_list_aimp      -widget hidden -datatype text -optional

element create $form_name cod_legale_rapp    -widget hidden -datatype text -optional
element create $form_name f_cod_via          -widget hidden -datatype text -optional
element create $form_name dummy              -widget hidden -datatype text -optional

element create $form_name nome_funz_new      -widget hidden -datatype text -optional
element create $form_name flag_ins_prop      -widget hidden -datatype text -optional

element create $form_name submit_btn         -widget submit -datatype text -label "$button_label" -html "class form_submit"

set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new
set flag_ins_prop "S"

#rom03 la regione marche non vuole che il responsabile possa essere modificato quindi commento il vecchio link e lo risetto vuoto
#set link_ins_prop [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_resp nome nome_resp nome_funz nome_funz_new dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy cod_responsabile dummy dummy flag_ins_prop dummy] "Inserisci Sogg."]
set link_ins_prop ""
set current_date [iter_set_sysdate]
#rom03 la regione marche non vuole che il responsabile possa essere modificato quindi commento il vecchio link e lo risetto vuoto
#if {$funzione eq "I" || $funzione eq "M"} {
#    set cerca_prop  [iter_search $form_name coimcitt-filter [list dummy cod_responsabile f_cognome cognome_resp f_nome nome_resp]]
#} else {
    set cerca_prop ""
#}

if {($funzione eq "I" || $funzione eq "M")
    && $cod_manutentore_da_id_utente eq ""
} {
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]
} else {
    set cerca_manu ""
}

if {$is_refresh_p || [form is_request $form_name]} {
    #rom04 modificata if: aggiunta parte cod_manutentore_da_id_utente
    if {!$is_controllo_ok && $coimtgen(regione) eq "MARCHE" && $cod_manutentore_da_id_utente ne ""} {#gac02 aggiunta if e suo contenuto
	set caller "dope"
	set link         [export_ns_set_vars "url"]
	set link [export_url_vars link]
	
	ad_returnredirect [ad_conn package_url]src/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdope-aimp-gest&$link&funzione=$funzione&caller=$caller
	ad_script_abort    
    }

    element set_properties $form_name is_controllo_ok      -value $is_controllo_ok;#gac02
    element set_properties $form_name cod_impianto     -value $cod_impianto
    # valorizzo flag_tipo_impianto piu' avanti (dopo averlo letto in caso di funz. <> I)
    element set_properties $form_name cod_dope_aimp    -value $cod_dope_aimp

    element set_properties $form_name last_cod_dimp    -value $last_cod_dimp

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name url_aimp         -value $url_aimp    
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name flag_ins_prop    -value $flag_ins_prop
    element set_properties $form_name cod_manu_dele         -value $cod_manu_dele;#mat02
    element set_properties $form_name rag_sociale_delegato  -value $rag_sociale_delegato;#mat02
    element set_properties $form_name cod_opma_dele         -value $cod_opma_dele;#mat02
    element set_properties $form_name nome_opma_delegato    -value $nome_opma_delegato;#mat02
    element set_properties $form_name cognome_opma_delegato    -value $cognome_opma_delegato;#mat02
    element set_properties $form_name nome_opma       -value $nome_opma;#mat02
    element set_properties $form_name cognome_opma    -value $cognome_opma;#mat02
    
    # Preparo questi default per l'inserimento:
    set flag_doc_tecnica   "f"
    set flag_istr_tecniche "f"
    set flag_man_tecnici   "f"
    set flag_norme_uni_cei "f"
    set flag_reg_locali    "f"
    set data_dich_st "";#ric01
    
    # Non rileggo la riga se siamo in un refresh,
    # altrimenti tutte le modifiche fatte al record
    # verrebbero eliminate
    if {!$is_refresh_p && $funzione ne "I"} {
        # leggo riga
        if {![db_0or1row query "
            select 
              flag_tipo_impianto,
              cognome_dichiarante,
              nome_dichiarante,
              flag_dichiarante,
              d.cod_manutentore,
              flag_tipo_tecnico,
              cod_utgi,
              pot_nom_risc,
              pot_nom_raff,
              num_generatori,
              cod_combustibile,
              toponimo,
              d.indirizzo,
              cod_via,
              d.localita,
              numero,
              esponente,
              scala,
              piano,
              interno,
              cod_comune,
              cod_distr,
              cod_responsabile,
       --rom02flag_resp,
              case flag_resp
              when 'O' then 'Occupante'
              when 'A' then 'Amministratore'
              when 'P' then 'Proprietario'
              when 'T' then 'Terzo Responsabile'
              else ''
               end as flag_resp --rom02
            , flag_resp as flag_resp_db --rom02
            , flag_doc_tecnica,
              flag_istr_tecniche,
              flag_man_tecnici,
              flag_reg_locali,
              flag_norme_uni_cei,
              altri_doc,
              data_dich as data_dich_st, --ric01
              iter_edit_data(data_dich)     as data_dich,
              iter_edit_num(pot_nom_risc,2) as pot_nom_risc,
              iter_edit_num(pot_nom_raff,2) as pot_nom_raff,
              d.utente_ins, --mic01
              d.data_ins    --mic01
            , cod_manu_dele --mat02
            , coalesce(man.cognome,'')||' '||coalesce(man.nome,'') as rag_sociale_delegato --mat02  
            , d.cod_opma_dele --mat02
            , opm_dele.nome     as nome_opma_delegato --mat02
            , opm_dele.cognome  as cognome_opma_delegato --mat02
            , d.cod_opma --mat02
            , opm.nome      as nome_opma --mat02
            , opm.cognome  as cognome_opma   --mat02
      from coimdope_aimp d
   left outer join coimmanu man      on man.cod_manutentore  = d.cod_manu_dele --mat02
   left outer join coimopma opm_dele on opm_dele.cod_opma    = d.cod_opma_dele --mat02
   left outer join coimopma opm      on opm.cod_opma         = d.cod_opma      --mat02
        where cod_dope_aimp = :cod_dope_aimp
        "]} {
            iter_return_complaint "Dichiarazione di codice '$cod_dope_aimp' non trovata"
        }

        set nome_utente_ins "";#mic01
	set data_ins_edit   "";#mic01
	if {$utente_ins ne ""} {#mic01 Aggiunta if e il suo contenuto
	    db_1row q "select coalesce(cognome,'')||' '||coalesce(nome,'') as nome_utente_ins
                         from coimuten
                        where id_utente=:utente_ins"
	}
	if {$data_ins ne ""} {#mic01 Aggiunta if e il suo contenuto
	    db_1row sel_edit_data "select iter_edit_data(:data_ins) as data_ins_edit"
	}

	set cod_manutentore_pre_refresh $cod_manutentore;#nic02
	

        foreach nome_campo {
            flag_tipo_impianto
            cognome_dichiarante
            nome_dichiarante
            flag_dichiarante
            cod_manutentore
            cod_manutentore_pre_refresh
            flag_tipo_tecnico
            cod_utgi
            num_generatori
            cod_combustibile
            toponimo
            indirizzo
            localita
            numero
            esponente
            scala
            piano
            interno
            cod_comune
            cod_responsabile
            flag_resp
            altri_doc
            data_dich
	    pot_nom_risc
            pot_nom_raff
        } {
            element set_properties $form_name $nome_campo -value [set $nome_campo]
        }
                
        element set_properties $form_name f_cod_via         -value $cod_via
        element set_properties $form_name fornitore_energia -value $cod_distr

	element set_properties $form_name cod_manu_dele         -value $cod_manu_dele;#mat02
	element set_properties $form_name rag_sociale_delegato  -value $rag_sociale_delegato;#mat02
	element set_properties $form_name cod_opma_dele         -value $cod_opma_dele;#mat02
	element set_properties $form_name nome_opma_delegato    -value $nome_opma_delegato;#mat02
	element set_properties $form_name cognome_opma_delegato    -value $cognome_opma_delegato;#mat02
	element set_properties $form_name nome_opma    -value $nome_opma;#mat02
	element set_properties $form_name cognome_opma    -value $cognome_opma;#mat02
	
	# Recupero tutte le operazioni sull'impianto e popolo i campi creati dinamicamente
        foreach op [db_list_of_lists query "
                    select gen_prog
                         , num_oper
                         , operazione
                         , frequenza
                      from coimdope_gend
                     where cod_dope_aimp = :cod_dope_aimp
                  order by gen_prog, num_oper asc
              "] {
            set gen_prog       [lindex $op 0]
            set num_oper       [lindex $op 1]
            set suffisso_campo "${gen_prog}_${num_oper}"
	    
            if {$num_oper > $max_righe_generatori} break
	    
            element set_properties $form_name operazione_$suffisso_campo -value [lindex $op 2]
            element set_properties $form_name  frequenza_$suffisso_campo -value [lindex $op 3]
        }
    };#fine if {!$is_refresh_p && $funzione ne "I"}

    if {[exists_and_not_null cod_responsabile]} {
        db_1row query "
          select cognome as cognome_resp,
                 nome    as nome_resp
            from coimcitt
           where cod_cittadino = :cod_responsabile"
        element set_properties $form_name cod_responsabile -value $cod_responsabile
        element set_properties $form_name cognome_resp     -value $cognome_resp
        element set_properties $form_name nome_resp        -value $nome_resp
    }
    
    # valorizzo alcuni default
    if {[exists_and_not_null cod_manutentore]} {

        if {[form is_request $form_name] || ($is_refresh_p && $cod_manutentore ne $cod_manutentore_pre_refresh)} {#nic02 (aggiunta questa if altrimenti c'erano problemi)
	    db_1row sel_man "
         select *
           from (
            select cognome as cognome_manu,
                   nome as nome_manu,
                   reg_imprese,
                   localita_reg,
                   flag_a,
                   flag_b,
                   flag_c,
                   flag_d,
                   flag_e,
                   flag_f,
                   flag_g,
                   cert_uni_iso,
                   cert_altro,
                   cod_legale_rapp,
                   current_date as data_validita --ric01
                   
              from coimmanu 
             where cod_manutentore = :cod_manutentore

       union --ric01

          select cognome as cognome_manu,
                   nome as nome_manu,
                   reg_imprese,
                   localita_reg,
                   flag_a,
                   flag_b,
                   flag_c,
                   flag_d,
                   flag_e,
                   flag_f,
                   flag_g,
                   cert_uni_iso,
                   cert_altro,
                   cod_legale_rapp,
                   st_data_validita as data_validita

              from coimmanu_st
             where cod_manutentore = :cod_manutentore
          ) as st
     where st.data_validita >= coalesce(:data_dich_st, current_date)
  order by st.data_validita
     limit 1"


            set cod_manutentore_pre_refresh $cod_manutentore;#nic02

	    foreach nome_campo {
		cod_manutentore
		cod_manutentore_pre_refresh
		cognome_manu
		nome_manu
		reg_imprese
		localita_reg
		flag_a
		flag_b
		flag_c
		flag_d
		flag_e
		flag_f
		flag_g
	    } {
		element set_properties $form_name $nome_campo -value [set $nome_campo]
	    }
	    
	    if {$cert_uni_iso ne ""} {
		element set_properties $form_name flag_certif -value "t"
	    }
	    if {$cert_altro ne ""} {
		element set_properties $form_name flag_altro  -value "t"
	    }
	};#nic02
    }
    
    if {[exists_and_not_null cod_legale_rapp]
	&& [db_0or1row sel_legale "
            select cognome as cognome_legale,
                   nome as nome_legale
              from coimcitt
             where cod_cittadino = :cod_legale_rapp"]
    } {
        set nome_dichiarante    [string trim [element::get_value $form_name nome_dichiarante]]
        if {$nome_dichiarante eq ""} {
	    element set_properties $form_name nome_dichiarante -value $nome_legale
        }
        set cognome_dichiarante [string trim [element::get_value $form_name cognome_dichiarante]]
        if {$cognome_dichiarante eq ""} {
	    element set_properties $form_name cognome_dichiarante -value $cognome_legale
        }
        element set_properties $form_name cod_legale_rapp -value $cod_legale_rapp
        element set_properties $form_name cognome_legale  -value $cognome_legale
        element set_properties $form_name nome_legale     -value $nome_legale
    }

    if {$flag_viario eq "F"} {
	db_1row sel_aimp_ins_no_vie "
               select a.cod_utgi                  as cod_utgi_old,
                      b.cod_impianto_est,
                      b.indirizzo,
                      b.toponimo,
                      b.cod_comune,
                      b.numero,
                      b.esponente,
                      b.piano,
                      b.scala,
                      b.localita,
                      b.interno,
                      iter_edit_num(b.potenza_utile,2) as potenza_old,
                      (select iter_edit_num(sum(pot_focolare_nom),2)
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S') as somma_pot_focolare_nom, --rom03
                      (select iter_edit_num(sum(pot_focolare_lib),2)
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S') as somma_pot_focolare_lib, --rom03
                      b.cod_combustibile          as cod_combustibile_old,
                      b.cod_responsabile          as cod_responsabile_old,
            --rom02   b.flag_resp                 as flag_resp_old,
                      case b.flag_resp --rom02
                      when 'O' then 'Occupante'
                      when 'A' then 'Amministratore'
                      when 'P' then 'Proprietario'
                      when 'T' then 'Terzo Responsabile'
                      else ''
                       end as flag_resp_old,
                      b.flag_resp as flag_resp_db, --rom02
                      d.nome                      as nome_resp_old,
                      d.cognome                   as cognome_resp_old,
                      b.cod_distributore          as forn_energia
                    , b.stato as stato_imp --rom07
                  from coimgend a
                     , coimaimp b
       left outer join coimcitt d on d.cod_cittadino = b.cod_responsabile
                 where a.cod_impianto = :cod_impianto
                   and b.cod_impianto = a.cod_impianto
              group by *
              order by a.flag_attivo desc
                     , a.gen_prog    desc
                 limit 1"
    } else {
	db_1row sel_aimp_ins_vie "
               select a.cod_utgi                  as cod_utgi_old,
                      b.cod_impianto_est,
                      c.descrizione as indirizzo,
                      c.descr_topo as toponimo,
                      b.cod_comune,
                      b.numero,
                      b.esponente,
                      b.piano,
                      b.scala,
                      b.localita,
                      b.interno,
--sim02                      iter_edit_num(b.potenza_utile, 2) as potenza_old,

                        (select iter_edit_num(sum(pot_utile_nom),2)
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S') as potenza_old, --sim02

                      (select iter_edit_num(sum(pot_focolare_nom),2)
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S') as somma_pot_focolare_nom, --rom03
                      (select iter_edit_num(sum(pot_focolare_lib),2)  
                         from coimgend  
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S') as somma_pot_focolare_lib, --rom03
                      b.cod_combustibile          as cod_combustibile_old,
                      b.cod_responsabile          as cod_responsabile_old,
            --rom02   b.flag_resp                 as flag_resp_old,
                      case b.flag_resp --rom02
                      when 'O' then 'Occupante'
                      when 'A' then 'Amministratore'
                      when 'P' then 'Proprietario'
                      when 'T' then 'Terzo Responsabile'
                      else ''
                       end as flag_resp_old,
                      b.flag_resp as flag_resp_db, --rom02
                      d.nome                      as nome_resp_old,
                      d.cognome                   as cognome_resp_old,
                      b.cod_distributore as forn_energia
                    , b.stato as stato_imp --rom07
                 from coimgend a
                    , coimaimp b
      left outer join coimcitt d on d.cod_cittadino = b.cod_responsabile
      left outer join coimviae c on c.cod_via       = b.cod_via
                                and c.cod_comune    = b.cod_comune
                where a.cod_impianto = :cod_impianto
                  and b.cod_impianto = a.cod_impianto
             order by a.flag_attivo desc
                    , a.gen_prog    desc
                limit 1"
    }


    if {$funzione eq "I"} {#rom07 Aggiunta if e suo contenuto
	if {$stato_imp ne "A" } {
	    iter_return_complaint "Sarà possibile trasmettere DFM e altri moduli solo dopo la riattivazione/validazione dell'impianto da parte dell'ente"
	    ad_script_abort
	}
    }

    if {!$is_refresh_p && $funzione eq "I"} {
	element set_properties $form_name cod_responsabile -value $cod_responsabile_old
	element set_properties $form_name flag_resp        -value $flag_resp_old
	element set_properties $form_name flag_resp_db     -value $flag_resp_db
	element set_properties $form_name cognome_resp     -value $cognome_resp_old
	element set_properties $form_name nome_resp        -value $nome_resp_old

	element set_properties $form_name cod_utgi         -value $cod_utgi_old

	# Il default della potenza viene dall'impianto. In realta', nel caso questo
	# sia un impianto da freddo non e' chiaro se la potenza sia in riscaldamento
	# o raffreddamento, ma per ora faccio cosi'.
	if {$flag_tipo_impianto eq "F"} {
	    #rom03element set_properties $form_name pot_nom_raff -value $potenza_old
	    element set_properties $form_name pot_nom_raff -value $somma_pot_focolare_nom;#rom03
	    element set_properties $form_name pot_nom_risc -value $somma_pot_focolare_lib;#rom03
	    #cod_combustibile non deve essere valorizzato per il freddo
	} elseif {$flag_tipo_impianto eq "T"} {#rom06 Aggiunta elseif e suo contenuto
	    element set_properties $form_name pot_nom_risc -value $somma_pot_focolare_nom
	} else {
	    element set_properties $form_name pot_nom_risc -value $potenza_old
	    element set_properties $form_name cod_combustibile -value $cod_combustibile_old
	}

	db_1row query "
        select count(*) as num_generatori_attivi
          from coimgend
         where cod_impianto = :cod_impianto
           and flag_attivo  = 'S'"

	element set_properties $form_name num_generatori   -value $num_generatori_attivi
    }

    element set_properties $form_name cod_impianto_est  -value $cod_impianto_est
    element set_properties $form_name indirizzo         -value $indirizzo
    element set_properties $form_name toponimo          -value $toponimo
    element set_properties $form_name localita          -value $localita
    element set_properties $form_name numero            -value $numero
    element set_properties $form_name esponente         -value $esponente
    element set_properties $form_name scala             -value $scala
    element set_properties $form_name piano             -value $piano
    element set_properties $form_name interno           -value $interno
    element set_properties $form_name cod_comune        -value $cod_comune
    element set_properties $form_name fornitore_energia -value $forn_energia
    
    element set_properties $form_name cod_impianto       -value $cod_impianto
    element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
    
    # Queste variabili hanno dei default,
    # quindi popolo i campi solo alla fine
    foreach nome_campo {
        flag_doc_tecnica
        flag_istr_tecniche
        flag_man_tecnici
        flag_reg_locali
        flag_norme_uni_cei
    } {
        element set_properties $form_name $nome_campo -value [set $nome_campo]
    }
    
    # Se eventualmente eravamo in un refresh, la prossima richiesta non lo sara'
    element set_properties $form_name __refreshing_p -value 0
}

set errori ""

# "test [form is_valid $form_name]"
# "test [template::form::get_errors $form_name]"

if {!$is_refresh_p && [form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set is_controllo_ok [element::get_value $form_name is_controllo_ok];#gac02
    db_1row sel_aimp_select "
          select cod_comune
            from coimaimp
           where cod_impianto = :cod_impianto
           limit 1"
    element set_properties $form_name cod_comune -value $cod_comune

    # Per ogni campo form qua sotto, la variabile
    # sara' popolata con il valore corrispondente
    foreach nome_campo {
        cod_dope_aimp
        cod_impianto
        cognome_dichiarante
        nome_dichiarante
        data_dich
        num_generatori
        cod_manutentore
        cognome_manu
        nome_manu
        cod_legale_rapp
        cognome_legale
        nome_legale
        data_inizio
        data_fine
        causale_fine
        toponimo
        indirizzo
        f_cod_via
        localita
        numero
        esponente
        scala
        piano
        interno
        cod_comune
        cod_responsabile
        cognome_resp
        nome_resp
        pot_nom_raff
        pot_nom_risc
        cod_utgi
        reg_imprese
        localita_reg
        flag_a
        flag_b
        flag_c
        flag_d
        flag_e
        flag_f
        flag_g
        flag_certif
        flag_altro
        cert_uni_iso
        cert_altro
        fornitore_energia
        flag_dichiarante
        flag_tipo_tecnico
        cod_combustibile
        flag_resp
	flag_resp_db
        flag_doc_tecnica
        flag_man_tecnici
        flag_istr_tecniche
        flag_norme_uni_cei
        flag_reg_locali
        altri_doc
    } {
        set $nome_campo [element::get_value $form_name $nome_campo]
    }
    
    set cod_manu_dele   [string trim [element::get_value $form_name cod_manu_dele]];#mat02
    set rag_sociale_delegato [string trim [element::get_value $form_name rag_sociale_delegato]];#mat02
    set cod_opma_dele   [string trim [element::get_value $form_name cod_opma_dele]];#mat02
    set nome_opma_delegato [string trim [element::get_value $form_name nome_opma_delegato]];#mat02
    set cognome_opma_delegato [string trim [element::get_value $form_name cognome_opma_delegato]];#mat02
    set cognome_opma [string trim [element::get_value $form_name cognome_opma]];#mat02
    set nome_opma [string trim [element::get_value $form_name nome_opma]];#mat02
    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {$funzione eq "I" || $funzione eq "M"} {
	
	if {$flag_tipo_tecnico eq ""} {#rom02 if e contenuto
	    element::set_error $form_name flag_tipo_tecnico "Inserire"
	    incr error_num
	}
	
	#routine generica per controllo codice manutentore
        set check_cod_manu {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_manu ""
            set ctr_manu         0
            if {$chk_inp_cognome eq ""} {
                set eq_cognome "is null"
	    } else {
                set eq_cognome "= upper(:chk_inp_cognome)"
	    }
            if {$chk_inp_nome eq ""} {
                set eq_nome "is null"
	    } else {
                set eq_nome "= upper(:chk_inp_nome)"
	    }
            db_foreach sel_manu "
            select cod_manutentore
              from coimmanu
             where upper(cognome) $eq_cognome
               and upper(nome)    $eq_nome
            " {
                incr ctr_manu
                if {$cod_manutentore eq $chk_inp_cod_manu} {
		    set chk_out_cod_manu $cod_manutentore
                    set chk_out_rc       1
		}
	    }
            switch $ctr_manu {
 		0 { set chk_out_msg "Soggetto non trovato"}
	 	1 { set chk_out_cod_manu $cod_manutentore
		    set chk_out_rc       1 }
		default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
 		}
	    }
 	}
	
	if {$cognome_manu eq "" && $nome_manu eq ""} {
	    element::set_error $form_name cognome_manu "Inserire il manutentore"
	    incr error_num
	} else {
            set chk_inp_cod_manu $cod_manutentore
            set chk_inp_cognome  $cognome_manu
            set chk_inp_nome     $nome_manu
            
            eval $check_cod_manu
            set cod_manutentore  $chk_out_cod_manu
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_manu $chk_out_msg
                incr error_num
            }
	}
	
        set check_cod_citt {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_citt ""
            set ctr_citt         0
            if {$chk_inp_cognome eq ""} {
                set eq_cognome "is null"
	    } else {
                set eq_cognome "= upper(:chk_inp_cognome)"
	    }
            if {$chk_inp_nome eq ""} {
                set eq_nome "is null"
	    } else {
                set eq_nome "= upper(:chk_inp_nome)"
	    }
            db_foreach sel_citt "
              select cod_cittadino
                from coimcitt
               where upper(cognome) $eq_cognome
                 and upper(nome)    $eq_nome" {
                incr ctr_citt
                if {$cod_cittadino eq $chk_inp_cod_citt} {
		    set chk_out_cod_citt $cod_cittadino
                    set chk_out_rc       1
		}
		}
            switch $ctr_citt {
 		0 { set chk_out_msg "Soggetto non trovato"}
	 	1 { set chk_out_cod_citt $cod_cittadino
		    set chk_out_rc       1 }
		default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
 		}
	    }
 	}
	
	if {$flag_certif eq "t" && $cert_uni_iso eq ""} { 
            element::set_error $form_name cert_uni_iso "valorizzare la certificazione"
	    incr error_num
	} elseif {$flag_certif ne "t" && $cert_uni_iso ne ""} { 
            element::set_error $form_name cert_uni_iso "valorizzare la certificazione"
	    incr error_num
	}
	
        if {$cognome_resp eq "" && $nome_resp eq ""} {
            set cod_responsabile ""
            element::set_error $form_name cognome_resp "valorizzare il responsabile"
            incr error_num
        } else {
            set chk_inp_cod_citt $cod_responsabile
            set chk_inp_cognome  $cognome_resp
            set chk_inp_nome     $nome_resp
            eval $check_cod_citt
            set cod_responsabile $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_resp $chk_out_msg
                incr error_num
            }
        }
	
        if {$flag_altro eq "t" && $cert_altro eq ""} {
            element::set_error $form_name cert_altro "valorizzare Altro"
	    incr error_num
	} elseif {$flag_altro ne "t" && $cert_altro ne ""} { 
            element::set_error $form_name cert_altro "valorizzare Altro"
	    incr error_num
	}
	
        if {$indirizzo ne "" || $toponimo ne ""} {
	    if {$cod_comune eq ""} {
		if {$coimtgen(flag_ente) eq "P"} {
		    element::set_error $form_name cod_comune "valorizzare il Comune" 
		} else {
		    element::set_error $form_name descr_comu "valorizzare il Comune"
		} 
		incr error_num
	    } 
	}
	
	# si controlla la via solo se il primo test e' andato bene.
	# in questo modo si e' sicuri che f_comune e' stato valorizzato.
	if {$flag_viario eq "T"} {
	    if {$indirizzo eq "" && $toponimo eq ""} {
		if {$localita ne ""} {
		    set f_cod_via ""
		} else {
		    set chk_out_msg "Compilare la localit&agrave se non si conosce la via"
		    set chk_out_rc 0
		}
	    } else {
		# controllo codice via
		set chk_out_rc      0
		set chk_out_msg     ""
		set chk_out_cod_via ""
		set ctr_viae        0
		if {$toponimo eq ""} {
		    set eq_toponimo  "is null"
		} else {
		    set eq_toponimo  "= upper(:toponimo)"
		}
		if {$indirizzo eq ""} {
		    set eq_descrizione "is null"
		} else {
		    set eq_descrizione "= upper(:indirizzo)"
		}
		db_foreach sel_viae "
                select cod_via
                  from coimviae
                 where cod_comune  = :cod_comune
                   and descrizione = upper(:indirizzo)
                   and descr_topo  = upper(:toponimo)
                   and cod_via_new is null
                " {
	 	    incr ctr_viae
		    if {$cod_via eq $f_cod_via} {
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
		set cod_via   $chk_out_cod_via
	    }
	    
	    if {[info exists chk_out_rc] && $chk_out_rc == 0} {
                element::set_error $form_name indirizzo $chk_out_msg
                incr error_num
	    }
	}

	# La potenza di riscaldamento esiste anche per gli impianti da freddo (pompe di calore),
	# quindi deve essere introdotta anche nel caso in cui manchi quella di raffreddamento.
        if {$pot_nom_risc eq ""} {
            if {$flag_tipo_impianto eq "R" || $pot_nom_raff eq ""} {
                element::set_error $form_name pot_nom_risc "inserire potenza"
                incr error_num
            }
        } else {
            set pot_nom_risc [iter_check_num $pot_nom_risc 2]
            if {$pot_nom_risc eq "Error"} {
                element::set_error $form_name pot_nom_risc "numerico, max 2 dec"
                incr error_num
            }
        }
        
        # La potenza di raffreddamento vale solo per gli impianti 
        # da freddo, quindi solo in quel caso sara' obbligatoria.
        if {$pot_nom_raff eq ""} {
            if {$flag_tipo_impianto eq "F"} {
                element::set_error $form_name pot_nom_raff "inserire potenza"
                incr error_num
            }
        } else {
            set pot_nom_raff [iter_check_num $pot_nom_raff 2]
            if {$pot_nom_raff eq "Error"} {
                element::set_error $form_name pot_nom_raff "numerico, max 2 dec"
                incr error_num
            }
        }
    }
    
    if {![string is integer $num_generatori]} {
        element::set_error $form_name num_generatori "Numero errato"
        incr error_num
    }
    
    # Scorro le operazioni nei campi creati dinamicamente ed eseguo i controlli.
    # Le operazioni controllate e non vuote le travaso in un'altra multirow
    template::multirow create operazioni gen_prog operazione frequenza
    template::multirow foreach campi_operazioni {
	set operazione [string trim [element::get_value $form_name $campo_operazione]]
        set frequenza  [string trim [element::get_value $form_name $campo_frequenza]]

        # Conto le operazioni specificate per ciascun generatore
        if {![info exists conta_operazioni($gen_prog)]} {
            # Mi salvo il campo dove eventualmente mettere l'errore
            set campo_errore($gen_prog) $campo_operazione
            set conta_operazioni($gen_prog) 0
        }
        
        # Ignoro le operazioni vuote
        if {"$operazione$frequenza" eq ""} continue
        
        if {$operazione eq ""} {
            element::set_error $form_name $campo_operazione "Manca l'operazione"
            incr error_num
        }
        if {$frequenza eq ""} {
            element::set_error $form_name $campo_frequenza "Manca la frequenza"
            incr error_num
        }
	if {$frequenza ne ""} {#rom01 if e suo contenuto
	    set frequenza [iter_check_num $frequenza 0]
	    if {($frequenza eq "Error") || ($frequenza < "4") || ($frequenza > "48")} {
		element::set_error $form_name $campo_frequenza "Deve essere un numero intero compreso tra 4 e 48"
                incr error_num
	    }
	    
        };#rom01

        incr conta_operazioni($gen_prog)
        
        template::multirow append operazioni $gen_prog $operazione $frequenza
    }
    
    # Scorro il conteggio delle operazioni. Ne voglio almeno una per ciascun generatore.
    # Si vuole farlo solo in inserimento.
    if {$funzione eq "I"} {
        foreach {gen cont} [array get conta_operazioni] {
            # Non ne hano messa nessuna su questo generatore, metto l'errore sul campo che mi ero segnato
            if {$cont == 0} {
                element::set_error $form_name $campo_errore($gen) "Inserire almeno una operazione di manutenzione"
                incr error_num
            }
        }
    }
        
    if {$data_dich eq ""} {
        element::set_error $form_name data_dich "Inserire data"
        incr error_num
    } else {
        set data_dich [iter_check_date $data_dich]
        if {$data_dich == 0} {
            element::set_error $form_name data_dich "Data non corretta"
            incr error_num
        } else {#nic01: aggiunta else ed il suo contenuto
	    if {$funzione eq "I"} {
		set and_cod_impianto_diverso ""
	    } else {
		set and_cod_impianto_diverso "and cod_impianto <> :cod_impianto"
	    }
	    if {[db_0or1row query "
                 select 1
                   from coimdope_aimp
                  where cod_impianto = :cod_impianto
                    and data_dich    = :data_dich
                   $and_cod_impianto_diverso
                  limit 1"]
	    } {
		element::set_error $form_name data_dich "Esiste gi&agrave; un'altra dichiarazione con questa data"
		incr error_num
	    }
	}
    }
    
    if {$delegation_active_p} {#mat02 aggiunto if e contenuto

	if {![string equal $cognome_opma ""] && ![string equal $nome_opma ""] && ![string equal $nome_opma_delegato ""] && ![string equal $cognome_opma_delegato ""]} {
	    element::set_error $form_name cognome_opma "Inserire solo uno tra tecnico che ha effettuato il controllo<br> e operatore delegato."
	    element::set_error $form_name nome_opma_delegato "Inserire solo uno tra tecnico che ha effettuato il controllo<br> e operatore delegato."
	    incr error_num
	}
	if {[string equal $cognome_opma ""] && [string equal $nome_opma ""]} {
	    set cod_opma ""
	}
	if {[string equal $nome_opma_delegato ""] && [string equal $cognome_opma_delegato ""]} {
	    set cod_opma_dele ""
	}
	if {$cod_manu_dele eq "" && $cod_opma_dele ne ""} {
	    element::set_error $form_name nome_opma_delegato "Il tecnico delegato è valorizzato. Valorizzare anche la ditta delegante."
	    incr error_num
	}
    }
    
    
    if {$error_num > 0} {
        set errori "ATTENZIONE sono presenti degli errori nella pagina"
        ad_return_template
        return
    }

    with_catch error_msg {
   
	db_transaction {
	
	    if {$funzione eq "M" || $funzione eq "D"} {
		# Elimino tutte le operazioni precedenti
		db_dml query "
                delete
                  from coimdope_gend 
                 where cod_dope_aimp = :cod_dope_aimp"
	    }

	    set flag_resp_db  [db_string q "select flag_resp from coimaimp where cod_impianto = :cod_impianto"];#rom02

	    switch $funzione {
		I {
		    set cod_dope_aimp [db_nextval coimdope_aimp_s]
		    
		    if {$cod_legale_rapp eq ""} {
			set cod_legale_rapp [db_string sel_leg "
                        select cod_legale_rapp
                          from coimmanu 
                         where cod_manutentore = :cod_manutentore"]
		    }

		    
		    db_dml query "
                    insert
                      into coimdope_aimp (
                      cod_dope_aimp,
                      cod_impianto,
                      flag_tipo_impianto,
                      cognome_dichiarante,
                      nome_dichiarante,
                      flag_dichiarante,
                      cod_manutentore,
                      flag_tipo_tecnico,
                      cod_utgi,
                      pot_nom_risc,
                      pot_nom_raff,
                      num_generatori,
                      cod_combustibile,
                      toponimo,
                      indirizzo,
                      cod_via,
                      localita,
                      numero,
                      esponente,
                      scala,
                      piano,
                      interno,
                      cod_comune,
                      cod_distr,
                      cod_responsabile,
                      flag_resp,
                      flag_doc_tecnica,
                      flag_istr_tecniche,
                      flag_man_tecnici,
                      flag_reg_locali,
                      flag_norme_uni_cei,
                      altri_doc,
                      data_dich,
                      data_ins,
                      utente_ins
                    , cod_manu_dele --mat02
                    , cod_opma_dele --mat02
                    , cod_opma      --mat02 
                     ) values (
                      :cod_dope_aimp,
                      :cod_impianto,
                      :flag_tipo_impianto,
                      :cognome_dichiarante,
                      :nome_dichiarante,
                      :flag_dichiarante,
                      :cod_manutentore,
                      :flag_tipo_tecnico,
                      :cod_utgi,
                      :pot_nom_risc,
                      :pot_nom_raff,
                      :num_generatori,
                      :cod_combustibile,
                      :toponimo,
                      :indirizzo,
                      :cod_via,
                      :localita,
                      :numero,
                      :esponente,
                      :scala,
                      :piano,
                      :interno,
                      :cod_comune,
                      :fornitore_energia,
                      :cod_responsabile,
                      :flag_resp_db, --rom02 sotituito flag_resp
                      :flag_doc_tecnica,
                      :flag_istr_tecniche,
                      :flag_man_tecnici,
                      :flag_reg_locali,
                      :flag_norme_uni_cei,
                      :altri_doc,
                      :data_dich,
                      current_date,
                      :id_utente
                     ,:cod_manu_dele --mat02
                     ,:cod_opma_dele --mat02
                     ,:cod_opma      --mat02
                    )"
		}
		M {
		    
		    db_dml query "
                    update coimdope_aimp set 
                      cod_impianto        = :cod_impianto,
                      flag_tipo_impianto  = :flag_tipo_impianto,
                      cognome_dichiarante = :cognome_dichiarante,
                      nome_dichiarante    = :nome_dichiarante,
                      flag_dichiarante    = :flag_dichiarante,
                      cod_manutentore     = :cod_manutentore,
                      flag_tipo_tecnico   = :flag_tipo_tecnico,
                      cod_utgi            = :cod_utgi,
                      pot_nom_risc        = :pot_nom_risc,
                      pot_nom_raff        = :pot_nom_raff,
                      num_generatori      = :num_generatori,
                      cod_combustibile    = :cod_combustibile,
                      toponimo            = :toponimo,
                      indirizzo           = :indirizzo,
                      cod_via             = :cod_via,
                      localita            = :localita,
                      numero              = :numero,
                      esponente           = :esponente,
                      scala               = :scala,
                      piano               = :piano,
                      interno             = :interno,
                      cod_comune          = :cod_comune,
                      cod_distr           = :fornitore_energia,
                      cod_responsabile    = :cod_responsabile,
                      flag_resp           = :flag_resp_db, --rom02 sotituito flag_resp
                      flag_doc_tecnica    = :flag_doc_tecnica,
                      flag_istr_tecniche  = :flag_istr_tecniche,
                      flag_man_tecnici    = :flag_man_tecnici,
                      flag_reg_locali     = :flag_reg_locali,
                      flag_norme_uni_cei  = :flag_norme_uni_cei,
                      altri_doc           = :altri_doc,
                      data_dich           = :data_dich,
                      data_mod            = current_date,
                      utente_mod          = :id_utente
                    , cod_manu_dele       = :cod_manu_dele --mat02
                    , cod_opma_dele       = :cod_opma_dele --mat02
                    , cod_opma            = :cod_opma      --mat02  
                where cod_dope_aimp = :cod_dope_aimp"
		}
		D {
		    db_dml query "
                    delete
                      from coimdope_aimp
                     where cod_dope_aimp = :cod_dope_aimp"
		}
	    }
        
	    # Siamo in inserimento o modifica. Salvo le operazioni inserite
	    if {$funzione eq "M" || $funzione eq "I"} {
		# Scorro le operazioni gia' controllate
		# e per ciascuna inserisco un record
		set key ""
		template::multirow foreach operazioni {
		    if {$gen_prog ne $key} {
			set key $gen_prog
			set num_oper 1
		    }
		    db_dml query "
                    insert into coimdope_gend (
                        cod_dope_aimp,
                        gen_prog,
                        num_oper,
                        operazione,
                        frequenza,
                        data_ins,
                        utente_ins,
                        data_mod,
                        utente_mod
                      ) values (
                        :cod_dope_aimp,
                        :gen_prog,
                        :num_oper,
                        :operazione,
                        :frequenza,
                        current_date,
                        :id_utente,
                        current_date,
                        :id_utente
                      )"
		    incr num_oper
		}
	    }
	    
	    # Siamo in inserimento o modifica. Aggiorno i dati del manutentore
	    #rom02 Visto che ora i dati relativi a flag_a, flag_b, flag_c, flag_d, flag_e, flag_f e flag_g
	    #rom02 vengono solo visti in modalità disabled non devo più aggiornarli
	    if {$funzione eq "M" || $funzione eq "I"} {#nic02
		db_dml query "
                update coimmanu
                   set localita_reg = upper(:localita_reg)
                     , reg_imprese  = upper(:reg_imprese)
       --rom02       , flag_a       = :flag_a
       --rom02       , flag_b       = :flag_b
       --rom02       , flag_c       = :flag_c
       --rom02       , flag_d       = :flag_d
       --rom02       , flag_e       = :flag_e
       --rom02       , flag_f       = :flag_f
       --rom02       , flag_g       = :flag_g
                 where cod_manutentore = :cod_manutentore"
	    }
	}
    } {
        iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

   
    set link_list [subst $link_list_script]
    set link_gest [export_url_vars cod_impianto cod_dope_aimp flag_tipo_impianto last_cod_dimp caller nome_funz nome_funz_caller extra_par url_aimp url_list_aimp]
    
    switch $funzione {
        I {set return_url "coimdope-aimp-gest?funzione=V&$link_gest"}
        M {set return_url "coimdope-aimp-gest?funzione=V&$link_gest"}
        V {set return_url "coimdimp-list?$link_list"}
        D {set return_url "coimdimp-list?$link_list"}
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
