ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcirc_inte_aimp"
    @author          Gabriele Lo Vaglio - clonato da coimaimp-tratt-acqua-gest
    @creation-date   19/08/2016
    
    @param funzione  I=insert M=edit D=delete V=view
    
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimcirc-inte-aimp-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 22/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_installaz, data_dismissione.
    rom02 21/12/2018 Aggiunto campo num_ci_sostituente

    rom01 03/09/2018 Aggiunto campo flag_sostituito
    
} {
    {cod_circ_inte_aimp     ""}
    {cod_impianto           ""}
    {funzione              "V"}
    {caller            "index"}
    {nome_funz              ""}
    {nome_funz_caller       ""}
    {extra_par              ""}
    {url_list_aimp          ""}
    {url_aimp               ""}
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

set link_gest [export_url_vars cod_circ_inte_aimp cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_circ_inte_aimp cod_impianto caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set current_date     [iter_set_sysdate]

set titolo              "Circuito Interrato a Condensazione/Espansione Diretta"
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
set form_name    "coimcirc_inte_aimp"
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
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}


form create $form_name \
    -html    $onsubmit_cmd

element create $form_name num_ci \
    -label   "Numero" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 readonly {} class form_element" \
    -optional
#but01
element create $form_name data_installaz \
    -label   "Data installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
#but01
element create $form_name data_dismissione \
    -label   "Data dismissione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional 
        
#rom01
element create $form_name flag_sostituito \
    -label "Sostituito?" \
    -widget   select \
    -datatype boolean \
    -html    "$disabled_fld {} class form_element" \
    -options  {{No f} {S&igrave; t}} \
    -optional \
    #rom02
element create $form_name num_ci_sostituente \
    -label "CI sostituente" \
    -widget text \
    -datatype text \
    -html    "size 3 maxlength 3 $readonly_fld {} class form_element" \
    -optional

element create $form_name lunghezza \
    -label   "Lunghezza" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name superficie \
    -label   "Superficie" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name profondita \
    -label   "Profondita" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional


element create $form_name cod_circ_inte_aimp  -widget hidden -datatype text -optional
element create $form_name funzione            -widget hidden -datatype text -optional
element create $form_name caller              -widget hidden -datatype text -optional
element create $form_name nome_funz           -widget hidden -datatype text -optional
element create $form_name nome_funz_caller    -widget hidden -datatype text -optional
element create $form_name extra_par           -widget hidden -datatype text -optional
element create $form_name cod_impianto        -widget hidden -datatype text -optional
element create $form_name url_list_aimp       -widget hidden -datatype text -optional
element create $form_name url_aimp            -widget hidden -datatype text -optional

element create $form_name submit              -widget submit -datatype text -label "$button_label" -html "class form_submit"


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
	# propongo il numero del nuovo generatore con il max + 1
        db_1row query "
        select coalesce(max(num_ci),0) + 1 as num_ci
          from coimcirc_inte_aimp
         where cod_impianto = :cod_impianto"

        element set_properties $form_name num_ci -value $num_ci

	db_1row query "select nextval('coimcirc_inte_aimp_s') as cod_circ_inte_aimp"
	
	element set_properties $form_name cod_circ_inte_aimp -value $cod_circ_inte_aimp
	
    } else {

	# leggo riga
	if {[db_0or1row query "
             select a.cod_impianto
                  , a.num_ci
                  , iter_edit_data(a.data_installaz)   as data_installaz
                  , iter_edit_data(a.data_dismissione) as data_dismissione
                  , a.flag_sostituito --rom01
                  , iter_edit_num(a.lunghezza,2)       as lunghezza
                  , iter_edit_num(a.superficie,2)      as superficie
                  , iter_edit_num(a.profondita,2)      as profondita
                  , a.num_ci_sostituente --rom02
               from coimcirc_inte_aimp a
              where a.cod_circ_inte_aimp = :cod_circ_inte_aimp
        "] == 0
	} {
	    iter_return_complaint "Record non trovato"
	}

	element set_properties $form_name cod_circ_inte_aimp  -value $cod_circ_inte_aimp
	element set_properties $form_name cod_impianto        -value $cod_impianto
	element set_properties $form_name num_ci              -value $num_ci
        element set_properties $form_name data_installaz      -value $data_installaz
	element set_properties $form_name data_dismissione    -value $data_dismissione
	element set_properties $form_name flag_sostituito     -value $flag_sostituito;#rom01
	element set_properties $form_name lunghezza           -value $lunghezza
	element set_properties $form_name superficie          -value $superficie
        element set_properties $form_name profondita          -value $profondita
	element set_properties $form_name num_ci_sostituente  -value $num_ci_sostituente;#rom02
	
    }
}

if {[form is_valid $form_name]} {
 
    set cod_circ_inte_aimp   [element::get_value $form_name cod_circ_inte_aimp]
    set cod_impianto         [element::get_value $form_name cod_impianto]
    set num_ci               [element::get_value $form_name num_ci]
    set data_installaz       [element::get_value $form_name data_installaz]
    set data_dismissione     [element::get_value $form_name data_dismissione]
    set flag_sostituito      [element::get_value $form_name flag_sostituito];#rom01
    set lunghezza            [element::get_value $form_name lunghezza]
    set superficie           [element::get_value $form_name superficie]
    set profondita           [element::get_value $form_name profondita]
    set num_ci_sostituente   [element::get_value $form_name num_ci_sostituente];#rom02
    
    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    
    if {$funzione == "I" || $funzione == "M"} {   
	
        if {[string is space $data_installaz]} {
            element::set_error $form_name data_installaz "Inserire Data installazione"
            incr error_num
        } else {
	    set data_installaz [iter_check_date $data_installaz]
	    if {$data_installaz == 0} {
		element::set_error $form_name data_installaz "Inserire correttamente"
		incr error_num
	    }
	}
	
	if {![string is space $data_dismissione]} {
	    set data_dismissione [iter_check_date $data_dismissione]
	    if {$data_dismissione == 0} {
                element::set_error $form_name data_dismissione "Inserire correttamente"
                incr error_num
	    }
	}

	if {![string is space $data_dismissione] && $flag_sostituito ne "t"} {#rom01 aggiunta if e contenuto
	    element::set_error $form_name flag_sostituito "Selezionare \"Si\" se \"Data dismissione\" &egrave; compilata"
	       incr error_num
	} 
	if {[string is space $data_dismissione] && $flag_sostituito ne "f"} {#rom01 aggiunta if e contenuto
	    element::set_error $form_name flag_sostituito "Selezionare \"Si\" solo se \"Data dismissione\" &egrave; compilata"
	    incr error_num
        }

	if {$lunghezza ne ""} {
	    set lunghezza [iter_check_num $lunghezza 2]
	    if {$lunghezza == "Error"} {
                element::set_error $form_name lunghezza "Deve essere numerico, max 2 dec"
                incr error_num
	    } elseif {$lunghezza < 0.01} {
		element::set_error $form_name lunghezza "Deve essere > di 0,00"
		incr error_num
	    } elseif {[iter_set_double $lunghezza] >=  [expr pow(10,7)]
		  ||  [iter_set_double $lunghezza] <= -[expr pow(10,7)]
		  } {
		element::set_error $form_name lunghezza "Deve essere < di 10.000.000"
		incr error_num
	    }
	}

	if {$superficie ne ""} {
	    set superficie [iter_check_num $superficie 2]
	    if {$superficie == "Error"} {
                element::set_error $form_name superficie "Deve essere numerico, max 2 dec"
                incr error_num
	    } elseif {$superficie < 0.01} {
		element::set_error $form_name superficie "Deve essere > di 0,00"
		incr error_num
	    } elseif {[iter_set_double $superficie] >=  [expr pow(10,7)]
		  ||  [iter_set_double $superficie] <= -[expr pow(10,7)]
		  } {
		element::set_error $form_name superficie "Deve essere < di 10.000.000"
		incr error_num
	    }
	}
     
        if {$profondita ne ""} {
            set profondita [iter_check_num $profondita 2]
            if {$profondita == "Error"} {
                element::set_error $form_name profondita "Deve essere numerico, max 2 dec"
                incr error_num
            } elseif {$profondita < 0.01} {
                element::set_error $form_name profondita "Deve essere > di 0,00"
                incr error_num
            } elseif {[iter_set_double $profondita] >=  [expr pow(10,7)]
		      ||  [iter_set_double $profondita] <= -[expr pow(10,7)]
                  } {
                element::set_error $form_name profondita "Deve essere < di 10.000.000"
                incr error_num
            }
        }

	if {![string is space $num_ci_sostituente]} {#rom02 if e contenuto
	    set num_ci_sostituente [iter_check_num $num_ci_sostituente 0]
	    if {$num_ci_sostituente == "Error" || [db_0or1row q "select 1 
                                                                   from coimcirc_inte_aimp
                                                                  where num_ci = :num_ci 
                                                                    and cod_impianto = :cod_impianto
                                                                    and num_ci = :num_ci_sostituente
                                                                     or :num_ci = :num_ci_sostituente
                                                                     or :num_ci_sostituente = 0 limit 1"] == 1} {
		element::set_error $form_name num_ci_sostituente "Deve essere un numero intero diverso da 0 e da se stesso"
		incr error_num
	    } 
	};#rom02
	if { [string is space $num_ci_sostituente] && $flag_sostituito eq "t"} {#rom02 if, elseif e contenuto
	    element::set_error $form_name num_ci_sostituente "Inserire quale sarà il CI sostituente"
	    incr error_num
	} elseif {![string is space $num_ci_sostituente] && $flag_sostituito ne "t"} {
	    element::set_error $form_name num_ci_sostituente "Inserire solo se si sostituisce il CI"
	    incr error_num
	};#rom02

	
    }

    if {$error_num > 0} {
	#[template::form::get_errors $form_name]
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
                      into coimcirc_inte_aimp 
                         ( cod_circ_inte_aimp
                         , cod_impianto
                         , num_ci
                         , data_installaz
                         , data_dismissione
                         , flag_sostituito --rom01
                         , lunghezza
                         , superficie
                         , profondita
                         , data_ins
                         , utente_ins
                         , num_ci_sostituente --rom02
                         )
                    values 
                         (:cod_circ_inte_aimp
                         ,:cod_impianto
                         ,:num_ci
                         ,:data_installaz
                         ,:data_dismissione
                         ,:flag_sostituito --rom01
                         ,:lunghezza
                         ,:superficie
                         ,:profondita
                         ,:current_date
                         ,:id_utente
                         ,:num_ci_sostituente --rom02
                      )"
		}
		M {
		    db_dml query "
                    update coimcirc_inte_aimp
                       set data_installaz   = :data_installaz
                         , data_dismissione = :data_dismissione
                         , flag_sostituito  = :flag_sostituito --rom01
                         , lunghezza        = :lunghezza
                         , superficie       = :superficie
                         , profondita       = :profondita
                         , data_mod         = current_date
                         , utente_mod       = :id_utente
                         , num_ci_sostituente = :num_ci_sostituente --rom02
                     where cod_circ_inte_aimp = :cod_circ_inte_aimp"
		}
		D {
		    db_dml query "
                    delete
                      from coimcirc_inte_aimp
                     where cod_circ_inte_aimp = :cod_circ_inte_aimp"
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
    set link_gest      [export_url_vars cod_impianto cod_inte_circ_aimp nome_funz nome_funz_caller url_list_aimp url_aimp ]
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
