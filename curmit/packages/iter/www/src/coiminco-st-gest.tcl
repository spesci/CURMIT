ad_page_contract {
    Gestione         form per la tabella "coiminco"
    @author          Mortoni Nicola/Formizzi Paolo
    @creation-date   19/08/2004

    @param funzione  D=Delete  V=View
                     A=Assegna C=Conferma E=Effettua N=Annulla

    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coiminco-st-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ====================================================================================================
    rom01 27/03/2023 Commentata la variabile dett_tab perche' non viene usata nell'adp e fa andare in errore il programma.

} {
    
    {st_progressivo   ""}
    {cod_inco         ""}
    {last_cod_inco    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {extra_par_inco   ""}
    {flag_aimp        ""}
    {cod_impianto     ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


# Controlla lo user
switch $funzione {
    "V"     {set lvl 1}
    "D"     {set lvl 4}
    default {set lvl 3}
}

set id_utente    [lindex [iter_check_login $lvl $nome_funz] 1]
set current_date [iter_set_sysdate]

if {![string equal $extra_par_inco ""]} {
    set extra_par $extra_par_inco
}

iter_get_coimtgen
set sigla_prov    $coimtgen(sigla_prov)
set flag_ente     $coimtgen(flag_ente)

set cod_enve   [iter_check_uten_enve $id_utente]
set cod_tecn   [iter_check_uten_opve $id_utente]

if {![string equal $cod_enve ""]} {
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}

if {![string equal $cod_tecn ""]} {
    set flag_cod_tecn "t"  
} else {
    set flag_cod_tecn "f"
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

#set dett_tab [iter_tab_form $cod_impianto]
if {$flag_aimp == "S"} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
} else {
    set link_inco [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz $funzione $extra_par]
}


if {$flag_aimp != "S"} {
    # preparo il parametro da passare agli impianti (coimaimp-gest)
    # contenente la url necessaria per ritornare a questo programma
    set url_list_aimp2 [list [ad_conn url]?[export_ns_set_vars url "url_list_aimp"]]
}
if {$flag_cod_tecn == "t"
||  $flag_cod_enve == "t"
} {
    set link_aimp "nome_funz=impianti-ver&[export_url_vars nome_funz_caller cod_impianto url_list_aimp2]"
} else { 
    set link_aimp "nome_funz=impianti&[export_url_vars nome_funz_caller cod_impianto url_list_aimp2]"
}

# Personalizzo la pagina
# link_gest e' usato dall'adp per richiamare questo programma con funz diverse
set link_gest         [export_url_vars nome_funz cod_inco last_cod_inco nome_funz_caller extra_par caller flag_aimp cod_impianto url_aimp url_list_aimp]
set link_list_script {[export_url_vars last_cod_inco cod_inco caller nome_funz_caller nome_funz flag_aimp cod_impianto url_aimp url_list_aimp]&[iter_set_url_vars $extra_par]}
set link_list         [subst $link_list_script]
set titolo           "appuntamento"

switch $funzione {
    V {set button_label "Torna alla lista"
       set page_title   "Visualizzazione $titolo"}
    D {set button_label "Conferma Cancellazione"
       set page_title   "Cancellazione $titolo"}
    A {set button_label "Conferma Assegnazione"
       set page_title   "Assegnazione $titolo"}
    C {set button_label "Conferma"
       set page_title   "Conferma $titolo"}
    E {set button_label "Conferma Effettuazione"
       set page_title   "Effettuazione $titolo"}
    N {set button_label "Conferma Annullamento"
       set page_title   "Annullamento $titolo"}
}


set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name     "coiminco"
set readonly_fld  "readonly"
set disabled_fld  "disabled"
set readonly_ace  "readonly"
set disabled_ace  "disabled"
set onsubmit_cmd  ""
switch $funzione {
    "A" {
	set readonly_fld \{\}
	set readonly_ace \{\}
	set disabled_ace \{\}
	set disabled_fld \{\}
    }
    "C" {
	set readonly_fld \{\}
	set readonly_ace \{\}
	set disabled_ace \{\}
	set disabled_fld \{\}
    }
    "E" {
	set readonly_fld \{\}
	set readonly_ace \{\}
	set disabled_ace \{\}
	set disabled_fld \{\}
    }
    "N" {
	set readonly_fld \{\}
	set disabled_fld \{\}
    }
}

set disabled_ace_enve $disabled_ace
set readonly_ace_tecn $readonly_ace
if {$flag_cod_enve == "t"
||  $flag_cod_tecn == "t"
} {
  # disabilito ente verificatore se utente e' ente o tecnico verificatore
    set disabled_ace_enve "disabled"
}
if {$flag_cod_tecn == "t"} {
  # disabilito tecnico verificatore se utente e' tecnico verificatore
    set readonly_ace_tecn "readonly"
}

form create $form_name \
-html    $onsubmit_cmd

element create $form_name cod_inco \
-label   "Codice" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 readonly {} class form_element" \
-optional

element create $form_name des_stato \
-label   "Stato" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 50 readonly {} class form_element" \
-optional

element create $form_name desc_camp \
-label   "Campagna" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 50 readonly {} class form_element" \
-optional

element create $form_name tipo_estrazione \
-label   "Tipo Estrazione" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 50 readonly {} class form_element" \
-optional

element create $form_name data_estrazione \
-label   "Data estrazione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 readonly {} class form_element" \
-optional

element create $form_name data_assegn \
-label   "Data assegnazione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 readonly {} class form_element" \
-optional

if {$disabled_ace_enve != "disabled"} {
    element create $form_name cod_enve \
    -label   "Ente verificatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_ace_enve {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimenve cod_enve substr(ragione_01,1,20) ragione_01]
} else {
    element create $form_name cod_enve -widget hidden -datatype text -optional
    element create $form_name desc_enve \
    -label   "Ente verificatore" \
    -widget   text \
    -datatype text \
    -html    "size 20 readonly {} class form_element" \
    -optional 
}

element create $form_name cog_tecn \
-label   "Cognome tecnico" \
-widget   text \
-datatype text \
-html    "$readonly_ace_tecn {} size 15 maxlength 40 class form_element" \
-optional 

element create $form_name nom_tecn \
-label   "Nome tecnico" \
-widget   text \
-datatype text \
-html    "$readonly_ace_tecn {} size 15 maxlength 40 class form_element" \
-optional 

if {$readonly_ace_tecn != "readonly"} {
    if {$flag_ente  == "P"
    &&  $sigla_prov == "LI"
    } { 
	set cerca_opve [iter_search $form_name coimopve-disp-list [list cod_enve cod_enve cod_opve cod_opve cognome nom_tecn nome cog_tecn data_verifica data_verifica ora_verifica ora_verifica  cod_inco cod_inco]]

#[list cod_enve cod_opve nome cognome data_verifica ora_verifica ]

    } else {
	set cerca_opve [iter_search $form_name coimopve-list [list cod_enve cod_enve dummy cod_opve dummy nom_tecn dummy cog_tecn]]
    }
} else {
    set cerca_opve ""
}

element create $form_name data_verifica \
-label   "Data appuntamento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_ace {} class form_element" \
-optional

element create $form_name ora_verifica \
-label   "Ora appuntamento" \
-widget   text \
-datatype text \
-html    "size 05 maxlength 05 $readonly_ace {} class form_element" \
-optional

element create $form_name data_avviso_01 \
-label   "Data avviso di verifica" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 readonly {} class form_element" \
-optional

element create $form_name data_avviso_02 \
-label   "Data stampa esito" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 readonly {} class form_element" \
-optional

element create $form_name cod_noin \
-label   "Anomalia" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimnoin cod_noin descr_noin]

# definisco la routine che prepara il link alla visualizzazione avviso
set prep_link_alle {
    # preparo il link solo se cod_documento e' valorizzato e solo
    # se il record di coimdocu esiste ancora e se l'allegato non e'
    # stato cancellato.
    set cod_documento $cod_documento_01
    if {![string is space $cod_documento_01]
    &&   [db_0or1row sel_docu ""] == 1
    } {
	set link_docu [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp nome_funz_caller]&nome_funz=docu
	set link_alle_stav "<a target=\"Visualizza Avviso di ispezione\" href=\"coimdocu-gest?funzione=A&$link_docu\">Visualizza Avviso di ispezione<a>"
    } else {
	set link_alle_stav "&nbsp;"
    }

    set cod_documento $cod_documento_02
    if {![string is space $cod_documento_02]
    &&   [db_0or1row sel_docu ""] == 1
    } {
	set link_docu [export_url_vars cod_documento cod_impianto url_aimp url_list_aimp nome_funz_caller]&nome_funz=docu
	set link_alle_stev "<a target=\"Visualizza Stampa esito\" href=\"coimdocu-gest?funzione=A&$link_docu\">Visualizza Stampa esito<a>"
    } else {
	set link_alle_stev "&nbsp;"
    }
}

element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 02 $readonly_fld {} class form_element" \
-optional

element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name stato         -widget hidden -datatype text -optional
element create $form_name cod_opve      -widget hidden -datatype text -optional
element create $form_name cod_documento_01 -widget hidden -datatype text -optional
element create $form_name cod_documento_02 -widget hidden -datatype text -optional
element create $form_name flag_aimp     -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_inco -widget hidden -datatype text -optional
element create $form_name cod_cinc      -widget hidden -datatype text -optional
element create $form_name cod_opve_old  -widget hidden -datatype text -optional
element create $form_name data_verifica_old  -widget hidden -datatype text -optional
element create $form_name ora_verifica_old  -widget hidden -datatype text -optional
element create $form_name stato_old     -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name flag_aimp     -value $flag_aimp
    element set_properties $form_name cod_impianto  -value $cod_impianto
    element set_properties $form_name url_aimp      -value $url_aimp
    element set_properties $form_name url_list_aimp -value $url_list_aimp
    element set_properties $form_name last_cod_inco -value $last_cod_inco

    if {$flag_ente  == "P"
    &&  $sigla_prov == "TN"
    &&  $funzione == "V"
    } {
	db_1row sel_comune ""
	db_1row sel_effettivi ""
	db_1row sel_riserve ""
    }

    # leggo riga
    if {[db_0or1row sel_inco {}] == 0} {
	iter_return_complaint "Appuntamento non trovato"
    } else {
	element set_properties $form_name cod_cinc -value $cod_cinc
    }

    if {[db_0or1row sel_cinc {}] == 0} {
	iter_return_complaint "Campagna non trovata"
    }

    if {[db_0or1row sel_opve ""] == 0} {
	set cog_tecn ""
	set nom_tecn ""
	set cod_enve ""
    }

#if {$flag_ente  == "P"
#&&  $sigla_prov == "TN"
#} {
#    switch $tipo_estrazione {
#	"1" {set tipo_estrazione "Impianti < 35kW con contratto (5%)"}
#	"2" {set tipo_estrazione "Impianti > 35kW con contratto"}
#	"3" {set tipo_estrazione "Impianti senza contratto"}
#	"4" {set tipo_estrazione "Impianti da definire"}
#    }
#} else {
#    switch $tipo_estrazione {
#	"1" {set tipo_estrazione "Impianti < 35kW dichiarati (5%)"}
#        "2" {set tipo_estrazione "Impianti < 35kW dichiarati (mod.H scad.)"}
#        "3" {set tipo_estrazione "Impianti > 35kW dichiarati"}
#        "4" {set tipo_estrazione "Impianti non dichiarati"}
#        "6" {set tipo_estrazione "Singolo impianto"}
#    }
#}

    db_1row sel_tpes ""
    set tipo_estrazione $descr_tpes

    element set_properties $form_name cod_inco         -value $cod_inco
    element set_properties $form_name stato            -value $stato
    element set_properties $form_name stato_old        -value $stato
    element set_properties $form_name des_stato        -value $des_stato
    element set_properties $form_name desc_camp        -value $desc_camp
    element set_properties $form_name tipo_estrazione  -value $tipo_estrazione
    element set_properties $form_name data_estrazione  -value $data_estrazione
    element set_properties $form_name data_assegn      -value $data_assegn
    element set_properties $form_name cod_opve         -value $cod_opve
    element set_properties $form_name cod_opve_old     -value $cod_opve
    element set_properties $form_name cog_tecn         -value $cog_tecn
    element set_properties $form_name nom_tecn         -value $nom_tecn
    element set_properties $form_name data_verifica    -value $data_verifica
    element set_properties $form_name data_verifica_old -value $data_verifica
    element set_properties $form_name ora_verifica     -value $ora_verifica
    element set_properties $form_name ora_verifica_old -value $ora_verifica
    element set_properties $form_name data_avviso_01   -value $data_avviso_01
    element set_properties $form_name cod_documento_01 -value $cod_documento_01
    element set_properties $form_name data_avviso_02   -value $data_avviso_02
    element set_properties $form_name cod_documento_02 -value $cod_documento_02
    element set_properties $form_name note             -value $note
    element set_properties $form_name cod_enve         -value $cod_enve
    element set_properties $form_name cod_noin         -value $cod_noin
    if {$disabled_ace_enve == "disabled"} {
	if {[db_0or1row sel_ragione_enve ""] == 0} {
	    set ragione_01 ""
	}
	element set_properties $form_name desc_enve -value $ragione_01
    }
    # eseguo la routine che prepara il link alla visualizzazione avviso
    eval $prep_link_alle
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system
    set cod_inco          [element::get_value $form_name cod_inco]
    set stato             [element::get_value $form_name stato]
    set des_stato         [element::get_value $form_name des_stato]
    set desc_camp         [element::get_value $form_name desc_camp]
    set tipo_estrazione   [element::get_value $form_name tipo_estrazione]
    set data_estrazione   [element::get_value $form_name data_estrazione]
    set data_assegn       [element::get_value $form_name data_assegn]

    set cod_opve          [element::get_value $form_name cod_opve]
    set cog_tecn          [element::get_value $form_name cog_tecn]
    set nom_tecn          [element::get_value $form_name nom_tecn]
    set data_verifica     [element::get_value $form_name data_verifica]
    set ora_verifica      [element::get_value $form_name ora_verifica]
    set data_avviso_01    [element::get_value $form_name data_avviso_01]
    set cod_documento_01  [element::get_value $form_name cod_documento_01]
    set data_avviso_02    [element::get_value $form_name data_avviso_02]
    set cod_documento_02  [element::get_value $form_name cod_documento_02]
    set note              [element::get_value $form_name note]
    set cod_cinc          [element::get_value $form_name cod_cinc]
    set cod_opve_old      [element::get_value $form_name cod_opve_old]
    set stato_old         [element::get_value $form_name stato_old]
    set data_verifica_old [element::get_value $form_name data_verifica_old]
    set ora_verifica_old  [element::get_value $form_name ora_verifica_old]
    set cod_noin          [element::get_value $form_name cod_noin]


    if {$flag_cod_enve == "f"
    &&  $flag_cod_tecn == "f"
    } {
	set cod_enve          [element::get_value $form_name cod_enve]
    } else {
	if {$flag_cod_enve == "t"} {
	    set cod_enve   [iter_check_uten_enve $id_utente]
	} 
	if {$flag_cod_tecn == "t"} {
	    if {[db_0or1row sel_cod_enve ""] == 0} {
		set cod_enve ""
	    }
	}
    }
    # eseguo la routine che prepara il link alla visualizzazione avviso
    eval $prep_link_alle

    if {[db_0or1row sel_cinc {}] == 0} {
	iter_return_complaint "Campagna non trovata"
    }
  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione != "D"
    &&  $funzione != "V"
    } {
	# routine generica per controllo codice tecnico
	set check_cod_opve {
	    set chk_out_rc       0
	    set chk_out_msg      ""
	    set chk_out_cod_opve ""
	    set ctr_opve         0
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
	    db_foreach sel_opve_nom "" {
		incr ctr_opve
		if {$cod_opve_db == $chk_inp_cod_opve} {
		    set chk_out_cod_opve $cod_opve_db
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_opve {
		0 { set chk_out_msg "Tecnico non trovato"}
		1 { set chk_out_cod_opve $cod_opve_db
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; tecnici: usa il link cerca"
		    }
		}
	    }
	}
	
	# inizio vero e proprio dei controlli

	# controlli per le funzioni di assegnazione, conferma ed effettuazione
	if {$funzione == "A"
	||  $funzione == "C"
	||  $funzione == "E"
	} {

	    # se (ri)assegno un incontro precedentemente annullato
            # svuoto il cod_documento_01 per mantenere lo storico degli avvisi
	    if {$funzione == "A"} {
		if {$stato == "5"} {
		    set cod_documento_01 ""
		}
	    }

	    # giro la data assegnazione, e' readonly
	    if {![string equal $data_assegn ""]} {
		set data_assegn [iter_check_date $data_assegn]
		if {$data_assegn == 0} {
		    element::set_error $form_name data_assegn "Data non corretta"
		    incr error_num
		}
	    }

	    # giro la data stampa avviso
	    if {![string equal $data_avviso_01 ""]} {
		set data_avviso_01 [iter_check_date $data_avviso_01]
		if {$data_avviso_01 == 0} {
		    element::set_error $form_name data_avviso_01 "Data non corretta"
		    incr error_num
		}
	    }

	    # giro la data stampa esito
	    if {![string equal $data_avviso_02 ""]} {
		set data_avviso_02 [iter_check_date $data_avviso_02]
		if {$data_avviso_02 == 0} {
		    element::set_error $form_name data_avviso_02 "Data non corretta"
		    incr error_num
		}
	    }

	    if {[string equal $cod_enve ""]} {
                element::set_error $form_name cod_enve "Inserire ente verificatore"
                incr error_num
            } else {
		if {[string equal $cog_tecn ""]
		&&  [string equal $nom_tecn ""]
		} {
		    set cod_opve "$cod_enve"
                    append cod_opve "000"
		} else {
		    set chk_inp_cod_opve $cod_opve
		    set chk_inp_cognome  $cog_tecn
		    set chk_inp_nome     $nom_tecn
		    eval $check_cod_opve
		    set cod_opve  $chk_out_cod_opve
		    if {$chk_out_rc == 0} {
			element::set_error $form_name cog_tecn $chk_out_msg
			incr error_num
		    }
		}
	    }

	    if {[string equal $data_verifica ""]} {
		# personalizzazione per provincia di mantova: lascio la 
                # possibilita' di non inserire la data dell'appuntamento
		if {$flag_ente  != "P"
		&&  $sigla_prov != "MN"
		} {
		    element::set_error $form_name data_verifica "Inserire data appuntamento"
		    incr error_num
		} else {
		    if {$funzione == "E"} {
			element::set_error $form_name data_verifica "Inserire data appuntamento"
			incr error_num
		    }
		}
            } else {
		set data_verifica [iter_check_date $data_verifica]
		if {$data_verifica == 0} {
		    element::set_error $form_name data_verifica "Data non corretta"
		    incr error_num
		} else {
		    if {$data_verifica < $dt_inizio_cinc
                    ||  $data_verifica > $dt_fine_cinc
		    } {
			element::set_error $form_name data_verifica "Data non compresa nella campagna"
			incr error_num
		    }
		}
	    }

	    if {![string equal $ora_verifica ""]} {
		set ora_verifica [iter_check_time $ora_verifica]
		if {$ora_verifica == 0} {
		    element::set_error $form_name ora_verifica "Ora non corretta, deve essere hh:mm"
		    incr error_num
		}
	    }
	}
    }

    if {$funzione == "N"} {
	if {[string equal $note ""]
	 && [string equal $cod_noin ""]} {
	    element::set_error $form_name note "Inserire le note o i motivi di annullamento"
	    incr error_num
	}
	# giro la data assegnazione, e' readonly
	if {![string equal $data_assegn ""]} {
	    set data_assegn [iter_check_date $data_assegn]
	    if {$data_assegn == 0} {
		element::set_error $form_name data_assegn "Data non corretta"
		incr error_num
	    }
	}
	if {![string equal $data_verifica ""]} {
	    set data_verifica [iter_check_date $data_verifica]
	    if {$data_assegn == 0} {
		element::set_error $form_name data_verifica "Data non corretta"
		incr error_num
	    }
	}

	if {![string equal $data_avviso_01 ""]} {
	    set data_avviso_01 [iter_check_date $data_avviso_01]
	    if {$data_avviso_01 == 0} {
		element::set_error $form_name data_avviso_01 "Data non corretta"
		incr error_num
	    }
	}
	if {![string equal $data_avviso_02 ""]} {
	    set data_avviso_02 [iter_check_date $data_avviso_02]
	    if {$data_avviso_02 == 0} {
		element::set_error $form_name data_avviso_02 "Data non corretta"
		incr error_num
	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        D {
	    set dml_sql [db_map del_inco]
	}
        A {
	    set data_assegn $current_date
	    set stato   "2"
	    set dml_sql [db_map upd_inco]
	    # elimino la disponibilita' del verificatore
	    if {[db_0or1row sel_inco_disp ""] == 1} {
		set dml_del_disp [db_map del_disp]
	    }
	    # se lo stato dell'incontro e' diverso da 5 (annullato) vado 
            # a ricreare la disponibilita' del vecchio verificatore, perche'
            # in questo caso sarei in una riassegnazione. se invece lo stato 
            # era annullato, la disponibilita' era gia' stata ricreata.
	    if {$stato_old != "5"} {
		if {$cod_opve_old      != $cod_opve
		&&  $data_verifica_old != $data_verifica
                &&  $ora_verifica_old  != $ora_verifica
		} {
   		    set data_verifica_old [iter_check_date $data_verifica_old]
		    if {[db_0or1row sel_opdi_fascia ""] == 1} {
			db_1row sel_cod_inco_dual ""
			set dml_crea_disp [db_map crea_disp]
		    }
		}
	    }
	}
        C {
	    set stato   "4"
	    set dml_sql [db_map upd_inco]
	    set dml_sql [db_map upd_inco]
	    # elimino la disponibilita' del verificatore
	    if {[db_0or1row sel_inco_disp ""] == 1} {
		set dml_del_disp [db_map del_disp]
	    }
	    # se lo stato dell'incontro e' diverso da 5 (annullato) vado 
            # a ricreare la disponibilita' del vecchio verificatore, perche'
            # in questo caso sarei in una riassegnazione. se invece lo stato 
            # era annullato, la disponibilita' era gia' stata ricreata.
	    if {$stato_old != "5"} {
		if {$cod_opve_old      != $cod_opve
		&&  $data_verifica_old != $data_verifica
                &&  $ora_verifica_old  != $ora_verifica
		} {
   		    set data_verifica_old [iter_check_date $data_verifica_old]
		    if {[db_0or1row sel_opdi_fascia ""] == 1} {
			db_1row sel_cod_inco_dual ""
			set dml_crea_disp [db_map crea_disp]
		    }
		}
	    }
	}
        E {
	    set stato   "8"
	    set dml_sql [db_map upd_inco]
	    set dml_sql [db_map upd_inco]
	    # elimino la disponibilita' del verificatore
	    if {[db_0or1row sel_inco_disp ""] == 1} {
		set dml_del_disp [db_map del_disp]
	    }
	    # se lo stato dell'incontro e' diverso da 5 (annullato) vado 
            # a ricreare la disponibilita' del vecchio verificatore, perche'
            # in questo caso sarei in una riassegnazione. se invece lo stato 
            # era annullato, la disponibilita' era gia' stata ricreata.
	    if {$stato_old != "5"} {
		if {$cod_opve_old      != $cod_opve
		&&  $data_verifica_old != $data_verifica
                &&  $ora_verifica_old  != $ora_verifica
		} {
   		    set data_verifica_old [iter_check_date $data_verifica_old]
		    if {[db_0or1row sel_opdi_fascia ""] == 1} {
			db_1row sel_cod_inco_dual ""
			set dml_crea_disp [db_map crea_disp]
		    }
		}
	    }
	}
        N {
	    set stato   "5"
	    set dml_sql [db_map upd_inco]
	    # ricreo la disponibilita' del verificatore
	    set ora_vererifica_old  $ora_verifica
            set cod_opve_old        $cod_opve
	    set data_verifica_old   $data_verifica
	    if {[db_0or1row sel_opdi_fascia ""] == 1} {
		db_1row sel_inco_disp_count ""
		if {$inco_disp > 1} {
		    # in questo caso non ricreo la disopnibilita'
                    # perche' sto annullando un incontro su una
                    # fascia che aveva gia' piu' di una  
                    # disponibilita'
		} else {
		    db_1row sel_cod_inco_dual ""
		    set dml_crea_disp [db_map crea_disp]
		}
	    }
	}
    }

  # Lancio la query di manipolazione dati contenuta in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coiminco $dml_sql
		if {[info exists dml_crea_disp]} {
		    db_dml dml_inco_crea_disp $dml_crea_disp
		}
		# eseguo prima la creazione della disponibilità rispetto
                # all'eliminazione perche' potrei essere in riassegnazione
                # con lo stesso verificatore/data/ora di conseguenza la  
                # disponibilita' sarebbe gia' assente.
		if {[info exists dml_del_disp]} {
		    db_dml dml_inco_del_disp $dml_del_disp
		}


            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    switch $funzione {
        D {set return_url   "coiminco-st-list?$link_list"}
        V {set return_url   "coiminco-st-list?$link_list"}
        A {set return_url   "coiminco-st-gest?funzione=V&$link_gest"}
        C {set return_url   "coiminco-st-gest?funzione=V&$link_gest"}
        E {set return_url   "coiminco-st-gest?funzione=V&$link_gest"}
        N {set return_url   "coiminco-st-gest?funzione=V&$link_gest"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
