ad_page_contract {
    Add/Edit/Delete  Estrazione bollettini postali in formato TD896

    @author          Giulio Laurenzi
    @creation-date   31/08/2004

    @param funzione  V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @cvs-id          coimscar-docu-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    rom01 28/09/2022 Aggiunta colonna pec del soggetto responsabile su richiesta di Paravan di Ucit.

} {
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_stampa    ""}
    {f_tipo_documento ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto variabili usate nel programma:
set sysdate [iter_set_sysdate]

# imposto la directory degli permanenti ed il loro nome.
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]

set nome_file     "TD896"
set nome_file     [iter_temp_file_name -permanenti $nome_file]
set file_csv      "$permanenti_dir/$nome_file.csv"
set file_csv_url  "$permanenti_dir_url/$nome_file.csv"

set file_id       [open $file_csv w]
fconfigure $file_id -encoding iso8859-1

# imposto la prima riga del file csv
set     head_cols ""
lappend head_cols "Rigadestinatario1"
lappend head_cols "Rigadestinatario2"
lappend head_cols "Rigadestinatario3"
lappend head_cols "Rigadestinatario4"
lappend head_cols "NOME 1"
lappend head_cols "INDIRIZZO"
lappend head_cols "CAP"
lappend head_cols "DEST"
lappend head_cols "PROV"
lappend head_cols "IBAN"
lappend head_cols "DOM"
lappend head_cols "VAR01D"
lappend head_cols "VAR01S"
lappend head_cols "VAR01A"
lappend head_cols "VAR02A"
lappend head_cols "VAR03A"
lappend head_cols "VAR04A"
lappend head_cols "VAR05A"
lappend head_cols "VAR06A"
lappend head_cols "VAR07A"
lappend head_cols "VAR08A"
lappend head_cols "VAR09A"
lappend head_cols "NOTE01"
lappend head_cols "NOTE02"
lappend head_cols "NOTE03"
lappend head_cols "NOTE04"
lappend head_cols "NOTE05"
lappend head_cols "NOTE06"
lappend head_cols "NOTE07"
lappend head_cols "NOTE08"
lappend head_cols "NOTE09"
lappend head_cols "NOTE10"
lappend head_cols "VCAMPOT"
lappend head_cols "XRATAT"
lappend head_cols "SCADET"

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "documento(nom_resp)"
lappend file_cols "documento(indir_resp)"
lappend file_cols "documento(loca_resp)";#diff. da Viae il campo non e' obbligatorio
lappend file_cols "documento(cap_comune_provincia_resp)"
lappend file_cols "documento(nom_resp)"
lappend file_cols "documento(indir_resp)"
lappend file_cols "documento(cap_resp)"
lappend file_cols "documento(comune_resp)"
lappend file_cols "documento(provincia_resp)"
lappend file_cols "iban"
lappend file_cols "dom"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "impianto"
lappend file_cols "ubicazione"
lappend file_cols "ispezione"
lappend file_cols "ispettore"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "campo_fittizio"
lappend file_cols "quinto_campo";#vcampo
lappend file_cols "importo_emesso_edit";#xrat
lappend file_cols "data_scadenza"


iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

if {$flag_viario == "T"} {
    set sel_docu [db_map sel_docu_si_viae]
} else {
    set sel_docu [db_map sel_docu_no_viae]
}


set sw_primo_rec "t"

# Visto che nel ciclo devo fare delle insert, devo usare una db_transaction.
# Con la db_transaction, non posso usare la db_foreach.
# Al suo posto sfrutto la db_multirow e non la db_list_of_lists per non dover manutentere
# l'elenco di colonne nella util_unlist (che va tenuta allineata alle colonne della query).

db_multirow documenti query $sel_docu

with_catch error_msg {
    db_transaction {

	# Scorro le righe della multirow documenti
	set ind 1
	while {$ind <= ${documenti:rowcount}} {
	    upvar 0 documenti:$ind documento;#documento è un array

	    if {$sw_primo_rec == "t"} {
		set sw_primo_rec "f"
		iter_put_csv $file_id head_cols
	    }

	    # Imposto i campi che non ho estratto con la query
	    # Variabile non usata set causale "Verifica impianto termico"
	    set iban           "N"
	    set dom            ""

	    set ispezione      "$documento(data_verifica) alle $documento(ora_verifica)"
	    if {$coimtgen(ente) ne "CPESARO" && $coimtgen(ente) ne "CFANO"} {
		append ispezione " con dilazione di 90 min."
	    }
	    
	    # non aggiungo l'ora perche' altrimenti non stiamo dentro i 44 caratteri
	    #if {![string is space $documento(ora_verifica)]} {
	    #    append ispezione "alle $documento(ora_verifica)"
	    #}
	    #set ispezione      [string range $ispezione 0 43]

	    set ispettore      "$documento(nome_opve)"
	    set ispettore      [string range $ispettore 0 31]

	    set impianto       "$documento(cod_impianto_est)"

	    set ubicazione     "$documento(indir)"
	    set ubicazione     [string range $ubicazione 0 31]

	    set campo_fittizio ""

	    # Per impostare quinto_campo o importo_emesso_edit,
	    # prima provo a leggerli sulla coimbpos:
	    # se esiste significa che li ho già estratti in precedenza.
	    set cod_inco       $documento(cod_inco)
	    if {![db_0or1row query "select iter_edit_num(importo_emesso,2) as importo_emesso_edit
                                         , quinto_campo
                                      from coimbpos
                                     where cod_inco = :cod_inco"]
	    } {
		# In questo caso inserisco un nuovo record di bpos:

		# Trovo un cod_bcos univoco grazie alla sequence
                db_1row sel_dual_cod_bpos ""

		# Imposto le altre variabili che mi servono per l'inserimento.

		# cod_inco e' gia' valorizzato

		# Il quinto campo deve essere di 16 caratteri (abbiamo provato con 15 ma ci e'
		# stato scartato).
		# Ho inizialmente messo 1 davanti per evitare problemi con excel (che mangia
		# gli 0 di sx) ma ci e' stato scartato perche' volevano un campo testo.
		# Ho provato con apice ma ci e' stato scartato.
		# Ce l'hanno accettato se uso la funzione testo ma non posso piu' mettere
		# l'uno davanti altrimenti viene approssimata l'ultima cifra alla decina.
		db_1row query "select lpad(:cod_bpos, 16, '0') as quinto_campo
                                 from dual"

		set data_emissione $documento(data_documento)

		if {$documento(potenza) < 35} {
		    set importo_emesso  80
		} else {
		    set importo_emesso 100
		}


		set stato          "A";#attivo
		set data_ins       $sysdate
		set utente_ins     $id_utente

                db_dml query "
                insert
                  into coimbpos
                     ( cod_bpos
                     , cod_inco
                     , quinto_campo
                     , data_emissione
                     , importo_emesso
                     , importo_pagato  
                     , data_pagamento
                     , protocollo
                     , data_protocollo
                     , stato
                     , data_ins
                     , utente_ins
                     , data_mod
                     , utente_mod
                     )
                values
                     ( :cod_bpos
                     , :cod_inco
                     , :quinto_campo
                     , :data_emissione
                     , :importo_emesso
                     , 0    -- importo_pagato
                     , null -- data_pagamento 
                     , null -- protocollo
                     , null -- data_protocollo
                     , :stato
                     , :data_ins
                     , :utente_ins
                     , null -- data_mod
                     , null -- utente_mod
                     )
                "

		# Ora posso valorizzare le variabili del tracciato record

		set importo_emesso_edit [iter_edit_num $importo_emesso 2]

		# quinto_campo (già valorizzato prima dell'insert)
            }

	    # Le poste vogliono due campi testo. Come spiegato sopra, ce l'hanno accettato solo
	    # usando la funzione =TESTO e mettendo gli opportuni formati ("0000000000000000" e
            # "0,00"):

	    set quinto_campo        "=TESTO($quinto_campo;\"0000000000000000\")"

	    set importo_emesso_edit "=TESTO($importo_emesso_edit;\"0,00\")"

	    set data_scadenza $documento(data_verifica)

	    # Ora scrivo il record
	    set file_col_list ""
	    foreach column_name $file_cols {
		lappend file_col_list [set $column_name]
	    }
	    iter_put_csv $file_id file_col_list


	    incr ind;#leggo la riga successiva dell'array documenti
	}
    
    };#fine db_transaction
} {
    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
}

if {$sw_primo_rec eq "t"} {
    set msg_err      "Non e' stato trovato nessun documento con i criteri di ricerca impostati"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list
}
   
ad_returnredirect $file_csv_url
ad_script_abort
