ad_page_contract {
    @author          Gianni Prosperi
    @creation-date   19/04/2007

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimstpm-stat-opve-layout.tcl     


    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    mic01 20/01/2023 Modifiche per il nuovo "Rapporto di Accertamento"

} {
    {f_data_da         ""}
    {f_data_a          ""}
    {cod_potenza       ""}
    {f_cod_comune      ""}
    {cod_combustibile  ""}
    {f_cod_enve        ""}
    {f_cod_tecn        ""}
    {flag_tipo_impianto  ""}
    {caller       "index"}
    {funzione         "V"}
    {nome_funz         ""}
    {nome_funz_caller  ""}   
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

iter_get_coimtgen
set flag_ente   $coimtgen(flag_ente)
set flag_viario $coimtgen(flag_viario)

if {![string equal $f_data_da ""] || ![string equal $f_data_a  ""]} {
    if {[string equal $f_data_da ""]} {
	set f_data_da "18000101"
    }
    if {[string equal $f_data_a ""]} {
	set f_data_a "21001231"
    }
    set where_data "and a.data_controllo between :f_data_da and  :f_data_a"
} else {
    set where_data ""
}

if {![string equal $cod_potenza ""]} {
    set where_cod_potenza "and b.cod_potenza = :cod_potenza"
} else {
    set where_cod_potenza ""
}

if {![string equal $f_cod_comune ""]} {
    set where_comune "and b.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

if {![string equal $cod_combustibile ""]} {
    set where_combustibile "and b.cod_combustibile = :cod_combustibile"
} else {
    set where_combustibile ""
}

if {![string equal $f_cod_tecn ""]} {
    set where_opve "and a.cod_opve = :f_cod_tecn"
} else {
    set where_opve ""
}
#dpr74

if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and b.flag_tipo_impianto = :flag_tipo_impianto"
} else {
    set where_tipo_imp ""
}

#dpr74

set desc_tipo_impianto ""

if {[string equal $flag_tipo_impianto ""]} {
   set desc_tipo_impianto "Globale"
} 
if {[string equal $flag_tipo_impianto "R"]} {
   set desc_tipo_impianto "Riscaldamento"
} 
if {[string equal $flag_tipo_impianto "F"]} {
   set desc_tipo_impianto "Raffrddamento"
} 
if {[string equal $flag_tipo_impianto "C"]} {
   set desc_tipo_impianto "Cogenerazione"
} 
if {[string equal $flag_tipo_impianto "T"]} {
   set desc_tipo_impianto "Teleriscaldamento"
} 
#fine dpr74

set titolo       "Stampa statistiche operatore Ispettore"
set button_label "Stampa"
set page_title   "Stampa statistiche operatore Ispettore"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_permanenti_dir]
set spool_dir_url [iter_set_permanenti_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "stampa_statistiche_operatore_ispettore"
set nome_file        [iter_temp_file_name -permanenti $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"
set file_csv_name    "$spool_dir/$nome_file.csv"
set file_csv_url     "$spool_dir_url/$nome_file.csv"
set anom_csv_name    "$spool_dir/$nome_file-anomalie.csv"
set anom_csv_url     "$spool_dir_url/$nome_file-anomalie.csv"

set   file_id  [open $file_html w]
set   file_csv [open $file_csv_name w]
set   anom_csv [open $anom_csv_name w]
fconfigure $file_id -encoding iso8859-1
fconfigure $file_csv -encoding iso8859-1
fconfigure $anom_csv -encoding iso8859-1

set stampa ""
iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)


# Titolo della stampa

append testata "<!-- FOOTER LEFT   \"$sysdate_edit\"-->
                <!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->
             <table width=100%>
               <tr>
                   <td width=100% align=center>
                       <table><tr>
                           <td align=center><b>$ente</b></td>
                       </tr><tr>
                           <td align=center>$ufficio</td>
                       </tr><tr>
                           <td align=center>$assessorato</td>
                       </tr><tr>
                           <td align=center><small>$indirizzo_ufficio</small></td>
                       </tr><tr>
                           <td align=center><small>$telefono_ufficio</small></td>
                       </tr></td>
                       </table>
                  </tr>
               </table> "

append stampa "<p align=center><big>Stampa statistiche tecnico Ispettore - $desc_tipo_impianto- </p></big>"

if {![string equal $f_data_da ""] || ![string equal $f_data_a ""]} {
    db_1row edit_date_dual ""
    append stampa "<br>Data estrazione compresa tra $data_da_e e $data_a_e"
} else {
    set data_da_e ""
    set data_a_e ""
}
#puts $file_id "<br>"

# Costruisco descrittivi tabella
if {$flag_ente == "C"} {
    #mic01 aggiunto tipo verbale
    append stampa "
          <center>
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Ispettoree</th>
                 <th>Tecnico Ispettore</th>
  	         <th>Fascia di Potenza</th>
                 <th align=left>Combustibile</th>
                 <th align=left>Cod. Impianto</th>
                 <th align=left>N. Verbale</th>
                 <th align=left>Totale Ispezioni</th>
                 <th align=left>Positive</th>
                 <th align=left>Negative</th>
                 <th align=left>Anomalia</th>
                 <th align=left>Numero</th>
                 <th align=left>Tipo verbale</th>
             </tr>"

    # Setto la prima riga del csv
    set     head_cols ""
    lappend head_cols "Da Data"
    lappend head_cols "A Data"
    lappend head_cols "Ente Ispettore"
    lappend head_cols "Tecnico Ispettore"
    lappend head_cols "Fascia di Potenza"
    lappend head_cols "Combustibile"
    lappend head_cols "Codice Impianto"
    lappend head_cols "Rapporto di Ispezione"
    lappend head_cols "Totale Ispezioni"
    lappend head_cols "Positive"
    lappend head_cols "Negative"
    lappend head_cols "Anomalia"
    lappend head_cols "Numero"
    lappend head_cols "Tipo verbale";#mic01

    # imposto il tracciato record del file csv
    set     file_cols ""
    lappend file_cols "data_da_e"
    lappend file_cols "data_a_e"
    lappend file_cols "nome_ente"
    lappend file_cols "nome_opve"
    lappend file_cols "fascia_potenza"
    lappend file_cols "combustibile"
    lappend file_cols "cod_impianto_est"
    lappend file_cols "verb_n"
    lappend file_cols "n_verifiche"
    lappend file_cols "n_verifiche_pos"
    lappend file_cols "n_verifiche_neg"
    lappend file_cols "anomalia"
    lappend file_cols "count_anomalie"
    lappend file_cols "tipo_verbale";#mic01
} else {
    #mic01 aggiunto tipo verbale
    append stampa "
          <center>
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Verificatore</th>
                 <th>Tecnico Verificatore</th>
                 <th align=left>Comune</th>
  	         <th>Fascia di Potenza</th>
                 <th align=left>Combustibile</th>
                 <th align=left>Cod. Impianto</th>
                 <th align=left>N. Verbale</th>
                 <th align=left>Totale Ispezioni</th>
                 <th align=left>Positive</th>
                 <th align=left>Negative</th>
                 <th align=left>Anomalia</th>
                 <th align=left>Numero</th>
                 <th align=left>Tipo verbale</th>
              </tr>"
    # Setto la prima riga del csv
    set     head_cols ""
    lappend head_cols "Da Data"
    lappend head_cols "A Data"
    lappend head_cols "Ente Ispettore"
    lappend head_cols "Tecnico Ispettore"
    lappend head_cols "Comune"
    lappend head_cols "Fascia di Potenza"
    lappend head_cols "Combustibile"
    lappend head_cols "Codice Impianto"
    lappend head_cols "Rapporto di Ispezione"
    lappend head_cols "Totale Ispezioni"
    lappend head_cols "Positive"
    lappend head_cols "Negative"
    lappend head_cols "Anomalia"
    lappend head_cols "Numero"
    lappend head_cols "Tipo verbale";#mic01

    # imposto il tracciato record del file csv
    set     file_cols ""
    lappend file_cols "data_da_e"
    lappend file_cols "data_a_e"
    lappend file_cols "nome_ente"
    lappend file_cols "nome_opve"
    lappend file_cols "comune"
    lappend file_cols "fascia_potenza"
    lappend file_cols "combustibile"
    lappend file_cols "cod_impianto_est"
    lappend file_cols "verb_n"
    lappend file_cols "n_verifiche"
    lappend file_cols "n_verifiche_pos"
    lappend file_cols "n_verifiche_neg"
    lappend file_cols "anomalia"
    lappend file_cols "count_anomalie"
    lappend file_cols "tipo_verbale";#mic01
}

set sw_primo_rec "t"

db_foreach sel_stat_opve "" {
    #    db_0or1row count_all ""
    #    db_0or1row count_pos ""
    #    db_0or1row count_neg ""
    #    db_0or1row count_anomalia ""

    set anomalia ""
    set count_anomalie ""
    set flag_primo "t"

    db_foreach sel_anom "" {
	if {[string equal $flag_primo "t"]} {
	    append anomalia $cod_tanom
	    set flag_primo "f"
	} else {
	    append anomalia ", $cod_tanom"
	}
    } if_no_rows {
	append anomalia "-"
    }
    set file_cols_list ""

    if {[string equal $sw_primo_rec "t"]} {
	set sw_primo_rec "f"
	iter_put_csv $file_csv head_cols
    }

    #  ns_return 200 text/html "$nome_opve<br>$n_verifiche<br>$n_verifiche_pos<br>$n_verifiche_neg<br>$fascia_potenza<br>$combustibile"; return
    if {$flag_ente == "C"} {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$verb_n&nbsp;</td>
                   <td align=left>$n_verifiche&nbsp;</td>
                   <td align=left>$n_verifiche_pos&nbsp;</td>
                   <td align=left>$n_verifiche_neg&nbsp;</td>
                   <td align=left>$anomalia&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
	foreach column_name $file_cols {
	    lappend file_cols_list [set $column_name]
	}
	iter_put_csv $file_csv file_cols_list
	
    } else {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$verb_n&nbsp;</td>
                   <td align=left>$n_verifiche&nbsp;</td>
                   <td align=left>$n_verifiche_pos&nbsp;</td>
                   <td align=left>$n_verifiche_neg&nbsp;</td>
                   <td align=left>$anomalia&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
	#	ns_return 200 text/html $file_cols; return
	foreach column_name $file_cols {
	    lappend file_cols_list [set $column_name]
	}
	iter_put_csv $file_csv file_cols_list
    }
} if_no_rows {
    set msg_err "Nessun dato conforme alla selezione impostata"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_csv msg_err_list

    if {$flag_ente == "C"} {
	set colspan 7
    } else {
	set colspan 8
    }
    append stampa "<tr>
                      <td colspan=$colspan>Nessun dato conforme alla selezione impostata</td>
                   </tr>"
}

db_1row estrai_data ""

append stampa "</table>"

#Estraggo e stampo i dati relativi alle anomalie
append stampa "<!-- PAGE BREAK -->"
append stampa "<p align=center><big>Statistiche relative alle anomalie riscontrate - $desc_tipo_impianto- </big></p>"

# Costruisco descrittivi tabella
if {$flag_ente == "C"} {
    #mic01 aggiunto tipo verbale
    append stampa "
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Ispettore</th>
                 <th>Tecnico Ispettore</th>
                 <th>Descrizione Anomalia</th>
                 <th>Numero</th>
  	         <th>Fascia di Potenza</th>
                 <th>Combustibile</th>
                 <th>Tipo verbale</th>
              </tr>"
    # Setto la prima riga del csv
    set     head_cols_anom ""
    lappend head_cols_anom "Ente Ispettore"
    lappend head_cols_anom "Tecnico Ispettore"
    lappend head_cols_anom "Fascia di Potenza"
    lappend head_cols_anom "Combustibile"
    lappend head_cols_anom "Descrizione Anomalia"
    lappend head_cols_anom "Numero"
    lappend head_cols_anom "Tipo verbale";#mic01
    
    # imposto il tracciato record del file csv
    set     file_cols_anom ""
    lappend file_cols_anom "nome_ente"
    lappend file_cols_anom "nome_opve"
    lappend file_cols_anom "fascia_potenza"
    lappend file_cols_anom "combustibile"
    lappend file_cols_anom "descr_anomalia"
    lappend file_cols_anom "count_anomalie"
    lappend file_cols_anom "tipo_verbale";#mic01


} else {
    #mic01 aggiunto tipo verbale
    append stampa "
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Ispettore/th>
                 <th>Tecnico Ispettore</th>
                 <th>Comune</th>
                 <th>Descrizione Anomalia</th>
                 <th>Numero</th>
  	         <th>Fascia di Potenza</th>
                 <th>Combustibile</th>
                 <th>Tipo verbale</th>
              </tr>"

    # Setto la prima riga del csv
    set     head_cols_anom ""
    lappend head_cols_anom "Ente Ispettore"
    lappend head_cols_anom "Tecnico Ispettore"
    lappend head_cols_anom "Comune"
    lappend head_cols_anom "Fascia di Potenza"
    lappend head_cols_anom "Combustibile"
    lappend head_cols_anom "Descrizione Anomalia"
    lappend head_cols_anom "Numero"
    lappend head_cols_anom "Tipo verbale";#mic01
    
    # imposto il tracciato record del file csv
    set     file_cols_anom ""
    lappend file_cols_anom "nome_ente"
    lappend file_cols_anom "nome_opve"
    lappend file_cols_anom "comune"
    lappend file_cols_anom "fascia_potenza"
    lappend file_cols_anom "combustibile"
    lappend file_cols_anom "descr_anomalia"
    lappend file_cols_anom "count_anomalie"
    lappend file_cols_anom "tipo_verbale";#mic01
}

set sw_primo_rec "t"
db_foreach sel_anom_opve "" {

    if {$flag_ente == "C"} {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$descr_anomalia&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
    } else {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$descr_anomalia&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
    }
    set file_cols_list_anom ""

    if {[string equal $sw_primo_rec "t"]} {
	set sw_primo_rec "f"
	iter_put_csv $anom_csv head_cols_anom
    }

    foreach column_name $file_cols_anom {
	lappend file_cols_list_anom [set $column_name]
    }
    iter_put_csv $anom_csv file_cols_list_anom
}

append stampa "</table>
               </center>"

# BUBU
#Estraggo e stampo i dati relativi alle criticità
append stampa "<!-- PAGE BREAK -->"
append stampa "<p align=center><big>Statistiche relative alle anomalie riscontrate - $desc_tipo_impianto- </big></p>"

# Costruisco descrittivi tabella
if {$flag_ente == "C"} {
    #mic01 aggiunto tipo verbale
    append stampa "
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Ispettore</th>
                 <th>Tecnico Ispettore</th>
                 <th>Criticita'</th>
                 <th>Numero</th>
  	         <th>Fascia di Potenza</th>
                 <th>Combustibile</th>
                 <th>Tipo verbale</th>
              </tr>"
    # Setto la prima riga del csv
    set     head_cols_anom ""
    lappend head_cols_anom "Ente Ispettore"
    lappend head_cols_anom "Tecnico Ispettore"
    lappend head_cols_anom "Fascia di Potenza"
    lappend head_cols_anom "Combustibile"
    lappend head_cols_anom "Criticita'"
    lappend head_cols_anom "Numero"
    lappend head_cols_anom "Tipo verbale";#mic01
    
    # imposto il tracciato record del file csv
    set     file_cols_anom ""
    lappend file_cols_anom "nome_ente"
    lappend file_cols_anom "nome_opve"
    lappend file_cols_anom "fascia_potenza"
    lappend file_cols_anom "combustibile"
    lappend file_cols_anom "criticita"
    lappend file_cols_anom "count_anomalie"
    lappend file_cols_anom "tipo_verbale";#mic01
} else {
    #mic01 aggiunto tipo verbale
    append stampa "
          <table border=1 class=table_s>
	      <tr>
                 <th>Ente Ispettore</th>
                 <th>Tecnico Ispettore</th>
                 <th>Comune</th>
                 <th>Criticita'</th>
                 <th>Numero</th>
  	         <th>Fascia di Potenza</th>
                 <th>Combustibile</th>
                 <th>Tipo verbale</th>
              </tr>"

    # Setto la prima riga del csv
    set     head_cols_anom ""
    lappend head_cols_anom "Ente Ispettore"
    lappend head_cols_anom "Tecnico Ispettore"
    lappend head_cols_anom "Comune"
    lappend head_cols_anom "Fascia di Potenza"
    lappend head_cols_anom "Combustibile"
    lappend head_cols_anom "Criticita'"
    lappend head_cols_anom "Numero"
    lappend head_cols_anom "Tipo verbale";#mic01
    
    # imposto il tracciato record del file csv
    set     file_cols_anom ""
    lappend file_cols_anom "nome_ente"
    lappend file_cols_anom "nome_opve"
    lappend file_cols_anom "comune"
    lappend file_cols_anom "fascia_potenza"
    lappend file_cols_anom "combustibile"
    lappend file_cols_anom "criticita"
    lappend file_cols_anom "count_anomalie"
    lappend file_cols_anom "tipo_verbale";#mic01
}
set sw_primo_rec "t"
db_foreach sel_crit_opve "" {
    if {$flag_ente == "C"} {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$criticita&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
    } else {
	#mic01 aggiunto tipo verbale
	append stampa "
	       <tr>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$criticita&nbsp;</td>
                   <td align=left>$count_anomalie&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$tipo_verbale</td>
               </tr>"   
    }
    set file_cols_list_anom ""

    if {[string equal $sw_primo_rec "t"]} {
	set sw_primo_rec "f"
	iter_put_csv $anom_csv head_cols_anom
    }

    foreach column_name $file_cols_anom {
	lappend file_cols_list_anom [set $column_name]
    }
    iter_put_csv $anom_csv file_cols_list_anom
}

append stampa "</table>
               </center>"


puts $file_id $testata
puts $file_id $stampa
close $file_id
close $file_csv
close $anom_csv
# lo trasformo in PDF
#mic01 modificata dimensione carattere
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --fontsize 10 --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 1cm -f $file_pdf $file_html]

ns_unlink $file_html
ad_return_template
