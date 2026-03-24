ad_page_contract {
    Stampa RCEE Tipo 2 (gruppi frigo)
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coimdimp-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================
    rom13 25/11/2024 Sandro ha chiesto di riportare la modifica di rom09 fatta per Caserta anche per
    rom13            Frosinone: il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom12 23/05/2024 Se è attivo l'apposito parametro riporto la campagna di riferimento.

    rom11 11/04/2024 Sandro ha chiesto di riportare la modifica di rom10 fatta per Rieti anche per Caserta:
    rom11            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom10 04/12/2023 Sandro ha chiesto di riportare la modifica di rom09 per Napoli anche per Rieti:
    rom10            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom09 13/11/2023 Sandro ha chiesto di riportare la modifica di rom07 fatta per Palermo anche per Napoli:
    rom09            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom08 28/11/2022 Aggiunta possibilita' di stampare gli rcee con la firma grafometrica in base
    rom08            ai parametri flag_firma_manu_stampa_rcee e flag_firma_resp_stampa_rcee.

    rom07 07/12/2022 Implementazione per Palermo richiesta con mail "Implementazioni" di Sandro del 01/12/2022, riporto testo:
    rom07            Inserimento di un codice bollino nell'apposito campo del Rapporto di controllo. Tale codice sarà uguale a
    rom07            quello del  campo  progressivo inserimento. Per gli impianti con piu' generatori il codice bollino sarà
    rom07            rilasciato solo sul primo generatore dove è presente il contributo.
    rom07            Tale implementazionzione riguarda tutte le tipologie di RCEE e le stampe. Il numero di bollino potrà essere
    rom07            rilasciato solo al momento dell'inserimento. L'implementazione sara' visibile solo per Palermo.

    rom06 02/11/2022 Palermo salva gli allegati su sile system.

    rom05 23/03/2022 Su richiesta di Giuliodori rivisti alcune modifiche di rom04.

    rom04 16/03/2022 MEV Regione Marche punto 6. Stampa RCEE precompilato senza dati del
    rom04            Controllo del rendimento di combustione.

    rom03 12/04/2021 Corretta sezione C. per Regione Marche:
    rom03            Tolta parte Trattamento in ACS perche' in realta' non e' presente.

    rom02 22/12/2020 Per gli enti diversi dalla Regione Marche non veniva visualizzato il costo
    rom02            dei bollini virtuali.

    rom01 02/07/2020 Corretto errore sulla visualizzazione di alcune immagine fleggate e
    rom01            sulla visualizzazione delle potenze corrette.

    sim03 08/04/2019 Gestito il salvataggio degli allegati sul file system

    gac03 13/02/2019 Tolto NC nei campi della sezione B.

    gac02 21/01/2019 Aggiunto campi consumi ed elettricità
    
    gac01 15/01/2019 Modificata stampa per regione marche, quasi ogni modifica è riportata in
    gac01            una if solo per regione marche

    sim03 08/05/2019 Al posto di pot_utile_lib come "Pot. term. utile riscald." va visualizzata la pot_focolare_lib

    sim02 29/01/2018 Gestito nella stampa le prove fumo multiple

    sim01 21/06/2016 Aggiunta del logo alla stampa utilizzando i parametri stampe_logo_nome
    sim01            e stampe_logo_in_tutte_le_stampe.

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
    {is_only_print_p     "f"}
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
set flag_cind   $coimtgen(flag_cind);#rom12

if {$is_only_print_p} {#rom04 Aggiunta if e sil suo contenuto

    set sel_dimp "sel_gend_only_print"

    set sel_aimp "sel_aimp_only_print"

    set tr_da_agg "<tr><td><small><small>&nbsp;</small></small></td></tr>";#rom05
    
} else {#rom04 Aggiunta else ma non il suo contenuto
    
if {$flag_viario == "T"} {
    set sel_dimp "sel_dimp_si_vie"
} else {
    set sel_dimp "sel_dimp_no_vie"
}
set sel_aimp "sel_aimp";#rom04
    set tr_da_agg "";#rom05
};#rom04

#rom04if {[db_0or1row $sel_dimp ""] == 0} {
    # codice non trovato
#rom04    iter_return_complaint  "Dati Impianto non trovati</li>"
#rom04    return
#rom04}

set img_firma_manuten $spool_dir/$cod_dimp-M-immagine.png;#rom08
set img_firma_respons $spool_dir/$cod_dimp-C-immagine.png;#rom08

if {[file exists $img_firma_manuten] == 0} {#rom08 Aggiunta if e il suo contenuto
    set img_firma_manuten ""
}

if {[file exists $img_firma_respons] == 0} {#rom08 Aggiunta if e il suo contenuto
    set img_firma_respons ""
}



set n_page 0;#rom04

db_foreach $sel_dimp "" {#rom04 Aggiunta foreach ma non il suo contenuto

    set stampa "";#rom04

# dati impianto
if {[db_0or1row $sel_aimp ""] == 0} {
    # codice non trovato
    #   iter_return_complaint  "Impianto non trovato"
    #   return
    set modello          ""
    set descrizione      ""
    set tipo_gen_foco    ""
    set tiraggio         ""
}

if {$coimtgen(regione) eq "MARCHE"} {#gac01 if e suo contenuto
    set height "height=10"
} else {
    set height ""
}

incr n_page;#rom04

if {$n_page > 1} {#rom04 Aggiunta if e suo contenuto
    set testata2 "<!-- PAGE BREAK -->"
} else {
    set testata2 ""
}

switch $flag_resp {
    "P" {set check_prop "<img src=$logo_dir/check-in.gif $height>"
	set check_occu "<img src=$logo_dir/check-out.gif $height>"
	set check_terz "<img src=$logo_dir/check-out.gif $height>"
	set check_ammi "<img src=$logo_dir/check-out.gif $height>"
	set check_inst "<img src=$logo_dir/check-out.gif $height>"
    }
    "O" {set check_prop "<img src=$logo_dir/check-out.gif $height>"
	set check_occu "<img src=$logo_dir/check-in.gif $height>"
	set check_terz "<img src=$logo_dir/check-out.gif $height>"
	set check_ammi "<img src=$logo_dir/check-out.gif $height>"
	set check_inst "<img src=$logo_dir/check-out.gif $height>"
    }
    "T" {set check_prop "<img src=$logo_dir/check-out.gif $height>"
	set check_occu "<img src=$logo_dir/check-out.gif $height>"
	set check_terz "<img src=$logo_dir/check-in.gif $height>"
	set check_ammi "<img src=$logo_dir/check-out.gif $height>"
	set check_inst "<img src=$logo_dir/check-out.gif $height>"
    }
    "A" {set check_prop "<img src=$logo_dir/check-out.gif $height>"
	set check_occu "<img src=$logo_dir/check-out.gif $height>"
	set check_terz "<img src=$logo_dir/check-out.gif $height>"
	set check_ammi "<img src=$logo_dir/check-in.gif $height>"
	set check_inst "<img src=$logo_dir/check-out.gif $height>"
    }
    "I" {set check_prop "<img src=$logo_dir/check-out.gif $height>"
	set check_occu "<img src=$logo_dir/check-out.gif $height>"
	set check_terz "<img src=$logo_dir/check-out.gif $height>"
	set check_ammi "<img src=$logo_dir/check-out.gif $height>"
	set check_inst "<img src=$logo_dir/check-in.gif $height>"
    }
}

set img_checked "<img src=\"$logo_dir/check-in.gif\" height=10 width=10>";#gac01
set img_unchecked "<img src=\"$logo_dir/check-out.gif\" height=10 width=10>";#gac01
db_0or1row q "select gen_prog_est from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_progg";#gac01

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

#rom04set stampa "<table width=100%>"

append stampa "<table width=100% border=0>";#rom04

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
    if {$coimtgen(regione) eq "MARCHE"} {#gac00 if else e contenuto di if
	set indir_man "$indirizzo $localita"
    } else {
	set indir_man "$indirizzo $localita $provincia $telefono"
    }
} else {
    # codice non trovato
    set manuten "" 
    set indir_man ""
}

if {[db_0or1row sel_opma ""] == 1} {
    set operatore "$nome_op $cognome_op"
} else {
    # codice non trovato
    set operatore "_______________________________________";#rom05
}

if {$coimtgen(regione) ne "MARCHE"} {#gac01 if else e contenuto
    if {$tipologia_costo eq "BO"} {
	set bollino_applicato "Bollino applicato: $riferimento_pag"
    } else {
	set bollino_applicato ""
    }

    if {$tipologia_costo eq "LM"} {;#sim02 if e else e loro contenuto
	set costo_bollino "Bollino virtuale: $costo_pretty euro"
    } else {
	set costo_bollino ""
    }

    #rom09 Aggiunta condizione per PNA
    #rom10 Aggiunta condizione per PRI
    #rom11 Aggiunta condizione per PCE
    #rom13 Aggiunta condizione per PFR
    if {$coimtgen(ente) in [list "PPA" "PNA" "PRI" "PCE" "PFR"] && $riferimento_pag ne ""} {#rom07 Aggiunta if e il suo contenuto
        append costo_bollino "    Codice bollino: $riferimento_pag"
    }
    
} else {#gac01
    if {$tipologia_costo eq "BO"} {
	set bollino_applicato "Bollino applicato: $riferimento_pag"
    } else {
	set bollino_applicato ""
    }

    if {$tipologia_costo eq "LM"} {;#sim02 if e else e loro contenuto
	set costo_bollino "segno identificativo assolto -  &euro; $costo_pretty"
    } else {
	set costo_bollino ""
    }
};#gac01

set stampe_logo_in_tutte_le_stampe [parameter::get_from_package_key -package_key iter -parameter stampe_logo_in_tutte_le_stampe -default "0"];#sim01
set stampe_logo_nome               [parameter::get_from_package_key -package_key iter -parameter stampe_logo_nome];#sim01
set stampe_logo_height             [parameter::get_from_package_key -package_key iter -parameter stampe_logo_height];#sim01

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: Aggiunta if e suo contenuto
    if {$stampe_logo_height ne ""} {
        if {$coimtgen(regione) eq "MARCHE"} {#gac01 if else e contenuto di if
	    set height_logo "height=28"
	} else {#gac01
	    set height_logo "height=$stampe_logo_height"
	}
    } else {
        set height_logo ""
    }
    set logo "<img src=$logo_dir/$stampe_logo_nome $height_logo>"

    if {$coimtgen(regione) eq "MARCHE"} {#gac01 aggiunta if, else e contenuto di if (parte per regione marche)
	if {$coimtgen(ente) ne "CANCONA"} {
	    set logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default ""]
	    set logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"]
	    set logo_dx "<img src=$logo_dir/logo_dx_nome.png height=15>"

	} else {
	    set logo_dx "<img src=$logo_dir/logo-comune-ancona.png width=28 height=28>"
	}
    } else {#parte standard
	set logo_dx "";#gac01
    }
    if {$coimtgen(ente) eq "PRC"} {;#gac01 if e suo contenuto

	set master_logo_dx_nome [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
	set logo_dx "<img src=$logo_dir/$master_logo_dx_nome $height_logo align=right>"
    }
} else {
    set logo_dx "";#gac01
    set logo ""
}

append testata2 "
<table width=100%>
  <tr>
    <td width=100% align=center>"

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: Aggiunta if e suo contenuto
    append testata2 "
      <table width=100% border=0>
        <tr>
          <td width=20%>$logo</td>
          <td width=60% align=center>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
#rom08append testata2 "
#            <table>
#              <tr><td align=center><b><small>$ente</small></b></td></tr>
#              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
#              <tr><td align=center><small>$assessorato</small></td></tr>
#              <tr><td align=center><small>$indirizzo_ufficio</small></td></tr>
#              <tr><td align=center><small>$telefono_ufficio</small></td></tr>
#rom08       </table>"
    append testata2 "
            <table>
              <tr><td align=center><b><small>$ente</small></b></td></tr>
              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
              <tr><td align=center><small>$assessorato $indirizzo_ufficio $telefono_ufficio </small></td></tr>
       </table>";#rom08
} else {#parte per regione marche
        append testata2 "
            <table>
              <tr><td align=center><b><small><small>$ente</small></small></b></td></tr>
              <tr><td align=center><b><small><small>$ufficio</small></small></b></td></tr>
            </table>"
}

if {$coimtgen(regione) ne "MARCHE"} {#gac01 parte standard
    if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
	#sim03 aggiunto logo_dx
	        append testata2 "
          </td>
          <td align=center width=25%>$logo_dx</td>
      </table>"
	    }
} else {#parte per regione marche
    if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
	#sim03 aggiunto logo_dx
	        append testata2 "
          </td>
          <td align=center width=25%>$logo_dx</td>
             <tr>
                <td colspan=2 align=left><small><small>Motivo compilazione REE: $descr_tprc</small></small></td><!-- gac01-->
                <td colspan=1 align=right><small><small>$costo_bollino</small></small></td></tr><!-- sim02 -->
             </tr>
      </table>"
	    }
}

set um "";#gac01
set um [db_string q "select um from coimcomb where cod_combustibile = :cod_combustibile" -default ""];#gac01

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto
    append testata2 "
      <table width=100% border>
        <tr>
          <td colspan=2 align=center>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 2 (GRUPPI FRIGO)
        </tr>
      </table>"
} else {
    append testata2 "
      <table width=100% border>
        <tr>
          <td colspan=2 align=center><small>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 2 (gruppi frigo)</small></td>
        </tr>
      </table>"
}

set testata ""
#gac01 aggiunto sopra
#if {$tipologia_costo eq "BO"} {
#    set bollino_applicato "Bollino applicato: $riferimento_pag"
#} else {
#    set bollino_applicato ""
#}

if {$coimtgen(regione) ne "MARCHE"} {#gac01 if else e loro contenuto
    append stampa "
               <tr>
               <td><b><small>A. IDENTIFICAZIONE DELL'IMPIANTO</small></b></td>
               <td><small>Catasto impianti/codice $cod_impianto_est</small></td>
               <td><small>$bollino_applicato</small></td>
               </tr>

               <table align=center width=100% cellpadding=2 cellspacing=0>"
} else {
    append stampa "
               <tr>
               <td width=25% align=left><b><small><small>A. DATI IDENTIFICATIVI</small></small></b></td>
               <td width=25%><small><small>codice catasto $cod_impianto_est</small></small></td>
               <td width=25%><small><small>$bollino_applicato</small></small></td>
               <td width=25%><small><small>Targa: $targa</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if e suo contenuto
    append stampa "
               <tr>
                  <td width=33%><small>Rapporto di controllo N&deg; $num_autocert</small></td>
                  <td width=33%><small><b>Data $data_controllo</b></small></td>
                  <td width=34%><small>Protocollo $n_prot</small></td>
               </tr>"
}

if {$flag_cind eq "S"} {#rom12 Aggiunta if e il suo contenuto

    db_1row q "select c.descrizione as descr_cind
                 from coimcind c
                    , coimdimp d
                where c.cod_cind     = d.cod_cind
                  and d.cod_impianto = :cod_impianto
                  and d.cod_dimp     = :cod_dimp"
    
    append stampa "<tr><td colspan=3 align=left><small>Campagna: $descr_cind</small></td></tr>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
    append stampa "
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

<!--rom08 <tr><td>&nbsp;</td></tr> -->
<tr><td><table width=100% border=0>
    <tr>
        <td><b><small>Impresa di Manutenzione :</small></b></td>
        <td><small>$manuten  -  $indir_man</small></td>
    </tr>
 
</table>
"
} else {#parte per regione marche
        append stampa "
                  <tr>
                  <td><small><small><b>Impianto:</b> di Potenza termica nominale max $pot_ter_nom_tot_max (kW) </small></small></td>
                  <td><small><small>sito nel Comune $comune_ubic Prov. $prov_ubic</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Indirizzo $indirizzo_ubic</small></small></td>
                  <td><small><small>Scala $scala  Interno $interno</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small><b>Responsabile dell'impianto:</b> Cognome $cognome_resp</small></small></td>
                  <td><small><small>Nome $nome_resp </small></small></td>
                  <td><small><small>C.F. $cod_fiscale</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Indirizzo $indirizzo_resp</small></small></td>
                  <td><small><small>Comune $comune_resp</small></small></td>
                  <td><small><small>Provincia $provincia_resp</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Ragione Sociale </small></small></td>
                  <td><small><small>P.IVA</small></small></td>
                  </tr>
                  <td colspan=3><small><small>Titolo di responsabilità: $check_prop Proprietario $check_occu Occupante
                      $check_terz Terzo responsabile $check_ammi Amministratore $check_inst Intestatario</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small><b>Impresa manutentrice: </b>Ragione Sociale $manuten</small></small></td>
                  <td><small><small>P.IVA $cod_piva</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Indirizzo $indir_man</small></small></td>
                  <td><small><small>Comune $comune</small></small></td>
                  <td><small><small>Prov. $provincia</small></small></td>
                  </tr>
"
};#gac01

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
        append stampa "
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
              </table>"
} else {#gac01 parte per regione marche

    if {$conformita eq "S"} {
	set img_conf_s $img_checked
    } else {
	set img_conf_s $img_unchecked
    }
    if {$conformita eq "N"} {
	set img_conf_n $img_checked
    } else {
	set img_conf_n $img_unchecked
    }
    if {$conformita eq "C"} {
	set img_conf_nc $img_checked
    } else {
	set img_conf_nc $img_unchecked
    }

    if {$lib_uso_man eq "S"} {
	set img_lib_uso_s $img_checked
    } else {
	set img_lib_uso_s $img_unchecked
    }
    if {$lib_uso_man eq "N"} {
	set img_lib_uso_n $img_checked
    } else {
	set img_lib_uso_n $img_unchecked
    }
    if {$lib_uso_man eq "C"} {
	set img_lib_uso_nc $img_checked
    } else {
	set img_lib_uso_nc $img_unchecked
    }
    
    if {$lib_impianto eq "S"} {
	set img_lib_impianto_s $img_checked
    } else {
	set img_lib_impianto_s $img_unchecked
    }
    if {$lib_impianto eq "N"} {
	set img_lib_impianto_n $img_checked
    } else {
	set img_lib_impianto_n $img_unchecked
    }
    if {$lib_impianto eq "C"} {
	set img_lib_impianto_nc $img_checked
    } else {
	set img_lib_impianto_nc $img_unchecked
    }
    
    if {$rct_lib_uso_man_comp eq "S"} {
	set img_lib_uso_man_s $img_checked
    } else {
	set img_lib_uso_man_s $img_unchecked
    }
    if {$rct_lib_uso_man_comp eq "N"} {
	set img_lib_uso_man_n $img_checked
    } else {
	set img_lib_uso_man_n $img_unchecked
    }
    if {$rct_lib_uso_man_comp eq "C"} {
	set img_lib_uso_man_nc $img_checked
    } else {
	set img_lib_uso_man_nc $img_unchecked
    }

    set check_r "<img src=$logo_dir/check-out.gif height=10>"
    set check_a "<img src=$logo_dir/check-out.gif height=10>"
    set check_f "<img src=$logo_dir/check-out.gif height=10>"
    set check_d "<img src=$logo_dir/check-out.gif height=10>"
    set check_c "<img src=$logo_dir/check-out.gif height=10>"
    set check_altro "<img src=$logo_dir/check-out.gif height=10>" 

    #rom03 Aggiunti switch per i valori:
    #rom03 K: Filtr. + Addolc.
    #rom03 J: Filtr. + Cond.Ch.
    #rom03 W: Cond.Ch. + Addolc.
    #rom03 T: Filt. + Cond.Ch. + Addolc.

    switch $rct_tratt_in_risc {
	"R" {
	    set check_r "<img src=$logo_dir/check-in.gif height=10>"
	}
	"A" {
	    set check_a "<img src=$logo_dir/check-in.gif height=10>"
	}
	"F" {
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	}
	"D" {
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	}
	"C" {
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	"K" {
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	}
	"J" {
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	"W" {
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	"T" {
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	default {
	    set check_altro "<img src=$logo_dir/check-in.gif height=10>"
	}
    }

    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"

    switch $rct_tratt_in_acs {
	"R" {
	    set check_r1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"A" {
	    set check_a1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"F" {
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"D" {
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"C" {
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	default {
	    set check_altro1 "<img src=$logo_dir/check-in.gif height=10>"
	}
    }
    if {$idoneita_locale eq "S"} {
	set img_idoneita_s $img_checked
    } else {
	set img_idoneita_s $img_unchecked
    }
    if {$idoneita_locale eq "N"} {
	set img_idoneita_n $img_checked
    } else {
	set img_idoneita_n $img_unchecked
    }
    if {$idoneita_locale eq "E"} {
	set img_idoneita_nc $img_checked
    } else {
	set img_idoneita_nc $img_unchecked
    }

    if {$ap_ventilaz eq "S"} {
	set img_ap_ventilaz_s $img_checked
    } else {
	set img_ap_ventilaz_s $img_unchecked
    }
    if {$ap_ventilaz eq "N"} {
	set img_ap_ventilaz_n $img_checked
    } else {
	set img_ap_ventilaz_n $img_unchecked
    }
    if {$ap_ventilaz eq "C"} {
	set img_ap_ventilaz_nc $img_checked
    } else {
	set img_ap_ventilaz_nc $img_unchecked
    }
    
    if {$ap_vent_ostruz eq "S"} {
	set img_ap_vent_ostruz_s $img_checked
    } else {
	set img_ap_vent_ostruz_s $img_unchecked
    }
    if {$ap_vent_ostruz eq "N"} {
	set img_ap_vent_ostruz_n $img_checked
    } else {
	set img_ap_vent_ostruz_n $img_unchecked
    }
    if {$ap_vent_ostruz eq "C"} {
	set img_ap_vent_ostruz_nc $img_checked
    } else {
	set img_ap_vent_ostruz_nc $img_unchecked
    }
    
    if {$fr_linee_ele eq "S"} {
	set img_fr_linee_ele_s $img_checked
    } else {
	set img_fr_linee_ele_s $img_unchecked
    }
    if {$fr_linee_ele eq "N"} {
	set img_fr_linee_ele_n $img_checked
    } else {
	set img_fr_linee_ele_n $img_unchecked
    }
    if {$fr_linee_ele eq "C"} {
	set img_fr_linee_ele_nc $img_checked
    } else {
	set img_fr_linee_ele_nc $img_unchecked
    }

    if {$fr_coibentazione eq "S"} {
	set img_fr_coibentazione_s $img_checked
    } else {
	set img_fr_coibentazione_s $img_unchecked
    }
    if {$fr_coibentazione eq "N"} {
	set img_fr_coibentazione_n $img_checked
    } else {
	set img_fr_coibentazione_n $img_unchecked
    }
    if {$fr_coibentazione eq "C"} {
	set img_fr_coibentazione_nc $img_checked
    } else {
	set img_fr_coibentazione_nc $img_unchecked
    }

    if {$fr_assorb_recupero eq "S"} {
	set img_fr_assorb_recupero_s $img_checked
    } else {
	set img_fr_assorb_recupero_s $img_unchecked
    }
    if {$fr_assorb_fiamma eq "S"} {
	set img_fr_assorb_fiamma_s $img_checked
    } else {
	set img_fr_assorb_fiamma_s $img_unchecked
    }
    if {$fr_ciclo_compressione eq "S"} {
	set img_fr_ciclo_compressione_s $img_checked
    } else {
	set img_fr_ciclo_compressione_s $img_unchecked
    }

    if {$cont_rend eq "S"} {
	set img_cont_rend_s $img_checked
	set img_cont_rend_n $img_unchecked
    } else {
	set img_cont_rend_s $img_unchecked
	set img_cont_rend_n $img_checked
    }
    if {$fr_prova_modalita eq "R"} {
	set img_fr_prova_modalita_raff $img_checked
	set img_fr_prova_modalita_risc $img_unchecked
    } elseif {$fr_prova_modalita eq "C"} {
	set img_fr_prova_modalita_raff $img_unchecked
	set img_fr_prova_modalita_risc $img_checked
    } else {
	set img_fr_prova_modalita_raff $img_unchecked
	set img_fr_prova_modalita_risc $img_unchecked
    }
    
    if {$fr_assenza_perdita_ref eq "S"} {
	set img_fr_assenza_perdita_ref_s $img_checked
    } else {
	set img_fr_assenza_perdita_ref_s $img_unchecked
    }
    if {$fr_assenza_perdita_ref eq "N"} {
	set img_fr_assenza_perdita_ref_n $img_checked
    } else {
	set img_fr_assenza_perdita_ref_n $img_unchecked
    }
    if {$fr_assenza_perdita_ref eq "C"} {
	set img_fr_assenza_perdita_ref_nc $img_checked
    } else {
	set img_fr_assenza_perdita_ref_nc $img_unchecked
    }

    if {$fr_leak_detector eq "S"} {
	set img_fr_leak_detector_s $img_checked
    } else {
	set img_fr_leak_detector_s $img_unchecked
    }
    if {$fr_leak_detector eq "N"} {
	set img_fr_leak_detector_n $img_checked
    } else {
	set img_fr_leak_detector_n $img_unchecked
    }
    if {$fr_leak_detector eq "C"} {
	set img_fr_leak_detector_nc $img_checked
    } else {
	set img_fr_leak_detector_nc $img_unchecked
    }

    if {$fr_pres_ril_fughe eq "S"} {
	set img_fr_pres_ril_fughe_s $img_checked
    } else {
	set img_fr_pres_ril_fughe_s $img_unchecked
    }
    if {$fr_pres_ril_fughe eq "N"} {
	set img_fr_pres_ril_fughe_n $img_checked
    } else {
	set img_fr_pres_ril_fughe_n $img_unchecked
    }
    if {$fr_pres_ril_fughe eq "C"} {
	set img_fr_pres_ril_fughe_nc $img_checked
    } else {
	set img_fr_pres_ril_fughe_nc $img_unchecked
    }

    if {$fr_scambiatore_puliti eq "S"} {
	set img_fr_scambiatore_puliti_s $img_checked
    } else {
	set img_fr_scambiatore_puliti_s $img_unchecked
    }
    if {$fr_scambiatore_puliti eq "N"} {
	set img_fr_scambiatore_puliti_n $img_checked
    } else {
	set img_fr_scambiatore_puliti_n $img_unchecked
    }
    if {$fr_scambiatore_puliti eq "C"} {
	set img_fr_scambiatore_puliti_nc $img_checked
    } else {
	set img_fr_scambiatore_puliti_nc $img_unchecked
    }
    
    append stampa "
              </table><table align=center width=100% border=0  cellpadding=0 cellspacing=\"0\">
              <tr><td width=40% size=3><small><small><b>B. DOCUMENTAZIONE TECNICA A CORREDO</b></small></small></td>
                  <td width=10%><small><small>Sì &nbsp; No</small></small></td>
                  <td width=40%>&nbsp;</td>
                  <td width=10%><small><small>Sì &nbsp; No</small></small></td>
                 </tr>
                  <tr><td size=3 ><small><small>Dichiarazione di Conformit&agrave; presente</small></small></td>
                  <td><small><small>$img_conf_s $img_conf_n</small></small></td>
                  <td size=3><small><small>Libretti uso/manutenzione generatore presenti<small/></td>
                  <td><small><small>$img_lib_uso_s $img_lib_uso_n</small></td>
              </tr>
              <tr><td><small><small>Libretto impianto presente</small></small></td>
                  <td><small><small>$img_lib_impianto_s $img_lib_impianto_n</small></small></td>
                  <td><small><small>Libretto compilato in tutte le sue parti</small></small></td>
                  <td><small><small>$img_lib_uso_man_s $img_lib_uso_man_n</small></small></td>
              </tr>
              </table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
              <tr><td size=2><small><small><b>C.TRATTAMENTO DELL'ACQUA</b></small></small></td>
               </tr>
                  <tr>
                  <td width=20%><small><small>Durezza totale dell'acqua: $rct_dur_acqua (°fr)</small></small></td>
                  <td><small><small>Trattamento in riscaldamento: </small></small></td>
                  <td><small><small>$check_r Non richiesto $check_a Assente $check_f Filtrazione $check_d Addolcimento $check_c 
                  Condiz.chimico <!--rom03 $check_altro Altro--></small></small></td>
                  </tr>
    <!--rom03     <tr>
                  <td>&nbsp;</td>
                  <td><small><small>Trattamento in ACS:</small></small></td>
                  <td><small><small> $check_r1 Non richiesto $check_a1 Assente $check_f1 Filtrazione $check_d1 Addolcimento $check_c1
                  Condiz.chimico $check_altro1 Altro</small></small></td>
              </tr> -->
              </table><table align=center width=100% border=0  cellpadding=0 cellspacing=\"0\">
                  <tr>
                  <td size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO (esami visivi)</b></small></small></td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  <td>&nbsp;</td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Locale di installazione idoneo</small></small></td>
                  <td width=10%><small><small>$img_idoneita_s $img_idoneita_n $img_idoneita_nc </small></small></td>
                  <td width=40%><small><small>Linee elettriche idonee</small></small></td>
                  <td width=10%><small><small>$img_fr_linee_ele_s $img_fr_linee_ele_n $img_fr_linee_ele_nc </small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Dimensioni aperture di ventilazione adeguate</small></small></td>
                  <td width=10%><small><small>$img_ap_ventilaz_s $img_ap_ventilaz_n $img_ap_ventilaz_nc </small></small></td>
                  <td width=40%><small><small>Coibentazioni idonee</small></small></td>
                  <td width=10%><small><small>$img_fr_coibentazione_s $img_fr_coibentazione_n $img_fr_coibentazione_nc</small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Aperture di ventilazione libere da ostruzioni</small></small></td>
                  <td width=10%><small><small>$img_ap_vent_ostruz_s $img_ap_vent_ostruz_n $img_ap_vent_ostruz_nc</small></small></td>
                  <td width=50% colspan=2><small><small>&nbsp;</small></small></td>
                  </tr>
              </table>
              <table width=100% border=0><!-- gac02-->
              <tr><td colspan=2><small><small><b>D.bis. CONSUMI</b></small></small></td></tr>
              <tr>
                  <td valign=top align=center  colspan=10 class=form_title><small><small><b>Consumi di combustibile ($um)</b></small></small></td>
              </tr>
              <tr>    
                  <td valign=top align=left  class=form_title><small><small>Stagione di riscaldamento attuale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$stagione_risc</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Acquisti</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$acquisti</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. iniziale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_iniz</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. finale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_fin</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Consumi stagione</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$consumo_annuo</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left  class=form_title><small><small>Stagione di riscaldamento precedente</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$stagione_risc2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Acquisti</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$acquisti2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. iniziale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_iniz2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. finale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_fin2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Consumi stagione</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$consumo_annuo2</small></small></td>
               </tr>
               </table>
               <table width=100% border=0>
               <tr>
                   <td valign=top align=center colspan=4 class=form_title><small><small><b>Consumi elettrici</b></small></small></td></tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>Esercizio</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Lettura iniziale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Lettura finale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Consumo annuo</small></small></td>
               </tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>$elet_esercizio_1 / $elet_esercizio_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_iniziale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_finale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_consumo_totale</small></small></td>
               </tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>$elet_esercizio_3 / $elet_esercizio_4</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_iniziale_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_finale_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_consumo_totale_2</small></small></td>
               </tr>
               </table>
              <table width=100%>
              <tr><td size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DEL GRUPPO FRIGO GF $gen_prog_est </b></small></small></td>
              </tr>
              <tr>
                  <td valign=top width=50% align=left class=form_title><small><small>Fabbricante $descr_cost</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$img_fr_assorb_recupero_s Ad assorbimento per recupero del calore</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Modello $modello</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$img_fr_assorb_fiamma_s Ad assorbimento a fiamma diretta con combustibile $descr_comb</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Matricola $matricola</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$img_fr_ciclo_compressione_s A ciclo di compressione con motore elettrico o endotermico </small></small></td>
              </tr>
              </table>
              <table width=100%>
              <tr>
                  <td width=20% valign=top align=left class=form_title><small><small>N° circuiti $num_circuiti</small></small></td>
                  <td width=30% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=40% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=10% valign=top align=left><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
              </tr>
              <tr>
                  <td colspan=2 valign=top align=left class=form_title><small><small>Potenza frigorifera nominale in raffrescamento $pot_focolare_nom (kW)</small></small></td>
                  <td><small><small>Assenza perdite di gas refrigerante</small></small></td>
                  <td><small><small>$img_fr_assenza_perdita_ref_s $img_fr_assenza_perdita_ref_n $img_fr_assenza_perdita_ref_nc</small></small></td>
              </tr>
              <tr>
                  <td colspan=2 valign=top align=left class=form_title><small><small>Potenza termica nominale in riscaldamento $pot_focolare_lib (kW)</small></small></td>
                  <td><small><small>Presenza apparecchiatura automatica rilevazione diretta fughe refrigerante (leak detector)</small></small></td>
                  <td><small><small>$img_fr_leak_detector_s $img_fr_leak_detector_n $img_fr_leak_detector_nc</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Verifica energetica:</small></small></td>
                  <td><small><small>$img_cont_rend_n non effettuata $img_cont_rend_s effettuata </small></small></td>
                  <td><small><small>Presenza apparecchiatura automatica rilevazione indiretta fughe refrigerante (parametri termodinamici)</small></small></td>
                  <td><small><small>$img_fr_pres_ril_fughe_s $img_fr_pres_ril_fughe_n $img_fr_pres_ril_fughe_nc</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Prova eseguita in modalità:</small></small></td>
                  <td><small><small>$img_fr_prova_modalita_raff raffrescamento $img_fr_prova_modalita_risc riscaldamento </small></small></td>
                  <td><small><small>Scambiatori di calore puliti e liberi da incrostazioni</small></small></td>
                  <td><small><small>$img_fr_scambiatore_puliti_s $img_fr_scambiatore_puliti_n $img_fr_scambiatore_puliti_nc</small></small></td>
              </tr>
              </table>
"
}
if {$coimtgen(regione) ne "MARCHE"} {#gac01 if e suo contenuto
    append stampa "
<table  width=100% border=0> <!-- gac01 aggiunti nuovi campi scheda 11-->
<tr>    
    <td valign=top align=left  class=form_title><small>Stagione di riscaldamento attuale</small></td>
    <td valign=top align=right  class=form_title><small>$stagione_risc</small></td>
    <td valign=top align=left  class=form_title><small>Acquisti</small></td>
    <td valign=top align=right  class=form_title><small>$acquisti</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. iniziale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_iniz</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. finale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_fin</small></td>
    <td valign=top align=left  class=form_title><small>Consumi stagione</small></td>
    <td valign=top align=right  class=form_title><small>$consumo_annuo</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>Stagione di riscaldamento precedente</small></td>
    <td valign=top align=right  class=form_title><small>$stagione_risc2</small></td>
    <td valign=top align=left  class=form_title><small>Acquisti</small></td>
    <td valign=top align=right  class=form_title><small>$acquisti2</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. iniziale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_iniz2</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. finale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_fin2</small></td>
    <td valign=top align=left  class=form_title><small>Consumi stagione</small></td>
    <td valign=top align=right  class=form_title><small>$consumo_annuo2</small></td>

</tr>
</table>
<table width=100% border=0>
<tr>
    <td valign=top align=center colspan=4 class=form_title><small><b>Elettricità</b></small></td></tr>
<tr>
    <td valign=top align=left  class=form_title><small>Esercizio</small></td>
    <td valign=top align=left  class=form_title><small>Lettura iniziale</small></td>
    <td valign=top align=left  class=form_title><small>Lettura finale</small></td>
    <td valign=top align=left  class=form_title><small>Consumo annuo</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>$elet_esercizio_1 / $elet_esercizio_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_iniziale</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_finale</small></td>
    <td valign=top align=left  class=form_title><small>$elet_consumo_totale</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>$elet_esercizio_3 / $elet_esercizio_4</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_iniziale_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_finale_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_consumo_totale_2</small></td>
</tr>

</table>
<table>
  <tr><td colspan=3 size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DEL GRUPPO TERMICO</b></small></small></td></tr>
  <tr>
    <td valign=top align=left class=form_title><small>Costruttore: $descr_cost</small></td>
    <td valign=top align=left class=form_title><small>Modello: $modello</small></td>
    <td valign=top align=left class=form_title><small>Matricola: $matricola</small></td>
  </tr>
  <tr>
    <td valign=top align=left class=form_title><small>Pot. term. nom. in raffrescamento $potenza</small></td>
    <td valign=top align=left class=form_title><small>Pot. term. nom in riscaldamento $pot_focolare_lib</small></td>
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
  <tr>
    <td nowrap><small><small>Ad assorbimento per recupero calore</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_assorb_recupero]</small></small></td>
    <td nowrap><small><small>Ad assorbimento a fiamma diretta con combustibile</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_assorb_fiamma]</small></small></td>
  </tr>
  <tr>
    <td nowrap><small><small>A ciclo di compressione con motore elettrico o endotermico</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_ciclo_compressione]</small></small></td>
  </tr>
  <tr>
    <td nowrap><small><small>Assenza perdite di gas refrigente</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_assenza_perdita_ref]</small></small></td>
    <td nowrap><small><small>Presenza apparecchiature automatica rilevazione diretta fughe refrigerante</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_leak_detector]</small></small></td>
  </tr>
  <tr>
    <td nowrap><small><small>Presenza apparecchiature automatica rilevazione indiretta fughe refrigerante</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_pres_ril_fughe]</small></small></td>
    <td nowrap><small><small>Scambiatori di calore puliti e liberi da incrostazioni</small></small></td>
    <td nowrap><small><small>[iter_edit_flag_mh $fr_scambiatore_puliti]</small></small></td>
  </tr>
  <tr>
    <td nowrap><small><small>Prova eseguita in modalità (R)affreddamento/Ris(C)aldamento :</small></small></td>
    <td nowrap><small><small><b> $fr_prova_modalita</b></small></small></td>
  </tr>
  <tr></tr>
</table>
"}

if {$coimtgen(regione) ne "MARCHE"} {#gac01 if e suo contenuto (parte standard)
    append stampa "
                 <table align=center width=100% border=1 cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td><small>Num modulo</small></td><!--sim04-->
                  <td><small>Surriscald.(&deg;C)</small></td>
                  <td><small>Sottoraffed.(&deg;C)</small></td>
                  <td><small>T.condens.<sub><small>2</small></sub>(%)</small></td>
                  <td><small>T.eavapor<sub><small>2</small></sub>(%)</small></td>
                  <td><small>T ing.lato est</small></td>
                  <td><small>T usc.lato est</small></td>
                  <td><small>T ing.lato ute</small></td>
                  <td><small>T usc.lato ute</small></td>
                  <td><small>N.Circuito</small></td>
              </tr>
              <tr>
                  <td align=right><small>1</small></td><!--sim04-->
                  <td align=right><small>$fr_surrisc</small></td>
                  <td align=right><small>$fr_sottoraff</small></td>
                  <td align=right><small>$fr_tcondens</small></td>
                  <td align=right><small>$fr_tevapor</small></td>
                  <td align=right><small>$fr_t_ing_lato_est</small></td>
                  <td align=right><small>$fr_t_usc_lato_est</small></td>
                  <td align=right><small>$fr_t_ing_lato_ute</small></td>
                  <td align=right><small>$fr_t_usc_lato_ute</small></td>
                  <td align=right><small>$fr_nr_circuito</small></td>
              </tr>"

db_foreach q "select progressivo_prova_fumi
                   , fr_surrisc as fr_surrisc_prfumi
                   , fr_sottoraff as fr_sottoraff_prfumi
                   , fr_tcondens as fr_tcondens_prfumi
                   , fr_tevapor as fr_tevapor_prfumi
                   , fr_t_ing_lato_est as fr_t_ing_lato_est_prfumi
                   , fr_t_usc_lato_est as fr_t_usc_lato_est_prfumi
                   , fr_t_ing_lato_ute as fr_t_ing_lato_ute_prfumi
                   , fr_t_usc_lato_ute as fr_t_usc_lato_ute_prfumi
                   , fr_nr_circuito as fr_nr_circuito_prfumi
                from coimdimp_prfumi
               where cod_dimp = :cod_dimp" {#sim04

		   append stampa "
              <tr>
                  <td align=right><small>$progressivo_prova_fumi</small></td>
                  <td align=right><small>$fr_surrisc_prfumi</small></td>
                  <td align=right><small>$fr_sottoraff_prfumi</small></td>
                  <td align=right><small>$fr_tcondens_prfumi</small></td>
                  <td align=right><small>$fr_tevapor_prfumi</small></td>
                  <td align=right><small>$fr_t_ing_lato_est_prfumi</small></td>
                  <td align=right><small>$fr_t_usc_lato_est_prfumi</small></td>
                  <td align=right><small>$fr_t_ing_lato_ute_prfumi</small></td>
                  <td align=right><small>$fr_t_usc_lato_ute_prfumi</small></td>
                  <td align=right><small>$fr_nr_circuito_prfumi</small></td>
              </tr>"


	       }
} else {#gac01 parte per regione marche

    if {$is_only_print_p} {#rom04 Aggiunta if e il suo contenuto

	    append stampa "
                 <table align=center width=100% border=1 cellpadding=2 cellspacing=\"0\">
              <tr>
                  <td><small><small>Num modulo</small></small></td><!--sim04-->
                  <td><small><small>Surriscald.(&deg;C)</small></small></td>
                  <td><small><small>Sottoraffed.(&deg;C)</small></small></td>
                  <td><small><small>T.condens.<sub><small>2</small></sub>(%)</small></small></td>
                  <td><small><small>T.eavapor<sub><small>2</small></sub>(%)</small></small></td>
                  <td><small><small>T ing.lato est</small></small></td>
                  <td><small><small>T usc.lato est</small></small></td>
                  <td><small><small>T ing.lato ute</small></small></td>
                  <td><small><small>T usc.lato ute</small></small></td>
                  <td><small><small>N.Circuito</small></small></td>
              </tr>"

	set num_circuiti_printed 0

	for {set num_circuiti_printed 0} {$num_circuiti_printed < $num_circuiti} {incr num_circuiti_printed} {
	    append stampa "
              <tr>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
              </tr>"


	}
	    append stampa "</table>"

    } else {#rom05 Aggiunta else ma  non il suo contenuto
    
    append stampa "
                 <table align=center width=100% border=1 cellpadding=2 cellspacing=\"0\">
              <tr>
                  <td><small><small>Num modulo</small></small></td><!--sim04-->
                  <td><small><small>Surriscald.(&deg;C)</small></small></td>
                  <td><small><small>Sottoraffed.(&deg;C)</small></small></td>
                  <td><small><small>T.condens.<sub><small>2</small></sub>(%)</small></small></td>
                  <td><small><small>T.eavapor<sub><small>2</small></sub>(%)</small></small></td>
                  <td><small><small>T ing.lato est</small></small></td>
                  <td><small><small>T usc.lato est</small></small></td>
                  <td><small><small>T ing.lato ute</small></small></td>
                  <td><small><small>T usc.lato ute</small></small></td>
                  <td><small><small>N.Circuito</small></small></td>
              </tr>
              <tr>
                  <td align=right><small><small>1</small></small></td><!--sim04-->
                  <td align=right><small><small>$fr_surrisc</small></small></td>
                  <td align=right><small><small>$fr_sottoraff</small></small></td>
                  <td align=right><small><small>$fr_tcondens</small></small></td>
                  <td align=right><small><small>$fr_tevapor</small></small></td>
                  <td align=right><small><small>$fr_t_ing_lato_est</small></small></td>
                  <td align=right><small><small>$fr_t_usc_lato_est</small></small></td>
                  <td align=right><small><small>$fr_t_ing_lato_ute</small></small></td>
                  <td align=right><small><small>$fr_t_usc_lato_ute</small></small></td>
                  <td align=right><small><small>$fr_nr_circuito</small></small></td>
              </tr>"

db_foreach q "select progressivo_prova_fumi
                   , fr_surrisc as fr_surrisc_prfumi
                   , fr_sottoraff as fr_sottoraff_prfumi
                   , fr_tcondens as fr_tcondens_prfumi
                   , fr_tevapor as fr_tevapor_prfumi
                   , fr_t_ing_lato_est as fr_t_ing_lato_est_prfumi
                   , fr_t_usc_lato_est as fr_t_usc_lato_est_prfumi
                   , fr_t_ing_lato_ute as fr_t_ing_lato_ute_prfumi
                   , fr_t_usc_lato_ute as fr_t_usc_lato_ute_prfumi
                   , fr_nr_circuito as fr_nr_circuito_prfumi
                from coimdimp_prfumi
               where cod_dimp = :cod_dimp" {#sim04

		   append stampa "
              <tr>
                  <td align=right><small><small>$progressivo_prova_fumi</small></small></td>
                  <td align=right><small><small>$fr_surrisc_prfumi</small></small></td>
                  <td align=right><small><small>$fr_sottoraff_prfumi</small></small></td>
                  <td align=right><small><small>$fr_tcondens_prfumi</small></small></td>
                  <td align=right><small><small>$fr_tevapor_prfumi</small></small></td>
                  <td align=right><small><small>$fr_t_ing_lato_est_prfumi</small></small></td>
                  <td align=right><small><small>$fr_t_usc_lato_est_prfumi</small></small></td>
                  <td align=right><small><small>$fr_t_ing_lato_ute_prfumi</small></small></td>
                  <td align=right><small><small>$fr_t_usc_lato_ute_prfumi</small></small></td>
                  <td align=right><small><small>$fr_nr_circuito_prfumi</small></small></td>
              </tr>"

	          
	       }
};#rom05
};#gac01
if {$coimtgen(regione) ne "MARCHE"} {#gac01 parte standard
append stampa  "</table>
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
                <td><small><b>PRESCRIZIONI</b> (in attesa di questi interventi l'impianto non pu&ograve; essere messo in funzione): $prescrizioni</small>
              </tr>
              </table>"
} else {#gac01 parte per regione marche

    if {$rct_check_list_1 eq "S"} {
	set img_list_1 $img_checked
    } else {
	set img_list_1 $img_unchecked
    }
    if {$rct_check_list_2 eq "S"} {
	set img_list_2 $img_checked
    } else {
	set img_list_2 $img_unchecked
    }
    if {$rct_check_list_3 eq "S"} {
	set img_list_3 $img_checked
    } else {
	set img_list_3 $img_unchecked
    }
    if {$rct_check_list_4 eq "S"} {
	set img_list_4 $img_checked
    } else {
	set img_list_4 $img_unchecked
    }
    
    append stampa "
             <table>
             <tr><td colspan=2 size=2 nowrap><small><small><b>F. CHECK LIST</b> Elenco di possibili interventi, dei quali va valuta la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica:</small></small></td>
             </tr>
             <tr>
               <td><small><small>$img_list_1 La sostituzione di generatori a regolazione on/off, con altri di pari potenza a più gradini o a regolazione continua.</small></small></td>
               <td><small><small>$img_list_3 L'isolamento della rete di distribuzione acqua refrigerata/calda nei locali non climatizzati.</small></small></td>
             </tr>
             <tr>
               <td><small><small>$img_list_2 La sostituzione dei sistemi di regolazione on/off con sistemi programmabili su più livelli di temperatura.</small></small></td>
               <td><small><small>$img_list_4 L'isolamento dei canali di distribuzione aria fredda/calda nei locali non climatizzati.</small></small></td>
              </tr>
              </table>

              <table width=100% border=0 cellpadding=0 cellspacing=1>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>OSSERVAZIONI</b>:<small><small></td>
                <td width=90%><small><small>$osservazioni</small></small></td>
              </tr>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>RACCOMANDAZIONI</b>:<small><small></td>
                <td width=90%><small><small>$raccomandazioni</small></small></td>
              </tr>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>PRESCRIZIONI</b>:<small><small></td>
                <td width=90%><small><small>$prescrizioni</small></small></td>
              </tr>
              </table>"
}

set lista_anom ""
db_foreach sel_anom "" {
    lappend lista_anom $cod_tanom
}

if {![string equal $lista_anom ""]} {
    append stampa "<table width=100% border=0 cellpadding=0 cellspacing=0>
                     <tr>
                       <td width=10%><small><small>Anomalie presenti:</small></small></td>
                       <td align=left><small><small>"
    foreach anom $lista_anom {
	append stampa " $anom "
    }
    append stampa "    </small></small></td>
                     </tr>
                   </table>"
}


#append stampa "</b></small>
#               </td>
#               </tr>
#               </table>"

if {[string is space $firma_manut]} {
    set firma_manut $manuten
}

if {[string is space $firma_resp]} {
    set firma_resp "$cognome_resp $nome_resp"
}

if {$coimtgen(flag_firma_manu_stampa_rcee) eq "t"} {#rom08 Aggiunta if e il suo contenuto
    set firma_manut "<img src=$img_firma_manuten height=50>"
}
if {$coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {#rom08 Aggiunta if e il suo contenuto
    set firma_resp "<img src=$img_firma_respons height=50>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=1><tr>
                <tr>
                  <td  valign=top align=left class=form_title><small>Il tecnico dichiara, in riferimento ai punti A,B,C,D,E (sopra menzionati)  che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.<b>L'impianto pu&ograve; funzionare</b> [iter_edit_flag_mh $flag_status]</small></td>
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
                  <td colspan=2><small>$costo_bollino<small></td><!-- rom02 -->
               </tr>
               <tr>
                  <td width=50%><small>Firma manutentore <br> $firma_manut</small></td>
                  <td width=50%><small>Firma responsabile <br> $firma_resp</small></td>
               </tr>
    <!-- rom08 <tr>
                  <td><small>$firma_manut</small></td>
                  <td><small>$firma_resp</small></td>
               </tr> -->
             </table>"
} else {#gac01 parte per regione marche
    if {$flag_status eq "P"} {
	#rom05set img_funz $img_checked
        set img_funz_si $img_checked;#rom05
	set img_funz_no $img_unchecked;#rom05
    } elseif {$flag_status eq "O_P"} {#rom05 Aggiunta elseif e suo contenuto
	#Se sto stampando la dichiarazione precompilata non devo avere nessuna casella checkata
	set img_funz_no $img_unchecked
	set img_funz_si $img_unchecked	
    } else {
	#rom05set img_funz $img_unchecked
	set img_funz_no $img_checked;#rom05
	set img_funz_si $img_unchecked;#rom05
    }
    append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=0>
                <tr>
                  <td valign=top align=left class=form_title><small><small><b>Il tecnico dichiara, in riferimento ai punti A,B,C,D,E (sopra menzionati)  che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.</b></small></small></td>
                </tr>
                <tr>
                  <td valign=top align=left class=form_title><small><small><b>L'impianto pu&ograve; funzionare $img_funz_si Sì $img_funz_no No</b></small></small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align=center>
            <table width=100%>
              <tr>
                <td valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissione dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo, a provvedere alla loro risoluzione dandone notizia all'operatore incaricato.</small></small></td>
              </tr>
              <tr>
                <td valign=top align=left class=form_title><small><small>Si raccomanda un intervento manutentivo entro il $data_prox_manut</small></small></td>
              </tr>
            </table>
          </td>
          </tr>
          <tr>
            <td align=center>
             <table width=100% border=0 cellpadding=1 cellspacing=1>
               <tr>               
                 <td width=33%><small><small>Data del presente controllo $data_controllo</small></small></td>
                 <td><small><small>Orario di arrivo/partenza presso l'impianto $ora_inizio / $ora_fine</small></small></td>
               </tr>
               <tr>
                 <td colspan=2><small><small>Tecnico che ha effettato il controllo: Nome e cognome: $operatore </small></small></td>
               </tr>
               <tr>
                 <td width=50%><small><small>Firma leggibile del tecnico</small></small></td>
                 <td width=50%><small><small>Firma leggibile, per presa visione, del responsabile dell'impianto</small></small></td>
               </tr>
               <tr>
                 <td><small>$firma_manut</small></td>
                 <td><small>$firma_resp</small></td>
               </tr>
             </table>
            </td>
          </tr>
        </table>"
}

# creo file temporaneo html
set stampa1 $testata
append stampa1 $stampa
append stampa2 $testata2
append stampa2 $stampa

};#rom04

set stampa2 "<!-- HEADER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\" -->$stampa2";#rom04


# imposto il nome dei file
set nome_file        "stampa RCEE"
set nome_file_originale  "$nome_file.pdf";#sim03
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
		
		#rom06 Aggiunta condizione su Palermo
		if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim03 if e suo contenuto	    
		    
		    set path_file [iter_permanenti_file_salva $contenuto_tmpfile $nome_file_originale]
		    
		    db_dml q "update coimdocu
		  	             set tipo_contenuto = :tipo_contenuto
			               , path_file      = :path_file
			           where cod_documento  = :cod_documento"
		     
		} else {#sim03
		    db_dml dml_sql3 [db_map upd_docu_3]
		};#sim03
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

} else {#sim03 else e suo contenuto
    set path_file $file_pdf
}
ns_unlink $file_html

if {$img_firma_manuten ne ""} {#rom08 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_manuten
}

if {$img_firma_respons ne ""} {#rom08 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_respons
}


#rom06 Aggiunta condizione su Palermo
if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim03 if e suo contenuto	    
    ns_returnfile 200 $tipo_contenuto $path_file
    return
} else {#sim03    
    ad_returnredirect $file_pdf_url
    ad_script_abort
};#sim03
