ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcons_elet"
    @author          Romitti Luca
    @creation-date   14/11/2022
    
    @param funzione  I=insert M=edit D=delete V=view
    
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimcons-elet-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    
} {
    {cons_elet_id                ""}
    {cod_impianto                ""}
    {funzione                   "V"}
    {caller                 "index"}
    {nome_funz                   ""}
    {nome_funz_caller            ""}
    {extra_par                   ""}
    {url_list_aimp               ""}
    {url_aimp                    ""}
} -properties {    
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
    focus_field:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}  
    "M" {set lvl 3}   
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set link_gest [export_url_vars cons_elet_id cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars cons_elet_id cod_impianto caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set current_date     [iter_set_sysdate]

set titolo              "Consumo prodotti chimici per il trattamento acqua del circuito dell'impianto termico"
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

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcons_elet"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {
	set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
    }
    "M" {
	set readonly_fld \{\}
        set disabled_fld \{\}
    }
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name esercizio1 \
    -label   "Data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name esercizio2 \
    -label   "Data dismissione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional 

element create $form_name lett_iniziale \
    -label   "Lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name lett_finale \
    -label   "Lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional
element create $form_name consumo_tot \
    -label   "Consumo totale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name cons_elet_id -widget hidden -datatype text -optional
element create $form_name funzione             -widget hidden -datatype text -optional
element create $form_name caller               -widget hidden -datatype text -optional
element create $form_name nome_funz            -widget hidden -datatype text -optional
element create $form_name nome_funz_caller     -widget hidden -datatype text -optional
element create $form_name extra_par            -widget hidden -datatype text -optional
element create $form_name cod_impianto         -widget hidden -datatype text -optional
element create $form_name url_list_aimp        -widget hidden -datatype text -optional
element create $form_name url_aimp             -widget hidden -datatype text -optional
element create $form_name submit               -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp
    
    if {$funzione == "I"} {
	db_1row query "select coalesce(max(cons_elet_id) + 1, '1') as cons_elet_id from coimcons_elet"
	
	element set_properties $form_name cons_elet_id -value $cons_elet_id
	
    } else {
	# leggo riga
	if {[db_0or1row query "
             select a.cod_impianto
                  , a.esercizio1
                  , a.esercizio2
                  , iter_edit_num(a.lett_iniziale, 2) as lett_iniziale
                  , iter_edit_num(a.lett_finale, 2)   as lett_finale
                  , iter_edit_num(a.consumo_tot, 2)   as consumo_tot
	       from coimcons_elet a
	      where a.cons_elet_id = :cons_elet_id
        "] == 0
	} {
	    iter_return_complaint "Record non trovato"
	}
	
	element set_properties $form_name cons_elet_id -value $cons_elet_id
	element set_properties $form_name cod_impianto        -value $cod_impianto
	element set_properties $form_name esercizio1          -value $esercizio1
	element set_properties $form_name esercizio2          -value $esercizio2
	element set_properties $form_name lett_iniziale       -value $lett_iniziale
	element set_properties $form_name lett_finale         -value $lett_finale     
	element set_properties $form_name consumo_tot         -value $consumo_tot
	
    }
}

if {[form is_valid $form_name]} {
 
    set cons_elet_id   [element::get_value $form_name cons_elet_id]
    set cod_impianto         [element::get_value $form_name cod_impianto]
    set esercizio1           [element::get_value $form_name esercizio1]
    set esercizio2           [element::get_value $form_name esercizio2]
    set lett_iniziale        [element::get_value $form_name lett_iniziale]
    set lett_finale          [element::get_value $form_name lett_finale]
    set consumo_tot          [element::get_value $form_name consumo_tot]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
	
	if {$funzione == "I" || $funzione == "M"} {   
	
	    if {[string is space $esercizio1] || [string is space $esercizio2]} {
		element::set_error $form_name esercizio1 "Inserire entrambi gli eserizi"
		incr error_num
	    } 
	    if {![string equal $esercizio1 ""]} {
		set esercizio1 [iter_check_num $esercizio1 0]
		if {$esercizio1 == "Error"} {
		    element::set_error $form_name esercizio1 "Esercizio deve essere numerico"
		    incr error_num
		}
	    }
	    if {![string equal $esercizio2 ""]} {
		set esercizio2 [iter_check_num $esercizio2 0]
		if {$esercizio2 == "Error"} {
		    element::set_error $form_name esercizio1 "Esercizio deve essere numerico"
		    incr error_num
		}
	    }
	
	    if {![string equal $lett_iniziale ""]} {
		set lett_iniziale [iter_check_num $lett_iniziale 2]
		if {$lett_iniziale == "Error"} {
		    element::set_error $form_name lett_iniziale "Deve essere numerico, max 2 dec"
		    incr error_num
		}
	    } else {
		element::set_error $form_name lett_iniziale "Inserire campo."
		incr error_num
	    }

	    if {![string equal $lett_finale ""]} {
		set lett_finale [iter_check_num $lett_finale 2]
		if {$lett_finale == "Error"} {
		    element::set_error $form_name lett_finale "Deve essere numerico, max 2 dec"
		    incr error_num
		}
	    } else {
		element::set_error $form_name lett_finale "Inserire campo."
		incr error_num
	    }

	    if {![string equal $consumo_tot ""]} {
		set consumo_tot [iter_check_num $consumo_tot 2]
		if {$consumo_tot == "Error"} {
		    element::set_error $form_name consumo_tot "Deve essere numerico, max 2 dec"
		    incr error_num
		}
	    } else {
		element::set_error $form_name consumo_tot "Inserire campo."
		incr error_num
	    }

	    
	}

    if {$error_num > 0} {
	ad_return_template
	return
    }   
    
    # Lancio la query di manipolazione dati contenuta in dml_sql
    
    # with_catch error_msg serve a verificare che non ci siano errori nella db_transaction
    with_catch error_msg {
	db_transaction {
	    switch $funzione {
		I {
		    db_dml query "
                    insert
                      into coimcons_elet 
                         ( cons_elet_id
                         , cod_impianto
                         , esercizio1
                         , esercizio2
                         , lett_iniziale
                         , lett_finale
                         , consumo_tot
	         	 , data_ins
                         , utente_ins
                         )
                    values 
                         (:cons_elet_id
                         ,:cod_impianto
                         ,:esercizio1
                         ,:esercizio2
                         ,:lett_iniziale
                         ,:lett_finale
                         ,:consumo_tot
                         ,:current_date
                         ,:id_utente
                      )"
		}
		M {
		    db_dml query "
                    update coimcons_elet
                       set esercizio1           = :esercizio1
                         , esercizio2           = :esercizio2
                         , lett_iniziale        = :lett_iniziale
                         , lett_finale          = :lett_finale     
                         , consumo_tot          = :consumo_tot
                         , data_mod             = current_date
                         , utente_mod           = :id_utente
                     where cons_elet_id = :cons_elet_id"
		}
		D {
		    db_dml query "
                    delete
                      from coimcons_elet
                     where cons_elet_id = :cons_elet_id"
		}
	    }
	    
	} 
    } {
        iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }
    
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto cons_elet_id nome_funz nome_funz_caller url_list_aimp url_aimp ]
    switch $funzione {
	I {set return_url   "coimaimp-altre-schede-list?funzione=V&$link_gest"}
	V {set return_url   "coimaimp-altre-schede-list?$link_list"}
	M {set return_url   "coimaimp-altre-schede-list?funzione=V&$link_gest"}
	D {set return_url   "coimaimp-altre-schede-list?$link_list"}
    }
    
    ad_returnredirect $return_url
    ad_script_abort
    
}
ad_return_template
