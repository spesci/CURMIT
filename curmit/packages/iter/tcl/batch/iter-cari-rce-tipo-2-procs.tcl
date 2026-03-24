ad_proc iter_cari_rcee_tipo_2 {
    {
	-cod_batc      ""
        -id_utente     ""
	-file_name     ""
	-nome_tabella  ""
    }
} {
    Elaborazione     Caricamento controlli/modelli per manutentori
    @author          Simone Pesci (clonato da iter_cari_modelli)
    @creation-date   22/08/2014
    @cvs-id          
    se swc_solo_aimp vale "S" allora non si creano i controlli

    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 06/04/2022 La data di scadenza deve essere calcolata in base alla maggiore tra la potenza
    rom02            frigorifera e la termica, prima veniva settata in base al parametro flag_potenza
    rom02            della coimtgen e venivano utulizzati dei campi inesistenti sulla coimaimp. 

    rom01 19/10/2018 Cambiata la proc richiamata per l'associazione delle targhe da 
    rom01            iter_httpget_wallet a iter_httpget_call_portale perchè dava dei problemi.

    sim17 22/05/2017 Spostato più in alto il controllo del combustibile perchè mi serve la
    sim17            variabile combustibile per il controllo sulla tariffa vecchia

    sim16 01/10/2018 Gestito l'inserimento del contributo regionale sul wallet

    sim15 22/05/2017 Personaliz. per Comune di Jesi: ricodificare gli impianti come da Legge
    sim15            Reg. Marche CMJE.
    sim15            Per Comune di Senigalli: CMSE

    gab01 12/04/2017 Gestito cod_impianto_est per provincia di Ancona

    sim14 09/02/2017 Rivisto le scadenze della Toscana

    sim13 08/02/2017 Gestito cod_impianto_est per Ancona

    sim12 02/02/2017 Solo PFI può inserire manualmente il costo del bollino (anche manutentori)
    sim12            perchè devono recuperare il pregresso. Quindi tolog il controllo

    sim11 03/10/2016 Aggiunta gestione scadenze di Massa

    sim10 28/09/2016 Taranto ha il cod. impianto composto dalle ultime 3 cifre del codice istat
    sim10            + un progressivo.

    sim09 08/09/2016 Se c'e' la gestione della targa devo controllare la targa ed eventualmente
    sim09            salvarla se non ancora presente.

    sim08 29/06/2016 Se il manutentore non ha il patentino non puo' inserire impianti con
    sim08            potenza maggiore di 232 KW.
    sim08            Il controllo va fatto sulla potenza gestita dal parametro 
    sim08            coimtgen(flag_potenza)

    sim07 28/06/2016 Aggiunto controllo che il costo indicato sia uguale alla tariffa.
    sim07            Il controllo tiene conto anche del fatto che:
    sim07            se flag_tariffa_impianti_vecchi eq "t"
    sim07            e il combustibile e' Gas o Metano potrei dover usare una seconda tariffa
    sim07            in base all'anzianita'.

    sim06 21/03/2016 Corretto parte relativa al portafoglio.

    sim05 15/02/2016 Livorno ha chiesto che prima del 30/03/2016 sia possibile inserire RCT
    sim05            piu' vecchi di 90 giorni.
    sim05            Dopo questa data deve essere di 30 giorni.

    sim04 15/02/2016 Per Livorno controllo che il bollino sia pagato.

    nic01 04/02/2016 Gestito coimtgen.lun_num_cod_impianto_est per regione MARCHE

    sim03 28/09/2015 Da ottobre 2015 gli enti della regione marche devono costruire il codice
    sim03            impianto con una sigla imposta dalla regione (es: CMPS) + un progressivo
    sim03            di 6 cifre.

    sim02 25/09/2015 Gestita data scadenza per provincia e comune di Pesaro e Urbino

    sim01 10/02/2015 Aggiunto il controllo sull'esistenza del codice impianto

} {

    # Aggiorno stato di coimbatc
    iter_batch_upd_flg_sta -iniz $cod_batc
    
    ns_log Notice "Inizio sim della proc iter_cari_rcee_tipo_2. id_utente = $id_utente, file_name = $file_name, nome_tabella = $nome_tabella,"
    
    # Al momento il campo non esiste nel csv ma per non scoinvolgere il programma si è deciso con Sandro di settarla a "" all'inizio in modo che non faccia nulla e mantenere il codice.
    set data_rottamaz_gen   ""
    set rct_install_esterna ""

    set data_scadenza_autocert "";#Vedi commento più avanti (questo set serve per tenere le stesse istruzioni di coimdimp-rct-gest più avanti)

    with_catch error_msg {
	
	if {![string equal $nome_tabella ""]} {
	    set nome_tabella_anom [string map {RCEE2CARI ANOM} $nome_tabella]
	    set nome_sequence $nome_tabella
	    append nome_sequence "_s"
	    db_dml upd_table   "update $nome_tabella set flag_stato = null, numero_anomalie = null, cod_impianto_catasto = null, gen_prog_catasto = null where flag_stato = 'P'"
	    db_dml delete_anom "delete from $nome_tabella_anom where id_riga in (select id_riga from $nome_tabella where flag_stato is null)"
	}
	
	# reperisco le colonne della tabella parametri
	iter_get_coimtgen
	set flag_cod_aimp_auto  $coimtgen(flag_cod_aimp_auto)
	set flag_codifica_reg   $coimtgen(flag_codifica_reg)
	set lun_num_cod_imp_est $coimtgen(lun_num_cod_imp_est);#nic01
	set flag_gest_targa     $coimtgen(flag_gest_targa);#sim09

	set stato_tgen [db_string sel_stato_tgen "select cod_imst_cari_manu as stato_tgen from coimtgen"]
	set flag_scarta_via_nt [db_string sel_stato_tgen "select flag_scarta_via_nt from coimtgen"]
	set flag_cod_imp_obblig [db_string sel_stato_tgen "select flag_cod_imp_obblig from coimtgen"]
	set flag_portafoglio [db_string sel_tgen_portafoglio "select flag_portafoglio from coimtgen"]
	set num_anom_max [db_string sel_num_anom_max "select num_anom_max from coimtgen"]

	#provvisori
	set tariffa_reg ""
	set importo_contr ""	
	
	# valorizzo la data_corrente (serve per l'inserimento)
	set data_corrente  [iter_set_sysdate]
	set ora_corrente   [iter_set_systime]
	
	set permanenti_dir [iter_set_permanenti_dir]
	set permanenti_dir_url [iter_set_permanenti_dir_url]
	
	#se non mi viene passato il nome della tabella da analizzare significa che  un nuovo caricamento
	if {[string equal $nome_tabella ""]} {
	    set file_inp_name  "Caricamento-rcee-tipo-2-input"
	    set file_inp_name  [iter_temp_file_name -permanenti $file_inp_name]
	    
	    set file_table_name  "create-table"
	    set file_table_name  [iter_temp_file_name -permanenti $file_table_name]
	}
	
	set file_esi_name  "Caricamento-rcee-tipo-2-esito"
	set file_esi_name  [iter_temp_file_name -permanenti $file_esi_name]
	
	set file_err_name  "Caricamento-rcee-tipo-2-scartati"
	set file_err_name  [iter_temp_file_name -permanenti $file_err_name]
	
	set file_tot_name  "Caricamento-rcee-tipo-2-file"
	set file_tot_name  [iter_temp_file_name -permanenti $file_tot_name]
	
	# salvo i file di output come .txt in modo che excel permetta di
	# indicare il formato delle colonne (testo) al momento
	# dell'importazione del file.
	# in caso contrario i numeri di telefono rimarrebbero senza lo zero
	# ed i civici 8/10 diverrebbero una data!
	# bisogna fare in modo che excel apra correttamente il file
	# degli scarti perche' l'utente potrebbe correggere gli errori
	# e provare a ricaricarli.
	if {[string equal $nome_tabella ""]} {
	    set file_inp       "${permanenti_dir}/$file_inp_name.csv"
	    set file_table     "${permanenti_dir}/$file_table_name.sql"
	    set file_inp_url   "${permanenti_dir_url}/$file_inp_name.csv"
	    set file_table_url "${permanenti_dir_url}/$file_table_name.sql"
	    # rinomino il file (che per ora ha lo stesso nome di origine)
	    # con un nome legato al programma ed all'ora di esecuzione
	    exec mv $file_name $file_inp
	}
	set file_esi       "${permanenti_dir}/$file_esi_name.adp"
	set file_err       "${permanenti_dir}/$file_err_name.txt"
	set file_tot       "${permanenti_dir}/$file_tot_name.txt"
	# in file_esi_url non metto .adp altrimenti su vestademo non
	# viene trovata la url!!
	set file_esi_url   "${permanenti_dir_url}/$file_esi_name"
	set file_err_url   "${permanenti_dir_url}/$file_err_name.txt"
	set file_tot_url   "${permanenti_dir_url}/$file_tot_name.txt"
	
	if {[string equal $nome_tabella ""]} {
	    # apro il file in lettura e metto in file_inp_id l'identificativo
	    # del file per poterlo leggere successivamente
	    if {[catch {set file_inp_id [open $file_inp r]}]} {
		iter_return_complaint "File csv di input non aperto: $file_inp"
	    }
	    # dichiaro di leggere in formato iso West European e di utilizzare
	    # crlf come fine riga (di default andrebbe a capo anche con gli
	    # eventuali lf contenuti tra doppi apici).
	    fconfigure $file_inp_id -encoding iso8859-15
	    
	    if {[catch {set file_table_id [open $file_table w]}]} {
		iter_return_complaint "File creazione tabella non aperto: $file_table"
	    }
	}	
	
	# apro il file in scrittura e metto in file_esi_id l'identificativo
	# del file per poterlo scrivere successivamente
	if {[catch {set file_esi_id [open $file_esi w]}]} {
	    iter_return_complaint "File di esito caricamento non aperto: $file_esi"
	}
	# dichiaro di scrivere in formato iso West European
	fconfigure $file_esi_id -encoding iso8859-15 -translation crlf
	
	# apro il file in scrittura e metto in file_err_id l'identificativo
	# del file per poterlo scrivere successivamente
	if {[catch {set file_err_id [open $file_err w]}]} {
	    iter_return_complaint "File csv dei record scartati non aperto: $file_err"
	}
	# dichiaro di scrivere in formato iso West European
	fconfigure $file_err_id -encoding iso8859-15
	
	
	# apro il file in scrittura e metto in file_tot_id l'identificativo
	# del file per poterlo scrivere successivamente
	if {[catch {set file_tot_id [open $file_tot w]}]} {
	    iter_return_complaint "File csv dei record scartati non aperto: $file_tot"
	}
	# dichiaro di scrivere in formato iso West European
	fconfigure $file_tot_id -encoding iso8859-15
	
	
	# PRIMO STEP: Controllo che il file riporti lo stesso manutentore su tutte le righe (Nel caso di utente manutentore deve riportare la sua ditta)
	set cod_manutentore_chk [iter_check_uten_manu $id_utente]
	
	# preparo e scrivo scrivo la riga di intestazione per file out
	set     head_cols ""

	# definisco il tracciato record del file di input
	set     file_cols ""
	# Setto il nome della tabella da cui leggere le intestazioni
	set csv_name "rcee2"
	set count_fields 0
	# Eseguo la query che reperisce i campi della lista dal db
	db_foreach sel_liste_csv "select nome_colonna
     	                               , denominazione
	                               , tipo_dato
	                               , dimensione
	                               , obbligatorio
	                               , default_value
	                               , range_value
	                            from coimtabs 
	                            where nome_tabella = :csv_name 
	                         order by ordinamento" {

				     lappend head_cols $denominazione
				     
				     # Popolo i campi della lista
				     lappend file_cols $nome_colonna
				     
				     #Memorizzo in un array tutti i dati relativi ad un singoloo campo, necessari per la successiva analisi
				     set file_fields($count_fields) [list $nome_colonna $denominazione $tipo_dato $dimensione $obbligatorio $default_value $range_value]
				     incr count_fields		
				 }

	set err_log ""
        if {[string equal $nome_tabella ""]} {
	    # Setto la lunghezza standard del tracciato in base ai campi letti dal database
	    set lunghezza_attesa [expr $count_fields]
	    
	    # Salto il primo record che deve essere di testata
	    iter_get_csv $file_inp_id file_inp_col_list |

	    # Ciclo di lettura sul file di input
	    # uso la proc perche' i file csv hanno caratteristiche 'particolari'
	    iter_get_csv $file_inp_id file_inp_col_list |
	    set lunghezza_letta [llength $file_inp_col_list]
	    ns_log notice "simone $file_inp_col_list"
	    ns_log notice "simone2 $file_inp_id - $file_inp - $file_inp_name"	    
	    #ns_log notice "prova dob  inizio ciclo lettura file di input"
	    while {![eof $file_inp_id]} {
		# valorizzo le relative colonne
		set ind 0
		ns_log notice "prova dob  file_cols = $file_cols"
		foreach column_name $file_cols {
		    #ns_log notice "prova dob colonna $column_name indice $ind contenuto $file_inp_col_list "
		    set $column_name [lindex $file_inp_col_list $ind]
		    incr ind
		}
		#ns_log notice "prova dob valorizzate colonne"
		if {$lunghezza_letta == $lunghezza_attesa
		    || $lunghezza_letta == [expr $lunghezza_attesa + 6]} {
		    #ns_log notice "prova dob cod_manutentore_chk $cod_manutentore_chk"

		    if {[string equal $cod_manutentore_chk ""]} {
			set cod_manutentore_chk $cod_manutentore
		    } else {
			if {$cod_manutentore != $cod_manutentore_chk
			    || [string equal $cod_manutentore ""]} {
			    append err_log "L'intero lotto &egrave; stato scartato in quanto non presenta un'unica ditta di manutenzione o l'utente manutentore non corrisponde alla ditta del file"
			    break
			}
		    }
		} else {
		    append err_log "L'intero lotto &egrave; stato scartato in quanto una o pi&ugrave; righe non corrisponde alla lunghezza prevista ($lunghezza_attesa) lunghezza letta = $lunghezza_letta."
		    
		    break
		}
		
		# lettura del record successivo
		iter_get_csv $file_inp_id file_inp_col_list |
		set lunghezza_letta [llength $file_inp_col_list]
	    }
	    if {[string equal $err_log ""]} {
		if {[db_0or1row sel_cari_manu "select '1' from coimcari_manu where cod_manutentore = :cod_manutentore"]} {
		    append err_log "L'intero lotto &egrave; stato scartato in quanto la ditta di manutenzione con codice $cod_manutentore sta gi&agrave effettuando un caricamento su questo ente."
		}
	    }
	    
	    if {[string equal $err_log ""]} {

		db_dml ins_cari "insert into coimcari_manu (cod_manutentore) values (:cod_manutentore)"
		# Creo la tabella temporanea e la carico
		set nome_tabella "RCEE2CARI_"
		append nome_tabella $cod_manutentore
		append nome_tabella "_"
		append nome_tabella $data_corrente
		append nome_tabella "_"
		set ora_corrente_edit [string map {: _}  $ora_corrente]
		append nome_tabella $ora_corrente_edit
		set nome_tabella_anom "ANOM_"
		append nome_tabella_anom $cod_manutentore
		append nome_tabella_anom "_"
		append nome_tabella_anom $data_corrente
		append nome_tabella_anom "_"
		append nome_tabella_anom $ora_corrente_edit
		
		puts $file_table_id "create table $nome_tabella
                                        ( "
		
		set i 0
		while {$i < $count_fields} {
		    
		    util_unlist $file_fields($i) nome_colonna denominazione type dimensione obbligatorio default_value range_value
		    if {![string equal $dimensione ""]} {
			set virgola [string first "," $dimensione]
			if {$virgola > 0} {
			    set dimensione 30
			} else {
			    set dimensione [expr $dimensione + 10]
			}
		    } else {
			set dimensione 10
		    }
		    
		    puts $file_table_id "$nome_colonna   varchar($dimensione)
                                     , "
		    incr i
		}
		
		set nome_index $nome_tabella
		append nome_index "_00"
		set nome_sequence $nome_tabella
		append nome_sequence "_s"
		puts $file_table_id "id_riga            varchar(08)
                                 , flag_stato           char (01)
                                 , numero_anomalie      integer 
                                 , cod_impianto_catasto varchar(08)
                                 , gen_prog_catasto     varchar(08) );

                                 create unique index $nome_index
                                     on $nome_tabella
                                   ( id_riga);

                                 create sequence $nome_sequence start 1;

                                 create table $nome_tabella_anom
                                            ( id_riga          varchar(08)
                                            , cod_manutentore  varchar(08)
                                            , nome_colonna     varchar(40)
                                            , desc_errore      varchar(1000)
                                            );
                                "

		close $file_table_id
		set database [db_get_database]

		if {$coimtgen(regione) eq "MARCHE"} {
		    exec psql $database -f ${permanenti_dir}/$file_table_name.sql -h 10.101.11.107 
		} else {
		    exec psql $database -f ${permanenti_dir}/$file_table_name.sql
		}

		close $file_inp_id
		
		if {[catch {set file_inp_id [open $file_inp r]}]} {
		    iter_return_complaint "File csv di input non aperto: $file_inp"
		}
		
		# Salto il primo record che deve essere di testata
		iter_get_csv $file_inp_id file_inp_col_list |
		
		# Ciclo di lettura sul file di input
		# uso la proc perche' i file csv hanno caratteristiche particolari
		iter_get_csv $file_inp_id file_inp_col_list |
		
		while {![eof $file_inp_id]} {

		    set i 0
		    set variabili_da_ins ""
		    while {$i < $count_fields} {
			
			set colonna [lindex $file_inp_col_list $i]
			set colonna [string trim $colonna]
			set colonna [string toupper $colonna]
			# Bonifico l'elemento da possibili caratteri che non vengono accettati dal database
			set colonna [string map {\\ "" \r " " \n " " \r\n " " ' "''"} $colonna]
			
			if {$i > 0} {
			    append variabili_da_ins ","
			}
			append variabili_da_ins "'$colonna'"
			
			incr i
		    }
		    
		    db_dml ins_tabs "insert into $nome_tabella
                                             values ( $variabili_da_ins , nextval('$nome_sequence'), null, 0 )"
		    
		    
		    # lettura del record successivo
		    iter_get_csv $file_inp_id file_inp_col_list |
		}
		close $file_inp_id
	    }
	}

	#setto un array contenente tutti i codici delle anomalie per verificare la loro esistenza durante il caricamento dei modelli
	db_foreach sel_cod_tanom "select cod_tano as codice_anomalia from coimtano" {
	    set anomalie($codice_anomalia) 1
	    
	}
	# Setto una sola volta l'array dei comuni possibili all'interno dell'ente
	db_foreach sel_comuni "select cod_comune , denominazione as nome_comune from coimcomu" {
	    set comuni($nome_comune) $cod_comune
	}
	# Setto una sola volta l'array dei costruttori
	db_foreach sel_cost "select cod_cost, descr_cost from coimcost" {
	    set costruttori($descr_cost) $cod_cost
	}

	if {[string equal $err_log ""]} {
	    db_foreach sel_coimcari_manu "select * from $nome_tabella where flag_stato is null" {
		set errori 0
		set i 0
		while {$i < $count_fields} {

		    util_unlist $file_fields($i) col_name denominazione type dimension obbligatorio default_value range_value
		    incr i

		    #ns_log notice "prova dob $col_name $denominazione $type $dimension $obbligatorio $default_value $range_value"

		    
		    set colonna [set $col_name]

		    if {[string equal $colonna ""]} {
			if {[string equal $obbligatorio "S"]} {
			    if {(![string equal $data_rottamaz_gen ""]
				 && ($col_name == "matricola"
				     || $col_name == "modello"
				     || $col_name == "cod_manutentore"
				     || $col_name == "cod_fiscale_resp"
				     || $col_name == "toponimo"
				     || $col_name == "indirizzo"
				     || $col_name == "comune"
				     || $col_name == "marca"
				     || $col_name == "flag_responsabile"))
				|| [string equal $data_rottamaz_gen ""]} {				
				set valori_possibili ""
				if {![string equal $range_value ""]} {
				    set valori_possibili "con $range_value"
				}
				set desc_errore "Il campo &egrave; obbligatorio. Valorizzare $valori_possibili."
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
			    }
			}
		    } else {
			if {(![string equal $data_rottamaz_gen ""]
			     && ($col_name == "matricola"
				 || $col_name == "modello"
				 || $col_name == "cod_manutentore"
				 || $col_name == "cod_fiscale_resp"
				 || $col_name == "toponimo"
				 || $col_name == "indirizzo"
				 || $col_name == "comune"
				 || $col_name == "marca"
				 || $col_name == "flag_responsabile"))
			    || [string equal $data_rottamaz_gen ""]} {							
			    switch $type {
				date {
				    #Nel caso venga inserito solo l'anno aggiungerò di default 01/01
				    if {[string length $colonna] == 4} {
					set colonna "$colonna-01-01"
				    }
				    set colonna [string map {- ""}  $colonna]
				    db_dml q "update $nome_tabella set $col_name=:colonna where id_riga=:id_riga"
				    set date [iter_edit_date $colonna]

				    if {[iter_check_date $date] == "0"} {
					set desc_errore "Il campo deve essere una data (in formato AAAA-MM-GG)"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
				    }
				}
				numeric {
				    set int_dec [split $dimension \,]
				    util_unlist $int_dec intero decimale
				    if {[iter_edit_num $colonna $decimale] != "Error"} {
					set element_int_dec [split $colonna \.]
					util_unlist $element_int_dec parte_intera parte_decimale
					
					set max_value [expr pow(10,[expr $intero - $decimale]) - 1]
					if {($parte_intera > [expr $max_value - 1]) || ($parte_intera < [expr (-1 * $max_value) +1])} {
					    set desc_errore "Il campo deve essere numerico di [expr $intero-$decimale] cifre"
					    incr errori
					    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
					} else {
					    
					    if {![string equal $range_value ""]} {
						set range_list [split $range_value \,]
						set num_range [llength $range_list]
						
						set x 0
						set ok_range 0
						while {$x < $num_range} {
						    if {$colonna == [lindex $range_list $x]} {
							incr ok_range
						    }
						    incr x
						}
						if {$ok_range == 0} {
						    set desc_errore "Il campo deve assumere uno dei seguenti valori: '$range_value'"
						    incr errori
						    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
						}			
					    }
					}			    		     
					set max_value [expr pow(10,$decimale)]
					if {($parte_decimale > [expr $max_value - 1])} {
					    set desc_errore "Il campo deve avere $decimale cifre decimali"
					    incr errori
					    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
					} else {			
					    if {![string equal $range_value ""]} {
						set range_list [split $range_value \,]
						set num_range [llength $range_list]
						
						set x 0
						set ok_range 0
						while {$x < $num_range} {
						    if {$colonna == [lindex $range_list $x]} {
							incr ok_range
						    }
						    incr x
						}
						if {$ok_range == 0} {
						    set desc_errore "Il campo deve assumere uno dei seguenti valori: '$range_value'"
						    incr errori
						    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
						}   
					    }	
					}
					
				    } else {
					set desc_errore "Il campo deve essere un numero (per i decimali usare il separatore . )"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
				    }
				}
				
				varchar {
				    set colonna [string toupper $colonna]
				    set colonna_length [string length $colonna]
				    if {$colonna_length > $dimension} {
					set desc_errore "Il campo deve essere al massimo di $dimension caratteri"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
				    } else {
					
					if {![string equal $range_value ""]} {
					    set range_list [split $range_value \,]
					    set num_range [llength $range_list]
					    
					    set x 0
					    set ok_range 0
					    while {$x < $num_range} {
						if {$colonna == [lindex $range_list $x]} {
						    incr ok_range
						}
						incr x
					    }
					    if {$ok_range == 0} {
						set desc_errore "Il campo deve assumere uno dei seguenti valori: '$range_value'"
						incr errori
						db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :col_name , :desc_errore )"
					    }
					}
				    }
				}
			    }
			}
		    }
		}

		if {$errori > 0} {
		    
		    # $num_anom_max
		    if {$errori > 100} {
			db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
		    } else {
			set cod_comune_chk ""
			if {![string equal $comune ""]} {
			    if {![info exist comuni($comune)]} {
				set desc_errore "Comune inesistente"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune' , :desc_errore )"
			    } else {
				set cod_comune_chk $comuni($comune)
			    }
			}
			if {![string equal $toponimo ""] && ![string equal $indirizzo ""] && ![string equal $cod_comune_chk ""]} {
			    # Controllo sull'indirizzo		    
			    if {$coimtgen(flag_viario) == "F"} {
				set where_indirizzo "and upper(toponimo) = :toponimo
	                                                         and upper(indirizzo) = :indirizzo"
			    } else {
				if {[db_0or1row sel_viae_check "select cod_via
	  	                                                              from coimviae
	  	                                                             where upper(descr_topo)  = :toponimo
		                                                               and upper(descrizione) = :indirizzo
	                                                                       and cod_via_new is null
		                                                               and cod_comune = :cod_comune_chk
	                                                                       limit 1"]} {
				    set where_indirizzo "and cod_via = :cod_via"
				} else {
				    set desc_errore "Indirizzo inesistente nel viario"
				    incr errori
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'toponimo' , null )"
				}
			    }
			}
			db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
		    }
		} else {

		    #superati controlli integrita eseguo controlli esistenza: comune responsabile
		    # indirizzo costruttore costruttore bruciatore operatore manutentore combustibile
		    
		    #sim01 Controllo che esista l'impianto con quel codice
		    if {![db_0or1row sel_impianto "select cod_impianto from coimaimp where cod_impianto_est = :cod_impianto_est"]} {;#sim01
			set desc_errore "Non è censito nessun impianto con codice $cod_impianto_est";#sim01
			incr errori;#sim01
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :desc_errore )";#sim01
		    };#sim01

		    # Controllo sul comune dell'impianto
		    set cod_comune_chk ""
		    if {![info exist comuni($comune)]} {
			set desc_errore "Comune inesistente"
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune' , :desc_errore )"
		    } else {
			set cod_comune_chk $comuni($comune)
		    }
		    
		    # Controllo sul responsabile
		    switch $flag_responsabile {
			"A" { 
			    if {[string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (amministratore) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
			    }
			}
			"O" {
			    if {[string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (occupante) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
			    } else {
				set cognome_occu $cognome_resp
			    }
			}
			"P" {
			    if {[string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (proprietario) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
			    } else {
				set cognome_prop $cognome_resp
			    }
			}
			"T" {
			    if {[string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (terzo) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
			    } else {
				if {[string equal $nome_resp ""]} {
				    set where_nome_chk " and nome is null"
				} else {
				    set where_nome_chk " and upper(nome) = :nome_resp"
				}
				if {[string equal $indirizzo_resp ""]} {
				    set where_indirizzo_chk " and indirizzo is null"
				} else {
				    set where_indirizzo_chk " and upper(indirizzo) = :indirizzo_resp"
				}
				if {[string equal $comune_resp ""]} {
				    set where_comune_chk " and comune is null"
				} else {
				    set where_comune_chk " and upper(comune) = :comune_resp"
				}
				if {[string equal $cod_fiscale_resp ""]} {
				    set where_cod_fiscale_chk " and cod_fiscale is null"
				} else {
				    set where_cod_fiscale_chk " and upper(cod_fiscale) = :cod_fiscale_resp"
				}
				if {[db_0or1row sel_citt_check "select cod_cittadino as cod_terzi from coimcitt
			                                                         where upper(cognome) = :cognome_resp
		                                                                $where_nome_chk
		                                                                $where_indirizzo_chk
		                                                                $where_comune_chk
                                                                                $where_cod_fiscale_chk
		                                                                limit 1"]} {
				    db_1row sel_terzi "select cod_legale_rapp from coimmanu where cod_manutentore = :cod_manutentore"
				    if {[string equal $cod_legale_rapp ""]
					|| $cod_legale_rapp != $cod_terzi} {
					ns_log notice "Gacalin- cod_legale_rapp$cod_legale_rapp cod_terzi=$cod_terzi"

					set desc_errore "Il terzo responsabile non corrisponde a quello della ditta di manutenzione, ricontrolla i dati relativi"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'nome_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_fiscale_resp', :desc_errore )"
				    }
				} else {
				    set desc_errore "Il responsabile (terzi) non &egrave; presente nell'anagrafica, ricontrolla i dati relativi"
				    incr errori
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'nome_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_fiscale_resp' ,:desc_errore )"
				}
			    }
			}
		    }
		    
		    # Controllo sull'indirizzo		    
		    if {$coimtgen(flag_viario) == "F"} {
			set where_indirizzo "and upper(toponimo) = :toponimo
	                                                         and upper(indirizzo) = :indirizzo"
		    } else {

			if {[db_0or1row sel_viae_check "select cod_via
	  	                                                              from coimviae
	  	                                                             where upper(descr_topo)  = :toponimo
		                                                               and upper(descrizione) = :indirizzo
	                                                                       and cod_via_new is null
		                                                               and cod_comune = :cod_comune_chk
	                                                                       limit 1"]} {
			    set where_indirizzo "and cod_via = :cod_via"
			} else {
			    set desc_errore "Indirizzo inesistente nel viario"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo' , :desc_errore )"
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'toponimo' , null )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    }
		    
		    # Controllo sul costruttore
		    set cod_cost_chk ""
		    if {![info exist costruttori($marca)]} {
			set desc_errore "Marca generatore inesistente"
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'marca' , :desc_errore )"
		    } else {
			set cod_cost_chk $costruttori($marca)
		    }
		    
		    #controllo sul operatore manutentore
		    if {![string equal $cod_opmanu_new ""]} {

			if {[db_0or1row sel_opma "select '1' from coimopma where cod_opma = :cod_opmanu_new and cod_manutentore = :cod_manutentore"] == 0} {
			    set desc_errore "Operatore manutentore inesistente"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_opmanu_new' , :desc_errore )"
			}
		    }

		    #AGGIUNTI controlli su ora_inzio e ora_fine
		    if {![string equal $ora_inizio ""]} {
			set ora_inizio [iter_check_time $ora_inizio]
			if {$ora_inizio eq "0"} {
			    set desc_errore "Ora errata. Deve essere scritta nel formato hh24:mi"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'ora_inizio' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    }
		    if {![string equal $ora_fine ""]} {
			set ora_fine [iter_check_time $ora_fine]
			if {$ora_fine eq "0"} {
			    set desc_errore "Ora errata. Deve essere scritta nel formato hh24:mi"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'ora_fine' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    }

		    if {$coimtgen(regione) eq "MARCHE"} {
			if {$targa eq ""} {
			    
			    set desc_errore "Il campo targa è obbligatorio"
			    incr errori
			    incr error_targa
			    #			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
			    db_dml ins_anom "insert into $nome_tabella_anom 
                                                      values ( :id_riga 
                                                             , :cod_manutentore
                                                             , 'targa' 
                                                             , :desc_errore )"
			    
			    ns_log notice "Simone: errore Il campo targa è obbligatorio"
			    
			} else {
			    if {![db_0or1row q "select 1 from coimaimp where cod_impianto = :cod_impianto and targa= :targa"]} {
				set descr_errore "La targa non è associata all'impianto"
				incr errori
				incr error_targa
				db_dml upd_riga "update $nome_tabella 
                                                    set numero_anomalie = '1' 
                                                      , flag_stato = 'S' 
                                                  where id_riga = :id_riga"
				db_dml ins_anom "insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
			    }	
			}
		    } else {
			#di default se non uso la targa la setto vuota
			if {$flag_gest_targa ne "T"} {
			    set targa ""
			    set inserire_targa "f"
			}
			
			if {$flag_gest_targa eq "T"} {#sim09: aggiunta if e suo contenuto
			    
			    set error_targa 0
			    
			    if {$targa eq ""} {
				
				set desc_errore "Il campo targa è obbligatorio"
				incr errori
				incr error_targa
				#			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
				db_dml ins_anom "insert into $nome_tabella_anom 
                                                      values ( :id_riga 
                                                             , :cod_manutentore
                                                             , 'targa' 
                                                             , :desc_errore )"
				
				ns_log notice "Simone: errore Il campo targa è obbligatorio"
				
			    } else {
				
				set cod_manutentore_targa $cod_manutentore
				
				set nome_db [db_get_database]
				set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale]
				set dyn_url "$url_portale/iter-portal/targhe/targhe-controllo?targa=$targa&cod_manutentore=$cod_manutentore_targa"
				#rom01set data [iter_httpget_wallet $dyn_url];#sim
				set data [iter_httpget_call_portale $dyn_url];#rom01
				
				#			    set data [ad_httpget -url $dyn_url -timeout 100]
				array set result $data
				set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]

				set inserire_targa "t"
				if {$risultato != "OK"} {
				    set desc_errore "Targa non assegnata al manutentore"
				    incr errori
				    incr error_targa
				    db_dml upd_riga "update $nome_tabella 
                                                    set numero_anomalie = '1' 
                                                      , flag_stato = 'S' 
                                                  where id_riga = :id_riga"
				    db_dml ins_anom "insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
				    
				} else {

				    set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
				    set nome_db_utilizzo_targa [string range $parte_2 0 [expr [string first " " $parte_2] - 1]]
				    set parte_3 [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
				    set cod_impianto_caldo_targa [string range $parte_3 0 [expr [string first " " $parte_3] - 1]]
				    set cod_impianto_freddo_targa [string range $parte_3 [expr [string first " " $parte_3] + 1] end]
				    
				    regsub -all "{" $nome_db_utilizzo_targa    "" nome_db_utilizzo_targa
				    regsub -all "}" $nome_db_utilizzo_targa    "" nome_db_utilizzo_targa
				    regsub -all "{" $cod_impianto_caldo_targa  "" cod_impianto_caldo_targa
				    regsub -all "}" $cod_impianto_caldo_targa  "" cod_impianto_caldo_targa
				    regsub -all "{" $cod_impianto_freddo_targa "" cod_impianto_freddo_targa
				    regsub -all "}" $cod_impianto_freddo_targa "" cod_impianto_freddo_targa

				    
				    db_0or1row q "select flag_tipo_impianto
                                                   , cod_responsabile as cod_responsabile_targa
                                                from coimaimp
                                               where cod_impianto = :cod_impianto"
				    
				    if {$nome_db_utilizzo_targa != ""} {
					
					#il campo targa era già stato associato all'impianto su cui opero
					if {$cod_impianto eq $cod_impianto_caldo_targa 
					    || $cod_impianto eq $cod_impianto_freddo_targa} {
					    set inserire_targa "f"
					} else {
					    
					    #verifico che la targa sia usata su un impianto di questa istanza
					    if {$nome_db_utilizzo_targa != $nome_db} {
						
						#è su un'altra istanza
						set inserire_targa "f"
						set desc_errore "Targa già associata ad un impianto"
						incr errori
						incr error_targa
						
						if {$error_targa !=0 } {
						    db_dml upd_riga "update $nome_tabella 
                                                                set numero_anomalie = '1' 
                                                                  , flag_stato      = 'S' 
                                                              where id_riga         = :id_riga"
						    db_dml ins_anom "
                                                 insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
						}
					    } else {
						
						#è sulla medesima istanza
						set cod_impianto_est_freddo ""
						set cod_responsabile_freddo ""
						set cod_comune_freddo       ""
						set cod_via_freddo          ""
						set numero_freddo           ""
						set cod_impianto_est_caldo  ""
						set cod_responsabile_caldo  ""
						set cod_comune_caldo        ""
						set cod_via_caldo           ""
						set numero_caldo            ""
						set numero $toponimo
						
						#ricavo i dati dell'eventuale impianto del freddo associato
						db_0or1row q "
                                  select cod_impianto_est as cod_impianto_est_freddo
                                       , cod_responsabile as cod_responsabile_freddo 
                                       , cod_comune       as cod_comune_freddo
                                       , cod_via          as cod_via_freddo
                                       , numero           as numero_freddo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_freddo_targa"
						
						#ricavo i dati dell'eventuale impianto del caldo associato
						db_0or1row q "
                                  select cod_impianto_est as cod_impianto_est_caldo
                                       , cod_responsabile as cod_responsabile_caldo
                                       , cod_comune       as cod_comune_caldo
                                       , cod_via          as cod_via_caldo
                                       , numero           as numero_caldo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_caldo_targa"
						
						#se lavoro su un impianto del freddo
						if {$flag_tipo_impianto eq "F" && $cod_impianto_freddo_targa ne ""} {
						    #ha già un impianto del freddo associato
						    set inserire_targa "f"
						    set desc_errore "Targa già associata all'impianto $cod_impianto_est_freddo"
						    incr errori
						    incr error_targa
						    if {$error_targa !=0 } {
							db_dml upd_riga "update $nome_tabella 
                                                                set numero_anomalie = '1' 
                                                                  , flag_stato      = 'S' 
                                                              where id_riga         = :id_riga"
							
							db_dml ins_anom "
                                                 insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
						    }
						} else {
						    
						    #la targa ha associato un impianto del caldo che non ha i medesimi dati ubicazione e resp del nostro
						    if {$cod_impianto_caldo_targa ne "" &&
							($cod_responsabile_caldo  != $cod_responsabile_targa
							 || $cod_comune_caldo     != $cod_comune
							 || $cod_via_caldo        != $cod_via
							 || $numero_caldo         != $numero)} {
							
							set inserire_targa "f"
							set desc_errore "Targa già associata all'impianto $cod_impianto_est_caldo"
							incr errori
							incr error_targa
							if {$error_targa !=0 } {
							    db_dml upd_riga "update $nome_tabella 
                                                                        set numero_anomalie = '1'
                                                                          , flag_stato = 'S'
                                                                      where id_riga = :id_riga"
							    db_dml ins_anom "
                                                 insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
							}
						    }			    
						}
						
						if {$flag_tipo_impianto eq "R" && $cod_impianto_caldo_targa ne ""} {
						    set inserire_targa "f"
						    
						    set desc_errore "Targa già associata all'impianto $cod_impianto_est_caldo"
						    incr errori
						    incr error_targa
						    if {$error_targa !=0 } {
							db_dml upd_riga "update $nome_tabella 
                                                                set numero_anomalie = '1' 
                                                                  , flag_stato      = 'S' 
                                                              where id_riga         = :id_riga"
							
							db_dml ins_anom "
                                                 insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
						    }
						} else {
						    
						    #la targa ha associato un impianto del freddo che non ha i medesimi dati ubicazione e resp del nostro
						    if {$cod_impianto_freddo_targa ne "" &&
							($cod_responsabile_freddo != $cod_responsabile_targa
							 || $cod_comune_freddo    != $cod_comune
							 || $cod_via_freddo       != $cod_via
							 || $numero_freddo        != $numero)} {
							
							set inserire_targa "f"
							
							set desc_errore "Targa già associata all'impianto $cod_impianto_est_freddo"
							incr errori
							incr error_targa
							if {$error_targa !=0 } {
							    
							    db_dml upd_riga "update $nome_tabella 
                                                                set numero_anomalie = '1' 
                                                                  , flag_stato      = 'S' 
                                                              where id_riga         = :id_riga"
							    
							    db_dml ins_anom "
                                                 insert into $nome_tabella_anom
                                                      values ( :id_riga
                                                             , :cod_manutentore
                                                             , 'targa'
                                                             , :desc_errore )"
							}
						    }
						}
					    }
					}
				    }
				}
			    }
			}
		    }
		    #sim09: FINE CONTROLLI TARGA 

		    if {$errori > 0} {
			if {$errori > $num_anom_max} {
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
			} else {
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    } else {
			set cod_impianto ""
			#superati controlli esistenza ricerco l'impianto nel catasto
			if {![string equal $cod_impianto_est ""]} {
			    #caso in cui cod impianto  valorizzato
			    if {[db_0or1row sel_impianto "select cod_impianto from coimaimp where cod_comune = :cod_comune_chk and cod_impianto_est = :cod_impianto_est"]} {
				
				#trovato impianto per comune e provincia
				if {[db_0or1row sel_aimp_check "select cod_impianto from coimaimp where 1 = 1 $where_indirizzo and cod_impianto_est = :cod_impianto_est"]} {
				    #impianto trovato per indirizzo
				    db_dml upd_riga "update $nome_tabella set cod_impianto_catasto = :cod_impianto where id_riga = :id_riga"

				    if {[db_0or1row sel_impianto "select b.gen_prog as gen_prog_check from coimaimp a
	                                                                               , coimgend b
	                                                                         where a.cod_impianto = b.cod_impianto
	                                                                           and a.cod_impianto_est = :cod_impianto_est
	                                                                           and b.matricola = :matricola
	                                                                           and b.cod_cost  = :cod_cost_chk limit 1"]} {
					
					db_dml upd_riga "update $nome_tabella set gen_prog_catasto = :gen_prog_check where id_riga = :id_riga"
				    } else {

					#togli errore e inserisci novo generatore
					#							set desc_errore "Generatore non trovato controlla marca e matricola"
					#							incr errori
					#							db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'marca' , :desc_errore )"
					#							db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'matricola' , :desc_errore )"
					#							db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
				    }
				} else {
				    set desc_errore "Impianto trovato ma con indirizzo diverso"
				    incr errori
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'toponimo' , null )"
				    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
				}
				
			    } else {
				set desc_errore "Impianto non trovato per comune. Il codice impianto non &egrave; stato assegnato correttamente"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :desc_errore )"
				db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
			    }
			} else {
			    #rinisci query
			    db_1row sel_n_impianti "select count(*) as conta_impianti_trovati from coimaimp a
                                                                               , coimgend b
                                                                         where a.cod_impianto = b.cod_impianto
                                                                           and a.cod_comune = :cod_comune_chk
                                                                           and b.matricola = :matricola
                                                                           and b.cod_cost  = :cod_cost_chk
                                                                           and a.stato = 'A'
                                                                          $where_indirizzo"
			    

			    if {$conta_impianti_trovati > 1} {
				
				set desc_errore "Trovati piu impianti attivi aventi stesso indirizzo costruttore e matricola"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :desc_errore )"
				db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
				
			    } else {
				
				if {[db_0or1row sel_impianto "select a.cod_impianto, b.gen_prog as gen_prog_check from coimaimp a
                                                                               , coimgend b
                                                                         where a.cod_impianto = b.cod_impianto
                                                                           and a.cod_comune = :cod_comune_chk
                                                                           and b.matricola = :matricola
                                                                           and b.cod_cost  = :cod_cost_chk
                                                                           and a.stato = 'A'
                                                                          $where_indirizzo limit 1"]} {
				    db_dml upd_riga "update $nome_tabella set cod_impianto_catasto = :cod_impianto where id_riga = :id_riga"
				    db_dml upd_riga "update $nome_tabella set gen_prog_catasto = :gen_prog_check where id_riga = :id_riga"
				}
			    }
			}
		    }

		    #controllo che il manutentore sia associato all'impianto in cui sto inserendo l'rcee.
		    if {![db_0or1row q "select cod_impianto as cod_impianto_per_controllo 
                                          from coimaimp 
                                         where cod_impianto_est = :cod_impianto 
                                           and cod_manutentore  = :cod_manutentore"]} {
			set desc_errore "Il manutentore non è associato all'impianto"
			incr errori
			
			db_dml upd_riga "update $nome_tabella 
                                            set numero_anomalie = '1' 
                                              , flag_stato      = 'S' 
                                          where id_riga         = :id_riga"
			
			db_dml ins_anom "
                                         insert into $nome_tabella_anom
                                              values ( :id_riga
                                                     , :cod_manutentore
                                                     , 'cod_manutentore'
                                                     , :desc_errore )"
			
		    }

		    if {$coimtgen(regione) eq "MARCHE"} {

			#controllo che il responsabile sia associato all'impianto
			set cod_citt [db_string sel_citt_check "select cod_cittadino as cod_citt
                                                              from coimcitt
                                                       	     where upper(cognome) = upper(:cognome_resp)
                                                               and upper(nome) = upper(:nome_resp)
                                                               and upper(indirizzo) = upper(:indirizzo_resp)
                                                               and upper(comune) = upper(:comune_resp)
                                                               and upper(cod_fiscale) = upper(:cod_fiscale_resp)
                                                             limit 1" -default ""]

			set cod_responsabile [db_string q "select cod_responsabile 
                                                             from coimaimp 
                                                            where cod_impianto = :cod_impianto" -default ""]
			
			switch $flag_responsabile {
			    "P" {
				set cod_proprietario [db_string q "select cod_proprietario
                                                                     from coimaimp
                                                                    where cod_impianto = :cod_impianto" -default ""]

				if {$cod_proprietario ne $cod_citt || $cod_proprietario ne $cod_responsabile} {
				    set desc_errore "Il responsabile non corrisponde al proprietario dell'impianto, ricontrolla i dati relativi"
				    incr errori

				    db_dml upd_riga "update $nome_tabella
                                            set numero_anomalie = '1'
                                              , flag_stato      = 'S'
                                          where id_riga         = :id_riga"
				    
				    db_dml ins_anom "
                                         insert into $nome_tabella_anom
                                              values ( :id_riga
                                                     , :cod_manutentore
                                                     , 'cod_responsabile'
                                                     , :desc_errore )"
				}
			    }
			    "O" {
				set cod_occupante [db_string q "select cod_occupante
                                                                     from coimaimp
                                                                    where cod_impianto = :cod_impianto" -default ""]

				if {$cod_occupante ne $cod_citt || $cod_occupante ne $cod_responsabile} {
				    set desc_errore "Il responsabile non corrisponde all'occupante dell'impianto, ricontrolla i dati relativi"
				    incr errori

				    db_dml upd_riga "update $nome_tabella
                                            set numero_anomalie = '1'
                                              , flag_stato      = 'S'
                                          where id_riga         = :id_riga"
				    
				    db_dml ins_anom "
                                         insert into $nome_tabella_anom
                                              values ( :id_riga
                                                     , :cod_manutentore
                                                     , 'cod_responsabile'
                                                     , :desc_errore )"
				}
			    }
			    "A" {
				set cod_amministratore [db_string q "select cod_amministratore
                                                                     from coimaimp
                                                                    where cod_impianto = :cod_impianto" -default ""]

				if {$cod_amministratore ne $cod_citt || $cod_amministratore ne $cod_responsabile} {
				    set desc_errore "Il responsabile non corrisponde all'amministratore dell'impianto, ricontrolla i dati relativi"
				    incr errori

				    db_dml upd_riga "update $nome_tabella
                                            set numero_anomalie = '1'
                                              , flag_stato      = 'S'
                                          where id_riga         = :id_riga"
				    
				    db_dml ins_anom "
                                         insert into $nome_tabella_anom
                                              values ( :id_riga
                                                     , :cod_manutentore
                                                     , 'cod_responsabile'
                                                     , :desc_errore )"
				}
			    }
			    "T" { }
			}
		    }
		}

		#controlli sulla dichiarazione
		if {$errori == 0
		    && [string equal $data_rottamaz_gen ""]} {
		    
		    if {![string equal $cod_impianto ""]} {
			if {[catch {set d_dummy [db_1row query "select to_date(:data_controllo,'YYYYMMDD') as dummy"]} var_errore_dummy]
			} {
			    set desc_errore "Data controllo errata"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'data_controllo' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"

			} elseif {[db_0or1row sel_dimp "select cod_dimp from coimdimp where cod_impianto = :cod_impianto and data_controllo = :data_controllo limit 1"]} {
			    set desc_errore "Dichiarazione gi&agrave; presente controlla la data"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'data_controllo' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    }		    
		    
		    if {$coimtgen(ente) eq "PLI"} {#sim05 Aggiunta if e suo contenuto
			set current_date [iter_set_sysdate]
			if {$current_date < 20160331} {
			    set num_gg_post_data_controllo_per_messaggio 90
			} else {
			    set num_gg_post_data_controllo_per_messaggio 40
			}
			set oggi50 [clock format [clock scan "$data_controllo + $num_gg_post_data_controllo_per_messaggio days"] -format "%Y%m%d"]
			
			if {$current_date > $oggi50} {
			    
			    set desc_errore "Non è possibile inserire rapporti di controllo tecnico oltre i $num_gg_post_data_controllo_per_messaggio giorni dalla data di effettuazione del controllo"
			    incr errori

			    db_dml ins_anom "
                            insert 
                              into $nome_tabella_anom 
                            values (:id_riga 
                                   ,:cod_manutentore
                                   ,'data_controllo' 
                                   ,:desc_errore
                                   )"

			    db_dml upd_riga "
                            update $nome_tabella 
                               set numero_anomalie = :errori 
                                 , flag_stato      = 'P' 
                             where id_riga = :id_riga"
			}
		    }		    
		}
	    }
	    #chiude db_foreach sulla tabella
	} else {

	    set page_title "Esito caricamento RCEE di tipo 2 per manutentori"
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
		
		
		<table>
		<tr><td valign=top class=form_title align=center colspan=4>$err_log</td>
		</tr>
		
		<tr><td>&nbsp;</td>
		
		</table>
		</center>
	    }]
	    
	    puts $file_esi_id $pagina_esi
	    
	    
	    
	    if {[string equal $nome_tabella ""]} {	    
		close $file_table_id
		close $file_inp_id
	    }
	}

	# inserisco i link ai file di esito sulla tabella degli esiti
	# ed aggiorno lo stato del batch a 'Terminato' coimcorr-anom-gest.tcl
	set     esit_list ""
	if {[string equal $err_log ""]} {

	    db_1row sel_count_anom "select count(*) as conta_anom from $nome_tabella where flag_stato = 'P'"
	    if {$conta_anom > 0} {
		close $file_esi_id
		close $file_err_id
		close $file_tot_id
		
		ns_unlink $file_esi
		ns_unlink $file_err
		ns_unlink $file_tot
		
		set file_esi_url   "${permanenti_dir_url}/coimcorr-anom-gest?nome_tabella=$nome_tabella&cod_batc=$cod_batc&nome_funz=cari-rcee-tipo-2"
		set file_esi       "${permanenti_dir}/coimcorr-anom-gest"
		
		set file_esi_url [string map {permanenti src}  $file_esi_url]
		set file_esi     [string map {permanenti src}  $file_esi]
		ns_log notice "Gacalin -conta_anom=$conta_anom - nome_tabella_anom=$nome_tabella_anom"
		lappend esit_list [list "Esito provvisorio"  $file_esi_url $file_esi]
		iter_batch_upd_flg_sta -fine $cod_batc $esit_list

	    } else {

		# Scrivo la procedura che controllera' l'esistenza o meno nel db dei cittadini
		# e ne curera' l'eventuale inserimento
		set citt_control {
		    if {[string equal $nome_citt_chk ""]} {
			set where_nome_chk " and nome is null"
		    } else {
			set where_nome_chk " and upper(nome) = upper(:nome_citt_chk)"
		    }
		    if {[string equal $indirizzo_citt_chk ""]} {
			set where_indirizzo_chk " and indirizzo is null"
		    } else {
			set where_indirizzo_chk " and upper(indirizzo) = upper(:indirizzo_citt_chk)"
		    }
		    if {[string equal $comune_citt_chk ""]} {
			set where_comune_chk " and comune is null"
		    } else {
			set where_comune_chk " and upper(comune) = upper(:comune_citt_chk)"
		    }
		    if {[db_0or1row sel_citt_check "select cod_cittadino as cod_citt
    	                                              from coimcitt
	                                             where upper(cognome) = :cognome_citt_chk
                                                    $where_nome_chk
                                                    $where_indirizzo_chk
                                                    $where_comune_chk
                                                    limit 1"] == "0"} {
			db_1row sel_dual_cod_citt ""
			db_dml ins_citt ""
			incr count_citt

		    } else {
			set cod_citt [db_string sel_citt_check "select cod_cittadino as cod_citt
                                                               	  from coimcitt
                                                        	 where upper(cognome) = :cognome_citt_chk
                                                                $where_nome_chk
                                                                $where_indirizzo_chk
                                                                $where_comune_chk
                                                                limit 1" -default ""]
		    }
		}
		
		set count_aimp 0
		set count_dimp 0
		set count_citt 0
		
		set soldi_spesi "0.00"
		#inizio la routine degli inserimenti
		ns_log notice "iter-cari-rcee-tipo-2;inizio la routine degli inserimenti"

		db_foreach sel_righe_buone "select * from $nome_tabella where flag_stato is null" {
		    
		    
		    if {[string equal $data_rottamaz_gen ""]} {
			if {$coimtgen(regione) ne "MARCHE"} {
			    set cod_amministratore ""
			    
			    set nome_citt_chk $nome_resp
			    set cognome_citt_chk $cognome_resp
			    set indirizzo_citt_chk $indirizzo_resp
			    set comune_citt_chk $comune_resp
			    set natura_citt_chk $natura_giuridica_resp
			    set cap_chk $cap_resp
			    set cod_fiscale_chk $cod_fiscale_resp
			    set telefono_chk $telefono_resp
			    if {![string equal $cognome_citt_chk ""]} {
				eval $citt_control
				set cod_responsabile $cod_citt
			    } else {
				set cod_responsabile ""
			    }
			    # Proprietario
			    set nome_citt_chk $nome_prop
			    set cognome_citt_chk $cognome_prop
			    set indirizzo_citt_chk $indirizzo_prop
			    set comune_citt_chk $comune_prop
			    set natura_citt_chk $natura_giuridica_prop
			    set cap_chk $cap_prop
			    set cod_fiscale_chk $cod_fiscale_prop
			    set telefono_chk $telefono_prop
			    if {![string equal $cognome_citt_chk ""]} {
				eval $citt_control
				set cod_proprietario $cod_citt
			    } else {
				set cod_proprietario ""
			    }
			    # Occupante
			    set nome_citt_chk $nome_occu
			    set cognome_citt_chk $cognome_occu
			    set indirizzo_citt_chk $indirizzo_occu
			    set comune_citt_chk $comune_occu
			    set natura_citt_chk $natura_giuridica_occu
			    set cap_chk $cap_occu
			    set cod_fiscale_chk $cod_fiscale_occu
			    set telefono_chk $telefono_occu
			    if {![string equal $cognome_citt_chk ""]} {
				eval $citt_control
				set cod_occupante $cod_citt
			    } else {
				set cod_occupante ""
			    }
			    # Intestatario
			    set nome_citt_chk $nome_int
			    set cognome_citt_chk $cognome_int
			    set indirizzo_citt_chk $indirizzo_int
			    set comune_citt_chk $comune_int
			    set natura_citt_chk $natura_giuridica_int
			    set cap_chk $cap_int
			    set cod_fiscale_chk $cod_fiscale_int
			    set telefono_chk $telefono_int
			    if {![string equal $cognome_citt_chk ""]} {
				eval $citt_control
				set cod_intestatario $cod_citt
			    } else {
				set cod_intestatario ""
			    }
			    
			    switch $flag_responsabile {
				"A" { set cod_amministratore $cod_responsabile }
				"T" {  }
				"I" {
				    if {[string equal $cod_intestatario ""]} {
					set cod_intestatario $cod_responsabile
				    } else {
					set cod_responsabile $cod_intestatario
				    }
				}
				"O" {
				    if {[string equal $cod_occupante ""]} {
					set cod_occupante $cod_responsabile
				    } else {
					set cod_responsabile $cod_occupante
				    }
				}
				"P" {
				    if {[string equal $cod_proprietario ""]} {
					set cod_proprietario $cod_responsabile
				    } else {
					set cod_responsabile $cod_proprietario
				    }
				}
			    }
			}
			
			
			set cod_comune_chk $comuni($comune)
			set cod_comune $comuni($comune)
			set cod_comb "88"
			set cod_cost_chk $costruttori($marca)
			set cod_cost $costruttori($marca)
			set combustibile     $cod_comb;#Posso farlo perchè da questo punto in poi non è più usata la variabile combustibile
			set sw_data_controllo_ok   "t";#Già controllata prima, se si arriva in questo punto, è sicuramente ok.
			set sw_pot_focolare_nom_ok "t";#Già controllata prima, se si arriva in questo punto, è sicuramente ok.
			set form_name              "";#Non serve perchè non capita mail il caso di data_scadenza_autocert già valorizzata
			
			
			
			set colonna_errore "cod_impianto_est"
			set msg_errore ""
			set err_count 0
			
			
			######################
			if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#sim08 Aggiunta if ed il suo contenuto
			    #rom02set potenza_impianto "potenza_utile_nom"
			    set potenza_impianto potenza_utile;#rom02
			} else {
			    #rom02set potenza_impianto "potenza_foc_nom"
			    set potenza_impianto potenza;#rom02
			}

			
			ns_log notice "simone inizio parte rifatta con gacalin"
			db_1row q "select cod_potenza as cod_potenza_tari
                               --rom02  , :potenza_impianto as potenza_impianto
                                        , greatest(potenza, potenza_utile) as potenza_impianto  --rom02
                                        , cod_responsabile --lo rileggo dall'impianto perche' ho gia' verificato sopra che e' identico a quello inserito nel file  
                                     from coimaimp
                                    where cod_impianto=:cod_impianto_catasto limit 1"

			set data_installaz_gend [db_string q "select data_installaz 
                                                                from coimgend 
                                                               where cod_impianto =:cod_impianto_catasto
                                                                 and gen_prog     = :gen_prog_catasto" -default ""]

			set data_insta       [string range $data_installaz_gend 0 3][string range $data_installaz_gend 5 6][string range $data_installaz_gend 8 9]

			# Inizio istruzioni che devono essere identiche a quelli di coimdimp-rct-gest con la differenza di dover incrementare err_count e valorizzare msg_errore indicando anche la colonna col problema e di non effettuare controlli perchè la data_scadenza_autocert non potrà mai arrivare dal file (dava problemi perchè veniva valorizzata colo primo record e poi veniva controllata).
			set data_scadenza_autocert "";#altrimenti può rimanere sporca dal record precedente

			if {$coimtgen(regione) in [list "MARCHE" "CALABRIA" "TOSCANA"]} {#sim02: Aggiunta if e suo contenuto	   
			    
			    if {$potenza_impianto < 100.00 } {
				if {[string equal $data_scadenza_autocert ""]} {
				    if {$sw_data_controllo_ok == "t"} {
					set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
				    }
				} else {
				    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
				    if {$data_scadenza_autocert == 0} {
					element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
					incr error_num
				    }
				}
			    }
			    
			    if {$potenza_impianto >= 100.00} {
				if {[string equal $data_scadenza_autocert ""]} {
				    if {$sw_data_controllo_ok == "t"} {
					set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
				    }
				} else {
				    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
				    if {$data_scadenza_autocert == 0} {
					element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
					incr error_num
				    }
				}
			    }
			    
			    if {$coimtgen(regione) eq "MARCHE"} {
				#gac05 La regione Marche tiene come data scadenza sempre la data di fine mese
				set data_scadenza_autocert [db_string q "select (date_trunc('month', :data_scadenza_autocert::date) + interval '1 month' - interval '1 day')::date as end_of_month"]
			    }
			} elseif {$coimtgen(ente) eq "PMS"} {#sim12 Massa
			    if {$sw_data_controllo_ok eq "t" && $flag_errore_data_controllo eq "f"} {
				set data_insta_controllo [db_string q "select coalesce(:data_insta::date,'1900-01-01')"]
				set oggi         [iter_set_sysdate]
				set dt_controllo [clock format [clock scan "$oggi - 8 years"] -format "%Y%m%d"]
				
				if {$data_insta_controllo < $dt_controllo} {
				    set flag_impianto_vecchio 1
				} else {
				    set flag_impianto_vecchio 0
				}
				
				if {$potenza_impianto < 100.00 && $flag_impianto_vecchio==0 && $locale eq "E"} {;#4 anni
				    set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '4 year'" -default ""]
				} else {;#2 anno
				    set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]
				}
			    }
			    
			} else {;#sim02
			    #caso standard
			    if {[string equal $data_scadenza_autocert ""]} {
				if {$sw_data_controllo_ok == "t"} {
				    #27/06/2014 D'accordo con Sandro, usiamo il parametro gia' esistente
				    #coimtgen(valid_mod_h): Validità allegati (mesi)
				    #27/06/2014 set data_scadenza_autocert [db_string query "select :data_controllo::date + 775" -default ""]
				    db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                            ,$coimtgen(valid_mod_h))
                                                 ,'YYYYMMDD') as data_scadenza_autocert
                                     from dual";#27/06/2014
				}
			    } else {
				set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
				if {$data_scadenza_autocert == 0} {
				    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
				    incr error_num
				}
			    }
	    
			};#sim02
			# Fine istruzioni che devono essere identiche a quelli di coimdimp-rct-gest
			ns_log notice "Gacalin - fine parte rifatta con gacalin"
			
			if {$flag_portafoglio == "T"
			    && $data_controllo >= "20080801" } {

			    set data_insta_check $data_insta

			    
			    if {$data_controllo >= $data_insta_check} {

				if {(![string equal $cod_impianto_catasto ""]) && ([db_0or1row sel_dimp_check_data_controllo ""] == 1)} {
				    set tariffa_reg "7"
				    set importo_contr "0.00"
				    db_1row sel_dual_cod_dimp ""
				} else {
				    set tariffa_reg "7"
				    db_1row sel_tari_contributo ""
				    set oggi [db_string sel_date "select current_date"]
				    set url "balance?iter_code=$cod_manutentore"
				    set data [iter_httpget_wallet $url]
				    array set result $data
				    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
				    set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
				    set saldo [string range $parte_2 0 [expr [string first " " $parte_2] - 1]]
				    set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
				    
				    #sim06 $saldo < importo_contr
				    if {$saldo < $costo} {;#sim06	
					incr err_count
					append msg_errore "Saldo manutentore ($saldo) non sufficiente" 
				    } else {
					db_1row sel_dual_cod_dimp ""
					set database [db_get_database]
					set reference "$cod_dimp+$database"
					
					set url "lotto/itermove?iter_code=$cod_manutentore&body_id=1&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$costo";#sim06

					set importo_tariffa 0;#sim16
					db_0or1row q "select a.importo as importo_tariffa
                                                            from coimtari a
                                                           where a.cod_potenza = :cod_potenza_tari
                                                             and a.tipo_costo  = '7'
                                                             and a.cod_listino = '0' limit 1";#sim16

					if {$importo_tariffa > 0} {#sim16 if e suo conenuto
					    
					    set url_reg "lotto/itermove?iter_code=$cod_manutentore&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa"
					    
					    set data [iter_httpget_wallet $url_reg]
					    array set result $data
					    
					    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
					    if {$risultato == "OK"} {
						
					    }  else {
						incr err_count
						append msg_errore "Transazione non avvenuta correttamente ($result(page))"
					    }
					}

					set data [iter_httpget_wallet $url]
					array set result $data
					set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
					if {$risultato == "OK"} {
					    
					} else {
					    incr err_count
					    append msg_errore "Transazione non avvenuta correttamente ($result(page))" 
					}
				    }
				}
				
			    } else {
				db_1row sel_dual_cod_dimp ""
				set tariffa_reg "8"	
				set importo_contr "0.00"
			    }
			} else {
			    db_1row sel_dual_cod_dimp ""
			    set importo_contr ""
			    set tariffa_reg ""
			}
			
			set cod_cost	$cod_cost_chk

			if {$err_count == 0} {
			    if {![string equal $cod_impianto_catasto ""]} {
				
				set cod_impianto 	$cod_impianto_catasto
				if {[string equal $gen_prog_catasto ""]} {
				    set cod_cost		$cod_cost_chk
#gac01				    if {[db_0or1row sel_gen_prog "select '1' from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_prog"]} {
#gac01					db_dml upd_gend ""
#gac01				    } else {
#gac01					db_dml ins_gend ""
#gac01				    }
				} else {
				    set gen_prog $gen_prog_catasto
				}
				ns_log notice "simone 2"			

				#faccio switch flag_pagato perche il tracciato record accetta SI, NO e RI mentre a db devo inserire S,N,C
				switch $flag_pagato {
				    "SI" {
					set flag_pagato S
				    }
				    "NO" {
					set flag_pagato N
				    }
				    "RI" {
					set flag_pagato C
				    }
				}
				db_dml ins_dimp ""
				incr count_dimp

				if {$flag_portafoglio == "T" && ![string equal $importo_contr ""]} {
				    set soldi_spesi [expr $soldi_spesi + $importo_contr]
				}

			    }
			} else {
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :colonna_errore , :msg_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
			}
			###################

			
			
		    } else {
			if {![string equal $cod_impianto_catasto ""]
			    && ![string equal $gen_prog_catasto ""]} {
#			    db_dml upd_gen_rott ""
			} else {
			    set msg_errore "Il generatore &egrave; da rottamare ma non &egrave; stato trovato nel database."
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :msg_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
			}
		    }
		}

		set count_scartati 0
		ns_log notice "simone tabella_scarti=$nome_tabella nome_tabella_anom=$nome_tabella_anom"
		db_foreach sel_scarti "select * from $nome_tabella where flag_stato = 'S'" {
		    
		    set i 0
		    set riga ""
		    while {$i < $count_fields} {
			util_unlist $file_fields($i) nome_colonna denominazione type dimensione obbligatorio default_value range_value		    
			set colonna [set $nome_colonna]
			if {$i != "0"} {
			    append riga "|"
			}
			
			append riga $colonna
			incr i
		    }
		    
		    append riga " --di seguito riportati alcuni errori -> "
		    
		    db_foreach sel_anom "select * from $nome_tabella_anom where id_riga = :id_riga limit 5" {
			append riga "$nome_colonna: $desc_errore , "
		    }
		    
		    puts $file_err_id $riga
		    
		    incr count_scartati
		}
		
		set count_totale 0
		db_foreach sel_file "select * from $nome_tabella" {
		    
		    set i 0
		    set riga ""
		    while {$i < $count_fields} {
			util_unlist $file_fields($i) nome_colonna denominazione type dimensione obbligatorio default_value range_value		    
			set colonna [set $nome_colonna]
			if {$i != "0"} {
			    append riga "|"
			}
			
			append riga $colonna
			incr i
		    }
		    
		    puts $file_tot_id $riga
		    
		    incr count_totale
		}

		db_dml del_tabella "drop table $nome_tabella"
		db_dml del_tabella_anom "drop table $nome_tabella_anom"
		db_dml del_seq "drop sequence $nome_sequence"
		db_dml del_tabella_anom "delete from coimcari_manu where cod_manutentore = :cod_manutentore"

		# scrivo la pagina di esito
		set page_title "Esito caricamento RCEE di tipo 2 per manutentori"
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
		    
		    <tr><td valign=top class=form_title>Modelli letti:</td>
		    <td valign=top class=form_title>$count_totale</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		    
		    <tr><td valign=top class=form_title>Modelli scartati:</td>
		    <td valign=top class=form_title>$count_scartati</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		    
		    <tr><td colspan=4>&nbsp;</td>
		    
		    <!--		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Soggetti:</td>
		    <td valign=top class=form_title>$count_citt</td>
		    <td>&nbsp;</td>
		    </tr>
		    
		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Impianti:</td>
		    <td valign=top class=form_title>$count_aimp</td>
		    <td>&nbsp;</td>
		    </tr>-->
		    
		    
		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Modelli inseriti:</td>
		    <td valign=top class=form_title>$count_dimp</td>
		    <td>&nbsp;</td>
		    </tr>

		    <!--		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Sono stati spesi euro:</td>
		    <td valign=top class=form_title>$soldi_spesi</td>
		    <td>&nbsp;</td>
		    </tr>
		    <tr><td colspan=4>&nbsp;</td>-->
		    
		    
		    <tr><td valign=top class=form_title>Modelli scartati:</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td valign=top class=form_title><a target="Modelli scartati" href="$file_err_url">Scarica il file csv dei controlli/impianti scartati</a></td>
		    </tr>
		    
		    
		    <tr><td valign=top class=form_title>Modelli totali:</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td valign=top class=form_title><a target="Modelli scartati" href="$file_tot_url">Scarica il file csv dei controlli/impianti completo</a></td>
		    </tr>
		    
		}]
		
		puts $file_esi_id $pagina_esi
		
		close $file_esi_id
		close $file_err_id
		close $file_tot_id
		
		lappend esit_list [list "Esito caricamento"  $file_esi_url $file_esi]
		iter_batch_upd_flg_sta -fine $cod_batc $esit_list
	
	    }

	} else {

	    close $file_esi_id
	    close $file_err_id
	    close $file_tot_id
	    
	    ns_unlink $file_err
	    ns_unlink $file_tot
	    
	    lappend esit_list [list "Esito caricamento"  $file_esi_url $file_esi]
	    iter_batch_upd_flg_sta -fine $cod_batc $esit_list
	}
	
    } {
	iter_batch_upd_flg_sta -abend $cod_batc
	ns_log Error "iter_cari_rcee_tipo_2: $error_msg"
    }

    ns_log Notice "Fine della proc iter_cari_rcee_tipo_2"
    return
}
