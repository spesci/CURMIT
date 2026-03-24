ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   06/08/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, serve per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi 

} {
    
   {funzione            "V"}
   {caller          "index"}
   {nome_funz            ""}
   {nome_funz_caller     ""}
   {f_da_dat_prot      ""}
   {f_a_dat_prot       ""}
   {f_da_dat_prot2     ""}
   {f_a_dat_prot2      ""}
   {f_da_data_stp      ""}
   {f_a_data_stp       ""}
   {f_da_num_prot      ""}
   {f_a_num_prot       ""}
   {f_da_num_prot2     ""}
   {f_a_num_prot2      ""}
   {f_cod_sogg         ""}
   {f_tipo_doc         ""}
   {cod_impianto       ""}
   {f_manu_cogn        ""}
   {f_manu_nome        ""}
   {dummy              ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCUFILTER-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCUFILTER-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-DOCUFILTER-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


# Controllo se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]


# Personalizzo la pagina
set titolo       "Selezione Documenti"
set button_label "Seleziona" 
set page_title   "Selezione Documenti"

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set flag_viario  $coimtgen(flag_viario)
set cod_comune   $coimtgen(cod_comu)
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 


set form_name    "coimdocu_filter"
set readonly_fld \{\}
set disabled_fld \{\}
set onsubmit_cmd ""


# imposto variabili per il cerca del manutentore
set sw_manu "f"
if {[string equal $cod_manutentore ""]} {
    set readonly_fld2 \{\}
    set cerca_manu    [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy f_manu_cogn dummy f_manu_nome]]
} else {
    set readonly_fld2 "readonly"
    set cerca_manu    ""
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date ai campi:f_da_dat_prot, f_a_dat_prot, f_da_dat_prot2, f_a_dat_prot2,f_a_data_stp, f_da_data_stp.
element create $form_name f_da_dat_prot \
-label   "Da Data protocollo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional

element create $form_name f_a_dat_prot \
-label   "a Data protocollo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional

element create $form_name f_da_dat_prot2 \
-label   "Da Data protocollo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional

element create $form_name f_a_dat_prot2 \
-label   "a Data protocollo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional


element create $form_name f_cod_impianto_est \
-label   "Cod. Impianto" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name f_da_data_stp \
-label   "Da data stampa" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional

element create $form_name f_a_data_stp \
-label   "A data stampa" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 $jq_date" \
-optional

element create $form_name f_da_num_prot \
-label   "Da numero protocollo" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name f_a_num_prot \
-label   "A numero protocollo" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name f_da_num_prot2 \
-label   "Da numero protocollo" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name f_a_num_prot2 \
-label   "A numero protocollo" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name f_cogn_resp \
-label   "cognome soggetto" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name f_nome_resp \
-label   "cognome soggetto" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

set cerca_resp  [iter_search $form_name coimcitt-filter [list dummy f_cod_sogg f_cognome f_cogn_resp f_nome f_nome_resp]]

element create $form_name f_tipo_doc \
-label   "Tipo documento" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtdoc tipo_documento descrizione]

element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element " \
    -optional

element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element "\
    -optional



element create $form_name nome_funz_caller  -widget hidden -datatype text -optional
element create $form_name f_cod_sogg  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit "
element create $form_name cod_manutentore -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    if {![string equal $f_cod_sogg ""]} {
	if {[db_0or1row sel_resp ""] == 0} {
	    set cogn_resp ""
	    set nome_resp ""
	}
    } else {
	set cogn_resp ""
	set nome_resp ""
    }

    element set_properties $form_name f_cogn_resp    -value $cogn_resp
    element set_properties $form_name f_nome_resp    -value $nome_resp
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz
    element set_properties $form_name dummy          -value $dummy    
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name f_da_num_prot  -value $f_da_num_prot
    element set_properties $form_name f_a_num_prot   -value $f_a_num_prot
    element set_properties $form_name f_da_num_prot2  -value $f_da_num_prot2
    element set_properties $form_name f_a_num_prot2   -value $f_a_num_prot2
    element set_properties $form_name f_cod_impianto_est -value $cod_impianto
    element set_properties $form_name f_da_dat_prot  -value [iter_edit_date $f_da_dat_prot]
    element set_properties $form_name f_a_dat_prot   -value [iter_edit_date $f_a_dat_prot]
    element set_properties $form_name f_da_dat_prot2 -value [iter_edit_date $f_da_dat_prot2]
    element set_properties $form_name f_a_dat_prot2  -value [iter_edit_date $f_a_dat_prot2]
    element set_properties $form_name f_da_data_stp  -value [iter_edit_date $f_da_data_stp]
    element set_properties $form_name f_a_data_stp   -value [iter_edit_date $f_a_data_stp]
    element set_properties $form_name f_da_num_prot  -value $f_da_num_prot
    element set_properties $form_name f_cod_sogg     -value $f_cod_sogg   
    element set_properties $form_name f_tipo_doc     -value $f_tipo_doc 
    element set_properties $form_name f_manu_cogn    -value $f_manu_cogn
    element set_properties $form_name f_manu_nome    -value $f_manu_nome
  

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set f_da_dat_prot      [element::get_value $form_name f_da_dat_prot]
    set f_a_dat_prot       [element::get_value $form_name f_a_dat_prot]
    set f_da_dat_prot2     [element::get_value $form_name f_da_dat_prot2]
    set f_a_dat_prot2      [element::get_value $form_name f_a_dat_prot2]
    set f_cod_impianto_est [element::get_value $form_name f_cod_impianto_est]
    set f_da_data_stp      [element::get_value $form_name f_da_data_stp]
    set f_a_data_stp       [element::get_value $form_name f_a_data_stp]
    set f_da_num_prot      [element::get_value $form_name f_da_num_prot]
    set f_a_num_prot       [element::get_value $form_name f_a_num_prot]
    set f_da_num_prot2     [element::get_value $form_name f_da_num_prot2]
    set f_a_num_prot2      [element::get_value $form_name f_a_num_prot2]
    set f_cogn_resp        [element::get_value $form_name f_cogn_resp]
    set f_nome_resp        [element::get_value $form_name f_nome_resp]
    set f_tipo_doc         [element::get_value $form_name f_tipo_doc] 
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]
   

    set error_num 0

    if {[string equal $f_cod_impianto_est ""]
    &&  [string equal $f_cogn_resp        ""]
    &&  [string equal $f_nome_resp        ""]
    &&  [string equal $f_da_dat_prot      ""]
    &&  [string equal $f_a_dat_prot       ""]
    &&  [string equal $f_tipo_doc         ""]
    &&  [string equal $f_da_data_stp      ""]
    &&  [string equal $f_a_data_stp       ""]
    &&  [string equal $f_da_num_prot      ""]
    &&  [string equal $f_a_num_prot       ""]
    &&  [string equal $f_da_num_prot2     ""]
    &&  [string equal $f_a_num_prot2      ""]
    &&  [string equal $f_da_dat_prot2     ""]
    &&  [string equal $f_a_dat_prot2      ""]
    &&  [string equal $f_manu_cogn        ""]
    &&  [string equal $f_manu_nome        ""]
    } {
	element::set_error $form_name f_cod_impianto_est "Indicare almeno<br> un parametro di selezione"
	incr error_num
    }

    if {![string equal $f_cod_impianto_est ""]
    && (![string equal $f_cogn_resp        ""]
    ||  ![string equal $f_nome_resp        ""]
    ||  ![string equal $f_da_dat_prot      ""]
    ||  ![string equal $f_a_dat_prot       ""]
    ||  ![string equal $f_tipo_doc         ""]
    ||  ![string equal $f_da_data_stp      ""]
    ||  ![string equal $f_a_data_stp       ""]
    ||  ![string equal $f_da_num_prot      ""]
    ||  ![string equal $f_a_num_prot       ""]
    ||  ![string equal $f_da_num_prot2     ""]
    ||  ![string equal $f_a_num_prot2      ""]
    ||  ![string equal $f_da_dat_prot2     ""]
    ||  ![string equal $f_a_dat_prot2      ""]
    )
    } {
	element::set_error $form_name f_cod_impianto_est "Con la selezione per codice non &egrave; possibile indicare nessun altro criterio di selezione"
	incr error_num
    } else {
	if {[string equal $f_cogn_resp ""]
        && ![string equal $f_nome_resp ""]
	} {
	    element::set_error $form_name f_cogn_resp "Indicare anche il cognome"
	    incr error_num
	}
    }

    set check_da_data_stp "f"
    if {![string equal $f_da_data_stp ""]} {
	set f_da_data_stp [iter_check_date $f_da_data_stp]
	if {$f_da_data_stp == 0} {
	    element::set_error $form_name f_da_data_stp "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_da_data_stp "t"
	}
    }

    set check_a_data_stp "f"
    if {![string equal $f_a_data_stp ""]} {
	set f_a_data_stp [iter_check_date $f_a_data_stp]
	if {$f_a_data_stp == 0} {
	    element::set_error $form_name f_a_data_stp "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_a_data_stp "t"
	}
    }

    if {$check_da_data_stp  == "t"
    &&  $check_a_data_stp   == "t"
    &&  $f_da_data_stp > $f_a_data_stp
    } {
	element::set_error $form_name f_da_data_stp "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }

    set check_da_dat_prot "f"
    if {![string equal $f_da_dat_prot ""]} {
	set f_da_dat_prot [iter_check_date $f_da_dat_prot]
	if {$f_da_dat_prot == 0} {
	    element::set_error $form_name f_da_dat_prot "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_da_dat_prot "t"
	}
    }

    set check_a_dat_prot "f"
    if {![string equal $f_a_dat_prot ""]} {
	set f_a_dat_prot [iter_check_date $f_a_dat_prot]
	if {$f_a_dat_prot == 0} {
	    element::set_error $form_name f_a_dat_prot "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_a_dat_prot "t"
	}
    }

    if {$check_da_dat_prot  == "t"
    &&  $check_a_dat_prot   == "t"
    &&  $f_da_dat_prot > $f_a_dat_prot
    } {
	element::set_error $form_name f_da_dat_prot "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }


    set check_da_dat_prot2 "f"
    if {![string equal $f_da_dat_prot2 ""]} {
	set f_da_dat_prot2 [iter_check_date $f_da_dat_prot2]
	if {$f_da_dat_prot2 == 0} {
	    element::set_error $form_name f_da_dat_prot2 "Inserire correttamente la data" 
	    incr error_num
	} else {
	    set check_da_dat_prot2 "t"
	}
    }

    set check_a_dat_prot2 "f"
    if {![string equal $f_a_dat_prot2 ""]} {
	set f_a_dat_prot2 [iter_check_date $f_a_dat_prot2]
	if {$f_a_dat_prot2 == 0} {
	    element::set_error $form_name f_a_dat_prot2 "Inserire correttamente la data"
	    incr error_num
	} else {
	    set check_a_dat_prot2 "t"
	}
    }

    if {$check_da_dat_prot2  == "t"
    &&  $check_a_dat_prot2   == "t"
    &&  $f_da_dat_prot2 > $f_a_dat_prot2
    } {
	element::set_error $form_name f_da_dat_prot2 "Data Inizio deve essere minore di Data Fine"
	incr error_num
    }

    if { [string equal $f_cod_sogg  ""]
    &&	![string equal $f_cogn_resp ""]
    &&	![string equal $f_nome_resp ""]
    } {

	set f_cogn_resp [iter_search_word $f_cogn_resp]
	set f_nome_resp [iter_search_word $f_nome_resp]

	db_1row sel_count_sogg ""

	if {$conta_sogg == 0} {
	    element::set_error $form_name f_nome_resp "Soggetto non trovato"
	    incr error_num
	} 
	if {$conta_sogg > 1} {
	    element::set_error $form_name f_nome_resp "Trovati pi&ugrave; soggetti: usa il link cerca"
	    incr error_num
	}
	if {$conta_sogg == 1} {
	    db_1row get_cod_sogg ""
	}
    }

    if {![string equal $f_cod_impianto_est ""]} {
	if {[db_0or1row get_cod_aimp ""] == 0} {
	    element::set_error $form_name f_cod_impianto_est "Impianto inesistente"
	    incr error_num
	}
    }

    # manutentore
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
                              where upper(cognome)            $eq_cognome
                                and upper(nome)               $eq_nome
                                and coalesce(flag_attivo,'S') <> 'N'
        " {
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

    if {[string equal $f_manu_cogn ""] &&  [string equal $f_manu_nome ""]} {
	set cod_manutentore ""
    } else {
	set chk_inp_cod_manu $cod_manutentore
	set chk_inp_cognome  $f_manu_cogn
	set chk_inp_nome     $f_manu_nome
	eval $check_cod_manu
	set cod_manutentore  $chk_out_cod_manu
	if {$chk_out_rc == 0} {
	    element::set_error $form_name f_manu_cogn $chk_out_msg
	    incr error_num
	}
    }
    #fine manutentore

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set link_list [export_url_vars cod_impianto f_cod_sogg f_da_dat_prot f_a_dat_prot f_da_dat_prot2 f_a_dat_prot2 f_da_data_stp f_a_data_stp f_da_num_prot f_a_num_prot f_da_num_prot2 f_a_num_prot2 f_tipo_doc funzione nome_funz nome_funz_caller f_cod_impianto_est cod_manutentore]&caller=coimdocu-filter

    set return_url "coimdocu-list?$link_list"    
    
    ad_returnredirect $return_url
    ad_script_abort
}
 
ad_return_template
