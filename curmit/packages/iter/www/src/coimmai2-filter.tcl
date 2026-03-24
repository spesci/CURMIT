ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   19/05/2005

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, serve per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    ric02 09/09/2025 Aggiunto campo f_cod_fiscale solo per regione Marche (punto 28 MEV).

    but01 26/11/2024  Modifica MEV aggiunto la lettera di civico campo "f_esponente".
    
    rom08 18/05/2023 Corretto intervento di ric01, settato vuoto il default della variabile where_targa
    rom08            per gli enti che non hanno la gestione delle targhe.

    rom07 16/05/2023 Basilicata deve avere il num_min_parametri impostato a 3.

    ric01 17/03/2023 Aggiunto campo f_targa, mostrato solo se l'ente gestisce le targhe, possibilità 
    ric01            di effettuare la ricerca/acquisizione esclusivamente tramite il numero di targa.
    ric01            Se si effettua tale ricerca il controllo sul numero minimo di campi non viene eseguito.

    rom06 24/01/2023 Ucit ha chiesto che il num_min_parametri per Regione Fiuli sia impostato a 3.

    rom05 27/07/2022 Riportata modifica fatta per il vecchio cvs per allinemanto di UCIT, i controlli
    rom05            delle abilitazioni vanno fatti in base al parametro flag_controllo_abilitazioni.

    rom04 17/12/2020 Messo un controllo sulle abilitazioni per gli impianti del freddo che era
    rom04            gia' presente in fase di inserimento di un nuovo impianto.

    sim02 22/11/2019 Anche la provincia di Fermo vuole poter indicare solo 3 campi per acquisire un impianto
    
    sim01 31/10/2019 Per Macerata,Civitanova e Ascoli Piceno sono stati portati a 3 i campi da indicare 

    rom03 29/11/2018 Se un manutentore prova ad acquisire un impianto già suo lo blocco.

    rom02 02/11/2018 Confermando l'inserimento non vengo più indirizzato direttamente sull'impianto
    rom02            ma in una pagina intermedia "coimaimp-gest-messaggio-intermedio".
    rom02            Per il momento lo faccio solo per la Regione Marche, va chiesto a Sandro se
    rom02            può andare bene per tutti.

    rom01 09/05/2019 Sviluppi per la BAT: aggiunti controlli che impediscono ad un manutentore
    rom01            di acquisire un impianto per cui non ha le abilitazioni.

    rom01M21/06/2018 Aggiunto campo f_numero_bollino, il Numero bollino inserito deve essere 
    rom01M           l'ultimo inserito nell'RCEE

} {
    
   {funzione            "V"}
   {caller          "index"}
   {nome_funz            ""}
   {nome_funz_caller     ""}

   {f_resp_cogn          ""} 
   {f_resp_nome          ""} 
   {f_cod_impianto_est   ""} 

   {f_comune             ""}

   {f_cod_via            ""}
   {f_desc_via           ""}
   {f_desc_topo          ""}
   {f_civico             ""}

   {f_matricola          ""}
   {f_modello            ""}
   {f_costruttore        ""}
   {f_pdr                ""}
   {f_numero_bollino     ""}
   {f_targa              ""}
   {f_esponente          ""}
   {f_stato_aimp        "A"}
   {cod_cittadino        ""}
   {flag_risultato       "f"}
   {f_cod_fiscale        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# controllo se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo se l'utente e' un ente verificatore o un verificatore
#set cod_enve [iter_check_uten_enve $id_utente]
#set cod_opve [iter_check_uten_opve $id_utente]

# Personalizzo la pagina
set titolo       "Acquisizione impianto esistente"
set button_label "Ricerca" 
set page_title   "Acquisizione impianto esistente"

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set flag_viario  $coimtgen(flag_viario)
set cod_comune   $coimtgen(cod_comu)
set sigla_prov   $coimtgen(sigla_prov)
set flag_gest_targa  $coimtgen(flag_gest_targa);#ric01
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

set num_min_parametri 4
#rom06 Tolte condizioni $coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"
if {$coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN"} {
    set num_min_parametri 4
}

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom06 Aggiunta if e il suo contenuto
    set num_min_parametri 3
}

if {$coimtgen(regione) eq "BASILICATA"} {#rom07 Aggiunta if e il suo contenuto
    set num_min_parametri 3
}

if {$coimtgen(ente) eq "CRIMINI"} {
    set num_min_parametri 1
}  

if {$coimtgen(ente) eq "PAP" || $coimtgen(ente) eq "CASCOLI PICENO" || $coimtgen(ente) eq "CMACERATA"  || $coimtgen(ente) eq "PMC"  || $coimtgen(ente) eq "CCIVITANOVA MARCHE" || $coimtgen(ente) eq "PFM"} {#sim01
    set num_min_parametri 3
}


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
-html    $onsubmit_cmd

element create $form_name f_cod_impianto_est \
-label   "Codice impianto esterno" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
-optional

element create $form_name f_resp_cogn \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name f_resp_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

if {$coimtgen(regione) eq "MARCHE"} {#ric02 aggiunta if e contenuto
    element create $form_name f_cod_fiscale \
	-label   "Cod.Fisc." \
	-widget   text \
	-datatype text \
	-html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
	-help_text {Inserisci il codice fiscale in alternativa a <b>Nome</b> e <b>Cognome</b>.} \
	-optional 
	
}

if {$flag_ente == "P"} {
    element create $form_name f_comune \
    -label   "Comune" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_comu]
} else {
    element create $form_name f_comune -widget hidden -datatype text -optional
}

element create $form_name f_desc_topo \
-label   "topos" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name f_desc_via \
-label   "Via" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name f_matricola \
-label   "Matricola" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 35 $readonly_fld {} class form_element" \
-optional

element create $form_name f_modello \
-label   "Modello" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name f_costruttore \
-label   "Costruttore" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimcost cod_cost descr_cost]

element create $form_name f_pdr \
-label   "PDR" \
-widget   text \
-datatype text \
-html    "size 18 maxlength 20 $readonly_fld {} class form_element" \
-optional


if {$flag_viario == "T"} {
    set cerca_viae [iter_search coimaimp [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_desc_via dummy f_desc_topo cod_comune f_comune dummy dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

element create $form_name f_civico \
-label   "Civico da" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 $readonly_fld {} class form_element" \
-optional

#but01 aggiunto la lettera di civico
element create $form_name f_esponente \
    -label   "esopnente" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 3 $readonly_fld {} class form_element" \
    -optional

#rom01M
element create $form_name f_numero_bollino \
    -laber  "Numero Bollino" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 35 $readonly_fld {} class form_element" \
    -optional

#ric01 aggiunto f_targa solo se gestita
if {$flag_gest_targa} {#ric01 aggiunta if e suo contenuto
    element create $form_name f_targa \
	-laber  "Numero di Targa" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 35 $readonly_fld {} class form_element" \
	-optional
}

element create $form_name f_cod_via   -widget hidden -datatype text -optional
#element create $form_name f_cod_manu  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {

    element set_properties $form_name funzione            -value $funzione
    element set_properties $form_name caller              -value $caller
    element set_properties $form_name nome_funz           -value $nome_funz

  # valorizzo i campi di mappa con i parametri ricevuti.
  # serve quando la lista ritorna al filtro.

    element set_properties $form_name f_cod_impianto_est -value $f_cod_impianto_est

    element set_properties $form_name f_resp_cogn        -value $f_resp_cogn
    element set_properties $form_name f_resp_nome        -value $f_resp_nome

    if {$coimtgen(regione) eq "MARCHE"} {#ric02 aggiunta if e contenuto
	element set_properties $form_name f_cod_fiscale      -value $f_cod_fiscale
    }
    
    if {$flag_ente == "P"} {
	element set_properties $form_name f_comune       -value $f_comune
    } else {
	element set_properties $form_name f_comune       -value $cod_comune
    }

    element set_properties $form_name f_cod_via          -value $f_cod_via
    element set_properties $form_name f_civico           -value $f_civico
    element set_properties $form_name f_desc_topo        -value $f_desc_topo
    element set_properties $form_name f_desc_via         -value $f_desc_via
    element set_properties $form_name f_matricola        -value $f_matricola
    element set_properties $form_name f_modello          -value $f_modello
    element set_properties $form_name f_costruttore      -value $f_costruttore
    element set_properties $form_name f_pdr              -value $f_pdr
    element set_properties $form_name f_numero_bollino   -value $f_numero_bollino;#rom01M
    element set_properties $form_name f_esponente        -value $f_esponente;#but01
    if {$flag_gest_targa} {#ric01 aggiunta if e suo contenuto
	element set_properties $form_name f_targa            -value $f_targa;#ric01
    }
}

if {[form is_valid $form_name]} {
#    iter_return_complaint "funzione non disponibile"
#    return
    # form valido dal punto di vista del templating system
    set f_cod_impianto_est [element::get_value $form_name f_cod_impianto_est]
    set f_resp_cogn        [element::get_value $form_name f_resp_cogn]
    set f_resp_nome        [element::get_value $form_name f_resp_nome]

    if {$coimtgen(regione) eq "MARCHE"} {#ric02 aggiunta if e contenuto
	set f_cod_fiscale   [string trim [element::get_value $form_name f_cod_fiscale]]
    }
    
    set f_comune           [element::get_value $form_name f_comune]
    set f_cod_via          [element::get_value $form_name f_cod_via]
    set f_desc_topo        [element::get_value $form_name f_desc_topo]
    set f_desc_via         [element::get_value $form_name f_desc_via]  
    set f_civico           [element::get_value $form_name f_civico]

    set f_matricola        [element::get_value $form_name f_matricola]
    set f_modello          [element::get_value $form_name f_modello]
    set f_costruttore      [element::get_value $form_name f_costruttore]
    set f_pdr              [element::get_value $form_name f_pdr]
    set f_numero_bollino   [element::get_value $form_name f_numero_bollino];#rom01M
    set f_esponente          [element::get_value $form_name f_esponente];#but01
    
    if {$flag_gest_targa} {#ric01 aggiunta if else e loro contenuto
	set f_targa            [element::get_value $form_name f_targa];#ric01
    } else {
	set f_targa ""
    }

    set error_num 0

    set sw_filtro_ind "t"

  # per capire se si e' cercato di fare un filtro per indirizzo,
  # per la Provincia e' sufficiente sapere se e' indicato il comune
  # per il Comune    e' necessario sapere se e' indicata la via

    if {$flag_ente == "P"} {
	if {[string equal $f_comune ""]} {
	    element::set_error $form_name f_comune "Inserire il comune"
	    incr error_num
	}
    }

    if {[string equal $f_desc_via ""]
    &&  [string equal $f_desc_topo ""]
    } {
	element::set_error $form_name f_desc_via "Inserire l'indirizzo"
	incr error_num
    }

    if {$coimtgen(ente) eq "CRIMINI"} {
	if {[string equal $f_cod_impianto_est ""] } {
	    element::set_error $form_name f_cod_impianto_est "Inserire il codice impianto"
	    incr error_num
	}
    }

    if {[string equal $f_resp_cogn ""]
    && ![string equal $f_resp_nome ""]
    } {
	element::set_error $form_name f_resp_cogn "Indicare anche il cognome"
	incr error_num
    }

    if {$coimtgen(regione) eq "MARCHE"} {#ric02 aggiunta if e contenuto    
	if {(![string equal $f_resp_nome ""] || ![string equal $f_resp_cogn ""]) && ![string equal $f_cod_fiscale ""]} {
	    element::set_error $form_name f_cod_fiscale "Indicare il codice fiscale in alternativa al responsabile."
	    incr error_num
	}
    }
    
  # si controlla la via solo se il primo test e' andato bene.
  # in questo modo si e' sicuri che f_comune e' stato valorizzato.

    if {$error_num        ==  0
    &&  $flag_viario      == "T"
    } {
	if {[string equal $f_desc_via  ""]
	&&  [string equal $f_desc_topo ""]
	} {
	    set f_cod_via ""
	} else {
	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $f_desc_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:f_desc_topo)"
	    }
	    if {[string equal $f_desc_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:f_desc_via)"
	    }
	    db_foreach sel_viae "" {
		incr ctr_viae
		if {$cod_via == $f_cod_via} {
		    set chk_out_cod_via $cod_via
		    set chk_out_rc       1
		}
	    }
            switch $ctr_viae {
 		0 { set chk_out_msg "Via non trovata"}
	 	1 { set chk_out_cod_via $cod_via
		    set chk_out_rc       1 }
	  default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovate pi&ugrave; vie: usa il link cerca"
		    }
 		}
	    }
            set f_cod_via $chk_out_cod_via
            if {$chk_out_rc == 0} {
                element::set_error $form_name f_desc_via $chk_out_msg
                incr error_num
	    }
	}
    } else {
	set f_cod_via ""
    }

    if {(    [string equal $f_desc_topo ""]
         &&  [string equal $f_desc_via  ""]
         &&  [string equal $f_cod_via   ""])
	 && ![string equal $f_civico    ""]
	&& ![string equal $f_esponente ""]
    } {#but01 aggiunto la modifica sul f_esponente
	element::set_error $form_name f_desc_via "La selezione per numero civico viene effettuata solo insieme alla selezione per via"
	incr error_num
    }
    set err_civico ""
    if {![string equal $f_civico ""]} {
	if {![string is integer $f_civico]} {
	    element::set_error $form_name f_civico "Civico deve essere un numero intero"
	    incr error_num
	}
    }

    set conta_parametri 0

    if {![string equal $f_civico ""]} {
	incr conta_parametri
	#set where_civico "and to_number(a.numero,'99999999') = :f_civico"
 	set where_civico "and a.numero = :f_civico"
	if {![string equal $f_esponente ""]} {#but01 Aggiunta if e contenuto
	    append where_civico " and a.esponente = :f_esponente"
	}
    } else {
	set where_civico ""
    }

    set where_cogn ""
    set where_nome ""
    set where_cod ""
    set where_via ""
    set where_impianto ""
    set where_pdr ""

    if {![string equal $f_cod_impianto_est ""] } {
	incr conta_parametri
	set where_impianto "and a.cod_impianto_est = :f_cod_impianto_est and a.stato = 'A'"
    } else {
	set where_impianto " and stato = 'A'"
    }

    if {![string equal $f_resp_cogn ""]
    ||  ![string equal $f_resp_nome ""]
    } {
	incr conta_parametri

	if {![string equal $f_resp_cogn ""]} {
	    set f_resp_cogn_1 [iter_search_word $f_resp_cogn]
	    set where_cogn  " and b.cognome like upper(:f_resp_cogn_1)"
	} else {
	    set where_cogn ""
	}

	if {![string equal $f_resp_nome ""]} {
	    incr conta_parametri
	    set where_nome "and b.nome like upper(:f_resp_nome)"
	} else {
	    set where_nome ""
	}
    }

    if {$coimtgen(regione) eq "MARCHE"} {##ric02 aggiunta if e contenuto
	if {![string equal $f_cod_fiscale ""] } {
	    incr conta_parametri
	    set where_cod_fiscale " and upper(b.cod_fiscale) = upper(:f_cod_fiscale)"
	} else {
	    set where_cod_fiscale ""
	}
    }

    if {![string equal $f_matricola ""] } {
	incr conta_parametri
	set where_matricola "and c.matricola = :f_matricola"
    } else {
	set where_matricola ""
    }

    if {![string equal $f_modello ""]} {
	incr conta_parametri
	set where_modello "and c.modello = :f_modello"
    } else {
	set where_modello ""
    }

    if {![string equal $f_costruttore ""]} {
	incr conta_parametri
	set where_costruttore "and c.cod_cost = :f_costruttore"
    } else {
	set where_costruttore ""
    }

    if {![string equal $f_pdr ""] } {
	incr conta_parametri
	set where_pdr "and a.pdr = :f_pdr and a.stato = 'A'"
    } else {
	set where_pdr ""
    }
    if {![string equal $f_numero_bollino ""]} {#rom01M if, else e loro contenuto
	        incr conta_parametri
        set where_bollino "and d.riferimento_pag = :f_numero_bollino"
    } else {
	set where_bollino ""
    };#rom01M
    
    if {$flag_gest_targa} {#ric01 aggiunta if e suo contenuto
	if {![string equal $f_targa ""]} {#ric01 aggiunta if else e loro contenuto
	    set conta_parametri 100
	    set where_targa "and a.targa = :f_targa"
	} else {
	    set where_targa ""
	}
    } else {#rom08 aggiunta else e contenuto
	set where_targa ""
    }

    set error_cod_fiscale "responsabile";#ric02
    set br_cod_fiscale "";#ric02
    if {$coimtgen(regione) eq "MARCHE"} {##ric02 aggiunta if e contenuto
	set error_cod_fiscale "cognome e nome o codice fiscale"
	set br_cod_fiscale "<br>"
    }
    
    if {$conta_parametri < $num_min_parametri} {
	#ric02 element::set_error $form_name f_civico "Inserire almeno $num_min_parametri parametri tra civico,<br>responsabile, matricola, modello , costruttore e numero bollino"
	element::set_error $form_name f_civico "Inserire almeno $num_min_parametri parametri tra civico,<br> $error_cod_fiscale, matricola,$br_cod_fiscale modello , costruttore e numero bollino";#ric02
	incr error_num
    }
    

    if {[db_0or1row q "select 1
                         from coimaimp a
                            , coimopma o 
                        where a.cod_manutentore  = o.cod_manutentore
                          and a.cod_impianto_est = :f_cod_impianto_est
                          and o.cod_opma         = :id_utente"]} {#rom03 if e contenuto
	element::set_error $form_name f_cod_impianto_est "Impianto gi&agrave; in carico al Manutentore, utilizzare la funzione \"Ricerca impianti gi&agrave; in carico al Manutentore\""
	incr error_num
    }
    
    if {$error_num > 0} {
        ad_return_template
        return
    }

    # imposto la condizione per gli impianti di un soggetto
    if {![string equal $cod_cittadino ""]} {
	set nome_funz_citt [iter_get_nomefunz coimcitt-gest]
	set sogg_join   [db_map sogg_join]
	set where_sogg  [db_map where_sogg]
	set ruolo [db_map ruolo_citt]
    } else {
	set nome_funz_citt ""
	set sogg_join      ""
	set where_sogg     ""
	set ruolo          ""
    }

    # imposto la condizione SQL per il comune e la via
    if {![string equal $f_comune ""]} {
	set where_comune "and a.cod_comune = :f_comune"
    } else {
	set where_comune ""
    }

    set where_via ""
    if {![string equal $f_cod_via ""]
	&&  $flag_viario == "T"
    } {
	set where_via "and a.cod_via = :f_cod_via"
    } 

    if {(![string equal $f_desc_via ""]
	 ||   ![string equal $f_desc_topo ""])
	&&  $flag_viario == "F"
    } {
	set f_desc_via1  [iter_search_word $f_desc_via]
	set f_desc_topo1 [iter_search_word $f_desc_topo]
	set where_via "and a.indirizzo like upper(:f_desc_via1)
                   and a.toponimo  like upper(:f_desc_topo1)"
    }
    
    # stabilisco l'ordinamento ed uso una inner join al posto di una outer join
    # sulle tabelle dove uso un filtro (Ottimizzazione solo per postgres)
    set citt_join_pos "left outer join"
    set citt_join_ora "(+)"

    if {![string equal $where_matricola ""]
    ||  ![string equal $where_modello ""]
    ||  ![string equal $where_costruttore ""]
    } {
	set gend_join_pos "left outer join  coimgend c on c.cod_impianto = a.cod_impianto
                                                      and c.flag_attivo = 'S' "
	set gend_join_ora1 ", coimgend c"
	set gend_join_ora2 "and c.cod_impianto = a.cod_impianto
                            and c.gen_prog_est = 1"
    } else {
	set gend_join_pos ""
	set gend_join_ora1 ""
	set gend_join_ora2 ""
    }
    if {![string equal $where_bollino ""]} {#rom01 if, esle e loro contenuto
	set join_bollino "left outer join coimdimp d on d.cod_impianto = a.cod_impianto"
    } else {
	set join_bollino ""
    };#rom01
    
    db_1row sel_conta_aimp ""

    ns_log notice "simone query= and a.cod_comune = $f_comune
           and a.cod_via = $f_cod_via
           and c.matricola = $f_matricola
           and c.modello = $f_modello

"

    if {$conta_num > 1} {
	set flag_risultato "t"
	set conta_num_edit [iter_edit_num $conta_num 0]
	set error_mex "<font color=red><b>Con i parametri impostati sono stati trovati $conta_num_edit impianti, inserire pi&ugrave; parametri di selezione</b></font>"
        ad_return_template
        return
    } else {
	if {$conta_num == 0} {
	    set flag_risultato "t"
	    set error_mex "<font color=red><b>Con i parametri impostati non sono stati trovati impianti, inserire altri parametri di selezione</b></font>"
	    ad_return_template
	    return
	} else {
	    if {$conta_num == 1} {
		if {[db_0or1row sel_cod_aimp ""] == 0} {
		    set cod_impianto ""
		}
		db_foreach q "select b.matricola
                                   , a.flag_tipo_impianto
 		                   , a.cod_combustibile
		                from coimaimp a
                                   , coimgend b
	                       where a.cod_impianto = :cod_impianto 
                                 and a.cod_impianto = b.cod_impianto
                             " {
	 	    
				 if {$coimtgen(flag_controllo_abilitazioni)} {#rom05 Aggiunta if ma non il contenuto			
                                     if {$flag_tipo_impianto ne "" && $cod_combustibile ne "" && $cod_manutentore ne ""} {#rom01 if e suo contenuto
					 set cod_coimtpin ""
					 set descrizione_tpin ""
					 set tipo_comb [db_string q "select tipo
                                                                       from coimcomb
                                                                      where cod_combustibile = :cod_combustibile" -default ""]

					 if {$flag_tipo_impianto eq "F"} {#rom04 ggiunta if e contenuto
					     if {![db_0or1row q "select 1
                                                                   from coimtpin_manu
                                                                  where cod_coimtpin    in (3,8)
                                                                   and cod_manutentore = :cod_manutentore limit 1"]} {
						 
						 element::set_error $form_name flag_tipo_impianto "Utente non abilitato per l'inserimento<br>di \"Pompe di calore\""
						 incr error_num
					     }
					 } else {#rom04 aggiunta else ma non contenuto
					     
                                         #rom01 aggiunta if else e suo contenuto
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
					     
                                         } else { #rom01
					     
					     db_0or1row q "select a.cod_coimtpin
                                                                , b.descrizione as descrizione_tpin
                                                             from coimtpin_abilitazioni a
                                                                , coimtpin b
                                                            where a.flag_tipo_impianto = :flag_tipo_impianto
                                                              and a.cod_coimtpin = b.cod_coimtpin"
					     
                                         };#rom01
                                         #rom01 aggiunta if e suo contenuto
					 if {![db_0or1row q "select 1
                                                               from coimtpin_manu
                                                              where cod_coimtpin    = :cod_coimtpin
                                                                and cod_manutentore = :cod_manutentore"]} {
					     
					     element::set_error $form_name f_cod_impianto_est "Utente non abilitato per l'acquisizione di un impianto <br>di \"$descrizione_tpin\""
					     incr error_num
					 }
				     };#fine rom04
				     };#fine rom01
				 };#rom05
			     };#fine foreach
		
                if {$error_num > 0} {#rom01 aggiunta if e suo contenuto
		    ad_return_template
		    return
		}
		if {$coimtgen(regione) eq "MARCHE"} {#rom02 aggiunta if e contenuto. Aggiunta else ma non contenuto
		    #ric02 set link_gest "[export_url_vars cod_impianto nome_funz_caller f_resp_cogn f_resp_nome f_comune f_cod_via f_desc_via f_desc_topo f_civico f_esponente f_matricola f_modello f_costruttore f_numero_bollino]&nome_funz=impianti&flag_assegnazione=t&caller=acquisizione"
		    #ric02 aggiunto f_cod_fiscale
		    set link_gest "[export_url_vars cod_impianto nome_funz_caller f_resp_cogn f_resp_nome f_cod_fiscale f_comune f_cod_via f_desc_via f_desc_topo f_civico f_esponente f_matricola f_modello f_costruttore f_numero_bollino]&nome_funz=impianti&flag_assegnazione=t&caller=acquisizione"
                set return_url "coimaimp-gest-messaggio-intermedio?funzione=A&$link_gest"
		} else {#ric01 aggiunto f_targa a link_gest
		    set link_gest "[export_url_vars cod_impianto nome_funz_caller f_resp_cogn f_resp_nome f_comune f_cod_via f_desc_via f_desc_topo f_civico f_esponente f_matricola f_modello f_costruttore f_numero_bollino f_targa]&nome_funz=impianti&flag_assegnazione=t"
		    set return_url "coimaimp-tecn?funzione=A&$link_gest"   
		}
		ad_returnredirect $return_url
		ad_script_abort
	    }
	}
    }
}

ad_return_template
