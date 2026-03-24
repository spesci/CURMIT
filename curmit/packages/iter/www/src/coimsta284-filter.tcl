ad_page_contract {

    @creation-date   10/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl
  
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi f_data1, f_data2
} {  
   {f_data1           ""}
   {f_data2           ""}
   {f_comune          ""}
   {nome_manu         ""}
   {cognome_manu      ""}
   {cod_manutentore   ""}
   {caller       "index"}
   {funzione         "V"}
   {nome_funz         ""}
   {nome_funz_caller  ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


# Personalizzo la pagina
set titolo       "Parametri per stampa riepilogo allegati 284 "
set button_label "Seleziona"
set page_title   "Parametri per stampa riepilogo allegati 284"

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimsta10"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
-html    $onsubmit_cmd

#but01 Aggiunto la classe ah-jquery-date ai campi f_data1, f_data2
element create $form_name f_data1 \
-label   "data inizio" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional \

element create $form_name f_data2 \
-label   "data fine" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional \

element create $form_name f_comune \
-label   "Comune" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element tabindex 4" \
-optional \
-options [iter_selbox_from_comu]

element create $form_name cognome_manu \
-label   "Cognome manutentore" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name nome_manu \
-label   "Nome manutentore" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]

element create $form_name cod_manutentore -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {
    
    element set_properties $form_name f_data1        -value [iter_edit_date $f_data1]
    element set_properties $form_name f_data2        -value [iter_edit_date $f_data2]
    element set_properties $form_name f_comune        -value [iter_edit_date $f_comune]
    element set_properties $form_name cognome_manu    -value [iter_edit_date $cognome_manu]
    element set_properties $form_name nome_manu       -value [iter_edit_date $nome_manu]
    element set_properties $form_name cod_manutentore -value [iter_edit_date $cod_manutentore]

    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set f_data1        [element::get_value $form_name f_data1]
    set f_data2        [element::get_value $form_name f_data2]
    set f_comune     [element::get_value $form_name f_comune]
    set cognome_manu     [element::get_value $form_name cognome_manu]
    set nome_manu        [element::get_value $form_name nome_manu]
    set cod_manutentore  [element::get_value $form_name cod_manutentore]


   
    set error_num 0

  if {[string equal $f_data1 ""]} {
        element::set_error $form_name f_data1 "Data obbligatoria"
	    incr error_num
  }    

 if {[string equal $f_data2 ""]} {
        element::set_error $form_name f_data2 "Data obbligatoria"
	    incr error_num
  }    


    set flag_data1_ok "f"
    if {![string equal $f_data1 ""]} {
	set f_data1 [iter_check_date $f_data1]
	if {$f_data1 == 0} {
	    element::set_error $form_name f_data1 "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data1_ok "t"
	}
    }
    
    set flag_data2_ok "f"
    if {![string equal $f_data2 ""]} {
	set f_data2 [iter_check_date $f_data2]
	if {$f_data2 == 0} {
	    element::set_error $form_name f_data2 "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data2_ok "t"
	}
    }

    if {$flag_data1_ok
    &&  $flag_data2_ok
    &&  $f_data1 > $f_data2
    } {
	element::set_error $form_name f_data2 "La data iniziale dell'intervallo deve essere inferiore a quella finale"
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
    
    if {[string equal $cognome_manu ""]
	&&  [string equal $nome_manu    ""]
    } {
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

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set link [export_url_vars  f_comune f_data1 f_data2  cod_manutentore nome_manu cognome_manu caller funzione nome_funz nome_funz_caller]

   
    set return_url "coimsta284-layout?$link"    

    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
