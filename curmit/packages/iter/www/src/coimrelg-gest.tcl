ad_page_contract {
    Gestione tabella "coimrelg" Scheda generale relazione biennale
    @author          Adhoc
    @creation-date   26/01/2005

    @param funzione  P=pre-insert I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimrelg-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =================================================================
    but01 10/07/2023 Aggiunto la classe ah-jquery-date ai campi: valid_dataf, rifer_dataf
    but01            , rifer_datai, conv_ass_categ, data_rel


} {
    
   {cod_relg         ""}
   {data_rel         ""}
   {ente_istat       ""}
   {rel_cod_comune   ""}
   {last_data_rel    ""}
   {last_ente_istat  ""}
   {funzione         "V"}
   {caller           "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "P" {set lvl 2}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_relg last_data_rel last_ente_istat nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione
set current_date      [iter_set_sysdate]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_data_rel last_ente_istat caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Relazione biennale"
switch $funzione {
    M {set button_label "Conferma Modifica" 
       set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
       set page_title   "Cancellazione $titolo"}
    P {set button_label "Conferma Inserimento"
       set page_title   "Inserimento Estremi $titolo"}
    I {set button_label "Conferma Inserimento"
       set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizzazione $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimrelg"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
   "P" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
       }
   "I" {set readonly_fld \{\}
        set disabled_fld \{\}
       }
   "M" {set readonly_fld \{\}
        set disabled_fld \{\}
       }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}
form create $form_name \
-html    $onsubmit_cmd

element create $form_name data_rel \
-label   "Data inizio relazione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
-optional

if {$funzione == "P"} {
    # valorizzo i valori possibili del codice istat ed il relativo default
    # usando cod_provincia e cod_comune della coimtgen.
    # se per la provincia e' indicato nella coimtgen anche il cod_comune,
    # lo utilizzo come seconda scelta ed in tal caso valorizzo il campo hidden
    # rel_cod_comune (verra' utilizzato nei conteggi dell'inserimento)

    # leggo i dati generali
    iter_get_coimtgen

    # definisco la routine che fa in modo di portare un codice_istat di 7
    # caratteri a 6 caratteri pulendo eventuali punti, - o spazi
    # ed alla fine troncando comunque a 6 caratteri
    # altrimenti l'inserimento nel campo ente_istat generera' un errore.
    set prep_cod_istat {
	regsub -all \\. $cod_istat {} cod_istat
	regsub -all \\- $cod_istat {} cod_istat
	regsub -all { } $cod_istat {} cod_istat
	set cod_istat [string range $cod_istat 0 5]
    }

    set options_ente_istat ""
    set rel_cod_comune     ""
    if {$coimtgen(flag_ente) == "P"} {
	set cod_provincia $coimtgen(cod_provincia)

	if {[db_0or1row sel_prov_cod_istat ""] == 1
	&& ![string equal $cod_istat       ""]
	} {
	    eval $prep_cod_istat
	    lappend options_ente_istat [list "$cod_istat Provincia" $cod_istat]
	} else {
	    iter_return_complaint "Codice istat dell'ente non trovato: controllare che siano valorizzati nei dati generali la provincia e sulla tabella province il relativo codice istat."
	}
    }

    set cod_comune  $coimtgen(cod_comu)
    if {[db_0or1row sel_comu_cod_istat ""] == 1
    && ![string equal $cod_istat       ""]
    } {
	eval $prep_cod_istat
	lappend options_ente_istat [list "$cod_istat Comune" $cod_istat]
	if {$coimtgen(flag_ente) == "P"} {
	    set rel_cod_comune $cod_comune
	}
    } else {
	if {$coimtgen(flag_ente) == "C"} {
	    iter_return_complaint "Codice istat dell'ente non trovato: controllare che siano valorizzati nei dati generali il comune e sulla tabella comuni il relativo codice istat."
	}
    }

    element create $form_name ente_istat \
    -label   "Codice istat" \
    -widget   select \
    -datatype text \
    -options $options_ente_istat \
    -html    "class form_element" \
    -optional
} else {
    element create $form_name ente_istat \
    -label   "Codice istat" \
    -widget   text \
    -datatype text \
    -html    "size 6 maxlength 6 $readonly_key {} class form_element" \
    -optional
}

element create $form_name nome_file_gen \
-label   "Nome file scheda generale" \
-widget   text \
-datatype text \
-html    "size 25 maxlength 50 $readonly_fld {} class form_element" \
-optional

element create $form_name nome_file_tec \
-label   "Nome file scheda tecnica" \
-widget   text \
-datatype text \
-html    "size 25 maxlength 50 $readonly_fld {} class form_element" \
-optional

element create $form_name resp_proc \
-label   "Responsabile del procedimento" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 80 $readonly_fld {} class form_element" \
-optional

element create $form_name nimp_tot_stim_ente \
-label   "N. Impianti stimati" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name nimp_tot_aut_ente \
-label   "Autonomi" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name nimp_tot_centr_ente \
-label   "Centralizzati" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name nimp_tot_telerisc_ente \
-label   "Teleriscaldamento" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name conv_ass_categ \
-label   "Data sottoscrizione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name conf_dgr7_7568 \
-label   "Conformit&agrave; alla D.G.R. 7/7568 del 21 dicembre 2001" \
-widget   select \
-datatype text \
-options [list [list "" ""] [list "Si" "Y"] [list "No" "N"]] \
-html    "$disabled_fld {} class form_element" \
-optional

element create $form_name npiva_ader_conv \
-label   "Numero delle P. Iva aderenti alla convenzione" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name npiva_ass_acc_reg \
-label   "Numero delle P. Iva iscritte alle associazioni di categoria firmatarie dell'Accordo Regionale" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name delib_autodic \
-label   "Delibera autodichiarazioni" \
-widget   select \
-datatype text \
-options [list [list "" ""] [list "Si" "Y"] [list "No" "N"]] \
-html    "$disabled_fld {} class form_element" \
-optional

element create $form_name rifer_datai \
-label   "Data inizio periodo di riferimento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name rifer_dataf \
-label   "Data fine periodo di riferimento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name valid_datai \
-label   "Data inizio periodo di validit&agrave;" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name valid_dataf \
-label   "Data fine periodo di validit&agrave;" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name ntot_autodic_perv \
-label   "N. autodichiarazioni" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name ntot_prescrizioni \
-label   "N. autodichiarazioni con prescrizioni" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name n_ver_interni \
-label   "N. verificatori interni" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name n_ver_esterni \
-label   "N. verificatori esterni" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name n_accert_enea \
-label   "N. accertamenti Enea" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name n_accert_altri \
-label   "N. accertamenti altri soggetti" \
-widget   text \
-datatype text \
-html    "size 6 maxlength 6 $readonly_fld {} class form_element" \
-optional

# in visualizzazione estraggo anche alcuni totali della scheda tecnica
if {$funzione == "V"} {
    element create $form_name nimp_verificati \
    -label   "N. impianti verificati" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
    -optional

    element create $form_name nimp_verificati_nc \
    -label   "N. impianti verificati non conformi" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
    -optional

    element create $form_name ngen_verificati \
    -label   "N. generatori verificati" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
    -optional

    element create $form_name ngen_verificati_nc \
    -label   "N. generatori verificati non conformi" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 $readonly_fld {} class form_element" \
    -optional
}

element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name cod_relg  -widget hidden -datatype text -optional
element create $form_name last_data_rel    -widget hidden -datatype text -optional
element create $form_name last_ente_istat  -widget hidden -datatype text -optional
element create $form_name rel_cod_comune   -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

  element set_properties $form_name funzione         -value $funzione
  element set_properties $form_name caller           -value $caller
  element set_properties $form_name nome_funz        -value $nome_funz
  element set_properties $form_name nome_funz_caller -value $nome_funz_caller
  element set_properties $form_name extra_par        -value $extra_par
  element set_properties $form_name last_data_rel    -value $last_data_rel
  element set_properties $form_name last_ente_istat  -value $last_ente_istat

  if {$funzione == "P"} {
    # valorizzo i default della funzione di 'pre-inserimento'

    # valorizzo data_rel col 01/08 di due anni fa
    set data_corr     [iter_set_sysdate]
    set anno_corr     [string range $data_corr 0 3]
    set mese_corr     [string range $data_corr 4 5]
    if {$mese_corr <= "08"} {
	set anno_corr [expr $anno_corr - 1]
    }
    set anno_iniz_rel [expr $anno_corr - 2]
    set data_rel      "01/08/$anno_iniz_rel"

    # il default di ente_istat e' valorizzato con le options
    # dell'element create.

    # valorizzo il campo della form
    # rel_cod_comune e' stato preparato nell'element create di ente_istat
    element set_properties $form_name data_rel       -value $data_rel
    element set_properties $form_name rel_cod_comune -value $rel_cod_comune

  } elseif {$funzione == "I"} {
    # valorizzo i default per l'inserimento

    # valorizzo il nome dei file con codice istat + _ + data_rel in formato
    # americano + Gen.txt o Tec.txt
    # 020000_01-Aug-2004Gen
    # 020000_01-Aug-2004Tec
    set data_rel_american [db_string sel_dual_edit_data_rel ""]
    set nome_file_gen "${ente_istat}_${data_rel_american}Gen.txt"
    set nome_file_tec "${ente_istat}_${data_rel_american}Tec.txt"

    # leggo i dati dell'ente competente
    iter_get_coimdesc
    # valorizzo resp_proc con di resp_uff di coimdesc
    set resp_proc $coimdesc(resp_uff)

    # per valorizzare i default del numero di impianti e di controlli
    # se rel_cod_comune e' valorizzato bisogna selezionare
    # solo gli impianti della provincia fuori dal comune oppure
    # solo gli impianti del comune.
    if {[string equal $rel_cod_comune ""]} {
	set where_cod_comune    ""
    } else {
	# se il codice istat termina con 000 si tratta della provincia
#	ns_log notice "UUU $ente_istat"
	if {[string range $ente_istat end-2 end] == "000"} {
	    set where_cod_comune "  and coimaimp.cod_comune <> :rel_cod_comune"
	} else {
	    set where_cod_comune "  and coimaimp.cod_comune  = :rel_cod_comune"
	}
    }

    # valorizzo un default del numero di impianti stimati
    # (totale, autonomi, centralizzati) contando gli impianti
    # attivi alla data odierna
    # dato che ho vari impianti con tipologia 'non nota'
    # li faccio confluire tra gli autonomi
    # calcolando gli autonomi come il totale - i centralizzati
    set where_cod_tpim      ""
    set nimp_tot_stim_ente  [db_string sel_aimp_count ""]
    set where_cod_tpim      "and cod_tpim = 'C'"
    set nimp_tot_centr_ente [db_string sel_aimp_count ""]
    set nimp_tot_aut_ente   [expr $nimp_tot_stim_ente - $nimp_tot_centr_ente]
    # valorizzo un default del numero di autodichiarazioni pervenute
    # nel periodo e di quelle con prescrizioni
    # prima calcolo data_rel_fine come data_rel + 2 anni - 1 giorno
    set data_rel_iniz       $data_rel
    set data_rel_fine       [db_string sel_dual_data_rel_fine ""]

    # poi conto i modelli h con data_controllo nel periodo
    if {![string equal $where_cod_comune ""]} {
	set from_coimaimp  "    , coimaimp"
	set where_coimaimp "  and coimaimp.cod_impianto = coimdimp.cod_impianto
                           $where_cod_comune"
    } else {
	set from_coimaimp  ""
	set where_coimaimp ""
    }

    set where_prescrizioni  ""
#    ns_log notice "EEE $data_rel_iniz $data_rel_fine $where_prescrizioni $where_cod_comune $rel_cod_comune"
    set ntot_autodic_perv   [db_string sel_dimp_count ""]

    # ed infine i modelli h con data_controllo nel periodo con
    # una nota nelle prescrizioni o almeno una anomalia
    set where_prescrizioni  "
    and (   prescrizioni is not null
         or exists (select '1'
                      from coimanom
                     where coimanom.cod_cimp_dimp = coimdimp.cod_dimp
                       and coimanom.flag_origine  = 'MH'
                   )
         )"
    set ntot_prescrizioni  [db_string sel_dimp_count ""]

    # solo ora trasformo in formato di edit la data_rel
    # ricevuta dalla funzione di "P"
    set data_rel [iter_edit_date $data_rel]
    # ed anche i vari numeri ottenuti dalle count
    set nimp_tot_stim_ente  [iter_edit_num $nimp_tot_stim_ente  0]
    set nimp_tot_aut_ente   [iter_edit_num $nimp_tot_aut_ente   0]
    set nimp_tot_centr_ente [iter_edit_num $nimp_tot_centr_ente 0]
    set ntot_autodic_perv   [iter_edit_num $ntot_autodic_perv   0]
    set ntot_prescrizioni   [iter_edit_num $ntot_prescrizioni   0]

    element set_properties $form_name data_rel          -value $data_rel
    element set_properties $form_name ente_istat        -value $ente_istat
    element set_properties $form_name rel_cod_comune    -value $rel_cod_comune
    element set_properties $form_name nome_file_gen     -value $nome_file_gen
    element set_properties $form_name nome_file_tec     -value $nome_file_tec
    element set_properties $form_name resp_proc         -value $resp_proc
    element set_properties $form_name nimp_tot_stim_ente     -value $nimp_tot_stim_ente
    element set_properties $form_name nimp_tot_aut_ente      -value $nimp_tot_aut_ente
    element set_properties $form_name nimp_tot_centr_ente    -value $nimp_tot_centr_ente
    element set_properties $form_name ntot_autodic_perv      -value $ntot_autodic_perv
    element set_properties $form_name ntot_prescrizioni      -value $ntot_prescrizioni

  } else {
    # leggo riga
    if {[db_0or1row sel_relg {}] == 0} {
	iter_return_complaint "Relazione biennale non trovata"
    }
    
    element set_properties $form_name cod_relg          -value $cod_relg
    element set_properties $form_name data_rel          -value $data_rel
    element set_properties $form_name ente_istat        -value $ente_istat
    element set_properties $form_name nome_file_gen     -value $nome_file_gen
    element set_properties $form_name nome_file_tec     -value $nome_file_tec
    element set_properties $form_name resp_proc         -value $resp_proc
    element set_properties $form_name nimp_tot_stim_ente     -value $nimp_tot_stim_ente
    element set_properties $form_name nimp_tot_aut_ente      -value $nimp_tot_aut_ente
    element set_properties $form_name nimp_tot_centr_ente    -value $nimp_tot_centr_ente
    element set_properties $form_name nimp_tot_telerisc_ente -value $nimp_tot_telerisc_ente
    element set_properties $form_name conv_ass_categ    -value $conv_ass_categ
    element set_properties $form_name conf_dgr7_7568    -value $conf_dgr7_7568
    element set_properties $form_name npiva_ader_conv   -value $npiva_ader_conv
    element set_properties $form_name npiva_ass_acc_reg -value $npiva_ass_acc_reg
    element set_properties $form_name delib_autodic     -value $delib_autodic
    element set_properties $form_name rifer_datai       -value $rifer_datai
    element set_properties $form_name rifer_dataf       -value $rifer_dataf
    element set_properties $form_name valid_datai       -value $valid_datai
    element set_properties $form_name valid_dataf       -value $valid_dataf
    element set_properties $form_name ntot_autodic_perv -value $ntot_autodic_perv
    element set_properties $form_name ntot_prescrizioni -value $ntot_prescrizioni
    element set_properties $form_name n_ver_interni     -value $n_ver_interni
    element set_properties $form_name n_ver_esterni     -value $n_ver_esterni
    element set_properties $form_name n_accert_enea     -value $n_accert_enea
    element set_properties $form_name n_accert_altri    -value $n_accert_altri

    # in visualizzazione estraggo anche alcuni totali della scheda tecnica
    if {$funzione == "V"} {
	set sezione    "C"
        set id_clsnc   "5"
        set id_stclsnc "1"
        set obj_refer  "I"
        set id_pot     "9"
        set id_per     "9"
        set id_comb    "9"
	# seleziono il numero impianti verificati
	if {[db_0or1row sel_relt ""] == 0} {
	    set nimp_verificati 0
	} else {
	    set nimp_verificati $n
	}

	# seleziono il numero impianti verificati con non conformita'
	set id_stclsnc "3"
	if {[db_0or1row sel_relt ""] == 0} {
	    set nimp_verificati_nc 0
	} else {
	    set nimp_verificati_nc $n
	}

	# seleziono il numero generatori verificati
	set obj_refer  "G"
	set id_stclsnc "1"
	if {[db_0or1row sel_relt ""] == 0} {
	    set ngen_verificati 0
	} else {
	    set ngen_verificati $n
	}

	# seleziono il numero generatori verificati con non conformita'
	set id_stclsnc "3"
	if {[db_0or1row sel_relt ""] == 0} {
	    set ngen_verificati_nc 0
	} else {
	    set ngen_verificati_nc $n
	}

	element set_properties $form_name nimp_verificati    -value $nimp_verificati
	element set_properties $form_name nimp_verificati_nc -value $nimp_verificati_nc
	element set_properties $form_name ngen_verificati    -value $ngen_verificati
	element set_properties $form_name ngen_verificati_nc -value $ngen_verificati_nc
    }
  }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_relg            [element::get_value $form_name cod_relg]
    set data_rel            [element::get_value $form_name data_rel]
    set ente_istat          [element::get_value $form_name ente_istat]
    set rel_cod_comune      [element::get_value $form_name rel_cod_comune]
    set nome_file_gen       [element::get_value $form_name nome_file_gen]
    set nome_file_tec       [element::get_value $form_name nome_file_tec]
    set resp_proc           [element::get_value $form_name resp_proc]
    set nimp_tot_stim_ente  [element::get_value $form_name nimp_tot_stim_ente]
    set nimp_tot_aut_ente   [element::get_value $form_name nimp_tot_aut_ente]
    set nimp_tot_centr_ente [element::get_value $form_name nimp_tot_centr_ente]
    set nimp_tot_telerisc_ente [element::get_value $form_name nimp_tot_telerisc_ente]
    set conv_ass_categ      [element::get_value $form_name conv_ass_categ]
    set conf_dgr7_7568      [element::get_value $form_name conf_dgr7_7568]
    set npiva_ader_conv     [element::get_value $form_name npiva_ader_conv]
    set npiva_ass_acc_reg   [element::get_value $form_name npiva_ass_acc_reg]
    set delib_autodic       [element::get_value $form_name delib_autodic]
    set rifer_datai         [element::get_value $form_name rifer_datai]
    set rifer_dataf         [element::get_value $form_name rifer_dataf]
    set valid_datai         [element::get_value $form_name valid_datai]
    set valid_dataf         [element::get_value $form_name valid_dataf]
    set ntot_autodic_perv   [element::get_value $form_name ntot_autodic_perv]
    set ntot_prescrizioni   [element::get_value $form_name ntot_prescrizioni]
    set n_ver_interni       [element::get_value $form_name n_ver_interni]
    set n_ver_esterni       [element::get_value $form_name n_ver_esterni]
    set n_accert_enea       [element::get_value $form_name n_accert_enea]
    set n_accert_altri      [element::get_value $form_name n_accert_altri]

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "P"} {
        if {[string equal $data_rel ""]} {
            element::set_error $form_name data_rel "Inserire Data inizio relazione"
            incr error_num
        } else {
            set data_rel [iter_check_date $data_rel]
            if {$data_rel == 0} {
                element::set_error $form_name data_rel "Deve essere una data"
                incr error_num
            }
        }

        if {[string equal $ente_istat ""]} {
            element::set_error $form_name ente_istat "Inserire Codice istat dell'ente"
            incr error_num
        }

	if {$error_num == 0
	&&  [db_0or1row sel_relg_check {}] == 1
	} {
	    # controllo univocita'/protezione da double_click
	    element::set_error $form_name data_rel "Esiste gi&agrave; una relazione biennale con questa data inizio sull'ente indicato"
	    incr error_num
	}
    }

    if {$funzione == "I"
    ||  $funzione == "M"
    } {
      # in inserimento e modifica devo solo riportare la data in
      # formato yyyymmdd e per farlo uso questa proc.
	set data_rel [iter_check_date $data_rel]

        if {[string equal $nome_file_gen ""]} {
            element::set_error $form_name nome_file_gen "Inserire Nome file scheda generale"
            incr error_num
        }

        if {[string equal $nome_file_tec ""]} {
            element::set_error $form_name nome_file_tec "Inserire Nome file scheda tecnica"
            incr error_num
        }

        if {![string equal $nimp_tot_stim_ente ""]} {
            set nimp_tot_stim_ente [iter_check_num $nimp_tot_stim_ente 0]
            if {$nimp_tot_stim_ente == "Error"} {
                element::set_error $form_name nimp_tot_stim_ente "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $nimp_tot_stim_ente] >=  [expr pow(10,8)]
                ||  [iter_set_double $nimp_tot_stim_ente] <= -[expr pow(10,8)]} {
                    element::set_error $form_name nimp_tot_stim_ente "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $nimp_tot_aut_ente ""]} {
            set nimp_tot_aut_ente [iter_check_num $nimp_tot_aut_ente 0]
            if {$nimp_tot_aut_ente == "Error"} {
                element::set_error $form_name nimp_tot_aut_ente "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $nimp_tot_aut_ente] >=  [expr pow(10,8)]
                ||  [iter_set_double $nimp_tot_aut_ente] <= -[expr pow(10,8)]} {
                    element::set_error $form_name nimp_tot_aut_ente "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $nimp_tot_centr_ente ""]} {
            set nimp_tot_centr_ente [iter_check_num $nimp_tot_centr_ente 0]
            if {$nimp_tot_centr_ente == "Error"} {
                element::set_error $form_name nimp_tot_centr_ente "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $nimp_tot_centr_ente] >=  [expr pow(10,8)]
                ||  [iter_set_double $nimp_tot_centr_ente] <= -[expr pow(10,8)]} {
                    element::set_error $form_name nimp_tot_centr_ente "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $nimp_tot_telerisc_ente ""]} {
            set nimp_tot_telerisc_ente [iter_check_num $nimp_tot_telerisc_ente 0]
            if {$nimp_tot_telerisc_ente == "Error"} {
                element::set_error $form_name nimp_tot_telerisc_ente "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $nimp_tot_telerisc_ente] >=  [expr pow(10,8)]
                ||  [iter_set_double $nimp_tot_telerisc_ente] <= -[expr pow(10,8)]} {
                    element::set_error $form_name nimp_tot_telerisc_ente "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $conv_ass_categ ""]} {
            set conv_ass_categ [iter_check_date $conv_ass_categ]
            if {$conv_ass_categ == 0} {
                element::set_error $form_name conv_ass_categ "Deve essere una data"
                incr error_num
            } else {
		if {$conv_ass_categ > $current_date} {
		    element::set_error $form_name conv_ass_categ "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {![string equal $npiva_ader_conv ""]} {
            set npiva_ader_conv [iter_check_num $npiva_ader_conv 0] 
            if {$npiva_ader_conv == "Error"} {
                element::set_error $form_name npiva_ader_conv "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $npiva_ader_conv] >=  [expr pow(10,5)]
                ||  [iter_set_double $npiva_ader_conv] <= -[expr pow(10,5)]} {
                    element::set_error $form_name npiva_ader_conv "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }

        if {![string equal $npiva_ass_acc_reg ""]} {
            set npiva_ass_acc_reg [iter_check_num $npiva_ass_acc_reg 0]
            if {$npiva_ass_acc_reg == "Error"} {
                element::set_error $form_name npiva_ass_acc_reg "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $npiva_ass_acc_reg] >=  [expr pow(10,5)]
                ||  [iter_set_double $npiva_ass_acc_reg] <= -[expr pow(10,5)]} {
                    element::set_error $form_name npiva_ass_acc_reg "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }

        if {![string equal $rifer_datai ""]} {
            set rifer_datai [iter_check_date $rifer_datai]
            if {$rifer_datai == 0} {
                element::set_error $form_name rifer_datai "Deve essere una data"
                incr error_num
            }
        }

        if {![string equal $rifer_dataf ""]} {
            set rifer_dataf [iter_check_date $rifer_dataf]
            if {$rifer_dataf == 0} {
                element::set_error $form_name rifer_dataf "Deve essere una data"
                incr error_num
            }
        }

        if {![string equal $valid_datai ""]} {
            set valid_datai [iter_check_date $valid_datai]
            if {$valid_datai == 0} {
                element::set_error $form_name valid_datai "Deve essere una data"
                incr error_num
            }
        }

        if {![string equal $valid_dataf ""]} {
            set valid_dataf [iter_check_date $valid_dataf]
            if {$valid_dataf == 0} {
                element::set_error $form_name valid_dataf "Deve essere una data"
                incr error_num
            }
        }

        if {![string equal $ntot_autodic_perv ""]} {
            set ntot_autodic_perv [iter_check_num $ntot_autodic_perv 0]
            if {$ntot_autodic_perv == "Error"} {
                element::set_error $form_name ntot_autodic_perv "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $ntot_autodic_perv] >=  [expr pow(10,8)]
                ||  [iter_set_double $ntot_autodic_perv] <= -[expr pow(10,8)]} {
                    element::set_error $form_name ntot_autodic_perv "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $ntot_prescrizioni ""]} {
            set ntot_prescrizioni [iter_check_num $ntot_prescrizioni 0]
            if {$ntot_prescrizioni == "Error"} {
                element::set_error $form_name ntot_prescrizioni "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $ntot_prescrizioni] >=  [expr pow(10,8)]
                ||  [iter_set_double $ntot_prescrizioni] <= -[expr pow(10,8)]} {
                    element::set_error $form_name ntot_prescrizioni "Deve essere inferiore di 100.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $n_ver_interni ""]} {
            set n_ver_interni [iter_check_num $n_ver_interni 0]
            if {$n_ver_interni == "Error"} {
                element::set_error $form_name n_ver_interni "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $n_ver_interni] >=  [expr pow(10,5)]
                ||  [iter_set_double $n_ver_interni] <= -[expr pow(10,5)]} {
                    element::set_error $form_name n_ver_interni "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }

        if {![string equal $n_ver_esterni ""]} {
            set n_ver_esterni [iter_check_num $n_ver_esterni 0]
            if {$n_ver_esterni == "Error"} {
                element::set_error $form_name n_ver_esterni "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $n_ver_esterni] >=  [expr pow(10,5)]
                ||  [iter_set_double $n_ver_esterni] <= -[expr pow(10,5)]} {
                    element::set_error $form_name n_ver_esterni "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }

        if {![string equal $n_accert_enea ""]} {
            set n_accert_enea [iter_check_num $n_accert_enea 0]
            if {$n_accert_enea == "Error"} {
                element::set_error $form_name n_accert_enea "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $n_accert_enea] >=  [expr pow(10,5)]
                ||  [iter_set_double $n_accert_enea] <= -[expr pow(10,5)]} {
                    element::set_error $form_name n_accert_enea "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }

        if {![string equal $n_accert_altri ""]} {
            set n_accert_altri [iter_check_num $n_accert_altri 0]
            if {$n_accert_altri == "Error"} {
                element::set_error $form_name n_accert_altri "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $n_accert_altri] >=  [expr pow(10,5)]
                ||  [iter_set_double $n_accert_altri] <= -[expr pow(10,5)]} {
                    element::set_error $form_name n_accert_altri "Deve essere inferiore di 100.000"
                    incr error_num
                }
            }
        }
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {
	    set cod_relg  [db_string sel_relg_s ""]
	    set dml_sql   [db_map ins_relg]

	    # devo preparare i record da inserire in coimrelt (scheda tecnica)
	    # dove devono comparire le non conformita' ed i relativi totali

	    # per prima cosa seleziono tutte le non conformita' dai rapporti
	    # di verifica del periodo richiesto (data_rel_iniz + 2 anni)
	    # (considerando solo l'ultimo dei rapporti di verifica sullo stesso
	    #  generatore).
	    # da questa query estraggo comunque il record relativo alla
	    # verifica del generatore anche se non vi e' alcuna non conformita'
	    # perche' devo contare quanti impianti e generatori sono 
	    # stati 'verificati' nel periodo.
	    # le non conformita' sono tutte le anomalie + i campi 8a, 8b, 8c,
	    # 8d quando sono valorizzati con 'S'.
	    # nel frattempo leggo anche i dati dell'impianto che usero'
	    # per fare le aggregazioni.
	    # i record sono ordinati per cod_impianto, gen_prog

	    # prima calcolo data_rel_fine come data_rel + 2 anni - 1 giorno
	    set data_rel_iniz $data_rel
	    set data_rel_fine [db_string sel_dual_data_rel_fine ""]

	    # poi preparo where_cod_comune perche'
	    # se rel_cod_comune e' valorizzato bisogna selezionare
	    # solo gli impianti della provincia fuori dal comune oppure
	    # solo gli impianti del comune.
	    if {[string equal $rel_cod_comune ""]} {
		set where_cod_comune    ""
	    } else {
		# se il codice istat termina con 000 si tratta della provincia
		if {[string range $ente_istat end-2 end] == "000"} {
		    set where_cod_comune "  and c.cod_comune <> :rel_cod_comune"
		} else {
		    set where_cod_comune "  and c.cod_comune  = :rel_cod_comune"
		}
	    }

	    # lancio la query e memorizzo tutto in un vettore.
	    set num_nc  0

	    db_foreach sel_cimp_non_conformita "" {
		# aggiungo la riga al vettore
		incr num_nc

		# valorizzo gli elementi della riga $num_nc del vettore
		set el_cod_impianto($num_nc)     $cod_impianto
		set el_gen_prog($num_nc)         $gen_prog
		set el_cod_potenza($num_nc)      $cod_potenza
		set el_data_installaz($num_nc)   $data_installaz
		set el_cod_combustibile($num_nc) $cod_combustibile
		set el_8a($num_nc)               $manutenzione_8a
		set el_8b($num_nc)               $co_fumi_secchi_8b
		set el_8c($num_nc)               $indic_fumosita_8c
		set el_8d($num_nc)               $rend_comb_8d
		set el_cod_tanom($num_nc)        $cod_tanom

	    };#fine db_foreach

	    # inizializzo un altro vettore di nome relt
	    # che e' strutturato come la tabella coimrelt
	    # ed e' predisposto per conteggiare le non conformita'
	    # raggruppate per classe, sottoclasse, potenza, periodo e combust.
	    array set relt ""

	    # definisco la routine che prepara id_pot
	    set prep_id_pot {
		# questa mappatura e' solo temporanea per CMPD
		if {$el_cod_potenza($ind_nc) == "M"} {
		    set el_cod_potenza($ind_nc) "MB"
		}

#nel programma di stampa le potenze MB e C/MC sono unite 
		if {$el_cod_potenza($ind_nc) == "C" || $el_cod_potenza($ind_nc) == "MC"} {
		    set el_cod_potenza($ind_nc) "MB"
		}

		switch $el_cod_potenza($ind_nc) {
		    "B" {set id_pot  1}
		   "MB" {set id_pot  2}
		   "MA" {set id_pot  3}
		    "A" {set id_pot  4}
		    "C" {set id_pot  5}
		default {set id_pot "0"}
		}
	    }

	    # definisco la routine che prepara id_per
	    set prep_id_per {
		set anno_installaz [string range $el_data_installaz($ind_nc) 0 3]
		if {$anno_installaz <  "1990"} {
		    set id_per 1
		} else {
		    if {$anno_installaz <= "2000"} {
			set id_per 2
		    } else {
			if {$anno_installaz >  "2000"} {
			    set id_per 3
			} else {
			    # non noto
			    set id_per 4
			}
		    }
		}
	    }

	    # definisco la routine che prepara id_comb
#	    set prep_id_comb {
#		# questa mappatura e' solo temporanea per PRMN
#		switch $el_cod_combustibile($ind_nc) {
#		    "1" {set el_cod_combustibile($ind_nc) "N"}
#		    "2" {set el_cod_combustibile($ind_nc) "C"}
#		    "3" {set el_cod_combustibile($ind_nc) "G"}
#		    "4" {set el_cod_combustibile($ind_nc) "O"}
#		    "5" {set el_cod_combustibile($ind_nc) "P"}
#		}
#
#		# decodifica definitiva
#		switch $el_cod_combustibile($ind_nc) {
#		    "G" {set id_comb 1}
#		    "P" {set id_comb 2}
#		    "O" {set id_comb 3}
#		default {set id_comb 5}
#		}
#	    }


	    set prep_id_comb {
		# questa mappatura e' per il comune di lecco
		switch $el_cod_combustibile($ind_nc) {
		    "7" {set id_comb 1} 
		    "3" {set id_comb 2}
		    "5" {set id_comb 3}
                default {set id_comb 5}
		}
	    }

	    # definisco la routine che prepara id_clsnc e id_stclsnc
	    # dato in input cod_nc
	    set prep_id_clsnc_e_id_stclsnc {
		set pre_cod_nc [string range    $cod_nc     0 0]
		set suf_cod_nc [string range    $cod_nc     1 end]
		set suf_cod_nc [string trimleft $suf_cod_nc 0]
		set id_clsnc   ""
		set id_stclsnc ""
		switch $pre_cod_nc {
		    "8" {
			set id_clsnc 1
			switch $suf_cod_nc {
			    "a" {set id_stclsnc  1}
			    "b" {set id_stclsnc  2}
			    "c" {set id_stclsnc  3}
			    "d" {set id_stclsnc  4}
			default {set id_stclsnc ""}
			}
		    }
		    "A" {
			if {[string is integer $suf_cod_nc]} {
			    if {$suf_cod_nc >= 1
			    &&  $suf_cod_nc <= 18
			    } {
				# qui finiscono le A1,... A18.
				set id_clsnc   2
				set id_stclsnc $suf_cod_nc
			    } else {
				# volutamente le A19, 20 ... della provincia di
				# mantova le catalogo come D1, ..., D5.
				set id_clsnc   4
				set id_stclsnc [expr $suf_cod_nc - 18]
			    }
			} else {
			    # se suf_cod_nc non e' numerico, e' un caso
			    # non contemplato
			    set id_clsnc   4
			    set id_stclsnc 99
			}
		    }
		    "C" {
			# stesso ragionamento delle a per le c > 14.
			if {[string is integer $suf_cod_nc]} {
			    if {$suf_cod_nc >= 1
			    &&  $suf_cod_nc <= 14
			    } {
				# qui finiscono le C1,... C14.
				set id_clsnc   3
				set id_stclsnc $suf_cod_nc
			    } else {
				# volutamente le C15, 16 ... della provincia di
				# mantova le catalogo come D15, D16, ....
				set id_clsnc   4
				set id_stclsnc $suf_cod_nc
			    }
			} else {
			    # se suf_cod_nc non e' numerico, e' un caso
			    # non contemplato: altri
			    set id_clsnc   4
			    set id_stclsnc 99
			}
		    }
		default {
		        # caso non contemplato: altri
		        set id_clsnc   4
		        set id_stclsnc 99
		    }
		}
	    }

	    # definisco la routine che prepara l'indice della tabella
	    # delle non conformita' con una chiave composta da sezione
	    # id_clsnc, id_stclsnc, obj_refer, id_pot, id_per e id_comb
	    set prep_ind_relt {
		set     ind_relt ""
		lappend ind_relt $sezione
		lappend ind_relt $id_clsnc
		lappend ind_relt $id_stclsnc
		lappend ind_relt $obj_refer
		lappend ind_relt $id_pot
		lappend ind_relt $id_per
		lappend ind_relt $id_comb
	    }

	    # definisco la routine che prepara l'indice della tabella
	    # delle non conformita' per i totali come la routine precedente.
	    # le uniche differenze sono:
	    # sezione C, id_pot 9, id_per 9 e id_comb 9
	    set prep_ind_relt_xtot {
		set     ind_relt ""
		lappend ind_relt "C"
		lappend ind_relt $id_clsnc
		lappend ind_relt $id_stclsnc
		lappend ind_relt $obj_refer
		lappend ind_relt 9
		lappend ind_relt 9
		lappend ind_relt 9
	    }

	    # definisco la routine che inserisce una riga nel vettore relt
	    # oppure aumenta il contatore della riga che ha lo stesso indice.
	    set ins_relt {
		if {![info exists relt($ind_relt)]} {
		    set  relt($ind_relt) 1
		} else {
		    incr relt($ind_relt)
		}
	    }

	    # definisco la routine che conteggia le non conformita'
	    # inserendo una riga del vettore relt oppure aumentando
	    # il contatore della riga che ha lo stesso indice.
	    set conta_nc {
		# incremento il totale generatori non conformi
		# solo se sto conteggiando la non conformita' di un generatore
		# ed una volta sola per generatore
		if {$obj_refer          == "G"
		&&  $sw_primo_relt_gend == "t"
		} {
		    set sw_primo_relt_gend "f"
		    incr tot_gend_nc

		    # conteggio anche il numero generatori non conformi
		    # della potenza, periodo e combustibile correnti.
		    set save_id_clsnc   $id_clsnc
		    set save_id_stclsnc $id_stclsnc
		    set id_clsnc   5
		    set id_stclsnc 3

		    # preparo l'indice del vettore con una chiave composta da
		    # sez., id_clsnc, id_stclsnc, obj_refer,
		    # id_pot, id_per e id_comb
		    eval $prep_ind_relt

		    # inserisco 1 riga del vettore oppure aumento il contatore
		    eval $ins_relt

		    # ripristino classe e sottoclasse da conteggiare
		    set id_clsnc   $save_id_clsnc
		    set id_stclsnc $save_id_stclsnc
		}

		# preparo l'indice del vettore con una chiave composta da sez.
		# id_clsnc, id_stclsnc, obj_refer, id_pot, id_per e id_comb
		eval $prep_ind_relt

		# inserisco una riga del vettore oppure aumento il contatore
		eval $ins_relt

		# bisogna conteggiare anche il totale delle non conformita'
		# degli impianti e dei generatori senza distinzione per
		# potenza, periodo e combustibile:

		# questa operazione va effettuata solo se non si tratta
		# della classe 5 dove i totali vengono conteggiati
		# manualmente perche' devono essere generati anche
		# se non esistono verifiche:

		if {$id_clsnc != 5} {
		    # preparo l'indice del vettore per i totali:
		    # sezione C, id_pot 9, id_per 9 e id_comb 9.
		    # non sovrascrivo le variabili. le altre parti dell'indice
		    # restano invariate.
		    eval $prep_ind_relt_xtot

		    # inserisco 1 riga del vettore oppure aumento il contatore
		    eval $ins_relt
		}
	    }

	    # definisco la routine che prepara il vettore delle non conformita'
	    # dell'impianto. bisogna conteggiare una sola volta la stessa
	    # non conformita' presente su piu' generatori.
	    # quindi' e' sufficiente che memorizzi solo un elemento
	    # del vettore con chiave id_clsnc e id_stclsnc
	    set prep_nc_aimp {
		set     ind_relt_aimp ""
		lappend ind_relt_aimp $id_clsnc
		lappend ind_relt_aimp $id_stclsnc

		if {![info exists relt_aimp($ind_relt_aimp)]} {
		    set relt_aimp($ind_relt_aimp) "t"
		}
	    }

	    # definisco la routine che conteggia il numero di impianti
	    # o di generatori non conformi della potenza, periodo e
	    # combustibile correnti:
	    set conta_obj {
		set id_clsnc   5
		set id_stclsnc 1;# numero generatori verificati
		# preparo l'indice del vettore con una chiave composta da
		# sez., id_clsnc, id_stclsnc, obj_refer,
		# id_pot, id_per e id_comb
		eval $prep_ind_relt
		# inserisco 1 riga del vettore oppure aumento il contatore
		eval $ins_relt

		if {(   $obj_refer == "G"
		     && $sw_primo_relt_gend == "t")
		||  (   $obj_refer == "I"
		     && $sw_primo_relt_aimp == "t")
		} {
		    # se il generatore o l'impianto non hanno
		    # alcuna non conformita' li conteggio tra i conformi
		    # conteggio il numero generatori conformi
		    set id_stclsnc 4
		    eval $prep_ind_relt
		    eval $ins_relt
		}
	    }

	    # inizializzo il totale impianti e generatori non conformi
	    set tot_aimp_nc 0
	    set tot_gend_nc 0

	    # inizializzo il totale impianti e generatori verificati
	    set tot_aimp_ver 0
	    set tot_gend_ver 0

	    # ora posso leggere il vettore a rottura di impianto e generatore
	    set ind_nc 1
	    while {$ind_nc <= $num_nc} {

		# per ogni impianto preparo le variabili da usare per i
		# raggruppamenti (id_pot, id_per e id_comb)
		eval $prep_id_pot
		eval $prep_id_per
		eval $prep_id_comb

		# inizializzo il vettore delle non conformita' dell'imp.
		array set relt_aimp ""

		# proseguo col ciclo a rottura di impianto
		set save_cod_impianto $el_cod_impianto($ind_nc)
		while {   $ind_nc                   <= $num_nc
		       && $el_cod_impianto($ind_nc) == $save_cod_impianto} {

		    set sw_prima_nc        "t"
		    set sw_primo_relt_gend "t"
		    set save_gen_prog      $el_gen_prog($ind_nc)

		    while {   $ind_nc                   <= $num_nc
			   && $el_cod_impianto($ind_nc) == $save_cod_impianto
			   && $el_gen_prog($ind_nc)     == $save_gen_prog} {

			# per ogni record di non conformita' vengono ripetute
			# le 8a, 8b, 8c, 8d che sono attributi della coimcimp.
			# per questo vanno rilevate solo la prima volta
			# sullo stesso generatore.
			# uso la routine prep_id_clsnc_e_id_stclsnc
			# per preparare id classe e sottoclasse di non conf.
			# uso la routine conta_nc per conteggiare la
			# non conformita' sul generatore (obj_refer=G)
			# uso la routine prep_nc_aimp per preparare le 
			# non conformita' dell'impianto.
			set sezione   "V";# non conformita della Verifica
			set obj_refer "G"
			if {$sw_prima_nc == "t"} {
			    set sw_prima_nc "f"
			    if {$el_8a($ind_nc) == "N"} {
				set cod_nc "8a"
				eval $prep_id_clsnc_e_id_stclsnc
				eval $conta_nc
				eval $prep_nc_aimp
			    }
			    if {$el_8b($ind_nc) == "N"} {
				set cod_nc "8b"
				eval $prep_id_clsnc_e_id_stclsnc
				eval $conta_nc
				eval $prep_nc_aimp
			    }
			    if {$el_8c($ind_nc) == "N"} {
				set cod_nc "8c"
				eval $prep_id_clsnc_e_id_stclsnc
				eval $conta_nc
				eval $prep_nc_aimp
			    }
			    if {$el_8d($ind_nc) == "N"} {
				set cod_nc "8d"
				eval $prep_id_clsnc_e_id_stclsnc
				eval $conta_nc
				eval $prep_nc_aimp
			    }
			}
			if {![string equal $el_cod_tanom($ind_nc) ""]} {
			    set cod_nc $el_cod_tanom($ind_nc)
			    eval $prep_id_clsnc_e_id_stclsnc
			    eval $conta_nc
			    eval $prep_nc_aimp
			}

			incr ind_nc
		    };#fine ciclo a rottura di generatore
		    incr tot_gend_ver

		    # richiamo la routine che conteggia il numero
		    # di generatori conformi e non conformi.
		    set obj_refer "G";#conteggio relativo ai generatori
		    eval $conta_obj

		};#fine ciclo a rottura di impianto

		# per ogni impianto con delle non conformita'
		# uso la routine conta_nc per conteggiare le
		# non conformita' sull'impianto (obj_refer=I)
		set obj_refer "I"
		set sezione   "V";# non conformita della Verifica
		set sw_primo_relt_aimp "t"
		foreach ind_relt_aimp [array names relt_aimp] {
		    if {$sw_primo_relt_aimp == "t"} {
			set sw_primo_relt_aimp "f"
			# solo per la prima non conformita' dell'impianto
			# incremento il totale impianti non conformi
			# e conteggio il numero impianti non conformi
			# della potenza, periodo e combustibile correnti.
			incr tot_aimp_nc
			set id_clsnc   5
			set id_stclsnc 3
			eval $conta_nc
		    }
		    set id_clsnc   [lindex $ind_relt_aimp 0]
		    set id_stclsnc [lindex $ind_relt_aimp 1]
		    eval $conta_nc
		}
		unset relt_aimp

		incr tot_aimp_ver
		# richiamo la routine che conteggia il numero
		# di impianti conformi e non conformi
		eval $conta_obj

	    };#fine ciclo sulle non conformita'

	    # calcolo il totale impianti conformi
	    set tot_aimp_conformi [expr $tot_aimp_ver - $tot_aimp_nc]

	    # calcolo il totale generatori conformi
	    set tot_gend_conformi [expr $tot_gend_ver - $tot_gend_nc]

	    # scrivo i totali nel vettore delle non conformita'
	    # valorizzando classe con 5 e di volta in volta le sottoclassi.
	    # valorizzo sezione con 'C', id_pot, id_per e id_comb con 9
	    # grazie alla routine prep_ind_relt_xtot

	    set id_clsnc   5

	    set obj_refer "I";#totali relativi agli impianti

	    set id_stclsnc 1;# numero impianti verificati
	    # preparo l'indice del vettore con una chiave composta da sez.
	    # id_clsnc, id_stclsnc, obj_refer, id_pot, id_per e id_comb
	    eval $prep_ind_relt_xtot
	    # valorizzo l'elemento del vettore
	    set relt($ind_relt) $tot_aimp_ver

	    set id_stclsnc 4;# numero impianti conformi
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $tot_aimp_conformi

	    set id_stclsnc 3;# numero impianti non conformi
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $tot_aimp_nc

	    set id_stclsnc 2;# numero autodichiarazioni nel periodo
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $ntot_autodic_perv

	    set obj_refer "G";#totali relativi ai generatori

	    set id_stclsnc 1;# numero generatori verificati
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $tot_gend_ver

	    set id_stclsnc 4;# numero generatori conformi
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $tot_gend_conformi

	    set id_stclsnc 3;# numero generatori non conformi
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $tot_gend_nc

	    # per i generatori, dato che non vi sono i modelli h bis,
	    # il numero autodichiarazioni e' uguale a quello degli impianti-
	    set id_stclsnc 2;# numero autodichiarazioni nel periodo
	    eval $prep_ind_relt_xtot
	    set relt($ind_relt) $ntot_autodic_perv

	    #pezza
	    if {[string equal $id_stclsnc ""]} {
		set id_stclsnc "0"
	    }
	    set dml_sql_2 [db_map ins_relt]
	}
        M {
	    set dml_sql   [db_map upd_relg]
	    if {$ntot_autodic_perv > 0} {
		# in modifica devo comunque aggiornare il numero
		# delle autodichiarazioni pervenute (sia per impianti
		# che per generatori) anche sulla tabella coimrelt
		set n         $ntot_autodic_perv
		set sezione   "C"
		set id_clsnc   5
		set id_stclsnc 2
		set id_pot     9
		set id_per     9
		set id_comb    9
		set dml_sql_2 [db_map upd_relt]
	    }
	}
        D {
	    set dml_sql   [db_map del_relt]
	    set dml_sql_2 [db_map del_relg]
	}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {

        with_catch error_msg {
            db_transaction {
                db_dml dml_coimrelg_1 $dml_sql
		if {[info exists dml_sql_2]} {
		    if {$funzione == "I"} {
			# in inserimento ricavo i valori di coimrelt
			# dal vettore
			set cod_relt       0
			foreach ind_relt   [array names relt] {
			    incr cod_relt
			    set sezione    [lindex $ind_relt 0]
			    set id_clsnc   [lindex $ind_relt 1]
			    set id_stclsnc [lindex $ind_relt 2]
			    set obj_refer  [lindex $ind_relt 3]
			    set id_pot     [lindex $ind_relt 4]
			    set id_per     [lindex $ind_relt 5]
			    set id_comb    [lindex $ind_relt 6]
			    set n          $relt($ind_relt)
			    if {[string equal $id_stclsnc ""]} {
				set id_stclsnc 0
			    }
			    db_dml dml_coimrelg_2 $dml_sql_2
			}
		    } else {
			db_dml dml_coimrelg_2 $dml_sql_2
		    }
		}
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_data_rel   $data_rel
        set last_ente_istat $ente_istat
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_relg last_data_rel last_ente_istat nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        P {set return_url   "coimrelg-gest?funzione=I&$link_gest&[export_url_vars data_rel ente_istat rel_cod_comune]"}
        I {set return_url   "coimrelg-gest?funzione=V&$link_gest"}
        V {set return_url   "coimrelg-list?$link_list"}
        M {set return_url   "coimrelg-gest?funzione=V&$link_gest"}
        D {set return_url   "coimrelg-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
