ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcamp_sola_aimp"
    @author          Gabriele Lo Vaglio - clonato da coimaimp-tratt-acqua-gest
    @creation-date   06/07/2016
    
    @param funzione  I=insert M=edit D=delete V=view
    
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimcamp-sola-aimp-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 22/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_installaz, data_installaz_nuova_conf.
    rom02 21/12/2018 Aggiunto il campo num_cs_sostituente
    rom01 07/11/2018 Aggiunti i campi data_installaz_nuova_conf e flag_sostituito
    
} {
    {cod_camp_sola_aimp     ""}
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

set link_gest [export_url_vars cod_camp_sola_aimp cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_camp_sola_aimp cod_impianto caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set current_date     [iter_set_sysdate]

set titolo              "Campo Solare Termico"
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
set form_name    "coimcamp_sola_aimp"
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

element create $form_name num_cs \
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
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
    -optional

#rom01
#but01
element create $form_name data_installaz_nuova_conf \
    -label   "Data installazione nuova configurazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
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
element create $form_name num_cs_sostituente \
    -label "CS sostituente" \
    -widget   text \
    -datatype text \
    -html    "size 3 maxlength 3 $readonly_fld {} class form_element" \
    -optional \

element create $form_name cod_cost \
    -label   "costruttore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcost cod_cost descr_cost] 
    
element create $form_name collettori \
    -label   "Collettori" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional \
    
element create $form_name sup_totale \
    -label   "Superficie totale di apertura" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional


element create $form_name cod_camp_sola_aimp  -widget hidden -datatype text -optional
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
        select coalesce(max(num_cs),0) + 1 as num_cs
          from coimcamp_sola_aimp
         where cod_impianto = :cod_impianto"

        element set_properties $form_name num_cs -value $num_cs

	db_1row query "select nextval('coimcamp_sola_aimp_s') as cod_camp_sola_aimp"
       
	element set_properties $form_name cod_camp_sola_aimp -value $cod_camp_sola_aimp

    } else {

	# leggo riga
	if {[db_0or1row query "
             select a.cod_impianto
                  , a.num_cs
                  , iter_edit_data(a.data_installaz) as data_installaz
                  , iter_edit_data(a.data_installaz_nuova_conf) as data_installaz_nuova_conf --rom01
                  , a.flag_sostituito --rom01
                  , a.num_cs_sostituente --rom02
                  , a.cod_cost
                  , a.collettori
                  , iter_edit_num(a.sup_totale, 2) as sup_totale
                  , b.descr_cost
               from coimcamp_sola_aimp a
          left join coimcost b
                 on b.cod_cost = a.cod_cost
              where a.cod_camp_sola_aimp = :cod_camp_sola_aimp
        "] == 0
	} {
	    iter_return_complaint "Record non trovato"
	}

	element set_properties $form_name cod_camp_sola_aimp  -value $cod_camp_sola_aimp
	element set_properties $form_name cod_impianto        -value $cod_impianto
	element set_properties $form_name num_cs              -value $num_cs
        element set_properties $form_name data_installaz      -value $data_installaz
	element set_properties $form_name data_installaz_nuova_conf  -value $data_installaz_nuova_conf;#rom01
        element set_properties $form_name flag_sostituito     -value $flag_sostituito ;#rom01
	element set_properties $form_name num_cs_sostituente  -value $num_cs_sostituente;#rom02
	element set_properties $form_name cod_cost            -value $cod_cost
	element set_properties $form_name collettori          -value $collettori
        element set_properties $form_name sup_totale          -value $sup_totale
	
    }
}


if {[form is_valid $form_name]} {
 
    set cod_recu_cond_aimp   [element::get_value $form_name cod_camp_sola_aimp]
    set cod_impianto         [element::get_value $form_name cod_impianto]
    set num_cs               [element::get_value $form_name num_cs]
    set data_installaz       [element::get_value $form_name data_installaz]
    set data_installaz_nuova_conf [element::get_value $form_name data_installaz_nuova_conf];#rom01
    set flag_sostituito      [element::get_value $form_name flag_sostituito] ;#rom01
    set num_cs_sostituente   [element::get_value $form_name num_cs_sostituente];#rom02
    set cod_cost             [element::get_value $form_name cod_cost]
    set collettori           [element::get_value $form_name collettori]
    set sup_totale           [element::get_value $form_name sup_totale]
    
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

	if {![string is space $data_installaz_nuova_conf]} {#rom01 if e contenuto
	    set data_installaz_nuova_conf [iter_check_date $data_installaz_nuova_conf]
	    if {$data_installaz_nuova_conf == 0} {
		element::set_error $form_name data_installaz_nuova_conf  "Inserire correttamente"
		incr error_num
	    }
	}
	
	if {![string is space $data_installaz_nuova_conf] && $flag_sostituito ne "t"} {#rom01 aggiunta if e contenuto
	    element::set_error $form_name flag_sostituito "Selezionare \"Si\" se \"Data installazione nuova configurazione\" &egrave; compilata"
	    incr error_num
	}
	if {[string is space $data_installaz_nuova_conf] && $flag_sostituito ne "f"} {#rom01 aggiunta if e contenuto
	    element::set_error $form_name flag_sostituito "Selezionare \"Si\" solo se \"Data installazione nuova configurazione\" &egrave; compilata"
	    incr error_num
	}
	
        if {[string is space $cod_cost]} {
            element::set_error $form_name cod_cost "Inserire fabbricante"
            incr error_num
        }
	
	if {$collettori ne ""} {
	    if {![string is integer $collettori]} {
		template::form::set_error coimcamp_sola_aimp collettori "Deve essere un numero intero."
		incr error_num
	    }
	}

	if {$sup_totale ne ""} {
	    set sup_totale [iter_check_num $sup_totale 2]
	    if {$sup_totale == "Error"} {
                element::set_error $form_name sup_totale "Deve essere numerico, max 2 dec"
                incr error_num
            } elseif {$sup_totale < 0.01} {
                element::set_error $form_name sup_totale "Deve essere > di 0,00"
                incr error_num
            } elseif {[iter_set_double $sup_totale] >=  [expr pow(10,7)]
		  ||  [iter_set_double $sup_totale] <= -[expr pow(10,7)]
                  } {
                element::set_error $form_name sup_totale "Deve essere < di 10.000.000"
                incr error_num
            }
	}

	if {![string is space $num_cs_sostituente]} {#rom02 if e contenuto
	    set num_cs_sostituente [iter_check_num $num_cs_sostituente 0]
	    if {$num_cs_sostituente == "Error" || [db_0or1row q "select 1 
                                                                   from coimcamp_sola_aimp
                                                                  where num_cs = :num_cs 
                                                                    and cod_impianto = :cod_impianto
                                                                    and num_cs = :num_cs_sostituente
                                                                     or :num_cs = :num_cs_sostituente
                                                                     or :num_cs_sostituente = 0 limit 1"] == 1} {
		element::set_error $form_name num_cs_sostituente "Deve essere un numero intero diverso da 0 e da se stesso"
		incr error_num
	    } 
	};#rom02
	if { [string is space $num_cs_sostituente] && $flag_sostituito eq "t"} {#rom02 if, elseif e contenuto
	    element::set_error $form_name num_cs_sostituente "Inserire quale sar&agrave; il CS sostituente"
	    incr error_num
	} elseif {![string is space $num_cs_sostituente] && $flag_sostituito ne "t"} {
	    element::set_error $form_name num_cs_sostituente "Inserire solo se si sostituisce il CS"
	    incr error_num
	};#rom02
	
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
                      into coimcamp_sola_aimp 
                         ( cod_camp_sola_aimp
                         , cod_impianto
                         , num_cs
                         , data_installaz
                         , cod_cost
                         , collettori
                         , sup_totale
                         , data_ins
                         , utente_ins
                         , data_installaz_nuova_conf --rom01
                         , flag_sostituito  --rom01
                         , num_cs_sostituente --rom02
                         )
                    values 
                         (:cod_camp_sola_aimp
                         ,:cod_impianto
                         ,:num_cs
                         ,:data_installaz
                         ,:cod_cost
                         ,:collettori
                         ,:sup_totale
                         ,:current_date
                         ,:id_utente
                         ,:data_installaz_nuova_conf --rom01
                         ,:flag_sostituito  --rom01
                         ,:num_cs_sostituente --rom02
                         )"
		}
		M {
		    db_dml query "
                    update coimcamp_sola_aimp
                       set data_installaz   = :data_installaz
                         , cod_cost         = :cod_cost
                         , collettori       = :collettori
                         , sup_totale       = :sup_totale
                         , data_mod         = current_date
                         , utente_mod       = :id_utente
                         , data_installaz_nuova_conf   = :data_installaz_nuova_conf --rom01
                         , flag_sostituito             = :flag_sostituito           --rom01
                         , num_cs_sostituente          = :num_cs_sostituente  --rom02
                     where cod_camp_sola_aimp = :cod_camp_sola_aimp"
		}
		D {
		    db_dml query "
                    delete
                      from coimcamp_sola_aimp
                     where cod_camp_sola_aimp = :cod_camp_sola_aimp"
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
    set link_gest      [export_url_vars cod_impianto cod_camp_sola_aimp nome_funz nome_funz_caller url_list_aimp url_aimp ]
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

