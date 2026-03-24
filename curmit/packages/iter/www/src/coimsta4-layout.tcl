ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   10/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl     

    rom01 11/07/2023 Modifiche chieste da Sandro

} {
   {f_data1           ""}
   {f_data2           ""}
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
    set data1_ok "01/01/1800"
} else {
    #set data1_ok [iter_check_date $f_data1]
    set data1_ok [iter_edit_date $f_data1]
}
if {[string equal $f_data2 ""]} {
    set f_data2 "21001231"
    set data2_ok "12/31/2100"
} else {
   #set data2_ok [iter_check_date $f_data1]
    set data2_ok [iter_edit_date $f_data2]
}

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "Stampa riepilogo appuntamenti eff.-ris."
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set titolo       "Stampa rapporto totale controlli"
set button_label "Stampa"
set page_title   "Stampa rapporto totale controlli"
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


#but01 append stampa "<br><br>
#               <hr>
#               RAPPORTO TOTALE CONTROLLI DAL $data1_ok AL $data2_ok
#               <hr>
 #              <br><br>"
append stampa "<br><br>
              <table border=1 width=100% class=table_s>
                <tr> <th align=center valign=top><b> RAPPORTO TOTALE CONTROLLI DAL $data1_ok AL $data2_ok </b></th></tr></table>";#but01

# Costruisco descrittivi tabella
append stampa "<table border=1 width=100% class=table_s>";#but01

set inizio "S"
set conta 0

db_1row count_gg_lavoro_opve ""
db_1row count_lettere_spe ""
db_1row count_lettere_spe_inf ""
db_1row count_lettere_spe_sup ""
db_1row count_riserve ""
db_1row count_riserve_inf ""
db_1row count_riserve_sup ""
db_1row count_controlli_eff ""
db_1row count_controlli_eff_inf ""
db_1row count_controlli_eff_inf_nnoto ""
db_1row count_controlli_eff_inf_csolid ""
db_1row count_controlli_eff_inf_gasn ""
db_1row count_controlli_eff_inf_gaso ""
db_1row count_controlli_eff_inf_gpl ""
db_1row count_controlli_eff_inf_olio ""
db_1row count_controlli_eff_inf_pcalo "";#rom01
db_1row count_controlli_eff_sup ""
db_1row count_controlli_eff_sup_nnoto ""
db_1row count_controlli_eff_sup_csolid ""
db_1row count_controlli_eff_sup_gasn ""
db_1row count_controlli_eff_sup_gaso ""
db_1row count_controlli_eff_sup_gpl ""
db_1row count_controlli_eff_sup_olio ""
db_1row count_controlli_eff_sup_pcalo "";#rom01
db_1row count_controlli_eff_pos ""
db_1row count_mancate_ver ""
db_1row count_controlli_con_note ""
db_1row count_negativo_uni_inf ""
db_1row count_negativo_uni_sup ""
db_1row count_negativo_dpr_inf ""
db_1row count_negativo_dpr_sup ""
set controlli_gg_opve [iter_edit_num [expr $controlli_eff / $gg_lavoro_opve] 1]


append stampa "
	  <tr><td align=right>Giornate cumulative degli ispettori</td>
	      <td align=center>$gg_lavoro_opve</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Lettere spedite</td>
	      <td align=center>$lettere_spe</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>di cui, per potenza inf. 35 kW</td>
	      <td align=center>$lettere_spe_inf</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>di cui, per potenza sup. 35 kW</td>
	      <td align=center>$lettere_spe_sup</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli non effettuati</td>
	      <td align=center>$riserve</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>di cui, per potenza inf. 35 kW</td>
	      <td align=center>$riserve_inf</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>di cui, per potenza sup. 35 kW</td>
	      <td align=center>$riserve_sup</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Totale controlli effettuati</td>
	      <td align=center>$controlli_eff</td>
              <td align=center>Pompa di cal.</td> <!-- rom01 modificata label, prima era Non noto -->
              <td align=center>Comb. solido</td>
              <td align=center>Gas nat.</td>
              <td align=center>Gasolio</td>
              <td align=center>GPL</td>
              <td align=center>Altro</td></tr>
	  <tr><td align=right>di cui, per potenza inf. 35 kW</td>
	      <td align=center>$controlli_eff_inf</td>
              <td align=center>$controlli_eff_inf_pcalo</td> <!-- rom01 Sostiuito $controlli_eff_inf_nnoto -->
              <td align=center>$controlli_eff_inf_csolid</td>
              <td align=center>$controlli_eff_inf_gasn</td>
              <td align=center>$controlli_eff_inf_gaso</td>
              <td align=center>$controlli_eff_inf_gpl</td>
              <td align=center>$controlli_eff_inf_olio</td></tr>
	  <tr><td align=right>di cui, per potenza sup. 35 kW</td>
	      <td align=center>$controlli_eff_sup</td>
              <td align=center>$controlli_eff_sup_pcalo</td> <!-- rom01 Sostiuito $controlli_eff_sup_nnoto -->
              <td align=center>$controlli_eff_sup_csolid</td>
              <td align=center>$controlli_eff_sup_gasn</td>
              <td align=center>$controlli_eff_sup_gaso</td>
              <td align=center>$controlli_eff_sup_gpl</td>
              <td align=center>$controlli_eff_sup_olio</td></tr>
	  <tr><td align=right>Controlli con esito positivo</td>
	      <td align=center>$controlli_eff_pos</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Mancate verifiche</td>
	      <td align=center>$mancate_ver</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli con note da comunicare(anomalie)</td>
	      <td align=center>$controlli_con_note</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli con esito negativo UNI 10389 per pot. inf. 35 kW</td>
	      <td align=center>$negativo_uni_inf</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli con esito negativo UNI 10389 per pot. sup. 35 kW</td>
	      <td align=center>$negativo_uni_sup</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli con esito negativo Rendimento inferiore al limite (pot. inf. 35 kW)</td>
	      <td align=center>$negativo_dpr_inf</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli con esito negativo Rendimento inferiore al limite (pot. sup. 35 kW)</td>
	      <td align=center>$negativo_dpr_sup</td>
              <td colspan=6>&nbsp;</td></tr>
	  <tr><td align=right>Controlli giornalieri per ispettore</td>
	      <td align=center>$controlli_gg_opve</td>
              <td colspan=6>&nbsp;</td></tr>
	  "

append stampa "</table>"
append stampa "<br><br>
               <tr><td colspan=8>NB</td></tr>
               <tr><td colspan=8>Normativa UNI 10389, CO SFORATO (max.1000 ppm), indice di nero fumo sforato (max. bacharach 2 gasolio)</td></tr>
               <tr><td colspan=8>D.P.R. 412/93, rendimento minimo dei generatori di calore.</td></tr>"

# creo file temporaneo html

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer D / --quiet --landscape --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom  0cm -f $file_pdf $file_html]

ns_unlink $file_html
#ad_returnredirect $file_pdf_url
#ad_script_abort
ad_return_template
