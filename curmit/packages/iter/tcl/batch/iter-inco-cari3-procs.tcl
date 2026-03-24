ad_proc iter_inco_cari3 {
    {
	-cod_batc      ""
        -id_utente     ""
	-cod_cinc      ""
	-file_name     ""
        -swc_solo_aimp ""
    }
} {
    Elaborazione     Caricamento controlli/impianti da file esterno
    @author          Nicola Mortoni
    @creation-date   26/08/2005
    @cvs-id          iter_inco_cari3

    se swc_solo_aimp vale "S" allora non si creano i controlli
} {
    # aggiorno stato di coimbatc
    iter_batch_upd_flg_sta -iniz $cod_batc


    with_catch error_msg {
	db_transaction {

	    # reperisco le colonne della tabella parametri
	    iter_get_coimtgen
	    set flag_cod_aimp_auto  $coimtgen(flag_cod_aimp_auto)
	    set flag_ente           $coimtgen(flag_ente)
	    set sigla_prov          $coimtgen(sigla_prov)
	    set flag_codifica_reg   $coimtgen(flag_codifica_reg)
	    set lun_num_cod_imp_est $coimtgen(lun_num_cod_imp_est);#nic04


	    set flag_ente           $coimtgen(flag_ente);#rom02
	    set sigla_prov          $coimtgen(sigla_prov);#rom02
	    set flag_codifica_reg   $coimtgen(flag_codifica_reg);#rom02
	    set lun_num_cod_imp_est $coimtgen(lun_num_cod_imp_est);#rom02

	    # valorizzo la data_corrente (serve per l'inserimento)
	    set data_corrente  [iter_set_sysdate]

	    set permanenti_dir [iter_set_permanenti_dir]
	    set permanenti_dir_url [iter_set_permanenti_dir_url]
	    set file_inp_name  "Controlli-da-esterno-input"
	    set file_inp_name  [iter_temp_file_name -permanenti $file_inp_name]
	    set file_esi_name  "Controlli-da-esterno-esito"
	    set file_esi_name  [iter_temp_file_name -permanenti $file_esi_name]
	    set file_out_name  "Controlli-da-esterno-caricati"
	    set file_out_name  [iter_temp_file_name -permanenti $file_out_name]
	    set file_err_name  "Controlli-da-esterno-scartati"
	    set file_err_name  [iter_temp_file_name -permanenti $file_err_name]

	    # salvo i file di output come .txt in modo che excel permetta di
	    # indicare il formato delle colonne (testo) al momento
	    # dell'importazione del file.
	    # in caso contrario i numeri di telefono rimarrebbero senza lo zero
	    # ed i civici 8/10 diverrebbero una data!
	    # bisogna fare in modo che excel apra correttamente il file
	    # degli scarti perche' l'utente potrebbe correggere gli errori
	    # e provare a ricaricarli.
	    set file_inp       "${permanenti_dir}/$file_inp_name.csv"
	    set file_esi       "${permanenti_dir}/$file_esi_name.adp"
	    set file_out       "${permanenti_dir}/$file_out_name.txt"
	    set file_err       "${permanenti_dir}/$file_err_name.txt"
	    set file_inp_url   "${permanenti_dir_url}/$file_inp_name.csv"
	    # in file_esi_url non metto .adp altrimenti su vestademo non
	    # viene trovata la url!!
	    set file_esi_url   "${permanenti_dir_url}/$file_esi_name"
	    set file_out_url   "${permanenti_dir_url}/$file_out_name.txt"
	    set file_err_url   "${permanenti_dir_url}/$file_err_name.txt"

	    # rinomino il file (che per ora ha lo stesso nome di origine)
	    # con un nome legato al programma ed all'ora di esecuzione
	    exec mv $file_name $file_inp

	    # apro il file in lettura e metto in file_inp_id l'identificativo
	    # del file per poterlo leggere successivamente
	    if {[catch {set file_inp_id [open $file_inp r]}]} {
		iter_return_complaint "File csv di input non aperto: $file_inp"
	    }
	    # dichiaro di leggere in formato iso West European e di utilizzare
	    # crlf come fine riga (di default andrebbe a capo anche con gli
	    # eventuali lf contenuti tra doppi apici).
	    fconfigure $file_inp_id -encoding iso8859-1 -translation crlf

	    # apro il file in scrittura e metto in file_esi_id l'identificativo
	    # del file per poterlo scrivere successivamente
	    if {[catch {set file_esi_id [open $file_esi w]}]} {
		iter_return_complaint "File di esito caricamento non aperto: $file_esi"
	    }
	    # dichiaro di scrivere in formato iso West European
	    fconfigure $file_esi_id -encoding iso8859-1

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
	    lappend head_cols "Cognome"
	    lappend head_cols "Nome"
	    lappend head_cols "Tipo toponimo"
	    lappend head_cols "Nome toponimo"
	    lappend head_cols "Civico"
	    lappend head_cols "Cap"
	    lappend head_cols "Comune"
	    lappend head_cols "Provincia"
	    lappend head_cols "Codice Fiscale"
	    lappend head_cols "Prefisso telefonico"
	    lappend head_cols "Numero telefonico"

	    # uso la proc perche' i file csv hanno caratterstiche 'particolari'
	    set     out_cols  $head_cols
	    lappend out_cols  "cod_cittadino inserito"
	    lappend out_cols  "cod_impianto inserito"
	    lappend out_cols  "gen_prog inserito"
	    lappend out_cols  "cod_inco inserito"
	    iter_put_csv $file_out_id out_cols

	    # preparo e scrivo la riga di intestazione del file degli errori
	    lappend head_cols "Motivo di scarto"
	    iter_put_csv $file_err_id head_cols

	    # definisco il tracciato record del file di input
	    set     file_cols ""
	    lappend file_cols "inp_cognome"
	    lappend file_cols "inp_nome"
	    lappend file_cols "inp_tipo_toponimo"
	    lappend file_cols "inp_nome_toponimo"
	    lappend file_cols "inp_civico"
	    lappend file_cols "inp_cap"
	    lappend file_cols "inp_comune"
	    lappend file_cols "inp_prov"
	    lappend file_cols "inp_cod_fisc"
	    lappend file_cols "inp_prefisso_telefonico"
	    lappend file_cols "inp_numero_telefonico"

	    set ctr_inp 0
	    set ctr_err 0
	    set ctr_out 0
	    set ctr_ins_citt 0
	    set ctr_ins_aimp 0
	    set ctr_ins_gend 0
	    set ctr_ins_inco 0

	    # reperisco una volta sola max_cod_impianto_est
	    if {$coimtgen(flag_cod_aimp_auto) != "T"} {
		set max_cod_impianto_est [db_string sel_aimp_max_cod_impianto_est ""]
	    }

	    # Salto il primo record che deve essere di testata
	    iter_get_csv $file_inp_id file_inp_col_list

	    # Ciclo di lettura sul file di input
	    # uso la proc perche' i file csv hanno caratteristiche 'particolari'
	    iter_get_csv $file_inp_id file_inp_col_list
	    while {![eof $file_inp_id]} {
		incr ctr_inp
ns_log notice "|file_cols=$file_cols|"
		# valorizzo le relative colonne
		set ind 0
		foreach column_name $file_cols {
		    set $column_name [lindex $file_inp_col_list $ind]
		    incr ind
		}
		ns_log notice  "$inp_cognome - $inp_comune $inp_prov"
		# preparo le variabili di comodo con i dati di input
		# puliti da eventuali spazi
		# ragione sociale deve sempre essere maiuscolo per separa_cog.
		set ws_cognome             [string trim    $inp_cognome]
		set ws_nome                [string trim    $inp_nome]
		set ws_tipo_toponimo       [string trim    $inp_tipo_toponimo]
		set ws_nome_toponimo       [string trim    $inp_nome_toponimo]
		# ws_civico non deve avere gli zeri di sinistra per separa_num.
		set ws_civico              [string trim    $inp_civico]
		set ws_civico              [string trimleft $ws_civico "0"]
		set ws_nome_toponimo       [string trim    $inp_nome_toponimo]
		set ws_cap                 [string trim    $inp_cap]
		set ws_comune              [string trim    $inp_comune]
		set ws_prov                [string trim    $inp_prov]
		set ws_cod_fisc            [string trim    $inp_cod_fisc]
		set ws_prefisso_telefonico [string trim    $inp_prefisso_telefonico]
		set ws_numero_telefonico   [string trim    $inp_numero_telefonico]

		# controllo record
		set carica "S"

		if {$carica == "S"} {
		    if {[string equal $ws_cognome ""]} {
			set carica        "N"
			set motivo_scarto "Ragione sociale non valorizzata"
		    }
		}

		if {$carica == "S"} {
		    if {[string equal $ws_tipo_toponimo ""]} {
			set carica        "N"
			set motivo_scarto "Tipo toponimo non valorizzato"
		    }
		}

		if {$carica == "S"} {
		    if {[string equal $ws_nome_toponimo ""]} {
			set carica        "N"
			set motivo_scarto "Nome toponimo non valorizzato"
		    }
		}

		# ws_civico non obbligatorio

		# ws_cap non obbligatorio
		if {$carica == "S"} {
		    if {![string equal $ws_cap ""]
			&&  ![string is integer $ws_cap]
		    } {
			set carica        "N"
			set motivo_scarto "Cap non numerico"
		    }
		}

		if {$carica == "S"} {
		    if {[string equal $ws_comune ""]} {
			set carica        "N"
			set motivo_scarto "Comune non valorizzato"
		    } else {
			set denominazione $ws_comune
			db_1row sel_comu_check ""
			# con la query precedente ho valorizzato ctr_comu
			# e cod_comune con il max(cod_comune)
			if {$ctr_comu == 0} {
			    set carica        "N"
			    set motivo_scarto "Comune non esistente in tabella Comuni"
			}
			if {$ctr_comu > 1} {
			    set carica        "N"
			    set motivo_scarto "Trovati più comuni con questa denominazione"
			}
			if {$ctr_comu == 1} {
			    # seleziono cod_provincia e provincia
			    # che serviranno nel programma
			    if {[db_0or1row sel_comu ""] == 0} {
				set carica        "N"
				set motivo_scarto "Comune non esistente in tabella Comuni"
			    } else {
				if {$coimtgen(flag_ente) == "C"
				    &&  $coimtgen(cod_comu)  != $cod_comune
				} {
				    set carica        "N"
				    set motivo_scarto "Comune diverso da $coimtgen(denom_comune)"
				}
			    }
			}
		    }
		}

		if {$coimtgen(flag_viario) == "T"
		    &&  $carica == "S"
		} {
		    set descr_topo  $ws_tipo_toponimo
		    set descrizione $ws_nome_toponimo
		    ns_log notice "CATTE $cod_comune - $descrizione - $descr_topo"
		    db_1row sel_viae_check ""
		    # con la query precedente ho valorizzato ctr_viae
		    # e cod_via con il max(cod_via)
		    if {$ctr_viae == 0} {
			set carica        "N"
			set motivo_scarto "Toponimo non esistente in tabella Viario"
		    }
		    if {$ctr_viae > 1} {
			set carica        "N"
			set motivo_scarto "Trovati più toponimi con questo nome in tabella Viario"
		    }
		}


		# ROM 13/10/2023 Controllo se esiste gia' un impianto con ws_cod_fisc e indirizzo ws_nome_toponimo.
		# ROM            Al momento Sandro ha detto di non controllare anche il civico ws_civico.
		if {[db_0or1row q "select 1
                                     from coimaimp a
                                     left join coimviae v on v.cod_via       = a.cod_via
                                     left join coimcitt c on c.cod_cittadino = a.cod_responsabile
                                    where upper(v.descrizione) = upper(:ws_nome_toponimo)
                                      and upper(v.descr_topo)  = upper(:ws_tipo_toponimo)
                                      and v.cod_comune       = :cod_comune
                              --      and a.numero           = :ws_civico
                                      and c.cod_fiscale      = :ws_cod_fisc
                                    limit 1"]} {
		    set carica "N"
		    set motivo_scarto "Esiste già un impianto con Cod.Fiscale $ws_cod_fisc all'indirizzo $ws_nome_toponimo"
		}
		# ws_prefisso_telefonico non obbligatorio

		# ws_numero_telefonico non obbligatorio
              set nome   $ws_nome
              set cognome   $ws_cognome
		# finiti i controlli, provvedo a preparare ed inserire i record
		if {$carica == "S"} {
		    # prima di tutto provo a cercare se per caso trovo
		    # un soggetto con stesso nominativo ed indirizzo

		    # ignoro il messaggio di errore.
		    # al massimo in cognome ritrovo l'intera ws_ragione_sociale
		    if {[string length $ws_cognome] > 100} {
			set cognome  [string range $ws_cognome 0 99]
		    }
		    if {[string length $ws_nome] > 100} {
			set nome     [string range $ws_nome    0 99]
		    }
                   
		    if {![string equal "" $nome]} {
			set where_nome "and nome = :nome"
		    } else {
			set where_nome "and nome is null"
		    }

		    set comune        $ws_comune

		    set indirizzo    "$ws_tipo_toponimo $ws_nome_toponimo"
		    if {[string length $indirizzo] > 40} {
			set indirizzo [string range $indirizzo 0 39]
		    }

		    # provo a separare il civico da esponente
		    # serve sia per il soggetto che per l'impianto
		    set numciv_espciv_list [iter_separa_numciv_espciv $ws_civico]
		    set elab_numero        [lindex $numciv_espciv_list 0]
		    set elab_esponente     [lindex $numciv_espciv_list 1]
		    set msg_err            [lindex $numciv_espciv_list 2]
		    # ignoro eventuali messaggi di errore.
		    # comunque numero e' solo numerico.

		    # a volte dentro l'esponente c'e' la localita
		    if {[string length $elab_esponente] > 3} {
			set elab_localita  $elab_esponente
			set elab_esponente ""
		    } else {
			set elab_localita  ""
		    }

		    if {[string length $elab_numero] <= 6
			&& ![string is space $elab_esponente]
		    } {
			set numero        "$elab_numero/$elab_esponente"
		    } else {
			set numero         $elab_numero
		    }

		    if {[string length $numero] > 8} {
			set numero        [string range $numero 0 7]
		    }

		    if {![string equal "" $numero]} {
			set where_numero  "and numero = :numero"
		    } else {
			# se manca il civico, e' sufficiente che il soggetto
			# risieda nella stessa via
			set where_numero   ""
		    }

		    db_1row sel_citt_check ""
		    # con la query precedente ho valorizzato ctr_citt
		    # e cod_cittadino con il max(cod_cittadino)
		    if {$ctr_citt != 1} {

			# se il soggetto non e' stato trovato, lo inserisco
			set cod_cittadino    [db_string sel_dual_cod_cittadino ""]
			set natura_giuridica ""
			# cognome   gia' valorizzato da separa_cog_nom
			# nome      gia' valorizzato da separa_cog_nom
			# indirizzo gia' valorizzato prima della sel_citt_check
			# numero    gia' valorizzato prima della sel_citt_check
			set cap              $ws_cap
			if {[string length $cap] > 5} {
			    set cap          [string range $cap 0 4]
			}

			set localita         $elab_localita

			# comune    gia' valorizzato prima della sel_citt_check
			# provincia gia' valorizzato da sel_comu
			set cod_fiscale      $ws_cod_fisc
			set cod_piva         ""
			set telefono         ""
			if {![string equal "" $ws_prefisso_telefonico]} {
			    set telefono     $ws_prefisso_telefonico
			    append telefono  "/"
			}
			append telefono      $ws_numero_telefonico

			if {[string length $telefono] > 15} {
			    set telefono [string range $telefono 0 14]
			}

			set cellulare        ""
			set fax              ""
			set email            ""
			set data_nas         ""
			set comune_nas       ""
			set utente           $id_utente
			set data_ins         $data_corrente
			set data_mod         ""
			set utente_ult       ""
			set note             ""
			if {$numero ne ""} {#rom03 Aggiunta if e il suo contenuto
			    set indirizzo        "$indirizzo $numero"
			}

			db_dml ins_citt ""
			incr ctr_ins_citt

			# out_cod_cittadino viene scritto sul file degli
			# elaborati ok per tenere traccia dei record inseriti
			set out_cod_cittadino $cod_cittadino
		    } else {
			set out_cod_cittadino ""
		    }

		    # e' inutile provare a cercare se l'impianto esiste gia':
		    # il programma ci impiega di piu' per un 5% di casi
		    # che verranno sanati in fase di inserimento rapporti
		    # di verifica con fusione impianti.
		    # il programma con sel_aimp_check e' stato salvato in /old

		    # preparo le variabili per sel_aimp_check
		    # per le ricerche ignoro l'esponente

		    # inserisco l'impianto
		    set cod_impianto      [db_string sel_dual_cod_impianto ""]

		    if {1 == 0} {#rom02 Aggiunta if ma non il contenuto
		    if {$coimtgen(regione) eq "MARCHE"} {#rom01 aggiunta if e suo contenuto
			#Per le Marche il cod_impianto_est deve essere uguale al cod_impianto
			set cod_impianto_est $cod_impianto
		    } else {#rom01 aggiunta else ma non il suo contenuto
			# se cod_impianto_est viene valorizzato automaticamente
			# uso la sequence come coimaimp-isrt
			# altrimenti calcolo il max + 1 come in copia impianto.
			if {$coimtgen(flag_cod_aimp_auto) == "T"} {
			    set cod_impianto_est  [db_string sel_dual_cod_impianto_est ""]	    
			} else {
			    incr max_cod_impianto_est
			    # valorizzo cod_impianto_est con gli 0 di sinistra
			# esattamente come fa il programma di copia imp.
			    set cod_impianto_est  [format %010d $max_cod_impianto_est]
			}
		    };#rom01
		    };#rom02
		    
		    #ROM02 INIZIO inserimento impianto
		    if {$flag_codifica_reg == "T"} {
			if {$coimtgen(regione) eq "MARCHE"} {
			    if {$coimtgen(ente) eq "CPESARO"} {
				set sigla_est "CMPS"
			    } elseif {$coimtgen(ente) eq "CFANO"} {
				set sigla_est "CMFA"
			    } elseif {$coimtgen(ente) eq "CANCONA"} {
				set sigla_est "CMAN"
			    } elseif {$coimtgen(ente) eq "PAN"} {
				set sigla_est "PRAN"
			    } elseif {$coimtgen(ente) eq "CJESI"} {
				set sigla_est "CMJE"
			    } elseif {$coimtgen(ente) eq "CSENIGALLIA"} {
				set sigla_est "CMSE"
			    } elseif {$coimtgen(ente) eq "PPU"} {
				set sigla_est "PRPU"
			    } elseif {$coimtgen(ente) eq "PMC"} {
				set sigla_est "PRMC"
			    } elseif {$coimtgen(ente) eq "CMACERATA"} {
				set sigla_est "CMMC"
			    } elseif {$coimtgen(ente) eq "CCIVITANOVA MARCHE"} {
				set sigla_est "CMCM"
			    } elseif {$coimtgen(ente) eq "CASCOLI PICENO"} {
				set sigla_est "CMAP"
			    } elseif {$coimtgen(ente) eq "CSAN BENEDETTO DEL TRONTO"} {
				set sigla_est "CMSB"
			    } elseif {$coimtgen(ente) eq "PAP"} {
				set sigla_est "PRAP"
			    } elseif {$coimtgen(ente) eq "PFM"} {
				set sigla_est "PRFM"
			    } else {
				set sigla_est ""
			    }
			    
			    set progressivo_est [db_string sel "select nextval('coimaimp_est_s')"]

			    # devo fare l'lpad con una seconda query altrimenti mi va in errore
			    #set progressivo_est [db_string sel "select lpad(:progressivo_est,6,'0')"]
			    set progressivo_est [db_string sel "select lpad(:progressivo_est,:lun_num_cod_imp_est,'0')"]
			    
			    set cod_impianto_est "$sigla_est$progressivo_est"
			} else {
			    if {$coimtgen(ente) eq "PGO"} {
				set lun_progressivo 7
			    } else {
				set lun_progressivo 6
			    }
			    
			    db_1row sel_dati_comu "select coalesce(progressivo,0) + 1 as progressivo
                                                        , cod_istat
                                                        , id_belfiore -- rom20
                                                     from coimcomu
                                                    where cod_comune = :cod_comune"

			    if {$coimtgen(ente) eq "PMS"} {
				set progressivo [db_string query "select lpad(:progressivo, 5, '0')"]
				set cod_istat  "[string range $cod_istat 5 6]/"
			    } elseif {$coimtgen(ente) eq "PTA"} {
				set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
				set fine_istat  [string length $cod_istat]
				set iniz_ist    [expr $fine_istat -3]
				set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
			    } elseif {$coimtgen(ente) eq "PNA"} {#rom17 Aggiunta elseif e il suo contenuto
				
				set progressivo [db_string query "select lpad(:progressivo, $lun_progressivo, '0')"]
				set fine_istat  [string length $cod_istat]
				set iniz_ist    [expr $fine_istat -3]
				set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
				
			    } else {
				# caso standard
				# La sel_dati_comu andava in errore sul lpad di progressivo.Quindi faccio lpad dopo la query
				set progressivo [db_string query "select lpad(:progressivo, $lun_progressivo, '0')"]
				#if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU"} {
				#     set cod_istat [string range $cod_istat 3 5];#nic02 (fatto da Sandro)
				# }
			    }
			    set potenza "0.00"
			    set cod_potenza "0"
			    if {![string equal $potenza "0.00"]
				&&  ![string equal $potenza ""]
			    } {
				if {$potenza < 35} {
				    set tipologia "IN"
				} else {
				    set tipologia "CT"
				}
				if {$coimtgen(ente) eq "PNA"} {#rom17 Aggiunta if e il suo contenuto
				    set cod_impianto_est "$progressivo/$cod_istat"

				} elseif {$coimtgen(ente) eq "PCE"} {#rom20 Aggiunta elseif e il cuo contenuto
				    set annorif  [db_string query_aa "select (substr(current_date,3,2))"]
				    set cod_impianto_est "$annorif$id_belfiore$progressivo"
				    #set cod_impianto_est "$cod_istat$tipologia$progressivo"

				} else {#rom17 Aggiunta else ma non il suo contenuto
				    set cod_impianto_est "$cod_istat$progressivo"
				};#rom17
				set dml_comu [db_map upd_prog_comu]
			    } else {
				if {![string equal $cod_potenza "0"]
				    &&  ![string equal $cod_potenza ""]
				} {
				    switch $cod_potenza {
					"B"  {set tipologia "IN"}
					"A"  {set tipologia "CT"}
					"MA" {set tipologia "CT"}
					"MB" {set tipologia "CT"}
				    }
				    
				    if {$coimtgen(ente) eq "PNA"} {#rom17 Aggiunta if e il suo contenuto
					set cod_impianto_est "$progressivo/$cod_istat"

				    } elseif {$coimtgen(ente) eq "PCE"} {#rom20 Aggiunta elseif e il cuo contenuto
					set annorif  [db_string query_aa "select (substr(current_date,3,2))"]
					set cod_impianto_est "$annorif$id_belfiore$progressivo"
					#set cod_impianto_est "$cod_istat$tipologia$progressivo"
					
				    } else {#rom17 Aggiunta else ma non il suo contenuto
					set cod_impianto_est "$cod_istat$progressivo"
				    };#rom17
				    set dml_comu [db_map upd_prog_comu]
				} else {
				    if {$coimtgen(ente) eq "PNA"} {#rom17 Aggiunta if e il suo contenuto
					set cod_impianto_est "$progressivo/$cod_istat"

				    } elseif {$coimtgen(ente) eq "PCE"} {#rom20 Aggiunta elseif e il cuo contenuto
					set annorif  [db_string query_aa "select (substr(current_date,3,2))"]
					set cod_impianto_est "$annorif$id_belfiore$progressivo"
					#set cod_impianto_est "$cod_istat$tipologia$progressivo"

				    } else {#rom17 Aggiunta else ma non il suo contenuto
					set cod_impianto_est "$cod_istat$progressivo"
				    };#rom17
				    set dml_comu         [db_map upd_prog_comu]
				}
			    }
			    
			}
		    } else {
			db_1row sel_dual_cod_impianto_est ""
		    }
		    if {$coimtgen(regione) eq "MARCHE"} {
			if {$targa eq ""} {
			    set targa $cod_impianto_est
			}
			set cod_impianto_est $cod_impianto
		    }
		    #ROM02 FINE
		        
		    set cod_impianto_prov  ""
		    set descrizione        ""
		    set provenienza_dati   0;# Archivio esterno
		    set cod_combustibile   ""
		    set cod_potenza        0;# Non noto
		    set potenza            0
		    set potenza_utile      0
		    set data_installaz     "1900-01-01"
		    set data_attivaz       ""
		    set data_rottamaz      ""
		    set note               ""
		    set stato              "D";# Da controllo esterno
		    set flag_dichiarato    "N"
		    set data_prima_dich    ""
		    set data_ultim_dich    ""
		    set cod_tpim           0;# Non noto
		    set consumo_annuo      ""
		    set n_generatori       1
		    set stato_conformita   ""
		    set cod_cted           ""
		    set tariffa            ""
		    set cod_responsabile   $cod_cittadino
		    set flag_resp          "O";# Occupante
		    set cod_intestatario   ""
		    set flag_intestatario  "";# Campo non usato
		    set cod_proprietario   ""
		    set cod_occupante      $cod_cittadino
		    set cod_amministratore ""
		    set cod_manutentore    ""
		    set cod_installatore   ""
		    set cod_distributore   ""
		    set cod_progettista    ""
		    set cod_amag           ""
		    set cod_ubicazione     ""
		    set localita           $elab_localita

		    if {$coimtgen(flag_viario) == "T"} {
			#   cod_via gia' valorizzato da sel_viae_check
			set toponimo       ""
			set indirizzo      ""
		    } else {
			set cod_via        ""
			set toponimo       $ws_tipo_toponimo
			if {[string length $toponimo] > 20} {
			    set toponimo  [string range $toponimo 0 19]
			}

			set indirizzo      $ws_nome_toponimo
			if {[string length $indirizzo] > 100} {
			    set indirizzo [string range $indirizzo 0 99]
			}
		    }

		    if {[string length $elab_numero] <= 8} {
			set numero         $elab_numero
		    } else {
			set numero         [string range $elab_numero 0 7]
		    }
		    set esponente          $elab_esponente

		    set scala              ""
		    set piano              ""
		    set interno            ""
		    #   cod_comune    gia' valorizzato da sel_comu_check
		    #   cod_provincia gia' valorizzato da sel_comu
		    set cap                $ws_cap
		    if {[string length $cap] > 5} {
			set cap            [string range $cap 0 4]
		    }
		    set foglio            ""
		    set cod_tpdu           ""
		    set cod_qua            ""
		    set cod_urb            ""
		    set data_ins           $data_corrente
		    set data_mod           ""
		    set utente             $id_utente
		    set flag_dpr412        "S"
		    
		    set where_indirizzo ""
		    if {![string equal $localita ""]} {
			append where_indirizzo " and localita = :localita"
		    }
		    if {![string equal $cod_via ""]} {
			append where_indirizzo " and cod_via = :cod_via"
		    }
		    if {![string equal $toponimo ""]} {
			append where_indirizzo " and toponimo = :toponimo"
		    }
		    if {![string equal $indirizzo ""]} {
			append where_indirizzo " and indirizzo = :indirizzo"
		    }
		    if {![string equal $numero ""]} {
			append where_indirizzo " and numero = :numero"
		    }
		    if {![string equal $cod_comune ""]} {
			append where_indirizzo " and cod_comune = :cod_comune"
		    }
		    if {![string equal $cod_provincia ""]} {
			append where_indirizzo " and cod_provincia = :cod_provincia"
		    }
		    if {![string equal $cap ""]} {
			append where_indirizzo " and cap = :cap"
		    }
		    
		    db_1row sel_aimp_check ""

		    if {$ctr_aimp > 0} {
			set carica        "N"
			set motivo_scarto "Impianto esistente codice: $cod_impianto_es" 
		    } else {
			db_dml ins_aimp ""
			if {[info exists dml_comu]} {#rom 18/02/2025
			    db_dml dml_coimcomu $dml_comu
			}
			#rom 18/02/2025 db_dml dml_coimcomu $dml_comu
			incr ctr_ins_aimp

			# out_cod_impianto viene scritto sul file degli
			# elaborati ok per tenere traccia dei record inseriti
                        #sandro modifica del 14 01 15
			#set out_cod_impianto   $cod_impianto
                        set out_cod_impianto   $cod_impianto_est
			
			# inserisco il generatore
			#   cod_impianto gia' valorizzato per inserimento impianto
			set gen_prog         1
			set descrizione      ""
			set matricola        ""
			set modello          ""
			set cod_cost         ""
			set matricola_bruc   ""
			set modello_bruc     ""
			set cod_cost_bruc    ""
			set tipo_foco        ""
			set mod_funz         ""
			set cod_utgi         ""
			set tipo_bruciatore  ""
			set tiraggio         ""
			set locale           ""
			set cod_emissione    ""
			set cod_combustibile ""
			#   data_installaz valorizzata per inserimento impianto
			set data_rottamaz    ""
			set pot_focolare_lib 0
			set pot_utile_lib    0
			set pot_focolare_nom 0
			set pot_utile_nom    0
			set flag_attivo      "S"
			set note             ""
			set data_ins         $data_corrente
			set data_mod         ""
			set utente           $id_utente
			set gen_prog_est     1
			
			db_dml ins_gend ""
			incr ctr_ins_gend
			
			# out_gen_prog viene scritto sul file degli
			# elaborati ok per tenere traccia dei record inseriti
			set out_gen_prog     $gen_prog
			
			# ora inserisco finalmente il controllo
			# solo se swc_solo_aimp non vale S
			if {$swc_solo_aimp != "S"} {
			    set cod_inco         [db_string sel_dual_cod_inco ""]
			    #   cod_cinc gia' valorizzato in sel_cinc
			    set tipo_estrazione  4;# Impianti non dichiarati
			    #   cod_impianto  valorizzato in inserimento impianti
			    set data_estrazione  $data_corrente
			    set data_assegn      ""
			    set cod_opve         ""
			    set data_verifica    ""
			    set ora_verifica     ""
			    set data_avviso_01   ""
			    set cod_documento_01 ""
			    set data_avviso_02   ""
			    set cod_documento_02 ""
			    set stato            0;# Estratto
			    set esito            ""
			    
			    # nelle note va indicato il telefono del responsabile.
			    # se non ho il numero di telefono ed il soggetto e'
			    # gia esistente, allora provo a leggerlo dalla coimcitt
			    if {[string equal $out_cod_cittadino ""]} {
				if {![string equal $ws_prefisso_telefonico ""] || ![string equal $ws_numero_telefonico ""]} {
				    set telefono         ""
				    if {![string equal "" $ws_prefisso_telefonico]} {
					set telefono     $ws_prefisso_telefonico
					append telefono  "/"
				    }
				    append telefono      $ws_numero_telefonico
				} else {
				    if {[db_0or1row sel_citt ""] == 0} {
					# e' impossibile che non trovi il record
					# ma evito comunque un eventuale abend
					set telefono ""
				    }
				}
			    }
			    if {![string is space $telefono]} {
				set note       "Telefono responsabile: $telefono. "
			    } else {
				set note       ""
			    }
			    
			    set data_ins         $data_corrente
			    set data_mod         ""
			    set utente           $id_utente
			    
			    if {$coimtgen(flag_ente)  == "P"
				&&  $coimtgen(sigla_prov) == "LI"
			    } {
				set tipo_lettera     "A"
			    } else {
				set tipo_lettera     ""
			    }
			    
			    db_dml ins_inco ""
			    incr ctr_ins_inco
			    
			    # out_cod_inco viene scritto sul file degli
			    # elaborati ok per tenere traccia dei record inseriti
			    set out_cod_inco $cod_inco
			} else {
			    set out_cod_inco ""
			}
			
		    };# fine if $carica == "S"
		}
		# ricostruisco il record di output
		set file_out_col_list ""
		set ind 0
		foreach column_name $file_cols {
		    lappend file_out_col_list [set $column_name]
		    incr ind
		}

		# scrivo un record sul file dei record caricati o scartati
		if {$carica == "S"} {
		    lappend file_out_col_list $out_cod_cittadino
		    lappend file_out_col_list $out_cod_impianto
		    lappend file_out_col_list $out_gen_prog
		    lappend file_out_col_list $out_cod_inco

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

	    # scrivo la pagina di esito
	    set page_title "Esito caricamento controlli/impianti da file esterno"
	    set context_bar [iter_context_bar \
				 [list "javascript:window.close()" "Chiudi finestra"] \
				 "$page_title"]

	    set pagina_esi [subst {
		<master   src="../../master">
		<property name="title">$page_title</property>
		<property name="context_bar">$context_bar</property>

		<center>

		<table>
		<tr><td valign=top class=form_title align=center colspan=4>
		<b>ELABORAZIONE TERMINATA</b>
		</td>
		</tr>

		<tr><td valign=top class=form_title>Letti Controlli/Impianti:</td>
		<td valign=top class=form_title>$ctr_inp</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
                </tr>

                <tr><td colspan=4>&nbsp;</td>

                <tr><td valign=top class=form_title>Caricati Controlli/Impianti:</td>
		<td valign=top class=form_title>$ctr_out</td>
		<td>&nbsp;</td>
		<td valign=top class=form_title><a target="Controlli/Impianti caricati" href="$file_out_url">Scarica il file csv dei controlli/impianti caricati</a></td>
                </tr>

                <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Soggetti:</td>
		<td valign=top class=form_title>$ctr_ins_citt</td>
		<td>&nbsp;</td>
                </tr>

                <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Impianti:</td>
		<td valign=top class=form_title>$ctr_ins_aimp</td>
		<td>&nbsp;</td>
                </tr>

                <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Generatori:</td>
		<td valign=top class=form_title>$ctr_ins_gend</td>
		<td>&nbsp;</td>
                </tr>

                <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Controlli:</td>
		<td valign=top class=form_title>$ctr_ins_inco</td>
		<td>&nbsp;</td>
                </tr>

                <tr><td colspan=4>&nbsp;</td>

                <tr><td valign=top class=form_title>Scartati Controlli/Impianti:</td>
		<td valign=top class=form_title>$ctr_err</td>
		<td>&nbsp;</td>
		<td valign=top class=form_title><a target="Controlli/Impianti scartati" href="$file_err_url">Scarica il file csv dei controlli/impianti scartati</a></td>
                </tr>
	    }]

	    foreach motivo_scarto [lsort [array names ctr_scarto]] {
		set ws_mot_scarto $motivo_scarto
		regsub -all "à" $ws_mot_scarto {\&agrave;} ws_mot_scarto
		regsub -all "è" $ws_mot_scarto {\&egrave;} ws_mot_scarto
		regsub -all "ì" $ws_mot_scarto {\&igrave;} ws_mot_scarto
		regsub -all "ò" $ws_mot_scarto {\&ograve;} ws_mot_scarto
		regsub -all "ù" $ws_mot_scarto {\&ugrave;} ws_mot_scarto

		append pagina_esi [subst {
		    <tr>
                    <td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Per [ad_quotehtml $ws_mot_scarto]:</td>
                    <td valign=top class=form_title>$ctr_scarto($motivo_scarto)</td>
                    <td>&nbsp;</td>
		    </tr>
		}]
	    }

	    append pagina_esi [subst {
                <tr><td colspan=4>&nbsp;</td>

		<tr><td valign=top colspan=4 class=form_title>
		Da questa pagina &egrave; possibile scaricare il file dei
		controlli/impianti caricati ed il file dei controlli/impianti
		scartati.<br>
		Per scaricare il file, fare click col tasto destro del mouse
		sul link corrispondente e selezionare "salva oggetto con nome".
		<p>
		E' possibile modificare il file dei controlli/impianti
		scartati per sistemare gli errori e provare a caricarli
		nuovamente.<br>
		Per fare questo, aprire Excel, selezionare file, apri,
		selezionare "File di Testo" nella casella "Tipo file" ed
		aprire il file precedentemente salvato.<br>
		Ora scegliere l'opzione Tipo di file "Delimitati" e fare click
		su "Avanti".<br>
		Selezionare "Punto e virgola" come "Delimitatore" e fare click
		su "Avanti".<br>
		Selezionare tutte le colonne e scegliere "Testo" come
		"formato dati per colonna".<br>
		Se non si facesse cos&igrave; excel troncherebbe gli zeri del
		prefisso e del numero telefonico e trasformerebbe alcuni civici
		in date (es: 8/10 diventerebbe 8-ott).
		<p>
		Una volta aperto il file, nel caso in cui apportino delle
		modifiche, ricordarsi di salvarlo come "CSV".
		</td>
		</tr>
                </table>
		</center>
	    }]

	    puts $file_esi_id $pagina_esi

	    close $file_inp_id
	    close $file_esi_id
	    close $file_out_id
	    close $file_err_id

	    # inserisco i link ai file di esito sulla tabella degli esiti
	    # ed aggiorno lo stato del batch a 'Terminato'
	    set     esit_list ""
	    lappend esit_list [list "Esito caricamento"  $file_esi_url $file_esi]
	    iter_batch_upd_flg_sta -fine $cod_batc $esit_list
	}
	# fine db_transaction ed ora fine with_catch
    } {
	iter_batch_upd_flg_sta -abend $cod_batc
	ns_log Error "iter_inco_cari3: $error_msg"
    }
    return
}
