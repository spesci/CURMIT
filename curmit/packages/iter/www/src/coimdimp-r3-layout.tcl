ad_page_contract {
    Stampa modello RCEE impianto
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coimdimp-layout.tcl
 
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom11 25/11/2024 Sandro ha chiesto di riportare la modifica di rom09 fatta per Caserta anche per
    rom11            Frosinone: il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom10 23/05/2024 Se è attivo l'apposito parametro riporto la campagna di riferimento.

    rom09 11/04/2024 Sandro ha chiesto di riportare la modifica di rom08 fatta per Rieti anche per Caserta:
    rom09            il codice bollino sara' valorizzato con il valore dell'id cod_dimp

    rom08 04/12/2023 Sandro ha chiesto di riportare la modifica di rom07 per Napoli anche per Rieti:
    rom08            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom07 13/11/2023 Sandro ha chiesto di riportare la modifica di rom05 fatta per Palermo anche per Napoli:
    rom07            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom06 28/11/2022 Aggiunta possibilita' di stampare gli rcee con la firma grafometrica in base
    rom06            ai parametri flag_firma_manu_stampa_rcee e flag_firma_resp_stampa_rcee.

    rom05 07/12/2022 Implementazione per Palermo richiesta con mail "Implementazioni" di Sandro del 01/12/2022, riporto testo:
    rom05            Inserimento di un codice bollino nell'apposito campo del Rapporto di controllo. Tale codice sarà uguale a
    rom05            quello del  campo  progressivo inserimento. Per gli impianti con piu' generatori il codice bollino sarà
    rom05            rilasciato solo sul primo generatore dove è presente il contributo.
    rom05            Tale implementazionzione riguarda tutte le tipologie di RCEE e le stampe. Il numero di bollino potrà essere
    rom05            rilasciato solo al momento dell'inserimento. L'implementazione sara' visibile solo per Palermo.

    rom04 02/11/2022 Palermo salva gli allegati su file system.

    rom03 23/03/2022 Su richiesta di Giuliodori rivisti alcune modifiche di rom02.

    rom02 16/03/2022 MEV Regione Marche punto 6. Stampa RCEE precompilato senza dati del
    rom02            Controllo del rendimento di combustione. 

    rom01 12/04/2021 Corretta sezione C.TRATTAMENTO DELL'ACQUA per Regione Marche.

    sim04 08/04/2019 Gestito il salvataggio degli allegati sul file system

    gac01 15/01/2019 Modificata stampa per regione marche, quasi ogni modifica è riportata in
    gac01            una if solo per regione marche

    ale01 07/03/2017 Fatto in modo che se la matricola contiene > o < l'html venga scritto
    ale01            correttamente.

    sim03 23/11/2016 Per Reggio Calabria aggiungo un secondo logo nella stampa

    sim02 17/10/2016 In caso di bollino virtuale visualizzo il prezzo.

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
    {is_only_print_p      "f"}
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

if {$is_only_print_p} {#rom02 Aggiunta if e sil suo contenuto
    
    set sel_dimp "sel_gend_only_print"
    
    set sel_aimp "sel_aimp_only_print"

    set tr_da_agg "<tr><td><small><small>&nbsp;</small></small></td></tr>";#rom03
    
} else {#rom02 Aggiunta else ma non il suo contenuto
    
    if {$flag_viario == "T"} {
	set sel_dimp "sel_dimp_si_vie"
    } else {
	set sel_dimp "sel_dimp_no_vie"
    }
    
    set sel_aimp "sel_aimp";#rom02
    set tr_da_agg "";#rom03
    
};#rom02

#rom02if {[db_0or1row $sel_dimp ""] == 0} {
    # codice non trovato
#rom02    iter_return_complaint  "Dati Impianto non trovati</li>"
#rom02    return
#rom02 }

set img_firma_manuten $spool_dir/$cod_dimp-M-immagine.png;#rom06
set img_firma_respons $spool_dir/$cod_dimp-C-immagine.png;#rom06

if {[file exists $img_firma_manuten] == 0} {#rom06 Aggiunta if e il suo contenuto
    set img_firma_manuten ""
}

if {[file exists $img_firma_respons] == 0} {#rom06 Aggiunta if e il suo contenuto
    set img_firma_respons ""
}

set n_page 0;#rom02
db_foreach $sel_dimp "" {#rom02 Aggiunta foreach ma non il suo contenuto
    
    set stampa "";#rom02
    
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

incr n_page;#rom02

if {$coimtgen(regione) eq "MARCHE"} {#gac01 if e suo contenuto
    set height "height=10"
} else {
    set height ""
}

if {$n_page > 1} {#rom02 Aggiunta if e suo contenuto
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

#rom02set stampa "<table>"

append stampa "<table width=100% border=0>";#rom02

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
    set operatore "_______________________________________";#rom03 
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

    #rom07 Aggiunta condizione su PNA
    #rom08 Aggiunta condizione su PRI
    #rom09 Aggiunta condizione su PCE
    #rom11 Aggiunta condizione su PFR
    if {$coimtgen(ente) in [list "PPA" "PNA" "PRI" "PCE" "PFR"] && $riferimento_pag ne ""} {#rom05 Aggiunta if e il suo contenuto
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

    if {$coimtgen(ente) eq "PRC"} {;#sim03 if e suo contenuto
	
	set master_logo_dx_nome [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
	set logo_dx "<img src=$logo_dir/$master_logo_dx_nome $height_logo align=right>"
	
    }
} else {
    set logo_dx "";#sim03
    set logo ""
}

append testata2 "
<table width=100%>
  <tr>
    <td width=100% align=center>"

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
    append testata2 "
      <table width=100%>
        <tr>
          <td width=20%>$logo</td>
          <td width=60% align=center>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
#rom06append testata2 "
#            <table>
#              <tr><td align=center><b><small>$ente</small></b></td></tr>
#              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
#              <tr><td align=center><small>$assessorato</small></td></tr>
#              <tr><td align=center><small>$indirizzo_ufficio</small></td></tr>
#              <tr><td align=center><small>$telefono_ufficio</small></td></tr>
#rom06       </table>"
    append testata2 "
            <table>
              <tr><td align=center><b><small>$ente</small></b></td></tr>
              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
              <tr><td align=center><small>$assessorato $indirizzo_ufficio $telefono_ufficio </small></td></tr>
       </table>";#rom06
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

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto
append testata2 "
      <table width=100% border>
        <tr>
          <td colspan=2 align=center>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 3 (SCAMBIATORI)
        </tr>
      </table>"
} else {
    append testata2 "
      <table width=100% border>
        <tr>
          <td colspan=2 align=center><small>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 3 (scambiatori)</small></td>
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

#if {$tipologia_costo eq "LM"} {;#sim02 if e else e loro contenuto
#    set costo_bollino "Bollino virtuale: $costo_pretty euro"
#} else {
#    set costo_bollino ""
#}

regsub -all {<} $matricola {\&lt;} matricola; #ale01
regsub -all {>} $matricola {\&gt;} matricola; #ale01

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

<tr><td>&nbsp;</td></tr>
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

if {$coimtgen(regione) ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
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
                  <tr>
                  <td><small><small>Durezza °fr</small></small></td>
                  <td><small><small>$rct_dur_acqua</small></small></small></td>
                  <td><small><small>Trattamento in riscaldamento -Non(R)ichiesto-(A)ssente-(F)iltrazione-A(D)dolcimento-Cond.(C)himico</small></small></td>
                  <td><small><small>$rct_tratt_in_risc</small></small></td>
                  </tr>
                  <tr><td><small><small>Trattamento in ACS  -Non(R)ichiesto-(A)ssente-(F)iltrazione-A(D)dolcimento-Cond.(C)himico</small></small></td>
                  <td><small><small>$rct_tratt_in_acs</small></small></td>

              </tr>
              <tr><td colspan=2 size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO</b></small></small></td>
              </tr>

              <tr><td><small><small>Luogo di installazione idoneo</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $idoneita_locale]</small></small></td>
                  <td><small><small>Stato delle coibentazioni idoneo</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $tel_stato_coibent_idoneo_imp]</small></small></td>
              </tr>
              <tr><td><small><small>Linee elettriche idonee</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $tel_linee_eletr_idonee]</small></small></td>
                  <td><small><small>Assenza perdite del circuito idraulico</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $tel_assenza_perdite_circ_idraulico]</small></small></td>
              </tr>"
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
    
    #rom01 Aggiunti switch per i valori:
    #rom01 K: Filtr. + Addolc.
    #rom01 J: Filtr. + Cond.Ch.
    #rom01 W: Cond.Ch. + Addolc.
    #rom01 T: Filt. + Cond.Ch. + Addolc.

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

    #rom01 Aggiunti switch per i valori:
    #rom01 K: Filtr. + Addolc.
    #rom01 J: Filtr. + Cond.Ch.
    #rom01 W: Cond.Ch. + Addolc.
    #rom01 T: Filt. + Cond.Ch. + Addolc.

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
	"K" {
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"J" {
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"W" {
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"T" {
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
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
    if {$idoneita_locale eq "C"} {
	set img_idoneita_nc $img_checked
    } else {
	set img_idoneita_nc $img_unchecked
    }
    if {$tel_linee_eletr_idonee eq "S"} {
	set img_tel_linee_ele_s $img_checked
    } else {
	set img_tel_linee_ele_s $img_unchecked
    }
    if {$tel_linee_eletr_idonee eq "N"} {
	set img_tel_linee_ele_n $img_checked
    } else {
	set img_tel_linee_ele_n $img_unchecked
    }
    if {$tel_linee_eletr_idonee eq "C"} {
	set img_tel_linee_ele_nc $img_checked
    } else {
	set img_tel_linee_ele_nc $img_unchecked
    }

    if {$tel_stato_coibent_idoneo_imp eq "S"} {
	set img_tel_coibentazione_imp_s $img_checked
    } else {
	set img_tel_coibentazione_imp_s $img_unchecked
    }
    if {$tel_stato_coibent_idoneo_imp eq "N"} {
	set img_tel_coibentazione_imp_n $img_checked
    } else {
	set img_tel_coibentazione_imp_n $img_unchecked
    }
    if {$tel_stato_coibent_idoneo_imp eq "C"} {
	set img_tel_coibentazione_imp_nc $img_checked
    } else {
	set img_tel_coibentazione_imp_nc $img_unchecked
    }

    if {$tel_assenza_perdite_circ_idraulico eq "S"} {
	set img_tel_assenza_perd_s $img_checked
    } else {
	set img_tel_assenza_perd_s $img_unchecked
    }
    if {$tel_assenza_perdite_circ_idraulico eq "N"} {
	set img_tel_assenza_perd_n $img_checked
    } else {
	set img_tel_assenza_perd_n $img_unchecked
    }
    if {$tel_assenza_perdite_circ_idraulico eq "C"} {
	set img_tel_assenza_perd_nc $img_checked
    } else {
	set img_tel_assenza_perd_nc $img_unchecked
    }

    if {$flag_clima_invernale eq "S"} {
	set img_clima_inv $img_checked
    } else {
	set img_clima_inv $img_unchecked
    }
    if {$flag_prod_acqua_calda eq "S"} {
	set img_prod_acqua $img_checked
    } else {
	set img_prod_acqua $img_unchecked
    }

    set check_ali_acq "<img src=$logo_dir/check-out.gif height=10>"
    set check_ali_surr "<img src=$logo_dir/check-out.gif height=10>"
    set check_ali_vap "<img src=$logo_dir/check-out.gif height=10>"
    set altro_ali "<img src=$logo_dir/check-out.gif height=10>"
    switch $tel_alimentazione_tel {
	"A" {
	    set check_ali_acq "<img src=$logo_dir/check-in.gif height=10>"
	}
	"B" {
	    set check_ali_surr "<img src=$logo_dir/check-in.gif height=10>"
	}
	"C" {
	    set check_ali_vap "<img src=$logo_dir/check-in.gif height=10>"
	}
	"Z" {
	    set altro_ali "<img src=$logo_dir/check-in.gif height=10>"
	}
    }
    
    set check_fluid_acq "<img src=$logo_dir/check-out.gif height=10>"
    set check_fluid_vap "<img src=$logo_dir/check-out.gif height=10>"
    set altro_fluid "<img src=$logo_dir/check-out.gif height=10>"
    switch $tel_fluido_vett_term_uscita_tel {
        "A" {
	    set check_fluid_acq "<img src=$logo_dir/check-in.gif height=10>"
	}
	"B" {
	    set check_fluid_vap "<img src=$logo_dir/check-in.gif height=10>"
	}
	"Z" {
	    set altro_fluid "<img src=$logo_dir/check-in.gif height=10>"
	}
    }

    if {$tel_potenza_compatibile_dati_prog eq "S"} {
	set img_tel_pot_comp_s $img_checked
    } else {
	set img_tel_pot_comp_s $img_unchecked
    }
    if {$tel_potenza_compatibile_dati_prog eq "N"} {
	set img_tel_pot_comp_n $img_checked
    } else {
	set img_tel_pot_comp_n $img_unchecked
    }
    if {$tel_potenza_compatibile_dati_prog eq "C"} {
	set img_tel_pot_comp_nc $img_checked
    } else {
	set img_tel_pot_comp_nc $img_unchecked
    }

    if {$tel_stato_coibent_idoneo_scamb eq "S"} {
	set img_tel_coibentazione_scamb_s $img_checked
    } else {
	set img_tel_coibentazione_scamb_s $img_unchecked
    }
    if {$tel_stato_coibent_idoneo_scamb eq "N"} {
	set img_tel_coibentazione_scamb_n $img_checked
    } else {
	set img_tel_coibentazione_scamb_n $img_unchecked
    }
    if {$tel_stato_coibent_idoneo_scamb eq "C"} {
	set img_tel_coibentazione_scamb_nc $img_checked
    } else {
	set img_tel_coibentazione_scamb_nc $img_unchecked
    }
    
    if {$tel_disp_regolaz_controll_funzionanti eq "S"} {
	set img_tel_disp_reg_s $img_checked
    } else {
	set img_tel_disp_reg_s $img_unchecked
    }
    if {$tel_disp_regolaz_controll_funzionanti eq "N"} {
	set img_tel_disp_reg_n $img_checked
    } else {
	set img_tel_disp_reg_n $img_unchecked
    }
    if {$tel_disp_regolaz_controll_funzionanti eq "C"} {
	set img_tel_disp_reg_nc $img_checked
    } else {
	set img_tel_disp_reg_nc $img_unchecked
    }
    
    if {$tel_assenza_trafil_valv_regolaz eq "S"} {
	set img_tel_assenza_trafil_s $img_checked
    } else {
	set img_tel_assenza_trafil_s $img_unchecked
    }
    if {$tel_assenza_trafil_valv_regolaz eq "N"} {
	set img_tel_assenza_trafil_n $img_checked
    } else {
	set img_tel_assenza_trafil_n $img_unchecked
    }
    if {$tel_assenza_trafil_valv_regolaz eq "C"} {
	set img_tel_assenza_trafil_nc $img_checked
    } else {
	set img_tel_assenza_trafil_nc $img_unchecked
    }

    append stampa "
              </table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
              <tr><td width=40% size=3><small><small><b>B. DOCUMENTAZIONE TECNICA A CORREDO</b></small></small></td>
                  <td width=10%><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  <td width=40%>&nbsp;</td>
                  <td width=10%><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
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
                  Condiz.chimico <!--rom01$check_altro Altro--></small></small></td>
                  </tr>
                  <tr>
                  <td>&nbsp;</td>
                  <td><small><small>Trattamento in ACS:</small></small></td>
                  <td><small><small> $check_r1 Non richiesto $check_a1 Assente $check_f1 Filtrazione $check_d1 Addolcimento $check_c1
                  Condiz.chimico <!--rom01 $check_altro1 Altro--></small></small></td>
              </tr>
              </table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
                  <tr>
                  <td size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO (esami visivi)</b></small></small></td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  <td>&nbsp;</td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Locale di installazione idoneo</small></small></td>
                  <td width=10%><small><small>$img_idoneita_s $img_idoneita_n $img_idoneita_nc </small></small></td>
                  <td width=40%><small><small>Stato delle coibentazioni idoneo</small></small></td>
                  <td width=10%><small><small>$img_tel_coibentazione_imp_s $img_tel_coibentazione_imp_n $img_tel_coibentazione_imp_nc </small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Linee elettriche idonee</small></small></td>
                  <td width=10%><small><small>$img_tel_linee_ele_s $img_tel_linee_ele_n $img_tel_linee_ele_nc </small></small></td>
                  <td width=40%><small><small>Assenza perdite dal circuito idraulico</small></small></td>
                  <td width=10%><small><small>$img_tel_assenza_perd_s $img_tel_assenza_perd_n $img_tel_assenza_perd_nc</small></small></td>
                  </tr>
              </table>
              <table width=100%>
              <tr><td size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DELLO SCAMPBIATORE SC $gen_prog_est </b></small></small></td>
              </tr>
              <tr>
                  <td valign=top width=50% align=left class=form_title><small><small>Fabbricante $descr_cost</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$img_clima_inv Climatizzazione invernale $img_prod_acqua Produzione ACS</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Modello $modello</small></small></td>
                  <td valign=top align=left class=form_title><small><small>Potenza termica nominale $potenza (kW)</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Matricola $matricola</small></small></td>
                  <td valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
              </tr>
              </table>
              <table width=100%>
              <tr>
                  <td width=20% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=30% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=40% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=10% valign=top align=left><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>Alimentazione:</small></small></td>
                  <td><small><small>$check_ali_acq Acqua calda $check_ali_surr Acqua surriscaldata</small></small></td>
                  <td><small><small>Potenza compatibile con i dati di progetto</small></small></td>
                  <td><small><small>$img_tel_pot_comp_s $img_tel_pot_comp_n $img_tel_pot_comp_nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>&nbsp;</small></small></td>
                  <td><small><small>$check_ali_vap Vapore $altro_ali Altro: $tel_alimentazione_altro</small></small></td>
                  <td><small><small>Stato delle coibentazioni idoneo</small></small></td>
                  <td><small><small>$img_tel_coibentazione_scamb_s $img_tel_coibentazione_scamb_n $img_tel_coibentazione_scamb_nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>Fluido vettore termico in uscita:</small></small></td>
                  <td><small><small>$check_fluid_acq Acqua calda</small></small></td>
                  <td><small><small>Dispositivi di regolazione e controllo funzionanti</small></small></td>
                  <td><small><small>$img_tel_disp_reg_s $img_tel_disp_reg_n $img_tel_disp_reg_nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>&nbsp;</small></small></td>
                  <td><small><small>$check_fluid_vap Vapore $altro_fluid Altro: $tel_fluido_altro</small></small></td>
                  <td><small><small>Assenza di trafilamenti sulla valvola di regolazione</small></small></td>
                  <td><small><small></small></small></td>
              </tr>
              </table>
<br>"
}
if {$coimtgen(regione) ne "MARCHE"} {#gac01 if e suo contenuto
    append stampa "
              <table>
                <tr>
                  <td colspan=2 size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DELLO SCAMBIATORE</b></small></small></td>
                  <tr>
                    <td valign=top align=left class=form_title><small>Fabbricante: $descr_cost</small></td>
                    <td valign=top align=left class=form_title><small>Destinazione: $destinazione</small></td>
                  </tr>
                  <tr>
                    <td valign=top align=left class=form_title><small>Modello: $modello</small></td>
                    <td valign=top align=left class=form_title><small>Potenza termica nominale: $potenza (kW)</small></td>
                  </tr>
                  <tr>
                    <td valign=top align=left class=form_title><small>Matricola: $matricola</small></td>
                    <td valign=top align=left class=form_title><small>Pot. term. nom. al focolare: $pot_focolare_nom (kW)</small></td>
                  <tr>
                    <td></td>
                    <td valign=top align=left class=form_title><small>Data installazione: $data_installaz</small><td>
                  </tr>
                </tr>
                <tr>
                  <tr>
                    <td valign=top align=left class=form_title><small>Alimentazione: $tel_alimentazione</small></td>
                    <td valign=top align=left class=form_title><small>Potenza compatibile con i dati di progetto: [iter_edit_flag_mh $tel_potenza_compatibile_dati_prog]</small></td>
                  </tr>
                  <tr>
                    <td valign=top align=left class=form_title><small>Fluido vettore termico in uscita: $tel_fluido_vett_term_uscita</small></td>
                    <td valign=top align=left class=form_title><small>Stato delle coibentazioni idoneo: [iter_edit_flag_mh $tel_stato_coibent_idoneo_scamb]</small></td>
                  </tr>
                  <tr>
                    <td></td>
                    <td valign=top align=left class=form_title><small>Dispositivi di regolazione e controllo funzionanti: [iter_edit_flag_mh $tel_disp_regolaz_controll_funzionanti]</small></td>
                  </tr>
                  <tr>
                    <td></td>
                    <td valign=top align=left class=form_title><small>Assenza di trafilamenti sulla valvola di regolazione</small></td>
                  </tr>
                </tr>
              </table>
"
}
if {$coimtgen(regione) ne "MARCHE"} {#gac01 aggiunta if else e contenuto di else
append stampa "
              <table align=center width=100% border=1 cellpadding=3 cellspacing=\"0\">
                <tr>
                  <td><small>Temperatura esterna</small></td>
                  <td><small>Temperatura mandata Primario</small></td>
                  <td><small>Temperatura ritorno Primario</small></td>
                  <td><small>Potenza termica</small></td>
                </tr>
                <tr>
                  <td align=right><small>$tel_temp_est &deg;C</small></td>
                  <td align=right><small>$tel_temp_mand_prim &deg;C</small></td>
                  <td align=right><small>$tel_temp_rit_prim &deg;C</small></td>
                  <td align=right><small>$tel_potenza_termica kW</small></td>
                </tr>
                <tr>
                  <td><small>Portata fluido Primario</small></td>
                  <td><small>Temperatura mandata Secondario</small></td>
                  <td><small>Temperatura ritorno Secondario</small></td>
                </tr>
                <tr>
                  <td align=right><small>$tel_portata_fluido_prim m<sup><small>3</small></sup>/h</small></td>
                  <td align=right><small>$tel_temp_mand_sec &deg;C</small></td>
                  <td align=right><small>$tel_temp_rit_sec &deg;C</small></td>
                </tr>
              </table>"
} else {#gac01
    append stampa "
              <table align=center width=100% border=1 cellpadding=0 cellspacing=\"0\">
              <tr><td width=25%><table align=center width=100% border=0 cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Temperatura esterna</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_temp_est &deg;C</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Temperatura mandata Primario</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_temp_mand_prim &deg;C</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                  <td><small><small>Temperatura ritorno Primario</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_temp_rit_prim &deg;C</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Potenza termica</small></small></td>
                </tr> 
                <tr>
                  <td align=right><small><small>$tel_potenza_termica kW</small></small></td>
                </tr>
              </table></td></tr>
              <tr><td><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Portata fluido Primario</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_portata_fluido_prim m<sup><small>3</small></sup>/h</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Temperatura mandata Secondario</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_temp_mand_sec &deg;C</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>Temperatura ritorno Secondario</small></small></td>
                </tr>
                <tr>
                  <td align=right><small><small>$tel_temp_rit_sec &deg;C</small></small></td>
                </tr>
              </table></td>
              <td width=25%><table align=center width=100% cellpadding=1 cellspacing=\"0\">
                <tr>
                  <td><small><small>&nbsp;</small></small></td>
                </tr>
                <tr>
                  <td><small><small>&nbsp;</small></small></td>
                </tr>
              </table></td></tr>
              </table>
"
}

if {$coimtgen(regione) ne "MARCHE"} {#gac01 parte standard
    append stampa "
              <table>
                <tr><td colspan=2 size=2><small><b>F. CHECK LIST</b></small></td> </tr>
                <tr><td valign=top align=left class=form_title><small>Elenco di possibili interventi, dei quali va valuta la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica</b></small></td></tr>
                <tr><td><small>$rct_check_list_1   - Adozione di valvole termostatiche</small></td></tr>
                <tr><td><small>$tel_check_coerenza_paramentri   - Verifica coerenza tra parametri della curva climatica impostati sulla centralina ed i valori di temperatura ambiente</small></td></tr>
                <tr><td><small>$tel_check_perdite_h2o   - Verifica presenza perdite acqua</small></td></tr>
                <tr><td><small>$tel_check_install_involucro   - Installazione di adeguato 'involucro' di coibentazione per lo scambiatore, se non presente</small></td></tr>
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
                  <td><small><b>PRESCRIZIONI</b> (in attesa di questi interventi l'impianto non pu&ograve; essere messo in funzione): $prescrizioni
              </tr>
              </table>"
} else {#gac01 parte per regione marche

    if {$rct_check_list_1 eq "S"} {
	set img_list_1 $img_checked
    } else {
	set img_list_1 $img_unchecked
    }
    if {$tel_check_coerenza_paramentri eq "S"} {
	set img_list_2 $img_checked
    } else {
	set img_list_2 $img_unchecked
    }
    if {$tel_check_perdite_h2o eq "S"} {
	set img_list_3 $img_checked
    } else {
	set img_list_3 $img_unchecked
    }
    if {$tel_check_install_involucro eq "S"} {
	set img_list_4 $img_checked
    } else {
	set img_list_4 $img_unchecked
    }

    append stampa "
              <table width=100% border=0 cellpadding=1 cellspacing=0>
                   <tr><td colspan=2 size=2><small><small><b>F. CHECK LIST</b></small></small></td></tr>
                   <tr><td  valign=top align=left class=form_title><small><small>Elenco dei possibili interventi, dei quali va valutata la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica:</small></small></td></tr>
                   <tr><td><small><small>$img_list_1 L'adozione di valvole termostatiche sui corpi scaldanti</small></small></td></tr>
                   <tr><td><small><small>$img_list_2 Verifica coerenza tra parametri della curva climatica impostati sulla centralina ed i valori di temperatura ambiente</small></small></td></tr>
                   <tr><td><small><small>$img_list_3 Verifica presenza perdite di acqua</small></small></td></tr>
                   <tr><td><small><small>$img_list_4 Installazione di adeguato involucro di coibentazione per lo scambiatore se non presente</small></small></td></tr>
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
                <td width=90%><small><small> $raccomandazioni</small></small></td>
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

if {$coimtgen(flag_firma_manu_stampa_rcee) eq "t"} {#rom06 Aggiunta if e il suo contenuto
    set firma_manut "<img src=$img_firma_manuten height=50>"
}
if {$coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {#rom06 Aggiunta if e il suo contenuto
    set firma_resp "<img src=$img_firma_respons height=50>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac01 if else e contenuto (parte standard)
    append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=1><tr>
                <tr>
                  <td  valign=top align=left class=form_title><small>Il tecnico dichiara,in riferimento ai punti A,B,C,D,E (sopra menzionati), che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.<b>L'impianto pu&ograve; funzionare</b> [iter_edit_flag_mh $flag_status]</small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr><td align=center><table width=100% ><tr>
            <td  valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissione dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo a provvedere alla loro risoluzione dandone notizia all'operatore incaricato. Si raccomanda un intervento manutentivo entro il $data_prox_manut</small></small></td>
          </tr>
          </table>
        </td>
      </tr>
             <table width=100% border=0 cellpadding=2 cellspacing=0>
               <tr>
                    <td colspan=2><small><b>TECNICO CHE HA EFFETTUATO IL CONTROLLO:</b></small></td>
               </tr>
               <tr>
                  <td colspan=2><small>Nome e cognome: $operatore </small></td>
               </tr>
               <tr>
                  <td colspan=2><small>Indirizzo $indir_man<small>
               </tr>
               <tr>
                  <td><small><u>Orario di arrivo presso l'impianto $ora_inizio</u></small></td>
                  <td><small><u>Orario di partenza dall'impianto $ora_fine</u></small></td>
               </tr>
               <tr>
                  <td colspan=2><small>$costo_bollino<small></td><!-- sim02 -->
               </tr>
               <tr>
                  <td width=50%><small>Firma manutentore <br> $firma_manut</small></td>
                  <td width=50%><small>Firma responsabile <br> $firma_resp</small></td>
               </tr>
   <!--rom06   <tr>
                  <td><small>$firma_manut</small></td>
                  <td><small>$firma_resp</small></td>
               </tr> -->
             </table>"
} else {#gac01 parte per regione marche
    if {$flag_status eq "P"} {
	#rom02set img_funz $img_checked
	set img_funz_si $img_checked;#rom02
	set img_funz_no $img_unchecked;#rom02
    } elseif {$flag_status eq "O_P"} {#rom02 Aggiunta elseif e suo contenuto
	#Se sto stampando la dichiarazione precompilata non devo avere nessuna casella checkata
	set img_funz_no $img_unchecked
	set img_funz_si $img_unchecked	
    } else {
	#rom02set img_funz $img_unchecked
	set img_funz_no $img_checked;#rom02
	set img_funz_si $img_unchecked;#rom02
    }
    append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=0>
                <tr>
                  <td valign=top align=left class=form_title><small><small><b>Il tecnico dichiara, in riferimento ai punti A,B,C,D,E (sopra menzionati), che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.</b></small></small></td>
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
                <td valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissioni dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo, a provvedere alla loro risoluzione dandone notizia all'operatore incaricato.</small></small></td>
              </tr>
              <tr>
                <td valign=top align=left class=form_title><small><small>Si raccomanda un intervento manutentivo entro il $data_prox_manut</small></small></td>
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

};#rom02

set stampa2 "<!-- HEADER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\" -->$stampa2";#rom02

# imposto il nome dei file
set nome_file        "stampa RCEE"
set nome_file_originale  "$nome_file.pdf";#sim04
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
		#rom04 Aggiunta condizione su Palermo
		if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim05 if e suo contenuto	    
				    
		    set path_file [iter_permanenti_file_salva $contenuto_tmpfile $nome_file_originale]
		    
		    db_dml q "update coimdocu
		  	             set tipo_contenuto = :tipo_contenuto
			               , path_file      = :path_file
			           where cod_documento  = :cod_documento"
		     
		} else {#sim04
		    db_dml dml_sql3 [db_map upd_docu_3]
		};#sim04
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

} else {#sim04 else e suo contenuto
    set path_file $file_pdf
}

ns_unlink $file_html

if {$img_firma_manuten ne ""} {#rom06 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_manuten
}

if {$img_firma_respons ne ""} {#rom06 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_respons
}

#rom04 Aggiunta condizione su Palermo
    if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim04 if e suo contenuto
    ns_returnfile 200 $tipo_contenuto $path_file
    return
} else {#sim04
    ad_returnredirect $file_pdf_url
    ad_script_abort
};#sim04
