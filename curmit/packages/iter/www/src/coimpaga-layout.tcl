ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   19/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl     

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 31/10/2024 Aggiunto class=table_s nella tabella.
} {
    {f_data_da         ""}
    {f_data_a          ""}
    {f_id_caus         ""}
    {f_cod_comune      ""}
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
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
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
    set where_data "and a.data_scad between :f_data_da and  :f_data_a"
} else {
    set where_data ""
}

if {![string equal $f_id_caus ""]} {
    set where_caus "and a.id_caus = :f_id_caus"
} else {
    set where_caus ""
}

if {![string equal $f_cod_comune ""]} {
    set where_comune "and b.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

set titolo       "Stampa pagamenti non effettuati"
set button_label "Stampa"
set page_title   "Stampa pagamenti non effettuati"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "stampa pagamenti non effettuati"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1

set stampa ""
iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)
# Titolo della stampa

append testata "
               <!-- FOOTER LEFT   \"$sysdate_edit\"-->
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

append stampa "<p align=center><big>Stampa pagamenti non effettuati</p></big>"

if {![string equal $f_data_da ""] || ![string equal $f_data_a ""]
    ||  ![string equal $f_id_caus ""] || ( $flag_ente == "P" && ![string equal $f_cod_comune ""])} {
    append stampa "<br>Filtro per"

    if {![string equal $f_data_da ""] || ![string equal $f_data_a ""]} {
	db_1row edit_date_dual ""
        append stampa "<br>Data estrazione compresa tra $data_da_e e $data_a_e"
    }
}

if {![string equal $f_id_caus ""]} {
    #    switch $f_id_caus {
    #	"MH" {set caus_det "Pagamento per dichiarazione"}
    #	"VC" {set caus_det "Pagamento onere visita di controllo"}
    #	"ST" {set caus_det "Sanzione tecnica"}
    #	"SA" {set caus_det "Sanzione amministrativa"}
    #    }
    db_0or1row query "select descrizione as caus_det from coimcaus where id_caus = :f_id_caus"
    append stampa "<br>Caus: $caus_det"
}

if {$flag_ente == "P" && ![string equal $f_cod_comune ""]} {
    db_1row sel_desc_comu ""
    append stampa "<br>Comune: $desc_comune"
}

#puts $file_id "<br>"

# Costruisco descrittivi tabella

if {$flag_ente == "C"} {#but01 aggiunto class=table_s
    append stampa "
          <center>
          <table border=1 class=table_s>
	      <tr>
  	         <th align=left>Tipo movimento</th>
                 <th align=left>Cod. impianto</th>
                 <th align=left>Data scadenza</th>
                 <th align=left>Data compet.</th>
                 <th align=left>Importo</th>
                  <th align=left>Imp.pag.</th>
                 <th align=left>Responsabile impianto</th>
                 <th align=left>Indirizzo</th>
                 <th align=left>Cap-Comune</th>
              </tr>"
} else {#but01 aggiunto class=table_s
    append stampa "
          <center>
          <table border=1 class=table_s>
	      <tr>
  	         <th align=left>Tipo movimento</th>
                 <th align=left>Cod. impianto</th>
                 <th align=left>Data scadenza</th>
                 <th align=left>Data compet.</th>
                 <th align=left>Importo</th>
                 <th align=left>Imp.pag.</th>
                 <th align=left>Comune</th>
                 <th align=left>Responsabile impianto</th>
                 <th align=left>Indirizzo</th>
                 <th align=left>Cap-Comune</th>
              </tr>"
}

db_foreach sel_movi "" {
    if {$flag_ente == "C"} {
	append stampa "
	       <tr>
	           <td align=left>$tipo_movi</td>
                   <td align=left>$cod_impianto_est</td>
                   <td align=left>$data_scad</td>
                   <td align=left>$data_compet</td>
                   <td align=left>$importo</td>
                   <td align=left>$importo_pag</td>
                   <td align=left>$resp</td>
                   <td align=left>$indirizzo</td>
                   <td align=left>$cap_com</td>
               </tr>"   
    } else {
	append stampa "
	       <tr>
	           <td align=left>$tipo_movi</td>
                   <td align=left>$cod_impianto_est</td>
                   <td align=left>$data_scad</td>
                   <td align=left>$data_compet</td>
                   <td align)left>$importo</td>
                   <td align=left>$importo_pag</td>
                   <td align=left>$comune</td>
                   <td align=left>$resp</td>
                   <td align=left>$indirizzo</td>
                   <td align=left>$cap_com</td>
               </tr>"   
    }
} if_no_rows {
    if {$flag_ente == "C"} {
	set colspan 5
    } else {
	set colspan 6
    }
    append stampa "<tr>
                      <td colspan=$colspan>Nessun dato conforme alla selezione impostata</td>
                   </tr>"
}

db_1row estrai_data ""

append stampa "</table>
               </center>"

puts $file_id $testata
puts $file_id $stampa
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ns_unlink $file_html
ad_return_template
