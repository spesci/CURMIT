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
    ===== ========== ========================================================================
    rom01 09/09/2022 Modifiche per gestire il nuovo caricamento RCEE1 tramite xml.

    gac01 11/07/2019 Modifiche per gestire il nuovo caricamento RCEE2

    sim01 02/09/2014 Modifiche per gestire il nuovo caricamento RCEE1

} {
    
	{funzione           "I"}
	{caller          	"index"}
   	{nome_funz          ""}
   	{nome_funz_caller   ""}
  	{extra_par          ""}
	{rows_per_page    	""}
   	{url_coimaces_list	""}
   	{stato_01           ""}
	{lvl				""}
 	{nome_tabella		""}
	{cod_batc			""}
	{last_id_riga		""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
	list_head:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set nome_tab_cari 		$nome_tabella
set tipo_modello		[string range $nome_tabella 0 0]
set nome_tab_anom 		"ANOM_"

set tabella_caricamento_rcee_tipo_1 [parameter::get_from_package_key -package_key iter -parameter tabella_caricamento_rcee_tipo_1];#sim02

#sim01: col nuovo modello il nome della tabella  è più lungo dei precedenti quindi il range non troverebbe il nome della tabella anomalie corretto
if {$tipo_modello == "R"} {
    append nome_tab_anom        [string range $nome_tabella 10 end]
} elseif {$tipo_modello == "X"} {#rom01 Aggiunta elseif e il suo contenuto
    append nome_tab_anom        [string range $nome_tabella 11 end]
} else {
    append nome_tab_anom        [string range $nome_tabella 6 end]
}

#sim01: aggiunto gestione tipo modello R
#rom01: Aggiunta gestione tipo modello X
if {$tipo_modello == "F"} {
	set pot_nom				"pot_nom_foc_gen"
} elseif {$tipo_modello == "G" || $tipo_modello == "R" || $tipo_modello == "X"} {
	set pot_nom				"potenza_utile_nom"
}

set sel_pote ",a.potenza_foc_nom
		            ,a.$pot_nom as potenza_nominale";#sim02

set upd_pote ",potenza_foc_nom = btrim(:potenza_foc_nom,' ')
                ,$pot_nom = btrim(:potenza_nominale,' ')";#sim02


set sel_comb ",a.combustibile
                            ,b.cod_combustibile"
set where_comb "left join coimcomb b on b.descr_comb = a.combustibile"

if {$tabella_caricamento_rcee_tipo_1 eq "rce1"} {#sim02 if e suo contenuto
    set sel_pote ""
    set upd_pote ""
}

if {$nome_funz eq "cari-rcee-tipo-2"} {#gac01
    set sel_comb ""
    set where_comb ""
    set cod_combustibile 88
}

#ns_return 200 text/html "$tipo_modello";return
# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

set page_title   "Correzione Errori d'Importazione"

if {$funzione == "R"} {
	set context_bar [iter_context_bar \
					[list "javascript:window.opener.location.reload(); window.close()" "Chiudi finestra"] \
					"$page_title"]
} else {
	set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}


set count_imp_scar [db_string sel_imp_scar "select count(*) from $nome_tab_cari where flag_stato = 'S'"]
set count_imp_acc [db_string sel_imp_acc "select count(*) from $nome_tab_cari where flag_stato = ''"]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcorr_anom_gest"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_cod "readonly"
set readonly_aimp "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

#procedura di creazione del link altri errori
set create_link_altri_err {
	set tag_iniz "<a href=\"#\" title=\"Correggi Errori non presenti in questa pagina\""
    set tag_fine "Sono presenti altri errori, clicca QUI per correggerli</a>"
	set script_name [ad_conn package_url]/src/coimcorr-altre-anom-gest
    set link_to "$tag_iniz onclick=\"javascript:window.open('$script_name?caller=$form_name&nome_funz=$nome_funz'"
    
	foreach {p1 p2} $what_list {
		if {$p2 == ""} {
		    set p2 $p1
		}
		append link_to " + '&$p1=' + urlencode(document.$form_name.$p2.value)"
    }

    regsub -all -- {-} $script_name {} window_name
    regsub -all -- {/} $window_name {} window_name

    append link_to ", '$window_name', 'scrollbars=yes, resizable=yes, width=760, height=700').moveTo(12,1)\">$tag_fine"

    set urlencode "
    <script language=JavaScript>
    function urlencode(inString){
        inString=escape(inString);
        for(i=0;i<inString.length;i++){
             if(inString.charAt(i)=='+'){
                  inString=inString.substring(0,i) + \"%2B\" + inString.substring(i+1);
             }
        }
        return(inString);
    }
    </script>"

    append link_to $urlencode
}

#creazione del form
form create $form_name \
-html    $onsubmit_cmd

# imposto la condizione per la prossima pagina
if {![string is space $last_id_riga]} {
    set where_last " and id_riga >= :last_id_riga"
} else {
    set where_last ""
}
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]

multirow create multiple_form count_imp_anom
set count_imp_anom 0
db_foreach sel_imp_anom "" {
	multirow append multiple_form $count_imp_anom
	set count_anom.$count_imp_anom 0
	element create $form_name num_riga_tab_$count_imp_anom		-widget hidden -datatype text -optional
	
	element create $form_name id_riga_$count_imp_anom			-widget hidden -datatype text -optional
	
	set riftab "cod_impianto_est"
	set readonly_1 $readonly_cod
	if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_1 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name cod_impianto_est.$count_imp_anom \
	-label   "cod_impianto_est" \
	-widget   text \
	-datatype text \
	-html    "size 12 maxlength 20 $readonly_1 {} class form_element" \
	-optional
		
	set riftab "matricola"
	set readonly_2 $readonly_cod
	if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_2 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name matricola.$count_imp_anom \
	-label   "matricola" \
	-widget   text \
	-datatype text \
	-html    "size 12 maxlength 35 $readonly_2 {} class form_element" \
	-optional 

    	if {$tabella_caricamento_rcee_tipo_1 ne "rce1"} {#sim02 if e suo contenuto

	    set riftab "potenza_foc_nom"
	    set readonly_4 $readonly_cod
	    if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_4 \{\}
		incr count_anom.$count_imp_anom
	    }
	    
	    element create $form_name potenza_foc_nom.$count_imp_anom \
		-label   "modello" \
		-widget   text \
		-datatype text \
		-html    "size 5 maxlength 9 $readonly_4 {} class form_element" \
		-optional 
	    
	    set riftab "potenza_utile_nom"
	    set readonly_5 $readonly_cod
	    if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_5 \{\}
		incr count_anom.$count_imp_anom
	    }
	    element create $form_name potenza_nominale.$count_imp_anom \
		-label   "potenza_nominale" \
		-widget   text \
		-datatype text \
		-html    "size 5 maxlength 9 $readonly_5 {} class form_element" \
		-optional 
	    
	};#sim02

	set cerca_viae.$count_imp_anom ""
	set riftab "indirizzo"
	set readonly_6 $readonly_cod
	if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_6 \{\}
		incr count_anom.$count_imp_anom
	}
		
	element create $form_name descr_via_$count_imp_anom \
	-label   "Via" \
	-widget   text \
	-datatype text \
	-html    "size 30 maxlength 100 $readonly_6 {} class form_element" \
	-optional
	
	set cerca_viae.$count_imp_anom ""
	set riftab "toponimo"
	set disabled_7 $disabled_fld
	if {[db_0or1row sel_riftab ""] == 1} {
		set disabled_7 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name descr_topo_$count_imp_anom \
	-label   "Descrizione toponimo" \
	-widget   select \
	-datatype text \
	-html    "$disabled_7 {}" \
	-optional \
	-options [iter_selbox_from_table coimtopo descr_topo descr_topo]
	
	set riftab "civico"
	set readonly_8 $readonly_cod
	if {[db_0or1row sel_riftab ""] == 1} {
		set readonly_8 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name civico.$count_imp_anom \
	-label   "civico" \
	-widget   text \
	-datatype text \
	-html    "size 3 maxlength 8 $readonly_8 {} class form_element" \
	-optional
	
	set riftab "comune"
	set disabled_3 $disabled_fld
	if {[db_0or1row sel_riftab ""] == 1} {
		set disabled_3 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name cod_comune_$count_imp_anom \
	-label   "comune" \
	-widget   select \
	-datatype text \
	-html    "$disabled_3 {}" \
	-optional \
	-options [iter_selbox_from_comu]
	
	set riftab "combustibile"
	set disabled_9 $disabled_fld
	if {[db_0or1row sel_riftab ""] == 1} {
		set disabled_9 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name cod_combustibile.$count_imp_anom \
	-label   "combustibile" \
	-widget   select \
	-datatype text \
	-html    "$disabled_9 {}" \
	-optional \
	-options [iter_selbox_from_table coimcomb cod_combustibile descr_comb] 
	
	set riftab "marca"
	set disabled_10 $disabled_fld
	if {[db_0or1row sel_riftab ""] == 1} {
		set disabled_10 \{\}
		incr count_anom.$count_imp_anom
	}
	element create $form_name cod_cost.$count_imp_anom \
	-label   "marca costruttore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_10 {}" \
	-optional \
	-options [iter_selbox_from_table coimcost cod_cost descr_cost] 
	
	set link_altri_err.$count_imp_anom ""
	
	element create $form_name submit_scarta.$count_imp_anom \
	-label "Scarta dichiarazione" \
	-widget submit \
	-datatype text \
	-html "class form_submit"

	incr count_imp_anom 
}

set link_righe      [iter_rows_per_page     $rows_per_page]
# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
# preparo url escludendo last_dett_funz che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_id_riga]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"
# preparo link a pagina successiva
if {$count_imp_anom == $rows_per_page} {
    set last_id_riga $id_riga
    append url_vars "&[export_url_vars last_id_riga]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}
# creo testata della lista
set list_head [iter_list_head "" "" "" $link_altre_pagine $link_righe "Righe per pagina"]

element create $form_name submit_rilancia	-widget submit -datatype text -label "Rilancia Elaborazione" -html "class form_submit"

element create $form_name funzione			-widget hidden -datatype text -optional
element create $form_name caller    		-widget hidden -datatype text -optional
element create $form_name nome_funz     	-widget hidden -datatype text -optional
element create $form_name nome_funz_caller 	-widget hidden -datatype text -optional
element create $form_name extra_par     	-widget hidden -datatype text -optional
element create $form_name dummy         	-widget hidden -datatype text -optional
element create $form_name nome_tabella		-widget hidden -datatype text -optional
element create $form_name cod_batc			-widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione         	-value $funzione
    element set_properties $form_name caller           	-value $caller
    element set_properties $form_name nome_funz        	-value $nome_funz
    element set_properties $form_name nome_funz_caller 	-value $nome_funz_caller
    element set_properties $form_name extra_par        	-value $extra_par
    element set_properties $form_name nome_tabella      -value $nome_tabella
    element set_properties $form_name cod_batc			-value $cod_batc
    
    set count_imp_anom 0
    db_foreach sel_imp_anom "" {
	element set_properties $form_name num_riga_tab_$count_imp_anom 		-value $count_imp_anom
	
	element set_properties $form_name id_riga_$count_imp_anom			-value $id_riga
	
	set desc_errore ""
	set riftab "cod_impianto_est"
	db_0or1row sel_riftab ""
	element set_properties $form_name cod_impianto_est.$count_imp_anom	-value $cod_impianto_est
	element::set_error $form_name cod_impianto_est.$count_imp_anom 		$desc_errore
	
	set desc_errore ""
	set riftab "matricola"
	db_0or1row sel_riftab ""
	element set_properties $form_name matricola.$count_imp_anom      	-value $matricola
	element::set_error $form_name matricola.$count_imp_anom 			$desc_errore


	if {$tabella_caricamento_rcee_tipo_1 ne "rce1"} {#sim02 if e suo contenuto

	    set desc_errore ""
	    set riftab "potenza_foc_nom"
	    db_0or1row sel_riftab ""
	    element set_properties $form_name potenza_foc_nom.$count_imp_anom 	-value $potenza_foc_nom
	    element::set_error $form_name potenza_foc_nom.$count_imp_anom 		$desc_errore
		
	    set desc_errore ""
	    set riftab $pot_nom
	    db_0or1row sel_riftab ""
	    element set_properties $form_name potenza_nominale.$count_imp_anom	-value $potenza_nominale
	    element::set_error $form_name potenza_nominale.$count_imp_anom 	$desc_errore

	};#sim02
	
	set desc_errore ""
	set riftab "toponimo"
	db_0or1row sel_riftab ""
	element set_properties $form_name descr_topo_$count_imp_anom      	-value $toponimo
	if {![string equal $desc_errore ""]} {
	    element::set_error $form_name descr_topo_$count_imp_anom 		"$toponimo:	$desc_errore"
	}
	
	set desc_errore ""
	set riftab "comune"
	db_0or1row sel_riftab ""
	element set_properties $form_name cod_comune_$count_imp_anom    	-value $cod_comune
	if {![string equal $desc_errore ""]} {
	    element::set_error $form_name cod_comune_$count_imp_anom 		"$comune: $desc_errore"
	}
#ns_log notice "prova dob 1 $cod_comune $count_imp_anom"

	
	set desc_errore ""
	set riftab "indirizzo"
	db_0or1row sel_riftab ""
	element set_properties $form_name descr_via_$count_imp_anom      	-value $indirizzo
	element::set_error $form_name descr_via_$count_imp_anom 			$desc_errore
	if {![string equal $desc_errore ""]} {
	    if {$coimtgen(flag_viario) == "T"} {
		element set_properties $form_name cod_comune_$count_imp_anom		-html "\{\} {}"
		set cerca_viae.$count_imp_anom [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy dummy dummy descr_via_$count_imp_anom dummy descr_topo_$count_imp_anom cod_comune cod_comune_$count_imp_anom dummy dummy dummy dummy]]
		element set_properties $form_name cod_comune_$count_imp_anom		-html "disabled {}"				
	    }  
	}		
	
	set desc_errore ""
	set riftab "civico"
	db_0or1row sel_riftab ""
	element set_properties $form_name civico.$count_imp_anom    		-value $civico
	element::set_error $form_name civico.$count_imp_anom 				$desc_errore
	
	set desc_errore ""
	set riftab "combustibile"
	db_0or1row sel_riftab ""
	element set_properties $form_name cod_combustibile.$count_imp_anom	-value $cod_combustibile
	if {![string equal $desc_errore ""]} {
	    element::set_error $form_name cod_combustibile.$count_imp_anom 	"$combustibile: $desc_errore"
	}
	
	set desc_errore ""
	set riftab "marca"
	db_0or1row sel_riftab ""
	element set_properties $form_name cod_cost.$count_imp_anom    		-value $cod_cost
	if {![string equal $desc_errore ""]} {
	    element::set_error $form_name cod_cost.$count_imp_anom 			"$marca: $desc_errore"
	}
	
	set num_err [set count_anom.$count_imp_anom]
	if {$numero_anomalie > $num_err} {
	    set what_list [list id_riga id_riga_$count_imp_anom nome_tabella nome_tabella num_riga_tab num_riga_tab_$count_imp_anom]
	    set link_altri_err.$count_imp_anom [eval $create_link_altri_err]
	}
	
	incr count_imp_anom
    }	
}

if {[form is_valid $form_name]} {
	#riconosce il bottone che è stato premuto
	set submit_rilancia     [element::get_value $form_name submit_rilancia]
	
	for {set r 0} {$r < $count_imp_anom} {incr r} {
		set submit_scarta	[element::get_value $form_name submit_scarta.$r]
		set id_riga			[element::get_value $form_name id_riga_$r]
		if {![string equal $submit_scarta ""]} {
			break
		} 
	}
	#se è stato premuto rilancia elaborazione
	if {![string equal $submit_rilancia ""]} {
		set r 0
		#ciclo per il salvataggio dei dati della form
    	db_foreach sel_imp_anom "" {
			set id_riga		[element::get_value $form_name id_riga_$r]
			set cod_impianto_est	[string trim [element::get_value $form_name cod_impianto_est.$r]]
			set matricola           [string trim [element::get_value $form_name matricola.$r]]
	    if {$tabella_caricamento_rcee_tipo_1 ne "rce1"} {#sim02 if e suo contenuto
		set potenza_foc_nom     [string trim [element::get_value $form_name potenza_foc_nom.$r]]
		set potenza_nominale	[string trim [element::get_value $form_name potenza_nominale.$r]]
	    }
			set desc_errore ""
			set riftab "indirizzo"
			db_0or1row sel_riftab ""
			if {![string equal $desc_errore ""]} {
				set descr_topo 		[element::get_value $form_name descr_topo_$r]
			} else { 
				set descr_topo $toponimo
			}

			set descr_via         	[element::get_value $form_name descr_via_$r]
		        set civico            	[string trim [element::get_value $form_name civico.$r]]
			
                        set desc_errore ""
			set riftab "comune"
			db_0or1row sel_riftab ""
			if {![string equal $desc_errore ""]} {
				set cod_comune   [element::get_value $form_name cod_comune_$r]
			} else { 
				set cod_comune $cod_comune
			}

#ns_log notice "prova dob 2 $cod_comune $r"

			set desc_errore ""
			set riftab "combustibile"
			db_0or1row sel_riftab ""
			if {![string equal $desc_errore ""]} {
				set cod_combustibile	[element::get_value $form_name cod_combustibile.$r]
			} else { 
				set cod_combustibile $cod_combustibile
			}

			set desc_errore ""
			set riftab "marca"
			db_0or1row sel_riftab ""
			if {![string equal $desc_errore ""]} {
				set cod_cost       		[element::get_value $form_name cod_cost.$r]
			} else { 
				set cod_cost $cod_cost
			}
			set num_err 			[set count_anom.$r]
		
			with_catch error_msg {
		            db_transaction {
						db_dml upd_imp_cari_ok ""
		            }
		    } {
		    	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
		        seguente messaggio di errore <br><b>$error_msg</b><br>
		        Contattare amministratore di sistema e comunicare il messaggio
		        d'errore. Grazie."
		 	}
			incr r
		}
		#cancella batc ed esito per togliere dalla lista degli esiti ciò che non è definitivo
		set ctr 1
		if {[db_0or1row sel_esit ""] == 0} {
	    # iter_return_complaint "Record non trovato"
	    # in questo caso significa che c'e' solo il record di coimbatc
	    # ma non di coimesit perche', ad esempio si e' interrotto!!!
		    set sw_esit "f"
		} else {
		    set sw_esit "t"
		}
		# Lancio la query di cancellazione
		with_catch error_msg {
			db_transaction {
				if {$sw_esit == "t"} {
					db_dml del_esit ""
				}
				set ctr_esit [db_string sel_esit_count ""]
				if {$ctr_esit == 0} {
				    db_dml del_batc ""
				}
			}
		} {
		    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
		    seguente messaggio di errore <br><b>$error_msg</b><br>
		    Contattare amministratore di sistema e comunicare il messaggio
		    d'errore. Grazie."
		}
		
		#avvia batc per rielaborazione
		db_1row sel_batc_next ""
		set flg_stat    	"A"
		set dat_prev		[iter_set_sysdate]
		set ora_prev     	[iter_set_systime]
		set cod_uten_sch    $id_utente
		set par            	""
		lappend par         id_utente
		lappend par         $id_utente
		lappend par        	nome_tabella
		lappend par			$nome_tab_cari
		set note           	""

	        #sim01: aggiunta gestione del nuovo modello RCEE1
	        if {$tipo_modello == "F"} {
			set nom       			"Caricamento modelli F"
			set nom_prog       		"iter_cari_modelli_f"
		} elseif {$tipo_modello == "G"} {
			set nom       			"Caricamento modelli G"
			set nom_prog       		"iter_cari_modelli"
		}  elseif {$tipo_modello == "R"} {
		    if {$nome_funz == "cari-rcee-tipo-2"} {
			set nom                         "Caricamento RCEE di tipo 2"
			set nom_prog                    "iter_cari_rcee_tipo_2"
		    } else {
			set nom                         "Caricamento RCEE di tipo 1"
			if {$tabella_caricamento_rcee_tipo_1 ne "rce1"} {#sim02 if e suo contenuto
			    set nom_prog                    "iter_cari_rcee_tipo_1"
			} else {
			    set nom_prog                    "iter_cari_rce_tipo_1"
			}
		    }
                } elseif {$tipo_modello == "X"} {#rom01 Aggiunta elseif e il suo contenuto

		    if {$nome_funz == "cari-rcee-xml-tipo-2"} {
			set nom                         "Car.RCEE di tipo 2 tramite xml"
			set nom_prog                    "iter_cari_rcee_xml_tipo_2"
		    } else {
			set nom                         "Car.RCEE di tipo 1 tramite XML"
			if {$tabella_caricamento_rcee_tipo_1 ne "rce1"} {#sim02 if e suo contenuto
			    set nom_prog                    "iter_cari_rcee_xml_tipo_1"
			} else {
			    set nom_prog                    "iter_cari_rce_xml_tipo_1"
			}
		    }
		}

		set dml_sql        [db_map ins_batc]
		if {[info exists dml_sql]} {
			with_catch error_msg {
		    	db_transaction {
					db_dml dml_coimbatc $dml_sql
		        }
		    } {
		    	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
		        seguente messaggio di errore <br><b>$error_msg</b><br>
		        Contattare amministratore di sistema e comunicare il messaggio
		        d'errore. Grazie."
		 	}
		}
	
		set funzione "R"
		#se è stato premuto scarta
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
	
	#mostra avvenuto avvio elebarazione
	set link_gest [export_url_vars nome_tabella cod_batc nome_funz_caller extra_par caller]&nome_funz=$nome_funz
	set return_url   "coimcorr-anom-gest?funzione=$funzione&$link_gest"
	ad_returnredirect $return_url
	ad_script_abort
	
}

ad_return_template

