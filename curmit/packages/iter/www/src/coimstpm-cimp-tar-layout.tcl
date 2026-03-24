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
    rom01 08/04/2024 Sandro ha chiesto di aggiungere i campi flag pagato e data pagamento della coimmovi.
    rom01            Intervento richiesto per Terra di Lavoro ma puo' andare bene per tutti.

} {
    {f_data_da         ""}
    {f_data_a          ""}
    {f_cod_enve        ""}
    {f_cod_tecn        ""}
    {f_costo_da        ""}
    {f_costo_a         ""}
    {f_cod_comune      ""}
    {flag_tipo_impianto ""}
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

if {![string equal $f_costo_da ""] || ![string equal $f_costo_a  ""]} {
    if {[string equal f_costo_da ""]} {
	set f_costo_da "0.00"
    }
    if {[string equal $f_costo_a ""]} {
	set f_costo_a "100000.00"
    }
    set where_costo "and a.costo between :f_csto_da and :f_costo_a"
} else {
    set where_costo ""
}

if {![string equal $f_cod_tecn ""]} {
    set where_opve "and a.cod_opve = :f_cod_tecn"
} else {
    set where_opve ""
}

if {[info exists f_cod_comune]} {
    if {![string equal $f_cod_comune ""]} {
	set where_comune "and e.cod_comune = :f_cod_comune"
    } else {
	set where_comune ""
    }
} else {
    set where_comune ""
}
#dpr74

if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and e.flag_tipo_impianto = :flag_tipo_impianto"
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


set titolo_uno   "Stampa statistiche amministrativo -$desc_tipo_impianto-"
set button_label "Stampa"
set page_title   "Stampa statistiche amministrativo"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

set oggi [db_string query "select current_date"]
set dir     "$spool_dir/$oggi"

if {![file exists $dir]} {
    file mkdir $dir
    exec chmod 777 $dir
}

# imposto il nome dei file
set nome_file        "stampa_statistiche_amministrativo"
set nome_file        [iter_temp_file_name -permanenti $nome_file]

set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"
set file_csv_name    "$spool_dir/$nome_file.csv"
set file_csv_url     "$spool_dir_url/$nome_file.csv"

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
               </table>"

append stampa "<p align=center><big>Stampa statistiche amministrativo -$desc_tipo_impianto-</p></big>"

if {![string equal $f_data_da ""] ||  ![string equal $f_data_a ""]} {
    db_1row edit_date_dual ""
    
    append stampa "<br>Data estrazione compresa tra $data_da_e e $data_a_e"
} else {
    set data_da_e ""
    set data_a_e ""
}

# Setto la prima riga del csv
set     head_cols ""
lappend head_cols "Da Data"
lappend head_cols "A Data"
lappend head_cols "Ente Verificatore"
lappend head_cols "Tecnico Verificatore"
lappend head_cols "Cod.Impianto"
lappend head_cols "Responsabile"
lappend head_cols "Costo"
lappend head_cols "Tipo Costo"
lappend head_cols "Pagato";#rom01
lappend head_cols "Data pagamento";#rom01
lappend head_cols "Tariffa"
lappend head_cols "Tipo Estrazione"
lappend head_cols "Num.Fatt."
lappend head_cols "Esito"
lappend head_cols "Dich.Scad?"
lappend head_cols "App.n."
lappend head_cols "St.Imp"

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "data_da"
lappend file_cols "data_a"
lappend file_cols "nome_ente"
lappend file_cols "nome_opve"
lappend file_cols "cod_impianto_est"
lappend file_cols "responsabile"
lappend file_cols "costo"
lappend file_cols "tipo_costo"
lappend file_cols "flag_pagato_mov";#rom01
lappend file_cols "data_pag_mov"   ;#rom01
lappend file_cols "tariffa"
lappend file_cols "tp_estr"
lappend file_cols "numfatt"
lappend file_cols "esito"
lappend file_cols "scaduta"
lappend file_cols "cod_inco"
lappend file_cols "stat_imp"

# Costruisco descrittivi tabella
set table_def_uno [list \
		       [list comune           "Comune"           no_sort    {l}] \
		       [list nome_ente        "Ente Verif."      no_sort    {l}] \
		       [list nome_opve        "Tecnico Verif."   no_sort    {l}] \
		       [list cod_impianto_est "Cod.Impianto"     no_sort    {r}] \
		       [list responsabile     "Responsabile"     no_sort    {l}] \
		       [list costo            "Tot.Costo"        no_sort    {r}] \
		       [list tipo_costo       "TipoCosto"        no_sort    {l}] \
		       [list flag_pagato_mov  "Pagato"           no_sort    {l}] \
		       [list data_pag_mov     "Data pagamento"   no_sort    {l}] \
		       [list tariffa          "Tariffa"          no_sort    {r}] \
		       [list tp_estr          "Tipo Estr."       no_sort    {l}] \
		       [list numfatt          "Num.Fatt."        no_sort    {r}] \
		       [list esito            "Esito"            no_sort    {c}] \
		       [list scaduta          "D.Sc."            no_sort    {c}] \
                     [list cod_inco         "N.App."           no_sort    {c}] \
                     [list stat_imp         "Stato"            no_sort    {c}] \
		  ]

# setto la query da utilizzare per la tabella dei risultati
set select [db_map sel_cimp_tar]

#Setto la prima riga della tabella
append stampa "
        <center>
          <table border=1>
	      <tr>
                 <th>Comune</th>
                 <th>Ente Verif.</th>
                 <th>Tecnico Verif.</th>
                 <th align=left>Cod.Impianto</th>
                 <th align=left>Responsabile</th>
                 <th align=left>Costo</th>
                 <th align=left>TipoCosto</th>
                 <th align=left>Pagato</th>
                 <th align=left>DataPag.</th>
                 <th align=left>Tariffa</th>
                 <th align=left>Tipo Estr.</th>
                 <th align=left>N.Fatt.</th>
                 <th align=center>Esito</th>
                 <th align=center>Dich.Scad?</th>
                 <th align=center>App.n.</th>
                  <th align=center>St.imp.</th>
              </tr>"
set sw_primo_rec "t"

db_foreach sel_cimp_tar "" {

    append stampa "
	       <tr>
                   <td align=left>$comune&nbsp;</td>
                   <td align=left>$nome_ente&nbsp;</td>
	           <td align=left>$nome_opve&nbsp;</td>
                   <td align=left>$cod_impianto_est&nbsp;</td>
                   <td align=left>$responsabile&nbsp;</td>
                   <td align=left>$costo&nbsp;</td>
                   <td align=left>$tipo_costo&nbsp;</td>
                   <td align=left>$flag_pagato_mov&nbsp;</td>
                   <td align=left>$data_pag_mov&nbsp;</td>
                   <td align=left>$tariffa&nbsp;</td>
                   <td align=left>$tp_estr&nbsp;</td>
                   <td align=left>$numfatt&nbsp;</td>
                   <td align=center>$esito&nbsp;</td>
                   <td align=center>$scaduta&nbsp;</td>
                    <td align=center>$cod_inco&nbsp;</td>
                    <td align=center>$stat_imp&nbsp;</td>
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
                 <td colspan=5>Nessun dato conforme alla selezione impostata</td>
               </tr>"
}

append stampa "</table>
               </center>"

set table_result_uno [ad_table -Tmissing_text "Nessun dato conforma alla selezione impostata." -Textra_vars {data_da_e data_a_e nome_ente nome_opve cod_impianto_est costo esito numfatt scaduta} go $select $table_def_uno]

set titolo_due    "Stampa statistiche Mancata Ispezione -$desc_tipo_impianto-"

# imposto il nome dei file (due)
set nome_file_due     "stampa_stat_mancata_ispezione "
set nome_file_due     [iter_temp_file_name -permanenti $nome_file_due]
set file_csv_name_due "$spool_dir/$nome_file_due.csv"
set file_csv_url_due  "$spool_dir_url/$nome_file_due.csv"
set file_csv_due [open $file_csv_name_due w]
fconfigure $file_csv_due -encoding iso8859-1

# Setto la prima riga del csv
set     head_cols ""
lappend head_cols "Data controllo"
lappend head_cols "Codice"
lappend head_cols "Mancata Ispezione"
lappend head_cols "Cod.Impianto"
lappend head_cols "Indirizzo"
lappend head_cols "Comune"
lappend head_cols "Responsabile"
lappend head_cols "Importo";#rom01
lappend head_cols "Pagato";#rom01
lappend head_cols "Data pagamento";#rom01

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

set table_def_due [list \
		   [list data_controllo       "Data Controllo"        no_sort {l}] \
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

append stampa "
<!-- PAGE BREAK -->
<br>
<p align=center><big>Stampa statistiche Mancata Ispezione -$desc_tipo_impianto-</p></big>"

# Setto la prima riga della tabella
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

set sw_primo_rec "t"
db_foreach sel_stat_ma "" {

    append stampa "
	       <tr>
                   <td align=left>$data_controllo&nbsp;</td>
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
 	iter_put_csv $file_csv_due head_cols
    }
       
    foreach column_name $file_cols {
 	lappend file_cols_list [set $column_name]
    }
    iter_put_csv $file_csv_due file_cols_list	

} if_no_rows {
    set msg_err "Nessun dato conforme alla selezione impostata"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_csv_due msg_err_list

    append stampa "<tr>
                 <td colspan=7>Nessun dato conforme alla selezione impostata</td>
               </tr> "
}

append stampa "</table>
            </center>"

set table_result_due [ad_table -Tmissing_text "Nessun dato conforma alla selezione impostata." -Textra_vars {data_da_e data_a_e nome_ente nome_opve cod_impianto_est costo} go $select $table_def_due]

puts $file_id $testata
puts $file_id $stampa
close $file_id
close $file_csv
close $file_csv_due

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --fontsize 8 --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ns_unlink $file_html
ad_return_template
