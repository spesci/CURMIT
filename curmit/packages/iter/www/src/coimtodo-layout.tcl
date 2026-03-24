ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   11/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl     

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    rom02 20/06/2025 Ricevo e gestisco il campo f_enve che ha preso il posto di f_rgen.

    but01 31/10/2024 Aggiunto class=table_s nella tabella.
    
    rom01 25/01/2022 Su segnalazione di Regione Marche se l'ente che fa lestrazione csv  e' una
    rom01            Provincia, allora deve esserci anche la colonna Comune nel file csv.

} {
    {f_cod_comune       ""}
    {f_tipologia        ""}
    {f_evaso            ""}
    {f_data_evas_da     ""}
    {f_data_evas_a      ""}
    {f_data_controllo_da ""}
    {f_data_controllo_a  ""}
    {f_potenza_da       ""}
    {f_potenza_a        ""}
    {f_cod_combustibile ""}
    {f_cod_tpim         ""}
    {f_rgen             ""}
    {f_enve             ""}
    {flag_tipo_impianto ""}
    {caller        "index"}
    {funzione          "V"}
    {nome_funz          ""}
    {nome_funz_caller   ""}   
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

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

if {![string equal $f_cod_comune ""]} {
    set where_comune "and b.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

if {![string equal $f_tipologia ""]} {
    set where_tipologia "and a.tipologia = :f_tipologia"
} else {
    set where_tipologia ""
}


if {![string equal $f_evaso ""]} {
    set where_evasione "and a.flag_evasione = :f_evaso"
} else {
    set where_evasione ""
}

if {![string equal $f_data_evas_da ""] 
||  ![string equal $f_data_evas_a  ""]
} {
    if {[string equal $f_data_evas_da ""]} {
	set f_data_evas_da "18000101"
    }
    if {[string equal $f_data_evas_a ""]} {
	set f_data_evas_a "21001231"
    }
    set where_data "and a.data_evasione between :f_data_evas_da and :f_data_evas_a"
} else {
    set where_data ""
}


if {![string equal $f_data_controllo_da ""] || ![string equal $f_data_controllo_a  ""]} {
    if {[string equal $f_data_controllo_da ""]} {
	set f_data_controllo_da "18000101"
    }
    if {[string equal $f_data_controllo_a ""]} {
	set f_data_controllo_a "21001231"
    }
    #set where_data_controllo "and m.data_controllo between :f_data_controllo_da and :f_data_controllo_a"
    set where_data_controllo "and a.data_evento between :f_data_controllo_da and :f_data_controllo_a"
} else {
    set where_data_controllo ""
}

if {![string equal $f_potenza_da ""] 
||  ![string equal $f_potenza_a  ""]
} {
    if {[string equal $f_potenza_da ""]} {
	set f_potenza_da 0.00
    }
    if {[string equal $f_potenza_a ""]} {
	set f_potenza_a 9999999.99
    }
    set where_potenza "and b.potenza between :f_potenza_da and :f_potenza_a"

} else {
    set where_potenza ""
}

if {![string equal $f_cod_combustibile ""]} {
    set where_comb "and b.cod_combustibile = :f_cod_combustibile"
} else {
    set where_comb ""
}

if {![string equal $f_cod_tpim ""]} {
    set where_tpim "and b.cod_tpim = :f_cod_tpim"
} else {
    set where_tpim ""
}

if {![string equal $f_rgen ""]} {
    set where_rgen "and l.cod_rgen = :f_rgen"
} else {
    set where_rgen ""
}

if {![string equal $f_enve ""]} {#rom02 Aggiunta if e contenuto
    set where_enve "and p.cod_enve = :f_enve"
} else {
    set where_enve ""
}

#dpr74
if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and b.flag_tipo_impianto = :flag_tipo_impianto"
} else {
    set where_tipo_imp ""
}
#dpr74 fine

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "stampa attivita sospese"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"


set titolo       "Stampa attivit&agrave; sospese"
set button_label "Stampa"
set page_title   "Stampa attivit&agrave; sospese"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 
 
set stampa ""

# imposto il nome dei file
set nome_file_csv "attivita_sospese"
set nome_file     [iter_temp_file_name $nome_file_csv]
set file_csv_name "$spool_dir/$nome_file_csv.csv"
set file_csv_url  "$spool_dir_url/$nome_file_csv.csv"
set file_html_csv "$spool_dir/$nome_file_csv.html"

set file_id  [open $file_html_csv w]
set file_csv [open $file_csv_name w]
fconfigure $file_id -encoding iso8859-1
fconfigure $file_csv -encoding iso8859-1

set num 0
db_1row get_todo_si_vie_num ""


# Setto la prima riga del csv
if {[string equal $coimtgen(flag_ente) "C"]} {#rom01 Aggiunta if ma non il suo contenuto
    puts $file_csv "TI;Data Verbale;Num.Verbale;Responsabile;Indirizzo Resp.;Cod.impianto;Ubicazione;Tipologia;Dt.Scad.Anomalia;DataControllo;Note"
} else {#rom01 Aggiunta else e il suo contenuto

    puts $file_csv "TI;Data Verbale;Num.Verbale;Responsabile;Indirizzo Resp.;Cod.impianto;Comune;Ubicazione;Tipologia;Dt.Scad.Anomalia;DataControllo;Note"
}

iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)
# Titolo della stampa
set testata2 "<!-- FOOTER LEFT   \"$sysdate_edit\"-->
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
                  </table></tr></table> 
"
set testata "<blockquote>"

append stampa "<p align=center><big>Elenco Attivit&agrave; sospese</p></big>"
append stampa "<p align=center><big>Numero impianti: $num</p></big>"
append stampa "</font>"

if {![string equal $f_tipologia ""]} {
    set th_tipologia "<th align=left width=15%>Tipologia</th>"
    set n1 "8%"
    set n2 "12%"
    set n3 "25%"
    set n4 "25%"
    set n5 "30%"  
    set colspan 5
} else {
    set th_tipologia "<th align=left width=15%>Tipologia</th>"
    set n1 "10%"
    set n2 "10%"
    set n3 "25%"
    set n4 "25%"
    set n5 "25%" 
    set colspan 6
}

if {![string equal $f_cod_comune   ""]
    ||  ![string equal $f_tipologia    ""]
    ||  ![string equal $f_evaso        ""]
    ||  ![string equal $f_data_evas_da ""]
    ||  ![string equal $f_data_evas_a  ""]
    ||  ![string equal $f_data_controllo_da ""]
    ||  ![string equal $f_data_controllo_a  ""]
    ||  ![string equal $f_potenza_da   ""]
    ||  ![string equal $f_potenza_a    ""]
    ||  ![string equal $f_cod_combustibile ""]
    ||  ![string equal $f_cod_tpim     ""]
} {
       if {![string equal $f_cod_comune ""]} {
	if {[db_0or1row sel_desc_comu ""] == 0} {
	    set desc_comu "/"
	}
        append stampa "<br>Comune: $desc_comu"

    }
    
    if {![string equal $f_evaso ""]} {
	switch $f_evaso {
	    "E" {append stampa "<br>Attivit&agrave; evase;"}
	    "N" {append stampa "<br>Attivit&agrave; non evase"}
	    "A" {append stampa "<br>Attivit&agrave; annullate"}
	}
    }

    if {![string equal $f_data_evas_da ""]
    ||  ![string equal $f_data_evas_a  ""]
    } {
	db_1row edit_date_dual ""
        append stampa "&nbsp;- Data evasione compresa tra $data_evas_da_ed e $data_evas_a_ed"
    }
    if {![string equal $f_data_controllo_da ""] || ![string equal $f_data_controllo_a  ""]} {
	db_1row query "select iter_edit_data(:f_data_controllo_da) as data_controllo_da_ed
                            , iter_edit_data(:f_data_controllo_a) as data_controllo_a_ed"
        append stampa "<br>Data controllo compresa tra $data_controllo_da_ed e $data_controllo_a_ed"
    }

    if {![string equal $f_potenza_da   ""]
    ||  ![string equal $f_potenza_a    ""]
    } {
	db_1row edit_num_dual ""
	append stampa "<br>Potenza impianto compresa tra $potenza_da_ed e $potenza_a_ed;"
    }

    if {![string equal $f_cod_combustibile ""]} {
	db_1row get_desc_comb ""
	append stampa "<br>Combustibile impianto: $descr_comb;"
    }

    if {![string equal $f_cod_tpim       ""]} {
	db_1row get_desc_tpim ""
	append stampa "<br>Tipo impianto: $descr_tpim;"
    }

    append stampa "<br>"
}

# Costruisco descrittivi tabella
append stampa "<table border=1 width=100% class=table_s><br>";#but01

set inizio "S"
set conta 0

append stampa "
	  <tr>
          <th align=left width=$n1>TI</th>
	  <th align=left width=$n1>Cod. impianto</th>
          <th align=left width=$n2>Indirizzo</th>
          <th align=left width=$n3>Responsabile</th>
          <th align=left width=$n4>Note</th>
          $th_tipologia
          </tr>
	  "

set comu ""
set conta_contr 0

if {$flag_viario == "T"} {
    set get_todo "get_todo_si_vie"
} else {
    set get_todo "get_todo_no_vie"
}

db_foreach $get_todo "" {

    if {![string equal $f_tipologia ""]} {
	set td_tipologia "<td align=left>$tipologia</td>"
    } else {
	set td_tipologia "<td align=left>$tipologia</td>"
    }
    if {$conta_contr == 0} {
	set comu $comune
	if {[string equal $f_cod_comune ""]} {
	    append stampa "
               <tr>
                   <th align=left colspan=$colspan>Comune di $comu</th>
               </tr>"
	}
    } 
    if {$comu == $comune} {
	incr conta_contr
	append stampa "
	      <tr>
              <td align=left>$flag_tipo_impianto</td>
	      <td align=left>$cod_imp</td>
              <td align=left>$indirizzo</td>
              <td align=left>$resp</td>
              <td align=left>$note</td>
              $td_tipologia
              </tr>
	      "	  
	  
    } else {
	set comu $comune
	set conta_comu 1

	if {[string equal $f_cod_comune ""]} {
	    append stampa "
               <tr>
                   <th align=left colspan=4>Comune di $comu</th>
               </tr>"
	}
	append stampa "
	      <tr>
              <td align=left>$flag_tipo_impianto</td>
	      <td align=left>$cod_imp</td>
              <td align=left>$indirizzo</td>
              <td align=left>$resp</td>
              <td align=left>$note</td>
              $td_tipologia
              </tr>
	      "	  
    }  
    regsub -all {\n} $note " " note
    regsub -all {\r} $note " " note
    
    if {[string equal $coimtgen(flag_ente) "C"]} {#rom01 Aggiunta if ma non il suo contenuto
	puts $file_csv "$flag_tipo_impianto;$data_verbale;$num_verbale;$resp;$indirizzo_resp;$cod_imp;$indirizzo;$tipologia;$data_scadenza;$data_controllo;\"$note\" "
    } else {#rom01 Aggiunta if e suo contenuto
	puts $file_csv "$flag_tipo_impianto;$data_verbale;$num_verbale;$resp;$indirizzo_resp;$cod_imp;$comune;$indirizzo;$tipologia;$data_scadenza;$data_controllo;\"$note\" "
    }
    
	

} if_no_rows {
    set testata ""
    set stampa "<table width=100%><tr><th colspan=5 align= center>Non risultano dati corrispondenti al filtro impostato</th></tr></table>"
}

db_1row estrai_data ""

append stampa "</table>"


set stampa1 $testata
append stampa1 $stampa

set stampa2 $testata2
append stampa2 "<small>"
append stampa2 $stampa
append stampa2 "</small>"

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa2
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --landscape  --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ns_unlink $file_html
#ad_returnredirect $file_pdf_url
#ad_script_abort
ad_return_template
