ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimstpm"
    @author          Tania Masullo Adhoc
    @creation-date   17/08/2005

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimstpm-prnt-da-app.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric04 04/06/2024 Corretto where che andava in errore perchè uguagliati varchar = numeric.

    ric03 31/05/2024 Come richiesto da Sandro: se dall'incontro non risalgo al rapporto di ispezione
    ric03            imposto come where_inco_cimp la where sull'ultimo rapporto.

    ric02 14/07/2023 Il programma, se lanciato con un numero di avvisi elevato, andava in timeout
    ric02            tale comportamento non avviene in ambiente di dev e ipotizziamo sia dovuto 
    ric02            ad una versione diversa di naviserver.
    ric02            Per il momento testiamo la modifica in produzione e non committiamo. Cancellare questa riga in fase di commmit.

    but01 08/01/2024 Aggiunto nuova variable indirizzo_resp_aln2 per modifica della stampa Avviso di ispezione
    
    rom03 22/05/2023 Reso standard una modifica fatta per il Comune di Pesaro.

    ric01 18/11/2022 Palermo salva i documenti sul file system e non sul db come Regione Marche.
    ric01            Inoltre abbiamo uniformato la stampa totale e la stampa singola andando ad indicare
    ric01            sul totale il parametro size.

    sim02 30/03/2021 Corretto errore sulla Regione Marche per cui i file dei singoli impianti
    sim02            venivano sovrascritti e veniva tenuto solo l'ultimo preso in esame.
    sim02            Corretto errore sul nome del file allegato per cui l'allegato non veniva
    sim02            inviato insieme all'email perche' conteneva degli spazi.

    sim01 10/06/2019 Blocco l'inserimento degli rcee sull'impianto 

    rom02 21/11/2028 Escludo DAM e Modelli G dalla selezione dei campi pec, prescrizioni,
    rom02            osservazioni e raccomanazioni sulla coimdimp.

    rom01 13/07/2018 Ricevo e passo i filtri f_invio_comune e ls_cod_inco.

    gab01 29/06/2018  Ricevo e passo i filtri flag_racc e flag_pres.
    
    san01 06/02/2018 Aggiunto campo pec,prescrizioni,osservazioni e raccomanazioni 

} {
    {cod_inco            ""}
    {funzione           "V"}
    {caller         "index"}
    {nome_funz           ""}
    {nome_funz_caller    ""}
    {extra_par           ""}
    {extra_par_inco      ""}
    {cod_impianto        ""}
    {url_list_aimp       ""}
    {url_aimp            ""}

    {id_stampa           ""}
    {tipo_stampa         ""}
    {do                  ""}
    {flag_avviso         ""}
    {flag_richiesta      ""}

    {f_data              ""}
    {f_tipo_data         ""}
    {f_cod_impianto      ""}
    {f_cod_tecn          ""}
    {f_cod_enve          ""}
    {f_cod_comb          ""}
    {f_anno_inst_da      ""}
    {f_anno_inst_a       ""}
    {f_cod_comune        ""}
    {f_cod_via           ""}
    {f_tipo_estrazione   ""}
    {f_cod_area          ""}
    {flag_scaduto        ""}
    {f_cod_esito         ""}
    {flag_inco           ""}
    {conta_flag          ""}
    {f_num_max           ""}
    {f_da_data_verifica  ""}
    {f_a_data_verifica   ""}

    {f_descr_topo        ""}
    {f_descr_via         ""}
    {f_num_max           ""}
    {f_flag_pericolosita ""}
    {f_esito_verifica    ""}
    {f_da_potenza        ""}
    {f_a_potenza         ""}
    {f_cod_tano          ""}
    {f_da_data_controllo ""}
    {f_a_data_controllo  ""}
    {flag_ente          "P"}
    {ls_cod_inco         ""}
    {flag_racc         ""}
    {flag_pres         ""}
    {f_invio_comune    ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    form_name:onevalue
    table_result:onevalue
}

if {$flag_ente == "P"} {
    db_1row query "select a.flag_ente
                         ,a.flag_prot
                         ,b.sigla as sigla_prov
                         ,a.flag_viario
                     from coimtgen a, coimprov b
                    where a.cod_prov = b.cod_provincia
                    limit 1" 
}

if {$flag_ente == "C"} {
    db_1row query "select a.flag_ente
                     ,a.flag_prot
                     ,b.sigla as sigla_prov
                     ,a.flag_viario
                     ,c.denominazione as denom_comune
                 from coimtgen a, coimprov b, coimcomu c
                where a.cod_prov = b.cod_provincia
                  and c.cod_comune = a.cod_comu 
                limit 1" 
}

iter_get_coimtgen;# 13/11/2013

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_inco cod_impianto url_list_aimp url_aimp flag_avviso flag_richiesta nome_funz nome_funz_caller extra_par caller]

if {![string equal $cod_inco ""]} {
    set link_inco [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz "" $extra_par_inco]
    set dett_tab [iter_tab_form $cod_impianto]
} else {
    set link_inco ""
    set dett_tab ""
}

if {[db_0or1row sel_stpm {}] == 0} {
    iter_return_complaint "Record non trovato"
}

# Personalizzo la pagina
set main_directory   [ad_conn package_url]

set button_label "Stampa" 
set page_title   $descrizione_stampa

set link_list [export_url_vars caller funzione nome_funz nome_funz_caller url_list_aimp url_aimp flag_avviso flag_richiesta cod_inco cod_impianto]

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
			  [list "javascript:window.close()" "Torna alla Gestione"] \
			  [list coimstpm-menu?$link_list "Stampa Documento"] \
			  "$page_title"]
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstpm"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name id_protocollo \
    -label   "Tipo Protocollo" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 25 class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtppt cod_tppt descr]

element create $form_name protocollo_dt \
    -label   "Data protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
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
lappend options_swc_formato [list "<img src=\"$logo_dir_url/doc.gif\" border=\"0\"> Doc" "doc"]

element create $form_name swc_formato \
    -label   "Formato" \
    -widget   radio \
    -datatype text \
    -options $options_swc_formato \
    -html    "class form_element" \
    -optional

element create $form_name caller             -widget hidden -datatype text -optional
element create $form_name funzione           -widget hidden -datatype text -optional
element create $form_name nome_funz          -widget hidden -datatype text -optional
element create $form_name nome_funz_caller   -widget hidden -datatype text -optional
element create $form_name extra_par          -widget hidden -datatype text -optional
element create $form_name cod_impianto       -widget hidden -datatype text -optional
element create $form_name cod_inco           -widget hidden -datatype text -optional
element create $form_name url_list_aimp      -widget hidden -datatype text -optional
element create $form_name url_aimp           -widget hidden -datatype text -optional
element create $form_name flag_avviso        -widget hidden -datatype text -optional
element create $form_name flag_richiesta     -widget hidden -datatype text -optional
element create $form_name id_stampa          -widget hidden -datatype text -optional
element create $form_name tipo_stampa        -widget hidden -datatype text -optional
element create $form_name submit             -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name f_tipo_data        -widget hidden -datatype text -optional
element create $form_name f_data             -widget hidden -datatype text -optional
element create $form_name f_cod_impianto     -widget hidden -datatype text -optional
element create $form_name f_tipo_estrazione  -widget hidden -datatype text -optional
element create $form_name f_anno_inst_da     -widget hidden -datatype text -optional
element create $form_name f_anno_inst_a      -widget hidden -datatype text -optional
element create $form_name f_cod_comb         -widget hidden -datatype text -optional
element create $form_name f_cod_enve         -widget hidden -datatype text -optional
element create $form_name f_cod_tecn         -widget hidden -datatype text -optional
element create $form_name f_cod_comune       -widget hidden -datatype text -optional
element create $form_name f_descr_topo       -widget hidden -datatype text -optional
element create $form_name f_descr_via        -widget hidden -datatype text -optional
element create $form_name f_cod_via          -widget hidden -datatype text -optional
element create $form_name f_num_max          -widget hidden -datatype text -optional
element create $form_name f_cod_area         -widget hidden -datatype text -optional
element create $form_name flag_scaduto       -widget hidden -datatype text -optional
element create $form_name f_flag_pericolosita -widget hidden -datatype text -optional
element create $form_name f_esito_verifica    -widget hidden -datatype text -optional
element create $form_name f_da_potenza        -widget hidden -datatype text -optional
element create $form_name f_a_potenza         -widget hidden -datatype text -optional
element create $form_name f_cod_tano          -widget hidden -datatype text -optional
element create $form_name f_da_data_controllo -widget hidden -datatype text -optional
element create $form_name f_a_data_controllo  -widget hidden -datatype text -optional
element create $form_name f_da_data_verifica  -widget hidden -datatype text -optional
element create $form_name f_a_data_verifica   -widget hidden -datatype text -optional
element create $form_name ls_cod_inco         -widget hidden -datatype text -optional;#rom01
element create $form_name flag_racc           -widget hidden -datatype text -optional;#gab01
element create $form_name flag_pres           -widget hidden -datatype text -optional;#gab01
element create $form_name f_invio_comune      -widget hidden -datatype text -optional;#rom01

if {[form is_request $form_name]} {
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name flag_avviso       -value $flag_avviso
    element set_properties $form_name flag_richiesta    -value $flag_richiesta
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name cod_inco          -value $cod_inco
    element set_properties $form_name cod_impianto      -value $cod_impianto
    element set_properties $form_name id_stampa         -value $id_stampa
    element set_properties $form_name tipo_stampa       -value $tipo_stampa
    element set_properties $form_name swc_formato       -value "pdf"
    element set_properties $form_name f_tipo_data       -value $f_tipo_data
    element set_properties $form_name f_data            -value $f_data
    element set_properties $form_name f_cod_impianto    -value $f_cod_impianto
    element set_properties $form_name f_tipo_estrazione -value $f_tipo_estrazione
    element set_properties $form_name f_anno_inst_da    -value $f_anno_inst_da
    element set_properties $form_name f_anno_inst_a     -value $f_anno_inst_a
    element set_properties $form_name f_cod_comb        -value $f_cod_comb
    element set_properties $form_name f_cod_enve        -value $f_cod_enve
    element set_properties $form_name f_cod_tecn        -value $f_cod_tecn
    element set_properties $form_name f_cod_comune      -value $f_cod_comune
    element set_properties $form_name f_descr_topo      -value $f_descr_topo
    element set_properties $form_name f_descr_via       -value $f_descr_via
    element set_properties $form_name f_cod_via         -value $f_cod_via
    element set_properties $form_name f_num_max         -value $f_num_max
    element set_properties $form_name f_cod_area        -value $f_cod_area
    element set_properties $form_name flag_scaduto      -value $flag_scaduto

    element set_properties $form_name f_flag_pericolosita -value $f_flag_pericolosita
    element set_properties $form_name f_esito_verifica    -value $f_esito_verifica 
    element set_properties $form_name f_da_potenza        -value $f_da_potenza
    element set_properties $form_name f_a_potenza         -value $f_a_potenza
    element set_properties $form_name f_cod_tano          -value $f_cod_tano
    element set_properties $form_name f_da_data_controllo -value $f_da_data_controllo
    element set_properties $form_name f_a_data_controllo  -value $f_a_data_controllo
    element set_properties $form_name f_da_data_verifica -value $f_da_data_verifica
    element set_properties $form_name f_a_data_verifica  -value $f_a_data_verifica
    element set_properties $form_name ls_cod_inco        -value $ls_cod_inco;#rom01
    element set_properties $form_name flag_racc          -value $flag_racc;#gab01
    element set_properties $form_name flag_pres          -value $flag_pres;#gab01
    element set_properties $form_name f_invio_comune     -value $f_invio_comune;#rom01
}

if {[form is_valid $form_name]} {

    # form valido dal punto di vista del templating system
    set id_protocollo [element::get_value $form_name id_protocollo]
    set protocollo_dt [element::get_value $form_name protocollo_dt]
    set ls_cod_inco   [element::get_value $form_name ls_cod_inco];#rom01

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

    if {$flag_avviso == "S"} {
	set tipo_documento "AV"
    } else {
	if {$flag_avviso == "N"} {
	    set tipo_documento "EV"
	} else {
	    if {$flag_richiesta == "S"} {
		set tipo_documento "GE"
	    }
	}
    }

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    #recupero la data odierna 
    set edit_data [iter_edit_date [iter_set_sysdate]]

    #    if {![string equal $id_protocollo ""]} {
    #		db_1row sel_docu_count ""
    #		if {$conta_prot > 0} {
    #		    element::set_error $form_name id_protocollo "Protocollo gi&agrave; esistente"
    #		    incr error_num
    #		} else {
    #		    set id_protocollo_save $id_protocollo
    #		}
    #    } else {
    #		set id_protocollo_save ""
    #		set id_protocollo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    #    }
    
    if {[string equal $protocollo_dt ""]} {
	set prot_dt ""
	#	set protocollo_dt $current_date
    } else {
	set prot_dt [iter_check_date $protocollo_dt]
	if {$prot_dt == 0} {
	    element::set_error $form_name protocollo_dt "Data non corretta"
	    incr error_num
	} else {
	    set protocollo_dt [iter_edit_date $prot_dt]
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

    set desc_progressivo ""
    set num_progressivo ""
    if {[db_0or1row query "select descr as desc_progressivo
                                , progressivo as num_progressivo 
                             from coimtppt 
                            where cod_tppt = :id_protocollo"] == 0} {
	set desc_progressivo ""
	set num_progressivo ""
    }
    set protocollo_01 "${desc_progressivo}$num_progressivo"
    

    set permanenti_dir     [iter_set_permanenti_dir]
    set permanenti_dir_url [iter_set_permanenti_dir_url]
    #    set spool_dir     [iter_set_spool_dir]
    #    set spool_dir_url [iter_set_spool_dir_url]

#sim02    set nome_file     "stp-$id_stampa-$id_utente"
#sim02    set nome_file      [iter_temp_file_name -permanenti $nome_file] 
    set nome_file2    "stp-$id_stampa-$id_utente-totale"
    set nome_file2     [iter_temp_file_name -permanenti $nome_file2]

#sim02    set file_html     "$permanenti_dir/$nome_file.html"
    set file_html2    "$permanenti_dir/$nome_file2.html"

#sim02    set file_pdf      "$permanenti_dir/$nome_file.pdf"
    set file_pdf2     "$permanenti_dir/$nome_file2.pdf"

#sim02    set file_pdf_url  "$permanenti_dir_url/$nome_file.pdf"
    set file_pdf_url2 "$permanenti_dir_url/$nome_file2.pdf"

    set file_doc      "$permanenti_dir/$nome_file2.doc"
    set file_doc_url  "$permanenti_dir_url/$nome_file2.doc"
    # apro file temporaneo
    set file_id2     [open $file_html2 w]
    fconfigure $file_id2 -encoding iso8859-1

    if {$protocollo_dt != ""} {
	set protocollo_dt_edit  [iter_edit_date $protocollo_dt]
    } else {
	set protocollo_dt_edit  $protocollo_dt
    }
    
    # Data del giorno
    set oggi [iter_edit_date [iter_set_sysdate]]
    
    if {[string equal $cod_inco ""]} {

	if {![string equal $ls_cod_inco ""]} {#rom01 if else e loro contenuto
	    set where_ls_inco "and cod_inco in ('[join $ls_cod_inco ',']')"
	} else {
	    set where_ls_inco ""
	}

	# imposto il filtro per numero massimo
	if {![string equal $f_num_max ""]} {
	    set limit_ora "where rownum <= $f_num_max"
	    set limit_pos "limit $f_num_max"
	} else {
	    set limit_ora ""
	    set limit_pos ""
	}
	
	# imposto filtro per data
	if {![string equal $f_data ""]} {
	    switch $f_tipo_data {
		"A" {set where_data "and a.data_assegn       = :f_data"}
		"E" {set where_data "and a.data_estrazione   = :f_data"}
		"I" {set where_data "and a.data_verifica     = :f_data"}
	    }
	} else {
	    set where_data ""
	}
	
	if {![string equal $f_cod_impianto ""]} {
	    set where_codice "and b.cod_impianto_est = upper(:f_cod_impianto)"
	} else {
	    set where_codice ""
	}
	
	# imposto il filtro per il tecnico
	if {![string equal $f_cod_tecn ""]} {
	    set where_tecn "and a.cod_opve = :f_cod_tecn"
	} else {
	    set where_tecn ""
	}
	
	# imposto il filtro per comune
	if {![string equal $f_cod_comune ""]} {
	    set where_comune "and b.cod_comune = :f_cod_comune"
	} else {
	    set where_comune ""
	}
	
	# imposto filtro per via
	if {![string equal $f_cod_via ""]} {
	    set where_via "and b.cod_via = :f_cod_via"
	} else {
	    set where_via ""
	}
	
	# imposto filtro per tipo estrazione
	if {![string equal $f_tipo_estrazione ""]} {
	    set where_tipo_estr "and a.tipo_estrazione = :f_tipo_estrazione"
	} else {
	    set where_tipo_estr ""
	}
	
	# imposto filtro per combustibile
	if {![string equal $f_cod_comb ""]} {
	    set where_comb "and b.cod_combustibile = :f_cod_comb"
	} else {
	    set where_comb ""
	}
	
	# imposto filtro per data
	if {![string equal $f_anno_inst_da ""]} {
	    if {$flag_avviso == "N"} {
		set where_anno_inst_da "and substr(h.data_installaz,1,4) >= :f_anno_inst_da"
	    } else {
		set where_anno_inst_da "and substr(b.data_installaz,1,4) >= :f_anno_inst_da"
	    }

	} else {
	    set where_anno_inst_da ""
	}

	if {![string equal $f_anno_inst_a ""]} {
	    if {$flag_avviso == "N"} {
		set where_anno_inst_a  "and substr(h.data_installaz,1,4) <= :f_anno_inst_a"
	    } else {
		set where_anno_inst_a  "and substr(b.data_installaz,1,4) <= :f_anno_inst_a"
	    }
	} else {
	    set where_anno_inst_a ""
	}

	# imposto filtro per data appuntamento
	if {![string equal $f_da_data_verifica ""] || ![string equal $f_a_data_verifica ""]} {
	    if {[string equal $f_da_data_verifica ""]} {
		set f_da_data_verifica "18000101"
	    }
	    if {[string equal $f_a_data_verifica ""]} {
		set f_a_data_verifica  "21001231"
	    }
	    set where_data_verifica "and a.data_verifica between :f_da_data_verifica and :f_a_data_verifica"
	} else {
	    set where_data_verifica ""
	}

	# imposto filtro per flag_pericolosita
	if {![string equal $f_flag_pericolosita ""]} {
	    set where_flag_pericolosita "and a.new1_flag_peri_8p = :f_flag_pericolosita"
	} else {
	    set where_flag_pericolosita ""
	}
	
	# imposto filtro per esito_verifica
	if {![string equal $f_esito_verifica ""]} {
	    set where_esito_verifica "and a.esito_verifica = :f_esito_verifica"
	} else {
	    set where_esito_verifica ""
	}
	
	# imposto filtro per da_data_controllo
	if {![string equal $f_da_data_controllo ""]} {
	    set where_da_data_controllo "and a.data_controllo >= :f_da_data_controllo"
	} else {
	    set where_da_data_controllo ""
	}
	
	# imposto filtro per a_data_controllo
	if {![string equal $f_a_data_controllo ""]} {
	    set where_a_data_controllo "and a.data_controllo <= :f_a_data_controllo"
	} else {
	    set where_a_data_controllo ""
	}
	
	# imposto filtro per da_potenza
	if {![string equal $f_da_potenza ""]} {
	    set where_da_potenza "and b.potenza >= :f_da_potenza"
	} else {
	    set where_da_potenza ""
	}
	
	# imposto filtro per da_potenza
	if {![string equal $f_a_potenza ""]} {
	    set where_a_potenza "and b.potenza <= :f_a_potenza"
	} else {
	    set where_a_potenza ""
	}
	
	# imposto filtro per cod_tano
	if {![string equal $f_cod_tano ""]} {
	    set where_cod_tano "and exists (select * from coimanom j where j.cod_cimp_dimp = a.cod_cimp and j.flag_origine = 'RV' and j.cod_tanom = :f_cod_tano)"
	} else {
	    set where_cod_tano ""
	}
	
	# imposto filtro per area. ricordo che per questa estrazione si considerano
	# solo le aree come raggruppamenti di comuni.
	if {![string equal $f_cod_area ""]} {
	    if {[db_0or1row sel_area_tipo_01 ""] == 0} {
		set tipo_01 ""
	    }
	    
	    set lista_comu "("
	    set conta_comu 0
	    db_foreach sel_cmar "" {
		incr conta_comu
		append lista_comu "$cod_comune,"
	    }
	    if {$conta_comu > 0} {
		set lung_lista_comu [string length $lista_comu]
		set lista_comu [string range $lista_comu 0 [expr $lung_lista_comu -2]]
		append lista_comu ")"
		
		set where_area "and b.cod_comune in $lista_comu"
	    } else {
		set where_area ""
	    }
	} else {
	    set where_area ""
	}
	
	# imposto il filtro per ente verificatore
	if {![string equal $f_cod_enve ""]} {
	    set where_enve "and a.cod_opve in (select z.cod_opve 
	                                         from coimopve z
	                                        where z.cod_enve = :f_cod_enve)"
	} else {
	    set where_enve ""
	}
	set where_inco ""

	db_1row sel_cinc ""

	switch $flag_scaduto {
	    "S" {set where_dich " and (b.data_scad_dich <= current_date
	                               or b.data_scad_dich is null)"}
	    "N" {set where_dich " and b.data_scad_dich > current_date"}
	    default {set where_dich ""}
	}
	
	if {$flag_avviso == "S"} {
	    set sel_codici_inco [db_map sel_cod_avviso]
	} else {
	    if {$flag_avviso == "N"} {
		set sel_codici_inco [db_map sel_cod_esito_cimp]
	    } else {
		if {$flag_richiesta == "S"} {
		    set sel_codici_inco [db_map sel_cod_richiesta]
		}
	    }
	}

	set lista_cod [list]
	db_foreach sel_codici $sel_codici_inco {
	    lappend lista_cod [list $cod_impianto $cod_inco]
	}
    } else {
	set where_anno_inst_da ""
	set where_anno_inst_a ""
	set where_comb ""
	set where_enve ""
	set where_inco " and a.cod_inco = :cod_inco"
	set where_data ""
	set where_codice ""
	set where_tecn ""
	set where_comune ""
	set where_via ""
	set where_tipo_estr ""
	set where_area ""
	set where_data_verifica ""
	set lista_cod [list]
	lappend lista_cod [list $cod_impianto $cod_inco]
    }

    if {[string equal $lista_cod ""]} {
	iter_return_complaint "Nessun appuntamento selezionato"
    }

    set aggiornato_protocollo "N"

    set ctr 0
    foreach codice $lista_cod {

        set cod_impianto [lindex $codice 0]
        set cod_inco     [lindex $codice 1]

	#sim02 setto il nome del file all'interno del ciclo in modo che sia sempre univoco
	set nome_file     "stp-$id_stampa-$id_utente-$cod_inco";#sim02
	set nome_file      [iter_temp_file_name -permanenti $nome_file];#sim02
	set file_html     "$permanenti_dir/$nome_file.html";#sim02
	set file_pdf      "$permanenti_dir/$nome_file.pdf"
	set file_pdf_url  "$permanenti_dir_url/$nome_file.pdf";#sim02

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
	
	if {$coimtgen(flag_stp_presso_terzo_resp) eq "T"
        &&  $flag_resp                            eq "T"
	} {;#13/11/2013
	    # se è attivo l'apposito parametro ed il responsabile è un terzo, devo stampare
            # C/O l'indirizzo del terzo responsabile.
	    # Con questa query leggo indirizzo as indirizzo_resp, cap as cap_resp, etc...
            # di coimmanu con cod_legale_rapp = :cod_responsabile 
	    db_0or1row sel_manu_resp "";#13/11/2013
	};#13/11/2013

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

	if {[string equal $cod_inco ""]} {
	    set where_cimp_inco "and a.cod_cimp = (select max(to_number(cod_cimp, '99999999')) 
                                   from coimcimp
                                  where cod_impianto = :cod_impianto)::varchar"
	} else {

	    #ric03 se non trovo il rapporto di ispezione dall'incontro prendo l'ultimo rapporto 
	    if {[db_0or1row q "select to_number(cod_cimp, '99999999') as max_cimp_inco
	       		      	 from coimcimp a
				where a.cod_inco   = :cod_inco 
                                  and cod_impianto = :cod_impianto
                             order by to_number(cod_cimp, '99999999') desc
                                limit 1"]} {
		
		set where_cimp_inco "and a.cod_cimp = :max_cimp_inco"

	    }  else {

		set where_cimp_inco "and a.cod_cimp = (select max(to_number(cod_cimp, '99999999'))
                                   from coimcimp
                                  where cod_impianto = :cod_impianto)::varchar"
	    }
	}

	if {[db_0or1row sel_cimp {}] == 0} {
	    set cod_cimp ""
	    set gen_prog ""
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
        select cod_dimp, prescrizioni, raccomandazioni, osservazioni
          from coimdimp
         where cod_impianto = :cod_impianto
           and flag_tracciato not in ('DA','G') --rom02
      order by data_controllo desc
             , cod_dimp       desc
         limit 1
    "]} {#san01: aggiunta if e suo contenuto
        set cod_dimp ""
        set prescrizioni ""
        set raccomandazioni ""
        set osservazioni ""

    }


	#   Anomalie da Rapporto di Verifica
	set anomalie "<table width=\"100%\">
	                  <tr>
	                     <td align=left valign=top>&nbsp;</td>
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
	    set riga_anom "<tr>
	                          <td>Nessuna Anomalia Riscontrata</td>
	                       </tr>"
	    append anomalie $riga_anom
	    set non_conformita "Nessuna Anomalia Riscontrata"
	}
	set riga_anom "</table>"
	append anomalie $riga_anom


	if {[string equal $cod_inco ""]} {
	    set where_codice_inco "where cod_inco = (select max(to_number(cod_inco, '99999999'))
                                 from coiminco
                                where cod_impianto = :cod_impianto)::varchar";#ric04 aggiunto ::varchar
	} else {
	    set where_codice_inco "where cod_inco = :cod_inco"
	    #sim01 vado a bloccare l'inserimento degli rcee
	    db_dml q "update coiminco set flag_blocca_rcee = 't' where cod_inco=:cod_inco";#sim01

	}

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
	

	if {[db_0or1row query "select descr as desc_progressivo
                                , progressivo as num_progressivo 
                             from coimtppt 
                            where cod_tppt = :id_protocollo"] == 0} {
	    set desc_progressivo ""
	    set num_progressivo ""
	}
	set protocollo_01 "${desc_progressivo}$num_progressivo"


	#		if {[info exists data_prot_01] && [info exists id_protocollo]} {
	#		
	#		} else {
	set data_prot_01	$protocollo_dt
	#			set protocollo_01	$id_protocollo
	#		}
	
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
	
	if {$flag_ente == "P"} {
	    set logo_img "[string tolower $flag_ente]r[string tolower $sigla_prov]-stp.gif"
	} else {
	    
	    if {$coimtgen(ente) eq "CPESARO"} {#rom03 Aggiunta if e il suo contenuto
		set logo_img "[string tolower $flag_ente][string tolower $denom_comune]-stp.jpg"
	    } else {#rom03 Aggiunta else ma non il suo contenuto
		set logo_img "[string tolower $flag_ente][string tolower $denom_comune]-stp.gif"
	    };#rom03
	}
	
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

	set certificato_iso "
	    <table width=100%>
	          <tr><td align=center><img src=$logo_dir/certificato_iso.jpg height=45></td></tr>
	    </table>"
	
	set indirizzo_resp_aln "
	           <table width=\"100%\">
	              <tr>
	                 <td width=60%>&nbsp;</td>
	                 <td width=40%>Spett.le/Al Sig.</td>
	              </tr>
	              <tr>
	                 <td>&nbsp;</td>
	                 <td>$nome_resp</td>
	              </tr>
	              <tr>
	                 <td>&nbsp;</td>
	                 <td>$indirizzo_resp</td>
	              </tr>
	              <tr>
	                 <td>&nbsp;</td>
	                 <td>$cap_resp $localita_resp $comune_resp ($provincia_resp)</td>
	              </tr>
	           </table>"
#but01 aggiunto indirizzo_resp_aln2 per la nuova modifica della stampa Avviso di ispezione

set indirizzo_resp_aln2 "
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
                 <td>&nbsp;</td>
                 <td>Is.-Fab.-Sc.-P.-Int.-</td></tr>
               <tr>
                <td>&nbsp;</td>
                 <td><b>$cap_resp $localita_resp $comune_resp ($provincia_resp)</b></td>
                </tr>
           </table>"
	
	set indirizzo_sindaco "
	           <table width=\"100%\">
	              <tr>
	                 <td width=60%>&nbsp;</td>
	                 <td width=40%>Spett.le/Al Sig.</td>
	              </tr>
	              <tr>
	                 <td>&nbsp;</td>
	                 <td>SINDACO DEL COMUNE DI $comune_impianto</td>
	              </tr>
	              <tr>
	                 <td>&nbsp;</td>
	                 <td>$cap_impianto $comune_impianto</td>
	              </tr>
	           </table>"
	
	set firma_dirig "
	           <table width=\"100%\">
	                  <tr>
	                     <td width=50%>&nbsp;</td>
	                     <td width=50% align=center>Il Dirigente del servizio</td>
	                  </tr>
	                  <tr>
	                     <td>&nbsp;</td>
	                     <td align=center>Ing. Gabriele Alifraco</td>
	                  </tr>
	           </table>
	            "
	
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
	
	#anomalie impianto e schede rilievo
	set titolo ""
	set testo_anom ""
	set scrivi_anom {
	    
	    # ho messo la table perche' htmldoc mette il salto pagina dopo
	    # l'ultima table (e prima c'erano solo dei br).
	    set titolo "
	          <table cellpadding=0 cellspacing=0><tr><td></td></tr></table>
	          <br style=\"page-break-before:always\">"
	    
	    append titolo $logo
	    append titolo "
	          <table width=100%>
	            <tr><td colspan=2>&nbsp;</td></tr>
	            <tr>
	               <td valign=top colspan=2><b>ELENCO ANOMALIE RIGUARDANTI L'IMPIANTO TERMICO O IL LOCALE CALDAIA</b></td>
	            </tr>"
	    
	    set flag_anom "N"
	    db_foreach sel_cimp_anom "" {
		db_foreach sel_anom_cimp "" {
		    append anomalie "
		                    <tr>
		                       <td>$descr_breve</td>
		                       <td>$descr_tano</td>
		                    </tr>"
		    set flag_anom "S"
		}
	    }
	    
	    if {![string equal $anomalie ""]} {
		append testo_anom $titolo
		append testo_anom $anomalie
		append testo_anom "</table>"
	    }

	    set titolo ""
	    set anomalie ""
	    #	if {$potenza_nominale > 35} {
	    db_foreach sel_cimp_anom "" {
		if {[db_0or1row sel_srcm ""]} {
		    if {$flag_anom == "S"} {
			set titolo "<table cellpadding=0 cellspacing=0><tr><td></td></tr></table>"
		    } else {
			set titolo "<table cellpadding=0 cellspacing=0><tr><td></td></tr></table>
		                      <br style=\"page-break-before:always\">"
			append titolo $logo
		    }
		    append titolo "
	                <table width=100%>
	                     <tr><td>&nbsp;</td></tr>
	                     <tr>
	                        <td valign=top><b>ELENCO ANOMALIE SCHEDA DI RILIEVO PER IMPIANTI TERMICI A METANO</b></td>
	                     </tr>
	                     <tr><td>&nbsp;</td></tr>"
		    if {[string equal $se_intercapedine "N"]} {
			append anomalie "
		                <tr><td>L' intercapedine di accesso esterno &egrave; inferiore a 0,9 mt.</td>
		                </tr>"
		    }
		    if {[string equal $porta_classe_0 "N"]} {
			append anomalie "<tr><td>Caratteristiche costruttive della porta accesso esterno inadeguate</td></tr>"
		    }
		    if {[string equal $porta_con_apertura_esterno "N"]} {
			append anomalie "
		                <tr><td>Caratteristiche costruttive della porta accesso esterno inadeguate</td>
		                </tr>"
		    }
		    if {[string equal $dimensioni_porta "N"]} {
			append anomalie "
		                <tr><td>Le dimensioni minime previste per la porta di accesso esterno non sono rispettate</td>
		                </tr>"
		    }
		    if {[string equal $disimpegno "N"]} {
			append anomalie "
		                <tr><td>Accesso interno alla centrale termica senza disimpegno</td>
		                </tr>"
		    }
		    if {[string equal $da_disimp_con_lato_est "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno non ha la parete che attesta a cielo libero</td>
		                </tr>"
		    }
		    if {[string equal $da_disimp_rei_30 "N"]} {
			append anomalie "
		                <tr><td>Porta inadeguata ingresso disimpegno</td>
		                </tr>"
		    }
		    if {[string equal $da_disimp_rei_60 "N"]} {
			append anomalie "
		                <tr><td>Porta inadeguata ingresso disimpegno</td>
		                </tr>"
		    }
		    if {[string equal $aeraz_disimpegno "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno &grave; privo della condotta di aerazione</td>
		                </tr>"
		    }
		    if {[string equal $condotta_aeraz_disimp "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno &grave; privo della condotta di aerazione</td>
		                </tr>"
		    }
		    if {[string equal $porta_caldaia_rei_30 "N"]} {
			append anomalie "
		                <tr><td>Porta inadeguata ingresso caldaia</td>
		                </tr>"
		    }
		    if {[string equal $porta_caldaia_rei_60 "N"]} {
			append anomalie "
		                <tr><td>Porta inadeguata ingresso caldaia</td>
		                </tr>"
		    }
		    if {[string equal $valvola_interc_combustibile "N"]} {
			append anomalie "
		                <tr><td>Non esiste la valvola per l'intercettazione del combustibile e la relativa segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $interr_generale_luce "N"]} {
			append anomalie "
		                <tr><td>Manca l'interruttore generale luce forza e la relativa segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $estintore "N"]} {
			append anomalie "
		                <tr><td>Manca estintore classe (21A 89BC)</td>
		                </tr>"
		    }
		    if {[string equal $parete_conf_esterno "N"]} {
			append anomalie "
		                <tr><td>Il locale centrale termica non ha la parete che attesta su spazio a cielo libero</td>
		                </tr>"
		    }
		    if {[string equal $alt_locale_2 "N"]} {
			append anomalie "
		                <tr><td>L'altezza del locale caldaia &egrave; inferiore al minimo consentito (2,00 m. per pot fino 116 kW)</td>
		                </tr>"
		    }
		    if {[string equal $alt_locale_2_30 "N"]} {
			append anomalie "
		                <tr><td>L'altezza del locale caldaia &egrave; inferiore al minimo consentito (da 116 kW a 350 kW)</td>
		                </tr>"
		    }
		    if {[string equal $alt_locale_2_60 "N"]} {
			append anomalie "
		                <tr><td>L'altezza del locale caldaia &egrave; inferiore al minimo consentito (da 350 kW a 580 kW)</td>
		                </tr>"
		    }
		    if {[string equal $alt_locale_2_90 "N"]} {
			append anomalie "
		                <tr><td>L'altezza del locale caldaia &egrave; inferiore al minimo consentito (superiore 580 kW)</td>
		                </tr>"
		    }
		    if {[string equal $dispos_di_sicurezza "N"]} {
			append anomalie "
		                <tr><td>I dispositivi di sicurezza e controllo non sono facilmente raggiungibili</td>
		                </tr>"
		    }
		    if {[string equal $ventilazione_qx10 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $ventilazione_qx15 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $ventilazione_qx20 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $ventilazione_qx15_gpl "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $ispels "N"]} {
			append anomalie "
		                <tr><td>L'impianto &egrave; sprovvisto del collaudo ISPESL</td>
		                </tr>"
		    }
		    if {[string equal $cpi "N"]} {
			append anomalie "
		                <tr><td>L'impianto &egrave; sprovvisto del certificato prevenzione incendi</td>
		                </tr>"
		    }
		    if {[string equal $valv_interc_comb_segnaletica "N"]||[string equal $int_gen_luce_segnaletica "N"]||[string equal $centr_termica_segnaletica "N"]||[string equal $estintore_segnaletica "N"]} {
			append anomalie "
		                <tr><td>Segnaletica insufficiente</td>
		                </tr>"
		    }
		    if {[string equal $rampa_a_gas_norma "N"]} {
			append anomalie "
		                <tr><td>La rampa a gas non &egrave; a norma</td>
		                </tr>"
		    }
		}
		
		if {$anomalie != ""} {
		    append testo_anom $titolo
		    append testo_anom $anomalie
		    append testo_anom "</table>"
		}
		
		set anomalie ""
		set titolo ""
		if {[db_0or1row sel_srcg ""]} {
		    if {$flag_anom == "S"} {
			set titolo "
		                        <table cellpadding=0 cellspacing=0><tr><td></td></tr></table>"
		    } else {
			set titolo "
		                        <table cellpadding=0 cellspacing=0><tr><td></td></tr></table>
		                        <br style=\"page-break-before:always\">"
			append titolo $logo
		    }
		    append titolo "
	                <table width=100%>
	                     <tr><td>&nbsp;</td></tr>
	                     <tr>
	                        <td valign=top><b>ELENCO ANOMALIE SCHEDA DI RILIEVO PER IMPIANTI TERMICI AD OLIO COMBUSTIBILE O A GASOLIO</b></td>
	                     </tr>
	                     <tr><td>&nbsp;</td></tr>"
		    
		    if {[string equal $intercapedine "N"]} {
			append anomalie "
		                <tr><td>L'intercapedine di accesso esterno non a norma</td>
		                </tr>"
		    }
		    if {[string equal $portaincomb_acc_esterno "N"]} {
			append anomalie "
		                <tr><td>Il piano grigliato non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $portaincomb_acc_esterno_mag116 "N"]} {
			append anomalie "
		                <tr><td>Caratteristiche costruttive della porta accesso esterno inadeguate</td>
		                </tr>"
		    }
		    if {[string equal $dimensioni_porta "N"]} {
			append anomalie "
		                <tr><td>Caratteristiche costruttive della porta accesso esterno inadeguate</td>
		                </tr>"
		    }
		    if {[string equal $disimpegno "N"]} {
			append anomalie "
		                <tr><td>Accesso interno alla centrale termica senza disimpegno</td>
		                </tr>"
		    }
		    if {[string equal $struttura_disimp_verificabile "N"]} {
			append anomalie "
		                <tr><td>La struttura del disimpegno non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $da_disimpegno_con_lato "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno di accesso alla centrale &egrave; privo di parete esterna</td>
		                </tr>"
		    }
		    if {[string equal $da_disimpegno_senza_lato "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno non ha parete che attesta su spazio a cielo libero</td>
		                </tr>"
		    }
		    if {[string equal $aerazione_disimpegno "N"]} {
			append anomalie "
		                <tr><td>Disimpegno privo di aerazione</td>
		                </tr>"
		    }
		    if {[string equal $aerazione_tramite_condotto "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno &egrave; privo della condotta di aerazione pari a 0,1 mt.</td>
		                </tr>"
		    }
		    if {[string equal $porta_disimpegno "N"]} {
			append anomalie "
		                <tr><td>Caratteristiche costruttive della porta accesso esterno inadeguate</td>
		                </tr>"
		    }
		    if {[string equal $porta_caldaia "N"]} {
			append anomalie "
		                <tr><td>Caratteristiche costruttive della porta accesso caldaia inadeguate</td>
		                </tr>"
		    }
		    if {[string equal $loc_caldaia_rei_60 "N"]} {
			append anomalie "
		                <tr><td>La struttura del locale caldaia non &egrave; adeguata</td>
		                </tr>"
		    }
		    if {[string equal $valvola_strappo "N"]} {
			append anomalie "
		                <tr><td>Non esiste la valvola a strappo per l'intercettazione combustibile e la relativa segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $interruttore_gasolio "N"]} {
			append anomalie "
		                <tr><td>Manca l'interruttore generale luce forza e la relaiva segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $estintore "N"]} {
			append anomalie "
		                <tr><td>Manca estintore (21A 113B) e la relativa segnaletica</td>
		                </tr>"
		    }
		    if {[string equal $bocca_di_lupo "N"]} {
			append anomalie "
		                <tr><td>Il locale centrale termica non ha la parete che attesta spazio a cielo libero</td>
		                </tr>"
		    }
		    if {[string equal $parete_confinante_esterno "N"]} {
			append anomalie "
		                <tr><td>Il locale centrale termica non ha la parete che attesta spazio a cielo libero</td>
		                </tr>"
		    }
		    if {[string equal $altezza_locale "N"]} {
			append anomalie "
		                <tr><td>L'altezza del locale caldaia e&grave; inferiore a 2 mt.</td>
		                </tr>"
		    }
		    if {[string equal $altezza_230 "N"]} {
			append anomalie "
		                <tr><td>L'altezza locale caldaia e&grave; inferiore a 2,30 mt.</td>
		                </tr>"
		    }
		    if {[string equal $altezza_250 "N"]} {
			append anomalie "
		                <tr><td>L'altezza locale caldaia &egrave; inferiore a 2,50 mt.</td>
		                </tr>"
		    }
		    if {[string equal $distanza_generatori "N"]} {
			append anomalie "
		                <tr><td>Tutti i dispositivi di sicurezza e controllo sono raggiugiungibile</td>
		                </tr>"
		    }
		    if {[string equal $pavimento_imperm_soglia "N"]} {
			append anomalie "
		                <tr><td>Il pavimento non &egrave; impermeabilizzato perch&egrave; non esiste la soglia minima di 20 cm</td>
		                </tr>"
		    }
		    if {[string equal $apert_vent_sino_500000 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $apert_vent_sino_750000 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $apert_vent_sup_750000 "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del locale &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $certif_ispels "N"]} {
			append anomalie "
		                <tr><td>L'impianto &egrave; sprovvisto del collaudo ISPESL</td>
		                </tr>"
		    }
		    if {[string equal $certif_cpi "N"]} {
			append anomalie "
		                <tr><td>L'impianto &egrave; sprovvisto del certificato prevenzione incendi</td>
		                </tr>"
		    }
		    if {[string equal $serbatoio_esterno "N"]} {
			append anomalie "
		                <tr><td>Serbatoio esterno</td>
		                </tr>"
		    }
		    if {[string equal $sfiato_reticella_h "N"]} {
			append anomalie "
		                <tr><td>Sfiato del serbatoio sfociante all'esterno in posizione errata o privo di reticella antifiamma</td>
		                </tr>"
		    }
		    if {[string equal $segn_valvola_strappo "N"]||[string equal $segn_interrut_generale "N"]||[string equal $segn_estintore "N"]||[string equal $segn_centrale_termica "N"]} {
			append anomalie "
		                <tr><td>Segnaletica insufficiente</td>
		                </tr>"
		    }
		}
		
		if {$anomalie != ""} {
		    append testo_anom $titolo
		    append testo_anom $anomalie
		    append testo_anom "</table>"
		}
		
		set anomalie ""
		set titolo ""
		if {[db_0or1row sel_srdg ""]} {
		    set titolo "
	                    <table cellpadding=0 cellspacing=0><tr><td></td></tr></table>"
		    append titolo "
	                <table width=100%>
	                     <tr><td>&nbsp;</td></tr>
	                     <tr>
	                        <td valign=top><b>ELENCO ANOMALIE SCHEDA RILIEVO PER DEPOSITI DI GASOLIO</b></td>
	                     </tr>
	                     <tr><td>&nbsp;</td></tr>"
		    
		    if {[string equal $loc_escl_deposito_gasolio "N"]} {
			append anomalie "
		                <tr><td>Il locale non &egrave; destinato esclusivamente a deposito di combustibile liquido</td>
		                </tr>"
		    }
		    if {[string equal $dep_gasolio_esterno "N"]} {
			append anomalie "
		                <tr><td>DEPOSITO CON SERBATOI FUORI TERRA IN APPOSITO LOCALE ESTERNO</td>
		                </tr>"
		    }
		    if {[string equal $loc_materiale_incombustibile "N"]} {
			append anomalie "
		                <tr><td>Il locale non &egrave; realizzato in materiale incombustibile</td>
		                </tr>"
		    }
		    if {[string equal $soglia_pavimento "N"]} {
			append anomalie "
		                <tr><td>Il deposito &egrave; privo del bacino di contenimento pari alla met&agrave; del volume del serbatoio</td>
		                </tr>"
		    }
		    if {[string equal $tra_pareti_60_cm "N"]} {
			append anomalie "
		                <tr><td>Tra il serbatoio e le pareti del locale non esiste la distanza minima per le operazioni di manutenzione e ispezione</td>
		                </tr>"
		    }
		    if {[string equal $dep_serb_in_vista_aperto "N"]} {
			append anomalie "
		                <tr><td>DEPOSITO ALL'APERTO CON SERBATOI FUORI TERRA</td>
		                </tr>"
		    }
		    if {[string equal $tettoia_all_aperto "N"]} {
			append anomalie "
		                <tr><td>Non esiste la tettoia di copertura incombustibile</td>
		                </tr>"
		    }
		    if {[string equal $bacino_contenimento "N"]} {
			append anomalie "
		                <tr><td>Il deposito &egrave; privo del bacino di contenimento pari a un quarto del volume del serbatoio</td>
		                </tr>"
		    }
		    if {[string equal $dep_gasolio_interno_interrato "N"]} {
			append anomalie "
		                <tr><td>DEPOSITO CON SERBATOIO INTERRATO ALL'INTERNO DI UN EDIFICIO</td>
		                </tr>"
		    }
		    if {[string equal $porta_solaio_pareti_rei90 "N"]} {
			append anomalie "
		                <tr><td>Le pareti e il solaio non sono REI 90</td>
		                </tr>"
		    }
		    if {[string equal $struttura_locale_a_norma "N"]} {
			append anomalie "
		                <tr><td>La struttura del locale non &egrave; verificabile</td>
		                </tr>"
		    }
		    if {[string equal $dep_gasolio_interno "N"]} {
			append anomalie "
		                <tr><td>DEPOSITO CON SERBATOI FUORI TERRA ALL'INTERNO DELL'EDIFICIO</td>
		                </tr>"
		    }
		    if {[string equal $locale_caratteristiche_rei120 "N"]} {
			append anomalie "
		                <tr><td>La struttura del locale non &egrave; REI 120</td>
		                </tr>"
		    }
		    if {[string equal $tra_serb_e_pareti "N"]} {
			append anomalie "
		                <tr><td>Tra il serbatoio e le pareti del locale non esiste la distanza minima per permettere le operazioni di manutenzione e ispezione</td>
		                </tr>"
		    }
		    if {[string equal $pavimento_impermeabile "N"]} {
			append anomalie "
		                <tr><td>Il deposito &egrave; privo del bacino di contenimento pari al volume del serbatoio</td>
		                </tr>"
		    }
		    if {[string equal $accesso_esterno "N"]} {
			append anomalie "
		                <tr><td>L'accesso esterno del deposito non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $da_disimp_lato_esterno "N"]} {
			append anomalie "
		                <tr><td>Il disimpegno non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $porta_disimp "N"]} {
			append anomalie "
		                <tr><td>La porta di accesso al disimpegno non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $comunic_con_altri_loc "N"]} {
			append anomalie "
		                <tr><td>Il deposito gasolio comunica con altri ambienti</td>
		                </tr>"
		    }
		    if {[string equal $aeraz_disimp_05_mq "N"]} {
			append anomalie "
		                <tr><td>Disimpegno privo di aerazione sulla parete attestata a cielo libero pari a 0,5 mt.</td>
		                </tr>"
		    }
		    if {[string equal $aeraz_disimp_condotta "N"]} {
			append anomalie "
		                <tr><td>Disimpegno privo di aerazione tramite condotta incombustibile con superficie minima 0,1 mq. sfociante al di sopra della copertura del fabbricato</td>
		                </tr>"
		    }
		    if {[string equal $ventilazione_locale "N"]} {
			append anomalie "
		                <tr><td>La ventilazione del deposito &egrave; inadeguata</td>
		                </tr>"
		    }
		    if {[string equal $porta_esterna_incombustibile "N"]} {
			append anomalie "
		                <tr><td>La porta di accesso esterna al deposito non &egrave; a norma</td>
		                </tr>"
		    }
		    if {[string equal $porta_deposito "N"]} {
			append anomalie "
		                <tr><td>Porta accesso deposito non a norma</td>
		                </tr>"
		    }
		    if {[string equal $porta_deposito_h_2_l_08 "N"]} {
			append anomalie "
		                <tr><td>Porta accesso deposito non a norma</td>
		                </tr>"
		    }
		    if {[string equal $tubo_sfiato "N"]} {
			append anomalie "
		                <tr><td>Sfiato del serbatoio sfociante all'esterno in posizione errata o privo di reticella</td>
		                </tr>"
		    }
		    if {[string equal $messa_a_terra "N"]} {
			append anomalie "
		                <tr><td>Il serbatoio gasolio &egrave; privo della messa a terra</td>
		                </tr>"
		    }
		    if {[string equal $valvola_a_strappo "N"]} {
			append anomalie "
		                <tr><td>Non esiste la valvola a strappo per l'intercettazione combustibile con la relativa segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $interruttore_forza_luce "N"]} {
			append anomalie "
		                <tr><td>Manca l'interruttore generale luce forza con la relativa segnaletica di sicurezza</td>
		                </tr>"
		    }
		    if {[string equal $estintore "N"]||[string equal $segn_valvola_strappo "N"]||[string equal $segn_inter_forza_luce "N"]||[string equal $segn_estintore "N"]} {
			append anomalie "
		                <tr><td>Non esiste l'estintore classe 21B 113D</td>
		                </tr>"
		    }
		}
		
		if {$anomalie != ""} {
		    append testo_anom $titolo
		    append testo_anom $anomalie
		    append testo_anom "</table>"
		}
		set anomalie ""
		set titolo ""
	    }
	    # }
	    # append testo2 $testo_anom
	}
	
	# preparo la routine che serve per scrivere nel file il contenuto
	# di $testo	
	set scrivi_testo {

	    regsub -all {\n} $testo {<br />} testo
	    regsub -all "  " $testo {\&nbsp; } testo
	    
	    eval "set testo2 \"$testo\" "
	    #	eval $scrivi_anom

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
                           margin-top:    0cm;
                           margin-bottom: 0cm;
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
	    set file_id [open $file_html w]
	    fconfigure $file_id -encoding iso8859-1
	    puts $file_id $testo_docu
	}
	eval $scrivi_testo
	close $file_id

	# lo trasformo in PDF
#Sandro 18/07/2014 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont arial --fontsize 11 --textfont times --$orientamento --top 0cm --bottom 0cm --left 2cm --right 2cm -f $file_pdf $file_html]

#but01 22/12/2023 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --fontsize 11 --$orientamento --top 0cm --bottom 0cm --left 0.5cm --right 0.5cm -f $file_pdf $file_html];#Sandro 18/07/2014
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --fontsize 11 --$orientamento --top $margine_alto --bottom $margine_basso --left $margine_sinistro --right $margine_destro -f $file_pdf $file_html];#but01
	if {$ctr == 0} {
	    puts $file_id2 $testo_docu
	} else {
	    puts $file_id2 "<!-- PAGE BREAK -->"
	    puts $file_id2 $testo_docu
	}

	# Creazione documento per concessione
	db_1row get_id_documento ""
	set tipo_doc $id_stampa
	set stato_a "N"
	#set id_protocollo $id_protocollo_save

	if {$var_testo == "S"} {
	    set oggetto $nota
	} else {
	    set oggetto $descrizione_stampa
	}
	
	set sql_documento     "lo_import(:file_pdf)"
	set estensione        [ns_guesstype $file_pdf]
	
	### inserimento in documenti
	set sql_contenuto  "lo_import(:file_html)"
	set tipo_contenuto [ns_guesstype $file_pdf]
	
	set contenuto_tmpfile  $file_pdf

	set flag_docu "S"
	with_catch error_msg {
	    db_transaction {
		db_1row sel_docu_next ""
		set protocollo_01 "${desc_progressivo}$num_progressivo"
		db_dml ins_docu ""

		if {$flag_avviso == "S"} {
		    db_dml upd_inco_1 ""
		} else {
		    if {$flag_avviso == "N"} {
			db_dml upd_inco_2 ""
		    } else {
			if {$flag_richiesta == "S"} {
			    db_dml upd_inco_3 ""
			}
		    }
		}

		#ric01 Aggiunta condizione su Palermo.
		if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {

		    db_dml q "update coimdocu
		  	         set tipo_contenuto = :tipo_contenuto
			           , path_file      = :contenuto_tmpfile
			       where cod_documento  = :cod_documento"

		    
		} else {
		    



		# Controllo se il Database e' Oracle o Postgres
		set id_db [iter_get_parameter database]
		if {$id_db == "postgres"} {
		    if {[db_0or1row sel_docu_contenuto ""] == 1} {
			if {![string equal $docu_contenuto_check ""]} {
			    db_dml upd_docu_2 ""
			}
		    }		    
		    db_dml upd_docu_3 ""		    
		} else {
		    db_dml upd_docu_2 "" -blob_files [list $contenuto_tmpfile]
		}

	    }
	    }
	} {
	    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br /><b>$error_msg</b><br />
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
	}
	### fine inseriemnto in documenti
	
#ric02	ns_unlink $file_html
#sim	ns_unlink $file_pdf
file delete $file_html;#ric02
	incr ctr

	if {$flag_prot eq "S"} {  
	    db_dml query "update coimtppt set progressivo = progressivo + 1 where cod_tppt = :id_protocollo"
	    set aggiornato_protocollo "S"
	}
    }

    if {$aggiornato_protocollo eq "N"} {
	db_dml query "update coimtppt set progressivo = progressivo + 1 where cod_tppt = :id_protocollo"
    }
    close $file_id2

    # lo trasformo in PDF
    #Sandro 18/07/2014 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont times --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf2 $file_html2]

    #ric01 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont times --left 0.5cm --right 0.5cm --top 0cm --bottom 0cm -f $file_pdf2 $file_html2];#Sandro 18/07/2014
#but01 iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --top 0cm --bottom 0cm --left 0.5cm --right 0.5cm -f $file_pdf2 $file_html2];#ric01
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --size $formato --bodyfont times --top $margine_alto --bottom $margine_basso --left $margine_sinistro --right $margine_destro -f $file_pdf2 $file_html2];#but01
#ns_log notice "simone file_pdf=$file_pdf file_pdf2=$file_pdf2"

if {$nome_funz_caller eq "estr-mail"} {#rom01 if e suo contenuto

    set nome_file_email [db_string q "select replace(descrizione, ' ', '-') --sim02
                                     --sim02 descrizione
                                        from coimstpm
                                       where id_stampa =:id_stampa"]

    set nome_funz $nome_funz_caller
    #gab01 aggiunti al link_list flag_racc e flag_pres
    #rom01 aggiunto al link_list f_invio_comune
    set link_list [export_url_vars caller funzione nome_funz nome_funz_caller ls_cod_inco nome_file_email]&path_allegato=$file_pdf_url2&path_allegato_completo=$file_pdf2&flag_racc=$flag_racc&flag_pres=$flag_pres&f_invio_comune=$f_invio_comune

    set return_url "coimmail-invio?$link_list"
    ad_returnredirect $return_url
    ad_script_abort
};#rom01

    exec cp $file_html2 $file_doc

    if {$swc_formato == "pdf"} {
	ad_returnredirect "$file_pdf_url2"
    } else {
	ad_returnredirect "$file_doc_url"
    }
    ad_script_abort
}

ad_return_template
