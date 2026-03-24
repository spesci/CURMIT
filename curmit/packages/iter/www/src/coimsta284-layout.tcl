ad_page_contract {
    Stampa distinta di consegna Modelli H
    
    @author                  pippo
    @creation-date           07/07/2006
    
    @param caller            se diverso da index rappresenta il nome del form 
    da cui e' partita la ricerca ed in questo caso
    imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
    serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
    serve per la navigation bar
    
    @cvs-id coimdimp-scar-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 31/10/2024 Aggiunto class=table_s nella tabella.

} { 
    {caller            "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""} 
    {f_comune          ""}
    {f_data1          ""}
    {f_data2          ""}
    {nome_manu         ""}
    {cognome_manu      ""}
    {cod_manutentore   ""}
    {last_cod_documento ""}
    {extra_par          ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
}


set cod_manu $cod_manutentore

set sw_primo_rec "t"
set n_colspan 5

set f_data1_edit [iter_edit_date $f_data1]
set f_data2_edit [iter_edit_date $f_data2]

# Controlla lo user
set lvl        1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# valorizzo cod_manutentore se utente manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set button_label "Stampa"


set page_title      "Elenco allegati 284 inseriti"
set context_bar     [iter_context_bar -nome_funz $nome_funz_caller]

# preparo link per ritorno alla lista distinte:
set link_filter [export_ns_set_vars url]

# imposto la directory degli spool ed il loro nome.
set spool_dir       [iter_set_spool_dir]
set spool_dir_url   [iter_set_spool_dir_url]

# imposto il nome dei file
set nome_file       "Allegati 284 inseriti"
set nome_file       [iter_temp_file_name $nome_file]
set file_html       "$spool_dir/$nome_file.html"
set file_pdf        "$spool_dir/$nome_file.pdf"
set file_pdf_url    "$spool_dir_url/$nome_file.pdf"


# apro il file html temporaneo
set file_id [open $file_html w]
fconfigure $file_id -encoding iso8859-1

set nome_file_csv "elenco_allegati284"
set nome_file_csv [iter_temp_file_name -permanenti $nome_file_csv]
set file_csv_name "$spool_dir/$nome_file_csv.csv"
set file_csv_url  "$spool_dir_url/$nome_file_csv.csv"
set file_html_csv "$spool_dir/$nome_file_csv.html"

#set file_id  [open $file_html_csv w]
set file_csv [open $file_csv_name w]
fconfigure $file_csv -encoding iso8859-1

# imposto la prima riga del file csv
set     head_cols ""
lappend head_cols "Codice"
lappend head_cols "Data consegna"
lappend head_cols "Data ricevuta"
lappend head_cols "Manutentore"
lappend head_cols "Comune"
lappend head_cols "Indirizzo"

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "cod_impianto_est"
lappend file_cols "data_consegna_edit"
lappend file_cols "data_ricevuta_edit"
lappend file_cols "manutentore"
lappend file_cols "comune"
lappend file_cols "indir"


# sarebbe meglio fare una puts al posto di ogni append stampa
# per risparmiare ram (e l'attesa per liberarla se non e' occupata)
# ma con l'anteprima e' inutile  
set stampa ""

# imposto la query SQL 

# scrivo due query diverse a seconda se c'e' o meno il viario
iter_get_coimtgen

if {$coimtgen(flag_viario) == "T"} {
    set nome_col_toponimo  "e.descr_topo"
    set nome_col_via       "e.descrizione"
} else {
    set nome_col_toponimo  "b.toponimo"
    set nome_col_via       "b.indirizzo"
}


     
if {![string equal $cod_manu ""]} {
    set where_cond " and c.cod_manutentore = :cod_manu"
} else {
    set where_cond ""
}


if {![string equal $f_comune ""]} {
    set where_com " and b.cod_comune = :f_comune"
} else {
    set where_com ""
}



# non posso utilizzare la db_transaction con una db_foreach
# per questo metto tutto in una lista e poi faccio la db_transaction


set lista_aimp ""
db_foreach sel_aimp "" {
    lappend lista_aimp [list $cod_impianto_est \
                             $data_consegna_edit \
                             $data_ricevuta_edit \
                             $manutentore \
                             $comune \
                             $indir \
                             ]
}



set ctr_rec [llength $lista_aimp]
if {$ctr_rec == 0} {
    iter_return_complaint "Nessun dato corrisponde ai criteri impostati"
    return
}


set sysdate       [iter_set_sysdate];
set sysdate_edit  [iter_edit_date $sysdate]
append stampa "
<!-- FOOTER LEFT   \"$sysdate_edit\"-->
<!-- FOOTER CENTER \"ELENCO ALLEGATI art 284 INSERITI\"-->
<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->"

iter_get_coimdesc

set nome_ente    $coimdesc(nome_ente)
set tipo_ufficio $coimdesc(tipo_ufficio)
set assessorato  $coimdesc(assessorato)
set indirizzo    $coimdesc(indirizzo)
set telefono     $coimdesc(telefono)

append stampa "
<table width=100%>
      <tr>
         <td align=center>$nome_ente</td>
      </tr>
      <tr>
         <td align=center>$tipo_ufficio</td>
      </tr>
      <tr>
         <td align=center>$assessorato</td>
      </tr>
      <tr>
         <td align=center><small>$indirizzo</small></td>
      </tr>
      <tr>
         <td align=center><small>$telefono</small></td>
      </tr>
</table>"

db_1row sel_tot_all ""
append stampa "
<br>
<h2>Elenco allegati art. 284 inseriti da $f_data1_edit a $f_data2_edit </h2>
Numero Allegati inseriti: $tot_all da $f_data1_edit a $f_data2_edit<br>"
#but01 Aggiunto class=table_s 
append stampa "

<table width=100% border=1 class=table_s>
<br>
    <tr>
        <th align=left   valign=top>Cod.Imp.</th>
        <th align=center valign=top>Data Consegna.</th>
        <th align=center valign=top>Data Ricevuta.</th>
        <th align=left   valign=top>Manutentore</th>
        <th align=left   valign=top>Comune</th>
        <th align=left   valign=top>Indirizzo</th>
           </tr>"




foreach riga_aimp $lista_aimp {
    set cod_impianto_est    [lindex $riga_aimp 0]
    set data_consegna_edit  [lindex $riga_aimp 1]
    set data_ricevuta_edit  [lindex $riga_aimp 2]
    set manutentore         [lindex $riga_aimp 3]
    set comune              [lindex $riga_aimp 4]
    set indir               [lindex $riga_aimp 5]
    
    if {[string is space $cod_impianto_est]} {
	set cod_impianto_est "&nbsp;"
    }
    if {[string is space $data_consegna_edit]} {
	set data_ins_edit    "&nbsp;"
    }
    if {[string is space $data_ricevuta_edit]} {
	set data_ins_edit    "&nbsp;"
    }
    if {[string is space $manutentore]} {
	set resp             "&nbsp;"
    }
    if {[string is space $comune]} {
	set comune           "&nbsp;"
    }
    if {[string is space $indir]} {
	set indir            "&nbsp;"
    }
    
    
    append stampa "
    <tr>
        <td align=left   valign=top>$cod_impianto_est</td>
        <td align=center valign=top>$data_consegna_edit</td>
        <td align=center valign=top>$data_ricevuta_edit</td>
        <td align=left   valign=top>$manutentore</td>
        <td align=left   valign=top>$comune</td>
        <td align=left   valign=top>$indir</td>
          </tr>"
    

    
    # csv
    set file_cols_list ""
    
    
    if {[string equal $sw_primo_rec "t"]} {
	set sw_primo_rec "f"
	iter_put_csv $file_csv head_cols ;
    }
    
    foreach column_name $file_cols {
	lappend file_cols_list [set $column_name]
    }
    iter_put_csv $file_csv file_cols_list;
    
}


close $file_csv
# fine csv

append stampa "</table>"

puts $file_id $stampa
close $file_id

ns_log notice "prova dob 1 $file_pdf - $file_html"

with_catch error_msg {
    exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 10 --headfootfont arial --headfootsize 10 --landscape --top 2.5cm --bottom 2cm --left 2cm --right 2cm -f $file_pdf $file_html
} {
    ns_return 200 text/html "$error_msg-"; return
}	


# creo il file pdf
#	iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 10 --headfootfont arial --headfootsize 10 --landscape --top 2.5cm --bottom 2cm --left 2cm --right 2cm -f $file_pdf $file_html]

# cancello il file temporaneo creato
#ns_unlink     $file_html

#db_release_unused_handles

ns_log notice "prova dob 2 $file_pdf_url"


ad_return_template 
