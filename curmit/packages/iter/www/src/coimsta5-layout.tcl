ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   10/05/2004

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
   {f_data1           ""}
   {f_data2           ""}
   {flag_tipo_impianto   ""}
   {caller       "index"}
   {funzione         "V"}
   {nome_funz         ""}
   {nome_funz_caller  ""}   
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
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

set link_filter [export_ns_set_vars url]

# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


if {[string equal $f_data1 ""]} {
    set f_data1 "18000101"
    set data1_ok "01/01/2000"
} else {
    set data1_ok [iter_edit_date $f_data1]
}
if {[string equal $f_data2 ""]} {
    set f_data2 "21001231"
    set data2_ok "31/12/2100"
} else {
    set data2_ok [iter_edit_date $f_data2]
}

#inizio dpr74
# imposto filtro per tipo impianto
if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and z.flag_tipo_impianto = :flag_tipo_impianto"
} else {
    set where_tipo_imp ""
}

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

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "Stampa statistica incontri"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set titolo       "Stampa statistica incontri"
set button_label "Stampa"
set page_title   "Stampa statistica incontri"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 
 
set root       [ns_info pageroot]
set stampa ""

iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)
# Titolo della stampa


append stampa "<br><br>
               <hr>
               <b>STATISTICA INCONTRI DAL $data1_ok AL $data2_ok - <big>Tipologia Impianto: $desc_tipo_impianto</big></b>
               <hr>
               <br><br>"

# Costruisco descrittivi tabella
append stampa "<center><table border=1 width=50% class=table_s>"

set inizio "S"
set conta 0

db_1row sel_tot_inco ""

append stampa "<tr><th><b>Totale incontri: $tot_inco</b></th></tr>"

append stampa "</table><br>
               <table width=50% border=1 class=table_s>
                 <tr><th colspan=2><b>Suddivisi per stato dell'incontro:</b></th></tr>"

db_foreach sel_inco_stato "" {
    append stampa "<tr><td width=40%>$stato</td>
                       <td width=60%>$inco_count_stato</td>
                   </tr>"
}

append stampa "</table><br>
               <table class=table_s border=1 width=50%>
                 <tr><th colspan=2><b>I motivi dell'annullamento degli incontri codificati sono:</b></th></tr>"

db_foreach sel_inco_motivi_ann "" {
    append stampa "<tr><td width=40%>$motivo_ann</td>
                       <td width=60%>$inco_count_ann</td>
                   </tr>"
}

append stampa "</table><br>
               <table class=table_s border=1 width=50%>
                 <tr><th colspan=2><b>Gli incontri in stato effettuato suddivisi per fascia di potenza e tipo estrazione:</b></th></tr>"

db_foreach sel_inco_eff_pote "" {
    append stampa "<tr><td width=40%><b>$inco_count_pote</b></td>
                       <td width=60%><b>$potenza</b></td>
                   </tr>"
    db_foreach sel_inco_eff_tpes_pote "" {
	append stampa "<tr><td width=40%>di cui $count_tpes</td>
                           <td width=60%>$tp_estr</td>
                       </tr>"
    }
}

append stampa "</table><br>
               <table class=table_s border=1 width=50%>
                 <tr><th colspan=2><b>Riepilogo incontri effettuati suddivisi per tipo estrazione:</b></th></tr>"

db_foreach sel_inco_eff_tpes "" {
    append stampa "<tr><td width=40%>$tipo_estrazione</td>
                       <td width=60%>$inco_count_tpes</td>
                   </tr>"
}

append stampa "</table></center>"

# creo file temporaneo html

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer D / --quiet --landscape --bodyfont arial --fontsize 08-- left 1cm --right 1cm --top 0cm --bottom  0cm -f $file_pdf $file_html]

ns_unlink $file_html
#ad_returnredirect $file_pdf_url
#ad_script_abort
ad_return_template
