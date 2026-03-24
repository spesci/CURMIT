ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Giulio Laurenzi
    @creation-date   00/08/2006

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                       navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimdimp-fr-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    nic03 24/05/2014 Devo esporre ed aggiornare le potenze del generatore e non dell'impianto
    nic03            Il campo Potenza termica nominale in riscaldamento (utile) non è
    nic03            coimgend.pot_focolare_nom ma coimgend.pot_utile_lib (per ora, non è
    nic03            visualizzato nella gestione del generatore)

    nic02 23/05/2014 Se presente più di un generatore, l'utente deve scegliere a quale si
    nic02            riferisce

    nic01 15/05/2014 Comune di Rimini: se è attivo il parametro flag_gest_coimmode, deve
    nic01            comparire un menù a tendina con l'elenco dei modelli relativi al
    nic01            costruttore selezionato (tale menù a tendina deve essere rigenerato
    nic01            quando si cambia la scelta del costruttore).
    nic01            Ho dovuto aggiungere la gestione dei campi __refreshing_p e changed_field.
} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {flag_no_link        "F"}
    {url_gage             ""}
    {cod_opma             ""}
    {data_ins             ""}
    {cod_impianto_est_new ""}
    {gen_prog             ""}
    {flag_modello_h       ""}
    {flag_tracciato       ""}
    {tabella              ""}
    {cod_dimp_ins         ""}
    {transaz_eff          ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

set flag_tracciato "R2"

ad_return_if_another_copy_is_running

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

#modifica del 120913
if {$funzione eq "I"} {
    db_1row query "select coalesce(stato, '') as stato_imp from coimaimp where cod_impianto = :cod_impianto"    
    if {$stato_imp ne "A" } {
        iter_return_complaint "
        Funzione impossibile per impianti annullati/Non attivi/Rottamati"  
	ad_script_abort
    }
}
#fine modifica

if {$funzione ne "I"} {
    db_1row query "select coalesce(stato_dich, '') as stato_dich
                        , gen_prog -- nic02
                     from coimdimp
                    where cod_dimp = :cod_dimp"    
    if {$stato_dich eq "A" || $stato_dich eq "X" || $stato_dich eq "R"} {
	set funzione "V"
	set menu 0
    } else {
	set menu 1
    }
} else {
    set menu 1
}
if {[exists_and_not_null tabella]} {
    if {![exists_and_not_null cod_dimp]} {
	set cod_dimp $cod_dimp_ins
    }
    db_1row query "select data_controllo, coalesce(stato_dich, '') as stato_dich  from coimdimp where cod_dimp = :cod_dimp"    
    if {$data_controllo < "2008-08-01"} {
	iter_return_complaint "
        Funzione possibile solo per dichiarazioni con data controllo successiva all '01/08/2008'."  
	ad_script_abort
    }
    if {![exists_and_not_null gen_prog]} {#nic02
        iter_return_complaint "Storno impossibile. Generatore mancante ";#nic02
        ad_script_abort;#nic02
    };#nic02
    set stn "_stn"
    set funzione_stn " "
    if {[db_0or1row query "select 1 from coimanom where cod_cimp_dimp = :cod_dimp limit 1"] == 1} {
	iter_return_complaint "Presenti anomalie. Funzione di storno impossibile"
    }		
    if {[db_0or1row query "select 1 from coimdimp_stn where cod_dimp = :cod_dimp"]==0} {
	set funzione "I"
	set cod_dimp_ins $cod_dimp
    }
    if {$stato_dich != ""} {
	if {$funzione == "I"} {
	    iter_return_complaint "Dichiarazione sostitutiva non inseribile per dichiarazioni gia oggetto di storno"
	} else {
	    set funzione "V"
	}   
    }		
} else {
    set stn " "
    set funzione_stn " "
    set tabella ""
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_ma [string range $id_utente 0 1]

iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set cod_comu         $coimtgen(cod_comu)
set gg_scad_pag_mh   $coimtgen(gg_scad_pag_mh)
set flag_agg_sogg    $coimtgen(flag_agg_sogg)
set flag_dt_scad     $coimtgen(flag_dt_scad)
set flag_gg_modif_mh $coimtgen(flag_gg_modif_mh)
set flag_gg_modif_rv $coimtgen(flag_gg_modif_rv)

set link_gest [export_url_vars cod_dimp last_cod_dimp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp url_gage flag_no_link cod_opma data_ins tabella cod_dimp_ins]

# valorizzo pack_dir che sara' utilizzata sull'adp per fare i link.
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"

set msg_limite ""

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {$transaz_eff == "T"} {
    set report "Transazione effettuata con successo"
    set report1 "Attenzione - La tue dichiarazioni verranno accettate anche se il credito disponibile sul tuo Portafoglio manutentore non Ã¨ al momento sufficiente. Ti verrÃ  quindi contabilizzato un debito che dovrai rifondere alla prima ricarica del tuo Portafoglio. In questa occasione ti sarÃ  detratta automaticamente la quota negativa accumulata. Maggiori informazioni sul tuo Portafoglio sono disponibili sul portale www.curit.it."
} else {
    set report ""
    set report1 ""
}

# imposto la proc per i link e per il dettaglio impianto
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp  {} $flag_tracciato]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set link_list_script {[export_url_vars tariffa_reg nome_funz_caller nome_funz cod_impianto url_list_aimp url_aimp last_cod_dimp caller tabella cod_dimp_ins]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set link_gest_dimp $link_gest
set link_list_dimp $link_list

set link_anom "[export_url_vars cod_impianto gen_prog last_cod_cimp nome_funz_caller extra_par caller url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]&nome_funz=[iter_get_nomefunz coimanom-list]&cod_cimp_dimp=$cod_dimp&flag_origine=MH"

#04/08/2014: non prevedo questo link perche' non esiste la funzione ed il programma relativo a coim_d_anom-list
#set link_d_anom "[export_url_vars cod_impianto gen_prog last_cod_cimp nome_funz_caller extra_par caller url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]&nome_funz=[iter_get_nomefunz coim_d_anom-list]&cod_cimp_dimp=$cod_dimp&flag_origine=MH"
set link_d_anom ""

# agg dob cind
db_1row sel_mod_gend "select flag_mod_gend,flag_cind from coimtgen"
#set flag_cind "S"
set titolo "RCEE Tipo 2"
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

db_1row sel_tgen_portafoglio "select flag_portafoglio from coimtgen"
if {[exists_and_not_null tabella]} {
    set flag_portafoglio "F"
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimdimp"
set focus_field  "";#nic01
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

set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

if {$funzione_stn eq "I"} {
    set readonly_key \{\}
    set readonly_fld \{\}
    set disabled_fld \{\}
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

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

set cod_manu [iter_check_uten_manu $id_utente]

if {($funzione == "I" || $funzione == "M") && [string equal $cod_manu ""]} { 
    if {$flag_portafoglio == "T"} {
	set cerca_manu [iter_search $form_name [ad_conn package_url]/src/coimmanu-list [list dummy cod_manutentore f_cognome cognome_manu dummy nome_manu dummy saldo_manu dummy cod_portafoglio]]
    } else {
	set cerca_manu [iter_search $form_name [ad_conn package_url]/src/coimmanu-list [list dummy cod_manutentore f_cognome cognome_manu dummy nome_manu]]
    }
} else {
    set cerca_manu ""
}

if {[string range $id_utente 0 1] == "AM"} {
    set cod_manu $id_utente
}

if {$funzione == "I" || $funzione == "M"} { 
    set cerca_opma [iter_search $form_name [ad_conn package_url]/src/coimopma-list [list cod_manutentore cod_manutentore dummy cod_opmanu_new f_cognome nome_opma f_nome cognome_opma]]
} else {
    set cerca_opma ""
}

element create $form_name cognome_resp \
    -label   "Cod responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_resp \
    -label   "Cod responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_fiscale_resp \
    -label   "Cod fiscale responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 16 maxlength 16 readonly {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_resp [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_responsabile f_cognome cognome_resp f_nome nome_resp]]
} else {
    set cerca_resp ""
}

element create $form_name cognome_prop \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_prop \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name consumo_annuo \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name consumo_annuo2 \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name stagione_risc \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

element create $form_name stagione_risc2 \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

# agg dob cind
element create $form_name cod_cind \
    -label   "campagna" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcind cod_cind descrizione]

if {$flag_mod_gend == "S"} {
    element create $form_name matricola \
	-label   "Matricola" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 35 $readonly_fld {} class form_element" \
	-optional

    if {$coimtgen(flag_gest_coimmode) eq "F"} {#nic01
	element create $form_name modello \
	    -label   "Modello" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 40 $readonly_fld {} class form_element" \
	    -optional

        element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01

        set html_per_costruttore "";#nic01
    } else {;#nic01
        element create $form_name modello  -widget hidden -datatype text -optional;#nic01

        element create $form_name cod_mode \
                -label   "modello" \
                -widget   select \
                -datatype text \
                -html    "$disabled_fld {} class form_element" \
                -optional \
                -options "";#nic01

        set html_per_costruttore "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='costruttore';document.$form_name.submit.click()";#nic01
    };#nic01

    element create $form_name costruttore \
	-label   "costruttore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element $html_per_costruttore" \
	-optional \
	-options [iter_selbox_from_table coimcost cod_cost descr_cost]
  

    #modifica sandro del 08-05-13  
    set l_of_l  [db_list_of_lists query "select descr_comb, cod_combustibile from coimcomb where cod_combustibile <> '0'"]
    set cod_com  [linsert $l_of_l 0 [list "" ""]]
    element create $form_name combustibile \
	-label   "combustibile" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options $cod_com
    # fine

    element create $form_name tiraggio \
	-label   "tipo tiraggio" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {Forzato F} {Naturale N}}

    element create $form_name tipo_a_c \
	-label   "Tipo aperto/chiuso" \
	-widget   select \
	-options  {{Aperto A} {Chiuso C} {{} {}}} \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional

    element create $form_name data_insta \
	-label   "Data installazione" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 $readonly_fld {} class form_element $jq_date" \
	-optional

    element create $form_name destinazione \
	-label   "cod_utgi" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options [iter_selbox_from_table_obblig coimutgi cod_utgi descr_utgi cod_utgi] 

    element create $form_name locale \
	-label   "Locale" \
	-widget   select \
	-options {{{} {}} {Tecnico T} {Esterno E} {Interno I}} \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional
    
    element create $form_name data_costruz_gen \
	-label   "Data costruzione generatore" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element $jq_date" \
	-optional
    
    element create $form_name marc_effic_energ \
	-label   "Marcatura efficienza energetica" \
	-widget   text \
	-datatype text \
	-html    "size 4 maxlength 10 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name volimetria_risc \
	-label   "Volimetria riscaldata" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element" \
	-optional
    
#nic03  element create $form_name pot_focolare_nom \
#nic03	-label   "potenza_focolare" \
#nic03	-widget   text \
#nic03	-datatype text \
#nic03	-html    "size 10 $readonly_fld {} class form_element" \
#nic03	-optional
    
    element create $form_name potenza \
	-label   "Potenza" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional

    element create $form_name pot_utile_lib \
	-label   "pot_utile_lib" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element" \
	-optional;#nic03

} else {
    element create $form_name costruttore \
	-label   "Costruttore" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional

    element create $form_name modello \
	-label   "Modello" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01

    element create $form_name matricola \
	-label   "Matricola" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name combustibile \
	-label   "Combustibile" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name tiraggio \
	-label   "Tiraggio" \
	-widget   select \
	-options  {{Naturale N} {Forzato F} {{} {}}} \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional
    
    element create $form_name tipo_a_c \
	-label   "Tipo A/C" \
	-widget   select \
	-options  {{Aperto A} {Chiuso C} {{} {}}} \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional
    
    element create $form_name data_insta \
	-label   "Data installazione" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element $jq_date" \
	-optional
    
    element create $form_name destinazione \
	-label   "Destinazione" \
	-widget   text \
	-datatype text \
	-html    "size 40 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name locale \
	-label   "Locale" \
	-widget   select \
	-options {{{} {}} {Tecnico T} {Esterno E} {Interno I}} \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional
    
    element create $form_name data_costruz_gen \
	-label   "Data costruzione generatore" \
	-widget   text \
	-datatype text \
	-html    "size 10 readonly {} class form_element $jq_date" \
	-optional
    
    element create $form_name marc_effic_energ \
	-label   "Marcatura efficienza energetica" \
	-widget   text \
	-datatype text \
	-html    "size 4 readonly {} class form_element" \
	-optional
    
    element create $form_name volimetria_risc \
	-label   "Volimetria riscaldata" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element" \
	-optional
    
#nic03  element create $form_name pot_focolare_nom \
#nic03	-label   "potenza_focolare" \
#nic03	-widget   text \
#nic03	-datatype text \
#nic03	-html    "size 10  readonly {} class form_element" \
#nic03	-optional
    
    element create $form_name potenza \
	-label   "Potenza" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional

    element create $form_name pot_utile_lib \
	-label   "pot_utile_lib" \
	-widget   text \
	-datatype text \
	-html    "size 10  readonly {} class form_element" \
	-optional;#nic03
}

if {$funzione == "I" || $funzione == "M"} {
    set cerca_prop [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_proprietario f_cognome cognome_prop f_nome nome_prop]]

} else {
    set cerca_prop ""
}

element create $form_name cognome_occu \
    -label   "Cod occupante" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_occu \
    -label   "Cod occupante" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_occu [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_occupante f_cognome cognome_occu f_nome nome_occu]]
} else {
    set cerca_occu ""
}

element create $form_name cognome_contr \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_contr \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_contr [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_int_contr f_cognome cognome_contr f_nome nome_contr]]
} else {
    set cerca_contr ""
}

db_1row sel_anom_count2 ""

if {$funzione == "I" || $funzione == "V" || $funzione == "D"
    || ( $funzione == "M" && $conta_anom_2 == 0)} {
    set vis_desc_contr "f"
    element create $form_name flag_status \
	-label   "status" \
	-widget   select \
	-options  {{{} {}} {S&igrave; P} {No N}} \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional
} else {
    set vis_desc_contr "t"
    element create $form_name flag_stat \
	-label   "flag_stat" \
	-widget   text \
	-datatype text \
	-html    "size 10 readonly {} class form_element" \
	-optional 

    element set_properties $form_name flag_stat -value "Negativo"
    element create $form_name flag_status -widget hidden -datatype text -optional
}

element create $form_name garanzia \
    -label   "Garanzia" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name conformita \
    -label   "Conformit&agrave;" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name lib_impianto \
    -label   "Libretto impianto" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name lib_uso_man \
    -label   "Libretto uso/manut." \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name inst_in_out \
    -label   "Idoneita dei locali" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {{ES.&nbsp;} E} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name idoneita_locale \
    -label   "Idoneit&agrave; del locale" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {{ES.&nbsp;} E} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_dur_acqua \
    -label   "Durezza totale dell'acqua" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name rct_tratt_in_risc \
    -label   "Trattamento in riscaldamento" \
    -widget   select \
    -options  {{NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_tratt_in_acs \
    -label   "Trattamento in acs" \
    -widget   select \
  -options  {{NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_install_interna \
    -label   "Installazione Interna" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_install_esterna \
    -label   "Installazione Interna" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name ap_vent_ostruz \
    -label   "Apertura ventilazione areaz. ostruita" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name ap_ventilaz \
    -label   "Dimensioni aperture" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name rct_canale_fumo_idoneo  \
    -label   "canale_fumo_idoneo " \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_sistema_reg_temp_amb \
    -label   "sistema_reg_temp_ambi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_assenza_per_comb \
    -label   "rct_assenza_per_comb" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_idonea_tenuta \
    -label   "rct_idonea_tenuta" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_gruppo_termico \
    -label   "Gruppo Termico" \
    -widget   select \
    -options  {{Singolo S} {Modulare M} {Tubo/Nastro T}  {Aria_calda A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name disp_comando \
    -label   "Dispositivi di comando" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name disp_sic_manom \
    -label   "Dispositivi di sicurezza non manomessi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name rct_valv_sicurezza \
    -label   "rct_valv_sicurezza" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_scambiatore_lato_fumi \
    -label   "rct_scambiatore_lato_fumi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_riflussi_comb \
    -label   "rct_riflussi_comb" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_uni_10389 \
    -label   "rct_uni_10389" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_lib_uso_man_comp \
    -label   "lib_uso_man_comp" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
#-----------freddo ------------------------------

element create $form_name fr_linee_ele \
    -label   "fr_linee_ele" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_coibentazione \
    -label   "fr_coibentazione" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_assorb_recupero \
    -label   "fr_assorb_recupero" \
    -widget   select \
    -options  {{S&igrave; S} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_assorb_fiamma \
    -label   "fr_assorb_fiamma" \
    -widget   select \
    -options  {{S&igrave; S} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_ciclo_compressione \
    -label   "fr_ciclo_compressione" \
    -widget   select \
    -options  {{S&igrave; S} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_assenza_perdita_ref \
    -label   "fr_assenza_perdita_ref" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_leak_detector \
    -label   "fr_leak_detector" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_pres_ril_fughe \
    -label   "fr_pres_ril_fughe" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_scambiatore_puliti \
    -label   "fr_scambiatore_puliti" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_prova_modalita \
    -label   "fr_prova_modalita" \
    -widget   select \
    -options  {{Raff.; F} {Risca C}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name fr_surrisc \
    -label   "fr_surrisc" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_sottoraff \
    -label   "fr_sottoraff" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_tcondens \
    -label   "fr_tcondens" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_tevapor \
    -label   "fr_tevapor" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_t_ing_lato_est \
    -label   "fr_t_ing_lato_est" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_t_usc_lato_est \
    -label   "fr_t_usc_lato_est" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_t_ing_lato_ute \
    -label   "fr_t_ing_lato_ute" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional



element create $form_name fr_t_usc_lato_ute \
    -label   "fr_t_usc_lato_ute" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name fr_nr_circuito \
    -label   "fr_nr_circuito" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional


element create  $form_name  fr_check_list_1 \
    -label   "check list 1" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  fr_check_list_2 \
    -label   "check list 2" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  fr_check_list_3 \
    -label   "check list 3" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  fr_check_list_4 \
    -label   "check list 4" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

#------------------da togliere
element create $form_name scar_ca_si \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name sezioni \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create $form_name conservazione \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name lunghezza \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name curve \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name scar_parete \
    -label   "Scarico a parete" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name riflussi_locale \
    -label   "Riflussi nel locale" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name assenza_perdite \
    -label   "Assenza perdite" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name pulizia_ugelli \
    -label   "Pulizia ugelli" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name antivento \
    -label   "Antivento" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name scambiatore \
    -label   "Scambiatore" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name accens_reg \
    -label   "Accensione regolare" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name ass_perdite \
    -label   "Assenza perdite" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name valvola_sicur \
    -label   "Valvoal di sicurezza" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name vaso_esp \
    -label   "Vaso espansore" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional



element create $form_name organi_integri \
    -label   "Organi integri" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name circ_aria \
    -label   "Circolazione aria" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name guarn_accop \
    -label   "Guarnizione di accoppiamento integra" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name assenza_fughe \
    -label   "Assenza di fughe" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name coibentazione \
    -label   "Coibentazione" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name eff_evac_fum \
    -label   "Efficenza evacuazione fumi" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

#da togliere fine

element create $form_name cont_rend \
    -label   "Controllo rendimento" \
    -widget   select \
    -options  {{Effettuato S} {{Non effettuato} N} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name pot_focolare_mis \
    -label   "Potenza focolare misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name portata_comb_mis \
    -label   "Portata combustibile misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name pendenza \
    -label   "Portata combustibile misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional
element create $form_name temp_fumi \
    -label   "Temperatura fumi" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_ambi \
    -label   "Temperatura ambiente" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name o2 \
    -label   "o2" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name co2 \
    -label   "co2" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name bacharach \
    -label   "Bacharach" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name co \
    -label   "co" \
    -widget   text \
    -datatype text \
    -html    "size 6 maxlength 14 $readonly_fld {} class form_element" \
    -optional

element create $form_name rend_combust \
    -label   "Rendimento combustibile" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional


element create $form_name rct_rend_min_legge \
    -label   "Rendimento combustibile minimo" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create  $form_name  rct_check_list_1 \
    -label   "check list 1" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_2 \
    -label   "check list 2" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_3 \
    -label   "check list 3" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_4 \
    -label   "check list 4" \
    -widget   select \
    -options  {{S S} {N N}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name osservazioni \
    -label   "Osservazioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 100 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name raccomandazioni \
    -label   "Raccomandazioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 100 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name prescrizioni \
    -label   "Prescrizioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 100 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_utile_inter \
    -label   "Data utile intervento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_controllo \
    -label   "Data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
    -optional

element create $form_name n_prot \
    -label   "Num. protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name data_prot \
    -label   "Data protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name saldo_manu \
    -label   "saldo_manu" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional

element create $form_name cod_portafoglio \
    -label   "saldo_manu" \
    -widget   text \
    -datatype text \
    -html    "size 25 maxlength 25 readonly {} class form_element" \
    -optional

element create $form_name delega_resp \
    -label   "Delega responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
    -optional

element create $form_name delega_manut \
    -label   "Delega manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
    -optional

element create $form_name riferimento_pag \
    -label   "Rif. n bollino" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name costo \
    -label   "Costo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

if {$flag_portafoglio == "T"} {

    #    if {$funzione == "I"
    #	&& [db_0or1row sel_old_dimp ""] == 0} {
    #	element create $form_name tariffa_reg \
				   #	    -label   "Tipo costo" \
				   #	    -widget   select \
				   #	    -datatype text \
				   #	    -html    {onChange "document.coimdimp.__refreshing_p.value='1';document.coimdimp.submit.click()"} \
				   #	    -optional \
				   #	    -options { {{Contributo Regionale} 7} {{Prima accensione} 8}}
    #    } else {
    element create $form_name tariffa_reg \
	-label   "Tipo costo" \
	-widget   select \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options { {{Contributo Regionale} 7} {{Prima accensione} 8}}
    #    }
    element create $form_name importo_tariffa \
	-label   "Costo" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 readonly {} class form_element" \
	-optional
}

set l_of_l [db_list_of_lists sel_lol "select descrizione, cod_tipo_pag from coimtp_pag where cod_tipo_pag not in ('BO', 'LM') order by ordinamento"]
set options_cod_tp_pag [linsert $l_of_l 0 [list "" ""]]

element create $form_name tipologia_costo \
    -label   "Tipo pagamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_cod_tp_pag

element create $form_name flag_pagato \
    -label   "Pagato" \
    -widget   select \
    -options  {{No N} {S&igrave; S}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name data_scad_pagamento \
    -label   "Data scadenza pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name scar_can_fu \
    -label   "scarico canna fumaria ramificata" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tiraggio_fumi \
    -label   "Tiraggio" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name ora_inizio \
    -label   "Ora inizio" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
    -optional

element create $form_name ora_fine \
    -label   "Ora fine" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_scadenza_autocert \
    -label   "Potenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
    -optional

element create $form_name num_autocert \
    -label   "Numero autocertificazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_arrivo_ente \
    -label   "Data di arrivo all'ente" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional


element create $form_name prog_anom_max \
    -widget   hidden \
    -datatype text \
    -optional

element create $form_name tabella \
    -widget   hidden \
    -datatype text \
    -optional

element create $form_name cod_dimp_ins \
    -widget   hidden \
    -datatype text \
    -optional

set conta 0
multirow create multiple_form conta

while {$conta < 5} {
    incr conta

    multirow append multiple_form $conta

    element create $form_name prog_anom.$conta \
	-widget   hidden \
	-datatype text \
	-optional

    element create $form_name cod_anom.$conta \
	-label    "anomalia" \
	-widget   select \
	-datatype text \
	-html     "$disabled_fld {} class form_element" \
	-optional \
	-options [iter_selbox_from_table_wherec coimtano cod_tano "cod_tano||' - '||descr_breve" "" "where (flag_modello = 'S'
                                                                                                   or flag_modello is null)
                                                                                         and (data_fine_valid > current_date
                                                                                          or data_fine_valid is null)"]

    element create $form_name data_ut_int.$conta \
	-label    "data utile intervento" \
	-widget   text \
	-datatype text \
	-html     "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
	-optional 
}

element create $form_name flag_tracciato   -widget hidden -datatype text -optional
element create $form_name list_anom_old    -widget hidden -datatype text -optional
element create $form_name cod_opma         -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name data_ins         -widget hidden -datatype text -optional
element create $form_name cod_dimp         -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
#nic01 element create $form_name submitbut -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit";#nic01
element create $form_name last_cod_dimp    -widget hidden -datatype text -optional
element create $form_name cod_responsabile -widget hidden -datatype text -optional
element create $form_name cod_manutentore  -widget hidden -datatype text -optional
element create $form_name cod_opmanu_new   -widget hidden -datatype text -optional
element create $form_name cod_proprietario -widget hidden -datatype text -optional
element create $form_name cod_occupante    -widget hidden -datatype text -optional
element create $form_name url_list_aimp    -widget hidden -datatype text -optional
element create $form_name url_aimp         -widget hidden -datatype text -optional
element create $form_name url_gage         -widget hidden -datatype text -optional
element create $form_name flag_no_link     -widget hidden -datatype text -optional
element create $form_name flag_modifica    -widget hidden -datatype text -optional
element create $form_name cod_int_contr    -widget hidden -datatype text -optional
element create $form_name gen_prog         -widget hidden -datatype text -optional
element create $form_name flag_modello_h   -widget hidden -datatype text -optional
element create $form_name nome_funz_new    -widget hidden -datatype text -optional
element create $form_name nome_funz_gest   -widget hidden -datatype text -optional
element create $form_name flag_ins_prop    -widget hidden -datatype text -optional
element create $form_name flag_ins_occu    -widget hidden -datatype text -optional
element create $form_name __refreshing_p   -widget hidden -datatype text -optional
element create $form_name changed_field    -widget hidden -datatype text -optional;#nic01

set cod_manu [iter_check_uten_manu $id_utente]

if {[string range $id_utente 0 1] == "AM"} {
    set cod_manu $id_utente
}
if {$flag_portafoglio == "T"
    && ![string equal $cod_manu ""]} {
    #ricavo il portafoglio manutentore
    set url "lotto/balance?iter_code=$cod_manu"
    
    set data [iter_httpget_wallet $url]
    array set result $data
    #    ns_return 200 text/html "$result(page)"
    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
    if {$risultato == "OK"} {
	set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
	set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
	set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
    } else {
	set saldo ""
	set conto_manu ""
    }

    element set_properties $form_name saldo_manu  -value $saldo
    element set_properties $form_name cod_portafoglio  -value $conto_manu
} else {
    set saldo ""
}

set current_date [iter_set_sysdate]

if {$funzione != "I"
    &&  [db_0or1row sel_dimp_esito ""] != 0
} {
    switch $flag_status {
	"P" {set esit "Positivo"}
	"N" {set esit "<font color=red><b>Negativo</b></font>"}
	default {set esit ""}
    }
    set esito "Esito controllo: $esit"   
} else {
    set esito ""

}

set misura_co "(&\#037;)(ppm)"

set url_dimp        [list [ad_conn url]?[export_ns_set_vars url]]
set url_dimp        [export_url_vars url_dimp]    

if {$funzione != "I"} {
    # leggo riga
    if {[db_0or1row sel_dimp ""] == 0} {
	iter_return_complaint "Record non trovato"
    }
    set link_fatt "nome_funz=[iter_get_nomefunz coimfatt-gest]&$url_dimp&[export_url_vars cod_responsabile cod_impianto riferimento_pag]&funzione=I"
} else {
    # valorizzo il default dei soggetti
    if {[db_0or1row sel_aimp_old ""] == 0} {
	iter_return_complaint "Impianto non trovato"
    }
    set link_fatt "nome_funz=[iter_get_nomefunz coimfatt-gest]&$url_dimp&cod_responsabile=$cod_responsabile_old&cod_impianto=$cod_impianto&funzione=I"
}

set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new
set nome_funz_gest [iter_get_nomefunz coimcitt-gest]
element set_properties $form_name nome_funz_gest  -value $nome_funz_gest

set flag_ins_prop "S"
set flag_modello_h "T"
element set_properties $form_name flag_modello_h  -value $flag_modello_h
element set_properties $form_name flag_ins_prop  -value $flag_ins_prop


if {$funzione == "I" || $funzione == "M"} {
    db_1row query "select a.localita, 
                       b.descrizione as descr_via, 
                        b.descr_topo, 
                           a. numero, 
                               a.cap,
                        a.cod_comune, 
                     c.denominazione as provincia 
                    from coimaimp a
                        ,coimviae b
                        ,coimprov c 
                   where cod_impianto = :cod_impianto
                     and a.cod_via = b.cod_via 
                     and c.cod_provincia = a.cod_provincia"

    #link inserimento occupante
    #set link_ins_occu [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occ nome nome_occ nome_funz nome_funz_new localita localita descr_via descr_via descr_topo descr_topo numero numero cap cap provincia provincia cod_comune cod_comune dummy cod_citt_occ] "Inserisci Sogg."]
    #link inserimento occupante

    #   set link_ins_occu [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occu nome nome_occu nome_funz nome_funz_new dummy cod_occupante flag_ins_prop flag_ins_prop dummy flag_modello_h] "Inserisci Sogg."]

    #link inserimento occupante
    set link_ins_occu [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occu nome nome_occu nome_funz nome_funz_new localita localita descr_via descr_via descr_topo descr_topo numero numero cap cap provincia provincia cod_comune cod_comune dummy cod_occupante ] "Inserisci Sogg."]

    #link inserimento proprietario
    set link_ins_prop [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_prop nome nome_prop nome_funz nome_funz_new dummy cod_proprietario flag_ins_prop flag_ins_prop dummy flag_modello_h] "Inserisci Sogg."]

    set link_gest_resp [iter_link_ins $form_name coimcitt-gest [list cod_cittadino cod_responsabile nome_funz nome_funz_gest flag_modello_h] "Gest."]
} else {
    set link_ins_occu ""
    set link_ins_prop ""
    set link_gest_resp ""
}

if {[form is_request $form_name]} {
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp    
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name last_cod_dimp    -value $last_cod_dimp
    element set_properties $form_name url_gage         -value $url_gage
    element set_properties $form_name flag_no_link     -value $flag_no_link
    element set_properties $form_name cod_opma         -value $cod_opma   
    element set_properties $form_name data_ins         -value $data_ins
    element set_properties $form_name gen_prog         -value $gen_prog;#nic02
    element set_properties $form_name flag_tracciato   -value $flag_tracciato
    element set_properties $form_name __refreshing_p   -value 0;#nic01
    element set_properties $form_name changed_field    -value "";#nic01


    if {$funzione == "I"} {#nic02: aggiunto tutto questo blocco (copiato da coimdimp-f-gest)
        # gen_prog non e' mai valorizzato ad eccezione del caso in cui
        # non sia stata effettuata la scelta del generatore tramite
        # il programma coimcimp-gend-list qui sotto richiamato.
        if {[exists_and_not_null tabella]} {
            set gen_prog [db_string query "select gen_prog from coimdimp where cod_dimp = :cod_dimp_ins"]
        }

        # agg dob cind
        set cod_cind [db_string query "select cod_cind from coimcind where stato = '1' limit 1" -default ""]

        if {[string equal $gen_prog ""]} {
            # se esiste un solo generatore attivo, predispongo l'inserimento
            # del rapporto di verifica relativo a tale generatore
            set ctr_gend 0
            db_foreach sel_gend_list "" {
                incr ctr_gend
            }
            # se ho un solo generatore ho gia' reperito gen_prog con la query
            # se ne ho piu' di uno, invece richiamo coimdimp-gend-list
            # per scegliere su quale generatore si vuole inserire il R.V.
            # se non ho nessun generatore non posso inserire il R.V.
            if {$ctr_gend == 1} {
                # gen_prog e' gia' stato valorizzato con sel_gend_list
            } else {
                if {$ctr_gend > 1} {
                    # richiamo il programma che permette di scegliere gen_prog
                    set link_gend [export_url_vars flag_tracciato cod_impianto last_cod_cimp nome_funz nome_funz_caller tabella cod_dimp extra_par caller url_aimp url_list_aimp]
                    ad_returnredirect [ad_conn package_url]src/coimdimp-gend-list?$link_gend
                    ad_script_abort
                } else {
                    iter_return_complaint "Non trovato nessun generatore attivo: inserirlo"
                }
            }
        }
    };#nic02 (fine del blocco copiato da coimdimp-f-gest)

    #nic02 if {$funzione == "I"} {
    #nic02     set where_gen " and flag_attivo = 'S' limit 1"
    #nic02 } else {
    #nic02     set where_gen " and a.gen_prog = :gen_prog"
    #nic02 }

    if {$flag_mod_gend == "S"} {
	set sel_gend [db_map sel_gend_mod]
    } else {
	set sel_gend [db_map sel_gend_no_mod]
    }

    if {[db_0or1row sel_generatore $sel_gend] == 0} {
	set gend_zero        0
	set costruttore      ""
	set modello          ""
        set cod_mode         "";#nic01
	set matricola        ""
	set combustibile     ""
	set data_insta       ""
	set tiraggio         ""
	set destinazione     ""
	set tipo_a_c         ""
	set gen_prog         ""
        set locale           ""
        set data_costruz_gen ""
        set marc_effic_energ ""
        set volimetria_risc  ""
        set consumo_annuo    ""
	set consumo_annuo2   ""
	set stagione_risc    ""
	set stagione_risc2   ""
#nic03  set pot_focolare_nom ""
        set pot_utile_lib    ""
    } else {
	element set_properties $form_name costruttore      -value $costruttore
	element set_properties $form_name modello          -value $modello
	element set_properties $form_name matricola        -value $matricola
	element set_properties $form_name combustibile     -value $combustibile
	element set_properties $form_name data_insta       -value $data_insta
	element set_properties $form_name tiraggio         -value $tiraggio
	element set_properties $form_name destinazione     -value $destinazione
	element set_properties $form_name tipo_a_c         -value $tipo_a_c
	element set_properties $form_name gen_prog         -value $gen_prog       
        element set_properties $form_name locale           -value $locale
        element set_properties $form_name data_costruz_gen -value $data_costruz_gen
        element set_properties $form_name marc_effic_energ -value $marc_effic_energ
        element set_properties $form_name volimetria_risc  -value $volimetria_risc
        element set_properties $form_name consumo_annuo    -value $consumo_annuo
#nic03	element set_properties $form_name pot_focolare_nom -value $pot_focolare_nom
	element set_properties $form_name pot_utile_lib    -value $pot_utile_lib;#nic03

        # Imposto ora le options di cod_mode perchè solo adesso ho a disposiz. la var. costruttore
        element set_properties $form_name cod_mode         -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $costruttore]'" cod_mode descr_mode];#nic01
        element set_properties $form_name cod_mode         -value $cod_mode;#nic01
    }

    #ns_log notice "bubu1|$data_insta|"
    #ns_return 200 text/html "$tiraggio, $data_insta" ; return
    if {$funzione == "I"} {
	# valorizzo alcuni default
	
	# valorizzo data controllo con data_prevista del controllo
	# se richiamato da coimgage-gest
	if {[db_0or1row sel_gage ""] == 0} {
	    if {![string is space $cod_opma]} {
		iter_return_complaint "Controllo manutentore non trovato"
	    } else {
		set data_prevista ""
	    }
	}
	set data_controllo $data_prevista

	# valorizzo il default dei soggetti
	if {[db_0or1row sel_aimp_old ""] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}

	set potenza_old_edit [iter_edit_num $potenza_old 2]
	# valorizzo la tariffa di default in base alla potenza dell'impianto

	# imposto il codice listino a 0 perche' per ora il listino destinato ai costi 
        # e' il listino con codice 0 (zero) se in futuro ci sara' una diversificazione
        # sara' da creare una function o una procedura che renda dinamico il codice_listino
	set cod_listino 0

	# agg dob cind
	set cod_cind [db_string query "select cod_cind from coimcind where stato = '1' limit 1" -default ""]  



	if {[db_0or1row sel_tari ""] == 0} {
	    set tariffa ""
	}

	if {$flag_portafoglio == "T"} {
	    if {[db_0or1row sel_tari_contributo ""] == 0} {
		set importo_tariffa ""
		set tariffa_reg ""
	    } else {
		set tariffa_reg "7"
	    }
	}

	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}
	if {$flag_portafoglio == "T"
	    && ![string equal $cod_manutentore_old ""]} {
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu"
	    } else {
		set url "lotto/balance?iter_code=$cod_manutentore_old"
	    }
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #	        ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]

		db_1row sel_limiti_tgen "select flag_limite_portaf, valore_limite_portaf from coimtgen"
		if {$flag_limite_portaf == "S"} {
		    if {[iter_check_num $saldo 2] < $valore_limite_portaf} {
			set msg_limite "Attenzione - Il credito residuo disponibile sul tuo Portafoglio sta per terminare. Prima di completare l'inserimento delle dichiarazioni controlla l'importo necessario per il contributo regionale. Se il credito residuo risulta insufficiente la dichiarazione non verr&agrave; accettata. Informazioni sul tuo Portafoglio disponibili sul portale areaoperativa.curit.it"
		    }
		}
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    element set_properties $form_name saldo_manu  -value $saldo
	    element set_properties $form_name cod_portafoglio  -value $conto_manu
	} else {
	    set saldo ""
	}

	set tipologia_costo ""
	set flag_pagato ""

	# di default esito_verifica Positivo
	set flag_status "P"

	element set_properties $form_name data_controllo   -value $data_controllo
	element set_properties $form_name cod_manutentore  -value $cod_manutentore_old
	element set_properties $form_name cognome_manu     -value $cognome_manu_old
	element set_properties $form_name nome_manu        -value $nome_manu_old
	element set_properties $form_name cod_responsabile -value $cod_responsabile_old
	element set_properties $form_name cognome_resp     -value $cognome_resp_old
	element set_properties $form_name nome_resp        -value $nome_resp_old
	element set_properties $form_name cod_proprietario -value $cod_proprietario_old
	element set_properties $form_name cognome_prop     -value $cognome_prop_old
	element set_properties $form_name nome_prop        -value $nome_prop_old
	element set_properties $form_name cod_occupante    -value $cod_occupante_old
	element set_properties $form_name cognome_occu     -value $cognome_occu_old
	element set_properties $form_name nome_occu        -value $nome_occu_old
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp_old
        element set_properties $form_name cod_int_contr    -value $cod_int_contr_old
        element set_properties $form_name nome_contr       -value $nome_contr_old
        element set_properties $form_name cognome_contr    -value $cognome_contr_old

	if {$flag_portafoglio == "T"} {
	    element set_properties $form_name importo_tariffa   -value $importo_tariffa
	    element set_properties $form_name tariffa_reg       -value $tariffa_reg
	}
	element set_properties $form_name costo            -value $tariffa
	element set_properties $form_name tipologia_costo  -value $tipologia_costo
	element set_properties $form_name flag_pagato      -value $flag_pagato
#nic03	element set_properties $form_name potenza          -value $potenza_old_edit
	element set_properties $form_name potenza          -value $pot_utile_nom;#nic03
	element set_properties $form_name flag_status      -value $flag_status
	element set_properties $form_name cod_int_contr    -value $cod_int_contr_old
	element set_properties $form_name tabella          -value $tabella
	element set_properties $form_name cod_dimp_ins     -value $cod_dimp_ins
	# agg dob cind
	element set_properties $form_name cod_cind         -value $cod_cind

	db_1row sel_tgen_cont "select flag_default_contr_fumi from coimtgen"
	if {$flag_default_contr_fumi == "S"} {
	    element set_properties $form_name cont_rend    -value "S"
	} else {
	    element set_properties $form_name cont_rend    -value "N"
	}
	set conta 0
	while {$conta < 5} {
	    incr conta
	    element set_properties $form_name prog_anom.$conta -value $conta
	}
    } else {

	# leggo riga
	set cod_docu_distinta ""
	if {[db_0or1row sel_dimp ""] == 0} {
	    iter_return_complaint "Record non trovato"
	}
	# leggo aimp per dati progettista
	#	if {[db_0or1row sel_aimp ""] == 0} {
	#	    iter_return_complaint "Impianto non trovato"
	#	}

	# la query seguente e' temporanea e puo' essere tolta
	#db_1row query "select cod_fiscale as cod_fiscale_resp from coimcitt where cod_cittadino = :cod_responsabile "


	if {[iter_check_date $data_controllo] < "20080801"} {
	    set message "<td><table border=2 cellspacing=0 cellpadding=2 bordercolor=red><tr><td nowrap>Importo non dovuto data controllo antecedente 01/08/2008</td></tr></table></td>"
	} else {
	    set message "<td>&nbsp;</td>"
	}

 	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string equal $cod_manu ""]} {
	    set cod_manu $cod_manutentore
	}
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}
	if {$flag_portafoglio == "T"
	    && ![string equal $cod_manu ""]} {
	    #ricavo il portafoglio manutentore
	    set url "lotto/balance?iter_code=$cod_manu"
	    
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #    ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    element set_properties $form_name saldo_manu  -value $saldo
	    element set_properties $form_name cod_portafoglio  -value $conto_manu
	} else {
	    set saldo ""
	}
	
	set data_scad_mod [clock format [clock scan "$data_ins $flag_gg_modif_mh day"] -f %Y%m%d]

	set cod_man [iter_check_uten_manu $id_utente]
	db_1row sel_sett "select id_settore from coimuten where id_utente = :id_utente"
	if {![string equal $cod_man ""] || $id_settore == "regione"} {
	    if {$data_scad_mod < $current_date || ![string equal $cod_docu_distinta ""]} {
		set flag_modifica "F"
	    } else {
		set flag_modifica "T"
	    }
	} else {
	    set flag_modifica "T"
	}
	
	if {$flag_co_perc == "t"} {
	    set co [expr $co / 10000.0000]
	    set misura_co "(&\#037;)"
	    set co [iter_edit_num $co 4]
	} else {
	    set misura_co "(ppm)"
	    set co [iter_edit_num $co 0]
	}
	if {$funzione == "M"} {
	    set misura_co "(&\#037;)(ppm)"
	}
	
	element set_properties $form_name flag_status      -value $flag_status
	element set_properties $form_name cod_dimp         -value $cod_dimp
	element set_properties $form_name cod_impianto     -value $cod_impianto
	element set_properties $form_name data_controllo   -value $data_controllo
	element set_properties $form_name cod_manutentore  -value $cod_manutentore
	element set_properties $form_name cod_opmanu_new   -value $cod_opmanu_new
	element set_properties $form_name cod_responsabile -value $cod_responsabile
	element set_properties $form_name garanzia         -value $garanzia
	element set_properties $form_name conformita       -value $conformita
	element set_properties $form_name lib_impianto     -value $lib_impianto
	element set_properties $form_name lib_uso_man      -value $lib_uso_man
       element set_properties $form_name rct_lib_uso_man_comp      -value $rct_lib_uso_man_comp
	element set_properties $form_name inst_in_out      -value $inst_in_out
	element set_properties $form_name idoneita_locale  -value $idoneita_locale
	element set_properties $form_name ap_ventilaz      -value $ap_ventilaz
	element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz
	element set_properties $form_name pendenza         -value $pendenza
	element set_properties $form_name sezioni          -value $sezioni
	element set_properties $form_name curve            -value $curve
	element set_properties $form_name lunghezza        -value $lunghezza
	element set_properties $form_name conservazione    -value $conservazione
	element set_properties $form_name scar_ca_si       -value $scar_ca_si
	element set_properties $form_name scar_parete      -value $scar_parete
	element set_properties $form_name riflussi_locale  -value $riflussi_locale
	element set_properties $form_name assenza_perdite  -value $assenza_perdite
	element set_properties $form_name pulizia_ugelli   -value $pulizia_ugelli
	element set_properties $form_name antivento        -value $antivento
	element set_properties $form_name scambiatore      -value $scambiatore
	element set_properties $form_name accens_reg       -value $accens_reg
	element set_properties $form_name disp_comando     -value $disp_comando
	element set_properties $form_name ass_perdite      -value $ass_perdite
	element set_properties $form_name valvola_sicur    -value $valvola_sicur
	element set_properties $form_name vaso_esp         -value $vaso_esp
	element set_properties $form_name disp_sic_manom   -value $disp_sic_manom
	element set_properties $form_name organi_integri   -value $organi_integri
	element set_properties $form_name circ_aria        -value $circ_aria
	element set_properties $form_name guarn_accop      -value $guarn_accop
	element set_properties $form_name assenza_fughe    -value $assenza_fughe
	element set_properties $form_name coibentazione    -value $coibentazione
	element set_properties $form_name eff_evac_fum     -value $eff_evac_fum
	element set_properties $form_name cont_rend        -value $cont_rend
	element set_properties $form_name pot_focolare_mis -value $pot_focolare_mis
	element set_properties $form_name portata_comb_mis -value $portata_comb_mis
	element set_properties $form_name temp_fumi        -value $temp_fumi
	element set_properties $form_name temp_ambi        -value $temp_ambi
	element set_properties $form_name o2               -value $o2
	element set_properties $form_name co2              -value $co2
	element set_properties $form_name bacharach        -value $bacharach
	element set_properties $form_name co               -value $co
	element set_properties $form_name rend_combust     -value $rend_combust
	element set_properties $form_name osservazioni     -value $osservazioni
	element set_properties $form_name raccomandazioni  -value $raccomandazioni
	element set_properties $form_name prescrizioni     -value $prescrizioni
	element set_properties $form_name data_utile_inter -value $data_utile_inter
	element set_properties $form_name n_prot           -value $n_prot
	element set_properties $form_name data_prot        -value $data_prot
	element set_properties $form_name delega_resp      -value $delega_resp
	element set_properties $form_name delega_manut     -value $delega_manut
	element set_properties $form_name cognome_manu     -value $cognome_manu
	element set_properties $form_name cognome_opma     -value $cognome_opma
	element set_properties $form_name cognome_resp     -value $cognome_resp
	element set_properties $form_name nome_manu        -value $nome_manu
	element set_properties $form_name nome_opma        -value $nome_opma
	element set_properties $form_name nome_resp        -value $nome_resp
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp
	element set_properties $form_name cod_proprietario -value $cod_proprietario
	element set_properties $form_name cod_occupante    -value $cod_occupante
	element set_properties $form_name cognome_prop     -value $cognome_prop
	element set_properties $form_name cognome_occu     -value $cognome_occu
	element set_properties $form_name nome_prop        -value $nome_prop
	element set_properties $form_name nome_occu        -value $nome_occu
	if {$flag_portafoglio == "T"} {
	    element set_properties $form_name importo_tariffa   -value $importo_tariffa
	    element set_properties $form_name tariffa_reg      -value $tariffa_reg
	}
	element set_properties $form_name costo            -value $costo
	element set_properties $form_name tipologia_costo  -value $tipologia_costo
	element set_properties $form_name riferimento_pag  -value $riferimento_pag
	element set_properties $form_name data_scad_pagamento -value $data_scad
	element set_properties $form_name flag_pagato      -value $flag_pagato
	element set_properties $form_name potenza          -value $potenza
	element set_properties $form_name cod_int_contr    -value $cod_int_contr
	element set_properties $form_name nome_contr       -value $nome_contr
	element set_properties $form_name cognome_contr    -value $cognome_contr
	element set_properties $form_name scar_can_fu      -value $scar_can_fu  
	element set_properties $form_name tiraggio_fumi    -value $tiraggio_fumi     
	element set_properties $form_name ora_inizio       -value $ora_inizio   
	element set_properties $form_name ora_fine         -value $ora_fine     
	element set_properties $form_name data_scadenza_autocert   -value $data_scadenza_autocert
	element set_properties $form_name num_autocert     -value $num_autocert 
	element set_properties $form_name volimetria_risc   -value $volimetria_risc 
	element set_properties $form_name consumo_annuo    -value $consumo_annuo
	element set_properties $form_name consumo_annuo2   -value $consumo_annuo2
	element set_properties $form_name stagione_risc    -value $stagione_risc
	element set_properties $form_name stagione_risc2   -value $stagione_risc2			
	element set_properties $form_name data_arrivo_ente -value $data_arrivo_ente
	element set_properties $form_name tabella          -value $tabella
	element set_properties $form_name cod_dimp_ins     -value $cod_dimp_ins
       element set_properties $form_name rct_dur_acqua     -value $rct_dur_acqua
       element set_properties $form_name rct_tratt_in_risc -value $rct_tratt_in_risc
       element set_properties $form_name rct_tratt_in_acs   -value $rct_tratt_in_acs
       element set_properties $form_name rct_install_interna  -value $rct_install_interna
       element set_properties $form_name rct_install_esterna  -value  $rct_install_esterna
       element set_properties $form_name rct_canale_fumo_idoneo  -value $rct_canale_fumo_idoneo
       element set_properties $form_name rct_sistema_reg_temp_amb  -value $rct_sistema_reg_temp_amb
       element set_properties $form_name rct_assenza_per_comb  -value $rct_assenza_per_comb
       element set_properties $form_name rct_idonea_tenuta  -value $rct_idonea_tenuta
       element set_properties $form_name rct_valv_sicurezza -value $rct_valv_sicurezza
       element set_properties $form_name rct_scambiatore_lato_fumi -value $ rct_scambiatore_lato_fumi
       element set_properties $form_name rct_riflussi_comb -value $rct_riflussi_comb
       element set_properties $form_name rct_uni_10389 -value $rct_uni_10389
       element set_properties $form_name rct_rend_min_legge  -value $rct_rend_min_legge
       element set_properties $form_name rct_check_list_1    -value $rct_check_list_1
       element set_properties $form_name rct_check_list_2    -value $rct_check_list_2
       element set_properties $form_name rct_check_list_3    -value $rct_check_list_3
       element set_properties $form_name rct_check_list_4    -value $rct_check_list_4
       element set_properties $form_name rct_gruppo_termico   -value $rct_gruppo_termico
       #inizio freddo
       element set_properties $form_name fr_linee_ele     -value $fr_linee_ele
       element set_properties $form_name fr_coibentazione -value $fr_coibentazione
       element set_properties $form_name fr_assorb_fiamma   -value $fr_assorb_fiamma
       element set_properties $form_name fr_ciclo_compressione  -value $fr_ciclo_compressione
       element set_properties $form_name fr_assenza_perdita_ref  -value  $fr_assenza_perdita_ref
       element set_properties $form_name fr_leak_detector  -value $fr_leak_detector
       element set_properties $form_name fr_pres_ril_fughe  -value $fr_pres_ril_fughe
       element set_properties $form_name fr_scambiatore_puliti  -value $fr_scambiatore_puliti
       element set_properties $form_name fr_prova_modalita  -value $fr_prova_modalita
       element set_properties $form_name fr_surrisc -value $fr_surrisc
       element set_properties $form_name fr_sottoraff -value $fr_sottoraff
       element set_properties $form_name fr_tcondens -value $fr_tcondens
       element set_properties $form_name fr_tevapor -value $fr_tevapor
       element set_properties $form_name fr_t_ing_lato_est -value $fr_t_ing_lato_est
       element set_properties $form_name fr_t_usc_lato_est -value $fr_t_usc_lato_est
       element set_properties $form_name fr_t_ing_lato_ute -value $fr_t_ing_lato_ute
       element set_properties $form_name fr_t_usc_lato_ute  -value $fr_t_usc_lato_ute
       element set_properties $form_name fr_check_list_1    -value $fr_check_list_1
       element set_properties $form_name fr_check_list_2    -value $fr_check_list_2
       element set_properties $form_name fr_check_list_3    -value $fr_check_list_3
       element set_properties $form_name fr_check_list_4    -value $fr_check_list_4
       element set_properties $form_name fr_nr_circuito   -value $fr_nr_circuito
       #freddo fine
	# agg dob cind
	element set_properties $form_name cod_cind         -value $cod_cind

	set nome_utente_ins ""
        set data_ins_edit ""
	if {$utente_ins ne ""} {
	    db_1row sel_utente_ins ""
	}
	if {$data_ins ne ""} {
	    db_1row sel_edit_data "select iter_edit_data(:data_ins) as data_ins_edit"
	}
	
	set conta     0
	set prog_anom 0
	set list_anom_old [list]
	db_foreach sel_anom "" {
	    incr conta
	    lappend list_anom_old $cod_tanom
	    element set_properties $form_name prog_anom.$conta   -value $prog_anom
	    element set_properties $form_name cod_anom.$conta    -value $cod_tanom
	    element set_properties $form_name data_ut_int.$conta -value $dat_utile_inter
	}
	element set_properties $form_name prog_anom_max -value $prog_anom
	element set_properties $form_name list_anom_old -value $list_anom_old
	element set_properties $form_name flag_modifica -value $flag_modifica
	
	# valorizzo comunque prog_anom delle righe di anom eventualmente
	# non ancora inserite
	while {$conta < 5} {
	    incr conta
	    incr prog_anom
	    element set_properties $form_name prog_anom.$conta -value $prog_anom
	}
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set __refreshing_p   [element::get_value $form_name __refreshing_p];#nic01
    set changed_field    [element::get_value $form_name changed_field];#nic01
    set cod_dimp         [string trim [element::get_value $form_name cod_dimp]]
    set cod_impianto     [string trim [element::get_value $form_name cod_impianto]]
    set data_controllo   [string trim [element::get_value $form_name data_controllo]]
    set cod_manutentore  [string trim [element::get_value $form_name cod_manutentore]]
    set cod_opmanu_new                [element::get_value $form_name cod_opmanu_new]
    set cod_responsabile [string trim [element::get_value $form_name cod_responsabile]]
    set cod_occupante    [string trim [element::get_value $form_name cod_occupante]]
    set cod_proprietario [string trim [element::get_value $form_name cod_proprietario]]
    set flag_status      [string trim [element::get_value $form_name flag_status]]
    set garanzia         [string trim [element::get_value $form_name garanzia]]
    set conformita       [string trim [element::get_value $form_name conformita]]
    set lib_impianto     [string trim [element::get_value $form_name lib_impianto]]
    set lib_uso_man      [string trim [element::get_value $form_name lib_uso_man]]
    set inst_in_out      [string trim [element::get_value $form_name inst_in_out]]
    set idoneita_locale  [string trim [element::get_value $form_name idoneita_locale]]
    set ap_ventilaz      [string trim [element::get_value $form_name ap_ventilaz]]
    set ap_vent_ostruz   [string trim [element::get_value $form_name ap_vent_ostruz]]
    set pendenza         [string trim [element::get_value $form_name pendenza]]
    set sezioni          [string trim [element::get_value $form_name sezioni]]
    set curve            [string trim [element::get_value $form_name curve]]
    set lunghezza        [string trim [element::get_value $form_name lunghezza]]
    set conservazione    [string trim [element::get_value $form_name conservazione]]
    set scar_ca_si       [string trim [element::get_value $form_name scar_ca_si]]
    set scar_parete      [string trim [element::get_value $form_name scar_parete]]
    set riflussi_locale  [string trim [element::get_value $form_name riflussi_locale]]
    set assenza_perdite  [string trim [element::get_value $form_name assenza_perdite]]
    set pulizia_ugelli   [string trim [element::get_value $form_name pulizia_ugelli]]
    set antivento        [string trim [element::get_value $form_name antivento]]
    set scambiatore      [string trim [element::get_value $form_name scambiatore]]
    set accens_reg       [string trim [element::get_value $form_name accens_reg]]
    set disp_comando     [string trim [element::get_value $form_name disp_comando]]
    set ass_perdite      [string trim [element::get_value $form_name ass_perdite]]
    set valvola_sicur    [string trim [element::get_value $form_name valvola_sicur]]
    set vaso_esp         [string trim [element::get_value $form_name vaso_esp]]
    set disp_sic_manom   [string trim [element::get_value $form_name disp_sic_manom]]
    set organi_integri   [string trim [element::get_value $form_name organi_integri]]
    set circ_aria        [string trim [element::get_value $form_name circ_aria]]
    set guarn_accop      [string trim [element::get_value $form_name guarn_accop]]
    set assenza_fughe    [string trim [element::get_value $form_name assenza_fughe]]
    set coibentazione    [string trim [element::get_value $form_name coibentazione]]
    set eff_evac_fum     [string trim [element::get_value $form_name eff_evac_fum]]
    set cont_rend        [string trim [element::get_value $form_name cont_rend]]
    set pot_focolare_mis [string trim [element::get_value $form_name pot_focolare_mis]]
    set portata_comb_mis [string trim [element::get_value $form_name portata_comb_mis]]
    set temp_fumi        [string trim [element::get_value $form_name temp_fumi]]
    set temp_ambi        [string trim [element::get_value $form_name temp_ambi]]
    set o2               [string trim [element::get_value $form_name o2]]
    set co2              [string trim [element::get_value $form_name co2]]
    set bacharach        [string trim [element::get_value $form_name bacharach]]
    set co               [string trim [element::get_value $form_name co]]
    set rend_combust     [string trim [element::get_value $form_name rend_combust]]
    set osservazioni     [string trim [element::get_value $form_name osservazioni]]
    set raccomandazioni  [string trim [element::get_value $form_name raccomandazioni]]
    set prescrizioni     [string trim [element::get_value $form_name prescrizioni]]
    set data_utile_inter [string trim [element::get_value $form_name data_utile_inter]]
    set n_prot           [string trim [element::get_value $form_name n_prot]]
    set data_prot        [string trim [element::get_value $form_name data_prot]]
    set delega_resp      [string trim [element::get_value $form_name delega_resp]]
    set delega_manut     [string trim [element::get_value $form_name delega_manut]]
    set cognome_manu     [string trim [element::get_value $form_name cognome_manu]]
    regsub -all "!" $cognome_manu "'" cognome_manu
    set cognome_opma     [element::get_value $form_name cognome_opma]
    set cognome_resp     [string trim [element::get_value $form_name cognome_resp]]
    set nome_manu        [string trim [element::get_value $form_name nome_manu]]
    set nome_opma                     [element::get_value $form_name nome_opma]
    set nome_resp        [string trim [element::get_value $form_name nome_resp]]
    set cod_fiscale_resp [string trim [element::get_value $form_name cod_fiscale_resp]]
    set cognome_occu     [string trim [element::get_value $form_name cognome_occu]]
    set cognome_prop     [string trim [element::get_value $form_name cognome_prop]]
    set nome_occu        [string trim [element::get_value $form_name nome_occu]]
    set nome_prop        [string trim [element::get_value $form_name nome_prop]]
    # agg dob cind
    set cod_cind         [element::get_value $form_name cod_cind]
    if {$flag_portafoglio == "T"} {
	set importo_tariffa  [string trim [element::get_value $form_name importo_tariffa]]
	set tariffa_reg      [string trim [element::get_value $form_name tariffa_reg]]
	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}
	if {![string equal $cod_manutentore ""]} {
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu"
	    } else {
		#ricavo il portafoglio manutentore
		set url "lotto/balance?iter_code=$cod_manutentore"
	    }
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #    ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
		
		db_1row sel_limiti_tgen "select flag_limite_portaf, valore_limite_portaf from coimtgen"
		if {$flag_limite_portaf == "S"} {
		    if {[iter_check_num $saldo 2] < $valore_limite_portaf} {
			set msg_limite "Attenzione - Il credito residuo disponibile sul tuo Portafoglio sta per terminare. Prima di completare l'inserimento delle dichiarazioni controlla l'importo necessario per il contributo regionale. Se il credito residuo risulta insufficiente la dichiarazione non verr&agrave; accettata. Informazioni sul tuo Portafoglio disponibili sul portale areaoperativa.curit.it"
		    }
		}
	    }
	}
    }
    set costo             [string trim [element::get_value $form_name costo]]
    set tipologia_costo   [string trim [element::get_value $form_name tipologia_costo]]
    if {$tipologia_costo == "BO"} {
	element::set_value $form_name flag_pagato "S"
    }
    set flag_pagato       [string trim [element::get_value $form_name flag_pagato]]
    set riferimento_pag   [string trim [element::get_value $form_name riferimento_pag]]
    set data_scad_pagamento [string trim [element::get_value $form_name data_scad_pagamento]]
    set potenza           [string trim [element::get_value $form_name potenza]]
    set prog_anom_max     [string trim [element::get_value $form_name prog_anom_max]]
    set list_anom_old     [string trim [element::get_value $form_name list_anom_old]]
    set flag_modifica     [string trim [element::get_value $form_name flag_modifica]]
    set cod_int_contr     [string trim [element::get_value $form_name cod_int_contr]]
    set cognome_contr     [string trim [element::get_value $form_name cognome_contr]]
    set nome_contr        [string trim [element::get_value $form_name nome_contr]]
    set gen_prog          [string trim [element::get_value $form_name gen_prog]]
    set flag_tracciato    [string trim [element::get_value $form_name flag_tracciato]]
    set scar_can_fu       [string trim [element::get_value $form_name scar_can_fu]]
    set tiraggio_fumi     [string trim [element::get_value $form_name tiraggio_fumi]]
    set ora_inizio        [string trim [element::get_value $form_name ora_inizio]]
    set ora_fine          [string trim [element::get_value $form_name ora_fine]]
    set data_scadenza_autocert    [string trim [element::get_value $form_name data_scadenza_autocert]]
    set num_autocert      [string trim [element::get_value $form_name num_autocert]]
    set volimetria_risc   [string trim [element::get_value $form_name volimetria_risc]]
    set consumo_annuo     [string trim [element::get_value $form_name consumo_annuo]]
    set consumo_annuo2    [string trim [element::get_value $form_name consumo_annuo2]]
    set data_arrivo_ente  [element::get_value $form_name data_arrivo_ente]
    set stagione_risc     [element::get_value $form_name stagione_risc]
    set stagione_risc2    [element::get_value $form_name stagione_risc2]
    set tabella           [string trim [element::get_value $form_name tabella]]
    set cod_dimp_ins      [string trim [element::get_value $form_name cod_dimp_ins]]
    set rct_dur_acqua            [string trim [element::get_value $form_name rct_dur_acqua]]
    set rct_tratt_in_risc        [string trim [element::get_value $form_name rct_tratt_in_risc]]
    set rct_tratt_in_acs         [string trim [element::get_value $form_name rct_tratt_in_acs]]
    set rct_install_interna      [string trim [element::get_value $form_name rct_install_interna]]
    set rct_install_esterna      [string trim [element::get_value $form_name rct_install_esterna]]
    set rct_canale_fumo_idoneo   [string trim [element::get_value $form_name rct_canale_fumo_idoneo]]
    set rct_sistema_reg_temp_amb [string trim [element::get_value $form_name rct_sistema_reg_temp_amb]]
    set rct_assenza_per_comb     [string trim [element::get_value $form_name rct_assenza_per_comb]]
    set rct_idonea_tenuta         [string trim [element::get_value $form_name rct_idonea_tenuta]]
    set rct_valv_sicurezza        [string trim [element::get_value $form_name rct_valv_sicurezza]]
    set rct_scambiatore_lato_fumi [string trim [element::get_value $form_name rct_scambiatore_lato_fumi]]
    set rct_riflussi_comb         [string trim [element::get_value $form_name rct_riflussi_comb]]
    set rct_uni_10389             [string trim [element::get_value $form_name rct_uni_10389]]
    set rct_rend_min_legge    [string trim [element::get_value $form_name rct_rend_min_legge]]
    set rct_check_list_1          [string trim [element::get_value $form_name rct_check_list_1]]
    set rct_check_list_2          [string trim [element::get_value $form_name rct_check_list_2]]
    set rct_check_list_3          [string trim [element::get_value $form_name rct_check_list_3]]
    set rct_check_list_4          [string trim [element::get_value $form_name rct_check_list_4]]
    set rct_gruppo_termico        [string trim [element::get_value $form_name rct_gruppo_termico]]
    set rct_lib_uso_man_comp       [string trim [element::get_value $form_name rct_lib_uso_man_comp]]
    #inizio freddo 
    set fr_linee_ele             [string trim [element::get_value $form_name fr_linee_ele]]
    set fr_coibentazione        [string trim [element::get_value $form_name fr_coibentazione]]
    set fr_assorb_recupero        [string trim [element::get_value $form_name fr_assorb_recupero]]
    set fr_assorb_fiamma         [string trim [element::get_value $form_name fr_assorb_fiamma]]
    set fr_ciclo_compressione      [string trim [element::get_value $form_name fr_ciclo_compressione]]
    set fr_assenza_perdita_ref   [string trim [element::get_value $form_name fr_assenza_perdita_ref]]
    set fr_leak_detector         [string trim [element::get_value $form_name fr_leak_detector]]
    set fr_pres_ril_fughe        [string trim [element::get_value $form_name fr_pres_ril_fughe]]
    set fr_scambiatore_puliti    [string trim [element::get_value $form_name fr_scambiatore_puliti]]
    set fr_prova_modalita        [string trim [element::get_value $form_name fr_prova_modalita]]
    set fr_surrisc               [string trim [element::get_value $form_name fr_surrisc]]
    set fr_sottoraff             [string trim [element::get_value $form_name fr_sottoraff]]
    set fr_tcondens              [string trim [element::get_value $form_name fr_tcondens]]
    set fr_tevapor               [string trim [element::get_value $form_name fr_tevapor]]
    set fr_t_ing_lato_est        [string trim [element::get_value $form_name fr_t_ing_lato_est]]
    set fr_t_usc_lato_est        [string trim [element::get_value $form_name fr_t_usc_lato_est]]
    set fr_t_ing_lato_ute        [string trim [element::get_value $form_name fr_t_ing_lato_ute]]
    set fr_t_usc_lato_ute         [string trim [element::get_value $form_name fr_t_usc_lato_ute]]
    set fr_check_list_1          [string trim [element::get_value $form_name fr_check_list_1]]
    set fr_check_list_2          [string trim [element::get_value $form_name fr_check_list_2]]
    set fr_check_list_3          [string trim [element::get_value $form_name fr_check_list_3]]
    set fr_check_list_4          [string trim [element::get_value $form_name fr_check_list_4]]
    set fr_nr_circuito            [string trim [element::get_value $form_name fr_nr_circuito]]
    set rct_lib_uso_man_comp       [string trim [element::get_value $form_name rct_lib_uso_man_comp]]
    #fine freddo 

    if {$flag_mod_gend == "S"} {
	set costruttore      [element::get_value $form_name costruttore]
	set modello          [element::get_value $form_name modello]
	set matricola        [element::get_value $form_name matricola]
	set combustibile     [element::get_value $form_name combustibile]
	set data_insta       [element::get_value $form_name data_insta]
	set tiraggio         [element::get_value $form_name tiraggio]
	set tipo_a_c         [element::get_value $form_name tipo_a_c]
	set destinazione     [element::get_value $form_name destinazione]
	set locale           [element::get_value $form_name locale]
	set data_costruz_gen [element::get_value $form_name data_costruz_gen]
	set marc_effic_energ [element::get_value $form_name marc_effic_energ]
	set volimetria_risc  [element::get_value $form_name volimetria_risc]
	set consumo_annuo    [element::get_value $form_name consumo_annuo]
	set consumo_annuo2   [element::get_value $form_name consumo_annuo2]
	set stagione_risc    [element::get_value $form_name stagione_risc]
	set stagione_risc2   [element::get_value $form_name stagione_risc2]
	set potenza          [element::get_value $form_name potenza]
	#ns_return 200 text/html "bubu4|$combustibile|$data_insta|" ; return

        #Imposto ora le options di cod_mode perchè solo adesso ho a disposizione la var. costruttore
        element set_properties $form_name cod_mode -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $costruttore]'" cod_mode descr_mode];#nic01
        set cod_mode         [element::get_value $form_name cod_mode];#nic01
    } else {
        #Nicola 23/06/2014: se $flag_mod_gend == "N" devo valoriz. la var. tiraggio
        #altrimenti il pgm va in errore perche' in tal caso non viene letta la var. tiraggio
        #Andava in errore su iterprfi-dev (ho trovato la soluzione nel sorgente
        #coimdimp-g-gest personalizzato)
        if {[string equal $gen_prog ""]} {
            if {[db_0or1row query "select gen_prog
                                     from coimgend
                                    where flag_attivo = 'S'
                                      and cod_impianto = :cod_impianto
                                    limit 1"] == 0} {
                set gen_prog 1
            }
        }
        if {![db_0or1row query "select a.tiraggio
                                     , c.descr_comb as combustibile
                                   --  C'erano su PFI ma finche' non va in errore non li uso
                                   --, a.tipo_foco as tipo_a_c
                                   --, a.cod_combustibile
                                  from coimgend a
                            inner join coimaimp b on b.cod_impianto     = a.cod_impianto
                             left join coimcomb c on c.cod_combustibile = b.cod_combustibile
                                 where a.cod_impianto = :cod_impianto
                                   and a.gen_prog     = :gen_prog"]
        } {
            set tiraggio     ""
            set combustibile ""
        }

    }

#nic03 set pot_focolare_nom [element::get_value $form_name pot_focolare_nom]
    set pot_utile_lib [element::get_value $form_name pot_utile_lib];#nic03
    element set_properties $form_name garanzia         -value $garanzia
    element set_properties $form_name conformita       -value $conformita
    element set_properties $form_name lib_impianto     -value $lib_impianto
    element set_properties $form_name lib_uso_man      -value $lib_uso_man
    element set_properties $form_name inst_in_out      -value $inst_in_out
    element set_properties $form_name idoneita_locale  -value $idoneita_locale
    element set_properties $form_name ap_ventilaz      -value $ap_ventilaz
    element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz
    element set_properties $form_name pendenza         -value $pendenza
    element set_properties $form_name sezioni          -value $sezioni
    element set_properties $form_name curve            -value $curve
    element set_properties $form_name lunghezza        -value $lunghezza
    element set_properties $form_name conservazione    -value $conservazione
    element set_properties $form_name scar_ca_si       -value $scar_ca_si
    element set_properties $form_name scar_can_fu      -value $scar_can_fu
    element set_properties $form_name scar_parete      -value $scar_parete
    element set_properties $form_name riflussi_locale  -value $riflussi_locale
    element set_properties $form_name assenza_perdite  -value $assenza_perdite
    element set_properties $form_name pulizia_ugelli   -value $pulizia_ugelli
    element set_properties $form_name antivento        -value $antivento
    element set_properties $form_name scambiatore      -value $scambiatore
    element set_properties $form_name accens_reg       -value $accens_reg
    element set_properties $form_name disp_comando     -value $disp_comando
    element set_properties $form_name ass_perdite      -value $ass_perdite
    element set_properties $form_name valvola_sicur    -value $valvola_sicur
    element set_properties $form_name vaso_esp         -value $vaso_esp
    element set_properties $form_name disp_sic_manom   -value $disp_sic_manom
    element set_properties $form_name organi_integri   -value $organi_integri
    element set_properties $form_name circ_aria        -value $circ_aria
    element set_properties $form_name guarn_accop      -value $guarn_accop
    element set_properties $form_name assenza_fughe    -value $assenza_fughe
    element set_properties $form_name coibentazione    -value $coibentazione
    element set_properties $form_name eff_evac_fum     -value $eff_evac_fum
    element set_properties $form_name cont_rend        -value $cont_rend
    element set_properties $form_name rct_dur_acqua     -value $rct_dur_acqua
    element set_properties $form_name rct_tratt_in_risc -value $rct_tratt_in_risc
    element set_properties $form_name rct_tratt_in_acs   -value $rct_tratt_in_acs
    element set_properties $form_name rct_install_interna  -value $rct_install_interna
    element set_properties $form_name rct_install_esterna  -value  $rct_install_esterna
    element set_properties $form_name rct_canale_fumo_idoneo  -value $rct_canale_fumo_idoneo
    element set_properties $form_name rct_sistema_reg_temp_amb  -value $rct_sistema_reg_temp_amb
    element set_properties $form_name rct_assenza_per_comb  -value $rct_assenza_per_comb
    element set_properties $form_name rct_idonea_tenuta  -value $rct_idonea_tenuta
    element set_properties $form_name rct_valv_sicurezza -value $rct_valv_sicurezza
    element set_properties $form_name rct_scambiatore_lato_fumi -value $ rct_scambiatore_lato_fumi
    element set_properties $form_name rct_riflussi_comb -value $rct_riflussi_comb
    element set_properties $form_name rct_uni_10389 -value $rct_uni_10389
    element set_properties $form_name rct_rend_min_legge  -value $rct_rend_min_legge
    element set_properties $form_name rct_check_list_1    -value $rct_check_list_1
    element set_properties $form_name rct_check_list_2    -value $rct_check_list_2
    element set_properties $form_name rct_check_list_3    -value $rct_check_list_3
    element set_properties $form_name rct_check_list_4    -value $rct_check_list_4
    element set_properties $form_name rct_gruppo_termico   -value $rct_gruppo_termico
    element set_properties $form_name rct_lib_uso_man_comp   -value $rct_lib_uso_man_comp
    
    set conta 0
    while {$conta < 5} {
	incr conta
	set prog_anom($conta)   [element::get_value $form_name prog_anom.$conta]
	set cod_anom($conta)    [element::get_value $form_name cod_anom.$conta]
	set data_ut_int($conta) [element::get_value $form_name data_ut_int.$conta]
    }
    

    if {[string equal $__refreshing_p "1"]} {;#nic01
        if {$changed_field eq "costruttore"} {;#nic01
            set focus_field "$form_name.cod_mode";#nic01
        };#nic01

        element set_properties $form_name __refreshing_p -value 0;#nic01
        element set_properties $form_name changed_field  -value "";#nic01

        ad_return_template;#nic01
        return;#nic01
    };#nic01


    set error_num 0
    
    #if {$flag_portafoglio == "T" && $funzione == "I"} {
    #	if {[string equal $__refreshing_p 0] || [string equal $__refreshing_p ""]} {
    #	} else {
    #	    set error_num 1
    #	    if {$tariffa_reg == "8"} {
    #		set importo_tariffa "0,00"
    #	    } else {
    #		if {[db_0or1row sel_tari_contributo ""] == 0} {
    #		    set importo_tariffa ""
    #		}
    #	    }
    #	    element set_properties $form_name importo_tariffa   -value $importo_tariffa
    #	    set __refreshing_p "0"
    #	    element set_properties $form_name __refreshing_p   -value $__refreshing_p
    #	}
    #}    
    # gen_prog e num_bollo non sono piu' usati, valorizzati sempre a null
    set num_bollo ""

    # controlli standard su numeri e date, per Ins ed Upd
    set flag_errore_data_controllo "f"

    if {$flag_portafoglio == "T"} {
	if {![string equal $importo_tariffa ""]} {
	    set importo_tariffa [iter_check_num $importo_tariffa 2]
	    if {$importo_tariffa == "Error"} {
		element::set_error $form_name importo_tariffa "Deve essere numerico, max 2 dec"
		incr error_num
	    } else {
		if {[iter_set_double $importo_tariffa] >=  [expr pow(10,7)]
		    ||  [iter_set_double $importo_tariffa] <= -[expr pow(10,7)]} {
		    element::set_error $form_name importo_tariffa "Deve essere inferiore di 10.000.000"
		    incr error_num
		}
	    }
	}
    }
    
    set sw_costo_null "f"
    if {![string equal $costo ""]} {
	set costo [iter_check_num $costo 2]
	if {$costo == "Error"} {
	    element::set_error $form_name costo "Deve essere numerico, max 2 dec"
	    incr error_num
	} else {
	    if {[iter_set_double $costo] >=  [expr pow(10,7)] || [iter_set_double $costo] <= -[expr pow(10,7)]} {
		element::set_error $form_name costo "Deve essere inferiore di 10.000.000"
		incr error_num
	    } else {
		if {$costo == 0} {
		    set sw_costo_null "t"
		}
	    }
	}
    } else {
	set sw_costo_null "t"
    }
    
    if {$funzione == "I"} {
	set n_prot [db_string query "select descr || '/' || progressivo + 1 from coimtppt where cod_tppt = 'UC'"]
	set data_prot [db_string query "select iter_edit_data(current_date)"]
    }
    
    if {$funzione == "I" || $funzione == "M"} {

	# dob cind
	if {$flag_cind == "S" && $cod_cind == "" && $funzione == "I"} {
	    element::set_error $form_name cod_cind "Inserire campagna di riferimento"
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
		if {$cod_manutentore == $chk_inp_cod_manu} {
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
	
        set check_cod_opma {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_opma ""
            set ctr_opma         0
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
	    db_foreach sel_opma "" {
		incr ctr_opma
		if {$cod_opma == $chk_inp_cod_opma} {
		    set chk_out_cod_opma $cod_opma
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_opma {
		0 { set chk_out_msg "Soggetto non trovato"}
		1 { set chk_out_cod_opma $cod_opma
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
		}
	    }
	}
	
        if {[string equal $cognome_manu ""] && [string equal $nome_manu ""]} {
	    element::set_error $form_name cognome_manu "Inserire il manutentore"
            incr error_num
	} else {
	    if {[string equal $cognome_manu ""] && [string equal $nome_manu ""]} {
		set cod_manutentore ""
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
	}
    	
	if {[string equal $cognome_opma ""] && [string equal $nome_opma ""]} {
	    set cod_opma ""
	} else {
	    set chk_inp_cod_opma $cod_opma
	    set chk_inp_cognome  $cognome_opma
	    set chk_inp_nome     $nome_opma
	    eval $check_cod_opma
	    set cod_opma  $chk_out_cod_opma
	    if {$chk_out_rc == 0} {
		element::set_error $form_name cognome_opma $chk_out_msg
		incr error_num
	    }
	}
	
        #routine generica per controllo codice soggetto
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
                if {$cod_cittadino == $chk_inp_cod_citt} {
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
	
        if {[string equal $cognome_resp ""] &&  [string equal $nome_resp ""]} {
            set cod_responsabile ""
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

        if {[string equal $cognome_prop ""] && [string equal $nome_prop ""]} {
            set cod_proprietario ""
	} else {
	    set chk_inp_cod_citt $cod_proprietario
	    set chk_inp_cognome  $cognome_prop
	    set chk_inp_nome     $nome_prop
	    eval $check_cod_citt
            set cod_proprietario $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_prop $chk_out_msg
                incr error_num
	    }
	}
	
        if {[string equal $cognome_occu ""] && [string equal $nome_occu ""]} {
            set cod_occupante ""
	} else {
	    set chk_inp_cod_citt $cod_occupante
	    set chk_inp_cognome  $cognome_occu
	    set chk_inp_nome     $nome_occu
	    eval $check_cod_citt
            set cod_occupante    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_occu $chk_out_msg
                incr error_num
	    }
	}
	
        if {[string equal $cognome_contr ""] && [string equal $nome_contr ""]} {
            set cod_int_contr ""
	} else {
	    set chk_inp_cod_citt $cod_int_contr
	    set chk_inp_cognome  $cognome_contr
	    set chk_inp_nome     $nome_contr
	    eval $check_cod_citt
            set cod_int_contr    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_contr $chk_out_msg
                incr error_num
	    }
	}
	
	if {![string equal $volimetria_risc ""]} {
	    set volimetria_risc [iter_check_num $volimetria_risc 2]
            if {$volimetria_risc == "Error"} {
                element::set_error $form_name volimetrica_risc "Volumetria stanza misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num 
	    }
	}
	
	if {![string equal $consumo_annuo ""]} {
	    set consumo_annuo [iter_check_num $consumo_annuo 2]
            if {$consumo_annuo == "Error"} {
                element::set_error $form_name consumo_annuo "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num	    
	    }
	}
	
	if {![string equal $consumo_annuo2 ""]} {
	    set consumo_annuo2 [iter_check_num $consumo_annuo2 2]
	    if {$consumo_annuo2 == "Error"} {
		element::set_error $form_name consumo_annuo2 "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num	    
	    }
	}
	
	set sw_data_controllo_ok "f"
        if {[string equal $data_controllo ""]} {
	    set flag_errore_data_controllo "t"
            element::set_error $form_name data_controllo "Inserire Data controllo"
            incr error_num
        } else {
            set data_controllo [iter_check_date $data_controllo]
            if {$data_controllo == 0} {
		set flag_errore_data_controllo "t"
                element::set_error $form_name data_controllo "Data controllo deve essere una data"
                incr error_num
            } else {
		if {$flag_ente == "P"         
		    && $sigla_prov == "M "} {
		    
		} else {
		    if {$data_controllo > $current_date} {
			set flag_errore_data_controllo "t"
			element::set_error $form_name data_controllo "Data controllo deve essere inferiore alla data odierna"
			incr error_num
		    }
		}
            }
	}
	
        if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {
            # Per Udine e Gorizia non va fatto il controllo sul codice fiscale
        } else {
            # Caso Standard
	    if {$flag_errore_data_controllo == "f" && $data_controllo >= "20090801"} {
		if {[db_0or1row query "select natura_giuridica as natura_r, cod_fiscale as fisc_r, cod_piva as piva_r from coimcitt where cod_cittadino = :cod_responsabile"]} {
		    set fisc_r [string trim $fisc_r]
		    if {$fisc_r eq ""} {
			element::set_error $form_name cognome_resp "Il responsabile non ha il Codice Fiscale: e' obbligatorio per i modelli con data controllo superiore al 31 Luglio 2009"
			incr error_num
		    }
		}
	    }
	}


	if {$funzione eq "I"} {
	    if {$id_utente_ma eq "MA"} {
		# set oggi50 [db_string query "select :data_controllo::date + 50" -default ""]
		#  set oggi50 [clock format [clock scan "$ggad" -base [clock scan $data_controllo]] -f "%Y%m%d"]
		set oggi50  [clock format [ clock scan "$data_controllo +50 days" ] -format "%Y%m%d"] 
		if {$current_date > $oggi50} {
		    element::set_error $form_name num_autocert " Non è possibile inserire rapporti di controllo tecnico oltre i 45 giorni dalla data di  effettuazione del controllo"  
		    incr error_num
		}
	    }
	}

	
	# Nel caso di due impianti differenti con stesso indirizzo che
	# vengono inseriti come un solo impianto e che di conseguenza
	# ci troviamo con un impianto con potenza < 35 kW e due generatori,
	# permettiamo l'inserimento di piu' modelli h nella stessa data
	if {[string equal $data_controllo ""]} {
	    set where_gen_prog " and gen_prog is null"
	} else {
	    set where_gen_prog " and gen_prog = :gen_prog"
	}
	
	if {$flag_errore_data_controllo == "f"} {
	    if {$funzione == "I" && [db_0or1row sel_dimp_check_data_controllo ""] != 0} {
		set flag_errore_data_controllo "t"
		element::set_error $form_name data_controllo "Esiste gi&agrave; un mod. con questa data"
		incr error_num
	    } else {
		set sw_data_controllo_ok "t"
	    }
	}
	
	if {[string equal $gen_prog ""]} {
	    # set gen_prog 1
	    if {[db_0or1row gen_prog "select gen_prog from coimgend where flag_attivo = 'S' and cod_impianto = :cod_impianto limit 1"] == 0} {
		set gen_prog 1 
	    }
      	}
	#ns_log notice "bubu3|$data_insta|"
	#sandro 080512
	#	if {$flag_mod_gend == "S"} {
	#	    if {$data_insta == ""} {
	#		db_0or1row sel_data_insta_gen "select coalesce(iter_edit_data(data_installaz), '01/01/1900') as data_insta from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_prog"
	#	    }
	#	}
	#fine sandro

        #Nicola 23/06/2014: se $flag_mod_gend == "N" devo valoriz. la var. data_insta
        #altrimenti il pgm va in errore perche' in tal caso non viene letta la var. data_insta
        #Andava in errore su iterprfi-dev (ho trovato la soluzione nel sorgente
        #coimdimp-g-gest personalizzato)
        if {$flag_mod_gend == "N"} {
            if {![db_0or1row query "select iter_edit_data(data_installaz) as data_insta
                                      from coimgend
                                     where cod_impianto = :cod_impianto
                                       and gen_prog = :gen_prog"]
            } {
                set data_insta ""
            }
        }

	set err_insta 0
	if {$data_insta ne ""} {
	    set data_insta_contr [iter_check_date $data_insta]
	    if {$data_insta_contr == 0} {
		set err_insta 1
	    }
	} else {
	    set err_insta 1
	}
	
	if {$flag_portafoglio == "T"} {
	    if {$sw_data_controllo_ok == "t" && $err_insta == 0} {
		if {$data_controllo < "20080801"} {
		    set importo_tariffa ""
		    set tariffa_reg ""
		} else {
		    set dat_inst_gend [iter_check_date $data_insta]
		    if {![string equal $dat_inst_gend ""]} {
			set data_insta_check [db_string sel_dat "select to_char(add_months(:dat_inst_gend, '1'), 'yyyymmdd')"]
			if {$data_controllo <= $data_insta_check} {
			    set importo_tariffa "0.00"
			    set tariffa_reg "8"
			}
		    }
		}
	    }
	}
	#ns_log notice " mariano  $data_insta"
	if  {[string equal $sw_data_controllo_ok "t"] && $err_insta == 0} {
	    #set anno_insta [expr [string range $data_insta 6 9] + 1]
	    #set data_insta_contr [string range $data_insta 0 5]$anno_insta
            #set data_insta_contr [iter_check_date $data_insta_contr]
	    set dat_inst_gend [iter_check_date $data_insta]
	    set data_insta_contr [db_string query "select :dat_inst_gend::date + 365" -default ""]
	    
	    #	    if {$data_controllo > $data_insta_contr
	    #			&& [string equal $riferimento_pag ""]
	    #	    } {
            db_1row sel_tgen_boll "select flag_bollino_obb from coimtgen"
	    if {$tipologia_costo == "BO"
		&& [string equal $riferimento_pag ""]
		&& $flag_bollino_obb == "T"} {
		element::set_error $form_name riferimento_pag "Inserire n. bollino"
		incr error_num
	    }
	    #	    }
	}


        if {![string equal $pot_focolare_mis ""]} {
            set pot_focolare_mis [iter_check_num $pot_focolare_mis 2]
            if {$pot_focolare_mis == "Error"} {
                element::set_error $form_name pot_focolare_mis "Potenza focolare misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
		if {$pot_focolare_mis == "0,00"} {
		    element::set_error $form_name pot_focolare_mis "La potenza deve essere maggiore di 0,00"
		    incr error_num
		}
                if {[iter_set_double $pot_focolare_mis] >=  [expr pow(10,4)]
		    ||  [iter_set_double $pot_focolare_mis] <= -[expr pow(10,4)]} {
                    element::set_error $form_name pot_focolare_mis "Potenza focolare misurata deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        }
	
	#sandro 230513
	if {[string equal $tiraggio "N"]
	    && [string equal $assenza_perdite  "S"]} {
	    element::set_error $form_name assenza_perdite "Incongruenza con il tiraggio"
	    incr error_num
	    
	}

	if {[string equal $tiraggio "F"]
	    && [string equal $riflussi_locale  "S"]} {
	    element::set_error $form_name riflussi_locale "Incongruenza con il tiraggio"
	    incr error_num
	    
	}
	#sandro fine

        if {![string equal $portata_comb_mis ""]} {
            set portata_comb_mis [iter_check_num $portata_comb_mis 2]
            if {$portata_comb_mis == "Error"} {
                element::set_error $form_name portata_comb_mis "Portata combustibile misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $portata_comb_mis] >=  [expr pow(10,4)]
		    ||  [iter_set_double $portata_comb_mis] <= -[expr pow(10,4)]} {
                    element::set_error $form_name portata_comb_mis "Portata combustibile misurata deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        }

	# se il flag prova di combustione e' valorizzato a SI, obbligo 
        # l'inserimento dei valori numerici riguardanti il controllo dei 
        # fumi. per ora il bacharach non lo rendo obligatorio essendo un 
        # valore riferito agli impianti a combustibile liquido.
	if {$cont_rend == "S"} {
	    if {[string equal $fr_surrisc ""]} {
		element::set_error $form_name fr_surrisc "Inserire"
		incr error_num
	    }
	    if {[string equal $fr_sottoraff ""]} {
		element::set_error $form_name fr_sottoraff "Inserire"
		incr error_num
	    }
	    
	    if {[string equal $fr_tcondens ""]} {
		element::set_error $form_name fr_tcondens "Inserire"
		incr error_num		
	    }
	    
	    if {[string equal $fr_tevapor ""]} {
		element::set_error $form_name fr_tevapor "Inserire"
		incr error_num		
	    }
	    
	    if {[string equal $fr_t_ing_lato_est ""]} {
		element::set_error $form_name fr_t_ing_lato_est "Inserire"
		incr error_num		
	    }
	    
	    if {[string equal $fr_t_usc_lato_est ""]} {
		element::set_error $form_name fr_t_usc_lato_est "Inserire"
		incr error_num		
	    }
	    	    if {[string equal $fr_t_ing_lato_ute ""]} {
		element::set_error $form_name fr_t_ing_lato_ute "Inserire"
		incr error_num		
	    }
	    	    if {[string equal $fr_t_usc_lato_ute ""]} {
		element::set_error $form_name fr_t_usc_lato_ute "Inserire"
		incr error_num		
	    }
                 if {[string equal $fr_nr_circuito ""]} {
		element::set_error $form_name fr_nr_circuito "Inserire"
		incr error_num		
	    }	    


	    if {[info exist gend_zero] && $gend_zero == 0} {
		set tipo_a_c         ""
	    }
	    
	    
	    if {[info exist tiraggio] && [string equal $tiraggio "N"] &&
		[info exist tipo_a_c] && [string equal $tipo_a_c "A"]} {
		if {[string equal $tiraggio_fumi ""]} {
		    element::set_error $form_name tiraggio_fumi "Inserire"
		    incr error_num
		}
	    }

	    #if {[string equal $co ""]} {
	    #element::set_error $form_name co "Inserire"
	    #incr error_num
	    #}
	}


	if {![string equal $temp_fumi ""]} {
	    set temp_fumi [iter_check_num $temp_fumi 2]
	    if {$temp_fumi == "Error"} {
		element::set_error $form_name temp_fumi "Temperatura fumi deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $temp_fumi] >=  [expr pow(10,4)]
		    ||  [iter_set_double $temp_fumi] <= -[expr pow(10,4)]} {
		    element::set_error $form_name temp_fumi "Temperatura fumi deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $temp_ambi ""]} {
	    set temp_ambi [iter_check_num $temp_ambi 2]
	    if {$temp_ambi == "Error"} {
		element::set_error $form_name temp_ambi "Temperatura ambiente deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $temp_ambi] >=  [expr pow(10,4)]
		    ||  [iter_set_double $temp_ambi] <= -[expr pow(10,4)]} {
		    element::set_error $form_name temp_ambi "Temperatura ambiente deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}

	if {$flag_mod_gend == "S"} {
	    if {![string equal $data_insta ""]} {
		set data_insta [iter_check_date $data_insta]
		if {$data_insta == 0} {
		    element::set_error $form_name data_insta "Data installazione errata"
		    incr error_num
		}
	    } else {
		element::set_error $form_name data_insta "Data installazione mancante"
		incr error_num
	    }
	    if {![string equal $data_costruz_gen ""]} {
		set data_costruz_gen [iter_check_date $data_costruz_gen]
		if {$data_costruz_gen == 0} {
		    element::set_error $form_name data_costruz_gen "Data costr. deve essere una data"
		    incr error_num
		}
	    }
	    if {$costruttore == ""} {
		element::set_error $form_name costruttore "Costruttore obbligatorio"
		incr error_num
	    }

            if {$coimtgen(flag_gest_coimmode) eq "F"} {;#nic01
		if {$modello == ""} {
		    element::set_error $form_name modello "Modello obbligatorio"
		    incr error_num
		}
            } else {;#nic01
                if {$cod_mode eq ""} {;#nic01
                    element::set_error $form_name cod_mode "Modello obbligatorio";#nic01
                    incr error_num;#nic01
                } else {;#nic01
                    # Devo comunque valorizzare la colonna coimgend.modello
                    if {![db_0or1row query "select descr_mode as modello
                                              from coimmode
                                             where cod_mode = :cod_mode"]
                    } {#nic01
                        element::set_error $form_name cod_mode "Modello non trovato in anagrafica";#nic01
                        incr error_num;#nic01
                    };#nic01
                };#nic01
            };#nic01

	    if {$matricola == ""} {
		element::set_error $form_name matricola "Matricola obbligatoria"
		incr error_num
	    }
	    if {$combustibile == ""} {
		element::set_error $form_name combustibile "Combustibile obbligatorio"
		incr error_num
	    }
	} else {
	    # serena
	    ns_log notice "SERENA|$flag_mod_gend|$combustibile|$bacharach|"
	    if {$flag_mod_gend == "N" && $combustibile eq "GASOLIO"} {
		if {$bacharach eq ""} {
		    element::set_error $form_name bacharach "Campo obbligatorio"
		    incr error_num
		}
	    }
	}
	
#nic03	if {[string equal $pot_focolare_nom ""]} {
#nic03	    element::set_error $form_name pot_focolare_nom "Inserire potenza"
#nic03	    incr error_num	    
#nic03	} else {
#nic03	    set pot_focolare_nom [iter_check_num $pot_focolare_nom 2]
#nic03	    if {[string equal $pot_focolare_nom "0.00"]} {
#nic03		element::set_error $form_name pot_focolare_nom "Deve essere diverso da 0,00"
#nic03		incr error_num
#nic03	    }
#nic03	    if {$pot_focolare_nom == "Error"} {
#nic03		element::set_error $form_name pot_focolare_nom "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
#nic03		incr error_num	    
#nic03	    }
#nic03	}

	if {![string equal $pot_utile_lib ""]} {#nic03: aggiunta questa if ed il suo contenuto
	    set pot_utile_lib [iter_check_num $pot_utile_lib 2]
	    if {[string equal $pot_utile_lib "0.00"]} {
		element::set_error $form_name pot_utile_lib "Deve essere diverso da 0,00"
		incr error_num
	    }
	    if {$pot_utile_lib == "Error"} {
		element::set_error $form_name pot_utile_lib "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num	    
	    }
	}
    	
	if {![string equal $o2 ""]} {
	    set o2 [iter_check_num $o2 2]
	    if {$o2 == "Error"} {
		element::set_error $form_name o2 "o<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $o2] >  [expr pow(10,2)]
		    ||  [iter_set_double $o2] < -[expr pow(10,2)]} {
		    element::set_error $form_name o2 "o<sub><small>2</small></sub> deve essere inferiore di 100"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $co2 ""]} {
	    set co2 [iter_check_num $co2 2]
	    if {$co2 == "Error"} {
		element::set_error $form_name co2 "co<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $co2] >  [expr pow(10,2)]
		    ||  [iter_set_double $co2] < -[expr pow(10,2)]} {
		    element::set_error $form_name co2 "co<sub><small>2</small></sub> deve essere inferiore di 100"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $bacharach ""]} {
	    set bacharach [iter_check_num $bacharach 2]
	    if {$bacharach == "Error"} {
		element::set_error $form_name bacharach "Bacharach deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $bacharach] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach] <= -[expr pow(10,4)]} {
		    element::set_error $form_name bacharach "Bacharach deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	
	set flag_co_perc "f"
	if {![string equal $co ""]} {
	    set co [iter_check_num $co 4]
	    if {$co == "Error"} {
		element::set_error $form_name co "co deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $co] >=  [expr pow(10,7)]
		    ||  [iter_set_double $co] <= -[expr pow(10,7)]} {
		    element::set_error $form_name co "co deve essere inferiore di 1.000.000"
		    incr error_num
		} else {
		    if {$co < 1} {
			set co [expr $co * 10000]
			set flag_co_perc "t"
		    }
		}
	    }
	}
	
	if {![string equal $rend_combust ""]} {
	    set rend_combust [iter_check_num $rend_combust 2]
	    if {$rend_combust == "Error"} {
		element::set_error $form_name rend_combust "Rendimento combustibile deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		#if {[iter_set_double $rend_combust] >  [expr pow(10,2)]
		# || [iter_set_double $rend_combust] < -[expr pow(10,2)]} {
		#    element::set_error $form_name rend_combust "Rendimento combustibile deve essere inferiore di 100"
		#    incr error_num
		#}
	    }
	}
	
	if {![string equal $potenza ""]} {
            set potenza [iter_check_num $potenza 2]
            if {$potenza == "Error"} {
                element::set_error $form_name potenza "La potenza deve essere numerica e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
		if {$potenza== "0,00"} {
		    element::set_error $form_name potenza "La potenza deve essere maggiore di 0,00"
		    incr error_num
		}
                if {[iter_set_double $potenza] >=  [expr pow(10,7)]
		    ||  [iter_set_double $potenza] <= -[expr pow(10,7)]} {
                    element::set_error $form_name potenza "Potenza deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $data_utile_inter ""]} {
            set data_utile_inter [iter_check_date $data_utile_inter]
            if {$data_utile_inter == 0} {
                element::set_error $form_name data_utile_inter "Data utile intervento deve essere una data"
                incr error_num
            }
        }

        if {![string equal $data_arrivo_ente ""]} {
            set data_arrivo_ente [iter_check_date $data_arrivo_ente]
            if {$data_arrivo_ente == 0} {
                element::set_error $form_name data_arrivo_ente "Data arrivo ente deve essere una data"
                incr error_num
            }
        }

        if {![string equal $data_prot ""]} {
            set data_prot [iter_check_date $data_prot]
            if {$data_prot == 0} {
                element::set_error $form_name data_prot "Data protocollo deve essere una data"
                incr error_num
            }
        } else {
	    if {$data_prot > $current_date} {
		element::set_error $form_name data_prot "Data protocollo deve essere inferiore alla data odierna"
		incr error_num
	    }
	}

	# costo e' obbligatorio se sono stati indicati gli altri estremi
	# del pagamento
	if {$sw_costo_null == "t"} {
	    if {![string equal $tipologia_costo ""] || $flag_pagato == "S"} {
		element::set_error $form_name costo "Inserire il costo"
		incr error_num
	    }
	}

	# tipologia costo e' obbligatoria se sono stati indicati
	# gli altri estremi del pagamento
	if {[string equal $tipologia_costo ""]} {
	    if {$sw_costo_null == "f" || $flag_pagato == "S"} {
		element::set_error $form_name tipologia_costo "Inserire la tipologia del costo"
		incr error_num
	    }
	}

	# se viene indicato il bollino (riferimento pagamento valorizzato e
	# tipologia costo = 'BO').
	set note_todo_boll ""
	if {![string equal $riferimento_pag ""] && $tipologia_costo == "BO"} {
	    # controlli sui bollini disattivati per CPADOVA, PRO, PLI
	    #	    if { ( $flag_ente == "P" && ( $sigla_prov == "RO" || $sigla_prov == "LI")
	    #		|| (   $flag_ente == "C" && $cod_comu == "8761") ) } {
	    # vieto l'inserimento del bollino se il manutentore non e' convenz.
	    if {[db_0or1row sel_manu_flag_convenzionato ""] == 0} {
		set flag_convenzionato ""
	    } 
	    if {$flag_convenzionato == "N"} {
		element::set_error $form_name riferimento_pag "Manutentore non convenzionato all'utilizzo dei bollini"
		incr error_num
	    }
	    
	    # verifico che non esistano altri modelli H con lo stesso bollino
	    # segnalando l'eventuale incongruenza solamente su un TODO
	    # (Savazzi dice che verra' controllato solo per una quadratura dei
	    # pagamenti).
	    if {$funzione == "M"} {
		set where_codice "and cod_dimp <> :cod_dimp"
	    } else {
		set where_codice ""
	    }
	    
	    db_1row sel_dimp_check_riferimento_pag ""
	    if {$count_riferimento_pag > 0} {
		append note_todo_boll "Il bollino applicato sul modello H e' gia' stato applicato precedentemente su un'altro modello H \n"
	    }

	    # verifico che il numero bollino sia compreso tra le matricole
	    # dei blocchetti rilasciati al manutentore indicato
	    # (Savazzi dice che verra' controllato solo per una quadratura dei
	    # pagamenti).
	    set flag_boll_compreso "f"
	    db_foreach sel_boll_manu "" {
		if {$matricola_da <= $riferimento_pag
		    &&  $matricola_a  >= $riferimento_pag
		} {
		    set flag_boll_compreso "t"
		    
		    # per provincia di mantova: se inserisco un bollino con 
		    # tipologia "Comune" in un impianto non ubicato all'interno
		    # del comune di mantova, visualizzo un messaggio bloccante
		    #			if {$flag_ente == "P"
		    #			    &&  $sigla_prov == "MN"
		    #			} {
		    # codice comune "mantova" = 32
		    #			    if {[db_0or1row sel_aimp_comu ""] == 1
		    #				&&  [string range $riferimento_pag 0 0] == "C"
		    #				&&  $cod_comune != 32
		    #			    } {
		    #				element::set_error $form_name riferimento_pag "Tipo bollino non congruo con l'ubicazione dell'impianto"
		    #				incr error_num
		    #			    }
		    #			}
		}
	    }
	    
	    if {$flag_boll_compreso == "f"} {
		append note_todo_boll "Il bollino applicato sul modello H non e' stato rilasciato al manutentore che ha compilato il modulo"
	    }
	    #	    }
	}
	if {![string equal $data_scad_pagamento ""]} {
	    set data_scad_pagamento [iter_check_date $data_scad_pagamento]
	    if {$data_scad_pagamento == 0} {
		element::set_error $form_name data_scad_pagamento "Data scadenza pagamento deve essere una data"
		incr error_num
	    }
	} else {
	    # se non e' stata compilata la data scadenza pagamento
	    # ed esistono gli altri estremi del pagamento
	    # devo calcolarla in automatico:
	    # se il pagamento e' effettuato,               con data controllo
	    # se il pagamento e' avvenuto tramite bollino, con data controllo
	    # negli altri casi con data controllo + gg_scad_pag_mh
	    # che e' un parametro di procedura.
	    if {![string equal $tipologia_costo ""] || $sw_costo_null == "f" || $flag_pagato   == "S"} {
		if {$tipologia_costo == "BO" || $flag_pagato == "S" || [string equal $gg_scad_pag_mh ""]} {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento $data_controllo
		    }
		} else {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento [clock format [clock scan "$gg_scad_pag_mh day" -base [clock scan $data_controllo]] -f "%Y%m%d"]
		    }
		}
	    }
	}

	if {[string equal $data_scadenza_autocert ""]} {
	    if {$sw_data_controllo_ok == "t"} {
		#27/06/2014 D'accordo con Sandro, usiamo il parametro gia' esistente
		#coimtgen(valid_mod_h): Validità allegati (mesi)
		#27/06/2014 set data_scadenza_autocert [db_string query "select :data_controllo::date + 775" -default ""]
		db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                        ,$coimtgen(valid_mod_h))
                                             ,'YYYYMMDD') as data_scadenza_autocert
                                 from dual";#27/06/2014
	    }
	} else {
	    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
	    if {$data_scadenza_autocert == 0} {
		element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
		incr error_num
	    }
	}

	if {![string equal $ora_inizio ""]} {
	    set ora_inizio [iter_check_time $ora_inizio]
	    if {$ora_inizio == 0} {
		element::set_error $form_name ora_inizio "Ora non corretta, deve essere hh:mm"
		incr error_num
	    }
	}
	if {![string equal $ora_fine ""]} {
	    set ora_fine [iter_check_time $ora_fine]
	    if {$ora_fine == 0} {
		element::set_error $form_name ora_fine "Ora non corretta, deve essere hh:mm"
		incr error_num
	    }
	}

	if {![string equal $tiraggio_fumi ""]} {
            set tiraggio_fumi [iter_check_num $tiraggio_fumi 2]
            if {$tiraggio_fumi == "Error"} {
                element::set_error $form_name tiraggio_fumi "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $tiraggio_fumi] >=  [expr pow(10,7)]
		    ||  [iter_set_double $tiraggio_fumi] <= -[expr pow(10,7)]} {
                    element::set_error $form_name tiraggio_fumi "Deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }


	set sw_movi     "f"
	set data_pag    ""
	set importo_pag ""
	if {$sw_costo_null == "f" && ![string equal $tipologia_costo ""]} {
	    set sw_movi "t"
	    if {$flag_pagato == "S"} {
		set data_pag    $data_scad_pagamento
		set importo_pag $costo
	    }
	}

	set conta 0
	# controllo sui dati delle anomalie
	while {$conta < 5} {
	    incr conta
	    if {![string equal $data_ut_int($conta) ""]} {
		set data_ut_int($conta) [iter_check_date $data_ut_int($conta)]
		if {$data_ut_int($conta) == 0} {
		    element::set_error $form_name data_ut_int.$conta "Data non corretta"
		    incr error_num
		} else {
		    if {$data_controllo > $data_ut_int($conta)} {
			element::set_error $form_name data_ut_int.$conta "Data precedente al controllo"
			incr error_num
		    }
		}
		if {[string equal $cod_anom($conta) ""]} {
		    element::set_error $form_name cod_anom.$conta "Inserire anche anomalia oltre alla data utile intervento"
		    incr error_num
		}
	    }
	    
	    if {![string equal $cod_anom($conta) ""]} {
		set sw_dup "f"
		set conta2 $conta
		while {$conta2 > 1 && $sw_dup == "f"} {
		    incr conta2 -1
		    if {$cod_anom($conta) == $cod_anom($conta2)} {
			element::set_error $form_name cod_anom.$conta "Anomalia gi&agrave; presente"
			incr error_num
			set sw_dup "t"
		    }
		}

		set cod_anom_db  $cod_anom($conta)
		set prog_anom_db $prog_anom($conta)
		if {$sw_dup == "f"
		    &&  [db_string sel_anom_count ""] >= 1
		} {
		    element::set_error $form_name cod_anom.$conta "Anomalia gi&agrave; presente"
		    incr error_num
		}
	    }
	}
	
	db_1row sel_tgen_canne "select flag_obbligo_canne from coimtgen"
	if {$flag_obbligo_canne == "S"} {
	    if {$scar_ca_si == "S"
		&& $scar_parete == "S"} {
		element::set_error $form_name scar_ca_si "Solo una delle tre opzioni pu&ograve; essere Si"
		incr error_num
	    } else {
		if {$scar_ca_si == "S"
		    && $scar_can_fu == "S"} {
		    element::set_error $form_name scar_ca_si "Solo una delle tre opzioni pu&ograve; essere Si"
		    incr error_num
		} else {
		    if {$scar_parete == "S"
			&& $scar_can_fu == "S"} {
			element::set_error $form_name scar_parete "Solo una delle tre opzioni pu&ograve; essere Si"
			incr error_num
		    }
		}
	    }
	}
    }

    if {$error_num > 0} {
	if {$flag_errore_data_controllo == "f"} {
	    element::set_error $form_name data_controllo "ATTENZIONE: sono presenti degli errori nella pagina"
	}
	ad_return_template
	return
    } else {
	if {$flag_portafoglio == "T"
	    && $funzione == "I"
	    && $data_controllo >= "20080801"
	    && $importo_tariffa > "0.00"
	} {
	    set cod_manu [iter_check_uten_manu $id_utente]
	    if {[string range $id_utente 0 1] == "AM"} {
		set cod_manu $id_utente
	    }
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu"
	    } else {
		set url "lotto/balance?iter_code=$cod_manutentore"
	    }
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #ns_return 200 text/html "$result(page) $cod_manu"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    if {[string equal $saldo ""]} {

		element::set_error $form_name data_controllo "ATTENZIONE transazione non avvenuta correttamente "
		ad_return_template
		return
	    }
	    if {[expr [iter_check_num $saldo 2] + 0] >= $importo_tariffa} {
		set oggi [db_string sel_date "select current_date"]
		db_1row sel_dual_cod_dimp ""
		set database [db_get_database]
		set reference "$cod_dimp+$database"

		if {![string equal $cod_manu ""]} {
		    set url "lotto/itermove?iter_code=$cod_manu&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa"
		} else {
		    set url "lotto/itermove?iter_code=$cod_manutentore&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa"
		}
		set data [iter_httpget_wallet $url]
		array set result $data
		#		ns_return 200 text/html "$result(page)"; return
		set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
		if {$risultato == "OK"} {
		    set transaz_eff "T"
		} else {
		    element::set_error $form_name data_controllo "ATTENZIONE transazione non avvenuta correttamente"
		    ad_return_template
		    return
		}
	    } else {
		element::set_error $form_name data_controllo "ATTENZIONE il saldo del manutentore non &egrave; sufficente"
		ad_return_template
		return
	    }
	} else {
	    if {$funzione == "I"} {
		db_1row sel_dual_cod_dimp ""
	    }
	}
    }

    if {$funzione != "V"} {
	# leggo i soggetti, la potenza e data prima dich dell'impianto
	# che servono in preparazione inserimento, modifica e cancellazione
	if {[db_0or1row sel_aimp_old ""] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}
    }

    if {$funzione == "I" || $funzione == "M"} {
	# controllo se esiste un modello H con data piu' recente, in questo caso non vado ad eseguire gli aggiornamenti
	if {[db_0or1row check_modh_old ""] == 0} {
	    set data_ultimo_modh "19000101"
	}
	# Preparo i default per le note da segnalare sui todo
	set note_todo          ""
	set flag_evasione_todo "E"
	set data_controllo_db [string range $data_controllo 0 3]
	append data_controllo_db [string range $data_controllo 5 6]
	append data_controllo_db [string range $data_controllo 8 9]
	if {$data_controllo >= $data_ultimo_modh} {
	    # La potenza va confrontata con quella dell'impianto:
	    # se quella dell'impianto e' non nota, quella del modello h sovrascrive
	    # quella dell'impianto. L'aggiornamento viene registrato nel todo.
	    # se quella dell'impianto e' nota, la differenza viene segnalata todo.

	    # I soggetti del modello h vanno confrontati con quelli dell'impianto:
	    # se vi sono differenze, a seconda del parametro flag_agg_sogg,
	    # essi vanno a sovrascrivere quelli dell'impianto e l'aggiornamento
	    # viene registrato.
	    # Se il parametro flag_agg_sogg = "N" allora la differenza viene
	    # solo segnalata nel todo.

	    # preparo variabili editate e descrizione da utilizzare nei todo
	    if {[string is space $cod_manutentore]} {
		set desc_manu     "NON NOTO"
	    } else {
		set desc_manu     "$cognome_manu $nome_manu"
	    }
	    if {[string is space $cod_manutentore_old]} {
		set desc_manu_old "NON NOTO"
	    } else {
		set desc_manu_old "$cognome_manu_old $nome_manu_old"
	    }

	    if {[string is space $cod_responsabile]} {
		set desc_resp     "NON NOTO"
	    } else {
		set desc_resp     "$cognome_resp $nome_resp"
	    }
	    if {[string is space $cod_responsabile_old]} {
		set desc_resp_old "NON NOTO"
	    } else {
		set desc_resp_old "$cognome_resp_old $nome_resp_old"
	    }

	    if {[string is space $cod_occupante]} {
		set desc_occu     "NON NOTO"
	    } else {
		set desc_occu     "$cognome_occu $nome_occu"
	    }
	    if {[string is space $cod_occupante_old]} {
		set desc_occu_old "NON NOTO"
	    } else {
		set desc_occu_old "$cognome_occu_old $nome_occu_old"
	    }

	    if {[string is space $cod_proprietario]} {
		set desc_prop     "NON NOTO"
	    } else {
		set desc_prop     "$cognome_prop $nome_prop"
	    }
	    if {[string is space $cod_proprietario_old]} {
		set desc_prop_old "NON NOTO"
	    } else {
		set desc_prop_old "$cognome_prop_old $nome_prop_old"
	    }

	    if {[string is space $cod_int_contr]} {
		set desc_contr     "NON NOTO"
	    } else {
		set desc_contr     "$cognome_contr $nome_contr"
	    }
	    if {[string is space $cod_int_contr_old]} {
		set desc_contr_old "NON NOTO"
	    } else {
		set desc_contr_old "$cognome_contr_old $nome_contr_old"
	    }
	    
	    set potenza_edit     [iter_edit_num $potenza     2]
	    set potenza_old_edit [iter_edit_num $potenza_old 2]

	    # inizio della fase di confronto dati modello h ed impianto

	    if {$potenza > 0} {
		# potenza dell'impianto non nota e del modello h valorizzata
		if {$potenza_old == 0 || [string equal $potenza_old ""]} {
		    if {[db_0or1row sel_pote_fascia ""] == 0} {
			set cod_potenza ""
		    }
		    
		    set dml_aimp_pote [db_map upd_aimp_pote]
		    append note_todo "Potenza dell'impianto aggiornata da NON NOTA a $potenza_edit kW \n"

		    db_1row sel_gend_count ""
		    if {$conta_gend == 1} {
			#nic03: non eseguo questa update perchè per il freddo fa danni
			#nic03 set dml_gend_pote [db_map upd_gend_pote]
		    }
		} else {
		    # potenza dell'impianto nota e del modello h valorizzata
		    if {$potenza != $potenza_old} {
			# segnalo solamente la differenza sul todo
			append note_todo "Potenza dell'impianto ($potenza_old_edit kW) diversa dalla potenza del modello H ($potenza_edit kW) \n"
		    }
		}
	    }

	    # se e' cambiato almeno un soggetto:

	    if {$cod_manutentore  != $cod_manutentore_old
		|| $cod_responsabile != $cod_responsabile_old
		|| $cod_occupante    != $cod_occupante_old
		|| $cod_proprietario != $cod_proprietario_old
		|| $cod_int_contr    != $cod_int_contr_old
	    } {
		# evito di cancellare il responsabile dell'impianto.
		if {[string equal $cod_responsabile ""]} {
		    set cod_responsabile_new $cod_responsabile_old
		} else {
		    set cod_responsabile_new $cod_responsabile
		}

		# se e' cambiato anche solo un soggetto, i soggetti del modello
		# h sovrascrivono quelli dell'impianto.
		if {$flag_agg_sogg == "T"} {
		    # valorizzo il nuovo flag_resp
		    if {      $cod_responsabile_new == $cod_occupante} {
			set flag_resp "O"
		    } elseif {$cod_responsabile_new == $cod_proprietario} {
			set flag_resp "P"
		    } elseif {$cod_responsabile_new == $cod_amministratore_old} {
			set flag_resp "A"
		    } elseif {$cod_responsabile_new == $cod_intestatario_old} {
			set flag_resp "I"
		    } else {
			set flag_resp "T"
		    }

		    set dml_upd_aimp_sogg [db_map upd_aimp_sogg]
		}

		# scrivo le note nel todo ed inserisco lo storico.
		if {$cod_manutentore != $cod_manutentore_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Manutentore dell'impianto aggiornato da $desc_manu_old a $desc_manu \n"
			# memorizzo il vecchio manutentore nello storico
			set ruolo "M"
			if {![string equal $cod_manutentore_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_manu [db_map ins_rife]
			}
		    } else {
			append note_todo "Manutentore dell'impianto ($desc_manu_old) diverso dal manutentore del modello H ($desc_manu) \n"
		    }
		}

		if {$cod_responsabile_new != $cod_responsabile_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Responsabile dell'impianto aggiornato da $desc_resp_old a $desc_resp \n"
			# memorizzo il vecchio responsabile nello storico
			set ruolo "R"
			if {![string equal $cod_responsabile_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_resp [db_map ins_rife]
			}
		    } else {
			append note_todo "Responsabile dell'impianto ($desc_resp_old) diverso dal responsabile del modello H ($desc_resp) \n"
		    }
		}

		if {$cod_occupante != $cod_occupante_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Occupante dell'impianto aggiornato da $desc_occu_old a $desc_occu \n"
			# memorizzo il vecchio occupante nello storico
			set ruolo "O"
			if {![string equal $cod_occupante_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_occu [db_map ins_rife]
			}
		    } else {
			append note_todo "Occupante dell'impianto ($desc_occu_old) diverso dall'occupante del modello H ($desc_occu) \n"
		    }
		}

		if {$cod_proprietario != $cod_proprietario_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Proprietario dell'impianto aggiornato da $desc_prop_old a $desc_prop \n"
			# memorizzo il vecchio proprietario nello storico
			set ruolo "P"
			if {![string equal $cod_proprietario_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_prop [db_map ins_rife]
			}
		    } else {
			append note_todo "Proprietario dell'impianto ($desc_prop_old) diverso dal proprietario del modello H ($desc_prop) \n"
		    }
		}

		if {$cod_int_contr != $cod_int_contr_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Intestatario Contratto dell'impianto aggiornato da $desc_contr_old a $desc_contr \n"
			# memorizzo il vecchio occupante nello storico
			set ruolo "T"
			if {![string equal $cod_int_contr_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_inte [db_map ins_rife]
			}
		    }
		}
	    }
	    if {[string equal $dt_prima_dich ""]} {
		set dml_upd_aimp_prima_dich [db_map upd_aimp_prima_dich]
	    }

	    set dml_upd_aimp_ultim_dich [db_map upd_aimp_ultim_dich]
	} else {
	    # se il min di data autocertificazione dei modh di quell'impianto ï¿½ piu recente della data del controllo
	    # vado a fare l'update sull'impianto
	    db_1row sel_min_data_controllo ""
	    if {[string equal $min_data_controllo ""]
		|| $min_data_controllo > [iter_check_date $data_controllo]} {
		set dml_upd_aimp_prima_dich [db_map upd_aimp_prima_dich]
	    }
	}

	if {![string equal $note_todo ""]} {
	    set dml_todo_aimp [db_map ins_todo]
	}
	
	# Preparo esito e flag_pericolosita.
	# Se c'e' almeno un'anomalia, l'esito viene forzato a negativo.
	# Se c'e' almeno un'anomalia pericolosa, flag_pericolosita diventa 'T'.

	set flag_pericolosita "F"
	set conta 0
	# ciclo sulle anomalie presenti nella form
	while {$conta < 5} {
	    incr conta
	    if {![string equal $cod_anom($conta) ""]} {
		set flag_status "N"

		set cod_anomalia $cod_anom($conta)
		if {[db_0or1row sel_tano_scatenante ""] == 0} {
		    set flag_scatenante "F"
		}
		if {$flag_scatenante == "T"} {
		    set flag_pericolosita  "T"
		}
	    }
	}

	# in modifica devo considerare anche le anomalie che non compaiono
	# nella pagina corrente (oltre a 5)
	if {$funzione == "M"} {
	    db_foreach sel_tano_anom "" {
		set flag_uguale "f"
		foreach cod_tanom_old $list_anom_old {
		    if {$cod_tanom_old == $cod_tanom_check} {
			set flag_uguale "t"
		    }
		}
		if {$flag_uguale == "f"
		    &&  $flag_scatenante_check == "T"
                } {
		    set flag_pericolosita "T"
		}
	    }
	}

	# in inserimento ed in modifica valorizzo lo stato di conformita'
        # dell'impianto in base all'esito del M.H.
	if {![string equal $flag_status ""]} {
	    # lo aggiorno solo se l'esito del M.H. non e' null
	    if {$flag_status == "P"} {
		set stato_conformita "S"
	    } else {
		set stato_conformita "N"
	    }
	    set dml_upd_aimp_stato [db_map upd_aimp_stato]
	}
    }

    set lista_pesi [list]
    switch $conformita {
	"N" {lappend lista_pesi [list "conformita" "N"]}
	"C" {lappend lista_pesi [list "conformita" "C"]}
    }
    switch $lib_impianto {
	"N" {lappend lista_pesi [list "lib_impianto" "N"]}
	"C" {lappend lista_pesi [list "lib_impianto" "C"]}
    }
    switch $lib_uso_man {
	"N" {lappend lista_pesi [list "lib_uso_man" "N"]}
	"C" {lappend lista_pesi [list "lib_uso_man" "C"]}
    }
    switch $idoneita_locale {
	"N" {lappend lista_pesi [list "idoneita_locale" "N"]}
    }
    switch $ap_ventilaz {
	"N" {lappend lista_pesi [list "ap_ventilaz" "N"]}
	"C" {lappend lista_pesi [list "ap_ventilaz" "C"]}
    }
    switch $ap_vent_ostruz {
	"N" {lappend lista_pesi [list "ap_vent_ostruz" "N"]}
	"C" {lappend lista_pesi [list "ap_vent_ostruz" "C"]}
    }
    switch $pendenza {
	"N" {lappend lista_pesi [list "pendenza" "N"]}
	"C" {lappend lista_pesi [list "pendenza" "C"]}
    }
    switch $sezioni {
	"N" {lappend lista_pesi [list "sezioni" "N"]}
	"C" {lappend lista_pesi [list "sezioni" "C"]}
    }
    switch $curve {
	"N" {lappend lista_pesi [list "curve" "N"]}
	"C" {lappend lista_pesi [list "curve" "C"]}
    }
    switch $lunghezza {
	"N" {lappend lista_pesi [list "lunghezza" "N"]}
	"C" {lappend lista_pesi [list "lunghezza" "C"]}
    }
    switch $conservazione {
	"N" {lappend lista_pesi [list "conservazione" "N"]}
	"C" {lappend lista_pesi [list "conservazione" "C"]}
    }
    switch $scar_ca_si {
	"N" {lappend lista_pesi [list "scar_ca_si" "N"]}
	"C" {lappend lista_pesi [list "scar_ca_si" "C"]}
    }
    switch $scar_parete {
	"N" {lappend lista_pesi [list "scar_parete" "N"]}
	"C" {lappend lista_pesi [list "scar_parete" "C"]}
    }
    switch $riflussi_locale {
	"N" {lappend lista_pesi [list "riflussi_locale" "N"]}
	"C" {lappend lista_pesi [list "riflussi_locale" "C"]}
    }
    switch $assenza_perdite {
	"N" {lappend lista_pesi [list "assenza_perdite" "N"]}
	"C" {lappend lista_pesi [list "assenza_perdite" "C"]}
    }
    switch $cont_rend {
	"N" {lappend lista_pesi [list "cont_rend" "N"]}
    }
    switch $pulizia_ugelli {
	"N" {lappend lista_pesi [list "pulizia_ugelli" "N"]}
	"C" {lappend lista_pesi [list "pulizia_ugelli" "C"]}
    }
    switch $antivento {
	"N" {lappend lista_pesi [list "antivento" "N"]}
	"C" {lappend lista_pesi [list "antivento" "C"]}
    }
    switch $scambiatore {
	"N" {lappend lista_pesi [list "scambiatore" "N"]}
	"C" {lappend lista_pesi [list "scambiatore" "C"]}
    }
    switch $accens_reg {
	"N" {lappend lista_pesi [list "accens_reg" "N"]}
	"C" {lappend lista_pesi [list "accens_reg" "C"]}
    }
    switch $disp_comando {
	"N" {lappend lista_pesi [list "disp_comando" "N"]}
	"C" {lappend lista_pesi [list "disp_comando" "C"]}
    }
    switch $ass_perdite {
	"N" {lappend lista_pesi [list "ass_perdite" "N"]}
	"C" {lappend lista_pesi [list "ass_perdite" "C"]}
    }
    switch $valvola_sicur {
	"N" {lappend lista_pesi [list "valvola_sicur" "N"]}
	"C" {lappend lista_pesi [list "valvola_sicur" "C"]}
    }
    switch $vaso_esp {
	"N" {lappend lista_pesi [list "vaso_esp" "N"]}
	"C" {lappend lista_pesi [list "vaso_esp" "C"]}
    }
    switch $disp_sic_manom {
	"N" {lappend lista_pesi [list "disp_sic_manom" "N"]}
	"C" {lappend lista_pesi [list "disp_sic_manom" "C"]}
    }
    switch $organi_integri {
	"N" {lappend lista_pesi [list "organi_integri" "N"]}
	"C" {lappend lista_pesi [list "organi_integri" "C"]}
    }
    switch $circ_aria {
	"N" {lappend lista_pesi [list "circ_aria" "N"]}
	"C" {lappend lista_pesi [list "circ_aria" "C"]}
    }
    switch $guarn_accop {
	"N" {lappend lista_pesi [list "guarn_accop" "N"]}
	"C" {lappend lista_pesi [list "guarn_accop" "C"]}
    }
    switch $assenza_fughe {
	"N" {lappend lista_pesi [list "assenza_fughe" "N"]}
	"A" {lappend lista_pesi [list "assenza_fughe" "A"]}
    }
    switch $coibentazione {
	"N" {lappend lista_pesi [list "coibentazione" "N"]}
	"A" {lappend lista_pesi [list "coibentazione" "A"]}
    }
    switch $eff_evac_fum {
	"N" {lappend lista_pesi [list "eff_evac_fum" "N"]}
	"A" {lappend lista_pesi [list "eff_evac_fum" "A"]}
    }

    switch $funzione {
        I { if {$flag_portafoglio == "T"
		&& $data_controllo >= "20080801"} {
	    set azione "I"
	    set dml_trans [db_map ins_trans]
	} else {
	    set tariffa_reg ""
	    set importo_tariffa ""
	}
	    #	    ns_return 200 text/html " $tabella $stn"; return
	    
	    if {[exists_and_not_null tabella]} {
		set cod_dimp $cod_dimp_ins
	    }
	    set dml_sql [db_map ins_dimp]	
	    set dml_upd_tppt [db_map upd_tppt]	

	    # aggiorno su coimaimp il soggetto intestario del contratto
	    set dml_sql1 [db_map upd_aimp]

	    if {$sw_movi == "t"} {
		db_1row sel_dual_cod_movi ""
		set dml_movi [db_map ins_movi]
	    }

	    # in inserimento aggiorno sempre flag_dichiarato
	    set flag_dichiarato "S"

	    # in sel_aimp_old avevo letto data_prima_dich, data_installaz
	    # e note di coimaimp.

	    # se data_installaz non e' valorizzata, ci metto data_controllo
	    # e lo segnalo nelle note.
	    if {[string equal $data_installaz ""]} {
		set data_installaz  $data_controllo
		if {![string is space $note_aimp]} {
		    append note_aimp " "
		}
		append note_aimp "Data installazione presunta da data controllo del primo modello."
	    }

	    set dml_upd_aimp_flag_dich_data_inst [db_map upd_aimp_flag_dich_data_inst]

	    # gestione inserimento delle anomalie + inserimento rispettivi todo
	    set dml_ins_anom      [db_map ins_anom]
	    set dml_ins_todo_anom [db_map ins_todo]

	    # gestione inserimento dei todo relativi ai bollini
	    if {![string equal $note_todo_boll ""]} {
		set dml_ins_todo_boll [db_map ins_todo]
	    }

	    # aggiorno il controllo in agenda manutentore
	    # ad eseguito e con data_esecuzione = data_controllo
	    # se richiamato da coimgage-gest
	    if {![string is space $cod_opma]} {
		set stato           "2"
		set data_esecuzione $data_controllo
		set dml_upd_gage    [db_map upd_gage]
	    }
	    if {$flag_mod_gend == "S"} {
		set dml_upd_gend     [db_map upd_gend]
		db_1row sel_gend_count "";#nic03
		if {$conta_gend == 1} {#nic03
		    set aggiorna_potenze_impianto " , potenza_utile = :potenza ";#nic03
		} else {#nic03
		    set aggiorna_potenze_impianto "";#nic03
		};#nic03
		set dml_upd_aimp_mod [db_map upd_aimp_mod]
	    }
	}
        M {
	    set dml_sql [db_map upd_dimp]

	    if {$flag_portafoglio == "T"
		&& $data_controllo >= "20080801"} {
		set azione "M"
		set dml_trans [db_map ins_trans]
	    }
	    # aggiorno su coimaimp il soggetto intestario del contratto
	    set dml_sql1 [db_map upd_aimp]
	    
	    if {![exists_and_not_null tabella]} {
		if {$sw_movi == "t"} {
		    if {[db_0or1row sel_movi_check ""] == 0} {
			db_1row sel_dual_cod_movi ""
			set dml_movi  [db_map ins_movi]
		    } else {
			set dml_movi  [db_map upd_movi]
		    }
		} else {
		    set dml_movi      [db_map del_movi]
		}
	    }

	    # gestione delle anomalie: cancellazione todo ed anom
	    # e reinserimento anom e todo
	    set dml_del_todo_anom [db_map del_todo_anom]
	    set dml_del_anom      [db_map del_anom]
	    set dml_ins_anom      [db_map ins_anom]
	    set dml_ins_todo_anom [db_map ins_todo]

	    # gestione dei todo relativi ai bollini:
	    # cancellazione ed eventuale inserimento
	    set dml_del_todo_boll [db_map del_todo_boll]
	    if {![string equal $note_todo_boll ""]} {
		set dml_ins_todo_boll [db_map ins_todo]
	    }
	    if {$flag_mod_gend == "S"} {
		set dml_upd_gend [db_map upd_gend]

		db_1row sel_gend_count "";#nic03
		if {$conta_gend == 1} {#nic03
		    set aggiorna_potenze_impianto " , potenza_utile = :potenza ";#nic03
		} else {#nic03
		    set aggiorna_potenze_impianto "";#nic03
		};#nic03
		set dml_upd_aimp_mod [db_map upd_aimp_mod]
	    }
	}
        D { db_1row query "select stato_dich from coimdimp where cod_dimp = :cod_dimp"
	    if {[exists_and_not_null stato_dich]} {
		iter_return_complaint "Presenti richieste di storno. Funzione di storno impossibile"
	    } else {
		set dml_sql  [db_map del_dimp]
		if {$flag_portafoglio == "T"
		    && [iter_check_date $data_controllo] >= "20080801"} {
		    set azione "D"
		    set dml_trans [db_map ins_trans]
		}
		set dml_movi [db_map del_movi]
		#	    db_1row sel_dimp_count ""
		#	    if {$conta_dimp == 0} {
		#		iter_return_complaint "Record non trovato"
		#	    }
		#	    if {$conta_dimp == 1} {
		# se il modello h che vado a cancellare e' l'unico presente 
		# per l'impianto, valorizzo la data ultima dichiarazione
		# dell'impianto con la data prima dichiarazione
		#		set data_ultim_dich   $data_prima_dich
		#	    } else {
		# se il modello h che vado a cancellare non e' l'unico 
		# presente per l'impianto, valorizzo la data ultima 
		# dichiarazione dell'impianto con la data_controllo
		# dell'ultimo modello h.
		#		db_1row sel_dimp_last ""
		#		set data_ultim_dich   $data_controllo
		#	    }
		#	    set dml_upd_aimp_ultim_dich [db_map upd_aimp_ultim_dich]
		set dml_del_todo_all    [db_map del_todo_all]
		set dml_del_anom_all    [db_map del_anom_all]
		
		# aggiorno il controllo in agenda manutentore
		# a 'da eseguire' e con data_esecuzione = null
		# se richiamato da coimgage-gest
		if {![string is space $cod_opma]} {
		    set stato           "1"
		    set data_esecuzione ""
		    set dml_upd_gage    [db_map upd_gage]
		}
	    }
	}
    }
    
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
		db_dml dml_coimdimp $dml_sql
		
		if {$funzione == "I"} {
		    db_dml dml_upd_tppt $dml_upd_tppt
		}
		db_1row sel_tgen ""
		if {[string equal $flag_pesi "S"]} {
		    db_dml del_dipe ""
		    if {$funzione != "D"} {
			foreach peso $lista_pesi {
			    set nome_campo [lindex $peso 0]
			    set tipo_peso  [lindex $peso 1]
			    db_dml ins_dipe ""
			}
			db_1row sel_tot_pesi ""
			db_dml upd_dipe ""
		    }
		}
		
		if {[info exists dml_trans]} {
		    db_dml dml_coimtrans $dml_trans
		}

		if {[info exists dml_sql1]} {
		    db_dml dml_coimaimp $dml_sql1
		}
		
		if {[info exists dml_movi]} {
		    db_dml dml_coimmovi $dml_movi
		}
		
		if {[info exists dml_upd_aimp_flag_dich_data_inst]} {
		    set note $note_aimp
		    db_dml dml_coimaimp_flag_dich_data_inst $dml_upd_aimp_flag_dich_data_inst
		}
		
		if {[info exists dml_upd_aimp_stato]} {
		    db_dml dml_coimaimp_stato $dml_upd_aimp_stato
		}
		
		if {[info exists dml_aimp_pote]} {
		    db_dml dml_coimaimp $dml_aimp_pote
		}
		if {[info exists dml_gend_pote]} {
		    db_dml dml_coimgend $dml_gend_pote
		}
		if {[info exists dml_upd_aimp_sogg]} {
		    db_dml dml_coimaimp $dml_upd_aimp_sogg
		}
		if {[info exists dml_ins_rife_manu]} {
		    set ruolo            "M"
		    set cod_soggetto_old $cod_manutentore_old
		    db_dml dml_coimrife  $dml_ins_rife_manu
		}
		if {[info exists dml_ins_rife_resp]} {
		    set ruolo            "R"
		    set cod_soggetto_old $cod_responsabile_old
		    db_dml dml_coimrife  $dml_ins_rife_resp
		}
		if {[info exists dml_ins_rife_occu]} {
		    set ruolo            "O"
		    set cod_soggetto_old $cod_occupante_old
		    db_dml dml_coimrife  $dml_ins_rife_occu
		}
		if {[info exists dml_ins_rife_prop]} {
		    set ruolo            "P"
		    set cod_soggetto_old $cod_proprietario_old
		    db_dml dml_coimrife  $dml_ins_rife_prop
		}
		if {[info exists dml_ins_rife_inte]} {
		    set ruolo            "T"
		    set cod_soggetto_old $cod_int_contr_old
		    db_dml dml_coimrife  $dml_ins_rife_inte
		}
		if {[info exists dml_todo_aimp]} {
		    db_1row sel_dual_cod_todo ""
		    set tipologia     "5"
		    set note          $note_todo
		    set data_evento   $data_controllo
		    set flag_evasione $flag_evasione_todo
		    if {$flag_evasione == "N"} {
			set data_evasione ""
			set data_scadenza [iter_set_sysdate]
		    } else {
			set data_evasione $data_evento
			set data_scadenza $data_evento
		    }
		    db_dml dml_coimtodo_aimp $dml_todo_aimp
		}
		
		# in caso di aggiornamento elimino le anomalie
		# con i rispettivi todo
		if {[info exists dml_del_anom]} {
		    set conta 0
		    while {$conta < 5} {
			incr conta
			set prog_anom_db $prog_anom($conta)
			
			if {[info exists dml_del_todo_anom]} {
			    db_dml dml_coimtodo $dml_del_todo_anom
			}
			db_dml dml_coimanom $dml_del_anom
		    }
		}
		
		# in inserimento/aggiornamento inserisco le anomalie con i
		# rispettivi todo
		if {[info exists dml_ins_anom]} { 
		    set conta 0
		    while {$conta < 5} {
			incr conta
			
			if {![string equal $cod_anom($conta) ""]} {
			    # inserisco l'anomalia
			    set prog_anom_db   $prog_anom($conta)
			    set cod_anom_db    $cod_anom($conta)
			    set data_ut_int_db $data_ut_int($conta)
			    
			    db_dml dml_coimanom $dml_ins_anom
			    
			    if {[info exists dml_ins_todo_anom]} {
				db_1row sel_dual_cod_todo ""
				
				set tipologia     "1"
				# estraggo la descrizione anomalia da mettere
				# nelle note del todo

				if {[db_0or1row sel_tano ""] == 0} {
				    set note ""
				}
				
				set data_evento   $data_controllo
				set flag_evasione "N"
				set data_evasione ""
				set data_scadenza $data_ut_int_db
				db_dml dml_coimtodo_anom $dml_ins_todo_anom
			    }
			}
		    }
		}

		# in caso di aggiornamento elimino i todo dei bollini
		# li individuo con like delle note sotto indicate
                if {[info exists dml_del_todo_boll]} {
		    set note "Il bollino applicato sul modello H%"
		    db_dml dml_coimtodo_boll $dml_del_todo_boll
		}

		# in inserimento/aggiornamento inserisco gli eventuali
		# todo dei bollini
                if {[info exists dml_ins_todo_boll]} {
		    db_1row sel_dual_cod_todo ""
		    set tipologia     "1"
		    set note          $note_todo_boll
		    set data_evento   $data_controllo
		    set flag_evasione "N"
		    set data_evasione ""
		    set data_scadenza [iter_set_sysdate]

		    db_dml dml_coimtodo_boll $dml_ins_todo_boll
		}

		# in cancellazione elimino tutti i todo e tutte le anom
		# relative al modello H
		if {[info exists dml_del_todo_all]} {
		    db_dml dml_coimtodo $dml_del_todo_all
		}
		if {[info exists dml_del_anom_all]} {
		    db_dml dml_coimanom $dml_del_anom_all
		}

		# in inserimento ed in cancellazione aggiorno il controllo
		# in agenda manutentore
		if {[info exists dml_upd_gage]} {
		    db_dml dml_coimgage $dml_upd_gage
		}

		if {[info exists dml_upd_aimp_prima_dich]} {
		    db_dml dml_coimaimp $dml_upd_aimp_prima_dich
		}

		if {[info exists dml_upd_aimp_ultim_dich]} {
		    db_dml dml_coimaimp $dml_upd_aimp_ultim_dich
		}
                if {[info exists dml_upd_gend]} {
		    db_dml dml_coimgend $dml_upd_gend
		}
                if {[info exists dml_upd_aimp_mod]} {
		    db_dml dml_coimaimp $dml_upd_aimp_mod
		}
	    }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione eq "I"} {
        set last_cod_dimp [list $data_controllo $cod_dimp]
    }

    set link_list [subst $link_list_script]
    set link_gest [export_url_vars flag_tracciato cod_dimp last_cod_dimp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp url_gage flag_no_link cod_opma data_ins tabella]

    switch $funzione {
        M {set return_url "coimdimp-gest?funzione=V&$link_gest"}
        D {
	    if {$flag_no_link == "F"} { 
		set return_url  "$pack_dir/coimdimp-list?$link_list"
	    } else {
		set return_url  "coimdimp-gest?funzione=I&$link_gest"
	    }  
	}
        I { 
	    if {$nome_funz_caller == "insmodg"} {
		set return_url "$pack_dir/coimdimp-ins-filter?&nome_funz=insmodg&[export_url_vars flag_tracciato]&cod_impianto_old=$cod_impianto&cod_dimp_old=$cod_dimp"
	    } else {
		set return_url "coimdimp-gest?funzione=V&$link_gest&transaz_eff=$transaz_eff"
            }
	    #nic01 if {![string equal $__refreshing_p 0] && ![string equal $__refreshing_p ""]} {
	    #nic01     ad_returnredirect "coimdimp-gest?funzione=I&$link_list&__refreshing_p=$__refreshing_p"
	    #nic01 }
	}
        V {set return_url "$pack_dir/coimdimp-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
