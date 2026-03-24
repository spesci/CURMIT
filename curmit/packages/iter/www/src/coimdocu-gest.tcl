ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdocu"
    @author          Paolo Formizzi Adhoc
    @creation-date   11/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimdocu-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    ric01 18/11/2025 Punto 17 MEV regione Marche: gestione terzo numero di protocollo.

    rom02 30/08/2023 Napoli salva gli allegati sul file system cone Palermo e Regione Marche.

    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_stampa, data_notifica,
    but01            data_documento, data_prot_01, data_prot_02.

    rom01 31/01/2022 Palermo salva gli allegati sul file system come Regione Marche.

    sim01 07/03/2019 Se presente il path_file visualizzo il file presente sul file system

    san01 11/04/2017 Aggiunto gestione inserimento RCEE

} {
    {cod_documento      ""}
    {last_cod_documento ""}
    {funzione          "V"}
    {caller        "index"}
    {nome_funz          ""}
    {nome_funz_caller   ""}
    {extra_par          ""}
    {cod_impianto       ""}
    {url_aimp           ""}
    {url_list_aimp      ""}
    {cod_acts           ""}
    {last_cod_acts      ""}
    contenuto:trim,optional
    contenuto.tmpfile:tmpfile,optional
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



######## dobadd
set flag_manutentore [db_string query "select case when :id_utente_loggato_vero like 'MA%' then 's' else 'n' end"]
#ns_log notice "prova dob id_utente  $id_utente $id_utente_loggato_vero $flag_manutentore $flag_manutentore"
##### dobendadd

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCUGEST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCUGEST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-DOCUGEST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

if {$funzione == "C"} {
    set func_c func-sel
} else {
    set func_c func-menu
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
    "A" {set lvl 1}
    "C" {set lvl 4}
}

iter_get_coimtgen;#13/12/2013
########## dobagg
if {$flag_manutentore == "n"} {
    if {$funzione               eq "A" 
    &&  $coimtgen(flag_ente)    eq "C"
    &&  $coimtgen(denom_comune) eq "PADOVA"
    } {;#13/12/2013 Il servizio remoto di protocollazione può non fare login
	set id_utente "";#13/12/2013
    } else {;#13/12/2013
	set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
    };#13/12/2013
} else {
    set id_utente $id_utente_loggato_vero
}
########dobaggend



set current_date      [iter_set_sysdate]

# Controllo se il Database e' Oracle o Postgres
set id_db     [iter_get_parameter database]

set cancella_file "t"
if {$funzione == "A"} {

    #se presente il path vado a visualizzare il file sul file system
    if {[db_0or1row q "select path_file 
                            , tipo_contenuto
                         from coimdocu 
                        where cod_documento = :cod_documento
                          and path_file is not null"]} {#sim01


	set file_name $path_file
	set cancella_file "f"
    } else {#sim01

    
    set file_name [iter_set_spool_dir]/$id_utente-coimdocu-gest

    # estraggo il tipo allegato
    if {[db_0or1row sel_docu_tipo_contenuto ""] == 0 || [string is space $tipo_contenuto]} {
	iter_return_complaint "Documento non trovato"
	return 
    }

    if {$id_db == "postgres"} {
	db_0or1row       sel_docu_alle ""
    } else {
	db_blob_get_file sel_docu_alle "" -file $file_name
    }

    # scrivo su di un file l'allegato e poi lo spedisco al browser.
    # se facessi la select, non va bene perche' per alcuni tipi mi da'
    # un codice esadecimale, per altri (pdf) mi da' tutto il contenuto.
    # Non andrebbe bene nemmeno per i pdf perche' non riuscirei a mandarli
    # al browser

    };#sim01
    
    ns_returnfile 200 $tipo_contenuto $file_name
    if {$cancella_file eq "t"} {
	ns_unlink $file_name
    }
    ad_script_abort
    return
}

set link_gest [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller cod_acts last_cod_acts extra_par caller]

set link_del_alle [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller cod_acts last_cod_acts extra_par caller]

#set link_acts [export_url_vars cod_acts last_cod_acts cod_documento nome_funz_caller extra_par caller]&nome_funz=[iter_get_nomefunz "coimacts-gest"]
set link_acts ""
set link_list [export_url_vars nome_funz_caller caller extra_par url_aimp url_list_aimp last_cod_documento]&nome_funz=docu

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set flag_pote "N"
#if {$nome_funz_caller == [iter_get_nomefunz "coimacts-gest"]} {
#   set flag_pote "S"
#   set link_tab ""
#   set dett_tab ""
#} else {
switch $nome_funz_caller {
    "docu"        {set link_tab ""
	set dett_tab ""
    }
    "manutentori" {set link_tab ""
	set dett_tab ""
    }
    "impianti"    {set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
	set dett_tab [iter_tab_form $cod_impianto]
    }
    default        {set link_tab ""
	set dett_tab ""}
}

#if {$caller != "coimdocu-filter"
#&&  $nome_funz_caller != "docu-ins"
#} {
#    #proc per la navigazione 
#    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
#    set dett_tab [iter_tab_form $cod_impianto]
#} else {
#    set link_tab ""
#    set dett_tab ""
#}
#}

set data_corrente [iter_set_sysdate]

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_documento cod_acts last_cod_acts caller nome_funz_caller ]&[iter_set_url_vars $extra_par]&nome_funz=[iter_get_nomefunz "coimdocu-list"]}
set link_list        [subst $link_list_script]
set titolo           "documento"
switch $funzione {
    M {set button_label "Conferma modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma cancellazione"
	set page_title   "Cancella $titolo"}
    I {set button_label "Conferma inserimento"
	set page_title   "Inserisci $titolo"}
    V { if {$nome_funz_caller != "docu-ins"} {
	set button_label "Torna alla lista"
    } else {
	set button_label "Inserisci nuovo documento"
    }
	set page_title   "Visualizza $titolo"}
    C {set button_label "Conferma cancellazione"
	set page_title   "Cancella allegato $titolo"}
}

switch $nome_funz_caller {
    "docu"        {set context_bar [iter_context_bar -nome_funz $nome_funz_caller]}
    "manutentori" {set context_bar [iter_context_bar \
					[list "javascript:window.close()" "Chiudi finestra"] \
					"$page_title"]
    }
    "impianti"    {set context_bar [iter_context_bar \
					[list "javascript:window.close()" "Chiudi finestra"] \
					"$page_title"]
    }
    default       {set context_bar [iter_context_bar -nome_funz $nome_funz_caller]}
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimdocu"
set readonly_key "readonly"
set disabled_key "disabled"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set form_html    ""

set link_alle     "Visualizza allegato"
set link_del_alle "Cancella allegato"
# questa query, oltre a preparare i link serve per sapere se esiste un allegato
# durante la fase di modifica e di cancellazione (vedi tipo_contenuto_old)
if {[db_0or1row sel_docu_tipo_contenuto ""] == 1
    && ![string is space $tipo_contenuto]
} {
    set link_alle     "<a target=\"Visualizza Allegato\" href=\"coimdocu-gest?funzione=A&$link_gest\" class=func-menu>Visualizza Allegato</a>"
    set link_del_alle "<a href=\"coimdocu-gest?funzione=C&$link_gest\" class=$func_c>Cancella Allegato</a>"
    set tipo_contenuto_old $tipo_contenuto
    unset tipo_contenuto
} else {
    set tipo_contenuto_old ""
}

switch $funzione {
    "V" {
    }
    "I" {
        set onsubmit_cmd "enctype {multipart/form-data}"
	set readonly_key \{\}
        set disabled_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set link_alle "Visualizza allegato"
    }
    "M" {
        set onsubmit_cmd "enctype {multipart/form-data}"
	set readonly_fld \{\}
        set disabled_fld \{\}
    }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name tipo_documento \
    -label   "Tipo documento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtdoc tipo_documento descrizione ] \

element create $form_name tipo_soggetto \
    -label   "Tipo soggetto" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Cittadino C} {Distributore D} {Manutentore M} {Tecnico T}}

element create $form_name cod_soggetto \
    -label   "Cod.sog." \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_stampa, data_notifica, data_documento, data_prot_01, data_prot_02.
element create $form_name data_stampa \
    -label   "Data stampa" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_notifica \
    -label   "Data notifica" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_documento \
    -label   "Data documento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_prot_01 \
    -label   "Data prot.1" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name protocollo_01 \
    -label   "Protocollo 1" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_prot_02 \
    -label   "Data prot. 2" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name protocollo_02 \
    -label   "Protocollo 2" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

#ric01 aggiunta data_prot_03, protocollo_03
element create $form_name data_prot_03 \
    -label   "Data prot. 2" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name protocollo_03 \
    -label   "Protocollo 2" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_notifica \
    -label   "Flag notifica" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Attesa W} {Acc./Consegnata A} {Rifiutata R} {ErratoDest E} {IndirErrato 1} {CompiutaGiac 2} {Deceduto 3} {Sconosciuto 4} {Trasferito 5}}

element create $form_name contenuto \
    -label   "Contenuto" \
    -widget   file \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name descrizione \
    -label   "Descrizione" \
    -widget   text \
    -datatype text \
    -html    "size 50 maxlength 50 $readonly_fld {} class form_element" \
    -optional

element create $form_name note \
    -label   "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
    -optional

if {$caller == "coimdocu-filter"
    ||  $nome_funz_caller == "docu-ins"
} {
    element create $form_name cod_impianto_est \
	-label   "codice impianto" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_key {} class form_element" \
	-optional
}

element create $form_name cod_documento -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name cod_acts  -widget hidden -datatype text -optional
element create $form_name last_cod_acts -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_documento -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name cod_acts         -value $cod_acts
    element set_properties $form_name last_cod_acts    -value $last_cod_acts
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp
    element set_properties $form_name last_cod_documento -value $last_cod_documento

    if {$funzione == "I"} {
        
    } else {
	# leggo riga
        if {[db_0or1row sel_docu {}] == 0} {
            iter_return_complaint "Record non trovato"
	}
	if {[db_0or1row sel_aimp_cod_est ""] == 0} {
	    set cod_impianto_est ""
	}

        element set_properties $form_name cod_documento  -value $cod_documento
        element set_properties $form_name tipo_documento -value $tipo_documento
        element set_properties $form_name data_stampa    -value $data_stampa
        element set_properties $form_name data_documento -value $data_documento
        element set_properties $form_name data_prot_01   -value $data_prot_01
        element set_properties $form_name protocollo_01  -value $protocollo_01
        element set_properties $form_name data_prot_02   -value $data_prot_02
        element set_properties $form_name protocollo_02  -value $protocollo_02
        element set_properties $form_name flag_notifica  -value $flag_notifica
        element set_properties $form_name descrizione    -value $descrizione
        element set_properties $form_name note           -value $note
	element set_properties $form_name data_notifica  -value $data_notifica
	if {$caller == "coimdocu-filter"
	    ||  $nome_funz_caller == "docu-ins"
	} {
	    element set_properties $form_name cod_impianto_est -value $cod_impianto_est
	}
	element set_properties $form_name data_prot_03   -value $data_prot_03;#ric01
	element set_properties $form_name protocollo_03  -value $protocollo_03;#ric01

    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_documento  [element::get_value $form_name cod_documento]
    set tipo_documento [element::get_value $form_name tipo_documento]
    set data_stampa    [element::get_value $form_name data_stampa]
    set data_documento [element::get_value $form_name data_documento]
    set data_prot_01   [element::get_value $form_name data_prot_01]
    set protocollo_01  [element::get_value $form_name protocollo_01]
    set data_prot_02   [element::get_value $form_name data_prot_02]
    set protocollo_02  [element::get_value $form_name protocollo_02]
    set flag_notifica  [element::get_value $form_name flag_notifica]
    set data_notifica  [element::get_value $form_name data_notifica]
    set data_prot_03   [element::get_value $form_name data_prot_03];#ric01
    set protocollo_03  [element::get_value $form_name protocollo_03];#ric01
    if {$funzione == "I"
	||  $funzione == "M"
    } {
	set contenuto  [element::get_value $form_name contenuto]
    }
    set descrizione    [element::get_value $form_name descrizione]
    set note           [element::get_value $form_name note]
    if {$funzione == "I"
	&& ($caller == "coimdocu-filter"
	    ||  $nome_funz_caller == "docu-ins")
    } {
	set cod_impianto_est [element::get_value $form_name cod_impianto_est]
    }

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {$funzione == "I"
	&&  ($caller == "coimdocu-filter"
	     ||   $nome_funz_caller == "docu-ins")
    } {
	if {![string equal $cod_impianto_est ""]} {
	    if {[db_0or1row sel_aimp_cod ""] == 0} {
		element::set_error $form_name cod_impianto_est "Impianto inesistente"
		incr error_num
	    }
	}
    }

    if {$funzione == "I"
	||  $funzione == "M"
    } {

	# in inserimento vado a valorizzare in automatico il campo cod soggetto
        # con il codice del responsabile dell'impianto e tipo soggetto con "C"
	if {$funzione == "I"
	    && ![string equal $cod_impianto ""]
	} {
	    set tipo_soggetto "C"
	    if {[db_0or1row sel_aimp_resp ""] == 0} {
		set cod_soggetto ""
	    }
	} else {
	    set tipo_soggetto ""
            set cod_soggetto  ""
	}

	# cotrollo tipo documento
        if {[string equal $tipo_documento ""]} {
            element::set_error $form_name tipo_documento "Inserire Tipo documento"
            incr error_num
        }

######### dobadd
        if {$flag_manutentore == "s" && $tipo_documento != "XU"} {
            element::set_error $form_name tipo_documento "Per il manutentore ammesso solo Allegati Art.284"
            incr error_num
        }
######## dobendadd
        if {![string equal $data_stampa ""]} {
            set data_stampa [iter_check_date $data_stampa]
            if {$data_stampa == 0} {
                element::set_error $form_name data_stampa "Data non corretta"
                incr error_num
            } else {
		if {$data_stampa > $current_date} {
		    element::set_error $form_name data_stampa "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {[string equal $data_documento ""]} {
            element::set_error $form_name data_documento "Inserire Data documento"
            incr error_num
        } else {
            set data_documento [iter_check_date $data_documento]
            if {$data_documento == 0} {
                element::set_error $form_name data_documento "Data non corretta"
                incr error_num
            } else {
		if {$data_documento > $current_date} {
		    element::set_error $form_name data_documento "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $data_prot_01 ""]} {
            set data_prot_01 [iter_check_date $data_prot_01]
            if {$data_prot_01 == 0} {
                element::set_error $form_name data_prot_01 "Data non corretta"
                incr error_num
            } else {
		if {$data_prot_01 > $current_date} {
		    element::set_error $form_name data_prot_01  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $data_prot_02 ""]} {
            set data_prot_02 [iter_check_date $data_prot_02]
            if {$data_prot_02 == 0} {
                element::set_error $form_name data_prot_02 "Data non corretta"
                incr error_num
            } else {
		if {$data_prot_02 > $current_date} {
		    element::set_error $form_name data_prot_02  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

	if {![string equal $data_prot_03 ""]} {
	    set data_prot_03 [iter_check_date $data_prot_03]
	    if {$data_prot_03 == 0} {
		element::set_error $form_name data_prot_03 "Data non corretta"
		incr error_num
	    } else {
		if {$data_prot_03 > $current_date} {
		    element::set_error $form_name data_prot_03  "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	}
	
	if {$flag_notifica == "S"} {
	    if {[string equal $data_notifica ""]} {
                element::set_error $form_name data_notifica "Inserire Data notifica"
                incr error_num
	    }
	}
	if {![string equal $data_notifica ""]} {
	    set data_notifica [iter_check_date $data_notifica]
	    if {$data_notifica == 0} {
		element::set_error $form_name data_notifica "Data non corretta"
		incr error_num
	    } else {
		if {$data_notifica > $current_date} {
		    element::set_error $form_name data_notifica  "Data deve essere anteriore alla data odierna"
		    incr error_num
		} else {
		    db_foreach sel_cimp "" {
			if {[string equal $flag_uso "S"]} {
			    db_foreach sel_anom "" {
				if {[db_0or1row sel_tano_gg_adattamento ""]== 0} {
				    set gg_adattamento 0
				} else {
				    if {![string is digit $gg_adattamento]||[string equal $gg_adattamento ""]} {
					set gg_adattamento 0
				    }
				}
				db_dml dml_sql1 [db_map upd_anom]
			    }
			}
		    }
		}
	    }
	}	

        if {![info exists contenuto]
	    ||   [string is space $contenuto]
	} {
            set sw_contenuto_exists "f"
	} else {
            set sw_contenuto_exists "t"
            if {[file size ${contenuto.tmpfile}] == 0} {
                element::set_error $form_name contenuto "File non esistente oppure vuoto"
                incr error_num
	    }
        }

	# controlli per tipo documento = modello H
	if {$tipo_documento == "MH"} {
	    # obbligo l'inserimento del codice impianto 
	    if {[string equal $cod_impianto ""]} {
		element::set_error $form_name cod_impianto_est "Inserire il codice impianto"
		incr error_num
	    }
	    # verifico che non sia già presente un modello h per l'anno corrente
	    set anno_doc [string range $data_documento 0 3]  
	    db_0or1row sel_check_modh ""
	    if {![string equal $cod_impianto ""]
		&&  ![string equal data_documento ""]
		&&  $conta_mh > 0
	    } {
		element::set_error $form_name tipo_documento "E' gi&agrave; esistente una dichiarazione per questo impianto in questa data"
		incr error_num
	    }
	}

    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {
	    db_1row sel_docu_next ""
	    set dml_sql [db_map ins_docu]
	    if {$tipo_documento == "MH"} {
		db_1row sel_dual_cod_dimp ""
	        set dml_aimp [db_map upd_aimp]
		set dml_dimp [db_map ins_dimp]
	    }
	    if {$tipo_documento == "RC"} {;#san01 if e suo contenuto
		db_1row sel_dual_cod_dimp ""
	        set dml_aimp [db_map upd_aimp]
		set dml_dimp [db_map ins_dimpr]
	    }

	}
        M {
	    set dml_sql [db_map upd_docu]
	    if {$id_db == "postgres"
		&& $sw_contenuto_exists == "t"
		&& ![string equal $tipo_contenuto_old ""]
	    } {
		# su postgres se modifico un allegato
		# devo prima cancellare quello vecchio
		# con select lo_unlink + update per mettere null nell'oid
		set dml_sel_alle [db_map sel_docu_del_alle]
		set dml_del_alle [db_map upd_docu_del_alle]
	    }
	}
        D {
	    set dml_sql [db_map del_docu]
	    if {$id_db == "postgres"
		&& ![string equal $tipo_contenuto_old ""]
	    } {
		# su postgres devo prima cancellare quello vecchio
		# con select lo_unlink + update per mettere null nell'oid
		set dml_sel_alle [db_map sel_docu_del_alle]
		set dml_del_alle [db_map upd_docu_del_alle]
	    }
	}
        C {

	    #se presente il path vado a visualizzare il file sul file system
	    if {[db_0or1row q "select path_file 
                            , tipo_contenuto
                         from coimdocu 
                        where cod_documento = :cod_documento
                          and path_file is not null"]} {#sim01 if e suo contenuto

		if {[file exists $path_file]} {
		    ns_unlink $path_file
		}
		
		db_dml q "update coimdocu
		             set tipo_contenuto = null
		               , path_file      = null
		           where cod_documento  = :cod_documento" 
		
	    } else {#sim01


	    
	    # funzione di cancellazione allegato.
	    # solo per postgres devo far select lo_unlunk
	    if {$id_db == "postgres"} {
		set dml_sel_alle [db_map sel_docu_del_alle]
	    }
	    set dml_sql [db_map upd_docu_del_alle]
	};#sim01
	}
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
		# sel_alle contiente la lo_unlink usata solo per postgres
		if {[info exists dml_sel_alle]} {
		    db_0or1row dml_sel_alle $dml_sel_alle
		}
		# del_alle contiene l'update per mettere null nell'oid (postgr)
		if {[info exists dml_del_alle]} {
		    db_dml dml_del_alle $dml_del_alle
		}

		# effettuo l'inserimento, la modifica o la cancellazione
		db_dml dml_coimdocu $dml_sql

		# inserisco l'eventuale allegato
		if {($funzione == "I"
		     ||   $funzione == "M")
		    &&   $sw_contenuto_exists == "t"
		} {

		    set contenuto_tmpfile  ${contenuto.tmpfile}
		    exec chmod 775 $contenuto_tmpfile
		    set tipo_contenuto     [ns_guesstype $contenuto]

		    #rom01 Aggiuna comdizione per Palermo
		    #rom02 Modificata condizione di rom01 per Napoli
		    if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) in [list "PPA" "PNA"]} {#sim01 if e suo contenuto

			set nome_file_originale  [lindex $contenuto 0]			

			set path_file [iter_permanenti_file_salva $contenuto_tmpfile $nome_file_originale]
			
			db_dml q "update coimdocu
		  	             set tipo_contenuto = :tipo_contenuto
			               , path_file      = :path_file
			           where cod_documento  = :cod_documento"
			
		    } else {#sim01
		    
			if {$id_db == "postgres"} {
			    db_dml dml_ins_alle [db_map upd_docu_ins_alle]
			} else {
			    db_dml dml_ins_alle [db_map upd_docu_ins_alle] -blob_files [list $contenuto_tmpfile]
			}

		    };#sim01
		}

		if {[info exists dml_aimp]} {
		    db_dml dml_aimp $dml_aimp
		}
		if {[info exists dml_dimp]} {
		    db_dml dml_dimp $dml_dimp
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
    if {$funzione == "I"} {
        set last_cod_documento $cod_documento
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller cod_acts last_cod_acts extra_par caller]
    
    set link_del_alle  [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller cod_acts last_cod_acts extra_par caller]
    switch $funzione {
        M {set return_url   "coimdocu-gest?funzione=V&$link_gest"}
        D {set return_url   "coimdocu-list?$link_list"}
        I {set return_url   "coimdocu-gest?funzione=V&$link_gest"}
        V { if {$nome_funz_caller != "docu-ins"} {
	    set return_url   "coimdocu-list?$link_list"
	} else {
	    set return_url   "coimdocu-gest?funzione=I&nome_funz=$nome_funz"
	}
	}
        C {set return_url   "coimdocu-gest?funzione=V&$link_gest"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
