ad_page_contract {

    @author          Paolo Formizzi Adhoc
    @creation-date   21/05/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimstin-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 31/10/2024 Aggiunto class=table_s nella tabella.

    rom02 28/02/2023 Paravan di UCit ha chiesto che venga aggiunta la targa. Modifica fatta valere per tutti
    rom02            gli enti che hanno attiva la gestione delle targhe.
    rom02bis         Paravan ha chiesto che venga estesa a tutta Regione Friuli una particolarita' presente per
    rom02bis         Udine e Gorizia: vengono estratti contemporaneamente gli impianti in stato SPEDITO e CONFERMATO

    rom01 03/02/2023 Corretti 2 errori presenti nella stampa: nella foreach degli incontri non
    rom01            veniva chiusa la riga html tra un record e l'altro e questo faceva uscire
    rom01            in modo scorretto la stampa formato pdf.
    rom01            Per Udine e Gorizia era presente un errore se gli appuntamenti da stampare
    rom01            si filtravano per stato Spedito o Confermato.

    san02 06/02/2018 Aggiunto descrizione della mancata ispezione

    san01 12/08/2016 Aggiunto campo data_ultim_dich
 
} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {cod_cinc         ""}
    {cod_enve         ""}
    {cod_opve         ""}
    {da_data_app      ""}
    {a_data_app       ""}
    {da_data_spe      ""}
    {a_data_spe       ""}
    {cod_comune       ""}
    {cod_area         ""}
    {f_cod_noin       ""}
    {flag_stato_appuntamento ""}
    {flag_tipo_impianto ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set link_filter [export_ns_set_vars url]
set cd_tecn  [iter_check_uten_opve $id_utente]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set titolo       "Stampa elenco appuntamenti"
set page_title   "Stampa elenco appuntamenti"

set context_bar  [iter_context_bar -nome_funz $nome_funz]

# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]


iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)

iter_get_coimdesc
set nome_ente    $coimdesc(nome_ente)
set tipo_ufficio $coimdesc(tipo_ufficio)
set assessorato  $coimdesc(assessorato)
set indirizzo    $coimdesc(indirizzo)
set telefono     $coimdesc(telefono)
set resp_uff     $coimdesc(resp_uff)
set uff_info     $coimdesc(uff_info)
set dirigente    $coimdesc(dirigente)

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file_csv "elenco_appuntamenti"
# 26/11/2013 la proc iter_temp_file_name va chiamata senza lo switch -permanenti perchè
# 26/11/2013 altrimenti non viene creata la sottodirectory con la data nella directory spool
# 26/11/2013 e la open del primo file va in errore perchè non esiste la directory
# 26/11/2013 set nome_file_csv [iter_temp_file_name -permanenti $nome_file_csv]
set nome_file_csv [iter_temp_file_name $nome_file_csv];#26/11/2013

set file_csv_name "$spool_dir/$nome_file_csv.csv"
set file_csv_url  "$spool_dir_url/$nome_file_csv.csv"
set file_html_csv "$spool_dir/$nome_file_csv.html"

set file_id  [open $file_html_csv w]
set file_csv [open $file_csv_name w]
fconfigure $file_id -encoding iso8859-1
fconfigure $file_csv -encoding iso8859-1

# Setto la prima riga del csv
#rom02
if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunta if e il suo contenuto
    puts $file_csv "Impianto;Targa;Responsabile;Ubicazione;Cap;Mun.;Comune;Data app.;Stato;Esito isp.;Note;Ora;Telefono;Coor. X Y;Pot.;Dich"
} else {#rom02 Aggiunta else ma non il suo contenuto
    puts $file_csv "Impianto;Responsabile;Ubicazione;Cap;Mun.;Comune;Data app.;Stato;Esito isp.;Note;Ora;Telefono;Coor. X Y;Pot.;Dich"
}

set testata "
<!-- FOOTER LEFT   \"$sysdate_edit\"-->
<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->
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
      <tr>
         <td align=center>&nbsp;</td>
      </tr>
</table>
<p align=center><big>Stampa elenco appuntamenti</big>"

set ctr 0

if {$flag_viario == "T"} {
    set sel_inco "sel_inco_si_viae"
} else {
    set sel_inco "sel_inco_no_viae"
}

set stampa ""

if {[db_0or1row sel_cinc ""] == 0} {
    iter_return_complaint "Campagna non trovata"
}

append stampa "della campagna $desc_cinc "

if {$coimtgen(ente) eq "PLI"} {
    set order_by " order by a.data_verifica, a.ora_verifica"
} elseif {$coimtgen(ente) eq "PFI"} {#Sandro 21/07/2014
    set order_by " order by g.denominazione, f.descr_estesa, lpad(d.numero,10, '0'), c.ragione_01, nome_opve, a.stato";#Sandro 21/07/2014
} else {
    # caso standard
    set order_by " order by a.data_verifica, a.ora_verifica, c.ragione_01, nome_opve, a.stato"
}

if {![string equal $cod_comune ""] && $flag_ente == "P"} {
    if {[db_0or1row sel_desc_comu ""] == 0} {
	iter_return_complaint "Comune non presente in anagrafica"
    } else {
	append stampa "nel comune $desc_comune "
    }
    set where_comune "and d.cod_comune = :cod_comune "
} else {
    set where_comune ""
}
if {![string equal $cod_enve ""]} {
    if {[db_0or1row sel_enve ""] == 0} {
	iter_return_complaint "Ente verificatore non trovato"
    }
    append stampa "dell'ente verificatore $ragione_01 "
    set flag_enve "S"
} else {
    set flag_enve "N"
}

if {![string equal $cod_opve ""]} {
    if {[db_0or1row sel_opve ""] == 0} {
	iter_return_complaint "Ispettore non trovato"
    }
    if {[string equal $cod_enve ""]} {
	append stampa "dell'ente verificatore: $ragione_01 "
    }
    append stampa "dell'operatore $nome_opve "
    set flag_opve "S"
} else {
    set flag_opve "N"
}  

#rom02bis if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {}
if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom02bis Aggiunta if ma non il suo contenuto
    set where_stato ""
    if {![string equal $flag_stato_appuntamento ""]} {
        if {$flag_stato_appuntamento eq "3" || $flag_stato_appuntamento eq "4"} {
            #rom01set where_stato " and a.stato in (3, 4)"
            set where_stato " and a.stato in ('3', '4')";#rom01 il campo stato e' un varchar quindi devo usare gli apici
        } else {
	    set where_stato " and a.stato = :flag_stato_appuntamento"
        }
        db_1row sel_desc_stato  ""
        append stampa "in stato $desc_stato "
    }
} else {
    if {![string equal $flag_stato_appuntamento ""]} {
	set where_stato " and a.stato = :flag_stato_appuntamento"       
    } else {
	set where_stato ""
    }
}



if {![string equal $cod_area ""]} {
    set where_area "  left outer join coimcmar i on i.cod_comune    = g.cod_comune
                                  and i.cod_area = :cod_area"
} else {
    set where_area ""
}

if {![string equal $f_cod_noin ""]} {
    set where_noin " and a.cod_noin   = :f_cod_noin"
  } else {
    set where_noin ""
}

#dpr74
if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp  "and d.flag_tipo_impianto = :flag_tipo_impianto"
} else {
set where_tipo_imp ""
}


set where_data_app ""
set da_data_app_edit [iter_edit_date $da_data_app]
set a_data_app_edit  [iter_edit_date $a_data_app]

if {![string equal $da_data_app ""] &&  [string equal $a_data_app ""]} {
    append stampa "con data appuntamento Dal $da_data_app_edit "
    set where_data_app " and a.data_verifica >= :da_data_app"
}

if { [string equal $da_data_app ""] && ![string equal $a_data_app ""]} {
    append stampa "con data appuntamento fino a $a_data_app_edit "
    set where_data_app " and a.data_verifica <= :a_data_app"
}

if {![string equal $da_data_app ""] && ![string equal $a_data_app ""]} {
    append stampa "con data appuntamento compresa tra $da_data_app_edit e $a_data_app_edit "
    set where_data_app " and a.data_verifica between :da_data_app and :a_data_app"
}

set where_data_spe ""
set da_data_spe_edit [iter_edit_date $da_data_spe]
set a_data_spe_edit  [iter_edit_date $a_data_spe]

if {![string equal $da_data_spe ""] && [string equal $a_data_spe ""]} {
    append stampa "con data spedizione Dal $da_data_spe_edit "
    set where_data_spe " and a.data_avviso_01 >= :da_data_spe"
}

if { [string equal $da_data_spe ""] && ![string equal $a_data_spe ""]} {
    append stampa "con data spedizione fino a $a_data_spe_edit "
    set where_data_spe " and a.data_avviso_01 <= :a_data_spe"
} 

if {![string equal $da_data_spe ""] && ![string equal $a_data_spe ""]} {
    append stampa "con data spedizione compresa tra $da_data_spe_edit e $a_data_spe_edit "
    set where_data_spe " and a.data_avviso_01 between :da_data_spe and :a_data_spe"
}

append stampa "
</td></tr>
<tr>
   <td>&nbsp;</td>
</tr>
</table>
<table width=100% align=center border=1 cellspacing=0 celpadding=0 class=table_s>";#but01

if {$flag_enve == "S"} {
    set enve_join_pos "inner join"
    set enve_join_ora ""
    set where_enve    " and c.cod_enve = :cod_enve"
    if {$flag_opve == "N"} {
	#rom02set n_colspan 10
	set n_colspan 13;#rom02
	append stampa "
       <tr>
          <td><b>Oper.verif.   </b></td>
          <td><b>Impianto      </b></td>"
	if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunte if, else e il loro contenuto
	    append stampa "<td><b>Targa      </b></td>"
	    incr n_colspan
	}       
        append stampa "
          <td><b>Responsabile  </b></td>
          <td><b>Ubic. N/E/S/P/I </b></td>
          <td><b>Cap          </b></td>"
       if {$flag_ente == "C"} {
         append stampa "<td><b>Mun.</b></td>"
           incr n_colspan
	}
 	if {$flag_ente == "P"} {
	    append stampa "<td><b>Comune</b></td>"
	    incr n_colspan
	}
	append stampa "
          <td><b>Data app.</b></td>
          <td><b>Ora</b></td>
          <td><b>Stato</b></td>
          <td><b>Esito ispezione</b></td>
          <td><b>Note</b></td>
          <td><b>Telefono</b></td>
          <td><b>Pot.</b></td>
          <td><b>Dich.S/N</b></td>
       </tr>"
    }
} else {
    set enve_join_pos "left outer join"
    set enve_join_ora "(+)"
    set where_enve ""
}

if {$flag_opve == "S"} {
    set opve_join_pos "inner join"
    set opve_join_ora ""
    set where_opve " and a.cod_opve = :cod_opve"
    #rom02set n_colspan 10
    set n_colspan 13;#rom02
    append stampa "
    <tr>
       <th>Impianto      </th>"
    if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunte if, else e il loro contenuto
	append stampa "<th>Targa</th>"
	incr n_colspan
    }       
    append stampa "
       <th>Responsabile  </th>
       <th>Ubic. N/E/S/P/I </th>
       <th>Cap          </th>"
         if {$flag_ente == "C"} {
           append stampa "<th>Mun.</th>"
           incr n_colspan
	}

    if {$flag_ente == "P"} {
	append stampa "<th>Comune</th>"
	incr n_colspan
    }
    append stampa "
       <th>Data app.</th>
       <th><b>Ora</b></th>
       <th><b>Stato</b></th>
       <th>Esito isp.</th>
       <th><b>Note</b></th>
       <th><b>Telefono</b></th>
       <th><b>Coor. X Y</b></th>
       <th><b>Pot.</b></th>
       <th><b>Dich.S/N</b></th>
    </tr>"
} else {
    set opve_join_pos "left outer join"
    set opve_join_ora "(+)"
    set where_opve ""
}

if {$flag_enve == "N" && $flag_opve == "N"} {
    #rom02set n_colspan 11
    set n_colspan 14;#rom02
    append stampa "
    <tr>
       <th>Ente verif.   </th>
       <th>Oper.verif.   </th>
       <th>Impianto      </th>" 
    if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunte if, else e il loro contenuto
	append stampa "<th>Targa</th>"
	incr n_colspan
    }       
    append stampa "
       <th>Responsabile  </th>
       <th>Ubic. N/E/S/P/I </th>
        <th>Cap          </th>"
    if {$flag_ente == "C"} {
	append stampa "<th>Mun.</th>"
	incr n_colspan
    }
    if {$flag_ente == "P"} {
	append stampa "<th>Comune</th>"
	incr n_colspan
    }
    append stampa "
       <th>Data app.</th>
       <th><b>Ora</b></th>
       <th>Stato</th>
       <th>Esito isp.</th>
       <th>Note</th>
        <th><b>Telefono</b></th>
       <th><b>Pot.</b></th>
       <th><b>Dic.</b></th>
    </tr>"
}

set conta_inco 0
set sw_primo_rec "t"

db_foreach $sel_inco "" {

    incr conta_inco
    if {[string is space $ragione_01]} {
	set ragione_01 "&nbsp;"
	set ragione_01_csv ""
    } else {
	set ragione_01_csv "$ragione_01"
    }
    if {[string is space $nome_opve]} {
	set nome_opve  "&nbsp;"
	set nome_opve_csv ""
    } else {
	set nome_opve_csv "$nome_opve"
    }
    
    if {[string is space $targa]} {#rom02 Aggiunte if, else e il loro contenuto
	set targa "&nbsp;"
	set targa_csv ""
    } else {
	 set targa_csv "$targa"
    }

    if {[string is space $nome_resp]} {
	set nome_resp "&nbsp;"
	set nome_resp_csv ""
    } else {
	set nome_resp_csv "$nome_resp"
    }
    if {[string is space $indir]} {
	set indir "&nbsp;"
	set indir_csv ""
    } else {
	set indir_csv "$indir"
    }
    if {$flag_enve == "S" && $flag_opve == "N"} {
	append stampa "
        <tr>
           <td>$nome_opve</td>"
    }

    if {$flag_opve == "S"} {
	append stampa "<tr>"
    }

    if {$flag_enve == "N" && $flag_opve == "N"} {
	append stampa "
        <tr>
           <td>$ragione_01</td>
           <td>$nome_opve</td>"
    }

    append stampa "
           <td align=right>$cod_impianto_est</td>"

    if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunte if, else e il loro contenuto
        append stampa "<td align=right>$targa</td>"
    }
    append stampa "
           <td>$nome_resp</td>
           <td>$indir</td>
           <td>$cap</td>"
    if {$flag_ente == "C"} {
	append stampa "<td>$cod_qua</td>"
    }
    if {$flag_ente == "P"} {
	append stampa "<td>$denom_comune</td>"
    }
    
    if {$cod_noin ne ""} {
	db_1row query "select descr_noin from coimnoin where cod_noin = :cod_noin"
	append note " - $descr_noin"
	regsub -all {\r\n} $note "\n" note
	regsub -all \n     $note " "  note
	regsub -all \r     $note " "  note
	regsub -all {\s}   $note " "  note
	regsub -all \"     $note " "  note
       
    
  	append note_csv " - $descr_noin"
	regsub -all {\r\n} $note_csv "\n" note_csv
	regsub -all \n     $note_csv " "  note_csv
	regsub -all \r     $note_csv " "  note_csv
     	regsub -all {\s}   $note_csv " "  note_csv
	regsub -all \"     $note_csv " "  note_csv
    }

    if {$stato eq "8" || $stato eq "5" } {#san02 if e suo contenuto
        set descr_noin ""
	if {[db_0or1row query_noin "select descr_noin 
                                      from coimnoin a
                                         , coimcimp b  
                                     where b.cod_inco = :cod_inco 
                                       and a.cod_noin = b.cod_noin 
                                       and b.cod_noin is not null order by cod_inco desc limit 1" ] == 1} {
	    append note " - Mancata Ispezione :$descr_noin" 
	    regsub -all {\r\n} $note "\n" note
	    regsub -all \n     $note " "  note
	    regsub -all \r     $note " "  note
	    regsub -all {\s}   $note " "  note
	    regsub -all \"     $note " "  note 
	    	    
	    append note_csv " - Mancata Ispezione :$descr_noin"
	    regsub -all {\r\n} $note_csv "\n" note_csv
	    regsub -all \n     $note_csv " "  note_csv
	    regsub -all \r     $note_csv " "  note_csv
	    regsub -all {\s}   $note_csv " "  note_csv
	    regsub -all \"     $note_csv " "  note_csv 
        } else {
	    set  descr_noin ""
        }
    }
    
    if {$desc_notifica ne ""} {
	append note " - $desc_notifica"
    }
    
    append stampa " 
           <td>$data_verifica</td>
           <td>$ora_verifica</td>
           <td>$stato_inco</td>
           <td>$desc_esito</td>
           <td>$note</td>
           <td>$telefono<br>$cellulare</td>"
    if {$flag_opve == "S"} {
	append stampa "<td>$gb</td>"
    }
    
    append stampa " 
      <td>$potenza_csv</td>
      <td>$flag_dichiarato_csv - $data_ultim_dich</td></tr>"

if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunta if e il suo contenuto
    puts $file_csv "$cod_impianto_est;$targa_csv;$nome_resp_csv;$indir_csv;$cap_csv;$cod_qua_csv;$denom_comune_csv;$data_verifica_csv;$stato_inco;$desc_esito_csv;\"$note_csv\";$ora_verifica_csv;$telefono_csv;$gb_csv;$potenza_csv;$flag_dichiarato_csv - $data_ultim_dich"
} else {#rom02 Aggiunta else ma non il suo contenuto
    puts $file_csv "$cod_impianto_est;$nome_resp_csv;$indir_csv;$cap_csv;$cod_qua_csv;$denom_comune_csv;$data_verifica_csv;$stato_inco;$desc_esito_csv;\"$note_csv\";$ora_verifica_csv;$telefono_csv;$gb_csv;$potenza_csv;$flag_dichiarato_csv - $data_ultim_dich"
}

    append stampa "</tr>";#rom01

} if_no_rows {
    if {$flag_enve == "S" && $flag_opve == "N"} {
	append stampa "
        <tr>
           <td colspan=$n_colspan align=center><b>Nessun appuntamento selezionato</b></td>
        </tr>"
    }
    if {$flag_opve == "S"} {
	append stampa "
        <tr>
           <td colspan=$n_colspan align=center><b>Nessun appuntamento selezionato</b></td>
        </tr>"
    }
    if {$flag_enve == "N" && $flag_opve == "N"} {
	append stampa "
        <tr>
           <td colspan=$n_colspan align=center><b>Nessun appuntamento selezionato</b></td>
        </tr>"
    }
}
append stampa "</table>"

if {$conta_inco > 0} {
    set conta_inco [iter_edit_num $conta_inco]
    set conta "
    <br>
    <table width=100%><tr>
    <th align=center>Elenco di $conta_inco appuntamenti "
} else {
    set conta "
    <br>
    <table width=100%><tr>
    <th align=center>Nessun appuntamento "
}

set stampa_tot $testata
append stampa_tot  $conta 
append stampa_tot $stampa
set stampa $stampa_tot

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file    "stampa statistiche incontri-appuntamenti"
set nome_file    [iter_temp_file_name $nome_file]
set file_html    "$spool_dir/$nome_file.html"
set file_pdf     "$spool_dir/$nome_file.pdf"
set file_pdf_url "$spool_dir_url/$nome_file.pdf"

set file_id   [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts $file_id $stampa
close $file_id

# lo trasformo in PDF
# Sandro 22/01/2016: messo portrait al posto di landscape
# simone 17/07/2017: concordato con Sandro di rimettere landscape al posto di portrait
if {$coimtgen(flag_gest_targa) eq "T"} {#rom02 Aggiunte if, else e il loro contenuto
    set font_size 6
} else {
    set font_size 8
}

iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --fontsize $font_size --left 0.5cm --right 0.5cm --top 0cm --bottom 0.5cm -f $file_pdf $file_html]

ad_return_template
