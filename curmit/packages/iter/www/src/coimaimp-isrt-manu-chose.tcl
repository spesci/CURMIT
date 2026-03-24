ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   11/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id           coimaimp-isrt-manu-chose.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    mat01 08/04/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.1

    rom11 24/01/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    rom11            OpenACS 5.10.1

    ric01 14/03/2023 Solo per Palermo aggiunto controllo in fase di inserimento di un nuovo impianto,
    ric01            se presente più di un impianto in carico senza RCEE non permetto l'inserimento.

    rom10 03/08/2022 Modifiche per allineamento enti di Ucit al nuovo cvs, i controlli sulle abilitazioni
    rom10            vanno fatti in base al parametro flag_controllo_abilitazioni.

    rom09 13/01/2022 Su segnalazione di Sandro e Regione Marche il pod e' sempre obbligatorio
    rom09            se il combustibile e' GPL o GNL.

    rom08 08/04/2019 I campi pod e pdr sono resi visibili solo per le MARCHE.

    rom07 05/02/2019 Se un manutentore prova a inserire un impianto con caratteristiche uguali
    rom07            a un altro impianto già censito lo blocco.

    rom06 18/12/2018 La Regione Marche ha chiesto di non avere più obbligatori i campi pod e pdr.

    gac02 14/12/2018 Aggiunto warning al campo targa al posto del blocco in caso di inserimento
    gac02            di un impianto della stessa tipologia di uno già esistente con la stessa targa.

    rom05 13/09/2018 Sandro ha detto che il campo POD è obbligatorio se sto inserendo un impianto 
    rom05            con combustibile a gas e a catasto esiste già un PDR come quello che si sta inserendo.
    rom05            Per tutti gli altri tipi di combustibile il campo è sempre obbligatorio.
    rom05            In base al tipo impianto che si seleziona faccio vedere solo certi combustibili
    rom05            dopo il refresh della pagina.                                             
    rom05            Su richiesta della Regione Marche modificate le options del flag_tipo_impianto

    rom04 31/07/2018 Cambiate label per page_title e titolo. 

    rom03            aggiunto campo modello

    rom02            Visto che le marche hanno una gestione delle targhe differente faccio vedere 
    rom02            il campo già in fase di inserimento dell'impianto

    rom01            Aggiunti campi flag_conferma, pdr, pod, matricola, cod_cost, cod_combustibile 

    gac01 29/06/2018 Aggiunto refresh quando si seleziona un combustibile per permettere all'utente
    gac01            di selezionare solo i combustibili adatti ad un certo tipo di impianto

} {  
    {funzione             "I"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {flag_tipo_impianto       ""}
    {cod_combustibile    ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

set id_utente [lindex  [iter_check_login $lvl $nome_funz] 1]
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set titolo       "Inserimento nuovo impianto";#rom04
set button_label "Conferma"
set page_title   "Inserimento nuovo impianto";#rom04

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name "coimaimp"
set focus_field  ""
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)


set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
    -html    $onsubmit_cmd
if {$coimtgen(regione) eq "MARCHE"} {#rom08 aggiunta if ma non contenuto
element create $form_name pdr \
    -label   "PDR" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 14 $readonly_fld {} class form_element" \
    -optional

element create $form_name pod \
    -label   "POD" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
    -optional
} else {#rom08 aggiunta else e suo contenuto

element create $form_name pdr -widget hidden -datatype text -optional
element create $form_name pod -widget hidden -datatype text -optional
}

element create $form_name matricola \
    -label   "matricola" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 35 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_cost \
    -label   "cod_cost" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element " \
    -optional \
    -options [iter_selbox_from_table coimcost cod_cost descr_cost] \

set where_cod_combustibile "";#rom05
if {$flag_tipo_impianto eq "" || $flag_tipo_impianto eq "R"} {#rom05 aggiunta if, elseif e loro contenuto
set where_cod_combustibile "where cod_combustibile not in ('7','20','88')"
} elseif {$flag_tipo_impianto eq "T"} {
set where_cod_combustibile "where cod_combustibile='7'"
} elseif {$flag_tipo_impianto eq "C"} {
set where_cod_combustibile "where cod_combustibile='20'"
} elseif {$flag_tipo_impianto eq "F"} {
set where_cod_combustibile "where cod_combustibile='88'"
}
element create $form_name cod_combustibile \
    -label   "cod_combustibile" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimcomb cod_combustibile  descr_comb descr_comb "$where_cod_combustibile" ] \

set refresh_tipo_impianto "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_combustibile';document.$form_name.submit.click()";#gac01
#rom05 Sostitutita le optionssu richiesta delle Marche (Sandro ha detto che va bene per tutti).
#rom05 Prima era  -options {{Riscaldamento R} {Raffrescamento F} {Cogenerazione C} {Teleriscaldamento T}}
element create $form_name flag_tipo_impianto \
    -label   "flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html   "class form_element $refresh_tipo_impianto" \
    -optional \
    -options {{{Generatore a combustione} R} {{Pompa di calore / macchina frigorifera} F} {{Cogenerazione / trigenerazione} C} {{Teleriscaldamento / teleraffrescamento} T}}


#rom02 Visto che le marche hanno una gestione delle targhe differente faccio vedere il campo già in fase di inserimento dell'impianto
if {$coimtgen(regione) eq "MARCHE" } {#rom02 aggiunta if, else e loro contenuto
    element create $form_name targa \
        -label "targa" \
        -widget   text \
        -datatype text \
        -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
        -optional
} else {
    element create $form_name targa \
        -widget hidden \
        -datatype text \
        -optional
};#rom02
#rom03 aggiunto campo modello
element create $form_name modello \
    -label "modello" \
    -widget text \
    -datatype text \
    -html    "size 14 maxlength 40 $readonly_fld {} class form_element" \
    -optional



element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name flag_conferma        -widget hidden -datatype text -optional;#rom01
element create $form_name __refreshing_p   -widget hidden -datatype text -optional;#gac01
#element set_properties $form_name __refreshing_p   -value "0";#rom11
element create $form_name changed_field    -widget hidden -datatype text -optional;#gac01



#[element::get_value $form_name __refreshing_p]



if {[form is_request $form_name]} {

   
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name flag_conferma    -value "s";#rom01
    element set_properties $form_name __refreshing_p   -value "0";#gac01
    element set_properties $form_name changed_field    -value "";#gac01
    element set_properties $form_name cod_combustibile value $cod_combustibile
}

if {[form is_valid $form_name]} {
    #form valido dal punto di vista del templating system
    set error_num 0

    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    set pdr              [element::get_value $form_name pdr                 ];#rom01
    set pod              [element::get_value $form_name pod                 ];#rom01
    set matricola        [element::get_value $form_name matricola           ];#rom01
    set cod_cost         [element::get_value $form_name cod_cost            ];#rom01
    set cod_combustibile [element::get_value $form_name cod_combustibile    ];#rom01
    set flag_conferma    [element::get_value $form_name flag_conferma       ];#rom01
    set targa            [string trim [element::get_value $form_name targa  ]];#rom02
    set modello          [string trim [element::get_value $form_name modello]];#rom03
    set __refreshing_p   [element::get_value $form_name __refreshing_p];#gac01
    set changed_field    [element::get_value $form_name changed_field];#gac01
  
    if {$__refreshing_p eq "1"} {
	set error_num 1
	element set_properties $form_name __refreshing_p   -values "0"
#	ad_return_template
#        return
    }
    
    
    if { $flag_tipo_impianto == "R"} {
	set return_url "coimaimp-isrt-manu"
    }
    if { $flag_tipo_impianto == "F"} {
	set return_url "coimaimp-isrt-manu-fr"
    }
    if { $flag_tipo_impianto == "T"} {
        set return_url "coimaimp-isrt-manu-te"
    }
    if { $flag_tipo_impianto == "C"} {
        set return_url "coimaimp-isrt-manu-co"
    }
    if {[string equal $matricola ""]} {
           element::set_error $form_name matricola "Inserire matricola"
            incr error_num
    }
    
    if {$flag_conferma == "s"} {


	if {![string equal $matricola ""]} {
	    if {[db_0or1row query "select i.cod_impianto_est as cod_impianto_est_esistente from coimgend g, coimaimp i where g.cod_impianto = i.cod_impianto and matricola = :matricola limit 1"] == 1} {
		element::set_error $form_name matricola "Attenzione esiste a catasto un generatore sull'impianto<br>$cod_impianto_est_esistente con la stessa matricola. Confermi l'inserimento?"
		set controllo_impianto_matricola "t" 
		if {$error_num == 0} {
		    element set_properties $form_name flag_conferma -values "n" ;#mat01 corretto da -value a -values
		}
		incr error_num
	    }
	}
	if {$coimtgen(regione) eq "MARCHE"} {#rom08 aggiunta if ma non suo contenuto
	    if {![string equal $pdr ""]} {
		if {[db_0or1row query "select 1
                                 from coimaimp
                                where pdr = :pdr
                                limit 1"] == 1} {
		    element::set_error $form_name pdr "Attenzione esiste a catasto un impianto con lo stesso PDR.<br>Confermi l'inserimento?"
		    if {$error_num == 0} {
			element set_properties $form_name flag_conferma -values "n" ;#mat01 corretto da -value a -values
		    }
		    incr error_num
		    if {[string equal $pod ""]} {#rom05 aggiunta if e contenuto
			if {[db_0or1row q "select 1
                                             from coimcomb
                                            where tipo = 'G'
                                              and cod_combustibile = :cod_combustibile"] == 1} {
			    element::set_error $form_name pod "Inserire POD"
			    incr error_num
			    element set_properties $form_name flag_conferma -values "s" ;#mat01 corretto da -value a -values
			}		    
		    };#rom05
		}
	    }
	    
	    if {![string equal $pod ""]} {
		
		if {[db_0or1row query "select 1
                                 from coimaimp
                                where pod = :pod
                                limit 1"] == 1} {
		    element::set_error $form_name pod "Attenzione esiste a catasto un impianto con lo stesso POD.<br>Confermi l'inserimento?"
		    if {$error_num == 0} {
			element set_properties $form_name flag_conferma -values "n" ;#mat01 corretto da -value a -values
		    }
		    incr error_num
		}	}
	}
    };#rom08
    
    if {[string equal $cod_cost ""]} {
	element::set_error $form_name cod_cost "Inserire costruttore generatore"
	incr error_num
    }
    if {[string equal $cod_combustibile ""]} {
	element::set_error $form_name cod_combustibile "Inserire combustibile"
	incr error_num
    }
    if {$coimtgen(regione) eq "MARCHE"} {#rom08 aggiunta if ma non suo contenuto
	if {[string equal $pdr ""]} {
	    if {[string equal $cod_combustibile "5"]} {
		element::set_error $form_name pdr "Inserire PDR"
		incr error_num
	    }
	}
	if {[string equal $pod ""]} {
	if {![db_0or1row q "select 1
                              from coimcomb
                             where tipo = 'G'
                               and cod_combustibile = :cod_combustibile"]} {#rom05 aggiunta if
	    element::set_error $form_name pod "Inserire POD"
	    incr error_num
	}
	    
	    if {$cod_combustibile in [list "4" "21"]} {#rom09 Aggiunta if e suo contenuto
		element::set_error $form_name pod "Inserire POD"
		incr error_num
	    }
	    
	    if {$flag_tipo_impianto eq "F"} {
		element::set_error $form_name pod "Inserire POD"
		incr error_num
	    }
	}
	if {![string equal $pdr ""]} {
	    set pdr [string trim $pdr]
	    if {[string length $pdr] != 14} {
	    element::set_error $form_name pdr "PDR deve essere di 14 caratteri"
		incr error_num
	    }
	}
	if {![string equal $pod ""]} {
	    set pod [string trim $pod]
	    if {[string length $pod] < 14 || [string length $pod] > 15 } {
		element::set_error $form_name pod "POD deve essere di 14 o 15 caratteri"
		incr error_num
	    }
	}
    };#rom08
    if {$flag_tipo_impianto eq "T" } {#rom01 if e suo contenuto
	if {$cod_combustibile ne "7"} {
	    element::set_error $form_name cod_combustibile "Selezionare il Combustibile 'Teleriscaladamento' per questa tipologia d'impianto"
	    incr error_num
	}
    };#rom01

    
    if {$coimtgen(flag_controllo_abilitazioni)} {#rom10 Aggiunta if ma non il suo contenuto
    if {$flag_tipo_impianto ne "" && $cod_combustibile ne "" && $cod_manutentore ne ""} {#rom01 if e suo contenuto
	set cod_coimtpin ""
	set descrizione_tpin ""
	
	set tipo_comb [db_string q "select tipo 
                                      from coimcomb 
                                     where cod_combustibile = :cod_combustibile" -default ""]

	if {$flag_tipo_impianto eq "F"} {

	    	if {![db_0or1row q "select 1
                              from coimtpin_manu
                             where cod_coimtpin    in (3,8)
                               and cod_manutentore = :cod_manutentore limit 1"]} {
		    
		   element::set_error $form_name flag_tipo_impianto "Utente non abilitato per l'inserimento<br>di \"Pompe di calore\""
		   incr error_num
	       }

	    
	} else {
	
	if {[db_0or1row q "select 1
                             from coimtpin_abilitazioni 
                            where flag_tipo_impianto = :flag_tipo_impianto
                              and tipo_combustibile is not null
                            limit 1"]} {

	    db_0or1row q "select a.cod_coimtpin
                               , b.descrizione as descrizione_tpin
                            from coimtpin_abilitazioni a
                              , coimtpin b
                           where a.flag_tipo_impianto = :flag_tipo_impianto
                             and a.tipo_combustibile  = :tipo_comb
                             and a.cod_coimtpin       = b.cod_coimtpin"
	    
	} else {
	    
	    db_0or1row q "select a.cod_coimtpin
                               , b.descrizione as descrizione_tpin
                            from coimtpin_abilitazioni a
                               , coimtpin b
                           where a.flag_tipo_impianto = :flag_tipo_impianto
                             and a.cod_coimtpin = b.cod_coimtpin"
	    
	}                                 
    
	if {![db_0or1row q "select 1
                              from coimtpin_manu
                             where cod_coimtpin    = :cod_coimtpin
                               and cod_manutentore = :cod_manutentore"]} {

	    element::set_error $form_name flag_tipo_impianto "Utente non abilitato per l'inserimento<br>di \"$descrizione_tpin\""
	    incr error_num
        }

    };#sim
	
    };#rom01
    };#rom10
    if {$coimtgen(regione) eq "MARCHE" && $targa ne ""} {#rom02 aggiunta if e suo contenuto
	if {[db_0or1row q "select targa as targa_padre
                                , flag_tipo_impianto as flag_impianto_padre
                             from coimaimp
                            where targa = :targa
                         group by flag_tipo_impianto 
                                , targa
                         limit 1"]
	} {
	    #controllo che per la targa inserita non ci siano già 2 impianti collegati.
	    if {[db_0or1row q "select count(*)  from coimaimp where targa = :targa having count(*) >= 2"]} {	
		set cod_impianti_coll [db_list q "select cod_impianto_est 
                                                    from coimaimp 
                                                   where targa = :targa"]
		#Hanno chiesto di rimuovere il controllo
		#element::set_error $form_name targa "Impossibile associare la targa a più di due impianti.<br>La targa è già asssociata agli impianti con codice [join $cod_impianti_coll { e }]"
		#incr error_num
	    }
	    #controllo che l'impianto già pressente non sia dello stesso tipo
	    if {$flag_conferma == "s"} {#gac02 aggiunto solo la if 
		if {$flag_impianto_padre eq $flag_tipo_impianto } {
		    #gac02		    element::set_error $form_name targa "Impossibile associare due<br>impianti della stessa tipologia"
		    element::set_error $form_name targa "Esiste già un impianto della stessa tipologia<br>Confermi l'inserimento?"
		    if {$error_num == 0} {#gac02
			element set_properties $form_name flag_conferma -values "n" ;#mat01 corretto da -value a -values
		    };#gac02
		    incr error_num
		}
	    };#gac02
	    set targa $targa_padre
	} else {
		#controllo che esista un impianto con la stessa targa
		element::set_error $form_name targa "Non esiste a catasto la targa indicata.<br>Impossibile associare il nuovo impianto ad un impianto già esistente"
	    incr error_num
		
	    }
    };#rom02
    if {$cod_manutentore ne ""} {#rom07 aggiunta if e suo contenuto
	if {(![string equal $matricola ""]) && (![string equal $pdr ""]) || (![string equal $pod ""])} {
	    if {[db_0or1row query "select i.cod_impianto_est as cod_impianto_est_esistente 
                                     from coimgend g, 
                                 coimaimp i 
                                    where g.cod_impianto = i.cod_impianto 
                                      and matricola = :matricola  
                                    limit 1"] == 1
		&& ([db_0or1row query "select 1
                                         from coimaimp
                                        where pdr = :pdr
                                        limit 1"] == 1
		    ||  [db_0or1row query "select 1
                                             from coimaimp
                                            where pod = :pod
                                            limit 1"] == 1)
	    } {
		element::set_error $form_name flag_tipo_impianto "Attenzione impianto censito con queste caratteristiche,<br>utilizzare la funzione \"Acquisizione Impianti\" oppure<br>contatta il soggetto esecutore/ente competente per chiarimenti."
		incr error_num
	    }
	}

	if {$coimtgen(ente) eq "PPA"} {#ric01 aggiunta if e suo contenuto

	    #ric01 conto gli impianti attivi in carico al manutentore senza rcee
	    #ric01 inseriti dopo la partenza in produzione.
	    db_1row q "select count(*) as num_imp_no_dich
                         from coimaimp     
                        where cod_manutentore = :cod_manutentore
                          and ((flag_tipo_impianto = 'R' and potenza > '10.0')
	                   or  (flag_tipo_impianto = 'F' and potenza > '12.0'))
                          and data_ins > '2022-11-14'
                          and stato = 'A'
                          and data_prima_dich is null
                          and data_ultim_dich is null"

	    if {$num_imp_no_dich > 1} {#ric01 aggiunta if e suo contenuto
		element::set_error $form_name cod_combustibile "Attenzione non è possibile procedere con l'inserimento perchè esiste più di un impianto senza RCEE <br> si prega di provvedere con l'inserimento."
		incr error_num
	    }
	}
	
    };#rom07
    if {$error_num > 0} {
#	set __refreshing_prova   [element::get_value $form_name __refreshing_p]
#	$__refreshing_prova
        ad_return_template
        return
    }

    #rom01 set link [export_url_vars  flag_tipo_impianto nome_funz nome_funz_caller]
    set link [export_url_vars  flag_tipo_impianto nome_funz nome_funz_caller pod pdr matricola cod_cost cod_combustibile targa modello]
    set return_url "$return_url?$link"    
    
    ad_returnredirect $return_url 
    ad_script_abort
}

ad_return_template
