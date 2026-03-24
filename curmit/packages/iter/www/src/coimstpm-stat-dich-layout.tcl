ad_page_contract {
    @author          Gianni Prosperi
    @creation-date   19/04/2007

    @param funzione  V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimstpm-stat-opve-layout.tcl     

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    but01 31/10/2024 Aggiunto class=table_s nella tabella.
    
    rom02 14/04/2023 Con Sandro si e' deciso che anche la Provincia di Udine filtra le dichiarazioni
    rom02            con la data inserimento e non la data protocollo perche' sui caricamenti massivi
    rom02            la data protocollo non e' valorizzata.

    sim01 27/04/2022 Corretto errore di rom01, per le Provincie non venivano piu' settate le colonne
    sim01            di intestazione del file e il programma andava in errore.

    rom01 04/04/2022 MAC Regione Marche 9. Colonna N. di telefono su RCEE/DAM:
    rom01            Aggiunta colonna telefono, puo' andare su tutti gli enti.

    san01 28/10/2020 Aggiunta colonna costo, puo' andare su tutti gli enti.

} {
    {f_data_da         ""}
    {f_data_a          ""}
    {cod_potenza       ""}
    {f_cod_comune      ""}
    {cod_combustibile  ""}
    {cognome_manu      ""}
    {f_data_controllo_iniz ""}
    {f_data_controllo_fine ""}
    {ute_emmegi        ""}
    {f_utente          ""}
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
    # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

set id_utente_em [string range $id_utente 0 5]

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
    if {$coimtgen(ente) eq "PUD"} {
	#rom02set where_data "and a.data_prot between :f_data_da and  :f_data_a"
	set where_data "and a.data_ins  between :f_data_da and  :f_data_a";#rom02
    } else {
	set where_data "and a.data_ins  between :f_data_da and  :f_data_a"
    }
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

set uno emmegi$ute_emmegi


if {![string equal $ute_emmegi ""]} {
    set where_utente "and a.utente_ins = :uno"
} else {
    set where_utente ""
}

if {![string equal $cognome_manu ""]} {
    set where_manu "and g.cognome like :cognome_manu"
} else {
    set where_manu ""
}
 
if {![string equal $f_utente ""]} {
    set where_utente_admin "and a.utente_ins = :f_utente"
} else {
    set where_utente_admin ""
}

# se richiesta selezione per data_controllo
set where_data_controllo ""

if {![string equal $f_data_controllo_iniz ""]} {
    # questa volta non serve l'ora perche' data_controllo viene inserita senza
    append where_data_controllo  "
    and a.data_controllo >= :f_data_controllo_iniz"
}

if {![string equal $f_data_controllo_fine ""]} {
    # questa volta non serve l'ora perche' data_controllo viene inserita senza
    append where_data_controllo  "
    and a.data_controllo <= :f_data_controllo_fine"
}

db_1row count_all ""

set titolo       "Stampa statistiche Dichiarazioni"
set button_label "Stampa"
set page_title   "Stampa statistiche Dichiarazioni"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_permanenti_dir]
set spool_dir_url [iter_set_permanenti_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "stampa_statistiche_dich"
set nome_file        [iter_temp_file_name -permanenti $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"
set file_csv_name    "$spool_dir/$nome_file.csv"
set file_csv_url     "$spool_dir_url/$nome_file.csv"

set   file_id  [open $file_html w]
set   file_csv [open $file_csv_name w]

fconfigure $file_id -encoding iso8859-1
fconfigure $file_csv -encoding iso8859-1

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
             <table width=100% >
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

append stampa "<p align=center><big>Stampa statistiche Dichiarazioni </p></big>"

if {![string equal $f_data_da ""] || ![string equal $f_data_a ""]} {
    db_1row edit_date_dual ""
    append stampa "<br>Estrazione compresa tra le seguenti  date di inserimento : $data_da_e e $data_a_e  Numero dich.: $num_dich"
} else {
    set data_da_e ""
    set data_a_e ""
}
#puts $file_id "<br>"

# Costruisco descrittivi tabella
#sim01 if {$flag_ente == "C"} {
#but01 Aggiunto class=table_s

    append stampa "
          <center>
          <table border=1 class=table_s>
             <br>
	      <tr>
                 <th>Codice Manutentore</th>
                 <th>Manutentore</th>
  	          <th>Fascia di Potenza</th>
                 <th align=left>Combustibile</th>
                 <th align=left>Cod. Impianto</th>
                 <th align=left>Responsabile</th>
                 <th align=left>N&deg; telefono</th><!--rom01-->
                 <th align=left>Stato Imp.</th>
                 <th align=left>Comune</th>
                 <th align=left>N.Prot</th>
                 <th align=left>Data Prot.</th>
                 <th align=left>Data_controllo</th>
                 <th align=left>Bollino</th>
                 <th align=left>Costo</th>
                 <th align=left>Utente Ins.</th>
                           </tr>"

    # Setto la prima riga del csv
    set     head_cols ""
    lappend head_cols "Codice Manutentore"
    lappend head_cols "Manutentore"
    lappend head_cols "Fascia di Potenza"
    lappend head_cols "Combustibile"
    lappend head_cols "Cod.Impianto"
    lappend head_cols "Responsabile"
    lappend head_cols "N. telefono";#rom01
    lappend head_cols "Stato Imp."
    lappend head_cols "Comune"
    lappend head_cols "N.Prot"
    lappend head_cols "Data Prot."
    lappend head_cols "Data_controllo"
    lappend head_cols "Bollino"
    lappend head_cols "Costo"
    lappend head_cols "Utente Ins."

    # imposto il tracciato record del file csv
    set     file_cols ""
    lappend file_cols "codice"
    lappend file_cols "cog_manu"
    lappend file_cols "fascia_potenza"
    lappend file_cols "combustibile"
    lappend file_cols "cod_impianto_est"
    lappend file_cols "resp"
    lappend file_cols "resp_tel";#rom01"
    lappend file_cols "stato"
    lappend file_cols "comune"
    lappend file_cols "n_prot"
    lappend file_cols "data_protocollo"
    lappend file_cols "data_controllo"
    lappend file_cols "riferimento_pag"
    lappend file_cols "costo"
    lappend file_cols "utente_ins"
#sim01 }

set sw_primo_rec "t"

db_foreach sel_stat_dich "" {
    #    db_0or1row count_all ""
    #    db_0or1row count_pos ""
    #    db_0or1row count_neg ""
    #    db_0or1row count_anomalia ""
  
    set file_cols_list ""

    if {[string equal $sw_primo_rec "t"]} {
	set sw_primo_rec "f"
	iter_put_csv $file_csv head_cols
    }
    set cod_impianto_est "\'$cod_impianto_est"

    #personalizzazione per provincia di Udine
    if {$coimtgen(ente) eq "PUD"} {
	set cognome_resp ""
	db_0or1row query "select nn.responsabile as cognome_resp
                            from coimdimp_agg nn
                           where nn.cod_impianto   = :cod_impianto 
                             and nn.data_controllo = :data_con
                             and nn.flag_tracciato = :flag_tracciato limit 1"
	if {![string equal $cognome_resp ""] } {
	    set resp $cognome_resp
	}
	
	if {![string equal $resp ""] } {
	    db_0or1row query "select coalesce(jj.cognome,' ')||' '||coalesce(jj.nome,' ') as resp
                                from coimaimp kk
                                   , coimcitt jj
                               where kk.cod_responsabile = jj.cod_cittadino
                                 and kk.cod_impianto     = :cod_impianto"
	}
    }
    #fine personalizzazione per provincia di Udine

    #  ns_return 200 text/html "<br>$fascia_potenza<br>$combustibile"; return
    if {$flag_ente == "C"} {
	append stampa "
	       <tr>
                   <td align=left>$codice&nbsp;</td>
	           <td align=left>$cog_manu&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$resp&nbsp;</td>
                   <td align=left>$resp_tel&nbsp;</td><!--rom01-->
                   <td align=left>$stato&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$n_prot&nbsp;</td>
                   <td align=left>$data_protocollo&nbsp;</td>
                   <td align=left>$data_controllo&nbsp;</td>
                   <td align=left>$riferimento_pag&nbsp;</td>
                   <td align=left>$costo&nbsp;</td>
                   <td align=left>$utente_ins&nbsp;</td>
               </tr>"   
	foreach column_name $file_cols {
	    lappend file_cols_list [set $column_name]
	}
	iter_put_csv $file_csv file_cols_list
	
    } else {
	append stampa "
	       <tr>
                  <td align=left>$codice&nbsp;</td>
	           <td align=left>$cog_manu&nbsp;</td>
                   <td align=left>$fascia_potenza&nbsp;</td>
                   <td align=left>$combustibile&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$resp&nbsp;</td>
                   <td align=left>$resp_tel&nbsp;</td><!--rom01-->
                   <td align=left>$stato&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$n_prot&nbsp;</td>
                   <td align=left>$data_protocollo&nbsp;</td>
                   <td align=left>$data_controllo&nbsp;</td>
                   <td align=left>$riferimento_pag&nbsp;</td>
                   <td align=left>$costo&nbsp;</td>
                   <td align=left>$utente_ins&nbsp;</td>
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


puts $file_id $testata
puts $file_id $stampa
close $file_id
close $file_csv
# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --fontsize 07 --left 0.5cm --right 0.5cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ns_unlink $file_html
ad_return_template
