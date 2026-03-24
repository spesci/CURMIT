ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Romitti Luca
    @creation-date   20/06/2018

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                       navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimgend-pote.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================


} {
    {funzione            "V"}
    {caller               ""}
    {nome_funz            "datigen"}
    {nome_funz_caller     ""}
    {cod_impianto         ""}
    {gen_prog             ""}
    {cod_gen              ""}
    {url_list_aimp        ""}
    {url_aimp             ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}
switch $funzione {
    "V" {set lvl 1}
    "M" {set lvl 3}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest      [export_url_vars cod_impianto gen_prog last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]
#set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_ma [string range $id_utente 0 1]
iter_get_coimtgen
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

set titolo "Inserimento potenza singolo modulo"
switch $funzione {
    M {set button_label "Conferma Modifica"
	set page_title   "Modifica $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"}
}
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimgend-pote"
set focus_field  "";#nic01
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
    }
}
form create $form_name \
    -html    $onsubmit_cmd 


set num_prove_fumi [db_string query "select coalesce(num_prove_fumi,2)
                                       from coimgend 
                                      where cod_impianto = :cod_impianto 
                                        and gen_prog     = :gen_prog " -default 2]

set conta_prfumi 0

multirow create multiple_form_prfumi conta_prfumi
while {$conta_prfumi <= ($num_prove_fumi -1)} {
    incr conta_prfumi
    if {$conta_prfumi > 9} {
	break
    }
    
    multirow append multiple_form_prfumi $conta_prfumi
    
    element create $form_name progressivo_prova_fumi.$conta_prfumi \
	-label   "progressivo_prove_fumi" \
	-widget   inform \
	-datatype text \
	-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
	-optional

    element create $form_name potenza_nominale_focolare.$conta_prfumi \
	-label   "potenza_nominale_focolare" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element" \
	-optional

    element create $form_name potenza_utile_focolare.$conta_prfumi \
	-label   "potenza_utile_focolare" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional

    element set_properties $form_name progressivo_prova_fumi.$conta_prfumi      -value $conta_prfumi
    

}
element create $form_name cod_impianto     -widget hidden -datatype text -optional

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit";#nic01
element create $form_name gen_prog         -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name gen_prog         -value $gen_prog
    


set conta_prfumi 0

db_foreach a "select iter_edit_num(potenza_utile_focolare, 2) as potenza_utile_focolare
                           , iter_edit_num(potenza_nominale_focolare, 2) as potenza_nominale_focolare
                           , cod_pr_fumi
                        from coimgend_pote
                       where cod_impianto = :cod_impianto
                         and gen_prog = :gen_prog
        " {

	    incr conta_prfumi
	    element set_properties $form_name potenza_utile_focolare.$conta_prfumi      -value $potenza_utile_focolare
	    element set_properties $form_name potenza_nominale_focolare.$conta_prfumi      -value $potenza_nominale_focolare
	}

}

if {[form is_valid $form_name]} {
    
    # form valido dal punto di vista del templating system
    set cod_impianto     [string trim [element::get_value $form_name cod_impianto]]
    set gen_prog         [string trim [element::get_value $form_name gen_prog]]
    set error_num 0
    set conta_prfumi 0
    set potenza_utile_focolare_prfumi_tot    0
    set potenza_nominale_focolare_prfumi_tot 0

    while {$conta_prfumi <= ($num_prove_fumi -1)} {
	incr conta_prfumi
	if {$conta_prfumi > 9} {
	    break
	}

	set potenza_utile_focolare_prfumi($conta_prfumi)    [string trim [element::get_value $form_name potenza_utile_focolare.$conta_prfumi]]
	set potenza_nominale_focolare_prfumi($conta_prfumi) [string trim [element::get_value $form_name potenza_nominale_focolare.$conta_prfumi]] 
	set progressivo_prova_fumi_prfumi($conta_prfumi)    [string trim [element::get_value $form_name progressivo_prova_fumi.$conta_prfumi]]
	
	if {[string equal $potenza_utile_focolare_prfumi($conta_prfumi) ""]} {
	    element::set_error $form_name potenza_utile_focolare.$conta_prfumi "Inserire"
	    incr error_num
	}
	if {![string equal $potenza_utile_focolare_prfumi($conta_prfumi) ""]} {
	    set potenza_utile_focolare_prfumi($conta_prfumi) [iter_check_num $potenza_utile_focolare_prfumi($conta_prfumi) 2]
	    if {$potenza_utile_focolare_prfumi($conta_prfumi) == "Error"} {
		element::set_error $form_name potenza_utile_focolare.$conta_prfumi "Deve essere numerico e pu&ograve;<br>avere al massimo 2 decimali"
		incr error_num
	    }
	}
	if {[string equal $potenza_nominale_focolare_prfumi($conta_prfumi) ""]} {
	    element::set_error $form_name potenza_nominale_focolare.$conta_prfumi "Inserire"
	    incr error_num
	}
	if {![string equal $potenza_nominale_focolare_prfumi($conta_prfumi) ""]} {
	    set potenza_nominale_focolare_prfumi($conta_prfumi) [iter_check_num $potenza_nominale_focolare_prfumi($conta_prfumi) 2]
	    if {$potenza_nominale_focolare_prfumi($conta_prfumi) == "Error"} {
		element::set_error $form_name potenza_nominale_focolare.$conta_prfumi "Deve essere numerico e pu&ograve;<br>avere al massimo 2 decimali"
		    incr error_num
	    }
	}   
	
	if {$error_num == 0} {
	    set potenza_utile_focolare_prfumi_tot    [ah::round [expr $potenza_utile_focolare_prfumi_tot + $potenza_utile_focolare_prfumi($conta_prfumi)] 2]
	    set potenza_nominale_focolare_prfumi_tot [ah::round [expr $potenza_nominale_focolare_prfumi_tot + $potenza_nominale_focolare_prfumi($conta_prfumi)] 2]
	    
	}
    };#fine while    

    if {$error_num == 0} {
	set potenza_utile_focolare_prfumi_tot_pretty    [iter_edit_num $potenza_utile_focolare_prfumi_tot 2 ]
	set potenza_nominale_focolare_prfumi_tot_pretty [iter_edit_num $potenza_nominale_focolare_prfumi_tot 2 ]
	db_1row q "select iter_edit_num(pot_utile_nom, 2)    as pot_utile_nom_pretty
                        , pot_utile_nom    
                        , iter_edit_num(pot_focolare_nom, 2) as pot_focolare_nom_pretty
                        , pot_focolare_nom 
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and gen_prog     = :gen_prog"
	if {$potenza_utile_focolare_prfumi_tot != $pot_utile_nom} {
	    element::set_error $form_name potenza_utile_focolare.$conta_prfumi "La somma dei singoli moduli della \"Portata termica utile nomiale Pn (kW)\" &egrave; di $potenza_utile_focolare_prfumi_tot_pretty (kW), mentre la \"Potenza termica utile nominale\" del generatore &egrave; $pot_utile_nom_pretty (kW)"
	    incr error_num
	}
	if {$potenza_nominale_focolare_prfumi_tot != $pot_focolare_nom} {
	    element::set_error $form_name potenza_nominale_focolare.$conta_prfumi "La somma dei singoli moduli della<br>\"Portata nominale focolare (kW)\" &egrave; di $potenza_nominale_focolare_prfumi_tot_pretty (kW), mentre la \"Potenza termica al focolare nominale\" del generatore &egrave; $pot_focolare_nom_pretty (kW)"
	    incr error_num
	}
    }


    if {$error_num > 0} {
	ad_return_template
	return
    }


    db_dml q "delete from coimgend_pote 
               where cod_impianto = :cod_impianto 
                 and gen_prog     = :gen_prog"


    set conta_prfumi 0
    while {$conta_prfumi <= ($num_prove_fumi -1)} {
	incr conta_prfumi
	if {$conta_prfumi > 9} {
	    break
	}
	set cod_pr_fumi_new [db_string q "select coalesce(max(cod_pr_fumi::integer),'0')+1 from coimgend_pote"]
	set progressivo_prova_fumi_new    $progressivo_prova_fumi_prfumi($conta_prfumi)
	set potenza_utile_focolare_new    $potenza_utile_focolare_prfumi($conta_prfumi)
	set potenza_nominale_focolare_new $potenza_nominale_focolare_prfumi($conta_prfumi)
	db_dml q "insert into coimgend_pote
                       (cod_pr_fumi
                       ,progressivo_prova_fumi
                       ,cod_impianto
                       ,gen_prog
                       ,potenza_utile_focolare
                       ,potenza_nominale_focolare)
                    values (
                        :cod_pr_fumi_new
                       ,:progressivo_prova_fumi_new
	               ,:cod_impianto
                       ,:gen_prog
                       ,:potenza_utile_focolare_new
                       ,:potenza_nominale_focolare_new
                       )"
	
    };#fine while
    

    set link_list_script {[export_url_vars cod_impianto last_gen_prog caller nome_funz_caller nome_funz url_list_aimp url_aimp]}
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto gen_prog last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]
    switch $funzione {
	M {set return_url   "coimgend-pote?funzione=V&$link_gest"}
	V {set return_url   "coimgend-pote?$link_list"}
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
