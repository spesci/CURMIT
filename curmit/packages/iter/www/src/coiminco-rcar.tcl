ad_page_contract {
    @author          Paolo Formizzi Adhoc
    @creation-date   28/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-rcar.tcl
    USER  DATA       MODIFICHE

    ===== ========== =============================================================================
    rom01 21/07/2022 Su richiesta della Provincia di Salerno aggiunta la colonna flag_blocca_rcee.
    rom01            Sandro ha detto che va bene per tutti.
    
} {
    {funzione   "I"}
    {caller "index"}
    {nome_funz   ""}
    {nome_funz_caller ""}
    file_name:trim,optional
    file_name.tmpfile:tmpfile,optional
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set sigla_prov $coimtgen(sigla_prov)
set flag_ente  $coimtgen(flag_ente)

set flag ""

if {[db_0or1row sel_cinc_count ""] == 0} {
    set conta 0
}
if {$conta == 0} {
    iter_return_complaint "Non ci sono campagne aperte"
}
if {$conta > 1} {
    iter_return_complaint "C'&egrave; pi&ugrave; di una campagna aperta"
}

if {$conta == 1} {
    if {[db_0or1row sel_cinc ""] == 0} {
	iter_return_complaint "Campagna non trovata"
    }
}

# Personalizzo la pagina
set main_directory   [ad_conn package_url]
set titolo       "Ricarico appuntamenti dopo assegnazione"
set button_label "Conferma" 
set page_title   "Ricarico appuntamenti dopo assegnazione"

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coiminco"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd "enctype {multipart/form-data}"

form create $form_name \
-html    $onsubmit_cmd

element create $form_name file_name \
-label   "File da importare" \
-widget   file \
-datatype text \
-html    "size 40 maxlength 50 class form_element" \
-optional

element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit_2  -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[form is_request $form_name]} {

    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz
}

if {[form is_valid $form_name]} {

    # form valido dal punto di vista del templating system   
    set file_name       [element::get_value $form_name file_name]

    set data_corrente iter_set_sysdate

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {[string equal $file_name ""]} {
	element::set_error $form_name file_name "Inserire Nome File"
	incr error_num
    } else {
	set extension [file extension $file_name]
	if {$extension != ".csv"} {
	    if {$extension != ".txt"} {
		element::set_error $form_name file_name "Il file non ha estensione csv o txt"
		incr error_num
	    }
	} else {
	    set tmpfile ${file_name.tmpfile}
	    if {![file exists $tmpfile]} {
		element::set_error $form_name file_name "File non trovato"
		incr error_num
	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set permanenti_dir     [iter_set_permanenti_dir]
    set permanenti_dir_url [iter_set_permanenti_dir_url]
    set file_inp_name      "Valori-input"
    set file_inp_name      [iter_temp_file_name -permanenti $file_inp_name]
    set file_out_name      "Valori-caricati"
    set file_out_name      [iter_temp_file_name -permanenti $file_out_name]
    set file_err_name      "Valori-scartati"
    set file_err_name      [iter_temp_file_name -permanenti $file_err_name]
    set file_inp           "${permanenti_dir}/$file_inp_name.csv"
    set file_out           "${permanenti_dir}/$file_out_name.csv"
    set file_err           "${permanenti_dir}/$file_err_name.csv"
    set file_inp_url       "${permanenti_dir_url}/$file_inp_name.csv"
    set file_out_url       "${permanenti_dir_url}/$file_out_name.csv"
    set file_err_url       "${permanenti_dir_url}/$file_err_name.csv"


    set file_inp ${file_name.tmpfile}

    # apro il file in lettura e metto in file_inp_id l'identificativo del file
    # per poterlo leggere successivamente
    if {[catch {set file_inp_id [open $file_inp r]}]} {
	iter_return_complaint "File csv di input non aperto: $file_inp"
    }
    # dichiaro di leggere in formato iso West European e di utilizzare crlf
    # come fine riga (di default andrebbe a capo anche con gli eventuali lf
    # contenuti tra doppi apici).
    fconfigure $file_inp_id -encoding iso8859-1 -translation crlf

    # apro il file in scrittura e metto in file_out_id l'identificativo 
    # del file per poterlo scrivere successivamente
    if {[catch {set file_out_id [open $file_out w]}]} {
	iter_return_complaint "File csv dei record caricati non aperto: $file_out"
    }
    # dichiaro di scrivere in formato iso West European
    fconfigure $file_out_id -encoding iso8859-1

    # apro il file in scrittura e metto in file_err_id l'identificativo 
    # del file per poterlo scrivere successivamente
    if {[catch {set file_err_id [open $file_err w]}]} {
	iter_return_complaint "File csv dei record scartati non aperto: $file_err"
    }
    # dichiaro di scrivere in formato iso West European
    fconfigure $file_err_id -encoding iso8859-1

    # preparo e scrivo scrivo la riga di intestazione per file out
    set     head_cols ""
    lappend head_cols "Codice appuntamento"
    lappend head_cols "Note della verifica"
    lappend head_cols "N. verbale"
    lappend head_cols "Tipo visita"
    lappend head_cols "Tariffa"
    lappend head_cols "Codice impianto"
    lappend head_cols "Data"
    lappend head_cols "Ora"
    lappend head_cols "Ente verif"
    lappend head_cols "Verif cog."
    lappend head_cols "Verif. nome"
    lappend head_cols "Tipo verifica"
    lappend head_cols "Potenza"
    lappend head_cols "Utente"
    lappend head_cols "Utente 2"
    lappend head_cols "Indirizzo"
    lappend head_cols "CAP"
    lappend head_cols "Comune"
    lappend head_cols "Note"
    lappend head_cols "Indirizzo (recapito)"
    lappend head_cols "CAP (recapito)"
    lappend head_cols "Comune (recapito)"
    lappend head_cols "Provincia (recapito)"
    lappend head_cols "Telefono"
    lappend head_cols "Cellulare"
    lappend head_cols "Esito"
    lappend head_cols "Progressivo generatore"
    lappend head_cols "Data controllo"
    lappend head_cols "Num. verbale"
    lappend head_cols "Data verbale"
    lappend head_cols "Costo verifica"
    lappend head_cols "Tipologia costo"
    lappend head_cols "Riferimento pagamento"
    lappend head_cols "Data scadenza pagamento"
    lappend head_cols "Presenziante"
    lappend head_cols "Presenza libretto"
    lappend head_cols "Libretto corretto"
    lappend head_cols "Dichiarazione conformita'"
    lappend head_cols "Libretto manutenzione"
    lappend head_cols "Potenza combustibile"
    lappend head_cols "Potenza termica al focolare"
    lappend head_cols "Stato coibentazione"
    lappend head_cols "Stato canna fumaria"
    lappend head_cols "Verifica dispositivi di regolazione/controllo"
    lappend head_cols "Verifica aerazione"
    lappend head_cols "Taratura di regolazione/controllo"
    lappend head_cols "CO nei fumi secchi"
    lappend head_cols "PPM"
    lappend head_cols "Eccesso d'aria %"
    lappend head_cols "Perdita ai fumi %"
    lappend head_cols "Rendimento convenzionale %"
    lappend head_cols "Rendiento minimo richiesto %"
    lappend head_cols "Temperatura fumi 1° lettura"
    lappend head_cols "Temperatura fumi 2° lettura"
    lappend head_cols "Temperatura fumi 3° lettura"
    lappend head_cols "Temperatura fumi valore medio"
    lappend head_cols "Temperatura aria comburente 1° lettura"
    lappend head_cols "Temperatura aria comburente 2° lettura"
    lappend head_cols "Temperatura aria comburente 3° lettura"
    lappend head_cols "Temperatura aria comburente valore medio"
    lappend head_cols "Temperatura mantello 1° lettura"
    lappend head_cols "Temperatura mantello 2° lettura"
    lappend head_cols "Temperatura mantello 3° lettura"
    lappend head_cols "Temperatura mantello valore medio"
    lappend head_cols "Temperatura fluido in mandata 1° lettura"
    lappend head_cols "Temperatura fluido in mandata 2° lettura"
    lappend head_cols "Temperatura fluido in mandata 3° lettura"
    lappend head_cols "Temperatura fluido in mandata valore medio"
    lappend head_cols "Co2 1° letture"
    lappend head_cols "Co2 2° lettura"
    lappend head_cols "Co2 3° lettura"
    lappend head_cols "Co2 valore medio"
    lappend head_cols "O2 1° lettura"
    lappend head_cols "O2 2° lettura"
    lappend head_cols "O2 3° lettura"
    lappend head_cols "O2 valore medio"
    lappend head_cols "CO (RPM) 1° lettura"
    lappend head_cols "CO (RPM) 2° lettura"
    lappend head_cols "CO (RPM) 3° lettura"
    lappend head_cols "CO (RPM) valore medio"
    lappend head_cols "Indice di fumosita'-bacharach 1° lettura"
    lappend head_cols "Indice di fumosita'-bacharach 2° lettura"
    lappend head_cols "Indice di fumosita'-bacharach 3° lettura"
    lappend head_cols "Indice di fumosita'-bacharach valore medio"
    lappend head_cols "Manutenzione 8A"
    lappend head_cols "CO riferifo ai fumi secchi 8B"
    lappend head_cols "Indice di fumosita' 8C"
    lappend head_cols "Rendimento convenzionale 8D"
    lappend head_cols "Esito verifica"
    lappend head_cols "Strumento"
    lappend head_cols "Osservazione/Raccomandazioni"
    lappend head_cols "Note responsabile"
    lappend head_cols "Note non conformita'"
    lappend head_cols "Flag blocca RCEE";#rom01

    # uso la proc perche' i file csv hanno caratterstiche 'particolari'
    iter_put_csv $file_out_id head_cols

    # preparo e scrivo la riga di intestazione del file degli errori
    lappend head_cols "Motivo di scarto"
    iter_put_csv $file_err_id head_cols

    # definisco il tracciato record del file di input
    set     carv_cols ""
    lappend carv_cols "cod_inco"
    lappend carv_cols "note_verifica"
    lappend carv_cols "n_verbale"
    lappend carv_cols "tipo_visita"
    lappend carv_cols "tariffa"
    lappend carv_cols "cod_impianto"
    lappend carv_cols "data_verifica"
    lappend carv_cols "ora_verifica"
    lappend carv_cols "ragione_01"
    lappend carv_cols "cogn_verif"
    lappend carv_cols "nome_verif"
    lappend carv_cols "tipo_ver"
    lappend carv_cols "potenza"
    lappend carv_cols "resp"
    lappend carv_cols "resp2"
    lappend carv_cols "indirizzo_ext"
    lappend carv_cols "cap"
    lappend carv_cols "comune"
    lappend carv_cols "note"
    lappend carv_cols "indirizzo_sogg"
    lappend carv_cols "cap_sogg"
    lappend carv_cols "comune_sogg"
    lappend carv_cols "provincia_sogg"
    lappend carv_cols "telefono"
    lappend carv_cols "cellulare"
    lappend carv_cols "esito"
    lappend carv_cols "gen_prog"
    lappend carv_cols "data_controllo"
    lappend carv_cols "verb_n"
    lappend carv_cols "data_verb"
    lappend carv_cols "costo"
    lappend carv_cols "tipologia_costo"
    lappend carv_cols "riferimento_pag"
    lappend carv_cols "data_scad_pag"
    lappend carv_cols "nominativo_pres"
    lappend carv_cols "presenza_libretto"
    lappend carv_cols "libretto_corretto"
    lappend carv_cols "dich_conformita"
    lappend carv_cols "libretto_manutenz"
    lappend carv_cols "mis_port_combust"
    lappend carv_cols "mis_pot_focolare"
    lappend carv_cols "stato_coiben"
    lappend carv_cols "stato_canna_fum"
    lappend carv_cols "verifica_dispo"
    lappend carv_cols "verifica_areaz"
    lappend carv_cols "taratura_dispos"
    lappend carv_cols "co_fumi_secchi"
    lappend carv_cols "ppm"
    lappend carv_cols "eccesso_aria_perc"
    lappend carv_cols "perdita_ai_fumi"
    lappend carv_cols "rend_comb_conv"
    lappend carv_cols "rend_comb_min"
    lappend carv_cols "temp_fumi_1a"
    lappend carv_cols "temp_fumi_2a"
    lappend carv_cols "temp_fumi_3a"
    lappend carv_cols "temp_fumi_md"
    lappend carv_cols "t_aria_comb_1a"
    lappend carv_cols "t_aria_comb_2a"
    lappend carv_cols "t_aria_comb_3a"
    lappend carv_cols "t_aria_comb_md"
    lappend carv_cols "temp_mant_1a"
    lappend carv_cols "temp_mant_2a"
    lappend carv_cols "temp_mant_3a"
    lappend carv_cols "temp_mant_md"
    lappend carv_cols "temp_h2o_out_1a"
    lappend carv_cols "temp_h2o_out_2a"
    lappend carv_cols "temp_h2o_out_3a"
    lappend carv_cols "temp_h2o_out_md"
    lappend carv_cols "co2_1a"
    lappend carv_cols "co2_2a"
    lappend carv_cols "co2_3a"
    lappend carv_cols "co2_md"
    lappend carv_cols "o2_1a"
    lappend carv_cols "o2_2a"
    lappend carv_cols "o2_3a"
    lappend carv_cols "o2_md"
    lappend carv_cols "co_1a"
    lappend carv_cols "co_2a"
    lappend carv_cols "co_3a"
    lappend carv_cols "co_md"
    lappend carv_cols "indic_fumosita_1a"
    lappend carv_cols "indic_fumosita_2a"
    lappend carv_cols "indic_fumosita_3a"
    lappend carv_cols "indic_fumosita_md"
    lappend carv_cols "manutenzione_8a"
    lappend carv_cols "co_fumi_secchi_8b"
    lappend carv_cols "indic_fumosita_8c"
    lappend carv_cols "rend_comb_8d"
    lappend carv_cols "esito_verifica"
    lappend carv_cols "strumento"
    lappend carv_cols "note_verificatore"
    lappend carv_cols "note_resp"
    lappend carv_cols "note_conf"
    lappend carv_cols "flag_blocca_rcee";#rom01

    set ctr_inp 0
    set ctr_out 0
    set ctr_err 0
    set ctr_ins 0
    set ctr_upd 0

    with_catch error_msg {
	db_transaction {
	    # Salto il primo record che deve essere di testata
	    iter_get_csv $file_inp_id file_inp_col_list

	    # Ciclo di lettura sul file di input
	    # uso la proc perche' i file csv hanno caratteristiche 'particolari'
	    iter_get_csv $file_inp_id file_inp_col_list
	    while {![eof $file_inp_id]} {
		incr ctr_inp


		# valorizzo le relative colonne
		set ind 0
		foreach column_name $carv_cols {
		    set $column_name [lindex $file_inp_col_list $ind]
		    incr ind
		}
 
		set carica "S"
		# elaboro record
		# Motivi scarti
		# 1 cod_inco non trovato
		set cod_inco [string trim $cod_inco]
		if {[db_0or1row sel_inco ""] == 0} {
		    set carica "N"
		    set motivo_scarto "Codice appuntamento errato"
		}

		# 2 data non corretta
		if {$carica == "S"} {
		    set data_verifica  [string trim $data_verifica]
		    if {[string equal $data_verifica ""]} {
			# modifica per provincia di mantova: permetto 
			# l'inserimento di un'appuntamento senza la data
                        # verifica
			if {$flag_ente     != "P"
                        &&  $sigla_prov    != "MN"
			} {
			    set carica "N"
			    set motivo_scarto "Data mancante"
			} else {
			    set data_verifica_db ""
			}
		    } else {
			set data_verifica_db [iter_check_date $data_verifica]
			if {$data_verifica_db == 0} {
			    set carica "N"
			    set motivo_scarto "Data non corretta"
			}
		    }
		}

		# 3 ora non corretta
		if {$carica == "S"} {
		    set ora_verifica  [string trim $ora_verifica]
		    if {![string equal $ora_verifica ""]} {
			set punto [string first "." $ora_verifica]
			if {$punto == -1} {
			    set punto [string first "," $ora_verifica]
			}
			if {$punto == -1} {
			    set punto [string first ":" $ora_verifica]
			}
			if {$punto != -1} {
			    set ore [string range $ora_verifica 0 [expr $punto - 1]]
			    set min [string range $ora_verifica [expr $punto + 1] end]
			    if {[string range $min 0 0] == 0} {
				set min [string range $min 1 1]
			    }
			    if {(![string is integer $ore]
				 ||  $ore < 0
				 ||  $ore > 23)} {
				set carica "N"
				set motivo_scarto "Ora non corretta"
			    } else {
				if {$ore < 10} {
				    set ore "0$ore"
				}
			    }
			    if {(![string is integer $min]
				 ||  $min < 0
				 ||  $min > 59)
				&& $carica == "S"} {
				set carica "N"
				set motivo_scarto "Ora non corretta"
			    } else {
				if {[string length $min] == 1} {
				    set min "0$min"
				}
			    }
			    set ora_verifica "$ore:$min:00"
			} else {
			    set carica "N"
			    set motivo_scarto "Ora non corretta"
			}
		    }
		}

		# 4 ente verificatore non trovato
		set ragione_01 [string trim $ragione_01]
		if {$carica == "S"} {
		    if {[string equal $ragione_01 ""]} {
			set carica "N"
			set motivo_scarto "Ente Verificatore mancante"
		    } else {
		        db_1row sel_count_enve ""
			if {$conta_enve == 0} {
			    set carica "N"
			    set motivo_scarto "Ente Verificatore inesistente"
			}
			if {$conta_enve > 1} {
			    set carica "N"
			    set motivo_scarto "Ente Verificatore non univoco"
			}
			if {$conta_enve == 1} {
			    if {[db_0or1row sel_enve2 ""] == 0} {
				set carica "N"
				set motivo_scarto "Ente Verificatore non trovato"
			    }
			}
		    }
		}
		# 5 verificatore non trovato
		set nome_verif [string trim $nome_verif]
		set cogn_verif [string trim $cogn_verif]
		if {$carica == "S"
                &&  ![string equal $nome_verif ""]
                &&  ![string equal $cogn_verif ""]
		} {
		    if {[db_0or1row sel_opve ""] == 0} {
			set conta 0
		    }
		    if {$conta == 0} {
			set carica "N"
			set motivo_scarto "Tecnico assegnato inesistente"
		    }
		    if {$conta > 1} {
			set carica "N"
			set motivo_scarto "Tecnico assegnato non univoco"
		    }
		    if {$conta == 1} {
			if {[db_0or1row sel_opve2 ""] == 0} {
			    set carica "N"
			    set motivo_scarto "Tecnico assegnato non trovato"
			}
		    }
		} else {
		    set cod_opve ""
		}
	    
		if {[string is space $flag_blocca_rcee]} {#rom01 Aggiunte if, else e il loro contenuto
		    set carica "N"
		    set motivo_scarto "Flag blocca RCEE non segnato."

		} else {
		    set check_flag_blocca_rcee [string toupper $flag_blocca_rcee]

		    if {[string equal $check_flag_blocca_rcee "SI"]} {
			set upd_flag_blocca_rcee t

		    } elseif {[string equal $check_flag_blocca_rcee "NO"]} {
			set upd_flag_blocca_rcee f

		    } else {
			set carica "N"
			set motivo_scarto "Flag blocca RCEE indicato in maniera errata."
		    }
		}

		# 6 verifico che il controllo non sia gia' presente sul db
		if {$carica == "S"} {
		    if {[db_0or1row sel_stato_inco ""] == 0} {
			set stato_inco 0
		    } else {
			if {$stato_inco != "1"
			&&  $stato_inco != "2"
			} {
			    set carica "N"
			    set motivo_scarto "Appuntamento gi&agrave; trattato, non assegnabile"
			}
		    }
		}
		
		# ricostruisco il record di output
		set file_out_col_list ""
		set ind 0
		foreach column_name $carv_cols {
		    lappend file_out_col_list [set $column_name]
		    incr ind
		}

		if {$carica == "S"} {

		    # carica tabe#
		    set dml_sql [db_map upd_inco]
		    db_dml dml_coiminco $dml_sql
    		    incr ctr_ins
		    
		    iter_put_csv $file_out_id file_out_col_list
		    incr ctr_out
		} else {
		    lappend file_out_col_list $motivo_scarto
		    iter_put_csv $file_err_id file_out_col_list
		    incr ctr_err

		    if {![info exists ctr_scarto($motivo_scarto)]} {
			set ctr_scarto($motivo_scarto) 0
		    }
		    incr ctr_scarto($motivo_scarto)
		}
		
		# lettura del record successivo
		iter_get_csv $file_inp_id file_inp_col_list
	    }    
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

    close $file_inp_id
    close $file_out_id
    close $file_err_id

    multirow create multiple_scarti motivo_scarto ctr_scarto
    foreach motivo_scarto [lsort [array names ctr_scarto]] {
	set ws_mot_scarto $motivo_scarto
	regsub -all "à" $ws_mot_scarto {\&agrave;} ws_mot_scarto
	regsub -all "è" $ws_mot_scarto {\&egrave;} ws_mot_scarto
	regsub -all "ì" $ws_mot_scarto {\&igrave;} ws_mot_scarto
	regsub -all "ò" $ws_mot_scarto {\&ograve;} ws_mot_scarto
	regsub -all "ù" $ws_mot_scarto {\&ugrave;} ws_mot_scarto

	multirow append multiple_scarti $ws_mot_scarto $ctr_scarto($motivo_scarto)
    }

    set flag "S"
#    set file_scarti "[iter_set_permanenti_dir_url]/estr-excel-err.csv
#    ad_returnredirect    "${main_directory}main"
#    ad_script_abort
ad_return_template
}

ad_return_template
