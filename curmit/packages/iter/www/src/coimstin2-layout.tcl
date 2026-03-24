ad_page_contract {

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 31/10/2024 Aggiunto class=table_s nella tabella.
    
    san01 21/07/2016 Aggiunto filtro obbligatorio da_data_ins e a_data_ins e rimossa
    san01            obbligatorieta' dal filtro da_data_app e a_data_app come concordato
    san01            con l'Agenzia Fiorentina per l'Energia.

} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {da_data_app      ""}
    {a_data_app       ""}
    {cod_comune       ""}
    {cod_manutentore  ""}
    {prescr  ""}
    {osserv  ""}
    {raccom  ""}
    {funzionare  ""}
    {flag_tipo_impianto  ""}
    {da_data_ins      ""}
    {a_data_ins       ""}
} 

set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#set id_utente "sandro"
# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set link_filter [export_ns_set_vars url]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set page_title   "Selezione allegati per stampa delle note"

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
<p align=center><big>Elenco modelli con osservazioni/raccomandazioni/prescrizioni</big>
"

set ctr 0

set stampa ""


set order_by "order by a.data_controllo, a.ora_inizio"


if {![string equal $cod_comune ""]} {
    if {[db_0or1row sel_desc_comu "select denominazione as desc_comune from coimcomu where cod_comune = :cod_comune"] == 0} {
	iter_return_complaint "Comune non presente in anagrafica"
    } else {
	append stampa "<br>nel comune $desc_comune "
    }
    set where_comune "and d.cod_comune = :cod_comune "
} else {
    set where_comune ""
}

if {![string equal $cod_manutentore ""]} {
    set where_manutentore " and a.cod_manutentore = :cod_manutentore"
    
    if {[db_0or1row sel_manutentore "select cognome as manutentore from coimmanu where cod_manutentore = :cod_manutentore"] == 0} {
	iter_return_complaint "Manutentore non presente in anagrafica"
    } else {
	append stampa "<br>Manutentore $manutentore"
    }
    
} else {
    set where_manutentore ""
}



set where_data_app ""
set da_data_app_edit [iter_edit_date $da_data_app]
set a_data_app_edit  [iter_edit_date $a_data_app]

if {![string equal $da_data_app ""]
&&   [string equal $a_data_app ""]
} {
    append stampa "<br> con data controllo dal $da_data_app_edit "
    set where_data_app " and a.data_controllo >= :da_data_app"
}

if { [string equal $da_data_app ""]
&&  ![string equal $a_data_app ""]
} {
    append stampa "<br> con data controllo fino a $a_data_app_edit "
    set where_data_app " and a.data_controllo <= :a_data_app"
} 

if {![string equal $da_data_app ""]
&&  ![string equal $a_data_app ""]
} {
    append stampa "<br> con data controllo compresa tra $da_data_app_edit e $a_data_app_edit "
    set where_data_app " and a.data_controllo between :da_data_app and :a_data_app"
}


set where_data_ins "";#san01
set da_data_ins_edit [iter_edit_date $da_data_ins];#san01
set a_data_ins_edit  [iter_edit_date $a_data_ins];#san01

if {![string equal $da_data_ins ""]
&&   [string equal $a_data_ins ""]
} {#san01: aggiunta if e suo contenuto
    append stampa "<br> con data inserimento dal $da_data_ins_edit "
    set where_data_ins " and a.data_ins >= :da_data_ins"
}

if { [string equal $da_data_ins ""]
&&  ![string equal $a_data_ins ""]
} {#san01: aggiunta if e suo contenuto
    append stampa "<br> con data inserimento fino a $a_data_ins_edit "
    set where_data_ins " and a.data_ins <= :a_data_ins"
} 

if {![string equal $da_data_ins ""]
&&  ![string equal $a_data_ins ""]
} {#san01: aggiunta if e suo contenuto
    append stampa "<br> con data inserimento compresa tra $da_data_ins_edit e $a_data_ins_edit "
    set where_data_ins " and a.data_ins between :da_data_ins and :a_data_ins"
}


set where_prescr ""
if {[string equal $prescr "S"]} {
    append stampa "<br>Solo modelli con prescrizioni "
    set where_prescr " and trim(a.prescrizioni) is not null"
}
if {[string equal $prescr "N"]} {
    append stampa "<br>Solo modelli senza prescrizioni "
    set where_prescr " and trim(a.prescrizioni) is null"
}

set where_osserv ""
if {[string equal $osserv "S"]} {
    append stampa "<br>Solo modelli con osservazioni "
    set where_osserv " and trim(a.osservazioni) is not null"
}
if {[string equal $osserv "N"]} {
    append stampa "<br>Solo modelli senza osservazioni "
    set where_osserv " and trim(a.osservazioni) is null"
}


set where_raccom ""
if {[string equal $raccom "S"]} {
    append stampa "<br>Solo modelli con raccomandazioni "
    set where_raccom " and trim(a.raccomandazioni) is not null"
}
if {[string equal $raccom "N"]} {
    append stampa "<br>Solo modelli senza raccomandazioni "
    set where_raccom " and trim(a.raccomandazioni) is null"
}

set where_funzionare ""
if {[string equal $funzionare "S"]} {
    append stampa "<br>Solo modelli con impianto puo' funzionare = S "
    set funzionare "P"
    set where_funzionare " and flag_status = :funzionare"
}
if {[string equal $funzionare "N"]} {
    append stampa "<br>Solo modelli con impianto puo' funzionare = N "
    set where_funzionare " and flag_status = :funzionare"
}

#dpr74

if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and d.flag_tipo_impianto = :flag_tipo_impianto"
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

append stampa " -$desc_tipo_impianto -"





append stampa "
</td></tr>
<tr>
   <td>&nbsp;</td>
</tr>
</table>
<table align=center border=1 cellspacing=0 celpadding=0 class=table_s>";#but01

append stampa "
       <tr>
          <th><b>Data controllo</b></th>
          <th><b>Manutentore   </b></th>
          <th><b>Impianto      </b></th>
          <th><b>Responsabile  </b></th>
          <th><b>Ubicazione    </b></th>
	  <th><b>Comune        </b></th>
          <th><b>Cap           </b></th>
          <th><b>Tiraggio      </b></th>
          <th><b>CO            </b></th>
          <th><b>Rend.         </b></th>
          <th><b>Prescr/Osserv/Raccom/Funz(S/N) </b></th>
       </tr>"

db_foreach sel_dimp "select coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
     , coalesce(a.ora_inizio,'&nbsp;') as ora_inizio
     , coalesce(a.ora_fine,'&nbsp;') as ora_fine
     , coalesce(coalesce(b.cognome,'')||' '||coalesce(b.nome,''),'&nbsp;') as manutentore
     , coalesce(d.cod_impianto_est, '&nbsp;') as cod_impianto_est
     , coalesce(d.cap, '&nbsp;') as cap
     , flag_tipo_impianto
     , e.cognome||' '||coalesce(e.nome,'') as nome_resp
     , coalesce(f.descr_topo,'')||' '||coalesce(f.descr_estesa,'')||' '||coalesce(d.numero,'')||' '||coalesce(d.esponente, '') as indir
     , coalesce(g.denominazione,'&nbsp;') as denom_comune
     , coalesce(iter_edit_num(a.tiraggio, 2),'&nbsp;') as tiraggio
     , coalesce(iter_edit_num(a.co, 4),'&nbsp;') as co
     , coalesce(iter_edit_num(a.rend_combust, 2),'&nbsp;') as rend_combust
     , 'Presc.: ' || coalesce(a.prescrizioni,' - ') || ' Osserv.: ' || coalesce(a.osservazioni,' - ') || ' Raccom. : ' || coalesce(a.raccomandazioni,'-') || ' Può Funz. : ' || coalesce(( case a.flag_status 
       when 'P' then 'S'
       when 'N' then 'N'
       else '&nbsp;'
       end),'-')as note
  from coimdimp a
       inner join coimaimp d on d.cod_impianto = a.cod_impianto
                             $where_comune
                             $where_tipo_imp
  left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
  left outer join coimcitt e on e.cod_cittadino = d.cod_responsabile
  left outer join coimviae f on f.cod_via       = d.cod_via
                            and f.cod_comune    = d.cod_comune
  left outer join coimcomu g on g.cod_comune    = d.cod_comune
 where 1 = 1
 $where_manutentore
 $where_raccom
 $where_osserv
 $where_prescr
 $where_data_app
 $where_data_ins -- san01
 $where_funzionare
 $order_by
" {

    append stampa "
       <tr>
           <td>$data_controllo</td>
           <td>$manutentore</td>
           <td>$cod_impianto_est</td>
           <td>$nome_resp</td>
           <td>$indir</td>
           <td>$denom_comune</td>
           <td>$cap</td>
           <td>$tiraggio</td>
           <td>$co</td>
           <td>$rend_combust</td>
           <td>$note</td>
        </tr>"

} if_no_rows {
    append stampa "
        <tr>
           <td colspan = 10 align=center><b>Nessun dato selezionato</b></td>
        </tr>
        "
}


append stampa "</table>"



set stampa_tot $testata

append stampa_tot $stampa
set stampa $stampa_tot

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "Stampa modelli controllo prescrizioni"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set file_id   [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts $file_id $stampa
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --landscape --bodyfont arial --fontsize 11 --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

ad_return_template
