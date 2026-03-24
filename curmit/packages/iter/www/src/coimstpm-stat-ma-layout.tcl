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
    ===== ========== =============================================================================================================
    rom01 08/04/2024 Sandro ha chiesto di aggiungere i campi importo, flag pagato e data pagamento della coimmovi.
    rom01            Intervento richiesto per Terra di Lavoro ma puo' andare bene per tutti.

} {
    {f_data_da         ""}
    {f_data_a          ""}
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
set cod_tecn   [iter_check_uten_opve $id_utente]
set cod_enve   [iter_check_uten_enve $id_utente]

if {![string equal $cod_tecn ""]} {
    set f_cod_tecn $cod_tecn
    if {[db_0or1row sel_cod_enve ""] == 1} {
	set f_cod_enve $cod_enve
    }
    set flag_cod_tecn "t"
} else {
    set flag_cod_tecn "f"
}

if {![string equal $cod_enve ""]} {
    set f_cod_enve $cod_enve
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}

if {[string equal $cod_tecn ""]} {
    set where_tecn ""
} else {
    set where_tecn "and a.cod_opve = :cod_tecn"
}



# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

iter_get_coimtgen
set flag_ente   $coimtgen(flag_ente)
set flag_viario $coimtgen(flag_viario)

if {![string equal $f_data_da ""] || ![string equal $f_data_a  ""]} {
    if {[string equal $f_data_da ""]} {
	set data_da $f_data_da
	set f_data_da "18000101"
    } else {
	set data_da [iter_edit_date $f_data_da]
    }
    if {[string equal $f_data_a ""]} {
	set data_a $f_data_a
	set f_data_a "21001231"
    } else {
	set data_a [iter_edit_date $f_data_a]
    }
    db_1row edit_date_dual ""
    set where_data "and a.data_controllo between :f_data_da and  :f_data_a"
} else {
    set where_data ""
    set data_da ""
    set data_a ""
}

if {[string equal $cod_tecn ""]} {
    set where_tecn ""
} else {
    set where_tecn "and a.cod_opve = :cod_tecn"
}

#dpr74
if {[string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp ""
} else {
    set where_tipo_imp "and b.flag_tipo_impianto = :flag_tipo_impianto"
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


set titolo       "Stampa statistiche Mancata Ispezione"
set button_label "Stampa"
set page_title   "Stampa statistiche Mancata Ispezione"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

set permanenti_dir [iter_set_permanenti_dir]

# imposto il nome dei file
set nome_file        "stampa_statistiche_mancata_verifica"
set nome_file        [iter_temp_file_name -permanenti $nome_file]
set file_html        "$permanenti_dir/$nome_file.html"
set file_pdf         "$permanenti_dir/$nome_file.pdf"
set file_csv_name    "$permanenti_dir/$nome_file.csv"

set file_pdf_url     "../permanenti/$nome_file.pdf"
set file_csv_url     "../permanenti/$nome_file.csv"

set file_id  [open $file_html w]
set file_csv [open $file_csv_name w]
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

append stampa "<p align=center><big>Stampa statistiche Mancata Ispezione  - $desc_tipo_impianto -</p></big>"

if {![string equal $f_data_da ""] ||  ![string equal $f_data_a ""]} {
    db_1row edit_date_dual ""
   
    append stampa "<br>Data estrazione compresa tra $data_da_e e $data_a_e"
} else {
    set data_da_e ""
    set data_a_e ""
}

#Setto la prima riga della tabella
append stampa "
          <center>
          <table border=1>
	      <tr>
                 <th align=left>Data Controllo</th>
                 <th align=left>Codice</th>
                 <th align=left>Mancata Ispezione</th>
                 <th align=left>Codice Impianto</th>
                 <th align=left>Indirizzo</th>
                 <th align=left>Comune</th>
                 <th align=left>Responsabile</th>
                 <th align=left>Importo</th>
                 <th align=left>Pagato</th>
                 <th align=left>Data pagamento</th>
                             </tr>"

# Costruisco descrittivi tabella
# Setto la prima riga del csv
set     head_cols ""
lappend head_cols "Data Controllo"
lappend head_cols "Codice "
lappend head_cols "Mancata Ispezione"
lappend head_cols "Codice Impianto"
lappend head_cols "Indirizzo"
lappend head_cols "Comune"
lappend head_cols "Responsabile"
lappend head_cols "Importo";#rom01
lappend head_cols "Pagato";#rom01
lappend head_cols "Data pagamento";#rom01
lappend head_cols "Cod. Incontro"
lappend head_cols "St. Incontro"
lappend head_cols "Note"


# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "data_controllo"
lappend file_cols "cod_noin"
lappend file_cols "descr_noin"
lappend file_cols "cod_impianto_est"
lappend file_cols "indirizzo"
lappend file_cols "comune"
lappend file_cols "nome_resp"
lappend file_cols "importo_mov";#rom01
lappend file_cols "flag_pagato_mov";#rom01
lappend file_cols "data_pag_mov";#rom01
lappend file_cols "cod_inco"
lappend file_cols "stato_inco"
lappend file_cols "note_verificatore"


set table_def [list \
		   [list data_controllo_edit  "Data Controllo"        no_sort {l}] \
		   [list cod_noin             "Codice"                no_sort {l}] \
		   [list descr_noin           "Mancata Ispezione"     no_sort {l}] \
		   [list cod_impianto_est     "Codice Impianto"       no_sort {l}] \
		   [list indirizzo            "Indirizzo"             no_sort {l}] \
		   [list comune               "Comune"                no_sort {l}] \
		   [list nome_resp            "Responsabile"          no_sort {l}] \
		   [list importo_mov          "Importo"               no_sort {l}] \
		   [list flag_pagato_mov      "Pagato"                no_sort {l}] \
		   [list data_pag_mov         "Data pagamento"        no_sort {l}] \

	          ]

# setto la query da utilizzare per la tabella dei risultati
set select [db_map sel_stat_ma]

# imposto il 'conta' record estratti
if {![db_0or1row query "
  select count(*) as conta
  from coimcimp a
left outer join coiminco g on g.cod_inco = a.cod_inco
left outer join coimnoin f on f.cod_noin = a.cod_noin
left outer join coimmovi m on m.riferimento = a.cod_cimp and m.data_compet= a.data_controllo --rom01
,coimaimp b
,coimviae d
,coimcomu c
,coimcitt e
where b.cod_impianto  = a.cod_impianto
and d.cod_via  = b.cod_via
and c.cod_comune  = b.cod_comune
and e.cod_cittadino  = b.cod_responsabile
and a.flag_tracciato = 'MA'
$where_data
$where_tecn
$where_tipo_imp
"]} {
    set conta 0
}
set conta "Impianti estratti ($desc_tipo_impianto): <b>$conta</b>"

set sw_primo_rec "t"
db_foreach sel_stat_ma "" {
    
    regsub -all \n $note_verificatore " " note_verificatore
    regsub -all \r $note_verificatore " " note_verificatore

    append stampa "
	       <tr>
                   <td align=left>$data_controllo_edit&nbsp;</td>
	           <td align=left>$cod_noin&nbsp;</td>
                   <td align=left>$descr_noin&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$indirizzo&nbsp;</td>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$nome_resp&nbsp;</td>
                   <td align=left>$importo_mov&nbsp;</td>
                   <td align=left>$flag_pagato_mov&nbsp;</td>
                   <td align=left>$data_pag_mov&nbsp;</td>
               </tr>"

    set file_cols_list ""
    
    if {[string equal $sw_primo_rec "t"]} {
 	set sw_primo_rec "f"
 	iter_put_csv $file_csv head_cols
    }
    
    foreach column_name $file_cols {
 	lappend file_cols_list [set $column_name]
    }
    iter_put_csv $file_csv file_cols_list

} if_no_rows {
    set msg_err "Nessun dato conforme alla selezione impostata"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_csv msg_err_list

    append stampa "<tr>
                 <td colspan=7>Nessun dato conforme alla selezione impostata</td>
               </tr>"
}

append stampa "</table>
               </center>"

set table_result [ad_table -Tmissing_text "Nessun dato conforma alla selezione impostata." -Textra_vars {data_controllo cod_noin descr_noin cod_impianto_est indirizzo comune nome_resp note} go $select $table_def]

puts $file_id $testata
puts $file_id $stampa
close $file_id

close $file_csv

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ns_unlink $file_html
ad_return_template
