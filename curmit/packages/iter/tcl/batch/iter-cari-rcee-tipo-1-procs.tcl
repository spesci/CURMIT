ad_proc iter_cari_rcee_tipo_1 {
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
    ric02 08/05/2024 Settato l'importo_tariffa a 0 prima della chiamata al wallet per evitare che il programma andasse in errore.
    ric02            Aggiunto controllo per impedire l'inserimento di un RCEE per lo stesso generatore.

    ric01 29/04/2024 Modificata elseif per regione FRIULI. Corrette le scadenze in base al 
    ric01            combustibile come riportate in coimdimp-rct-gest (sim61).

    sim18 19/06/2023 La tipologia di pagamento che veniva salvata era errata. Ora vado a indicare
    sim18            come tipologia LM (Bollino virtuale).

    rom15 14/04/2023 Sandro ha detto, su richiesta di Ucit, di aggiungere un controllo sui campi del generatore obbligatori.
    rom15            Se mancano quei dati dati allora l'rcee va scartato.

    rom14 06/04/2023 Modificata condizione sulla tariffa del secondo generatore per Ucit:
    rom14            Prima c'erano le condizioni sui vari enti, ora c'e' un'unica condizione su Regione Friuli.

    rom13 31/03/2023 Regione Friuli deve avere 25 Euro come tariffa per gli rcee sui secondi generatori e non 24.

    rom12 26/01/2023 Nella composizione dell'url per la coimesit metto anche il nome_funz come viene gia' fatto
    rom12            per iter-cari-rce-tipo-1-procs.tcl, se non passo il nome_funz ho il problema sui permessi.

    rom11 16/12/2022 Su segnalazione di Ucit corretta anomalia riguardo ai giorni massimi consentiti
    rom11            per inserire un rcee.

    rom10 10/11/2022 Corretto errore su update della targa per UCIT, nei caricamenti con piu'
    rom10            di una riga su impianti con targhe diverse queste venivano sovrascritte
    rom10            perche' Ucit ha tenuto il vecchio tracciato di caricamento senza targa.

    rom09 22/09/2022 Gestito il caso di impianto senza targa per Ucit, se l'impianto non ha
    rom09            la targa associata non si puo' caricare l'rcee e la riga viene scartata.

    rom04 08/06/2022 Per un caso capitato su Ucit con Sandro si e' deciso do aggiungere un
    rom04            controllo che impedisca di caricare, per lo stesso file 2 righe con lo
    rom04            stesso impianto, stessa data e per lo stesso generatore.

    rom03 20/05/2021 Corretto errore sul controllo del costo sul secondo generatore:
    rom03            va fatto solo se non ho errori.

    rom02 09/03/2020 Inserisco il pagamento sulla coimmovi come avviene per la coimdimp-rct-gest.tcl
    rom02            Sandro ha detto che il caricamento puo' avvenire solo per gli impianti
    rom02            in stato Attivo.

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
    
    ns_log Notice "Inizio sim della proc iter_cari_rcee_tipo_1. id_utente = $id_utente, file_name = $file_name, nome_tabella = $nome_tabella,"

    # Al momento il campo non esiste nel csv ma per non scoinvolgere il programma si è deciso con Sandro di settarla a "" all'inizio in modo che non faccia nulla e mantenere il codice.
    set data_rottamaz_gen   ""
    set rct_install_esterna ""

    set data_scadenza_autocert "";#Vedi commento più avanti (questo set serve per tenere le stesse istruzioni di coimdimp-rct-gest più avanti)

    with_catch error_msg {
	
	if {![string equal $nome_tabella ""]} {
	    set nome_tabella_anom [string map {RCEE1CARI ANOM} $nome_tabella]
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
	    set file_inp_name  "Caricamento-rcee-tipo-1-input"
	    set file_inp_name  [iter_temp_file_name -permanenti $file_inp_name]
	    
	    set file_table_name  "create-table"
	    set file_table_name  [iter_temp_file_name -permanenti $file_table_name]
	}
	
	set file_esi_name  "Caricamento-rcee-tipo-1-esito"
	set file_esi_name  [iter_temp_file_name -permanenti $file_esi_name]
	
	set file_err_name  "Caricamento-rcee-tipo-1-scartati"
	set file_err_name  [iter_temp_file_name -permanenti $file_err_name]
	
	set file_tot_name  "Caricamento-rcee-tipo-1-file"
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
	set csv_name "rcee1"
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
		set nome_tabella "RCEE1CARI_"
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
		exec psql $database -f ${permanenti_dir}/$file_table_name.sql 
		
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
	# Setto una sola volta l'array delle province
	db_foreach sel_prov "select cod_provincia as cod_prov, sigla as sigla_prov from coimprov" {
	    set province($sigla_prov) $cod_prov
	}
	# Setto una sola volta l'array dei combustibili
	db_foreach sel_comb "select cod_combustibile, descr_comb from coimcomb" {
	    set combustibili($descr_comb) $cod_combustibile
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

		    #spesci: nel csv non è presente il campo num_bollo quindi questa parte non serve
		    ## dobadd salvo il num_bollo e lo metto in riferimento_pag se questo e' nullo
                    #if {$col_name == "num_bollo"} {
		    #    set salva_num_bollo $colonna
		    #}
		    #if {$col_name == "riferimento_pag"} {
		#	if {$colonna == ""} {
		#	    set colonna $salva_num_bollo 
                #            set riferimento_pag $colonna  
		#	}
		#    }
		    # dobadd

		    if {[string equal $colonna ""]} {
			if {[string equal $obbligatorio "S"]} {
			    if {(![string equal $data_rottamaz_gen ""]
				&& ($col_name == "matricola"
				    || $col_name == "modello"
				    || $col_name == "combustibile"
				    || $col_name == "cod_manutentore"
				    || $col_name == "cod_fiscale_resp"
				    || $col_name == "potenza_utile_nom"
				    || $col_name == "potenza_foc_nom"
				    || $col_name == "toponimo"
				    || $col_name == "indirizzo"
				    || $col_name == "comune"
				    || $col_name == "provincia"
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
				 || $col_name == "combustibile"
				 || $col_name == "cod_manutentore"
				 || $col_name == "cod_fiscale_resp"
				 || $col_name == "potenza_utile_nom"
				 || $col_name == "potenza_foc_nom"
				 || $col_name == "toponimo"
				 || $col_name == "indirizzo"
				 || $col_name == "comune"
				 || $col_name == "provincia"
				 || $col_name == "marca"
				 || $col_name == "flag_responsabile"))
			    || [string equal $data_rottamaz_gen ""]} {							
			    switch $type {
				date {
				    set colonna [string map {- ""}  $colonna]
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
		# dobadd aggiorno la tabella nome_tabella in modo che mantenga riferimento_pag eventualmente preso da num_bollo
		db_dml upd_riga "update $nome_tabella set riferimento_pag = :riferimento_pag where id_riga = :id_riga"
		# dobadd
		

		# Controllo sul combustibile: sim17 spostato qui perchè serve per il calcolo della tariffa vecchia
		
		set cod_comb_chk "0"
		if {![info exist combustibili($combustibile)]} {
		    set desc_errore "Combustibile inesistente"
		    incr errori
		    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'combustibile' , :desc_errore )"
		} else {
		    set cod_comb_chk $combustibili($combustibile)
		}
		

		if {$errori > 0} {
		    if {$errori > $num_anom_max} {
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

		    #superati controlli integrita eseguo controlli esistenza: comune provincia responsabile
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
		    
		    # Controllo sulla provincia dell'impianto
		    set cod_prov_chk ""
		    set sigla_prov $coimtgen(sigla_prov)
		    set denom_prov [db_string sel_provincia "select denominazione as denom_prov from coimprov where sigla = :sigla_prov"]
		    set cod_prov_chk ""
		    if {$sigla_prov == $provincia
			|| $denom_prov == $provincia} {
			set provincia $sigla_prov
			set cod_prov_chk $province($provincia)
		    } else {
			set desc_errore "Provincia non di competenza dell'ente"
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'provincia' , :desc_errore )"
		    }
	 	    
		    # Controllo sul responsabile
		    switch $flag_responsabile {
			"A" { 
			    if {[string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (amministratore) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
#			    } else {
#				if {[string equal $nome_resp ""]} {
#				    set where_nome_chk " and nome is null"
#				} else {
#				    set where_nome_chk " and upper(nome) = :nome_resp"
#				}
#				if {[string equal $indirizzo_resp ""]} {
#				    set where_indirizzo_chk " and indirizzo is null"
#				} else {
#				    set where_indirizzo_chk " and upper(indirizzo) = :indirizzo_resp"
#				}
#				if {[string equal $comune_resp ""]} {
#				    set where_comune_chk " and comune is null"
#				} else {
#				    set where_comune_chk " and upper(comune) = :comune_resp"
#				}
#				if {[string equal $provincia_resp ""]} {
#				    set where_provincia_chk " and provincia is null"
#				} else {
#				    set where_provincia_chk " and upper(provincia) = :provincia_resp"
#				}
#
#
#				if {[db_0or1row sel_citt_check "select cod_cittadino as cod_citt from coimcitt
#		                                                         where upper(cognome) = :cognome_resp
#	                                                                $where_nome_chk
#	                                                                $where_indirizzo_chk
#	                                                                $where_comune_chk
#	                                                                $where_provincia_chk limit 1"] == "0"} {
#				    set desc_errore "Il responsabile (amministratore) non &egrave; presente nell'anagrafica ricontrolla i dati relativi"
#				    incr errori
#				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
#				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'nome_resp' , :desc_errore )"
#				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo_resp' , :desc_errore )"
#				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune_resp' , :desc_errore )"
#				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'provincia_resp' , :desc_errore )"
#				}
			    }
			}
			"I" {
			    if {[string equal $cognome_inte ""]
				&& [string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (intestatario) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_inte' , :desc_errore )"
			    }
			}
			"O" {
			    if {[string equal $cognome_occu ""]
				&& [string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (occupante) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_occu' , :desc_errore )"
			    }
			}
			"P" {
			    if {[string equal $cognome_prop ""]
				&& [string equal $cognome_resp ""]} {
				set desc_errore "Il responsabile (proprietario) non &egrave; valorizzato"
				incr errori
				db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_prop' , :desc_errore )"
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
				if {[string equal $provincia_resp ""]} {
				    set where_provincia_chk " and provincia is null"
				} else {
				    set where_provincia_chk " and upper(provincia) = :provincia_resp"
				}

				if {[db_0or1row sel_citt_check "select cod_cittadino as cod_terzi from coimcitt
			                                                         where upper(cognome) = :cognome_resp
		                                                                $where_nome_chk
		                                                                $where_indirizzo_chk
		                                                                $where_comune_chk
		                                                                $where_provincia_chk limit 1"]} {
				    db_1row sel_terzi "select cod_legale_rapp from coimmanu where cod_manutentore = :cod_manutentore"
				    if {[string equal $cod_legale_rapp ""]
					|| $cod_legale_rapp != $cod_terzi} {
					set desc_errore "Il terzo responsabile non corrisponde a quello della ditta di manutenzione, ricontrolla i dati relativi"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'nome_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune_resp' , :desc_errore )"
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'provincia_resp' , :desc_errore )"
				    }
				} else {
				    set desc_errore "Il responsabile (terzi) non &egrave; presente nell'anagrafica, ricontrolla i dati relativi"
				    incr errori
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cognome_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'nome_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'indirizzo_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'comune_resp' , :desc_errore )"
				    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'provincia_resp' , :desc_errore )"
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
		    
		    # Controllo sul combustibile
		
                    #sim17 set cod_comb_chk "0"
		    #sim17 if {![info exist combustibili($combustibile)]} {
			#sim17 set desc_errore "Combustibile inesistente"
			#sim17 incr errori
			#sim17 db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'combustibile' , :desc_errore )"
		    #sim17} else {
			#sim17 set cod_comb_chk $combustibili($combustibile)
		    #sim17}
		
		    #di default se non uso la targa la setto vuota

		    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom09 Aggiunta if e il suo contenuto
			set flag_gest_targa "F"		       
		    }


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
				    if {   $cod_impianto eq $cod_impianto_caldo_targa 
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

					    if {$error_targa ==1 } {
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
					    set esponente_freddo        ""
					    set cod_impianto_est_caldo  ""
					    set cod_responsabile_caldo  ""
					    set cod_comune_caldo        ""
					    set cod_via_caldo           ""
					    set numero_caldo            ""
					    set esponente_caldo         ""
					    set numero $toponimo

					    #ricavo i dati dell'eventuale impianto del freddo associato
					    db_0or1row q "
                                  select cod_impianto_est as cod_impianto_est_freddo
                                       , cod_responsabile as cod_responsabile_freddo 
                                       , cod_comune       as cod_comune_freddo
                                       , cod_via          as cod_via_freddo
                                       , numero           as numero_freddo
                                       , esponente        as esponente_freddo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_freddo_targa"

					    #ricavo i dati dell'eventuale impianto del caldo associato
					    db_0or1row q "
                                  select cod_impianto_est as cod_impianto_est_caldo
                                       , cod_responsabile as cod_responsabile_caldo
                                       , cod_comune       as cod_comune_caldo
                                       , cod_via          as cod_via_caldo
                                       , numero           as numero_caldo
                                       , esponente        as esponente_caldo
                                    from coimaimp
                                   where cod_impianto = :cod_impianto_caldo_targa"

					    #ricavo i dati dell'impianto su cui sto salvando
					    #						db_0or1row q "
					    #                                  select cod_responsabile                            
					    #                                       , cod_comune      
					    #                                       , cod_via                            
					    #                                       , numero           
					    #                                       , esponente                           
					    #                                    from coimaimp
					    #                                   where cod_impianto = :cod_impianto"
					
					    #se lavoro su un impianto del freddo
					    if {$flag_tipo_impianto eq "F" && $cod_impianto_freddo_targa ne ""} {
						#ha già un impianto del freddo associato
						set inserire_targa "f"
						set desc_errore "Targa già associata all'impianto $cod_impianto_est_freddo"
						incr errori
						incr error_targa
						if {$error_targa ==1 } {
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
						     || $numero_caldo         != $numero
						     || $esponente_caldo      != $esponente)} {

						    set inserire_targa "f"
						    set desc_errore "Targa già associata all'impianto $cod_impianto_est_caldo"
						    incr errori
						    incr error_targa
						    if {$error_targa ==1 } {
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
						if {$error_targa ==1 } {
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
						     || $numero_freddo        != $numero
						     || $esponente_freddo     != $esponente)} {
						    
						    set inserire_targa "f"

						    set desc_errore "Targa già associata all'impianto $cod_impianto_est_freddo"
						    incr errori
						    incr error_targa
						    if {$error_targa ==1 } {
							
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
		    #sim09: FINE CONTROLLI TARGA 

		    # bollino
#		    ns_log notice "prova sandro 0  riferimento: $riferimento_pag "
		    
		    if {$riferimento_pag != ""} {
			
			
			db_1row sel_dimp_check_riferimento_pag "
                                select count(*) as count_riferimento_pag
                                  from coimdimp
                                 where riferimento_pag = :riferimento_pag
                                   "
#			ns_log notice "prova sandro 1  riferimento: $riferimento_pag  il conta :$count_riferimento_pag"
			
			if {$count_riferimento_pag > 0} {
			    set desc_errore "Riferimento bollino già utilizzato"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'riferimento_pag', :desc_errore )"
			}
			
			
			set flag_boll_compreso "f"
			set flag_boll_pagato "t";#sim04
			db_foreach sel_boll_manu "
                        select matricola_da
                             , matricola_a 
                             , cod_tpbo
                             , pagati --sim04
                          from coimboll 
                         where cod_manutentore = :cod_manutentore
                        " {
			    if {$matricola_da <= $riferimento_pag
			    &&  $matricola_a  >= $riferimento_pag
			    } {
				set flag_boll_compreso "t"
			       
				if {$pagati eq "N"} {#sim04 Aggiunta if e suo contenuto
				    set flag_boll_pagato "f"
				}
			    }
			}
			
			if {$flag_boll_compreso == "f"} {
			    set desc_errore "Riferimento bollino errato, Non venduto alla ditta di Manutenzione"
			    incr errori
			    
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'riferimento_pag' , :desc_errore )"
			    
			}

			if {$coimtgen(ente) eq "PLI" && $flag_boll_pagato eq "f"} {#sim04 Aggiunta if e suo contenuto
			    set desc_errore "Bollino non pagato"
			    incr errori
			    db_dml ins_anom "
                            insert
                              into $nome_tabella_anom 
                            values (:id_riga 
                                   ,:cod_manutentore
                                   ,'riferimento_pag' 
                                   ,:desc_errore
                                   )"
			}
		    }
		    # fine bollini



		    #controllo sulla potenza		    
		    if {$potenza_foc_nom == "0"} {
			set desc_errore "La potenza deve essere superiore a 0 kW"
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'potenza_foc_nom' , :desc_errore )"
		    } else {
			if {[db_0or1row sel_pot "select '1' from coimpote where potenza_min <= :potenza_foc_nom and potenza_max >= :potenza_foc_nom limit 1"] == 0} {
			    set desc_errore "La potenza non &egrave; compresa in nessuna fascia."
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'potenza_foc_nom' , :desc_errore )"
			}
		    }

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
			    if {[db_0or1row sel_impianto "select cod_impianto from coimaimp where cod_comune = :cod_comune_chk and cod_provincia = :cod_prov_chk and cod_impianto_est = :cod_impianto_est"]} {
				
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
					set desc_errore "Impianto non trovato per comune e provincia. Il codice impianto non &egrave; stato assegnato correttamente"
					incr errori
					db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :desc_errore )"
					db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
			    }
			} else {
			    #rinisci query
			    db_1row sel_n_impianti "select count(*) as conta_impianti_trovati from coimaimp a
                                                                               , coimgend b
                                                                         where a.cod_impianto = b.cod_impianto
                                                                           and a.cod_provincia = :cod_prov_chk
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
                                                                           and a.cod_provincia = :cod_prov_chk
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
		}

		if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $errori == 0} {#rom09 Aggiunta if e il suo contenuto
		    if {![db_0or1row q "select targa
                                              from coimaimp
                                             where cod_impianto = :cod_impianto
                                               and coalesce(targa, '') != ''"]} {
			set msg_errore "Manca la targa sull'impianto"
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :msg_errore )"
			db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
			
		    }
		}

		#rom02 Ricavo lo stato dell'impianto e, se non e' attivo, inserisci l'anomalia
		if {$errori == 0 && ![db_0or1row q "
                                      select 1 
                                        from coimaimp 
                                       where cod_impianto = :cod_impianto 
                                         and stato = 'A'"]} {#rom02 aggiunta if e suo contenuto
		    set desc_errore "Impossibile inserire Impianti non in stato Attivo"
                    incr errori
                    db_dml ins_anom "insert into $nome_tabella_anom
                                          values ( :id_riga
                                               , :cod_manutentore
                                               , 'costo'
                                               , :desc_errore )"
                    db_dml upd_riga "update $nome_tabella
                                        set numero_anomalie = :errori
                                          , flag_stato = 'S'
                                      where id_riga = :id_riga"

		}

		if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $errori == 0} {#rom15 Aggiunta if e il suo contenuto
		    if {![db_0or1row q "select 1
                                         from coimgend
                                        where cod_impianto = :cod_impianto
                                          and gen_prog     = :gen_prog
                                          and rend_ter_max  is not null"]} {
			set msg_errore "Inserire tutti i campi obbligatori del generatore."
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :msg_errore )"
			db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
			
		    }
		}

		#sim07 controllo sul costo inserito. lo faccio solo se non è già stato escluso dagli altri controlli
		ns_log notice "iter-cari-rcee-tipo-1:inizio controllo costo"
		
		# imposto il codice listino a 0 perche' per ora il listino destinato ai costi
		# e' il listino con codice 0 (zero) se in futuro ci sara' una diversificazione
		# sara' da creare una function o una procedura che renda dinamico il codice_listino
		set cod_listino 0

		set pot_focolare_nom_check [iter_edit_num $potenza_foc_nom 2];#sim09
		set pot_focolare_nom_check [iter_check_num $pot_focolare_nom_check 2];#sim09
		    
		if {![db_0or1row sel_cod_potenza ""]} {
		    set cod_potenza_tari ""
		}

		if {[db_0or1row sel_tari ""] == 0} {
		    set tariffa ""
		    set flag_tariffa_impianti_vecchi ""
		    set anni_fine_tariffa_base       ""
		    set tariffa_impianti_vecchi      ""
		}

		#il controllo sugli anni va fatto solo se l'aposito flag è true e solo per GAS e METANO
		if {$errori == 0 && $flag_tariffa_impianti_vecchi eq "t" && ($cod_comb_chk eq "4" || $cod_comb_chk eq "5")} {#sim07: aggiunta if e suo contenuto
		    #sim17 set data_insta_controllo [db_string q "select coalesce(data_insta,'1900-01-01')"]
		    set data_insta_controllo [db_string q "select coalesce(:data_installazione_aimp,'1900-01-01')"];#sim17

                    if {$data_controllo ne ""} {;#sim17
                        set oggi $data_controllo
                    } else {
                        set oggi [iter_set_sysdate]
                    }

		    set dt_controllo [clock format [clock scan "$oggi - $anni_fine_tariffa_base years"] -format "%Y%m%d"]
		    
		    if {$data_insta_controllo < $dt_controllo} {
			set tariffa $tariffa_impianti_vecchi
		    }
		}
		

###########inizio gestione costo secondo generatore
#		ns_log notice "simone cod_impianto=$cod_impianto data_controllo=$data_controllo gen_prog=$gen_prog" 
		#sim23 verifico se già esiste un rcee sull'impianto con la stessa data controllo ma su un generatore diverso.
		#rom03 Il controllo va fatto solo se non ho errori.
		if {$errori == 0 && [exists_and_not_null data_controllo] && [db_0or1row q "select 1
                         from coimdimp
                        where cod_impianto   = :cod_impianto
                          and data_controllo = :data_controllo
                          and gen_prog      != :gen_prog
                          and (costo        != 0   
                               or flag_status = 'N') --condizione per non sbiancare il costo in fase di modifica del rcee inserito per primo
                        limit 1"]} {;#sim23 if e else e loro contenuto
		    set rcee_su_secondo_gen "t"
		} else {
		    set rcee_su_secondo_gen "f"
		}		
		
		#verifico anche se esiste nello stesso caricamento un generatore differente sullo stesso impianto da caricare come primo rcee
		if {[exists_and_not_null data_controllo] && [db_0or1row q "select 1
                         from $nome_tabella
                        where cod_impianto_est   = :cod_impianto_est
                          and data_controllo = :data_controllo
                          and gen_prog      != :gen_prog
                          and iter_edit_num(costo::numeric,2) = :tariffa "]} {
		     set rcee_su_secondo_gen "t"
		}
	
		#rom14 Messa la condizione su tutta la Regione Friuli e non sui singoli enti
		if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"  && ($rcee_su_secondo_gen eq "t")} {#sim58
		    
		    #rom13set tariffa "24,00"
		    set tariffa "25,00";#rom13
		    		    
		}
#		ns_log notice "simone cod_impianto=$cod_impianto tariffa=$tariffa rcee_su_secondo_gen=$rcee_su_secondo_gen costo=$costo" 
###########fine gestione costo secondo generatore

		#rom04 Verifico se nello stesso caricamento esistono piu' righe riferite
		#rom04 allo stesso impianto per lo stessa data e per lo stesso generatore.
		if {[exists_and_not_null data_controllo] && 
		    [db_0or1row q "select count(*)
                                        , cod_impianto_est as cod_imp_doppio
                                     from $nome_tabella
                                    where cod_impianto_est   = :cod_impianto_est
                                      and data_controllo     = :data_controllo
                                      and gen_prog           = :gen_prog
                                    group by cod_impianto_est
                                   having count(*) > 1"]} {#rom04 Aggiunta if e il suo contenuto
		    
		    set desc_errore "Trovate più righe riferite allo stesso RCEE per l'impianto $cod_imp_doppio"
		    incr errori
		    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :desc_errore )"
		    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"
		}

		#sim07 Sandro ha detto di verificare sempre che il costo e la tariffa siano uguali
		#sim09 corretto controllo perche' i 2 capi erano formattati diversamente 
		set costo_controllo [iter_edit_num $costo 2]
		#sim12 aggiunto condizione su PFI
		if {$costo_controllo ne $tariffa && $coimtgen(ente) ne "PFI"} {#sim07: Aggiunta if e suo contenuto
		    
		    set desc_errore "Il costo indicato non corrisponde alla tariffa prevista ($tariffa euro)"
		    incr errori
		    db_dml ins_anom "insert into $nome_tabella_anom 
                                          values ( :id_riga 
                                               , :cod_manutentore
                                               , 'costo' 
                                               , :desc_errore )"
		    db_dml upd_riga "update $nome_tabella 
                                        set numero_anomalie = :errori 
                                          , flag_stato = 'S' 
                                      where id_riga = :id_riga"
		    
		}
		ns_log notice "iter-cari-rcee-tipo-1;fine controllo costo"
		
		ns_log notice "iter-cari-rcee-tipo-1;inizio controllo patentino"
			
		if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#sim08 Aggiunta if ed il suo contenuto
		    set potenza_impianto $potenza_utile_nom
		    set campo_controllo_patentino "potenza_utile_nom"
		} else {
		    set potenza_impianto $potenza_foc_nom
		    set campo_controllo_patentino "potenza_foc_nom"
		}

		if {![db_0or1row query "
                    select patentino 
                      from coimmanu 
                     where cod_manutentore = :cod_manutentore"]
		} {#sim08 if e suo contenuto
		    set patentino "f"
		}
		
		if {$potenza_impianto > 232 && $patentino eq "f"} {#sim08 if e suo contenuto
		    
		    set desc_errore "Manutentore non fornito di patentino. Impossibile inserire impianti con potenza maggiore di 232 Kw"
		    incr errori
		    db_dml ins_anom "insert into $nome_tabella_anom 
                                          values ( :id_riga 
                                               , :cod_manutentore
                                               , '$campo_controllo_patentino' 
                                               , :desc_errore )"
		    db_dml upd_riga "update $nome_tabella
                                        set numero_anomalie = :errori 
                                          , flag_stato = 'S'
                                      where id_riga = :id_riga"
		}

		ns_log notice "iter-cari-rcee-tipo-1;fine controllo patentino $errori $data_rottamaz_gen"
		

		set current_date [iter_set_sysdate];#rom11
		set num_gg_post_data_controllo_per_messaggio 45;#rom11
		
		if {$coimtgen(ente)    eq "PFI"
		    ||  $coimtgen(ente)    eq "PPO"
		    ||  [string match "*iterprfi_pu*" [db_get_database]]
		    ||  $coimtgen(ente)    eq "CRIMINI"
		    ||  $coimtgen(ente)    eq "CBARLETTA"
		    ||  $coimtgen(regione) eq "MARCHE"
		    ||  $coimtgen(ente) eq "PTA"
		    ||  $coimtgen(ente) eq "PRC"
		    ||  $coimtgen(ente) eq "CCARRARA"
		} {#rom11 Aggiunte if e contenuto
		    set oggi50 [clock format [clock scan "$data_controllo +2000 days"] -format "%Y%m%d"]
		    
		} elseif {$coimtgen(ente) eq "PBT" || ($coimtgen(regione) eq "CALABRIA" && $coimtgen(ente) ne "PRC")} {#rom100 Aggiunta elseif e contenuto
		    set oggi50 [clock format [clock scan "$data_controllo +60 days"] -format "%Y%m%d"]
		    set num_gg_post_data_controllo_per_messaggio 60		    
		} elseif {$coimtgen(ente) eq "PLI"} {#sim05 Aggiunta if e suo contenuto #rom11 trasformata if in elseif
		    #rom11set current_date [iter_set_sysdate]
		    if {$current_date < 20160331} {
			set num_gg_post_data_controllo_per_messaggio 90
		    } else {
			set num_gg_post_data_controllo_per_messaggio 40
		    }
		    set oggi50 [clock format [clock scan "$data_controllo + $num_gg_post_data_controllo_per_messaggio days"] -format "%Y%m%d"]
		    
		} else {#rom11 Aggiunta else e contenuto
		    set oggi50 [clock format [clock scan "$data_controllo +50   days"] -format "%Y%m%d"]
		}
		
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
		
		
		#controlli sulla dichiarazione
		if {$errori == 0
		    && [string equal $data_rottamaz_gen ""]} {
		    
		    if {![string equal $cod_impianto ""]} {
			
			if {[catch {set d_dummy [db_1row query "select to_date(:data_controllo,'YYYYMMDD') as dummy"]} var_errore_dummy]
			} { set desc_errore "Data controllo errata"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'data_controllo' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'S' where id_riga = :id_riga"

			} elseif {[db_0or1row sel_dimp "select cod_dimp from coimdimp where cod_impianto = :cod_impianto and data_controllo = :data_controllo and gen_prog != :gen_prog limit 1"]} {
			    set desc_errore "Dichiarazione gi&agrave; presente controlla la data"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'data_controllo' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			} elseif {[db_0or1row sel_dimp "select cod_dimp
                                                          from coimdimp
                                                         where cod_impianto   = :cod_impianto
                                                           and data_controllo = :data_controllo
                                                           and gen_prog       = :gen_prog
                                                         limit 1"]} {#ric02 aggiunta elseif e contenuto
			    set desc_errore "Dichiarazione gi&agrave; presente per il generatore $gen_prog controlla la data"
			    incr errori
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'data_controllo' , :desc_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
			}
		    }
		    
		    
		    #Controllo che le anomalie segnalate siano presenti nella tabella coimtano
		    # e quindi conformi agli standard della regione lombardia	    
		    set anomalie_impianto [split $anomalie_dimp \,]
		    set num_anom [llength $anomalie_impianto]
		    set err_anom ""
		    for {set i 0} {$i < $num_anom} {incr i} {
			set anomalia [lindex $anomalie_impianto $i]
			set anomalia [string trim $anomalia]
			if {![info exists anomalie($anomalia)]} {
			    if {![string equal $err_anom ""]} {
				append err_anom ","
			    }
			    append err_anom "codice anomalia $anomalia non valido "
			}
		    } 
		    if {![string equal $err_anom ""]} {
			set desc_errore $err_anom
			incr errori
			db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'anomalie_dimp' , :desc_errore )"
			db_dml upd_riga "update $nome_tabella set numero_anomalie = :errori , flag_stato = 'P' where id_riga = :id_riga"
		    }
		}
	    }
	    #chiude db_foreach sulla tabella
	    
	} else {
	    
	    set page_title "Esito caricamento RCEE di tipo 1 per manutentori"
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
		
		#rom12set file_esi_url   "${permanenti_dir_url}/coimcorr-anom-gest?nome_tabella=$nome_tabella&cod_batc=$cod_batc"
		set file_esi_url   "${permanenti_dir_url}/coimcorr-anom-gest?nome_tabella=$nome_tabella&cod_batc=$cod_batc&nome_funz=cari-rcee-tipo-1";#rom12
		set file_esi       "${permanenti_dir}/coimcorr-anom-gest"
		
		set file_esi_url [string map {permanenti src}  $file_esi_url]
		set file_esi     [string map {permanenti src}  $file_esi]
		
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
		    if {[string equal $provincia_citt_chk ""]} {
			set where_provincia_chk " and provincia is null"
		    } else {
			set where_provincia_chk " and upper(provincia) = upper(:provincia_citt_chk)"
		    }
		    if {[db_0or1row sel_citt_check "select cod_cittadino as cod_citt
    	                                              from coimcitt
	                                             where upper(cognome) = :cognome_citt_chk
                                                    $where_nome_chk
                                                    $where_indirizzo_chk
                                                    $where_comune_chk
                                                    $where_provincia_chk
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
                                                                $where_provincia_chk
                                                                limit 1"]
		    }
		}
		
		set count_aimp 0
		set count_dimp 0
		set count_citt 0

		set soldi_spesi "0.00"
		#inizio la routine degli inserimenti
		ns_log notice "iter-cari-rcee-tipo-1;inizio la routine degli inserimenti"

		db_foreach sel_righe_buone "select * from $nome_tabella where flag_stato is null" {

# dobdel: riferimento_pag viene impostato = a num_bollo in fase di caricamento della tabella nome_tabella  
#		    if {$riferimento_pag == ""} {
#			set riferimento_pag $num_bollo 
#		    }
# dobdel
		    
		    if {[string equal $data_rottamaz_gen ""]} {
			set cod_amministratore ""
			
			set nome_citt_chk $nome_resp
			set cognome_citt_chk $cognome_resp
			set indirizzo_citt_chk $indirizzo_resp
			set comune_citt_chk $comune_resp
			set provincia_citt_chk $provincia_resp
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
			set provincia_citt_chk $provincia_prop
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
			set provincia_citt_chk $provincia_occu
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
			set provincia_citt_chk $provincia_int
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


			set cod_comune_chk $comuni($comune)
			set cod_comune $comuni($comune)
			set cod_prov $province($provincia)
			set cod_comb $combustibili($combustibile)		    
			set cod_cost_chk $costruttori($marca)
			set cod_cost $costruttori($marca)
			set cod_potenza [db_string sel_pot "select cod_potenza from coimpote where potenza_min <= :potenza_foc_nom and potenza_max >= :potenza_foc_nom
and flag_tipo_impianto = 'R'"]
			
			# Sandro non ha messo volutamente il campo data_scadenza_autocert
			# nel tracciato record. La calcolo come fatto nel programma
			# coimdimp-rct-gest.
			# Queste istruzioni devono essere identiche tra i due sorgenti:
			# quando si modifica un sorgente, va modificato anche l'altro.

			# Questi set servono per non cambiare le istruzioni successive
			set pot_focolare_nom $potenza_foc_nom
			set combustibile     $cod_comb;#Posso farlo perchè da questo punto in poi non è più usata la variabile combustibile
			set data_insta       [string range $data_installaz_gend 0 3][string range $data_installaz_gend 5 6][string range $data_installaz_gend 8 9]
			set sw_data_controllo_ok   "t";#Già controllata prima, se si arriva in questo punto, è sicuramente ok.
			set sw_pot_focolare_nom_ok "t";#Già controllata prima, se si arriva in questo punto, è sicuramente ok.
			set form_name              "";#Non serve perchè non capita mail il caso di data_scadenza_autocert già valorizzata


			
			set colonna_errore "cod_impianto_est"
			set msg_errore ""
			set err_count 0
			

			# Inizio istruzioni che devono essere identiche a quelli di coimdimp-rct-gest con la differenza di dover incrementare err_count e valorizzare msg_errore indicando anche la colonna col problema e di non effettuare controlli perchè la data_scadenza_autocert non potrà mai arrivare dal file (dava problemi perchè veniva valorizzata colo primo record e poi veniva controllata).
			set data_scadenza_autocert "";#altrimenti può rimanere sporca dal record precedente
			
			set flag_ente        $coimtgen(flag_ente)
        # SF 271114 modificato Barletta e messa come udine
	if {$coimtgen(ente) eq "CRIMINI"}  {

	    #if {[string equal $data_scadenza_autocert ""]} {
		set data_8 "[expr [string range $data_controllo 0 3] - 4][string range $data_controllo 4 5][string range $data_controllo 6 7]"

		if {$flag_pagato eq "N"} {
		    set data_scadenza_autocert [string range $data_controllo 0 3]
		} elseif {$pot_focolare_nom >= 35 || $combustibile eq "1" || $combustibile eq "3"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 1]
		} elseif {$data_insta < $data_8} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 2]
		} elseif {$tipo_a_c eq "C"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 4]
		} elseif {$locale eq "I"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 2]
		} else {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 4]
		}
		set data_scadenza_autocert "$data_scadenza_autocert[string range $data_controllo 4 7]"

		if {[string range $data_scadenza_autocert 4 7] == "0229"} {
		    set data_scadenza_autocert [string range $data_scadenza_autocert 0 3]
		    append data_scadenza_autocert "0228"
		}
	    #}
	    } elseif {$coimtgen(regione) eq "TOSCANA"} {#sim28
		
		if {$sw_data_controllo_ok == "t"} {
		    set dt_controllo [clock format [clock scan "$data_controllo - 4 years"] -format "%Y%m%d"]
		    
                    set data_insta_controllo $data_insta

		    #sim34 se metano o gpl e ha meno di 4 anni
		    if {$combustibile eq "4" || $combustibile eq "5"} {#sim34
			
			if {$potenza_impianto <= 100} {#se potenza minore di 100
			    
			    #primo controllo ha scadenza 4 anni
			    if {$dt_controllo <= $data_insta_controllo} {			    		    
				set anno_scad [expr [string range $data_controllo 0 3] + 4]
			    } else {#dopo il primo sempre 2 anni
				set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    }
			    
			} else {#se potenza maggiore di 100
			    
			    #sempre 2 anni
			    set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    
			}
			
		    } else {#tutti quelli tranne metano e gpl
			
			if {$potenza_impianto <= 100} {#se potenza minore di 100
			    
			    #2 anni
			    set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    
			} else {#se potenza maggiore di 100
			    
			    #1 anno
			    set anno_scad [expr [string range $data_controllo 0 3] + 1]
			    
			}
		    }
		    
                    #la scadenza va sempre al 31/12 dell'anno
                    append anno_scad "1231"
                    set data_scadenza_autocert $anno_scad
		}
#		ns_log notice "simone scadenza toscana $data_scadenza_autocert"
	    
	} elseif {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU" || $coimtgen(ente) eq "CFANO"}  {#sim02

	    if {$potenza_impianto < 100.00 } {
		    
		#if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			    
			#se combustibile gpl o metano 4 anni
			if {$combustibile eq "4" || $combustibile eq "5"} {
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			} else {;#per gli altri 2
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			}
		    }
		#} else {
		    #set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    #if {$data_scadenza_autocert == 0} {
		    #    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
		    #    incr error_num
		    #}
		#}
		    
	    }

	    if {$potenza_impianto >= 100.00} {
		#if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			    
			#se combustibile gpl o metano 2 anni
			if {$combustibile eq "4" || $combustibile eq "5"} {
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			} else {;#per gli altri 1
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
			}
			
		    }
		#} else {
		    #set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    #if {$data_scadenza_autocert == 0} {
		    #    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
		    #    incr error_num
		    #}
		#}
	    }
	    #fine sim02
		
	} elseif { $coimtgen(ente) eq "CBARLETTA"} {
	    #ric01 tolto condizione $coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || aggiunta condizione su regione FRIULI sotto	    

	    if {$pot_focolare_nom < 35.00 } {
		#if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
		    }
		#} else {
		#    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		#    if {$data_scadenza_autocert == 0} {
		#	set colonna_errore "data_scadenza_autocert"
		#	set msg_errore "Inserire correttamente"
		#	incr err_count
		#   }
		#}
	    }
	    
	    if {$pot_focolare_nom >= 35.00 && $pot_focolare_nom < 100.00} {
		#if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		    }
		#} else {
		#    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		#    if {$data_scadenza_autocert == 0} {
		#	set msg_errore "Inserire correttamente"
		#       incr err_count
		#    }
		#}
	    }
	    
	    if {$pot_focolare_nom >= 100.00} {
		#if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		    }
		#} else {
		#    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		#    if {$data_scadenza_autocert == 0} {
		#	set msg_errore "Inserire correttamente"
		#	incr err_count
		#    }
		#}
	    }
	    # Fine caso PUD e PGO E CBARLETTA

        } elseif {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" } {#ric01 aggiunta elseif e suo interno (copiato da coimdimp-rct-gest.tcl)
	    
	    set tipo_combustibile [db_string q "select tipo as tipo_combustibile
                                                  from coimcomb
                                                 where cod_combustibile=:combustibile"];#ric01
	    	    
	    if {$pot_focolare_nom < 35.00 } {
		if {$sw_data_controllo_ok == "t"} {
		    if {$tipo_combustibile eq "G"} {#ric01 if else e loro contenuto
			#ric01 se gassoso 4 anni
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
		    } else {
			#ric01 se diverso  da gassoso 2 anni
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		    }
		}
	    }

	    if {$pot_focolare_nom >= 35.00 && $pot_focolare_nom < 100.00} {
		if {$sw_data_controllo_ok == "t"} {
		    if {$tipo_combustibile eq "G"} {#ric01 if else e loro contenuto
			#ric01 se gassoso 2 anni
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		    } else {
			#ric01 se diverso da gassoso 1 anno
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
		    }
		}
	    }
	    
	    if {$pot_focolare_nom >= 100.00} {
		if {$sw_data_controllo_ok == "t"} {
		    if {$tipo_combustibile eq "G"} {#ric01 if else e loro contenuto
			#ric01 se gassoso 2 anni
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		    } else {
			#ric01 se diverso da gassoso 1 anno
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
		    }
		}
	    }
	    
	} elseif {$coimtgen(ente) eq "PCE"} {
            # Provincia di Caserta (usa anche il flag valid_mod_h_b al 04/08/2014)

            # if {[string equal $data_scadenza_autocert ""]} {
                if {$sw_data_controllo_ok   == "t"
                &&  $sw_pot_focolare_nom_ok == "t"
                } {
                    if {$pot_focolare_nom < 35.00} {
                        db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                                ,$coimtgen(valid_mod_h))
                                                     ,'YYYYMMDD') as data_scadenza_autocert
                                         from dual"
                    } else {
                        db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                                ,$coimtgen(valid_mod_h_b))
                                                     ,'YYYYMMDD') as data_scadenza_autocert
                                         from dual"
                    }
                }
            #} else {
            #    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
            #    if {$data_scadenza_autocert == 0} {
            #        set msg_errore "Inserire correttamente"
            #        incr err_count
            #    }
            #}
            # Fine caso provincia di Caserta
	    } elseif {$coimtgen(ente) eq "PMS"} {#sim11 Massa

                if {$sw_data_controllo_ok == "t"} {
		    set data_insta $data_installaz_gend
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
	
	} else {
	    # Caso standard
	    
	    #if {[string equal $data_scadenza_autocert ""]} {
		if {$sw_data_controllo_ok == "t"} {
		    #27/06/2014 D'accordo con Sandro, usiamo il parametro gia' esistente
		    #coimtgen(valid_mod_h): Validità allegati (mesi)
		    #27/06/2014 set data_scadenza_autocert [db_string query "select :data_controllo::date + 775" -default ""]
		    db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                            ,$coimtgen(valid_mod_h))
                                                 ,'YYYYMMDD') as data_scadenza_autocert
                                     from dual";#27062014
		}
	    #} else {
		# set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		#if {$data_scadenza_autocert == 0} {
		#    set msg_errore "Inserire correttamente"
		#    incr err_count
		#}
	    #}
	}

			# Fine istruzioni che devono essere identiche a quelli di coimdimp-rct-gest
#ns_log Notice "simone 1"
			if {$coimtgen(flag_viario) == "T"} {
			    set cod_via [db_string sel_viae_check "select cod_via
	  	                                                              from coimviae
	  	                                                             where upper(descr_topo)  = :toponimo
		                                                               and upper(descrizione) = :indirizzo
	                                                                       and cod_via_new is null
		                                                               and cod_comune = :cod_comune
	                                                                       limit 1"]
			} else {
			    set cod_via ""
			}
			
		
			
			if {$flag_portafoglio == "T"
			    && $data_controllo >= "20080801" } {
			    #set data_insta_check "19000101"
			    #if {![string equal $data_insta ""]} {
				#set data_insta_check [db_string sel_dat "select to_char(add_months(:data_insta, '1'), 'yyyymmdd')"]
			    #}

			    set data_insta_check $data_insta

			    #ns_log notice "prova dob aggiornamento potafoglio dtata controllo $data_controllo data installazione $data_insta_check"
			    
			    if {$data_controllo >= $data_insta_check} {
				#ns_log notice "prova dob aggiornamento potafoglio dtata controllo $data_controllo data installazione $data_insta_check"
				#ns_log notice "simone qqq gen_prog=$gen_prog"
				if {(![string equal $cod_impianto_catasto ""]) && ([db_0or1row sel_dimp_check_data_controllo ""] == 1)} {
				    set tariffa_reg "7"
				    set importo_contr "0.00"
				    set importo_tariffa "0.00";#ric02
				    db_1row sel_dual_cod_dimp ""
				    #ns_log notice "simone aaa gen_prog=$gen_prog"

				} else {
				    set tariffa_reg "7"
				    set pot_focolare_nom_check [iter_edit_num $potenza_foc_nom 2]
				    set pot_focolare_nom_check [iter_check_num $pot_focolare_nom_check 2]
				    #ns_log notice "simone bbb gen_prog=$gen_prog"
				    if {$pot_focolare_nom_check == "0.00"
					|| $pot_focolare_nom_check == "0"} {
					incr err_count
					#ns_log notice "simone ccc gen_prog=$gen_prog"
					#sim06 append msg_errore "Non &egrave; stato possibile calcolare l'importo del contributo regionale in quanto la potenza e&grave; 0,00"
					append msg_errore "Non &egrave; stato possibile calcolare l'importo in quanto la potenza e&grave; 0,00"
				    } else {
					#ns_log notice "simone ddd gen_prog=$gen_prog"
					db_1row sel_cod_potenza ""
					db_1row sel_tari_contributo ""
					set oggi [db_string sel_date "select current_date"]
					set url "lotto/balance?iter_code=$cod_manutentore"
					set data [iter_httpget_wallet $url]
					array set result $data
					set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
					set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
					set saldo [string range $parte_2 0 [expr [string first " " $parte_2] - 1]]
					set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
					
					#ns_log notice "simone saldo=$saldo"

					#sim06 $saldo < importo_contr
					if {$saldo < $costo} {;#sim06	
					    incr err_count
					    append msg_errore "Saldo manutentore ($saldo) non sufficiente" 
					} else {
					    db_1row sel_dual_cod_dimp ""
					    set database [db_get_database]
					    set reference "$cod_dimp+$database"
					    
					    #sim06 set url "lotto/itermove?iter_code=$cod_manutentore&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_contr"
					    set url "lotto/itermove?iter_code=$cod_manutentore&body_id=1&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$costo";#sim06

					    set importo_tariffa 0;#sim16
					    db_0or1row q "select a.importo as importo_tariffa
                                                            from coimtari a
                                                           where a.cod_potenza = :cod_potenza
                                                             and a.tipo_costo  = '7'
                                                             and a.cod_listino = '0' limit 1";#sim16

					    #ns_log notice "simone contributo cod_potenza=$cod_potenza importo_tariffa=$importo_tariffa cod_impianto=$cod_impianto"

					    if {$importo_tariffa > 0} {#sim16 if e suo conenuto

						set url_reg "lotto/itermove?iter_code=$cod_manutentore&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa"
					
						set data [iter_httpget_wallet $url_reg]
						array set result $data
						#		ns_return 200 text/html "$result(page)"; return
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
				    if {[db_0or1row sel_gen_prog "select '1' from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_prog"]} {
					db_dml upd_gend ""
				    } else {
					db_dml ins_gend ""
				    }
				} else {
				    set gen_prog $gen_prog_catasto
				}
	#ns_log notice "simone 2"			
				db_1row sel_tot_potenza_aimp "select sum(pot_focolare_nom) as tot_potenza_aimp from coimgend where cod_impianto = :cod_impianto_catasto"
				db_1row sel_tot_potenza_aimp "select sum(pot_utile_nom) as tot_potenza_utile_aimp from coimgend where cod_impianto = :cod_impianto_catasto"
				
				
				if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom10 Aggiunta if e il suo contenuto
				    if {![db_0or1row q "select targa
                                              from coimaimp
                                             where cod_impianto = :cod_impianto
                                               and coalesce(targa, '') != ''"]} {
					set targa ""
				    }
				    ns_log notice "ter-cari-rcee-tipo-1: Update su cod_impianto $cod_impianto con targa $targa"
				}

				
				db_dml upd_aimp ""
				
				#spesci: il campo flag_status_g non esiste per questo csv
				#if {[string equal $flag_status ""]} {
				#    set flag_status $flag_status_g
				#    if {[string equal $flag_status "S"]} {
				#	set flag_status "P"
				#    }
				#}


				#rom02 inserisco il pagamento sulla coimmovi come avviene per la coimdimp-rct-gest.tcl
				set sw_movi     "f"
				set data_pag    ""
				set importo_pag ""
				#set tipologia_costo $tipo_costo
				#sim18 set tipologia_costo "7"
				set tipologia_costo "LM";#sim18
				set data_scad_pagamento $data_controllo
				set data_pag            $data_scad_pagamento
				set flag_pagato "S"
				if {$costo > 0 && ![string equal $tipologia_costo ""]} {
				    set sw_movi "t"
				    if {$flag_pagato == "S"} {
					if {$flag_portafoglio == "T"} {
					    #ns_log notice "iter-cari-rcee-tipo-1 test1 importo_tariffa "
					    set importo_pag [expr $costo + $importo_tariffa]
					} else {
					    set importo_pag $costo
					}
				    }
				}
			
				if {$sw_movi == "t"} {
				    db_1row sel_dual_cod_movi_ "select nextval('coimmovi_s') as cod_movi"
				    #set dml_movi [db_map ins_movi]
				    db_dml ins_movi_ "
                insert
                  into coimmovi 
                     ( cod_movi
                     , tipo_movi
                     , cod_impianto
                     , data_scad
                     , data_compet
                     , importo
                     , importo_pag
                     , riferimento
                     , data_pag
                     , tipo_pag
                     , data_ins
                     , utente
                     )
                values 
                     (:cod_movi
                     ,'MH'
                     ,:cod_impianto
                     ,:data_scad_pagamento
                     ,:data_controllo
                     ,:costo
                     ,:importo_pag
                     ,:cod_dimp
                     ,:data_pag
                     ,:tipologia_costo
                     , current_date
                     ,:id_utente
                     )"
				}
				#rom02 Fine inserimento pagamenti
				
				if {$inserire_targa eq "t" && $errori == 0} {;#sim09: aggiunta if e suo contenuto
				    set cod_impianto_targa $cod_impianto
				    set dyn_url "$url_portale/iter-portal/targhe/targhe-associa?targa=$targa&nome_db_utilizzo=$nome_db&cod_impianto_targa=$cod_impianto_targa&flag_tipo_impianto=$flag_tipo_impianto"

#				    set data [ad_httpget -url $dyn_url -timeout 100]
				    #rom01 set data [iter_httpget_wallet $dyn_url]
				    set data [iter_httpget_call_portale $dyn_url];#rom01

				}

				db_dml ins_dimp ""
				
				incr count_dimp
				
				if {$flag_portafoglio == "T" && ![string equal $importo_contr ""]} {
				    set soldi_spesi [expr $soldi_spesi + $importo_contr]
				}
				
			    } else {
				
				#spesci: il campo flag_status_g non esiste per questo csv
				#if {[string equal $flag_status ""]} {
				#    set flag_status $flag_status_g
				#    if {[string equal $flag_status "S"]} {
				#	set flag_status "P"
				#    }
				#}
				
				db_1row sel_dual_cod_impianto ""

				if {[string equal $potenza_foc_nom ""]} {
				    set potenza_foc_nom "0.00"
				}
				if {[string equal $potenza_utile_nom ""]} {
				    set potenza_utile_nom "0.00"
				}
				set cod_potenza [db_string sel_pot "select coalesce(cod_potenza, '') from coimpote where potenza_min <= :potenza_foc_nom and potenza_max >= :potenza_foc_nom" -default "0"]
				if {$flag_codifica_reg == "T"} {
                                    #gab01 aggiunto || su provincia di Ancona
				    #sim13 Aggiunto || su Ancona
				    if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA"} {#sim03: aggiunta if ed il suo contenuto
					if {$coimtgen(ente) eq "CPESARO"} {
					    set sigla_est "CMPS"
					} elseif {$coimtgen(ente) eq "CFANO"} {
					    set sigla_est "CMFA"
					} elseif {$coimtgen(ente) eq "CANCONA"} {;#sim13
					    set sigla_est "CMAN"
					} elseif {$coimtgen(ente) eq "PAN"} {;#gab01
					    set sigla_est "PRAN"
					} elseif {$coimtgen(ente) eq "CJESI"} {;#sim15
					    set sigla_est "CMJE"
					} elseif {$coimtgen(ente) eq "CSENIGALLIA"} {;#sim15
					    set sigla_est "CMSE"
					} else {
					    set sigla_est "PRPU"
					}
					
					set progressivo_est [db_string sel "select nextval('coimaimp_est_s')"]
					
					# devo fare l'lpad con una seconda query altrimenti mi va in errore
					#nic01; set progressivo_est [db_string sel "select lpad(:progressivo_est,6,'0')"]
					set progressivo_est [db_string sel "select lpad(:progressivo_est,:lun_num_cod_imp_est,'0')"];#nic01
					
					set cod_impianto_est "$sigla_est$progressivo_est"
					
				    } else {#sim03
					# caso standard

					if {![string equal $cod_comune ""]} {
					    db_1row sel_dati_comu "
                                            select coalesce(progressivo,0) + 1 as progressivo --sim02
                                           --sim10 coalesce(lpad((progressivo + 1), 7, '0'), '0000001') as progressivo
                                                 , cod_istat
                                              from coimcomu
                                             where cod_comune = :cod_comune"

					    #sim10 uniformato agli altri pogrammi che codificano l'impianto
					    if {$coimtgen(ente) eq "PMS"} {#sim10: Riportate modifiche fatte per Massa in data 03/12/2015 per gli altri programmi dove e' presente la codifica dell'impianto 
						set progressivo [db_string query "select lpad(:progressivo, 5, '0')"]
						set cod_istat  "[string range $cod_istat 5 6]/"
					    } elseif {$coimtgen(ente) eq "PTA"} {#sim10: aggiunta if e suo contenuto
						set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
						set fine_istat  [string length $cod_istat]
						set iniz_ist    [expr $fine_istat -3]
						set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
					    } else {#sim10
						set progessivo [db_string query "select lpad(:progressivo, 7, '0')"];#sim10
					    };#sim10

					    if {![string equal $potenza_foc_nom "0.00"]
					    &&  ![string equal $potenza_foc_nom ""]} {
						if {$potenza_foc_nom < 35} {
						    set tipologia "IN"
						} else {
						    set tipologia "CT"
						}
						#sim10 set cod_impianto_est "$cod_istat$tipologia$progressivo"
						set cod_impianto_est "$cod_istat$progressivo";#sim10
						db_dml upd_prog_comu "
                                                update coimcomu
                                                   set progressivo = :progressivo
                                                 where cod_comune  = :cod_comune"
					    } else {
						if {![string equal $cod_potenza "0"]
						&&  ![string equal $cod_potenza ""]} { 
						    switch $cod_potenza {
							"B"  {set tipologia "IN"}
							"A"  {set tipologia "CT"}
							"MA" {set tipologia "CT"}
							"MB" {set tipologia "CT"}
						    }
						    
						    #sim10 set cod_impianto_est "$cod_istat$tipologia$progressivo"
						    set cod_impianto_est "$cod_istat$progressivo";#sim10
						    db_dml upd_prog_comu "
                                                    update coimcomu
                                                       set progressivo = :progressivo
                                                     where cod_comune  = :cod_comune"
						} else {
						    set cod_impianto_est ""
						}
					    }
					} else {
					    set cod_impianto_est ""
					}
				    };#sim03
				} else {
				    db_1row sel_dual_cod_impianto_est ""
				}




				db_dml ins_aimp ""
				db_dml ins_gend ""
				db_dml ins_dimp ""
				
				if {$inserire_targa eq "t" && $errori == 0} {#sim09: aggiunta if e suo contenuto
                                    set cod_impianto_targa $cod_impianto
                                    set dyn_url "$url_portale/iter-portal/targhe/targhe-associa?targa=$targa&nome_db_utilizzo=$nome_db&cod_impianto_targa=$cod_impianto_targa&flag_tipo_impianto=$flag_tipo_impianto"

                                    #rom01set data [ad_httpget -url $dyn_url -timeout 100]
				    set data [iter_httpget_call_portale $dyn_url];#rom01

                                }


				incr count_aimp
				incr count_dimp
				
				if {$flag_portafoglio == "T" && ![string equal $importo_contr ""]} {
				    set soldi_spesi [expr $soldi_spesi + $importo_contr]
				}
			    }
			} else {
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, :colonna_errore , :msg_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
			}
		    } else {
			if {![string equal $cod_impianto_catasto ""]
			    && ![string equal $gen_prog_catasto ""]} {
			    db_dml upd_gen_rott ""
			} else {
			    set msg_errore "Il generatore &egrave; da rottamare ma non &egrave; stato trovato nel database."
			    db_dml ins_anom "insert into $nome_tabella_anom values ( :id_riga , :cod_manutentore, 'cod_impianto_est' , :msg_errore )"
			    db_dml upd_riga "update $nome_tabella set numero_anomalie = '1' , flag_stato = 'S' where id_riga = :id_riga"
			}
		    }
		}

		set count_scartati 0
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
		set page_title "Esito caricamento RCEE di tipo 1 per manutentori"
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
		    
		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Soggetti:</td>
		    <td valign=top class=form_title>$count_citt</td>
		    <td>&nbsp;</td>
		    </tr>
		    
		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Inseriti nuovi Impianti:</td>
		    <td valign=top class=form_title>$count_aimp</td>
		    <td>&nbsp;</td>
		    </tr>
		    
		    
		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Modelli inseriti:</td>
		    <td valign=top class=form_title>$count_dimp</td>
		    <td>&nbsp;</td>
		    </tr>

		    <tr><td valign=top class=form_title colspan=2>&nbsp;&nbsp;&nbsp;Sono stati spesi euro:</td>
		    <td valign=top class=form_title>$soldi_spesi</td>
		    <td>&nbsp;</td>
		    </tr>
		    <tr><td colspan=4>&nbsp;</td>
		    
		    
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
	ns_log Error "iter_cari_rcee_tipo_1: $error_msg"
    }
    
    ns_log Notice "Fine della proc iter_cari_rcee_tipo_1"
    return
}
