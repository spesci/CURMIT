ad_page_contract {

    @author         abid boutheina
    @creation-date 26/06/2023 

    @cvs-id coimdimp-scar-xml-rcee.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
} {
    {f_cod_manu        ""}
    {f_manu_cogn       ""}
    {f_manu_nome       ""}
    {f_data_ins_iniz   ""}
    {f_data_ins_fine   ""}
    {f_data_controllo_iniz ""}
    {f_data_controllo_fine ""}
    {nome_funz         ""}
    {nome_funz_caller  ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


if {![string equal $f_cod_manu ""]} {

    set where_manu "and d.cod_manutentore = :f_cod_manu"
} else {
    set where_manu ""
}

if {[string equal $f_data_ins_iniz ""]} {
    set f_data_ins_iniz "18000101"
}
if {[string equal $f_data_ins_fine ""]} {
    set f_data_ins_fine "21001231"
}

set where_data_ins "and d.data_ins between :f_data_ins_iniz and :f_data_ins_fine"


if {[string equal $f_data_controllo_iniz ""]} {
    set f_data_controllo_iniz "18000101"
}
if {[string equal $f_data_controllo_fine ""]} {
    set f_data_controllo_fine "21001231"
}

set where_data_con "and d.data_controllo between :f_data_controllo_iniz and :f_data_controllo_fine"



# per facilitare l'analisi dei file xml ricevuti e restituiti, li scrivo sul file system in apposite directory
set nome_file          "Scarico RCEE xml"
set nome_file          [iter_temp_file_name -permanenti $nome_file]
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]
set file_xml           "$permanenti_dir/$nome_file.xml"
set file_xml_url       "$permanenti_dir_url/$nome_file.xml"


#se ho passato i controlli vado a creare la mutirow dei dovuti
template::multirow create rcee cod_impianto_est targa data_controllo flag_status gen_prog pdr pod comune toponimo indirizzo civico marca matricola modello combustibile cod_manutentore cognome_manu nome_manu indirizzo_manu comune_manu telefono_manu cap_manu cod_fiscale_manu cod_opmanu_new flag_responsabile nome_resp cognome_resp indirizzo_resp comune_resp provincia_resp natura_giuridica_resp cap_resp cod_fiscale_resp telefono_resp ora_inizio ora_fine num_autocert conformita  lib_impianto lib_uso_man rct_lib_uso_man_comp rct_dur_acqua rct_tratt_in_risc rct_tratt_in_acs idoneita_locale rct_install_interna ap_vent_ostruz ap_ventilaz rct_canale_fumo_idoneo rct_sistema_reg_temp_amb rct_assenza_per_comb rct_idonea_tenuta disp_comando disp_sic_manom rct_valv_sicurezza rct_scambiatore_lato_fumi rct_riflussi_comb rct_uni_10389 cod_tprc cont_rend num_prove_fumi tiraggio portata_comb portata_termica_effettiva  temp_fumi temp_ambi o2 co2 bacharach bacharach2 bacharach3 co_fumi_secchi_ppm co rend_combust rct_rend_min_legge rct_modulo_termico  rispetta_indice_bacharach co_fumi_secchi rend_magg_o_ugua_rend_min cod_strumento_01 cod_strumento_02 rct_check_list_1 rct_check_list_2 rct_check_list_3 rct_check_list_4 osservazioni raccomandazioni prescrizioni costo tipologia_costo flag_pagato data_ultima_manu data_prox_manut consumo_annuo consumo_annuo2 stagione_risc stagione_risc2

set ls_rcee [list]
set ls_rcee   [db_list_of_lists q "select   i.cod_impianto_est as cod_impianto_est
                                           , i.targa   as targa
                                           , d.data_controllo as data_controllo
                                           , d.flag_status as flag_status 
                                           , d.gen_prog as gen_prog
                                           , i.pdr as pdr
                                           , i.pod as pod
                                           , c.comune as comune
                                           , i.toponimo as toponimo
                                           , c.indirizzo as indirizzo
                                           , c.numero  as civico
                                           , cost.descr_cost as marca
                                           , g.matricola as matricola
                                           , g.modello as modello
                                           , comb.descr_comb as combustibile 
                                           , m.cod_manutentore as cod_manutentore
                                           , m.cognome as cognome_manu
                                           , m.nome as nome_manu
                                           , m.indirizzo  as indirizzo_manu
                                           , m.comune as comune_manu
                                           , m.telefono as telefono_manu
                                           , m.cap as cap
                                           , m. cod_fiscale as cod_fiscale_manu
                                           , d.cod_opmanu_new as cod_opmanu_new
                                           , i.flag_resp as flag_responsabile 
                                           , c.nome as nome_resp
                                           , c.cognome as cognome_resp
                                           , c.indirizzo as indirizzo_resp
                                           , c.comune as comune_resp
                                           , c.provincia as provincia_resp
                                           , c. natura_giuridica as natura_giuridica_resp
                                           , c.cap as cap_resp
                                           , c.cod_fiscale as cod_fiscale_resp
                                           , c.telefono as telefono_resp
                                           , d.ora_inizio as ora_inizio
                                           , d.ora_fine  as ora_fine
                                           , d.num_autocert as num_autocert
                                           , d.conformita as conformita
                                           , d.lib_impianto as lib_impianto
                                           , d.lib_uso_man as lib_uso_man 
                                           , d.rct_lib_uso_man_comp  as rct_lib_uso_man_comp
                                           , d.rct_dur_acqua   as rct_dur_acqua
                                           , d.rct_tratt_in_risc as rct_tratt_in_risc
                                           , d.rct_tratt_in_acs as rct_tratt_in_acs
                                           , d.idoneita_locale  as idoneita_locale
                                           , d.rct_install_interna as rct_install_interna 
                                           , d.ap_vent_ostruz  as ap_vent_ostruz
                                           , d.ap_ventilaz as ap_ventilaz
                                           , d.rct_canale_fumo_idoneo  as rct_canale_fumo_idoneo
                                           , d.rct_sistema_reg_temp_amb  as rct_sistema_reg_temp_amb
                                           , d.rct_assenza_per_comb  as rct_assenza_per_comb 
                                           , d.rct_idonea_tenuta as rct_idonea_tenuta
                                           , d.disp_comando as disp_comando
                                           , d.disp_sic_manom as disp_sic_manom
                                           , d.rct_valv_sicurezza  as rct_valv_sicurezza
                                           , d.rct_scambiatore_lato_fumi as rct_scambiatore_lato_fumi
                                           , d.rct_riflussi_comb as rct_riflussi_comb
                                           , d.rct_uni_10389 as rct_uni_10389
                                           , d.cod_tprc  as cod_tprc
                                           , d.cont_rend as cont_rend
                                           , g.num_prove_fumi as num_prove_fumi
                                           , d.tiraggio as tiraggio
                                           , d.portata_comb as portata_comb
                                           , d.portata_termica_effettiva as portata_termica_effettiva
                                           , d.temp_fumi    as temp_fumi
                                           , d.temp_ambi    as temp_ambi
                                           , d.o2           as o2
                                           , d.co2          as co2
                                           , d.bacharach    as bacharach 
                                           , d.bacharach2   as bacharach2
                                           , d.bacharach3   as bacharach3 
                                           , d.co_fumi_secchi_ppm  as co_fumi_secchi_ppm
                                           , d.co            as co 
                                           , d.rend_combust  as rend_combust
                                           , d.rct_rend_min_legge as rct_rend_min_legge 
                                           , d.rct_modulo_termico as rct_modulo_termico 
                                           , d.rispetta_indice_bacharach as rispetta_indice_bacharach
                                           , d.co_fumi_secchi  as co_fumi_secchi
                                           , d.rend_magg_o_ugua_rend_min as rend_magg_o_ugua_rend_min
                                           , d.cod_strumento_01  as cod_strumento_01 
                                           , d.cod_strumento_02 as cod_strumento_02
                                           , d.rct_check_list_1 as rct_check_list_1
                                           , d.rct_check_list_2 as rct_check_list_2
                                           , d.rct_check_list_3 as rct_check_list_3
                                           , d.rct_check_list_4 as rct_check_list_4
                                           , d.osservazioni     as osservazioni 
                                           , d.raccomandazioni  as raccomandazioni
                                           , d.prescrizioni     as prescrizioni
                                           , d.costo           as costo 
                                           , d.tipologia_costo  as tipologia_costo
                                           , d.flag_pagato     as flag_pagato
                                           , d.data_ultima_manu  as data_ultima_manu
                                           , d.data_prox_manut   as data_prox_manut
                                           , d.consumo_annuo    as consumo_annuo
                                           , d.consumo_annuo2   as consumo_annuo2
                                           , d.stagione_risc    as stagione_risc 
                                           , d.stagione_risc2   as stagione_risc2
                                       from coimaimp i
                                           , coimmanu m
                                           , coimdimp d
                                           , coimcitt c  
                                           , coimgend g
                                       left join coimcost cost on cost.cod_cost = g.cod_cost 
                                       left join coimcomb comb on comb.cod_combustibile = g.cod_combustibile 
                                       where i.cod_impianto          = d.cod_impianto
                                            and m.cod_manutentore    = d.cod_manutentore
                                            and i.cod_responsabile   = c.cod_cittadino
                                            and d.gen_prog           = g.gen_prog
                                            and d.cod_impianto       = g.cod_impianto
					    $where_manu
                                            $where_data_ins
					    $where_data_con
"]


foreach riga_rcee $ls_rcee {
   # set rcee  $ls_rcee
    lassign $riga_rcee cod_impianto_est targa data_controllo flag_status gen_prog pdr pod comune toponimo indirizzo civico marca matricola modello combustibile cod_manutentore cognome_manu nome_manu indirizzo_manu comune_manu telefono_manu cap_manu cod_fiscale_manu cod_opmanu_new flag_responsabile nome_resp cognome_resp indirizzo_resp comune_resp provincia_resp natura_giuridica_resp cap_resp cod_fiscale_resp telefono_resp ora_inizio ora_fine num_autocert conformita  lib_impianto lib_uso_man rct_lib_uso_man_comp rct_dur_acqua rct_tratt_in_risc rct_tratt_in_acs idoneita_locale rct_install_interna ap_vent_ostruz ap_ventilaz rct_canale_fumo_idoneo rct_sistema_reg_temp_amb rct_assenza_per_comb rct_idonea_tenuta disp_comando disp_sic_manom rct_valv_sicurezza rct_scambiatore_lato_fumi rct_riflussi_comb rct_uni_10389 cod_tprc cont_rend num_prove_fumi tiraggio portata_comb portata_termica_effettiva  temp_fumi temp_ambi o2 co2 bacharach bacharach2 bacharach3 co_fumi_secchi_ppm co rend_combust rct_rend_min_legge rct_modulo_termico  rispetta_indice_bacharach co_fumi_secchi rend_magg_o_ugua_rend_min cod_strumento_01 cod_strumento_02 rct_check_list_1 rct_check_list_2 rct_check_list_3 rct_check_list_4 osservazioni raccomandazioni prescrizioni costo tipologia_costo flag_pagato data_ultima_manu data_prox_manut consumo_annuo consumo_annuo2 stagione_risc stagione_risc2

    template::multirow append rcee $cod_impianto_est $targa $data_controllo $flag_status $gen_prog $pdr $pod $comune $toponimo $indirizzo $civico $marca $matricola $modello $combustibile $cod_manutentore $cognome_manu $nome_manu $indirizzo_manu $comune_manu $telefono_manu $cap_manu $cod_fiscale_manu $cod_opmanu_new $flag_responsabile $nome_resp $cognome_resp $indirizzo_resp $comune_resp $provincia_resp $natura_giuridica_resp $cap_resp $cod_fiscale_resp $telefono_resp $ora_inizio $ora_fine $num_autocert $conformita  $lib_impianto $lib_uso_man $rct_lib_uso_man_comp $rct_dur_acqua $rct_tratt_in_risc $rct_tratt_in_acs $idoneita_locale $rct_install_interna $ap_vent_ostruz $ap_ventilaz $rct_canale_fumo_idoneo $rct_sistema_reg_temp_amb $rct_assenza_per_comb $rct_idonea_tenuta $disp_comando $disp_sic_manom $rct_valv_sicurezza $rct_scambiatore_lato_fumi $rct_riflussi_comb $rct_uni_10389 $cod_tprc $cont_rend $num_prove_fumi $tiraggio $portata_comb $portata_termica_effettiva  $temp_fumi $temp_ambi $o2 $co2 $bacharach $bacharach2 $bacharach3 $co_fumi_secchi_ppm $co $rend_combust $rct_rend_min_legge $rct_modulo_termico $rispetta_indice_bacharach $co_fumi_secchi $rend_magg_o_ugua_rend_min $cod_strumento_01 $cod_strumento_02 $rct_check_list_1 $rct_check_list_2 $rct_check_list_3 $rct_check_list_4 $osservazioni $raccomandazioni $prescrizioni $costo $tipologia_costo $flag_pagato $data_ultima_manu $data_prox_manut $consumo_annuo $consumo_annuo2 $stagione_risc $stagione_risc2


}

set pack_dir [iter_package_key]
set root_dir [acs_package_root_dir $pack_dir]
set code [template::adp_compile -file $root_dir/www/src/coimdimp-scar-xml-rcee.xml]

set xml_testo      [template::adp_eval code]

set         file_id [open $file_xml w]
fconfigure $file_id -encoding utf-8
puts       $file_id $xml_testo
close      $file_id

ns_returnfile 200 text/xml $file_xml

