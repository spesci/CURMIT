ad_page_contract {
    Stampa RCEE Tipo 2 (gruppi frigo)
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coimdimp-layout.tcl
} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {cod_manutentore_old  ""}
    {cod_responsabile_old ""}
    {cognome_manu_old     ""}
    {nome_manu_old        ""}
    {cognome_resp_old     ""}
    {nome_resp_old        ""}
    {flag_ins             ""}
} -properties {
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

set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]

set link_tab      [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab      [iter_tab_form $cod_impianto]
set logo_dir      [iter_set_logo_dir]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_dimp caller nome_funz_caller nome_funz cod_impianto  url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set page_title       "Stampa RCEE"

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

#set data_contr $data_controllo

# Ricerca i parametri della testata
if {[db_0or1row sel_cod_gend ""] == 0} {
    set cod_gendd 0
}
iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_cind   $coimtgen(flag_cind)

if {$flag_viario == "T"} {
    set sel_dimp "sel_dimp_si_vie"
} else {
    set sel_dimp "sel_dimp_no_vie"
}

if {[db_0or1row $sel_dimp ""] == 0} {
    # codice non trovato
    iter_return_complaint  "Dati Impianto non trovati</li>"
    return
}

# dati impianto
if {[db_0or1row sel_aimp ""] == 0} {
    # codice non trovato
    #   iter_return_complaint  "Impianto non trovato"
    #   return
    set modello          ""
    set descrizione      ""
    set tipo_gen_foco    ""
    set tiraggio         ""
}

switch $flag_resp {
    "P" {set check_prop "<img src=$logo_dir/check-in.gif>"
	set check_occu "<img src=$logo_dir/check-out.gif>"
	set check_terz "<img src=$logo_dir/check-out.gif>"
	set check_ammi "<img src=$logo_dir/check-out.gif>"
	set check_inst "<img src=$logo_dir/check-out.gif>"
    }
    "O" {set check_prop "<img src=$logo_dir/check-out.gif>"
	set check_occu "<img src=$logo_dir/check-in.gif>"
	set check_terz "<img src=$logo_dir/check-out.gif>"
	set check_ammi "<img src=$logo_dir/check-out.gif>"
	set check_inst "<img src=$logo_dir/check-out.gif>"
    }
    "T" {set check_prop "<img src=$logo_dir/check-out.gif>"
	set check_occu "<img src=$logo_dir/check-out.gif>"
	set check_terz "<img src=$logo_dir/check-in.gif>"
	set check_ammi "<img src=$logo_dir/check-out.gif>"
	set check_inst "<img src=$logo_dir/check-out.gif>"
    }
    "A" {set check_prop "<img src=$logo_dir/check-out.gif>"
	set check_occu "<img src=$logo_dir/check-out.gif>"
	set check_terz "<img src=$logo_dir/check-out.gif>"
	set check_ammi "<img src=$logo_dir/check-in.gif>"
	set check_inst "<img src=$logo_dir/check-out.gif>"
    }
    "I" {set check_prop "<img src=$logo_dir/check-out.gif>"
	set check_occu "<img src=$logo_dir/check-out.gif>"
	set check_terz "<img src=$logo_dir/check-out.gif>"
	set check_ammi "<img src=$logo_dir/check-out.gif>"
	set check_inst "<img src=$logo_dir/check-in.gif>"
    }
}

switch $tipo_gen_foco {
    "A" {set des_tipo_foc "Aperto"
	set tipo_gen_foco "B"}
    "C" {set des_tipo_foc "Chiuso"}
    default {set des_tipo_foc "&nbsp;"}
}

switch $tiraggio {
    "F" {set des_tiraggio "Forzato"}
    "N" {set des_tiraggio "Naturale"}
    default {set des_tiraggio "&nbsp;"}
}

set stampa "<table>"
set root [ns_info pageroot]
# Titolo della stampa
iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)

# combustibile
if {[db_0or1row sel_comb ""] == 0} {
    # codice non trovato
    #   iter_return_complaint  "Combustibile non trovato"
    #   return
    set descr_comb ""
}


if {$flag_co_perc == "t"} {
    set misura_co "(%)"
} else {
    set misura_co "(ppm)"
}

if {[db_0or1row sel_manu ""] == 1} {
    set manuten "$nome $cognome"
    set indir_man "$indirizzo $localita $provincia $telefono" 
} else {
    # codice non trovato
    set manuten "" 
    set indir_man ""
}



set testata2 "
              <table width=100% ><tr>
               <td width=100% align=center><table >
               <tr>
                  <td align=center><b><small>$ente</small></b></td>
               </tr><tr>
                   <td align=center><b><small>$ufficio</small></b></td></tr>
               </tr><tr>
                   <td align=center><small>$assessorato</small></td>
               </tr><tr>
                  <td align=center><small>$indirizzo_ufficio</small></td>
               </tr><tr>
                  <td align=center><small>$telefono_ufficio</small></td></tr></td></tr><small>
<table width=100% border>
    <tr>
        <td colspan=2 align=center>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 2 (GRUPPI FRIGO)
          </tr>
 </table>"

set testata ""

if {$tipologia_costo eq "BO"} {
    set bollino_applicato "Bollino applicato: $riferimento_pag"
} else {
    set bollino_applicato ""
}

if {$flag_cind eq "S"} {

    db_1row q "select c.descrizione as descr_cind
                 from coimcind c
                    , coimdimp d
                where c.cod_cind     = d.cod_cind
                  and d.cod_impianto = :cod_impianto
                  and d.cod_dimp     = :cod_dimp"
    
    set tr_campagna_verifica "<tr><td colspan=3 align=left><small>Campagna: $descr_cind</small></td></tr>"
} else {

    set tr_campagna_verifica ""

}

append stampa "
               <tr>
               <td><b><small>A. IDENTIFICAZIONE DELL'IMPIANTO</small></b></td>
               <td><small>Catasto impianti/codice $cod_impianto_est</small></td>
               <td><small>$bollino_applicato</small></td>
               </tr>

               <table align=center width=100% cellpadding=2 cellspacing=0>
               <tr>
                  <td width=33%><small>Rapporto di controllo N&deg; $num_autocert</small></td>
                  <td width=33%><small><b>Data $data_controllo</b></small></td>
                  <td width=34%><small>Protocollo $n_prot</small></td>
               </tr>
               $tr_campagna_verifica
               <tr>
                  <td colspan=3><small>Impianto termico sito nel comune di: $comune_ubic $prov_ubic 
                  <br>in via/piazza: $indirizzo_ubic Cap: $cap_ubic
                  <br>Responsabile : $cognome_resp $nome_resp $indirizzo_resp  tel.: $telefono_resp
                  <br>Indirizzo $indirizzo_resp $numero_resp $cap_resp $comune_resp $provincia_resp
                  <br>in qualit&agrave; di $check_prop Proprietario $check_occu Occupante 
                      $check_terz Terzo responsabile $check_ammi Amministratore $check_inst Intestatario
                  </small>
               </tr>
               </table>

<tr><td>&nbsp;</td></tr>
<tr><td><table width=100% border=0>
    <tr>
        <td><b><small>Impresa di Manutenzione :</small></b></td>
        <td><small>$manuten  -  $indir_man</small></td>
    </tr>
 
</table>

           </table><table align=center width=100% border=1  cellpadding=2 cellspacing=\"0\">
              <tr><td colspan=2 size=3><small><small><b>B. DOCUMENTAZIONE TECNICA DI CORREDO</b></small></small></td>
                 </tr>
                  <tr><td size=3 width=48%><small><small>Dichiarazione di conformit&agrave; dell'impianto</small></small></td>
                  <td width=2%><small><small>[iter_edit_flag_mh $conformita]</small></small></td>
                  <td size=3 width=48%><small><small>Libretti uso/manutenzione generatore presenti<small/></td>
                  <td width=2%><small><small>[iter_edit_flag_mh $lib_uso_man]</small></td>
              </tr>
              <tr><td><small><small>Libretto d'impianto</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $lib_impianto]</small></small></td>
                  <td><small><small>Libretto compilato in tutte le sue parti</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_lib_uso_man_comp]</small></small></td>
              </tr>
              <tr><td colspan=2 size=2><small><small><b>C.TRATTAMENTO DELL'ACQUA</b></small></small></td>
               </tr>
                  <td><small><small>Durezza °fr</small></small></td>
                  <td><small><small>$rct_dur_acqua</small></small></small></td>
                  <td><small><small>Trattamento in riscaldamento -Non(R)ichiesto-(A)ssente-(F)iltrazione-A(D)dolcimento-Cond.(C)himico</small></small></td>
                  <td><small><small>$rct_tratt_in_risc</small></small></td>
                  </tr>
              <tr><td colspan=2 size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO</b></small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Locale di installazione idoneo:</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $idoneita_locale]</small></small></td>
                  <td><small><small>Linee elettriche idonee</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_linee_ele ]</small></small></td>
              </tr>
              <tr><td><small><small>Adeguate dimensioni apertura ventilazione/aerazione</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $ap_ventilaz]</small></small></td>
                  <td><small><small>Coibentazioni idonee</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_coibentazione]</small></small></td>
              </tr>
               <tr><td><small><small>Aperture di ventilazioni libere da ostruzioni</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $ap_vent_ostruz]</small></small></td>
              </tr>
              </table>
              <table>
              <tr><td colspan=2 size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DEL GRUPPO TERMICO</b></small></small></td>
                 <tr>
        <td valign=top align=left class=form_title><small>Costruttore: $descr_cost</small></td>
        <td valign=top align=left class=form_title><small>Modello: $modello</small></td>
        <td valign=top align=left class=form_title><small>Matricola: $matricola</small></td>
    </tr>
    <tr>
        <td valign=top align=left class=form_title><small>Pot. term. nom. in raffrescamento $potenza</small></td>
        <td valign=top align=left class=form_title><small>Pot. term. nom in riscaldamento $pot_utile_lib</small></td>
        <td valign=top align=left class=form_title><small>Anno di costruzione: $data_costruz_gen</small></td>
    </tr>
    <tr>
         <td valign=top align=left class=form_title><small>Marcatura efficienza energetica:(DPR 660/96): $marc_effic_energ</small></td>
         <td valign=top align=left class=form_title><small>Uso: $destinazione</small></td>
        <td valign=top align=left class=form_title><small>Data installazione: $data_installaz</small></td>       
    </tr>

   <tr>
        <td valign=top align=left class=form_title><small>Consumi ultima stagione di riscaldamento (m<sup><small>3</small></sup>/kg): $consumo_annuo</small></td>
    </tr>        

             
              <tr><td><small><small>Ad assorbimento per recupero calore</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_assorb_recupero]</small></small></td>
                  <td><small><small>Ad assorbimento a fiamma diretta con combustibile</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_assorb_fiamma]</small></small></td>
              </tr>
              <tr><td><small><small>A ciclo di compressione con motore elettrico o endotermico</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_ciclo_compressione]</small></small></td>
              </tr>
              <tr>
                  <td><small><small>Assenza perdite di gas refrigente</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_assenza_perdita_ref]</small></small></td>
                  <td><small><small>Presenza apparecchiature automatica rilevazione diretta fughe refrigerante</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_leak_detector]</small></small></td>
              </tr>
              <tr><td><small><small>Presenza apparecchiature automatica rilevazione indiretta fughe refrigerante</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_pres_ril_fughe]</small></small></td>
                  <td><small><small>Scambiatori di calore puliti e liberi da incrostazioni</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $fr_scambiatore_puliti]</small></small></td>
              </tr>
               </tr>
               <tr><td><small><small>Prova eseguita in modalità (R)affreddamento/Ris(C)aldamento :</small></small></td>
                  <td><small><small><b> $fr_prova_modalita</b></small></small></td>
              </tr>
              <tr></tr>
              </table>
                 <table align=center width=100% border=1 cellpadding=3 cellspacing=\"0\">
              <tr><td><small>Surriscald.(&deg;C)</small></td>
                  <td><small>Sottoraffed.(&deg;C)</small></td>
                  <td><small>T.condens.<sub><small>2</small></sub>(%)</small></td>
                  <td><small>T.eavapor<sub><small>2</small></sub>(%)</small></td>
                  <td><small>T ing.lato est</small></td>
                  <td><small>T usc.lato est</small></td>
                  <td><small>T ing.lato ute</small></td>
                  <td><small>T usc.lato ute</small></td>
                  <td><small>N.Circuito</small></td>
              </tr>
              <tr><td align=right><small>$fr_surrisc</small></td>
                  <td align=right><small>$fr_sottoraff</small></td>
                  <td align=right><small>$fr_tcondens</small></td>
                  <td align=right><small>$fr_tevapor</small></td>
                  <td align=right><small>$fr_t_ing_lato_est</small></td>
                  <td align=right><small>$fr_t_usc_lato_est</small></td>
                  <td align=right><small>$fr_t_ing_lato_ute</small></td>
                  <td align=right><small>$fr_t_usc_lato_ute</small></td>
                  <td align=right><small>$fr_nr_circuito</small></td>
              </tr>
              </table>
              <table>
                   <tr><td colspan=2 size=2><small><small><b>F. CHECK LIST</b></small></small></td> </tr>
                   <tr><td  valign=top align=left class=form_title><small>Elenco di possibili interventi, dei quali va valuta la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica</b></small></td></tr>
                   <tr><td><small><small>$fr_check_list_1 La sostituzione di generatori a regolazione on/off, con altri di pari potenza a più gradini o a regolazione continua</small></small></td></tr>
                   <tr><td><small><small>$fr_check_list_2 La sostituzione dei sistemi di regolazione on/off, con sistemi programmabili su più livelli di temperatura</small></small></td></tr>
                   <tr><td><small><small>$fr_check_list_3 L'isolamento della rete di distribuzione acqua refrigerata/calda nei locali non climatizzati</small></small></td></tr>
                   <tr><td><small><small>$fr_check_list_4   -La sostituzione di un sistema on/off con un sistema programmabile su più livelli di temperatura</small></small></td></tr>
              </table>

              <table width=100% border=0 cellpadding=2 cellspacing=0>
              <tr>
                <td><small><b>OSSERVAZIONI</b>: $osservazioni</small>
                </td>
              </tr>
              <tr>
                <td><small><b>RACCOMANDAZIONI</b> (in attesa di questi interventi l'impianto pu&ograve; essere messo in funzione): $raccomandazioni</small>
                </td>
              </tr>
              <tr>
                <td><small><b>PRESCRIZIONI</b> (in attesa di questi interventi l'impianto non pu&ograve; essere messo in funzione): $prescrizioni"

set lista_anom ""
db_foreach sel_anom "" {
    lappend lista_anom $cod_tanom
}

if {![string equal $lista_anom ""]} {
    append stampa " anomalie presenti:"
    foreach anom $lista_anom {
	append stampa " $anom "
    }
}


append stampa "</b></small>
               </td>
               </tr>
               </table>"

if {[string is space $firma_manut]} {
    set firma_manut $manuten
}

if {[string is space $firma_resp]} {
    set firma_resp "$cognome_resp $nome_resp"
}

append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=1><tr>
                <tr>
                  <td  valign=top align=left class=form_title><small>il tecnico dichiara,in riferimento ai punti A,B,C,D,E (sopra menzionati)  che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.<b>L'impianto pu&ograve; funzionare</b> [iter_edit_flag_mh $flag_status]</small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr><td align=center><table width=100% ><tr>
            <td  valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissione dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo a provvedere alla loro risoluzione dandone notizia all'operatore incaricato. Si raccomanda un intervento manutentivoentro il ............</small></small></td>
          </tr>
          </table>
        </td>
      </tr>
             <table width=100% border=0 cellpadding=2 cellspacing=0>
               <tr>
                    <td colspan=2><small><b>TECNICO CHE HA EFFETTUATO IL CONTROLLO:</b></small></td>
               </tr>
               <tr>
                  <td colspan=2><small>Nome e cognome: $manuten </small></td>
               </tr>
               <tr>
                  <td colspan=2><small>Indirizzo $indir_man<small>
               </tr>
               <tr>
                  <td><small><u>Orario di arrivo presso l'impianto $ora_inizio</u></small></td>
                  <td><small><u>Orario di partenza dall'impianto $ora_fine</u></small></td>
               </tr>
               <tr>
                  <td width=50%><small>Firma manutentore</small></td>
                  <td width=50%><small>Firma responsabile</small></td>
               </tr>
               <tr>
                  <td><small>$firma_manut</small></td>
                  <td><small>$firma_resp</small></td>
               </tr>
             </table>"


# creo file temporaneo html
set stampa1 $testata
append stampa1 $stampa
set stampa2 $testata2
append stampa2 $stampa


# imposto il nome dei file
set nome_file        "stampa RCEE"
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa2
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

# Controllo se il Database e' Oracle o Postgres
set id_db     [iter_get_parameter database]

set sql_contenuto  "lo_import(:file_html)"
set tipo_contenuto [ns_guesstype $file_pdf]

set contenuto_tmpfile  $file_pdf

if {[db_0or1row sel_docu ""] == 0} {
    set flag_docu "N"
} else {
    set flag_docu "S"
}

if {$flag_ins == "S"} {
    with_catch error_msg {
	db_transaction {
	    if {[string equal $cod_documento ""]
		|| $flag_docu == "N"
	    } {
		db_1row sel_docu_next ""
		set tipo_documento "MH"
		db_dml dml_sql_docu [db_map ins_docu]
		db_dml dml_sql_dimp [db_map upd_dimp]
	    } else {
		db_dml dml_sql_docu [db_map upd_docu]
	    }
	    
	    if {$id_db == "postgres"} {
		if {[db_0or1row sel_docu_contenuto ""] == 1} {
		    if {![string equal $docu_contenuto_check ""]} {
			db_dml dml_sql2 [db_map upd_docu_2]
		    }
		}
		db_dml dml_sql3 [db_map upd_docu_3]
	    } else {
		db_dml dml_sql2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
	    }
	    
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

}
ns_unlink $file_html
ad_returnredirect $file_pdf_url
ad_script_abort
