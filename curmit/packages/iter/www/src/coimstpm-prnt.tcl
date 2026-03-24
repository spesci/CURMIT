ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimstpm"

    @author          Tania Masullo Adhoc
    @creation-date   17/08/2005

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimstpm-prnt.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 17/12/2020 Corretto errore sull'inserimento della stampa per la regione marche.
    rom02            Sandro ha detto che si può scegliere solo il formato pdf.

    rom01 05/12/2018 Aggiunta variabile importo_pagamento su richiesta di Sandro.

    san01 06/02/2018 Aggiunto campo pec,prescrizioni,osservazioni e raccomanazioni e corretto
    san01            controllo sul protocollo

    gab01 07/07/2016 Su richiesta di A.F.E. e di Sandro, vanno lette le anomalie della
    gab01            coimdimp.
} {
    {id_stampa         ""}
    {tipo_stampa       ""}
    {cod_impianto      ""}
    {last_cod_impianto ""}
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {extra_par         ""}
    {url_list_aimp     ""}
    {url_aimp          ""}
    {cod_rgen          ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

if {[db_0or1row sel_stpm {}] == 0} {
    iter_return_complaint "Record non trovato"
}

# Personalizzo la pagina
set main_directory   [ad_conn package_url]

set button_label "Stampa" 
set page_title   $descrizione_stampa

set link_list [export_url_vars caller funzione nome_funz nome_funz_caller $url_list_aimp $url_aimp]

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
			  [list "javascript:window.close()" "Torna alla Gestione"] \
			  [list coimstpm-menu?$link_list "Stampa Documento"] \
			  "$page_title"]
}


iter_get_coimtgen;#rom02

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstpm"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name id_protocollo \
    -label   "Protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 25 maxlength 25 class form_element" \
    -optional

element create $form_name protocollo_dt \
    -label   "Data protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element" \
    -optional

if {$campo1 != ""} {
    element create $form_name $campo1_testo \
	-label   "Nome variabile 1" \
	-widget   text \
	-datatype text \
	-html    "size 25 maxlength 25 class form_element" \
	-optional 
}

if {$campo2 != ""} {
    element create $form_name $campo2_testo \
	-label   "Nome variabile 2" \
	-widget   text \
	-datatype text \
	-html    "size 25 maxlength 25 class form_element" \
	-optional 
}

if {$campo3 != ""} {
    element create $form_name $campo3_testo \
	-label   "Nome variabile 3" \
	-widget   text \
	-datatype text \
	-html    "size 25 maxlength 25 class form_element" \
	-html    "cols 80 rows 3 class form_element" \
	-optional 
}

if {$campo4 != ""} {
    element create $form_name $campo4_testo \
	-label   "Nome variabile 4" \
	-widget   text \
	-datatype text \
	-html    "size 25 maxlength 25 class form_element" \
	-optional 
}

if {$campo5 != ""} {
    element create $form_name $campo5_testo \
	-label   "Nome variabile 5" \
	-widget   text \
	-datatype text \
	-html    "size 25 maxlength 25 class form_element" \
	-optional 
}

if {$var_testo == "S"} {
    element create $form_name nota\
	-label   "Nota" \
	-widget   textarea \
	-datatype text \
	-html    "cols 107 rows 10 class form_element" \
	-optional
}

# creo radio button per scegliere se stampare un pdf o un doc
set options_swc_formato ""
set logo_dir_url [iter_set_logo_dir_url]
lappend options_swc_formato [list "<img src=\"$logo_dir_url/pdf.gif\" border=\"0\"> Pdf" "pdf"]
#rom02 Sandro vuole che si possa scegliere solo il formato pdf 
#lappend options_swc_formato [list "<img src=\"$logo_dir_url/doc.gif\" border=\"0\"> Doc" "doc"]

element create $form_name swc_formato \
    -label   "Formato" \
    -widget   radio \
    -datatype text \
    -options $options_swc_formato \
    -html    "class form_element" \
    -optional

element create $form_name caller            -widget hidden -datatype text -optional
element create $form_name funzione          -widget hidden -datatype text -optional
element create $form_name nome_funz         -widget hidden -datatype text -optional
element create $form_name nome_funz_caller  -widget hidden -datatype text -optional
element create $form_name extra_par         -widget hidden -datatype text -optional
element create $form_name last_cod_impianto -widget hidden -datatype text -optional
element create $form_name cod_impianto      -widget hidden -datatype text -optional
element create $form_name url_list_aimp     -widget hidden -datatype text -optional
element create $form_name url_aimp          -widget hidden -datatype text -optional
element create $form_name id_stampa         -widget hidden -datatype text -optional
element create $form_name tipo_stampa       -widget hidden -datatype text -optional
element create $form_name cod_rgen          -widget hidden -datatype text -optional
element create $form_name submit            -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[form is_request $form_name]} {
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    element set_properties $form_name cod_impianto      -value $cod_impianto
    element set_properties $form_name id_stampa         -value $id_stampa
    element set_properties $form_name tipo_stampa       -value $tipo_stampa
    element set_properties $form_name cod_rgen          -value $cod_rgen   
    element set_properties $form_name swc_formato       -value "pdf"
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set id_protocollo [element::get_value $form_name id_protocollo]
    set protocollo_dt [element::get_value $form_name protocollo_dt]

    if {$campo1 != ""} {
	set $campo1_testo      [element::get_value $form_name $campo1_testo]
    }
    if {$campo2 != ""} {
	set $campo2_testo      [element::get_value $form_name $campo2_testo]
    }
    if {$campo3 != ""} {
	set $campo3_testo      [element::get_value $form_name $campo3_testo]
    }
    if {$campo4 != ""} {
	set $campo4_testo      [element::get_value $form_name $campo4_testo]
    }
    if {$campo5 != ""} {
	set $campo5_testo      [element::get_value $form_name $campo5_testo]
    }
    if {$var_testo == "S"} {
        set nota               [element::get_value $form_name nota]
    }
    set swc_formato            [element::get_value $form_name swc_formato]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    #recupero la data odierna 
    set edit_data [iter_edit_date [iter_set_sysdate]]

    if {![string equal $id_protocollo ""]} {
	db_1row sel_docu_count ""
	if {$conta_prot > 0} {
	    element::set_error $form_name id_protocollo "Protocollo gi&agrave; esistente"
	    incr error_num
	} else {
	    set id_protocollo_save $id_protocollo
	}
    } else {
	set id_protocollo_save ""
	set id_protocollo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }
    
    if {[string equal $protocollo_dt ""]} {
	#	set protocollo_dt $current_date
    } else {
	set protocollo_dt [iter_check_date $protocollo_dt]
	if {$protocollo_dt == 0} {
	    element::set_error $form_name protocollo_dt "Data non corretta"
	    incr error_num
	}
    }

    if {[string equal $swc_formato ""]} {
        element::set_error $form_name swc_formato "Inserire Formato"
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {$coimtgen(regione) eq "MARCHE"} {#rom02

	set spool_dir_perm     [iter_set_permanenti_dir]
	set spool_dir_url_perm [iter_set_permanenti_dir_url]
	set nome_file          "stp-$id_stampa-$id_utente"
	set file_html          "$spool_dir_perm/$nome_file.html"
	set file_pdf           "$spool_dir_perm/$nome_file.pdf"
	set file_pdf_url       "$spool_dir_url_perm/$nome_file.pdf"
	set file_doc           "$spool_dir_perm/$nome_file.doc"
	set file_doc_url       "$spool_dir_url_perm/$nome_file.doc"

    } else {#rom02
	
	set spool_dir     [iter_set_spool_dir]
	set spool_dir_url [iter_set_spool_dir_url]
	set nome_file     "stp-$id_stampa-$id_utente"
	set file_html     "$spool_dir/$nome_file.html"
	set file_pdf      "$spool_dir/$nome_file.pdf"
	set file_pdf_url  "$spool_dir_url/$nome_file.pdf"
	set file_doc      "$spool_dir/$nome_file.doc"
	set file_doc_url  "$spool_dir_url/$nome_file.doc"
    };#rom02
    
    # apro file temporaneo
    set file_id [open $file_html w]
    fconfigure $file_id -encoding iso8859-1

    if {$protocollo_dt != ""} {
	set protocollo_dt_edit  [iter_edit_date $protocollo_dt]
    } else {
	set protocollo_dt_edit  $protocollo_dt
    }

    #   Data del giorno
    
    set oggi [iter_edit_date [iter_set_sysdate]]

    iter_get_coimtgen
    set flag_viario      $coimtgen(flag_viario)
    set flag_ente        $coimtgen(flag_ente)         
    set sigla_prov       $coimtgen(sigla_prov)
    set denom_comune     $coimtgen(denom_comune)

    if {$flag_ente == "P"} {
	set logo_img "[string tolower $flag_ente]r[string tolower $sigla_prov]-stp.gif"
    } else {
	set logo_img "[string tolower $flag_ente][string tolower $denom_comune]-stp.gif"
    }

    #   Dati Impianto 
    if {$flag_viario == "T"} {
	if {[db_0or1row sel_imp_si_vie {}] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}
    } else {
 	if {[db_0or1row sel_imp_no_vie {}] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}
    }

    #rom01 La variabile importo_pagamento è utilizzata solo per Aspes,Aset e gli altri della Regione Marche
    set importo_pagamento  "";#rom01
    if {$potenza_utile >= 10.00 && $potenza_utile <= 35.00} {#rom01 aggiunta if, elseif e loro contenuto
	set importo_pagamento "80,00 Euro"
    } elseif {$potenza_utile > 35.00 && $potenza_utile <= 116.00} {
	set importo_pagamento "110,00 Euro"
    } elseif {$potenza_utile > 116.00 && $potenza_utile <= 350.00} {
	set importo_pagamento "180,00 Euro"
    } elseif {$potenza_utile > 350.00} {
	set importo_pagamento "250,00 Euro"
    };#rom01

    #   Dati Responsabile
    if {[db_0or1row sel_resp {}] == 0} {
	set natura_resp "" 
	set nome_resp ""  
	set indirizzo_resp ""
	set cap_resp "" 
	set localita_resp ""
	set comune_resp "" 
	set provincia_resp ""
	set codice_fiscale_resp ""  
	set telefono_resp ""  
	set data_nascita_resp ""
	set comune_nascita_resp "" 
	set note_resp "" 
    }


    #   Dati proprietario

    if {[db_0or1row sel_prop {}] == 0} {
	set natura_prop "" 
	set nome_prop ""  
	set indirizzo_prop ""
	set cap_prop "" 
	set localita_prop ""
	set comune_prop "" 
	set provincia_prop ""
	set codice_fiscale_prop ""  
	set telefono_prop ""  
	set data_nascita_prop ""
	set comune_nascita_prop "" 
	set note_prop "" 
    }

    #   Dati intestatario

    if {[db_0or1row sel_inte {}] == 0} {
	set natura_inte "" 
	set nome_inte ""  
	set indirizzo_inte ""
	set cap_inte "" 
	set localita_inte ""
	set comune_inte "" 
	set provincia_inte ""
	set codice_fiscale_inte ""  
	set telefono_inte ""  
	set data_nascita_inte ""
	set comune_nascita_inte "" 
	set note_inte "" 
    }

    #   Dati Occupante

    if {[db_0or1row sel_occu {}] == 0} {
	set natura_occu "" 
	set nome_occu ""  
	set indirizzo_occu ""
	set cap_occu "" 
	set localita_occu ""
	set comune_occu "" 
	set provincia_occu ""
	set codice_fiscale_occu ""  
	set telefono_occu ""  
	set data_nascita_occu ""
	set comune_nascita_occu "" 
	set note_occu "" 
    }

    #   Dati Amministratore

    if {[db_0or1row sel_ammi {}] == 0} {
	set natura_ammi "" 
	set nome_ammi ""  
	set indirizzo_ammi ""
	set cap_ammi "" 
	set localita_ammi ""
	set comune_ammi "" 
	set provincia_ammi ""
	set codice_fiscale_ammi ""  
	set telefono_ammi ""  
	set data_nascita_ammi ""
	set comune_nascita_ammi "" 
	set note_ammi "" 
    }

    #   Dati Manutentore

    if {[db_0or1row sel_manu {}] == 0} {
	set nome_manu ""  
	set indirizzo_manu ""
	set cap_manu "" 
	set localita_manu ""
	set comune_manu "" 
	set provincia_manu ""
	set partita_iva_manu ""  
	set telefono_manu ""  
	set note_manu "" 
        set pec "";#san01
    }

    #   Dati Installatore

    if {[db_0or1row sel_inst {}] == 0} {
	set nome_inst ""  
	set indirizzo_inst ""
	set cap_inst "" 
	set localita_inst ""
	set comune_inst "" 
	set provincia_inst ""
	set partita_iva_inst ""  
	set telefono_inst ""  
	set note_inst "" 
    }

    #   Dati Distributore

    if {[db_0or1row sel_dist {}] == 0} {
	set nome_dist ""  
	set indirizzo_dist ""
	set cap_dist "" 
	set localita_dist ""
	set comune_dist "" 
	set provincia_dist ""
	set codice_fiscale_dist ""  
	set telefono_dist ""  
	set note_dist "" 
    }

    #   Dati Progettista

    if {[db_0or1row sel_prog {}] == 0} {
	set natura_prog "" 
	set nome_prog ""  
	set indirizzo_prog ""
	set cap_prog "" 
	set localita_prog ""
	set comune_prog "" 
	set provincia_prog ""
	set codice_fiscale_prog ""  
	set telefono_prog ""  
	set note_prog "" 
    }


    # Eventuale destinatario
    if {![string equal cod_rgen ""]} {
	set indice_destinatario 0
	db_foreach sel_enrg "" {
	    incr indice_destinatario
	    set destinat($indice_destinatario) "
              <tr><td width=70%>&nbsp;</td><td width=30%>$denom_dest<td></tr>
              <tr><td>&nbsp;</td><td>$indirizzo_dest $numero_dest</td></tr>
              <tr><td>&nbsp;</td><td>$cap_dest $localita_dest $comune_dest</td></tr>
              <tr><td>&nbsp;</td><td>$provincia_dest</td></tr>
            " 
	}
	# con la spedizione ai diversi enti si invia una lettera anche
        # al proprietario o utilizzatore dell'impianto. in questo modo 
        # stampo un'altra lettera valorizzando il destinatario con il 
        # responsabile
	incr indice_destinatario
	set destinat($indice_destinatario) "
              <tr><td width=70%>&nbsp;</td><td width=30%>$nome_resp<td></tr>
              <tr><td>&nbsp;</td><td>$indirizzo_resp</td></tr>
              <tr><td>&nbsp;</td><td>$cap_resp $localita_resp $comune_resp</td></tr>
              <tr><td>&nbsp;</td><td>$provincia_resp</td></tr>
            " 
    }

    if {[db_0or1row sel_cted {}] == 0} {
	set tipo_edificio "" 
    }

    if {[db_0or1row sel_comu {}] == 0} {
	set comune_impianto "" 
    }

    if {[db_0or1row sel_prov {}] == 0} {
	set provincia_impianto "" 
    }

    if {[db_0or1row sel_tpdu {}] == 0} {
	set destinazione_uso "" 
    }

    if {[db_0or1row sel_comb {}] == 0} {
	set combustibile "" 
    }

    if {[db_0or1row sel_pote {}] == 0} {
	set fascia_potenza "" 
    }

    if {[db_0or1row sel_tpim {}] == 0} {
	set tipo_impianto "" 
    }


    #   Dati Generatore

    set generatore "<table width=90%>
                    <tr>
                       <td align=left><b>Elenco Generatori</b></td>
                    </tr>"
    db_foreach sel_gend "" { 
	set riga "<tr>
                      <td align=left>- Generatore $gen_prog_est: destinazione d'uso $descr_utgi, installato il $data_installaz, matricola $matricola, modello $modello, costruttore $descr_cost, combustibile utilizzato $descr_comb</td>
                  </tr>
                  <tr>
                      <td align=left>- Note: $note</td>
                  </tr>"
	append generatore $riga
    } if_no_rows {
	set riga "<tr>
              <td>Dati Generatore: Nessun Generatore Inserito</td>
              </tr>"
	append generatore $riga
    }
    set riga "</table>"
    append generatore $riga

    #   Dati Rapporti di Verifica

    if {[db_0or1row sel_cimp {}] == 0} {
	set cod_cimp ""
	set gen_prog ""
	set cod_inco ""
	set data_controllo_rv ""
	set verb_n ""
	set data_verb ""
	set verif_cimp ""
	set esito_verifica ""
	set flag_ispes ""
	set flag_cpi ""
	set verif_cel ""
    }
   
    if {![db_0or1row query "
        select cod_dimp
             , prescrizioni    --san01
             , raccomandazioni --san01
             , osservazioni    --san01
          from coimdimp
         where cod_impianto = :cod_impianto
      order by data_controllo desc
             , cod_dimp       desc
         limit 1
    "]} {#gab01: aggiunta if e suo contenuto
        set cod_dimp ""
        set prescrizioni "";#san01
        set raccomanazioni "";#san01
        set osservazioni "";#san01

    }

    #   Anomalie da Rapporto di Verifica
    
    set no_row_cimp "f";#gab01
    set no_row_dimp "f";#gab01

    set anomalie "<table width=100%>
                  <tr>
                     <td align=left valign=top width=100%>&nbsp;</td>
                  </tr>"
    db_foreach sel_anom "" { 
	if {$coimtgen(ente) eq "PFI"} {#Sandro 18/07/2014
	    set data_utile_intervento "";#Sandro 18/07/2014
	} else {#Sandro 18/07/2014
	    set data_utile_intervento "- Data Utile Intervento: $data_interv"
	};#Sandro 18/07/2014
	set riga_anom "<tr>
	                  <td align=justify style=\"text-align:justify\">$anomalia $data_utile_intervento</td>
	               </tr>"
	append anomalie $riga_anom
        set non_conformita $anomalia
    } if_no_rows {
        set no_row_cimp "t";#gab01
	#gab01 set riga_anom "<tr>
        #gab01                  <td>Nessuna Anomalia Riscontrata</td>
        #gab01               </tr>"
	#gab01 append anomalie $riga_anom
        #gab01 set non_conformita "Nessuna Anomalia Riscontrata"
    }
    
    db_foreach query "
        select b.descr_breve                     as anomalia
             , iter_edit_data(a.dat_utile_inter) as data_interv
          from coimanom a
             , coimtano b
         where a.cod_cimp_dimp = :cod_dimp
           and b.cod_tano      = a.cod_tanom
    " {#gab01: aggiunta db_foreach e suo contenuto
        if {$coimtgen(ente) eq "PFI"} {#Sandro 18/07/2014
            set data_utile_intervento "";#Sandro 18/07/2014
        } else {#Sandro 18/07/2014
            set data_utile_intervento "- Data Utile Intervento: $data_interv"
        };#Sandro 18/07/2014
        set riga_anom "<tr>
                          <td align=justify style=\"text-align:justify\">$anomalia $data_utile_intervento</td>
                       </tr>"
        append anomalie $riga_anom
        set non_conformita $anomalia
    } if_no_rows {
        set no_row_dimp "t"
    }

    if {$no_row_cimp eq "t" && $no_row_dimp eq "t"} {#gab01: aggiunta if e suo contenuto
	append anomalie "<tr>
                            <td>Nessuna Anomalia Riscontrata</td>
                         </tr>"

	set non_conformita "Nessuna Anomalia Riscontrata"
    }

    set riga_anom "</table>"
    append anomalie $riga_anom

    #  Dati incontro
    if {[db_0or1row sel_inco {}] == 0} {
	set cod_inco ""
	set desc_cinc ""
	set tipo_estrazione ""
	set data_estrazione ""
	set data_assegn ""
	set verif_inco ""
	set data_verifica ""
	set ora_verifica ""
	set data_avviso_01 ""
	set cod_documento_01 ""
	set data_avviso_02 ""
	set cod_documento_02 ""
	set stato ""
	set esito ""
	set note ""
    }

    #  Elenco Documenti inviati

    set allegati "<table width=90%>
                  <tr>
                     <td align=left valign=top width=90%>&nbsp;</td>
                  </tr>
                  <tr>
                     <td align=left><b>Elenco Documenti</b></td>
                  </tr>"
    db_foreach sel_docu "" { 
	set riga_docu "<tr>
                          <td align=left>$desc_tdoc del $data_documento</td>
                       </tr>"
	append allegati $riga_docu
    } if_no_rows {
	set riga_docu "<tr>
                          <td>Nessun Documento inserito</td>
                       </tr>"
	append allegati $riga_docu
    }
    
    if {[info exists data_prot_01] && [info exists id_protocollo]} {
	
    } else {
	set data_prot_01	$protocollo_dt
	set protocollo_01	$id_protocollo
    }

    set riga_docu "</table>"
    append allegati $riga_docu

    #  Modelli H

    set modelli_h "<table width=90%>
                  <tr>
                     <td align=left valign=top width=90%>&nbsp;</td>
                  </tr>
                  <tr>
                     <td align=left><b>Elenco Modelli H</b></td>
                  </tr>"

    db_foreach sel_dimp "" { 
	set riga_dimp "<tr>
                          <td align=left>Protocollo n. $n_prot del $data_prot rilasciato da $manutentore il $data_controllo. Controllo rendimento fumi $cont_rend</td>
                       </tr>"
	append modelli_h $riga_dimp
    } if_no_rows {
	set riga_dimp "<tr>
                          <td>Nessun Modello H inserito</td>
                       </tr>"
	append modelli_h $riga_dimp
	set data_controllo "";#gab01
    }
    set riga_dimp "</table>"
    append modelli_h $riga_dimp


    # costruzione logo
    set logo_dir     [util_current_location]/$logo_dir_url

    iter_get_coimdesc
    set nome_ente    $coimdesc(nome_ente)
    set tipo_ufficio $coimdesc(tipo_ufficio)
    set assessorato  $coimdesc(assessorato)
    set indirizzo    $coimdesc(indirizzo)
    set telefono     $coimdesc(telefono)
    set resp_uff     $coimdesc(resp_uff)
    set uff_info     $coimdesc(uff_info)
    set dirigente    $coimdesc(dirigente)

    set logo "
    <table width=100%>
    <tr>
    <td width=15%>
          <img src=$logo_dir/$logo_img>
    </td>
    <td valign=top align=left width=18%><table width=100%>
              <tr>
                 <td align=left>$nome_ente
                              <br><b>$tipo_ufficio</b></td>
              </tr>
        </table>
    </td>
    <td valign=top align=left><table width=100%>
              <tr><td><small>$indirizzo
                               <br>$telefono
                               <br>$uff_info</small>
                  </td>
              </tr>
        </table>
    </td>
    <td width=10%>&nbsp;</td>
    </table>"

    set indirizzo_resp_aln "
           <table width=100%>
              <tr>
                 <td width=60%>&nbsp;</td>
                 <td width=40%>Egr.Sig.re/ra</td>
              </tr>
              <tr>
                 <td>&nbsp;</td>
                 <td><b>$nome_resp</b></td>
              </tr>
              <tr>
                 <td>&nbsp;</td>
                 <td><b>$indirizzo_resp</b></td>
              </tr>
              <tr>
                 <td>Is.-Fab.-Sc.-P.-Int.-</td>
                 <td><b>$cap_resp $localita_resp $comune_resp ($provincia_resp)</b></td>
           </table>"

    set firma_dirig "
           <table width=100%>
                  <tr>
                     <td width=50%>&nbsp;</td>
                     <td width=50% align=center>Il Dirigente</td>
                  </tr>
                  <tr>
                     <td>&nbsp;</td>
                     <td align=center>(Arch. Giancarlo Leoni)</td>
                  </tr>
                  <tr>
                     <td>&nsap;</td>
                     <td align=center><img src=$logo_dir/firma-dirig-prmn.gif></td>
                  </tr>
           </table>
            "

    set n 1
    while {$n <= 3} {
	set data_scad_sanz$n ""
	set importo_sanz$n ""
	set tipo_soggetto_sanz$n ""
	set cod_soggetto_sanz$n ""
	set soggetto_sanz$n ""
	set sanzione_1$n ""
	set sanzione_2$n ""
	set data_rich_audiz$n ""
	set data_pres_deduz$n ""
	set data_ric_giudice$n ""
	set data_ric_tar$n ""
	set data_ric_ulter$n ""
	set data_ruolo$n ""
	set note_rich_audiz$n ""
	set note_pres_deduz$n ""
	set note_ric_giudice$n ""
	set note_ric_tar$n ""
	set note_ric_ulter$n ""
	set note_ruolo$n ""

	set n [expr $n + 1]
    }

    set n 1
    db_foreach sel_sanz "" {

	switch $tipo_soggetto_sanz {
	    "Responsabile" {db_1row sel_nome_resp ""}
	    "Manutentore"  {db_1row sel_nome_manu ""}
	    "Distributore" {db_1row sel_nome_dist ""}
	}

	set data_scad_sanz$n $data_scad_sanz
	set importo_sanz$n $importo_sanz
	set tipo_soggetto_sanz$n $tipo_soggetto_sanz
	set cod_soggetto_sanz$n $cod_soggetto_sanz
	set soggetto_sanz$n $soggetto_sanz
	set sanzione_1$n $sanzione_1
	set sanzione_2$n $sanzione_2
	set data_rich_audiz$n $data_rich_audiz
	set data_pres_deduz$n $data_pres_deduz
	set data_ric_giudice$n $data_ric_giudice
	set data_ric_tar$n $data_ric_tar
	set data_ric_ulter$n $data_ric_ulter
	set data_ruolo$n $data_ruolo
	set note_rich_audiz$n $note_rich_audiz
	set note_pres_deduz$n $note_pres_deduz
	set note_ric_giudice$n $note_ric_giudice
	set note_ric_tar$n $note_ric_tar
	set note_ric_ulter$n $note_ric_ulter
	set note_ruolo$n $note_ruolo

	set n [expr $n + 1]
    }

    set provincia_impianto [string totitle $provincia_impianto]
    if {$flag_ente == "C"} {
	set provincia_impianto "il Comune di $provincia_impianto"
    }

    if {$flag_ente == "P"} {
	set provincia_impianto "la Provincia di $provincia_impianto"
    }

    set fascia_potenza [string tolower $fascia_potenza]

    switch $flag_ispes {
	"S" {set flag_ispes "Si"} \
	    "N" {set flag_ispes "No"} \
	    "T" {set flag_ispes "Scaduto"} 
    }

    switch $flag_cpi {
	"S" {set flag_cpi "Si"} \
	    "N" {set flag_cpi "No"} \
	    "T" {set flag_cpi "Scaduto"} 
    }    

    switch $tipo_foglio {
        "3" {set formato "A3"}
	default {set formato "A4"}
    }

    switch $orientamento {
        "L" {set orientamento "landscape"}
	default {set orientamento "portrait"}
    }

    # preparo la routine che serve per scrivere nel file il contenuto
    # di $testo
    set scrivi_testo {
	regsub -all {\n} $testo {<br>} testo
	regsub -all "  " $testo {\&nbsp; } testo
	
	eval "set testo2 \"$testo\" "
	
	# non inserisco il numero di pagina perche' e' una lettera
	#	set testo_docu "<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) / \$PAGES(1)\"-->"
	set testo_docu "
            <html>
               <head>
                  <style type=\"text/css\">
                     <!--
                        body {
                           font-family: Times;
                           font-size: 11pt;
                           letter-spacing: 0.2pt;
                        }
                        small {
                           font-size: 8pt;
                        }
                        @page Section1 {
                           size:          $formato $orientamento;
                           margin-top:    2.5cm;
                           margin-bottom: 2cm;
                           margin-left:   2cm;
                           margin-right:  2cm;
                        }
                        div.Section1 {
                           page:Section1;
                        }
                     -->
                  </style>
               </head>
               <body>
                  <div class=\"Section1\">
                      $testo2
                  </div>
               </body>
            </html>"
	puts $file_id $testo_docu
    }

    if {![string equal $cod_rgen ""]} { 
	set contatore 1
	while {$contatore <= $indice_destinatario} {
	    set destinatario $destinat($contatore) 

            eval $scrivi_testo

	    incr contatore
	    puts $file_id "<br style=\"page-break-before:always\">"
	}

    } else {
	eval $scrivi_testo
    }
    close $file_id

    # lo trasformo in PDF
    # iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet {$formato} $orientamento --left 1cm --right 0.5cm --top 0cm -f $file_pdf $file_html]
    #Sandro 18/07/2014 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --fontsize 11 --$orientamento --top 2.5cm --bottom 2cm --left 2cm --right 2cm -f $file_pdf $file_html]
    iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --fontsize 11 --$orientamento --top 0cm --bottom 0cm --left 0.5cm --right 0.5cm -f $file_pdf $file_html];#Sandro 18/07/2014

    # Creazione documento per concessione
    #db_1row get_id_documento ""

    #set tipo_documento $id_stampa
    set tipo_documento [db_string query "select tipo_documento from coimstpm where id_stampa = :id_stampa" -default "GE"]

    set stato_a "N"
    set id_protocollo $id_protocollo_save
    if {$var_testo == "S"} {
	set oggetto $nota
    } else {
	set oggetto $descrizione_stampa
    }

    set sql_documento     "lo_import(:file_pdf)"
    set estensione        [ns_guesstype $file_pdf]

    ### inserimento su documenti
    set sql_contenuto  "lo_import(:file_html)"
    set tipo_contenuto [ns_guesstype $file_pdf]

    set contenuto_tmpfile  $file_pdf

    set flag_docu "S"
    with_catch error_msg {
	db_transaction {

	    if {$coimtgen(regione) eq "MARCHE"} {#rom02 if e suo contenuto

		db_1row q "select nextval('coimdocu_s') as cod_documento"
		
		db_dml q "insert
                  into coimdocu 
                     ( cod_documento
                     , tipo_documento
                     , cod_impianto
                     , data_documento
                     , data_stampa
                     , data_prot_01
                     , protocollo_01
                     , data_ins
                     , data_mod
                     , utente
                     , path_file
                     , tipo_contenuto
                     )
                values 
                     (:cod_documento
                     ,:tipo_documento
                     ,:cod_impianto
                     ,current_date
                     ,current_date
                     ,:protocollo_dt
                     ,:id_protocollo
                     ,current_date
                     ,current_date
                     ,:id_utente
                     ,:file_pdf
                     , 'application/pdf'
                     )"

	    } else {#rom02
	    	    
		db_1row sel_docu_next ""
		db_dml ins_docu ""
		
		# Controllo se il Database e' Oracle o Postgres
		set id_db         [iter_get_parameter database]
		if {$id_db == "postgres"} {
		    if {[db_0or1row sel_docu_contenuto ""] == 1} {
			if {![string equal $docu_contenuto_check ""]} {
			    db_dml upd_docu_2 [db_map upd_docu_2]
			}
		    }
		    db_dml upd_docu_3 [db_map upd_docu_3]
		} else {
		db_dml upd_docu_2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
		}
		
	    };#rom02
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }
    ### fine ins


    exec cp $file_html $file_doc
    ns_unlink $file_html

    if {$swc_formato == "pdf"} {
	ad_returnredirect "$file_pdf_url"
    } else {
	ad_returnredirect "$file_doc_url"
    }
    ad_script_abort

}

ad_return_template
