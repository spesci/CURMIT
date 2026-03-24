ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimvent_aimp"
    @author          Francesco Vibert - clonato da coimaccu-aimp-gest
    @creation-date   15/09/2016
    
    @param funzione  I=insert M=edit D=delete V=view
    
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar
    
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimaccu-aimp-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 22/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_installaz, data_dismissione.
    gac01 21/12/2018 Aggiunto num_vm_costituente

    rom01 04/09/2018 Aggiunto flag_sostituito, cambiata grandezza campo  note_tipologia_altro
    
} {
    {cod_vent_aimp               ""}
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

set link_gest [export_url_vars cod_vent_aimp cod_impianto nome_funz nome_funz_caller url_list_aimp url_aimp extra_par caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_vent_aimp cod_impianto caller nome_funz_caller nome_funz url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set current_date     [iter_set_sysdate]

set titolo              "Impianto di ventilazione"
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
set form_name    "coimvent_aimp"
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

element create $form_name num_vm \
    -label   "Numero" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 readonly {} class form_element" \
    -optional

#gac01
element create $form_name  num_vm_sostituente \
    -label   "VM sostituente" \
    -widget   text \
    -datatype text \
    -html    "size 3 maxlength 3 $readonly_fld {} class form_element" \
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

element create $form_name cod_cost \
    -label   "costruttore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcost cod_cost descr_cost]

element create $form_name modello \
    -label   "Modello" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional \
	
element create $form_name tipologia \
    -label   "Tipologia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Sola estrazione" S} {"Flusso doppio con recupero tramite scambiatore a flussi incrociati" I} {"Flusso doppio con recupero termodinamico" T} {"Altro" A}}
#rom01 cambiato -html, prima era  "cols 100 rows 3 $readonly_fld {} class form_element"
element create $form_name note_tipologia_altro \
    -label   "Note altro" \
    -widget   textarea \
    -datatype text \
    -html    "cols 57 rows 2 $readonly_fld {} class form_element" \
    -optional
	
element create $form_name portata_aria \
    -label   "Massima portata aria (m&sup3;/h)" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name rendimento_rec \
    -label   "Rendimento di recupero / COP" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_vent_aimp       -widget hidden -datatype text -optional
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
        select coalesce(max(num_vm),0) + 1 as num_vm
          from coimvent_aimp
         where cod_impianto = :cod_impianto"

        element set_properties $form_name num_vm -value $num_vm

	db_1row query "select nextval('coimvent_aimp_s') as cod_vent_aimp"
	
	element set_properties $form_name cod_vent_aimp -value $cod_vent_aimp
	
    } else {

	# leggo riga
	if {[db_0or1row query "
             select a.cod_impianto
                  , a.num_vm
                  , iter_edit_data(a.data_installaz) as data_installaz
                  , iter_edit_data(a.data_dismissione) as data_dismissione
                  , a.flag_sostituito --rom01
                  , a.cod_cost
		  , a.modello
		  , a.tipologia
		  , note_tipologia_altro
		  , iter_edit_num(a.portata_aria, 2) as portata_aria
                  , iter_edit_num(a.rendimento_rec, 2) as rendimento_rec
                  , a.num_vm_sostituente --gac01
	       from coimvent_aimp a
          left join coimcost b
                 on b.cod_cost = a.cod_cost
	      where a.cod_vent_aimp = :cod_vent_aimp
        "] == 0
	} {
	    iter_return_complaint "Record non trovato"
	}
	
	element set_properties $form_name cod_vent_aimp        -value $cod_vent_aimp
	element set_properties $form_name cod_impianto         -value $cod_impianto
	element set_properties $form_name num_vm               -value $num_vm
	element set_properties $form_name data_installaz       -value $data_installaz
	element set_properties $form_name data_dismissione     -value $data_dismissione
	element set_properties $form_name flag_sostituito     -value $flag_sostituito ;#rom01
	element set_properties $form_name cod_cost             -value $cod_cost
	element set_properties $form_name modello              -value $modello
	element set_properties $form_name tipologia            -value $tipologia
	element set_properties $form_name note_tipologia_altro -value $note_tipologia_altro
	element set_properties $form_name portata_aria         -value $portata_aria
	element set_properties $form_name rendimento_rec       -value $rendimento_rec
	element set_properties $form_name num_vm_sostituente -value $num_vm_sostituente;#gac01
    }
}

if {[form is_valid $form_name]} {
 
    set cod_vent_aimp   [element::get_value $form_name cod_vent_aimp]
    set cod_impianto         [element::get_value $form_name cod_impianto]
    set num_vm               [element::get_value $form_name num_vm]
    set data_installaz       [element::get_value $form_name data_installaz]
    set data_dismissione     [element::get_value $form_name data_dismissione]
    set flag_sostituito      [element::get_value $form_name flag_sostituito] ;#rom01
    set cod_cost             [element::get_value $form_name cod_cost]
    set modello              [element::get_value $form_name modello]
    set tipologia            [element::get_value $form_name tipologia]
    set note_tipologia_altro [string trim [element::get_value $form_name note_tipologia_altro]]
    set portata_aria         [element::get_value $form_name portata_aria]
    set rendimento_rec       [element::get_value $form_name rendimento_rec]
    set num_vm_sostituente   [element::get_value $form_name num_vm_sostituente];#gac01
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
	
	if {[string is space $cod_cost]} {
	    element::set_error $form_name cod_cost "Inserire fabbricante"
	    incr error_num
	}

	if {[string is space $modello]} {
	    element::set_error $form_name modello "Inserire modello"
	    incr error_num
	}
	
	if {[string is space $tipologia]} {
	    element::set_error $form_name tipologia "Inserire tipologia"
	    incr error_num
	}
	
	if {$tipologia eq "A" && [string is space $note_tipologia_altro]} {
	    template::form::set_error $form_name note_tipologia_altro "Compilare \"Note Altro\" specificando il tipo di emissione alternativo"
	    incr error_num
	} 
	
	if {$tipologia ne "A" && ![string is space $note_tipologia_altro]} {
            template::form::set_error $form_name note_tipologia_altro "Compilare solo in caso di tipo emissione = \"Altro\""
            incr error_num
    }

	if {$portata_aria ne ""} {
	    set portata_aria [iter_check_num $portata_aria 2]
	    if {$portata_aria == "Error"} {
                element::set_error $form_name portata_aria "Deve essere numerico, max 2 dec"
                incr error_num
	    } elseif {$portata_aria < 0.01} {
		element::set_error $form_name portata_aria "Deve essere > di 0,00"
		incr error_num
	    } elseif {[iter_set_double $portata_aria] >=  [expr pow(10,7)]
		  ||  [iter_set_double $portata_aria] <= -[expr pow(10,7)]
		  } {
		element::set_error $form_name portata_aria "Deve essere < di 10.000.000"
		incr error_num
	    }
	}

	if {$rendimento_rec ne ""} {
	    set rendimento_rec [iter_check_num $rendimento_rec 2]
	    if {$rendimento_rec == "Error"} {
                element::set_error $form_name rendimento_rec "Deve essere numerico, max 2 dec"
                incr error_num
	    } elseif {$rendimento_rec < 0.01} {
		element::set_error $form_name rendimento_rec "Deve essere > di 0,00"
		incr error_num
	    } elseif {[iter_set_double $rendimento_rec] >=  [expr pow(10,7)]
		  ||  [iter_set_double $rendimento_rec] <= -[expr pow(10,7)]
		  } {
		element::set_error $form_name rendimento_rec "Deve essere < di 10.000.000"
		incr error_num
	    }
	}
	if {![string is space $num_vm_sostituente]} {#gac01 if e contenuto
	    set num_vm_sostituente [iter_check_num $num_vm_sostituente 0]
	    if {$num_vm_sostituente == "Error" || [db_0or1row q "select 1 
                                                                   from coimvent_aimp
                                                                  where num_vm = :num_vm 
                                                                    and cod_impianto = :cod_impianto
                                                                    and num_vm = :num_vm_sostituente
                                                                     or :num_vm = :num_vm_sostituente
                                                                     or :num_vm_sostituente = 0 limit 1"] == 1} {
		element::set_error $form_name num_vm_sostituente "Deve essere un numero intero diverso da 0 e da se stesso"
		incr error_num
	    } 
	};#gac01
	if { [string is space $num_vm_sostituente] && $flag_sostituito eq "t"} {#gac01 if, elseif e contenuto
	    element::set_error $form_name num_vm_sostituente "Inserire quale sarà l'VM sostituente"
	    incr error_num
	} elseif {![string is space $num_vm_sostituente] && $flag_sostituito ne "t"} {
	    element::set_error $form_name num_vm_sostituente "Inserire solo se si sostituisce l'VM"
	    incr error_num
	};#gac01
	
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
                      into coimvent_aimp 
                         ( cod_vent_aimp
                         , cod_impianto
                         , num_vm
                         , data_installaz
                         , data_dismissione
                         , flag_sostituito --rom01
			 , cod_cost
                         , modello
         		 , tipologia
			 , note_tipologia_altro
			 , portata_aria
			 , rendimento_rec
	         	 , data_ins
                         , utente_ins
                         , num_vm_sostituente --gac01
                         )
                    values 
                         (:cod_vent_aimp
                         ,:cod_impianto
                         ,:num_vm
                         ,:data_installaz
                         ,:data_dismissione
                         ,:flag_sostituito --rom01
			 ,:cod_cost
                         ,:modello
			 ,:tipologia
			 ,:note_tipologia_altro
			 ,:portata_aria
			 ,:rendimento_rec
                         ,:current_date
                         ,:id_utente
                         ,:num_vm_sostituente --gac01
                      )"
		}
		M {
		    db_dml query "
                    update coimvent_aimp
                       set data_installaz       = :data_installaz
                         , data_dismissione     = :data_dismissione
                         , flag_sostituito      = :flag_sostituito --rom01
			 , cod_cost             = :cod_cost
                         , modello              = :modello
			 , tipologia            = :tipologia
			 , note_tipologia_altro = :note_tipologia_altro
			 , portata_aria         = :portata_aria
			 , rendimento_rec       = :rendimento_rec
                         , data_mod             = current_date
                         , utente_mod           = :id_utente
                         , num_vm_sostituente   = :num_vm_sostituente--gac01

                     where cod_vent_aimp   = :cod_vent_aimp"
		}
		D {
		    db_dml query "
                    delete
                      from coimvent_aimp
                     where cod_vent_aimp = :cod_vent_aimp"
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
    set link_gest      [export_url_vars cod_impianto cod_vent_aimp nome_funz nome_funz_caller url_list_aimp url_aimp ]
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
