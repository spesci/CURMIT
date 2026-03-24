ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimnoveb"
    @author          Valentina Catte
    @creation-date   02/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimnoveb-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    but01 25/07/2023 Aggiunto la classe ah-jquery-date a tutti campi DATA.
    ric01 15/03/2023 Solo per regione Marche mostro i flag_art_11 e flag_art_11_comma_3, per gli 
    ric01            altri enti non sono più necessari perchè abrogati, modificato anche adp.
    ric01            Aggiunto controllo su obbligatorietà flag_art_3.

    sim01 01/02/2023 Corretto errore dovuto a gac01. Se indicavo un cittadino i default dei campi
    sim01            non erano settati correttamente.
    sim01            Corretto messaggio di errore di data_dichiarazione che andava su un altro campo

    gac02 22/11/2019 Per poter aggiungere o modificare una dichiarazione bisogna aver inserito
    gac02            tutti i dati obbligatori

    gac01 21/11/2018 Modificato modello a con aggiunta di vari campi come richiesto da regione marche.
    gac01            Le modifiche valgono solo per regione marche

} {

    {cod_impianto     ""}
    {cod_noveb        ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {url_list_aimp    ""}
    {url_aimp         ""}
    {errore_1         ""}
    {errore_2         ""}
    {errore_3         ""}
    {is_controllo_ok    "f"}    
    {is_only_view       "f"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user

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
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set link_gest [export_url_vars cod_impianto cod_noveb nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

#proc per la navigazione
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_impianto cod_noveb caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set current_date      [iter_set_sysdate]

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

db_1row sel_data_inst ""

db_1row sel_aimp_indir ""

db_1row q "select cod_utgi from coimgend where cod_impianto = :cod_impianto limit 1";#gac01

if {$coimtgen(regione) eq "MARCHE"} {;#gac01 aggiunto if else e contenuto di if
    set titolo              "dichiarazione art.284 D. Lgs. 152/2006"
} else {
    set titolo              "Allegato IX B"
}



switch $funzione {
    M {set button_label "Conferma Modifica"
        set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
        set page_title   "Cancellazione $titolo"}
    I {set button_label "Conferma Inserimento"
        set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
        set page_title   "Visualizzazione $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimnoveb"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
    }
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name is_controllo_ok  -widget hidden -datatype text -optional;#gac02

if {$coimtgen(regione) eq "MARCHE"} {#gac01
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

    element create $form_name flag_dichiarante \
        -label   "In qualita' di" \
        -widget   select \
        -datatype text \
        -html    "$disabled_fld {} class form_element" \
        -optional \
        -options {{"Legale rappresentante" "L"} {"Responsabile tecnico" "R"} {"Tecnico specializzato" "T"}}

    element create $form_name reg_imprese \
	-label   "Reg. Imprese" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 15 disabled {} class form_element" \
	-optional
    
    element create $form_name localita_reg \
	-label   "localit&agrave;  reg imp." \
	-widget   text \
	-datatype text \
	-html    "size 31 maxlength 40 disabled {} class form_element" \
	-optional
    
    element create $form_name flag_a \
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
    
    element create $form_name flag_e \
	-label   "check" \
	-widget   checkbox \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options  {{Si t}}

    element create $form_name piva \
	-label   "piva" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional
    
    element create $form_name indirizzo_manu \
	-label   "indirizzo_manu" \
	-widget   text \
	-datatype text \
	-html    "size 50 maxlength 100 disabled {} class form_element" \
	-optional
    
    element create $form_name comune_manu \
	-label   "comune_manu" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional

    element create $form_name provincia_manu \
	-label   "provincia_manu" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 50 disabled {} class form_element" \
	-optional
        
    element create $form_name telefono \
	-label   "telefono" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional

    element create $form_name fax \
	-label   "fax" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional

    element create $form_name email \
	-label   "email" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 50 disabled {} class form_element" \
	-optional
    
    element create $form_name cod_impianto_est \
	-label   "cod_impianto_est" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional


    element create $form_name combustibile \
	-label   "combustibile" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 disabled {} class form_element" \
	-optional

    element create $form_name n_generatori_marche \
	-label   "n_generatori_marche" \
	-widget   text \
	-datatype text \
	-html    "size 5 maxlength 50 disabled {} class form_element" \
	-optional

    element create $form_name potenza_utile \
	-label   "potenza_utile" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 50 disabled {} class form_element" \
	-optional

    element create $form_name produzione_acs \
	-label   "check" \
	-widget   checkbox \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options  {{Si t}}
    

    element create $form_name riscaldamento_ambienti \
	-label   "check" \
	-widget   checkbox \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options  {{Si t}}
    
    
    
    element create $form_name cod_legale_rapp -widget hidden -datatype text -optional;#gac01
    element create $form_name nome_legale     -widget hidden -datatype text -optional;#gac01
    element create $form_name cognome_legale  -widget hidden -datatype text -optional;#gac01
    element create $form_name cod_utgi        -widget hidden -datatype text -optional;#gac01
    
} else {

    element create $form_name cognome_dichiarante  -widget hidden -datatype text -optional
    element create $form_name nome_dichiarante     -widget hidden -datatype text -optional
    
    element create $form_name reg_imprese          -widget hidden -datatype text -optional;#gac01
    element create $form_name localita_reg         -widget hidden -datatype text -optional;#gac01
    element create $form_name flag_a               -widget hidden -datatype text -optional;#gac01
    element create $form_name flag_c               -widget hidden -datatype text -optional;#gac01
    element create $form_name flag_e               -widget hidden -datatype text -optional;#gac01
    element create $form_name piva                 -widget hidden -datatype text -optional;#gac01
    element create $form_name indirizzo_manu       -widget hidden -datatype text -optional;#gac01
    element create $form_name comune_manu          -widget hidden -datatype text -optional;#gac01
    element create $form_name provincia_manu       -widget hidden -datatype text -optional;#gac01
    element create $form_name telefono             -widget hidden -datatype text -optional;#gac01
    element create $form_name fax                  -widget hidden -datatype text -optional;#gac01
    element create $form_name email                -widget hidden -datatype text -optional;#gac01
    element create $form_name cod_legale_rapp      -widget hidden -datatype text -optional;#gac01
    element create $form_name nome_legale          -widget hidden -datatype text -optional;#gac01
    element create $form_name cognome_legale       -widget hidden -datatype text -optional;#gac01
    element create $form_name flag_dichiarante     -widget hidden -datatype text -optional;#gac01
    element create $form_name cod_impianto_est     -widget hidden -datatype text -optional;#gac01
    element create $form_name combustibile         -widget hidden -datatype text -optional;#gac01
    element create $form_name n_generatori_marche  -widget hidden -datatype text -optional;#gac01
    element create $form_name potenza_utile        -widget hidden -datatype text -optional;#gac01
    element create $form_name produzione_acs       -widget hidden -datatype text -optional;#gac01
    element create $form_name riscaldamento_ambienti -widget hidden -datatype text -optional;#gac01
}

set onchange_manu "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_manutentore';document.$form_name.submit.click()"

element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 40 $readonly_fld {} class form_element $onchange_manu" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu dummy cod_legale_rapp dummy cognome_dichiarante dummy nome_dichiarante] [list f_ruolo "M"]]
    set cerca_citt [iter_search $form_name coimcitt-filter [list dummy cod_manutentore f_cognome cognome_manu  f_nome nome_manu ]]
} else {
    set cerca_manu ""
    set cerca_citt ""
}

element create $form_name data_consegna \
    -label   "data_consegna" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name luogo_consegna \
    -label   "luogo_consegna" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_art_3 \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_art_11 \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_patente_abil \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_art_11_comma_3 \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_installatore \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_responsabile \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_manutentore \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

#gac02 aggiunto flag_rispetta_val_min
element create $form_name flag_rispetta_val_min \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name indirizzo_impianto \
    -label   "indirizzo_impianto" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 60 disabled {} class form_element" \
    -optional

element create $form_name combustibili \
    -label   "combustibili" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 1  $readonly_fld {} class form_element" \
    -optional

element create $form_name n_generatori  \
    -label   "n_generatori " \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_term_tot_mw \
    -label   "pot_term_tot_mw" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_libretto_centr \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_dich_conformita \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name dich_conformita_nr \
    -label   "dich_conformita_nr" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_dich_conform \
    -label   "data_dich_conform" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name regolamenti_locali \
    -label   "regolamenti_locali" \
    -widget   textarea \
    -datatype text \
    -html    "cols 100 rows 1  $readonly_fld {} class form_element" \
    -optional

element create $form_name verif_emis_286_no \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name verif_emis_286_si \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name data_verif_emiss \
    -label   "data_verif_emiss" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name risultato_mg_nmc_h \
    -label   "risultato_mg_nmc_h" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name risultato_conforme_si \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name risultato_conforme_no \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name data_alleg_libretto \
    -label   "data_alleg_libretto" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name firma_dichiarante \
    -label   "firma_dichiarante" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_dichiarazione \
    -label   "data_dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name firma_responsabile \
    -label   "firma_responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 100 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_ricevuta \
    -label   "data_ricevuta" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name flag_consegnato \
    -label   "flag_consegnato" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {S&igrave; S} {No N}}

element create $form_name cod_noveb \
    -label   "cod_noveb" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_key {} class form_element" \
    -optional

element create $form_name manu_ord_1 \
    -label   "Manut. ordin. 1" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_1 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_2 \
    -label   "Manut. ordin. 2" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_2 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_3 \
    -label   "Manut. ordin. 3" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_3 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_4 \
    -label   "Manut. ordin. 4" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_4 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_5 \
    -label   "Manut. ordin. 5" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_5 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_6 \
    -label   "Manut. ordin. 6" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_6 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional
element create $form_name manu_ord_7 \
    -label   "Manut. ordin. 7" \
    -widget   textarea \
    -datatype text \
    -html    "cols 65 rows 2 class form_element" \
    -optional

element create $form_name manu_flag_7 \
    -label   "Periodicita'" \
    -widget   text \
    -datatype text \
    -html    "size 60 maxlength 50 class form_element" \
    -optional


element create $form_name manu_stra_1 \
    -label   "Manut. straord." \
    -widget   textarea \
    -datatype text \
    -html    "cols 130 rows 2 class form_element" \
    -optional

element create $form_name n_prot \
    -label   "Num. protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name dat_prot \
    -label   "Data protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional




element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name cod_manutentore  -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name url_list_aimp    -widget hidden -datatype text -optional
element create $form_name url_aimp         -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name __refreshing_p   -widget hidden -datatype text -optional;#gac01
element create $form_name changed_field    -widget hidden -datatype text -optional;#nic01

if {[form is_request $form_name]} {
    if {!$is_controllo_ok && $coimtgen(regione) eq "MARCHE"} {#gac02 aggiunta if e suo contenuto
	set caller "dope"
	set link   [export_ns_set_vars "url"]
	set link   [export_url_vars link]
	
	ad_returnredirect [ad_conn package_url]src/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimnoveb-gest&$link&funzione=$funzione&caller=$caller
	ad_script_abort    
    }
    element set_properties $form_name is_controllo_ok      -value $is_controllo_ok;#gac02
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name cod_impianto_est   -value $cod_impianto_est;#gac01		    
    element set_properties $form_name combustibile       -value $combustibile    ;#gac01
    element set_properties $form_name n_generatori_marche -value $n_generatori_marche;#gac01
    element set_properties $form_name potenza_utile      -value $potenza_utile   ;#gac01
    element set_properties $form_name __refreshing_p   -value 0;#gac01
    element set_properties $form_name changed_field    -value "";#gac01
    
    if {$coimtgen(regione) eq "MARCHE"} {#gac01 aggiunta if e suo contenuto
	if {$cod_utgi eq "RA"} {#gac01 aggiunta if e suo contenuto
	    set riscaldamento_ambienti t
	} else {
	    set riscaldamento_ambienti ""
	}
	if {$cod_utgi eq "D"} {#gac01 aggiunta if e suo contenuto
	    set produzione_acs  t
	} else {
	    set produzione_acs  ""
	}
    } else {
	set riscaldamento_ambienti "";#gac01
	set produzione_acs         "";#gac01
    }
    element set_properties $form_name riscaldamento_ambienti -value $riscaldamento_ambienti;#gac01
    element set_properties $form_name produzione_acs     -value $produzione_acs   ;#gac01

    if {$funzione == "I"} {

        db_1row sel_next_noveb ""
        element set_properties $form_name cod_noveb         -value $cod_noveb
        element set_properties $form_name flag_consegnato   -value "S"

	#gac01 quando si inserisce una dichiarazione prendo il codice manutentore ed estraggo il rappresentante legale 
	# valorizzo alcuni default
	if {[exists_and_not_null cod_manutentore]} {
	    if {[db_0or1row sel_manu ""] > 0} {
		element set_properties $form_name cognome_manu     -value $cognome_manu
		element set_properties $form_name nome_manu        -value $nome_manu
		element set_properties $form_name cod_manutentore  -value $cod_manutentore
		element set_properties $form_name indirizzo_impianto -value $indirizzo_impianto
		element set_properties $form_name reg_imprese       -value $reg_imprese;#gac01
		element set_properties $form_name localita_reg      -value $localita_reg;#gac01
		element set_properties $form_name flag_a            -value $flag_a;#gac01
		element set_properties $form_name flag_c            -value $flag_c;#gac01
		element set_properties $form_name flag_e            -value $flag_e;#gac01
		element set_properties $form_name cod_legale_rapp   -value $cod_legale_rapp;#gac01
		element set_properties $form_name indirizzo_manu    -value $indirizzo_manu;#gac01
		element set_properties $form_name comune_manu       -value $comune_manu;#gac01
		element set_properties $form_name piva              -value $piva;#gac01
		element set_properties $form_name telefono          -value $telefono;#gac01
		element set_properties $form_name fax               -value $fax;#gac01
                element set_properties $form_name email             -value $email
	    }	
	}
	#if {$coimtgen(regione) eq "MARCHE"} {
	#    if {[exists_and_not_null cod_legale_rapp]
	#	&& [db_0or1row sel_legale "
        #    select cognome as cognome_legale,
        #           nome as nome_legale
        #      from coimcitt
        #     where cod_cittadino = :cod_legale_rapp"]
	#    } {
	#	set nome_dichiarante    [string trim [element::get_value $form_name nome_dichiarante]]
	#	if {$nome_dichiarante eq ""} {
	#	    element set_properties $form_name nome_dichiarante -value $nome_legale
	#	}
	#	set cognome_dichiarante [string trim [element::get_value $form_name cognome_dichiarante]]
	#	if {$cognome_dichiarante eq ""} {
	#	    element set_properties $form_name cognome_dichiarante -value $cognome_legale
	#	}
	#	element set_properties $form_name cod_legale_rapp -value $cod_legale_rapp
	#	element set_properties $form_name cognome_legale  -value $cognome_legale
	#	element set_properties $form_name nome_legale     -value $nome_legale
	#    }
	#}
	
	# element set_properties $form_name manu_ord_1        -value "Controllo visivo dello stato di conservazione dei componentil'impianto, dello stato delle tubazioni e dei rivestimenti isolanti"
       # element set_properties $form_name manu_ord_2        -value "Controllo delle apparecchiature di termoregolazione con verifica funzionale della valvola miscelatrice"
       # element set_properties $form_name manu_ord_3        -value "Manutenzione ordinaria bruciatori con verifica della testa di combustione, elettrodi di accensione e rilevazione della fiamma, della ventola, del motore e degli accessori"
       # element set_properties $form_name manu_ord_4        -value "Analisi prodotti della combustione con calcolo rendimento ed eventuale regolazione del bruciatore"
        #element set_properties $form_name manu_ord_5        -value "Pulizia generatore, ugelli"
       # element set_properties $form_name manu_flag_1       -value "Annuale"
       # element set_properties $form_name manu_flag_2       -value "Annuale"
       # element set_properties $form_name manu_flag_3       -value "Annuale"
       # element set_properties $form_name manu_flag_4       -value "Annuale (due volte l'anno per impianti > 350 KW)"
       # element set_properties $form_name manu_flag_5       -value "Annuale"
       # element set_properties $form_name manu_stra_1       -value "Ogni qual volta si renda necessario per sostituire parti guaste o adeguare l'impianto alle norme vigenti. Si rammenta che tali opere devono essere eseguite da Ditte qualificate ai sensi di quanto previsto dal D.M. 37/08."

    } else {

	#sim01 spostato qui i defaul per evitare errori
	set reg_imprese "";#gac01
	set localita_reg "";#gac01
	set flag_a "";#gac01
	set flag_c "";#gac01
	set flag_e "";#gac01
	set cod_legale_rapp "";#gac01
	set indirizzo_manu "";#gac01
	set comune_manu "";#gac01
	set piva "";#gac01
	set telefono "";#gac01
	set fax "";#gac01
	set email "";#gac01 
	

        # leggo riga
	if {$funzione ne "I"} {
	    if {[db_0or1row sel_noveb {}] == 0} {
		iter_return_complaint "Record non trovato"
	    }

	    if {![string equal $cod_manutentore ""]} {
		if {[string range $cod_manutentore 0 1] == "MA"} {
		    db_0or1row sel_dati_manu ""
		} else {
		    db_0or1row sel_dati_citt ""
		}
	    } else {
		set cognome_manu ""
		set nome_manu ""
	    }	
	}
		    
	element set_properties $form_name reg_imprese       -value $reg_imprese;#gac01
	element set_properties $form_name localita_reg      -value $localita_reg;#gac01
	element set_properties $form_name flag_a            -value $flag_a;#gac01
	element set_properties $form_name flag_c            -value $flag_c;#gac01
	element set_properties $form_name flag_e            -value $flag_e;#gac01
	element set_properties $form_name cod_legale_rapp   -value $cod_legale_rapp;#gac01
	element set_properties $form_name indirizzo_manu    -value $indirizzo_manu;#gac01
	element set_properties $form_name comune_manu       -value $comune_manu;#gac01
	element set_properties $form_name piva              -value $piva;#gac01
	element set_properties $form_name telefono          -value $telefono;#gac01
	element set_properties $form_name fax               -value $fax;#gac01
	element set_properties $form_name email             -value $email;#gac01
	
#	if {$coimtgen(regione) eq "MARCHE"} {
#	    if {[exists_and_not_null cod_legale_rapp]
#		&& [db_0or1row sel_legale "
#            select cognome as cognome_legale,
#                   nome as nome_legale
#              from coimcitt
#             where cod_cittadino = :cod_legale_rapp"]
#	    } {
#		set nome_dichiarante    [string trim [element::get_value $form_name nome_dichiarante]]
#		if {$nome_dichiarante eq ""} {
#		    element set_properties $form_name nome_dichiarante -value $nome_legale
#		}
#		set cognome_dichiarante [string trim [element::get_value $form_name cognome_dichiarante]]
#		if {$cognome_dichiarante eq ""} {
#		    element set_properties $form_name cognome_dichiarante -value $cognome_legale
#		}
#		element set_properties $form_name cod_legale_rapp -value $cod_legale_rapp
#		element set_properties $form_name cognome_legale  -value $cognome_legale
#		element set_properties $form_name nome_legale     -value $nome_legale
#	    }
	#	}
#	set cognome_dichiarante [string trim [element::get_value $form_name cognome_dichiarante]]
#	set nome_dichiarante    [string trim [element::get_value $form_name nome_dichiarante]]

	element set_properties $form_name cognome_dichiarante -value $cognome_dichiarante;#gac01
	element set_properties $form_name nome_dichiarante    -value $nome_dichiarante;#gac01
	if {$flag_verif_emis_286 == "S"} {
            set verif_emis_286_si "t"
            set verif_emis_286_no ""
        } else {
            set verif_emis_286_si ""
            set verif_emis_286_no "t"
        }

        if {$flag_risult_conforme == "S"} {
           set risultato_conforme_si "t"
            set risultato_conforme_no ""
        } else {
            set risultato_conforme_si ""
           set risultato_conforme_no "t"
        }

        if {$dich_conformita_nr ne ""} {
            set flag_dich_conformita "t"
        } else {
            set flag_dich_conformita ""
        }

        #sistemare da qui
        element set_properties $form_name cognome_manu              -value $cognome_manu
        element set_properties $form_name nome_manu                 -value $nome_manu
        element set_properties $form_name cod_manutentore           -value $cod_manutentore

        element set_properties $form_name cod_noveb                 -value $cod_noveb
        element set_properties $form_name manu_ord_1                -value $manu_ord_1
        element set_properties $form_name manu_flag_1               -value $manu_flag_1 
        element set_properties $form_name manu_ord_2                -value $manu_ord_2
        element set_properties $form_name manu_flag_2               -value $manu_flag_2 
        element set_properties $form_name manu_ord_3                -value $manu_ord_3
        element set_properties $form_name manu_flag_3               -value $manu_flag_3 
        element set_properties $form_name manu_ord_4                -value $manu_ord_4
        element set_properties $form_name manu_flag_4               -value $manu_flag_4 
        element set_properties $form_name manu_ord_5                -value $manu_ord_5
        element set_properties $form_name manu_flag_5               -value $manu_flag_5 
        element set_properties $form_name manu_ord_6                -value $manu_ord_6
        element set_properties $form_name manu_flag_6               -value $manu_flag_6 
        element set_properties $form_name manu_ord_7                -value $manu_ord_7
        element set_properties $form_name manu_flag_7               -value $manu_flag_7 
        element set_properties $form_name manu_stra_1               -value $manu_stra_1 
        element set_properties $form_name data_consegna             -value $data_consegna
        element set_properties $form_name luogo_consegna            -value $luogo_consegna
        element set_properties $form_name flag_art_3                -value $flag_art_3
        element set_properties $form_name flag_art_11               -value $flag_art_11
        element set_properties $form_name flag_patente_abil         -value $flag_patente_abil
        element set_properties $form_name flag_art_11_comma_3       -value $flag_art_11_comma_3
        element set_properties $form_name flag_installatore         -value $flag_installatore
        element set_properties $form_name flag_responsabile         -value $flag_responsabile
        element set_properties $form_name flag_manutentore          -value $flag_manutentore
        element set_properties $form_name indirizzo_impianto        -value $indirizzo_impianto
        element set_properties $form_name combustibili              -value $combustibili
        element set_properties $form_name n_generatori              -value $n_generatori
        element set_properties $form_name pot_term_tot_mw           -value $pot_term_tot_mw
        element set_properties $form_name flag_libretto_centr       -value $flag_libretto_centr
        element set_properties $form_name flag_dich_conformita      -value $flag_dich_conformita
        element set_properties $form_name dich_conformita_nr        -value $dich_conformita_nr
        element set_properties $form_name data_dich_conform         -value $data_dich_conform
        element set_properties $form_name regolamenti_locali        -value $regolamenti_locali
        element set_properties $form_name verif_emis_286_no         -value $verif_emis_286_no
        element set_properties $form_name verif_emis_286_si         -value $verif_emis_286_si
        element set_properties $form_name data_verif_emiss          -value $data_verif_emiss
        element set_properties $form_name risultato_mg_nmc_h        -value $risultato_mg_nmc_h
        element set_properties $form_name risultato_conforme_si     -value $risultato_conforme_si
        element set_properties $form_name risultato_conforme_no     -value $risultato_conforme_no
        element set_properties $form_name data_alleg_libretto       -value $data_alleg_libretto
        element set_properties $form_name firma_dichiarante         -value $firma_dichiarante
        element set_properties $form_name data_dichiarazione        -value $data_dichiarazione
        element set_properties $form_name firma_responsabile        -value $firma_responsabile
        element set_properties $form_name data_ricevuta             -value $data_ricevuta
        element set_properties $form_name flag_consegnato           -value $flag_consegnato
         element set_properties $form_name n_prot                   -value $n_prot
        element set_properties $form_name dat_prot                 -value $dat_prot
	element set_properties $form_name flag_dichiarante         -value $flag_dichiarante;#gac01
	element set_properties $form_name flag_rispetta_val_min    -value $flag_rispetta_val_min;#gac01

        if {![string equal $pot_term_tot_mw ""]} {
            set pot_no_edit [iter_check_num $pot_term_tot_mw 4]
            set pot_term_tot_mw [expr $pot_no_edit * 1000]
            set pot_term_tot_mw [iter_edit_num $pot_term_tot_mw 2]
        } else {
            set pot_term_tot_mw ""
        }
    }
}
if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set is_controllo_ok [element::get_value $form_name is_controllo_ok];#gac02

    set cod_impianto           [element::get_value $form_name cod_impianto]
    set cod_noveb              [element::get_value $form_name cod_noveb]
    set manu_ord_1             [element::get_value $form_name manu_ord_1]
    set manu_flag_1            [element::get_value $form_name manu_flag_1]
    set manu_ord_2             [element::get_value $form_name manu_ord_2]
    set manu_flag_2            [element::get_value $form_name manu_flag_2]
    set manu_ord_3             [element::get_value $form_name manu_ord_3]
    set manu_flag_3            [element::get_value $form_name manu_flag_3]
    set manu_ord_4             [element::get_value $form_name manu_ord_4]
    set manu_flag_4            [element::get_value $form_name manu_flag_4]
    set manu_ord_5             [element::get_value $form_name manu_ord_5]
    set manu_flag_5            [element::get_value $form_name manu_flag_5]
    set manu_ord_6             [element::get_value $form_name manu_ord_6]
    set manu_flag_6            [element::get_value $form_name manu_flag_6]
    set manu_ord_7             [element::get_value $form_name manu_ord_7]
    set manu_flag_7            [element::get_value $form_name manu_flag_7]
    set manu_stra_1            [element::get_value $form_name manu_stra_1]
    set cod_manutentore        [element::get_value $form_name cod_manutentore]
    set cognome_manu           [element::get_value $form_name cognome_manu]
    set nome_manu              [element::get_value $form_name nome_manu]
    set data_consegna          [element::get_value $form_name data_consegna]
    set luogo_consegna         [element::get_value $form_name luogo_consegna]
    set flag_art_3             [element::get_value $form_name flag_art_3]
    set flag_art_11            [element::get_value $form_name flag_art_11]
    set flag_patente_abil      [element::get_value $form_name flag_patente_abil]
    set flag_art_11_comma_3    [element::get_value $form_name flag_art_11_comma_3]
    set flag_installatore      [element::get_value $form_name flag_installatore]
    set flag_responsabile      [element::get_value $form_name flag_responsabile]
    set flag_manutentore       [element::get_value $form_name flag_manutentore]
    set indirizzo_impianto     [element::get_value $form_name indirizzo_impianto]
    if {$coimtgen(regione) ne "MARCHE"} {#gac01 if else e contenuto di else
	set combustibili           [element::get_value $form_name combustibili]
	set n_generatori           [element::get_value $form_name n_generatori]
	set pot_term_tot_mw        [element::get_value $form_name pot_term_tot_mw]
    } else {
	set combustibili           [element::get_value $form_name combustibile]
	set n_generatori           [element::get_value $form_name n_generatori_marche]
	set pot_term_tot_mw        [element::get_value $form_name potenza_utile]
    }
    
    set flag_libretto_centr    [element::get_value $form_name flag_libretto_centr]
    set flag_dich_conformita   [element::get_value $form_name flag_dich_conformita]
    set dich_conformita_nr     [element::get_value $form_name dich_conformita_nr]
    set data_dich_conform      [element::get_value $form_name data_dich_conform]
    set regolamenti_locali     [element::get_value $form_name regolamenti_locali]
    set verif_emis_286_no      [element::get_value $form_name verif_emis_286_no]
    set verif_emis_286_si      [element::get_value $form_name verif_emis_286_si]
    set data_verif_emiss        [element::get_value $form_name data_verif_emiss]
    set risultato_mg_nmc_h     [element::get_value $form_name risultato_mg_nmc_h]
    set risultato_conforme_si  [element::get_value $form_name risultato_conforme_si]
    set risultato_conforme_no  [element::get_value $form_name risultato_conforme_no]
    set data_alleg_libretto    [element::get_value $form_name data_alleg_libretto]
    set firma_dichiarante      [element::get_value $form_name firma_dichiarante]
    set data_dichiarazione     [element::get_value $form_name data_dichiarazione]
    set firma_responsabile     [element::get_value $form_name firma_responsabile]
    set data_ricevuta          [element::get_value $form_name data_ricevuta]
    set flag_consegnato        [element::get_value $form_name flag_consegnato]
    set n_prot                 [element::get_value $form_name n_prot]
    set dat_prot              [element::get_value $form_name dat_prot]    
    set flag_dichiarante      [element::get_value $form_name flag_dichiarante]
    set __refreshing_p   [element::get_value $form_name __refreshing_p];#gac01
    set changed_field    [element::get_value $form_name changed_field];#gac01
    set flag_rispetta_val_min [element::get_value $form_name flag_rispetta_val_min];#gac01
    # controlli standard su numeri e date, per Ins ed Upd
    set cognome_dichiarante [string trim [element::get_value $form_name cognome_dichiarante]]
    set nome_dichiarante    [string trim [element::get_value $form_name nome_dichiarante]]

    element set_properties $form_name cognome_dichiarante -value $cognome_dichiarante;#gac01
    element set_properties $form_name nome_dichiarante    -value $nome_dichiarante;#gac01
    

    
     if {$funzione == "I"} {
	set n_prot [db_string query "select descr || '/' || progressivo + 1 from coimtppt where cod_tppt = 'XU'"]
	set dat_prot [db_string query "select iter_edit_data(current_date)"]
       set dat_prot [iter_check_date $dat_prot]

    }

    
    set error_num 0
    if {$funzione == "I" || $funzione == "M"} {
    
        if {![string equal $data_consegna ""]} {
            set data_consegna [iter_check_date $data_consegna]
            if {$data_consegna == 0} {
                element::set_error $form_name data_consegna "Data consegna deve essere una data"
                incr error_num
            } else {
                if {$data_consegna > $current_date} {
                    element::set_error $form_name data_consegna  "Data deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        } else {
            element::set_error $form_name data_consegna "Campo obbligatorio"
            incr error_num
        }
	
        if {![string equal $data_dich_conform ""]} {
            set data_dich_conform [iter_check_date $data_dich_conform]
            if {$data_dich_conform == 0} {
                element::set_error $form_name data_dich_conform "Data dichiarazione conformita' deve essere una data"
                incr error_num
            } else {
                if {$data_dich_conform > $current_date} {
                    element::set_error $form_name data_dich_conform "Data deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        }
	
        if {![string equal $data_verif_emiss ""]} {
            set data_verif_emiss [iter_check_date $data_verif_emiss]
            if {$data_verif_emiss == 0} {
                element::set_error $form_name data_verif_emiss "Data verifica emissioni deve essere una data"
                incr error_num
            } else {
                if {$data_verif_emiss > $current_date} {
                    element::set_error $form_name data_verif_emiss "Data deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        }
	
        if {![string equal $data_alleg_libretto ""]} {
            set data_alleg_libretto [iter_check_date $data_alleg_libretto]
            if {$data_alleg_libretto == 0} {
                element::set_error $form_name data_alleg_libretto "Data libretto deve essere una data"
                incr error_num
            } else {
                if {$data_alleg_libretto > $current_date} {
                    element::set_error $form_name data_alleg_libretto "Data libretto deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        }
        if {![string equal $data_dichiarazione ""]} {
            set data_dichiarazione [iter_check_date $data_dichiarazione]
            if {$data_dichiarazione == 0} {
                #sim01 element::set_error $form_name data_verif_emiss "Data dichiarazione deve essere una data"
                element::set_error $form_name data_dichiarazione "Data dichiarazione deve essere una data";#sim01
		incr error_num
            } else {
                if {$data_dichiarazione > $current_date} {
                    element::set_error $form_name data_dichiarazione "Data deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        }
	
        if {![string equal $data_ricevuta ""]} {
            set data_ricevuta [iter_check_date $data_ricevuta]
            if {$data_ricevuta == 0} {
                element::set_error $form_name data_ricevuta "Data ricevuta emissioni deve essere una data"
                incr error_num
            } else {
                if {$data_ricevuta > $current_date} {
                    element::set_error $form_name data_ricevuta "Data deve essere anteriore alla data odierna"
                    incr error_num
                }
            }
        }
	
        if {![string equal $pot_term_tot_mw ""]} {
            set pot_term_tot_mw [iter_check_num $pot_term_tot_mw 4]
            if {$pot_term_tot_mw == "Error"} {
                element::set_error $form_name pot_term_tot_mw "Deve essere numerico, max 4 dec"
                incr error_num
            } else {
                if {[iter_set_double $pot_term_tot_mw] >=  [expr pow(10,4)]
                    ||  [iter_set_double $pot_term_tot_mw] <= -[expr pow(10,4)]} {
                    element::set_error $form_name pot_term_tot_mw "Deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        } else {
            if {$flag_consegnato != "S"} {
                element::set_error $form_name pot_term_tot_mw "Inserire"
                incr error_num
            }
        }

        if {![string equal $n_generatori ""]} {
            set n_generatori [iter_check_num $n_generatori 0]
            if {$n_generatori == "Error"} {
                element::set_error $form_name n_generatori "deve essere numerico"
                incr error_num
            }
        }
	
        if {![string equal $dich_conformita_nr ""]} {
            set dich_conformita_nr [iter_check_num $dich_conformita_nr 0]
            if {$dich_conformita_nr == "Error"} {
                element::set_error $form_name dich_conformita_nr "deve essere numerico"
                incr error_num
            }
        }
	
        if {$verif_emis_286_si == "t"} {
            set flag_verif_emis_286 "S"
        } else {
            set flag_verif_emis_286 "N"
        }
        
	if {$verif_emis_286_no == "t"} {
            set flag_verif_emis_286 "N"
        } else {
            set flag_verif_emis_286 "S"
        }
	
        if {![string equal $risultato_mg_nmc_h ""]} {
            set risultato_mg_nmc_h [iter_check_num $risultato_mg_nmc_h 0]
            if {$risultato_mg_nmc_h == "Error"} {
                element::set_error $form_name risultato_mg_nmc_h "deve essere numerico"
                incr error_num
            }
        }
	
        if {$risultato_conforme_si == "t"} {
            set flag_risult_conforme "S"
        } else {
            set flag_risult_conforme "N"
        }

        if {[string equal $cod_noveb ""]} {
            element::set_error $form_name cod_noveb "Inserire"
            incr error_num
        } else {
            if {$funzione == "I"} {
                #if {[db_0or1row sel_cod_check ""] == 1} {
		#   element::set_error $form_name cod_noveb "Codice gi&agrave; esistente"
		#  incr error_num
                #}
            }
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
            db_foreach sel_manu_cont "" {
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
	
        set check_cod_citt {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_citt ""
            set ctr_citt         0
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
            db_foreach sel_citt "" {
                incr ctr_citt
                if {$cod_manutentore == $chk_inp_cod_citt} {
                    set chk_out_cod_citt $cod_manutentore
                    set chk_out_rc       1
                }
            }
            switch $ctr_citt {
                0 { set chk_out_msg "Soggetto non trovato"}
                1 { set chk_out_cod_citt $cod_manutentore
                    set chk_out_rc       1 }
                default {
                    if {$chk_out_rc == 0} {
                        set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
                    }
                }
            }
        }
	
        if {[string equal $cognome_manu ""] && [string equal $nome_manu ""]} {
	    if {$coimtgen(regione) eq "MARCHE"} {
		element::set_error $form_name cognome_manu "Inserire installatore/manutentore"
		incr error_num
	    } else {
		if {$flag_consegnato != "S"} {
		    element::set_error $form_name cognome_manu "Inserire manutentore"
		    incr error_num
		} else {
		    set cod_manutentore ""
		}
	    }
	} else {
            if {[string range $cod_manutentore 0 1] == "MA"} {
                set chk_inp_cod_manu $cod_manutentore
                set chk_inp_cognome  $cognome_manu
                set chk_inp_nome     $nome_manu
                eval $check_cod_manu
                set cod_manutentore  $chk_out_cod_manu
                if {$chk_out_rc == 0} {
                    element::set_error $form_name cognome_manu $chk_out_msg
                    incr error_num
                }
            } else {
                set chk_inp_cod_citt $cod_manutentore
                set chk_inp_cognome  $cognome_manu
                set chk_inp_nome     $nome_manu
                eval $check_cod_citt
                set cod_manutentore  $chk_out_cod_citt
                if {$chk_out_rc == 0} {
                    element::set_error $form_name cognome_manu $chk_out_msg
                    incr error_num
                }
            }
        }
	
        set errore_1 ""
        set errore_2 ""
        set errore_3 ""
	
	if {$coimtgen(regione) eq "MARCHE"} {#ric01 aggiunta if ma non suo contenuto
	    
	    if {$flag_art_3 eq "" && $flag_art_11 eq ""} {
		set errore_1 "Indicare una delle due possibilita'"
		incr error_num
	    }
	    if {$flag_patente_abil eq "" && $flag_art_11_comma_3 eq ""} {
		set errore_2 "Indicare una delle due possibilita'"
		incr error_num
	    }
	    
	} else {#ric01 aggiunta else e suo contenuto
	
	    if {$flag_art_3 eq ""} {
		set errore_1 "Selezionare requisito"
                incr error_num
	    }
	    
	};#ric01
	
	if {$coimtgen(regione) ne "MARCHE"} {
	    if {$flag_installatore eq "" && $flag_responsabile eq "" && $flag_manutentore eq ""} {
		set errore_3 "Indicare una delle 3 possibilita'"
		incr error_num
	    }
	} else {
	    if {$flag_installatore eq "" && $flag_manutentore eq "" && $flag_rispetta_val_min eq ""} {
		set errore_3 "Indicare una delle 3 possibilita'"
		incr error_num
	    }
	}
    }

    if {$coimtgen(regione) eq "MARCHE"} {
	if {$cognome_dichiarante eq "" && $nome_dichiarante eq ""} {
	    element::set_error $form_name cognome_dichiarante "Inserire"
	    incr error_num
	}
    }
    if {$error_num > 0} {
        ad_return_template
        return
    }
    if {$funzione == "I"} {
	db_1row sel_next_noveb ""
    }
    if {$funzione == "I"} {
	if {[db_0or1row sel_cod_check ""] == 1} {
	    element::set_error $form_name cod_noveb "Codice gi&agrave; esistente"
	    incr error_num
	}
    }
    if {$error_num > 0} {
        ad_return_template
        return
    }
    
    # Lancio la query di manipolazione dati contenuta in dml_sql
    with_catch error_msg {
        db_transaction {
            switch $funzione {
                I {db_dml ins_noveb ""
                db_dml upd_tppt  ""}	
                M {db_dml upd_noveb ""}
                D {db_dml del_noveb ""}
            }
        }
    } {
        iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto cod_noveb nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]
    switch $funzione {
        M {set return_url   "coimnoveb-gest?funzione=V&$link_gest"}
        D {set return_url   "coimdimpb-list?$link_list"}
        I {set return_url   "coimnoveb-gest?funzione=V&$link_gest"}
        V {set return_url   "coimdimpb-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
