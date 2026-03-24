ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Valentina Catte
    @creation-date   25/08/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimaimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    rom01 13/09/2022 Modifiche per caricamento massivo tramite xml

    sim01 06/05/2019 In base al parametro tabella_caricamento_rcee_tipo_1 vedo se usare il vecchio tracciato del
    sim01            caricamento o il nuovo semplificato
    

} {
    
  	{funzione           "I"}
	{caller          	"index"}
   	{nome_funz          ""}
	{lvl				"2"}
	{id_riga			""}
	{nome_tabella		""}
	{num_riga_tab		""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

set nome_tab_cari 	$nome_tabella
set nome_tab_anom 	"ANOM_"
set tipo_modello	[string range $nome_tabella 0 0]
if {$tipo_modello == "F"} {
	append nome_tab_anom 	[string range $nome_tabella 6 end]
	set modello				"modellof"
	set pot_nom				"pot_nom_foc_gen"
} 

if {$tipo_modello == "G"} {
	append nome_tab_anom 	[string range $nome_tabella 6 end]
	set modello				"modellog"
	set pot_nom				"potenza_utile_nom"
}

if {$tipo_modello == "R"} {
    append nome_tab_anom 	[string range $nome_tabella 10 end]
    
    set tabella_caricamento_rcee_tipo_1 [parameter::get_from_package_key -package_key iter -parameter tabella_caricamento_rcee_tipo_1];#sim01

    if {$nome_funz eq "cari-rcee-tipo-2"} {#gac01 gestito anche l'rcee del freddo
	set modello "rcee2"
    } else {
					
	if {$tabella_caricamento_rcee_tipo_1 eq "rce1"} {#sim01 if e suo contenuto
	    set modello "rce1"
	} else {
	    set modello                         "rcee1"
	}
    }
    
    set pot_nom				"potenza_nom_foc_gen"
}

if {$tipo_modello == "X"} {#rom01 Aggiunta if e il suo contenuto
    append nome_tab_anom        [string range $nome_tabella 11 end]

    set tabella_caricamento_rcee_tipo_1 [parameter::get_from_package_key -package_key iter -parameter tabella_caricamento_rcee_tipo_1]

    if {$nome_funz eq "cari-rcee-xml-tipo-2"} {
	set modello "rcee2"
    } else {

	if {$tabella_caricamento_rcee_tipo_1 eq "rce1"} {
	    set modello "rce1"
	} else {
	    set modello                         "rcee1"
	}
    }

    set pot_nom                         "potenza_nom_foc_gen"
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie   iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

iter_get_coimtgen

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script [export_url_vars calle nomue_funz id_riga nome_tabella]
set link_list [subst $link_list_script]

set page_title   "Correzione Errori d'Importazione"
set button1_label "Conferma correzioni"
set button2_label "Scarta dichiarazione"

set script ""
if {$funzione == "C"} {
	set script "<tr><td valign=top class=form_title align=center colspan=4><b>SALVATAGGIO EFFETTUATO</b></td></tr>
				<tr><td valign=top class=form_title align=center colspan=4>Clicca 'Chiudi finestra' e ritorna nell'elenco dichiarazioni per rilanciare l'elaborazione o per completare la correzione degli errori</td></tr>"
#	set context_bar [iter_context_bar \
#					[list "javascript:window.opener.location.reload(); window.close()" "Chiudi finestra"] \
#					"$page_title"]
	set context_bar [iter_context_bar \
					[list "javascript:window.close()" "Chiudi finestra"] \
					"$page_title"]
} elseif {$funzione == "S"} {
	set script "<tr><td valign=top class=form_title align=center colspan=4><b>DICHIARAZIONE SCARTATA</b></td></tr>
				<tr><td valign=top class=form_title align=center colspan=4>Clicca 'Chiudi finestra' e ritorna nell'elenco dichiarazioni per rilanciare l'elaborazione o per completare la correzione degli errori</td></tr>"
	set context_bar [iter_context_bar \
					[list "javascript:window.opener.location.reload(); window.close()" "Chiudi finestra"] \
					"$page_title"]
#	set context_bar [iter_context_bar \
#					[list "javascript:window.close()" "Chiudi finestra"] \
#					"$page_title"]
	
} else {
	set context_bar [iter_context_bar \
                 	[list "javascript:window.close()" "Torna alla Gestione"] \
                 	"$page_title"]
}	

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcorr_altre_anom_gest"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_cod "readonly"
set readonly_aimp "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

form create $form_name \
-html    $onsubmit_cmd

multirow create multiple_form count_anom
set count_anom 0

db_foreach sel_anom "" {
	multirow append multiple_form $count_anom
	set readonly_1 $readonly_cod
	if {![string equal $desc_errore ""]} {
		set readonly_1 \{\}
	}
	element create $form_name campo.$count_anom \
	-label   $nome_colonna \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 100 $readonly_1 {}" \
	-optional
	set denominazione.$count_anom ""
	
	incr count_anom 
}

element create $form_name submit_correggi	-widget submit -datatype text -label "$button1_label" -html "class form_submit"
element create $form_name submit_scarta		-widget submit -datatype text -label "$button2_label" -html "class form_submit"
		
element create $form_name funzione			-widget hidden -datatype text -optional
element create $form_name caller    		-widget hidden -datatype text -optional
element create $form_name nome_funz     	-widget hidden -datatype text -optional
element create $form_name dummy         	-widget hidden -datatype text -optional
element create $form_name nome_tabella		-widget hidden -datatype text -optional
element create $form_name id_riga     		-widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione         	-value $funzione
    element set_properties $form_name caller           	-value $caller
    element set_properties $form_name nome_funz        	-value $nome_funz
	element set_properties $form_name nome_tabella      -value $nome_tabella
	element set_properties $form_name id_riga     		-value $id_riga
	
	set count_anom 0
	db_foreach sel_anom "" {
		set denominazione.$count_anom $denominazione
		db_0or1row sel_value_anom ""
		element set_properties $form_name campo.$count_anom	-value 	$value
		if {![string equal $desc_errore ""]} {
			element::set_error $form_name campo.$count_anom 		$desc_errore
		}
		
		incr count_anom
	}	
}

if {[form is_valid $form_name]} {
  	set submit_correggi		[element::get_value $form_name submit_correggi]
	set submit_scarta     	[element::get_value $form_name submit_scarta]
	#preleva i valori dei campi nella form

	if {![string equal $submit_correggi ""]} {
		with_catch error_msg {
	    	db_transaction {
				set count 0
				set p ""
				db_foreach sel_anom "" {
					set value_campo	[string trim [element::get_value $form_name campo.$count]]
					db_dml upd_imp_cari_ok ""
					incr count
				}
	        }
	    } {
	    	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
	        seguente messaggio di errore <br><b>$error_msg</b><br>
	        Contattare amministratore di sistema e comunicare il messaggio
	        d'errore. Grazie."
	 	}
		set funzione "C"
	} elseif {![string equal $submit_scarta ""]} {
		with_catch error_msg {
		    db_transaction {
				db_dml upd_imp_anom_scarta ""
			}
		} {
		    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
			seguente messaggio di errore <br><b>$error_msg</b><br>
			Contattare amministratore di sistema e comunicare il messaggio
			d'errore. Grazie."
		}
		set funzione "S"
	}
      
	set link_gest [export_url_vars nome_tabella nome_funz caller]
	set return_url   "coimcorr-altre-anom-gest?funzione=$funzione&$link_gest"
	ad_returnredirect $return_url
	ad_script_abort
	
}
ad_return_template


