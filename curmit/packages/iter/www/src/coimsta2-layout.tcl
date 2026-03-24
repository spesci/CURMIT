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
   {f_cod_comune      ""}
   {f_cod_quartiere   ""}
   {f_data1           ""}
   {f_data2           ""}
   {f_campagna        ""}
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

set cod_opve [iter_check_uten_opve $id_utente]

set link_filter [export_ns_set_vars url]

# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {![string equal $cod_opve ""]} {
    set where_opve " and a.cod_opve = :cod_opve"
} else {
    set where_opve ""
}

if {![string equal $f_campagna ""]} {
    set where_campagna "and a.cod_cinc = :f_campagna"
}

if {![string equal $f_cod_comune ""]} {
    set where_comune "and b.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

if {![string equal $f_data1 ""] 
||  ![string equal $f_data2 ""]
} {
    if {[string equal $f_data1 ""]} {
	set f_data1 "18000101"
    }
    if {[string equal $f_data2 ""]} {
	set f_data2 "21001231"
    }
    set where_data "and a.data_estrazione between :f_data1 and  :f_data2"
} else {
    set where_data ""
}

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "Stampa riepilogo appuntamenti"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set titolo       "Stampa riepilogo appuntamenti"
set button_label "Stampa"
set page_title   "Stampa riepilogo appuntamenti"
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
set testata2 " <!-- FOOTER LEFT   \"$sysdate_edit\"-->
               <!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->
               <table width=100%>
               <tr><td width=100% align=center>
                    <table><tr>
                       <td align=center><b>$ente</b></td>
                    </tr><tr>
                       <td align=center>$ufficio</td>
                    </tr><tr>
                       <td align=center>$assessorato</td>
                    </tr><tr>
                       <td align=center><small>$indirizzo_ufficio</small></td>
                    </tr><tr><td align=center><small>$telefono_ufficio</small></td>
                    </tr></td></table></tr></table> 
"
set testata "<blockquote>"

append stampa "<p align=center><big>Riepilogo appuntamenti su impianti termici</p></big>"

append stampa "</font>"
if {![string equal $f_cod_comune ""]
||  ![string equal $f_data1 ""]
||  ![string equal $f_data2 ""]
} {
    append stampa "<br>Selezione per"

    if {![string equal $f_campagna ""]} {
	db_1row get_campagna ""
	append stampa "<br>Campagna: $des_campagna"
    }
    if {![string equal $f_cod_comune ""]} {
        db_1row get_comu ""
        append stampa "<br>Comune: $des_comu"
    }
    if {![string equal $f_data1 ""]
    ||  ![string equal $f_data2 ""]
    } {
	db_1row edit_date_dual ""

        append stampa "<br>Data estrazione compresa tra $data1e e $data2e"
    }
    append stampa "<br>"
}
# Costruisco descrittivi tabella
append stampa "<table border=1 class=table_s>";#but01

set inizio "S"
set conta 0

#ric01 modificata label
#ric01 <th align=left>Controlli su imp. < 35kW con mod H scaduta</th>
 append stampa "
	  <tr>
	  <th align=left>Controlli su imp. < 35kW dichiarati</th>
          <th align=left>Controlli su imp. < 35kW con RCEE scaduto</th> <!-- ric01 -->
          <th align=left>Controlli su imp. > 35kW dichiarati</th>
          <th align=left>Controlli su imp. non dichiarati</th>
          <th align=left>Controlli su imp. da accatastare</th>
          <th align=left>Controlli estratti singolarmente</th>
          <th align=left>Tot.</th>
          <th align=left>Assegnati</th>
          <th align=left>Effettuati</th>
	  <th align=left>Annullati</th>
	  <th align=left>Altri</th>
	  <th align=left>Con esito negativo</th>
          </tr>
	  "
set conta_tipo_estr1 0
set conta_tipo_estr2 0
set conta_tipo_estr3 0
set conta_tipo_estr4 0
set conta_tipo_estr5 0
set conta_tipo_estr6 0
set conta_stato2 0
set conta_stato8 0
set conta_stato5 0
set conta_stato_a 0
set conta_esitoneg 0
set comu ""
set conta_comu 1
set conta_contr 0

db_foreach get_inco "" {
      if {$conta_contr == 0} {
          set comu $comune
      } 
      if {$comu == $comune} {
          incr conta_contr
          incr conta_comu
	  switch $tipo_estrazione {
	      "1" {incr conta_tipo_estr1}
	      "2" {incr conta_tipo_estr2}
	      "3" {incr conta_tipo_estr3}
	      "4" {incr conta_tipo_estr4}
	      "5" {incr conta_tipo_estr5}
	      "6" {incr conta_tipo_estr6}
	  }  
	  if {$esito == "N"} {
	      incr conta_esitoneg
	  }
	  switch $stato {
	      "2" {incr conta_stato2}
	      "8" {incr conta_stato8}
	      "5" {incr conta_stato5}
	      default {incr conta_stato_a}
	  }
	  
      } else {
	  
	  set totale [expr $conta_tipo_estr1 + $conta_tipo_estr2 + $conta_tipo_estr3 + $conta_tipo_estr4 + $conta_tipo_estr5 + $conta_tipo_estr6]
	  if {[string equal $f_cod_comune ""]} {
	      append stampa "
               <tr>
                   <th align=left colspan=10>Comune di $comu</th>
               </tr>"
	  }
	  append stampa "
	       <tr>
	       <td align=left>$conta_tipo_estr1</td>
               <td align=left>$conta_tipo_estr2</td>
               <td align=left>$conta_tipo_estr3</td>
               <td align=left>$conta_tipo_estr4</td>
               <td align=left>$conta_tipo_estr5</td>
               <td align=left>$conta_tipo_estr6</td>
               <td align=left>$totale</td>
               <td align=left>$conta_stato2</td>
               <td align=left>$conta_stato8</td>
	       <td align=left>$conta_stato5</td>
	       <td align=left>$conta_stato_a</td>
	       <td align=left>$conta_esitoneg</td>
               </tr>
	       "   
	  set conta_tipo_estr1 0
	  set conta_tipo_estr2 0
	  set conta_tipo_estr3 0
	  set conta_tipo_estr4 0
	  set conta_tipo_estr5 0
	  set conta_tipo_estr6 0
	  set conta_stato2 0
	  set conta_stato8 0
	  set conta_stato5 0
	  set conta_stato_a 0
	  set conta_esitoneg 0
          set comu $comune
	  set conta_comu 1

	  switch $tipo_estrazione {
	      "1" {incr conta_tipo_estr1}
	      "2" {incr conta_tipo_estr2}
	      "3" {incr conta_tipo_estr3}
	      "4" {incr conta_tipo_estr4}
	      "5" {incr conta_tipo_estr5}
	      "6" {incr conta_tipo_estr5}
	  }  
	  if {$esito == "N"} {
	      incr conta_esitoneg
	  }
	  switch $stato {
	      "2" {incr conta_stato2}
	      "8" {incr conta_stato8}
	      "5" {incr conta_stato5}
	      default {incr conta_stato_a}
	  }  
      }
}

if {$conta_contr != 0} {
    set totale [expr $conta_tipo_estr1 + $conta_tipo_estr2 + $conta_tipo_estr3 + $conta_tipo_estr4 + $conta_tipo_estr5 + $conta_tipo_estr6]
    
    if {[string equal $f_cod_comune ""]} {
	append stampa "
               <tr>
                   <th align=left colspan=10>Comune di $comu</th>
               </tr>"
    }
    append stampa "
      <tr>
          <td align=left>$conta_tipo_estr1</td>
          <td align=left>$conta_tipo_estr2</td>
          <td align=left>$conta_tipo_estr3</td>
          <td align=left>$conta_tipo_estr4</td>
          <td align=left>$conta_tipo_estr5</td>
          <td align=left>$conta_tipo_estr6</td>
          <td align=left>$totale</td>
          <td align=left>$conta_stato2</td>
          <td align=left>$conta_stato8</td>
	  <td align=left>$conta_stato5</td>
	  <td align=left>$conta_stato_a</td>
	  <td align=left>$conta_esitoneg</td>
     </tr>
     "   
} else {
    append stampa "<tr><th colspan=12 align= center>Non risultano dati corrispondenti al filtro impostato</th></tr>"
} 
db_1row estrai_data ""

append stampa "</table>"

set stampa1 $testata
append stampa1 $stampa

set stampa2 $testata2
append stampa2 "<small>"
append stampa2 $stampa
append stampa2 "</small>"

# creo file temporaneo html

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa2
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer D / --quiet --landscape --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom  0cm -f $file_pdf $file_html]

ns_unlink $file_html
#ad_returnredirect $file_pdf_url
#ad_script_abort
ad_return_template
