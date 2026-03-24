ad_page_contract {
    @ 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 14/02/2025 Aggiunta lettura data creazione dei file per mostrarlo all'utente.

} {
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {impianti          ""}
    {verifiche         ""}
}

#ad_return_if_another_copy_is_running 

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set button_label "Aggiorna i file contenenti impianti verifiche e allegati G/F/RCEE" 
set page_title   "Scarico dati per connettori"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimscar"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""


# leggo la tabella dei dati generali
iter_get_coimtgen
# imposto variabili usate nel programma:
if {$coimtgen(flag_ente) eq "P"} {
    set nome_dir "scarico[string tolower $coimtgen(flag_ente)][string tolower $coimtgen(sigla_prov)]"
} else {
    set nome_dir "scarico[string tolower $coimtgen(flag_ente)][string tolower $coimtgen(denom_comune)]"
}
#setto la cartella di destinazione dati
cd [iter_set_spool_dir]
#creo la directory di destinazione dati
file mkdir $nome_dir
# imposto la directory degli spool ed il loro nome.
set spool_dir          [iter_set_spool_dir]
set spool_dir_url      [iter_set_spool_dir_url]

set impiantiA "$spool_dir_url/$nome_dir/impiantiA.csv"
set verificheA "$spool_dir_url/$nome_dir/rapportiA.csv"
set autocertificazioniA  "$spool_dir_url/$nome_dir/autocertificazioniA.csv"
set impiantiD "$spool_dir_url/$nome_dir/impiantiD.csv"
set verificheD "$spool_dir_url/$nome_dir/rapportiD.csv"
set autocertificazioniD  "$spool_dir_url/$nome_dir/autocertificazioniD.csv"

#ric01 ricavo la data di creazione del file per mostrarla all'utente
set complete_path "$spool_dir/$nome_dir/impiantiA.csv"
set last_update [exec stat -c %y $complete_path]
db_1row q "select to_char(:last_update::date, 'DD/MM/YYYY') as last_update_pretty"


form create $form_name \
    -html    $onsubmit_cmd


element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

}

if {[form is_valid $form_name]} {

    set this_connection_url [ad_conn url]
    set n_matches 0
    foreach connection [ns_server active] {
	set query_connection_url [lindex $connection 4]
	if { $query_connection_url == $this_connection_url } {
	    # we got a match (we'll always get at least one
	    # since we should match ourselves)
	    incr n_matches
	}
    }
    if { $n_matches > 1} {
	iter_return_complaint "Programma gia' in esecuzione attendere la fine prima di scaricare i file."
	return
    }


    ns_log notice "inizio scarico"
    switch $funzione {
	"V" {set lvl 1}
	"I" {set lvl 2}
    }
    
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
    set link_gest [export_url_vars nome_funz nome_funz_caller caller]

    # controllo il parametro di "propagazione" per la navigation bar
    if {[string is space $nome_funz_caller]} {
	set nome_funz_caller $nome_funz
    }
    
    
    set nome_file_1A "impiantiA"
    set nome_file_2A "rapportiA"
    set nome_file_3A "autocertificazioniA"

    set nome_file_1D "impiantiD"
    set nome_file_2D "rapportiD"
    set nome_file_3D "autocertificazioniD"
   
    
    # imposto il nome dei file
    set nome_file     "$nome_file_1A"
    set file_csvA     "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlA "$spool_dir_url/$nome_dir/$nome_file.csv"
    
    set file_idA      [open $file_csvA w]
    fconfigure $file_idA -encoding iso8859-15 -translation lf


    set nome_file     "$nome_file_1D"
    set file_csvD     "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlD "$spool_dir_url/$nome_dir/$nome_file.csv"
    
    set file_idD      [open $file_csvD w]
    fconfigure $file_idD -encoding iso8859-15 -translation lf

    
    #impongo la classe di dati da estrarre dalla tabella coimtabs
    set table_name "impianti"
    
    set     head_cols ""
    set     file_cols ""

# sf 141014 comune utente
db_0or1row sel_cout_check " select count(*) as conta_cout
                                   from coimcout
                                   where id_utente = :id_utente
                                         "
	
if {$conta_cout > 0} {
    set where_cout_im "and a.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout_im ""
}
# sf fine


    db_foreach sel_tab_fields "" {
	# imposto la prima riga del file csv
	lappend head_cols $nome_colonna_decodificata
	# imposto il tracciato record del file csv
	lappend file_cols $nome_colonna
    }
    
    
    set sw_primo_recA "t"
    set sw_primo_recD "t"
    set N "N"
    
    set counter 0
    set parziale 0 
    db_foreach sel_scar "" {
	if {$stato == "A"} {
	    set fileid $file_idA
	    if {$sw_primo_recA == "t"} {
		set sw_primo_recA "f"
		iter_put_csv $fileid head_cols |
	    }
	} else {
	    set fileid $file_idD
	    if {$sw_primo_recD == "t"} {
		set sw_primo_recD "f"
		iter_put_csv $fileid head_cols |
	    }
	}

	incr counter
	incr parziale
	if {$parziale > 999} {
	    ns_log notice "coimscar-filter scarico impianti arrivato a $counter"
	    set parziale 0
	}
	set file_col_list ""
	
	foreach column_name $file_cols {
            regsub -all \n $note_impianto "" note_impianto
            regsub -all \n $note "" note
            regsub -all \r $note_impianto "" note_impianto
            regsub -all \r $note "" note

	    lappend file_col_list [set $column_name]
	}
	#    lappend file_col_list $civico_manu
	iter_put_csv $fileid file_col_list	|
	
	#faccio un array per poi scaricare tutti i file in modo più rapido 
#	set impianti_elaborati([list $cod_impianto_est $gen_prog]) [list $cod_impianto $gen_prog]
	
	
    } if_no_rows {
	set msg_err      "Nessun impianto attivo presente in archivio"
	set msg_err_list [list $msg_err]
	iter_put_csv $fileid msg_err_list |
    }
    
    ##############################################################à    
    # imposto il nome dei file
    set nome_file      "$nome_file_2A"
    set file_csvA      "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlA  "$spool_dir_url/$nome_dir/$nome_file.csv"
    
    set file_idA       [open $file_csvA w]
    fconfigure $file_idA -encoding iso8859-15 -translation lf

    set nome_file      "$nome_file_2D"
    set file_csvD      "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlD  "$spool_dir_url/$nome_dir/$nome_file.csv"
    
    set file_idD       [open $file_csvD w]
    fconfigure $file_idD -encoding iso8859-15 -translation lf
    
    #impongo la classe di dati da estrarre dalla tabella coimtabs
    set table_name "rapporti"
    
# sf 141014 comune utente
db_0or1row sel_cout_check " select count(*) as conta_cout
                                   from coimcout
                                   where id_utente = :id_utente
                                         "
	
if {$conta_cout > 0} {
    set where_cout_ri "and e.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout_ri ""
}
# sf fine


    set     head_cols ""
    set     file_cols ""
    db_foreach sel_tab_fields "" {
	# imposto la prima riga del file csv
	lappend head_cols $nome_colonna_decodificata
	# imposto il tracciato record del file csv
	lappend file_cols $nome_colonna
    }
    lappend head_cols "ANOMALIE RISCONTRATE"
    
    set sw_primo_recA "t"
    set sw_primo_recD "t"
    set N "N"
    set flag_orig "RV"
    set count 0
    set parziale 0
    db_foreach sel_cimp "" {
	if {$stato == "A"} {
	    set fileid $file_idA
	    if {$sw_primo_recA == "t"} {
		set sw_primo_recA "f"
		iter_put_csv $fileid head_cols |
	    }
	} else {
	    set fileid $file_idD
	    if {$sw_primo_recD == "t"} {
		set sw_primo_recD "f"
		iter_put_csv $fileid head_cols |
	    }
	}
	incr count
	incr parziale
	if {$parziale > 999} {
	    ns_log notice "coimscar-all-filter scarico controlli arrivato a $count"
	    set parziale 0
	}
	set file_col_list ""
	#itero i generatori del sistema
	foreach column_name $file_cols {
	    
	    regsub -all \n $new1_note_manu "" new1_note_manu
	    regsub -all \n $note_verificatore "" note_verificatore
	    regsub -all \n $note_resp "" note_resp
	    regsub -all \n $note_conf "" note_conf
	    regsub -all \n $nominativo_pres "" nominativo_pres
	    
	    regsub -all \r $new1_note_manu "" new1_note_manu
	    regsub -all \r $note_verificatore "" note_verificatore
	    regsub -all \r $note_resp "" note_resp
	    regsub -all \r $note_conf "" note_conf
	    regsub -all \r $nominativo_pres "" nominativo_pres
	    
	    lappend file_col_list [set $column_name]
	}
	set tanom_list ""
	db_foreach list_anom "" {
	    lappend tanom_list "$cod_tanom,"
	}
	lappend file_col_list $tanom_list
	iter_put_csv $fileid file_col_list |
    }
    ############################################################
    
    set nome_file     "$nome_file_3A"
    set file_csvA      "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlA  "$spool_dir_url/$nome_dir/$nome_file.csv"
    set file_idA       [open $file_csvA w]
    fconfigure $file_idA -encoding iso8859-15 -translation lf



    set nome_file     "$nome_file_3D"
    set file_csvD      "$spool_dir/$nome_dir/$nome_file.csv"
    set file_csv_urlD  "$spool_dir_url/$nome_dir/$nome_file.csv"
    set file_idD       [open $file_csvD w]
    fconfigure $file_idD -encoding iso8859-15 -translation lf

    
    
    #impongo la classe di dati da estrarre dalla tabella coimtabs
    set table_name "autocert"
    
# sf 141014 comune utente
db_0or1row sel_cout_check " select count(*) as conta_cout
                                   from coimcout
                                   where id_utente = :id_utente
                                         "
	
if {$conta_cout > 0} {
    set where_cout_au "and d.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout_au ""
}
# sf fine
    


    set     head_cols ""
    set     file_cols ""
    db_foreach sel_tab_fields "" {
	# imposto la prima riga del file csv
	lappend head_cols $nome_colonna_decodificata
	# imposto il tracciato record del file csv
	lappend file_cols $nome_colonna
    }
    
    lappend head_cols "ANOMALIE RISCONTRATE"
    
    set null ""
    set sw_primo_recA "t"
    set sw_primo_recD "t"
    set N "N"
    set flag_orig "MH"
    set ctu 0
    set parziale 0 
    db_foreach sel_auto "" {
	if {$stato == "A"} {
	    set fileid $file_idA
	    if {$sw_primo_recA == "t"} {
		set sw_primo_recA "f"
		iter_put_csv $fileid head_cols |
	    }
	    
	} else {
	    set fileid $file_idD
	    if {$sw_primo_recD == "t"} {
		set sw_primo_recD "f"
		iter_put_csv $fileid head_cols |
	    }
	    
	}
	incr ctu
	incr parziale
	if {$parziale > 999} {
	    ns_log notice "coimscar-all-filter scarico autocertificazioni arrivato a $ctu"
	    set parziale 0
	}



	set file_col_list ""
	
	
	foreach column_name $file_cols {
	    regsub -all \n $osservazioni "" osservazioni
	    regsub -all \n $raccomandazioni "" raccomandazioni
	    regsub -all \n $prescrizioni "" prescrizioni
	    
	    regsub -all \r $osservazioni "" osservazioni
	    regsub -all \r $raccomandazioni "" raccomandazioni
	    regsub -all \r $prescrizioni "" prescrizioni
	    
	    if {$flag_co_perc eq "t"} {
		set co [expr $co/10000.0000]
	    }
	    lappend file_col_list [set $column_name]
	}
	
	set tanom_list ""
	db_foreach list_anom "" {
	    lappend tanom_list "$cod_tanom,"
	}
	
	lappend file_col_list $tanom_list
	
	iter_put_csv $fileid file_col_list |
    }
    
    ns_log notice "fine scarico"    
}

ad_return_template
    
