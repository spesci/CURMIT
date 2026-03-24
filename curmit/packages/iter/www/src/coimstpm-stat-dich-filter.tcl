ad_page_contract {
    @author          Gianni Prosperi
    @creation-date   19/04/2007

    @param funzione  V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimstpm-stat-opve-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi f_data_da, f_data_a, f_data_controllo_iniz, f_data_controllo_fine.
    rom01 21/10/2020 Su segnalazione di Salerno modificato page_title per renderlo
    rom01            uguale al nome del menu', Sandro ha detto che va bene per tutti.

    sim01 18/11/2016 Gestito la potenza in base al flag_tipo_impianto

} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_da        ""}
    {f_data_a         ""}
    {cognome_manu     ""}
    {nome_manu        ""}
    {cod_combustibile ""}
    {f_data_controllo_iniz ""}
    {f_data_controllo_fine ""}
    {ute_emmegi ""}
    {f_utente         ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
# leggo l'utente e prendo il ruolo per vedere se admin
db_1row query "select id_ruolo from coimuten where id_utente = :id_utente"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)
set cod_comune $coimtgen(cod_comu)
# Controllo se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

set id_utente_em [string range $id_utente 0 5]

set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_cod "readonly"
set disabled_fld "disabled"

# Personalizzo la pagina
#rom01set titolo       "Parametri per stampa statistiche Dichiarazioni" 
set titolo       "Riepilogo RCEE/DAM";#rom01
set button_label "Seleziona" 
#rom01set page_title   "Parametri per stampa statistiche Dichiarazioni"
set page_title    "Riepilogo RCEE/DAM";#rom01

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

set id_utente_em [string range $id_utente 0 5]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstpm_stat_opve"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date ai campi f_data_da, f_data_a, f_data_controllo_iniz, f_data_controllo_fine. 
element create $form_name f_data_da \
    -label   "Da data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_a \
    -label   "A data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

#sim01 per distinguere tra potenze del freddo e del caldo aggiungo flag_tipo_impianto||'-'|| e l'ordinamento per descr_potenza. Prima era [iter_selbox_from_table coimpote cod_potenza descr_potenza]
element create $form_name cod_potenza \
    -label   "codice potenza" \
    -widget   select \
    -options  [iter_selbox_from_table coimpote cod_potenza flag_tipo_impianto||'-'||descr_potenza descr_potenza] \
    -datatype text \
    -html    "class form_element" \
    -optional

element create $form_name cod_combustibile \
    -label   "Combustibile" \
    -widget   select \
    -options  [iter_selbox_from_table coimcomb cod_combustibile descr_comb] \
    -datatype text \
    -html    "class form_element" \
    -optional

if {[string equal $cod_manutentore ""]} {
    set readonly_fld2 \{\}

    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]

} else {
    set readonly_fld2 "readonly"
    set cerca_manu    ""
}

element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 40 $readonly_fld2 {} class form_element" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld2 {} class form_element" \
    -optional
 
element create $form_name f_data_controllo_iniz \
    -label   "Da data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10  class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_controllo_fine \
    -label   "A data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10  class form_element class ah-jquery-date" \
    -optional

if {[string equal $coimtgen(ente) "PGO"]
&&  [string equal $cod_manutentore ""]
} {
element create $form_name ute_emmegi \
    -label   "Utente Emmegi" \
    -widget   text \
    -datatype text \
    -html    "size 02 maxlength 02  class form_element" \
    -optional
} else {
element create $form_name ute_emmegi -widget hidden -datatype text -optional
}
element create $form_name cod_manutentore -widget hidden -datatype text -optional

if {$flag_ente == "P"} {
    element create $form_name f_cod_comune \
	-label   "Comune" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options [iter_selbox_from_comu]
} else {
    element create $form_name f_cod_comune -widget hidden -datatype text -optional
    element set_properties $form_name f_cod_comune  -value $cod_comune
}

set options_cod_tp_ute [db_list_of_lists sel_lol "select id_utente, id_utente from coimuten where id_settore = 'ente' order by id_utente"]
set options_cod_tp_ute [linsert $options_cod_tp_ute 0 [list "" ""]]

if {[string equal $id_ruolo "admin"]} {
    element create $form_name f_utente \
	-label   "Utente" \
	-widget   select \
	-options  $options_cod_tp_ute \
	-datatype text \
	-html    "class form_element tabindex 14" \
	-optional
} else {
    element create $form_name f_utente -widget hidden -datatype text -optional
}


element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy            -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    if {![string equal $cod_manutentore ""]} {
	#element set_properties $form_name cod_manutentore   -value $cod_manutentore
	if {[db_0or1row query "
            select cognome as cognome_manu
                 , nome    as nome_manu
              from coimmanu
             where cod_manutentore = :cod_manutentore"]
	} {
	    set manu_cogn ""
	    set manu_nome ""
	}
    }
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name cognome_manu     -value $cognome_manu
  
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_da         [element::get_value $form_name f_data_da]
    set f_data_a          [element::get_value $form_name f_data_a]
    set cod_potenza       [element::get_value $form_name cod_potenza]
    set cod_combustibile  [element::get_value $form_name cod_combustibile]
    set cognome_manu      [string trim [element::get_value $form_name cognome_manu]]
    set nome_manu         [string trim [element::get_value $form_name nome_manu]]
    set cod_manutentore   [string trim [element::get_value $form_name cod_manutentore]]
    set f_cod_comune      [element::get_value $form_name f_cod_comune]
    set f_data_controllo_iniz [string trim [element::get_value $form_name f_data_controllo_iniz]]
    set f_data_controllo_fine [string trim [element::get_value $form_name f_data_controllo_fine]]
    set f_utente              [element::get_value $form_name f_utente]

 
    if {[string equal $coimtgen(ente) "PGO"]
    &&  [string equal $cod_manutentore ""]
    } {
	set ute_emmegi [string trim [element::get_value $form_name ute_emmegi]]
    }

    set error_num 0

    if {![string equal $ute_emmegi ""]} {
	if {![string equal $ute_emmegi "01"]
	&& ![string equal $ute_emmegi  "02"]
        && ![string equal $ute_emmegi  "03"]
        && ![string equal $ute_emmegi  "04"]
        && ![string equal $ute_emmegi  "05"]
        && ![string equal $ute_emmegi  "06"]
	} {
	    element::set_error $form_name ute_emmegi "Utente deve essere 01 o 02 0 03..."
	    incr error_num
	}
    }
    
    if {[string equal $id_utente_em "emmegi"]} {
	if {[string equal $ute_emmegi ""]} {
	    element::set_error $form_name ute_emmegi "Dato Obbligatorio"
	    incr error_num
	}
    }
    

    if {[string equal $f_data_da ""]} {
	element::set_error $form_name f_data_da "Data Obbligatoria"
	incr error_num
    }
    if {[string equal $f_data_a ""]} {
	element::set_error $form_name f_data_a "Data Obbligatoria"
	incr error_num
    }
    
    #controllo f_data_da
    if {![string equal $f_data_da ""]} {
	set f_data_da [iter_check_date $f_data_da]
	if {$f_data_da == 0} {
	    element::set_error $form_name f_data_da "Data non corretta"
	    incr error_num
	}
    }

    #controllo f_data_a
    if {![string equal $f_data_a ""]} {
	set f_data_a [iter_check_date $f_data_a]
	if {$f_data_a == 0} {
	    element::set_error $form_name f_data_a "Data non corretta"
	    incr error_num
	}
    }


    set check_data_controllo_iniz "f"
    if {![string equal $f_data_controllo_iniz ""]} {
	set f_data_controllo_iniz [iter_check_date $f_data_controllo_iniz]
	if {$f_data_controllo_iniz == 0} {
	    element::set_error $form_name f_data_controllo_iniz "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_data_controllo_iniz "t"
	}
    }
    
    set check_data_controllo_fine "f"
    if {![string equal $f_data_controllo_fine ""]} {
	set f_data_controllo_fine [iter_check_date $f_data_controllo_fine]
	if {$f_data_controllo_fine == 0} {
	    element::set_error $form_name f_data_controllo_fine "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_data_controllo_fine "t"
	}
    }
	
    if {$f_data_controllo_iniz == "t"
    &&  $check_data_controllo_fine == "t"
    &&  $f_data_controllo_iniz > $f_data_controllo_fine
    } {
	element::set_error $form_name f_data_controllo_iniz "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }

    if {![string equal $f_data_controllo_iniz ""]
    &&  [string equal $f_data_controllo_fine ""]
    } {
	element::set_error $form_name f_data_controllo_fine "Se immessa data inizio deve esistere anche data fine"
	incr error_num
    }

    if {$error_num > 0} {
	ad_return_template
	return
    }

    set link_layout [export_url_vars f_data_da f_data_a cod_potenza f_cod_comune cod_combustibile cognome_manu f_data_controllo_iniz f_data_controllo_fine ute_emmegi f_utente nome_funz nome_funz_caller]
    set return_url "coimstpm-stat-dich-layout?$link_layout"    
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
