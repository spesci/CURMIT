ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimopve"
    @author          Adhoc
    @creation-date   29/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimopve-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    but01 29/03/2024 Modificato il controllo e il messagio d'errore nell'inserimento di un nuovo operatore.
    but01            Ora è possibile mettere lo stesso operatore su un ente verificatore diverso.

    rom02 15/09/2021 Modifiche per targatura Ispettori: Aggiunto il campo cod_portale, va valorizzato con lo stesso
    rom02            valore dell'omonimo campo del portale (iter_inspectors) dopo che viene registrato l'ispettore.
    rom02            Modifica riportata per allinemanto di UCIT al nuovo cvs. E' stata una modifica fatta appositamente
    rom02            per Ucit e con Sandro si e' deciso di rendere il campo visibile solo per Regione Friuli.

    rom01 13/09/2018 Aggiunto campo email
} {
    
   {cod_opve         ""}
   {last_cod_opve    ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
   {cod_enve         ""}
   {url_enve         ""}
   {flag_conta           ""}
   {conta_max            ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_opve last_cod_opve nome_funz nome_funz_caller extra_par caller cod_enve url_enve]
set link_area "../tabgen/coimtcar-list?[iter_get_nomefunz coimtcar-list]&[export_url_vars cod_opve nome_funz_caller url_enve]"
set link_disp "coimopdi-list?nome_funz=[iter_get_nomefunz coimopdi-list]&[export_url_vars cod_enve cod_opve nome_funz_caller url_enve]"
set link_disp2 "coimdisp-list?nome_funz=[iter_get_nomefunz coimdisp-list]&[export_url_vars cod_enve cod_opve nome_funz_caller url_enve]"

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_opve caller nome_funz_caller nome_funz cod_enve url_enve]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Ispettore"
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

set avviso_opgen ""
#if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar  [iter_context_bar \
#                     [list "javascript:window.close()" "Torna alla Gestione"] \
#                     [list coimopve-list?$link_list "Lista Operatori verificatori"] \
#                     "$page_title"]
#}

iter_get_coimtgen
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)


if {[db_0or1row sel_enve ""] == 0} {
    iter_return_complaint "Ente verificatore non trovato"
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimopve"
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

element create $form_name cod_listino \
-label   "Listino" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimlist cod_listino descrizione] 

element create $form_name cognome \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name matricola \
-label   "Matricola" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name telefono \
-label   "Telefono" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name cellulare \
-label   "Cellulare" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name recapito \
-label   "recapito" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name stato \
-label   "Stato" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {Attivo 0} {"Non attivo" 1}}

element create $form_name codice_fiscale \
-label   "Codice fiscale" \
-widget   text \
-datatype text \
-html    "size 18 maxlength 16 $readonly_fld {} class form_element" \
-optional

#rom02
element create $form_name cod_portale \
    -label   "" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name note \
-label   "recapito" \
-widget   textarea \
-datatype text \
-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
-optional

#rom01
element create $form_name email \
-label   "E-mail" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 35 $readonly_fld {} class form_element" \
-optional

element create $form_name conta_max \
    -widget   hidden \
    -datatype text \
    -optional

multirow create multiple_form conta
set conta 0
set flag_esiste "N"

if {$funzione == "I" } {
    if {[string equal $flag_conta ""]
	&& [string equal $conta_max ""]} {
	set conta_max "0"
    } else {
	if {![string equal $flag_conta ""]} {
	    set conta_max [expr $conta_max + 1]
	}
	set flag_esiste "S"
    }

    while {$conta < $conta_max} {
	incr conta 
	multirow append multiple_form $conta
	
	element create $form_name strumento.$conta \
	    -label   "Tipo" \
	    -widget   select \
	    -datatype text \
	    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
	    -optional \
	    -options {{{} {}} {Analizzatore A} {Deprimometro D}}
	
	element create $form_name marca_strum.$conta \
	    -label   "Marca Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name modello_strum.$conta \
	    -label   "Modello Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name matr_strum.$conta \
	    -label   "Matricola Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name dt_tar_strum.$conta \
	    -label   "Data Taratura Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name dt_inizio_att.$conta \
	    -label   "Data Taratura Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name dt_fine_att.$conta \
	    -label   "Data Taratura Strumento" \
	    -widget   text \
	    -datatype text \
	    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name strum_default.$conta \
	    -label   "check" \
	    -widget   checkbox \
	    -datatype text \
	    -html "$disabled_fld {} class form_element" \
	    -optional \
	    -options  {{Si S}}
    }
} else {

    db_foreach sel_strum "" {
		set flag_esiste "S"
		incr conta 
		multirow append multiple_form $conta
		
		element create $form_name strumento.$conta \
		    -label   "Tipo" \
		    -widget   select \
		    -datatype text \
		    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
		    -optional \
		    -options {{{} {}} {Analizzatore A} {Deprimometro D}}
		
		element create $form_name marca_strum.$conta \
		    -label   "Marca Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name modello_strum.$conta \
		    -label   "Modello Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name matr_strum.$conta \
		    -label   "Matricola Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name dt_tar_strum.$conta \
		    -label   "Data Taratura Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name dt_inizio_att.$conta \
		    -label   "Data Taratura Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
		
		element create $form_name dt_fine_att.$conta \
		    -label   "Data Taratura Strumento" \
		    -widget   text \
		    -datatype text \
		    -html    "cols 80 rows 3 $readonly_fld {} class form_element" \
		    -optional
	
		element create $form_name strum_default.$conta \
		    -label   "check" \
		    -widget   checkbox \
		    -datatype text \
		    -html "$disabled_fld {} class form_element" \
		    -optional \
		    -options  {{Si S}}
    }

    if {[string equal $conta_max ""]} {
		set conta_max $conta
    }
    
    if {$funzione == "M"} {
		if {![string equal $flag_conta ""]} {
		    set conta_max [expr $conta_max + 1]
		}

		while {$conta < $conta_max} {
		    incr conta 
		    multirow append multiple_form $conta
	
		    set flag_esiste "S"	
		    element create $form_name strumento.$conta \
			-label   "Tipo" \
			-widget   select \
			-datatype text \
			-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
			-optional \
			-options {{{} {}} {Analizzatore A} {Deprimometro D}}
		    
		    element create $form_name marca_strum.$conta \
			-label   "Marca Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name modello_strum.$conta \
			-label   "Modello Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name matr_strum.$conta \
			-label   "Matricola Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name dt_tar_strum.$conta \
			-label   "Data Taratura Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name dt_inizio_att.$conta \
			-label   "Data Taratura Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name dt_fine_att.$conta \
			-label   "Data Taratura Strumento" \
			-widget   text \
			-datatype text \
			-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
			-optional
		    
		    element create $form_name strum_default.$conta \
			-label   "check" \
			-widget   checkbox \
			-datatype text \
			-html "$disabled_fld {} class form_element" \
			-optional \
			-options  {{Si S}}
		}
    }
}
	
element create $form_name cod_opve  -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name cod_enve  -widget hidden -datatype text -optional
element create $form_name url_enve  -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_opve -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_cod_opve -value $last_cod_opve
    element set_properties $form_name cod_enve      -value $cod_enve
    element set_properties $form_name url_enve      -value $url_enve
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
	
    if {$funzione == "I"} {
		element set_properties $form_name conta_max -value $conta_max
		set link_aggiungi_gen "<a href=\"coimopve-gest?funzione=I&[export_url_vars cod_opve last_cod_opve conta_max nome_funz nome_funz_caller extra_par caller cod_enve url_enve]&flag_conta=S\">Aggiungi strumento</a>"        
    } else {

		if {$funzione == "M"} {
		    element set_properties $form_name conta_max -value $conta_max
		    
		    set link_aggiungi_gen "<a href=\"coimopve-gest?funzione=$funzione&[export_url_vars cod_opve last_cod_opve conta_max nome_funz nome_funz_caller extra_par caller cod_enve url_enve]&flag_conta=S\">Aggiungi strumento</a>"        
		}
	    # leggo riga
	    if {[db_0or1row sel_opve {}] == 0} {
	    	iter_return_complaint "Record non trovato"
		}
	
	    element set_properties $form_name cod_opve       -value $cod_opve
	    element set_properties $form_name cognome        -value $cognome
	    element set_properties $form_name nome           -value $nome
	    element set_properties $form_name matricola      -value $matricola
	    element set_properties $form_name stato          -value $stato
	    element set_properties $form_name recapito       -value $recapito
	    element set_properties $form_name telefono       -value $telefono
	    element set_properties $form_name cellulare      -value $cellulare
	    element set_properties $form_name codice_fiscale -value $codice_fiscale
	    element set_properties $form_name cod_portale    -value $cod_portale;#rom02
	    element set_properties $form_name note           -value $note
            element set_properties $form_name email          -value $email;#rom01
            element set_properties $form_name cod_listino    -value $cod_listino
	
		set conta 0
		db_foreach sel_strum "" {
		    incr conta
		    element set_properties $form_name strumento.$conta        -value $tipo_strum
		    element set_properties $form_name marca_strum.$conta      -value $marca_strumento
		    element set_properties $form_name modello_strum.$conta    -value $modello_strumento
		    element set_properties $form_name matr_strum.$conta       -value $matr_strumento
		    element set_properties $form_name dt_tar_strum.$conta     -value $dt_tar_strumento
		    element set_properties $form_name dt_inizio_att.$conta    -value $dt_inizio_attivita
		    element set_properties $form_name dt_fine_att.$conta      -value $dt_fine_attivita
		    element set_properties $form_name strum_default.$conta    -value $strum_def
		}
		
		if {[string range $cod_opve end-2 end] == "000"} {
			set avviso_opgen "<tr><td valign=top align=center colspan=4 class=form_title><font color=red><b>L'Operatore Generico NON può essere cancellato</b></font></td></tr>"
		}
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cognome        [string trim [element::get_value $form_name cognome]]
    set nome           [string trim [element::get_value $form_name nome]]
    set matricola      [string trim [element::get_value $form_name matricola]]
    set stato          [string trim [element::get_value $form_name stato]]
    set telefono       [string trim [element::get_value $form_name telefono]]
    set cellulare      [string trim [element::get_value $form_name cellulare]]
    set recapito       [string trim [element::get_value $form_name recapito]]
    set note           [string trim [element::get_value $form_name note]]
    set email          [string trim [element::get_value $form_name email]];#rom01
    set cod_listino    [string trim [element::get_value $form_name cod_listino]]
    set codice_fiscale [element::get_value $form_name codice_fiscale]
    set cod_portale    [string trim [element::get_value $form_name cod_portale]];#rom02

    set link_aggiungi_gen "<a href=\"coimopve-gest?funzione=$funzione&[export_url_vars cod_opve last_cod_opve conta_max nome_funz nome_funz_caller extra_par caller cod_enve url_enve]&flag_conta=S\">Aggiungi strumento</a>"        

	
    set conta 0
    while {$conta < $conta_max} {
	incr conta
	set strumento($conta)         [element::get_value $form_name strumento.$conta]
	set marca_strum($conta)       [element::get_value $form_name marca_strum.$conta]
	set modello_strum($conta)     [element::get_value $form_name modello_strum.$conta]
	set matr_strum($conta)        [element::get_value $form_name matr_strum.$conta]
	set dt_tar_strum($conta)      [element::get_value $form_name dt_tar_strum.$conta]
	set dt_inizio_att($conta)     [element::get_value $form_name dt_inizio_att.$conta]
	set dt_fine_att($conta)       [element::get_value $form_name dt_fine_att.$conta]
	set strum_default($conta)     [element::get_value $form_name strum_default.$conta]
    }

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

        if {[string equal $cognome ""]} {
            element::set_error $form_name cognome "Inserire Cognome"
            incr error_num
        }

        if {[string equal $nome ""]} {
            element::set_error $form_name nome "Inserire Nome"
            incr error_num
        }

        if {[string equal $matricola ""]} {
            element::set_error $form_name matricola "Inserire Matricola"
            incr error_num
        }

        if {[string equal $stato ""]} {
            element::set_error $form_name stato "Stato"
            incr error_num
        }

	set conta 0
	set count_ana 0
	set count_dep 0
	while {$conta < $conta_max} {
	    incr conta
	    
	    if {[string equal $strumento($conta) ""]} {
		element::set_error $form_name strumento.$conta "Inserire"
		incr error_num
	    }
	    if {[string equal $marca_strum($conta) ""]} {
		element::set_error $form_name marca_strum.$conta "Inserire"
		incr error_num
	    }
	    if {[string equal $modello_strum($conta) ""]} {
		element::set_error $form_name modello_strum.$conta "Inserire"
		incr error_num
	    }
	    if {[string equal $matr_strum($conta) ""]} {
		element::set_error $form_name matr_strum.$conta "Inserire"
		incr error_num
	    }
	    if {[string equal $dt_tar_strum($conta) ""]} {
		element::set_error $form_name dt_tar_strum.$conta "Inserire"
		incr error_num
	    } else {
		set dt_tar_strum($conta) [iter_check_date $dt_tar_strum($conta)]
		if {$dt_tar_strum($conta) == 0} {
		    element::set_error $form_name dt_tar_strum.$conta "Data taratura deve essere una data"
		    incr error_num
		}
	    }
	    if {[string equal $dt_inizio_att($conta) ""]} {
		element::set_error $form_name dt_inizio_att.$conta "Inserire"
		incr error_num
	    } else {
		set dt_inizio_att($conta) [iter_check_date $dt_inizio_att($conta)]
		if {$dt_inizio_att($conta) == 0} {
		    element::set_error $form_name dt_inizio_att.$conta "Data taratura deve essere una data"
		    incr error_num
		}
	    }

	    #corr 26092013
	    if {![string equal $dt_fine_att($conta) ""]} {
		set dt_fine_att($conta) [iter_check_date $dt_fine_att($conta)]
                if {$dt_fine_att($conta) == 0} {
                    element::set_error $form_name dt_fine_att.$conta "Data fine deve essere una data"
                    incr error_num
                }
            }
	    #fine

	    if {[string equal $strum_default($conta) "S"]} {
		if {$strumento($conta) == "A"} {
		    incr count_ana
		    set salva_conta_ana $conta
		}
		if {$strumento($conta) == "D"} {
		    incr count_dep
		    set salva_conta_dep $conta
		}
	    }
	}
	if {$count_ana > 1} {
	    element::set_error $form_name strum_default.$salva_conta_ana "Non &egrave; possibile inserire pi&ugrave; di un default per lo stesso tipo di strumento"
	    incr error_num
	}
	if {$count_dep > 1} {
	    element::set_error $form_name strum_default.$salva_conta_dep "Non &egrave; possibile inserire pi&ugrave; di un default per lo stesso tipo di strumento"
	    incr error_num
	}

    }

    if {$funzione == "D"} {
	db_1row sel_inco_count ""
        db_1row sel_cimp_count ""
        db_1row sel_stru_count ""
        db_1row sel_uten_count ""
	if {$conta_inco > 0 || $conta_cimp > 0 || $conta_stru > 0 || $conta_uten > 0} {
	    element::set_error $form_name cognome "Impossibile cancellare l'operatore: ha degli incontri/strumenti/RI/utenti collegati"
            incr error_num
	} else {
	    if {[string range $cod_opve end-2 end] == "000"} {
		element::set_error $form_name cognome "Impossibile cancellare l'operatore generico: cancellare l'ente verificatore"
		incr error_num
	    }
	}
    }

    if {$funzione == "I"
    &&  $error_num == 0
    &&  [db_0or1row sel_opve_check {}] == 1
    } {
      # controllo univocita'/protezione da double_click
	#but01 element::set_error $form_name cognome "Il nominativo che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
   	       element::set_error $form_name cognome "Il nominativo che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base per questo Ente Verificatore.";#but01
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

#    if {$funzione == "D"} {
#	set data_inizio [iter_check_date $data_inizio]
#    } 

    switch $funzione {
        I {db_1row sel_opve_s ""
	    set dml_sql [db_map ins_opve]}
        M {set dml_sql [db_map upd_opve]}
        D {set dml_sql [db_map del_opve]
           set del_dsp [db_map del_disp]
           set del_strum [db_map del_strum]
	}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimopve $dml_sql
		if {[info exists del_dsp]} {
		    db_dml dml_coiminco-disp $del_dsp
		}
		if {$funzione == "I"
		    || $funzione == "M"} {
		    set conta 0
		    db_dml del_strum ""
		    while {$conta < $conta_max} {
			incr conta
			set strumento_db     $strumento($conta)
			set marca_strum_db   $marca_strum($conta)
			set modello_strum_db $modello_strum($conta)
			set matr_strum_db    $matr_strum($conta)
			set dt_tar_strum_db  $dt_tar_strum($conta)
			set dt_inizio_att_db $dt_inizio_att($conta)
			set dt_fine_att_db   $dt_fine_att($conta)
			set strum_default_db $strum_default($conta)
			db_dml ins_strum ""
		    }
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
        set last_cod_opve $cod_opve
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_opve last_cod_opve nome_funz nome_funz_caller extra_par caller cod_enve url_enve conta_max]
    switch $funzione {
        M {set return_url   "coimopve-gest?funzione=V&$link_gest"}
        D {set return_url   "coimopve-list?$link_list"}
        I {set return_url   "coimopve-gest?funzione=V&$link_gest"}
        V {set return_url   "coimopve-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
