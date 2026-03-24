ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcons_prod_chimici"
    @author          Romitti Luca
    @creation-date   15/09/2016
    
    @param funzione  I=insert M=edit D=delete V=view
    
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimcons-prod-chimici-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    
} {
    {cons_prod_chimici_id        ""}
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

set link_gest [export_url_vars cons_prod_chimici_id cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars cons_prod_chimici_id cod_impianto caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
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
set form_name    "coimcons_prod_chimici"
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

element create $form_name circ_imp_term \
    -label "Cricuito impianto termico" \
    -widget   select \
    -datatype boolean \
    -html    "$disabled_fld {} class form_element" \
    -options  {{No f} {S&igrave; t}} \
    -optional \

element create $form_name circ_acs \
    -label "circuito ACS" \
    -widget   select \
    -datatype boolean \
    -html    "$disabled_fld {} class form_element" \
    -options  {{No f} {S&igrave; t}} \
    -optional \

element create $form_name  altri_circ_ausi\
    -label "Altri circuiti ausiliari" \
    -widget   select \
    -datatype boolean \
    -html    "$disabled_fld {} class form_element" \
    -options  {{No f} {S&igrave; t}} \
    -optional \

element create $form_name nome_prodotto \
    -label   "Nome_Prodotto" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
    -optional \
	
element create $form_name qta_cons \
    -label   "Massima portata aria (m&sup3;/h)" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name unita_misura \
    -label   "Rendimento di recupero / COP" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 50 $readonly_fld {} class form_element" \
    -optional

element create $form_name cons_prod_chimici_id -widget hidden -datatype text -optional
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
	db_1row query "select coalesce(max(cons_prod_chimici_id) + 1, '1') as cons_prod_chimici_id from coimcons_prod_chimici"
	
	element set_properties $form_name cons_prod_chimici_id -value $cons_prod_chimici_id
	
    } else {
	# leggo riga
	if {[db_0or1row query "
             select a.cod_impianto
                  , a.esercizio1
                  , a.esercizio2
                  , a.circ_imp_term
                  , a.circ_acs
                  , a.altri_circ_ausi
		  , a.nome_prodotto
		  , iter_edit_num(a.qta_cons, 2) as qta_cons
                  , a.unita_misura
	       from coimcons_prod_chimici a
	      where a.cons_prod_chimici_id = :cons_prod_chimici_id
        "] == 0
	} {
	    iter_return_complaint "Record non trovato"
	}
	
	element set_properties $form_name cons_prod_chimici_id -value $cons_prod_chimici_id
	element set_properties $form_name cod_impianto         -value $cod_impianto
	element set_properties $form_name esercizio1           -value $esercizio1
	element set_properties $form_name esercizio2           -value $esercizio2
	element set_properties $form_name circ_imp_term        -value $circ_imp_term
	element set_properties $form_name circ_acs             -value $circ_acs     
	element set_properties $form_name altri_circ_ausi      -value $altri_circ_ausi
	element set_properties $form_name nome_prodotto        -value $nome_prodotto
	element set_properties $form_name qta_cons             -value $qta_cons
	element set_properties $form_name unita_misura         -value $unita_misura
	
    }
}

if {[form is_valid $form_name]} {
 
    set cons_prod_chimici_id   [element::get_value $form_name cons_prod_chimici_id]
    set cod_impianto           [element::get_value $form_name cod_impianto]
    set esercizio1             [element::get_value $form_name esercizio1]
    set esercizio2             [element::get_value $form_name esercizio2]
    set circ_imp_term          [element::get_value $form_name circ_imp_term]
    set circ_acs               [element::get_value $form_name circ_acs]
    set altri_circ_ausi        [element::get_value $form_name altri_circ_ausi]
    set nome_prodotto          [element::get_value $form_name nome_prodotto]
    set qta_cons               [element::get_value $form_name qta_cons]
    set unita_misura           [element::get_value $form_name unita_misura]

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
	
	    if {[string is space $nome_prodotto]} {
		element::set_error $form_name nome_prodotto "Inserire nome_prodotto"
		incr error_num
	    }

	    if {[string is space $circ_imp_term]} {
		element::set_error $form_name circ_imp_term "Selezionare un valore."
		incr error_num
	    }

	    if {[string is space $circ_acs]} {
		element::set_error $form_name circ_acs "Selezionare un valore."
		incr error_num
	    }

	    if {[string is space $altri_circ_ausi]} {
		element::set_error $form_name altri_circ_ausi "Selezionare un valore."
		incr error_num
	    }

	    if {![string equal $qta_cons ""]} {
		set qta_cons [iter_check_num $qta_cons 2]
		if {$qta_cons == "Error"} {
		    element::set_error $form_name qta_cons "Deve essere numerico, max 2 dec"
		    incr error_num
		}
	    } else {
		element::set_error $form_name qta_cons "Inserire campo."
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
                      into coimcons_prod_chimici 
                         ( cons_prod_chimici_id
                         , cod_impianto
                         , esercizio1
                         , esercizio2
                         , circ_imp_term
                         , circ_acs
                         , altri_circ_ausi
                         , nome_prodotto
			 , qta_cons
			 , unita_misura
	         	 , data_ins
                         , utente_ins
                         )
                    values 
                         (:cons_prod_chimici_id
                         ,:cod_impianto
                         ,:esercizio1
                         ,:esercizio2
                         ,:circ_imp_term
                         ,:circ_acs
                         ,:altri_circ_ausi
                         ,:nome_prodotto
			 ,:qta_cons
			 ,:unita_misura
                         ,:current_date
                         ,:id_utente
                      )"
		}
		M {
		    db_dml query "
                    update coimcons_prod_chimici
                       set esercizio1           = :esercizio1
                         , esercizio2           = :esercizio2
                         , circ_imp_term        = :circ_imp_term
                         , circ_acs             = :circ_acs     
                         , altri_circ_ausi      = :altri_circ_ausi
                         , nome_prodotto        = :nome_prodotto
			 , qta_cons             = :qta_cons
			 , unita_misura       = :unita_misura
                         , data_mod             = current_date
                         , utente_mod           = :id_utente
                     where cons_prod_chimici_id = :cons_prod_chimici_id"
		}
		D {
		    db_dml query "
                    delete
                      from coimcons_prod_chimici
                     where cons_prod_chimici_id = :cons_prod_chimici_id"
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
    set link_gest      [export_url_vars cod_impianto cons_prod_chimici_id nome_funz nome_funz_caller url_list_aimp url_aimp ]
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
