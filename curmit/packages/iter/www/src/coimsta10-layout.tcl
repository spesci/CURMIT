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
} { 
   {caller            "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {f_data1          ""}
   {f_data2          ""}
   {last_cod_documento ""}
   {extra_par          ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
}


ns_log notice "prova dob 1"


# Controlla lo user
set lvl        1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# valorizzo cod_manutentore se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set button_label "Stampa"


set page_title      "Elenco Impianti inseriti"
set context_bar     [iter_context_bar -nome_funz $nome_funz_caller]

# preparo link per ritorno alla lista distinte:
set link_filter [export_ns_set_vars url]

# imposto la directory degli spool ed il loro nome.
set spool_dir       [iter_set_spool_dir]
set spool_dir_url   [iter_set_spool_dir_url]

# imposto il nome dei file
set nome_file       "Piero distinta di consegna modelli H"
set nome_file       [iter_temp_file_name $nome_file]
set file_html       "$spool_dir/$nome_file.html"
set file_pdf        "$spool_dir/$nome_file.pdf"
set file_pdf_url    "$spool_dir_url/$nome_file.pdf"

# apro il file html temporaneo
set file_id [open $file_html w]
fconfigure $file_id -encoding iso8859-1

# sarebbe meglio fare una puts al posto di ogni append righe_stampa
# per risparmiare ram (e l'attesa per liberarla se non e' occupata)
# ma con l'anteprima e' inutile  
set righe_stampa ""

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

# non posso utilizzare la db_transaction con una db_foreach
# per questo metto tutto in una lista e poi faccio la db_transaction

ns_log notice "prova dob 2"

set lista_aimp ""
db_foreach sel_aimp "" {
    lappend lista_aimp [list $cod_impianto_est \
                             $data_ins_edit \
                             $resp \
                             $comune \
                             $indir \
                             $utente]
}

ns_log notice " ferrari1"


set ctr_rec [llength $lista_aimp]
if {$ctr_rec == 0} {
    iter_return_complaint "Nessun dato corrisponde ai criteri impostati"
    return
}


set sysdate       [iter_set_sysdate];
set sysdate_edit  [iter_edit_date $sysdate]
append righe_stampa "
<!-- FOOTER LEFT   \"$sysdate_edit\"-->
<!-- FOOTER CENTER \"ELENCO IMPIANTI INSERITI\"-->
<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->"

iter_get_coimdesc

set nome_ente    $coimdesc(nome_ente)
set tipo_ufficio $coimdesc(tipo_ufficio)
set assessorato  $coimdesc(assessorato)
set indirizzo    $coimdesc(indirizzo)
set telefono     $coimdesc(telefono)

append righe_stampa "
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

ns_log notice " ferrari2"
db_1row sel_tot_imp ""
append righe_stampa "
<br>
<h2>Elenco impianti inseriti </h2>
Numero impianti inseriti: $tot_imp <br>"

append righe_stampa "

<table width=100% border=1 class=table_s>
<br>
    <tr>
        <th align=left   valign=top>Cod.Imp.</th>
        <th align=center valign=top>Data ins.</th>
        <th align=left   valign=top>Responsabile</th>
        <th align=left   valign=top>Comune</th>
        <th align=left   valign=top>Indirizzo</th>
        <th align=left   valign=top>Utente</th>
    </tr>"



foreach riga_aimp $lista_aimp {
    set cod_impianto_est    [lindex $riga_aimp 0]
    set data_ins_edit       [lindex $riga_aimp 1]
    set resp                [lindex $riga_aimp 2]
    set comune              [lindex $riga_aimp 3]
    set indir               [lindex $riga_aimp 4]
    set utente              [lindex $riga_aimp 5]
    
    if {[string is space $cod_impianto_est]} {
	set cod_impianto_est "&nbsp;"
    }
    if {[string is space $data_ins_edit]} {
	set data_ins_edit    "&nbsp;"
    }
    if {[string is space $resp]} {
	set resp             "&nbsp;"
    }
    if {[string is space $comune]} {
	set comune           "&nbsp;"
    }
    if {[string is space $indir]} {
	set indir            "&nbsp;"
    }
    if {[string is space $utente]} {
	set utente  "&nbsp;"
    }
    
    append righe_stampa "
    <tr>
        <td align=left   valign=top>$cod_impianto_est</td>
        <td align=center valign=top>$data_ins_edit</td>
        <td align=left   valign=top>$resp</td>
        <td align=left   valign=top>$comune</td>
        <td align=left   valign=top>$indir</td>
        <td align=left   valign=top>$utente</td>
    </tr>"
	    
}



	
	append righe_stampa "</table>"
	
	puts $file_id $righe_stampa
	close $file_id
	
	# creo il file pdf
	iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 10 --headfootfont arial --headfootsize 10 --landscape --top 2.5cm --bottom 2cm --left 2cm --right 2cm -f $file_pdf $file_html]
	
	# cancello il file temporaneo creato
	#ns_unlink     $file_html
	
#db_release_unused_handles
ad_return_template 
