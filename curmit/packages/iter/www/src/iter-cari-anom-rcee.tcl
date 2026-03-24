ad_page_contract {
    Elaborazione     Caricamento anomalie RCEE
    @author          vari
    @creation-date   2017 novembre
    @cvs-id          iter_cari_anom_rcee
     USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date al campo data_ini_elab.

    rom03 19/08/2020 Fatto in modo che il caricamento tenga conto anche dei dimp con flag_tracciato='NW'.

    rom02 09/11/2017 Tolta anomalia "M14".
    
    rom01 08/11/2017 Aggiunti i campi per le anomalie dell'RCEE nella query e nella lista_anom.


} {
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
} -properties {
      context_bar:onevalue
}


set lvl 2
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

set page_title   "Caricamento anomalie da RCEE"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
set form_name "carianomrcee"
set msg ""
db_1row sel_esit "select coalesce(to_char(max(data_elaborazione),'dd/mm/yyyy'),'01/01/2010') as data_ini_elab
                       , coalesce(max(data_elaborazione),'2010-01-01') as data_elaborazione
                               from coim_d_esit
                              where (flag_tracciato = 'R1'
                                 or flag_tracciato = 'NW') --rom03"


set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}
form create $form_name \
    -html    ""
#but01 Aggiunto la classe ah-jquery-date al campo data_ini_elab.
element create $form_name data_ini_elab \
    -label   "Data inizio controlli " \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element $jq_date" \
    -optional

element create $form_name msg \
    -label   " " \
    -widget   textarea \
    -datatype text \
    -html    "rows 10 cols 80 readonly {} class form_element" \
    -optional

element create $form_name submit      -widget submit -datatype text -label "Conferma caricamento" -html "class form_submit"
element create $form_name funzione     -widget hidden -datatype text -optional
element create $form_name caller       -widget hidden -datatype text -optional
element create $form_name nome_funz    -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name msg           -value ""
    element set_properties $form_name data_ini_elab -value $data_ini_elab
    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set data_ini_elab    [element::get_value $form_name data_ini_elab]

    ns_log Notice "Inizio della procedura Caricamento anomalie RCEE"
    
   db_foreach sel_dimp_g "select a.cod_dimp
                                    , a.cod_impianto
                                    , b.cod_cost
                                    , b.modello
                                    , b.matricola
                                    , b.data_costruz_gen
                                    , b.pot_focolare_nom
                                    , b.cod_combustibile
                                    , b.data_installaz as data_installazione
                                    , b.cod_emissione
                                    , a.data_controllo
                                    , a.conformita
                                    , a.lib_impianto
                            --rom01 , a.lib_uso_man 
                            --rom01 , a.idoneita_locale
                                    , a.ap_ventilaz
                                    , a.ap_vent_ostruz
                            --rom01 , a.pendenza
                            --rom01 , a.sezioni
                            --rom01 , a.curve
                            --rom01 , a.lunghezza
                            --rom01 , a.conservazione
                            --rom01 , a.disp_comando
                            --rom01 , a.ass_perdite
                            --rom01 , a.valvola_sicur
                            --rom01 , a.disp_sic_manom
                            --rom01 , a.assenza_fughe
                            --rom01 , a.coibentazione
                            --rom01 , a.eff_evac_fum
                                    , a.cont_rend
                                    , a.temp_fumi
                                    , a.temp_ambi
                                    , a.o2
                                    , a.co2
                                    , a.bacharach
                                    , a.co
                                    , a.rend_combust
                                    , a.tiraggio
                                    , b.tiraggio as tiraggio_gend
                                    , b.tipo_foco
                                    , b.mod_funz as fluido_termovettore
                                    , b.dpr_660_96 as class_dpr
                                    , b.pot_focolare_nom as potenza_nominale
                                    , b.pot_utile_nom  as potenza_utile
                                    , a.prescrizioni
                                    , a.raccomandazioni
                                    , a.flag_status
                                    , a.potenza
                                    , a.scar_parete
                            --rom01 , a.scar_can_fu
                            --rom01 , a.scar_ca_si
                            --rom01 , a.riflussi_locale
                            --rom01 , a.pulizia_ugelli
                            --rom01 , a.antivento
                            --rom01 , a.scambiatore
                            --rom01 , a.accens_reg
                            --rom01 , a.assenza_perdite
                            --rom01 , a.vaso_esp
                                    , a.organi_integri
                            --rom01 , b.locale
                                    , a.idoneita_locale
                                    , a.rct_sistema_reg_temp_amb
                                    , a.ap_vent_ostruz
                                    , a.ap_ventilaz
                                    , a.rct_canale_fumo_idoneo
                                    , a.rct_sistema_reg_temp_amb
                                    , a.rct_assenza_per_comb
                                    , a.rct_idonea_tenuta
                                    , a.disp_comando
                                    , a.disp_sic_manom
                                    , a.rct_valv_sicurezza
                                    , a.rct_scambiatore_lato_fumi
                                    , a.rct_riflussi_comb
                                    , a.rct_uni_10389
                                    , a.rct_install_interna --san
                                 from coimdimp a
                                    , coimgend b
                                where a.cod_impianto = b.cod_impianto
                                  and a.gen_prog     = b.gen_prog
                                  and (a.flag_tracciato = 'R1'
                                    or a.flag_tracciato = 'NW') --rom03
                                  and (a.data_ins >= :data_elaborazione
                                    or a.data_mod >= :data_elaborazione)
                                  and not exists (select 1 from coimdimp aa
                                                   where aa.cod_impianto = a.cod_impianto
                                                     and aa.cod_dimp <> a.cod_dimp
                                                     and aa.data_controllo >= a.data_controllo
                                                     and aa.cod_manutentore is not null)
                                 and a.data_ins > '2008-05-01' and a.cod_manutentore is not null
     " {
	 
	 set lista_anom [list]
	 set lista_anom_m [list]
	 
	 if {$potenza_utile > $potenza_nominale} {
	     lappend lista_anom "A1"
	 }
	 if {$cod_combustibile != "7"} {
	     if {[string equal $cod_cost ""]} {
		 lappend lista_anom "C1"
	     }
	 }
	 
	 if {$cod_combustibile != "7"} {
	     if {[string equal $modello ""]} {
		 lappend lista_anom "C2"
	     }
	 }
	 
	 if {$cod_combustibile != "7"} {
	     if {[string equal $matricola ""]
	     } {
		 lappend lista_anom "C4"
	     }
	 }
	 
	 if {$cod_combustibile != "7"} {
	     if {[string equal $potenza ""]
		 || $potenza >= 35.00} {
		 lappend lista_anom "C7"
	     }
	 }
	 
	 if {[string equal $cod_combustibile ""]} {
	     lappend lista_anom "C14"
	 }
	 if {$cod_combustibile != "7"} {
	     if {[string equal $data_installazione ""]
		 || [string equal $data_installazione "1900-01-01"]} {
		 lappend lista_anom "C16"
	     }
	 }
	 if {$cod_combustibile != "7"} {
	     if {[string equal $data_costruz_gen "1900-01-01"]} {
		 lappend lista_anom "C5"
	     }
	 }
	 #rom01 aggiumte anomalie per RCEE
	 if {$idoneita_locale ne "S" && $rct_install_interna ne "S"} {
	     lappend lista_anom "D1"
	 }
	 if {$rct_install_interna ne "S" && $idoneita_locale ne "S"} {
             lappend lista_anom "D2"
         }
	 if {$ap_vent_ostruz ne "S"} {
             lappend lista_anom "D3"
         }
	 if {$ap_ventilaz ne "S"} {
             lappend lista_anom "D4"
         }
	 if {$rct_canale_fumo_idoneo ne "S"} {
             lappend lista_anom "D5"
         }
	 if {$rct_sistema_reg_temp_amb ne "S"} {
             lappend lista_anom "D6"
         }
	 if {$rct_assenza_per_comb ne "S" && ($cod_combustibile eq "4" || $cod_combustibile eq "3")} {
             lappend lista_anom "D7"
         }
	 if {$rct_idonea_tenuta ne "S"} {
             lappend lista_anom "D8"
         }
	 if {[string equal $conformita ""]
	 }  {
	     lappend lista_anom "E1"
	 }

	 if {[string equal $conformita "N"]
	 } {
	     lappend lista_anom "E3"
	 }
	 if {[string equal $conformita "C"]
	 }  {
	     lappend lista_anom "E4"
	 }

	 if {[string equal $lib_impianto ""]} {
	     lappend lista_anom "E5"
	 }
	 if {[string equal $lib_impianto "N"]} {
	     lappend lista_anom "E7"
	 }
	 if {[string equal $lib_impianto "C"]} {
	     lappend lista_anom "E8"
	 }
	 if {$disp_comando ne "S"} {
             lappend lista_anom "E9"
         }
	 if {$disp_sic_manom ne "S"} {
             lappend lista_anom "E10"
         }
	 if {$rct_valv_sicurezza ne "S"} {
             lappend lista_anom "E11"
         }
	 if {$rct_scambiatore_lato_fumi ne "S"} {
             lappend lista_anom "E12"
         }
	 if {$rct_riflussi_comb ne "N"} {
             lappend lista_anom "E13"
         }
	 if {$rct_uni_10389 ne "S"} {
             lappend lista_anom "E14"
         }

	# if {[string equal $lib_uso_man ""]} {
	#    lappend lista_anom "E9"
	# }
	# if {[string equal $lib_uso_man "N"]} {
	#     lappend lista_anom "E11"
	# }
	# if {[string equal $lib_uso_man "C"]} {
	#     lappend lista_anom "E12"
	# }
	 #rom01 -->fine
	 if {[string equal $cont_rend ""]
	 } {
	     lappend lista_anom "M1"
	 }

	 if {[string equal $cont_rend "N"]
	     || [string equal $cont_rend ""]} {
	     lappend lista_anom "M1"
	 } else {
	     if {[string equal $temp_fumi ""]
		 || $temp_fumi > 220.00} {
		 lappend lista_anom "M4"
	     }
	     if {[string equal $temp_ambi ""]
		 || $temp_ambi < -5.00 || $temp_ambi > 50} {
		 lappend lista_anom "M5"
	     }
	     if {[string equal $o2 ""]
		 || $o2 < 0.21} {
		 lappend lista_anom "M6"
	     }
	     if {[string equal $co2 ""]
		 || $co2 > 30.00} {
		 lappend lista_anom "M7"
	     }
	     if {$cod_combustibile == "1"
		 &&  ([string equal $bacharach ""]
		      || $bacharach > 2.00
		      || [string equal $bacharach "0.00"])} {
		 lappend lista_anom "M9"
	     }
	     
	     if {$cod_combustibile == "2"
		 &&  ([string equal $bacharach ""]
		      || $bacharach > 6.00)} {
		 lappend lista_anom "M9"
	     }
	     if {[string equal $co ""]
		 || $co > 1000
		 || [string equal $co "0.00"]} {
		 lappend lista_anom "M10"
	     }
	     

# rendimento 
    set rend_min ""
    if {[string equal $potenza_nominale ""]} {
		set potenza_nominale 0.1
	     }
   if {[string equal $potenza_nominale "0"]} {
		set potenza_nominale 0.1
	     }

    switch $fluido_termovettore {
	1 {
	    if {[iter_check_date $data_installazione] <= "19931029"} {
		set rend_min [expr 82 + 2*[expr log10($potenza_nominale)]]
                if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
			    }
	    if {([iter_check_date $data_installazione] > "19931029") && ([iter_check_date $data_installazione] <= "19971231")} {
		set rend_min [expr 84 + 2*[expr log10($potenza_nominale)]]
                 if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
		    }
	    if {[iter_check_date $data_installazione] > "19980101" && [iter_check_date $data_installazione] <= "20051007"} {
		switch $class_dpr {
		    S { set rend_min [expr 84 + 2*[expr log10($potenza_nominale)]] 
					    }
		    B { set rend_min [expr 87,5 + 1,5*[expr log10($potenza_nominale)]] 
			
		    }
		    G { set rend_min [expr 91 + [expr log10($potenza_nominale)]] 
			
		    }
		    default { set rend_min [expr 84 + 2*[expr log10($potenza_nominale)]] 
					    }
		}
             if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
	    }
	    if {[iter_check_date $data_installazione] >= "20051008"} {
		set rend_min [expr 89 + 2*[expr log10($potenza_nominale)]]
		if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
	    }
	}

	2 {
	    if {[iter_check_date $data_installazione] <= "19931029"} {
		set rend_min [expr 77 + 2*[expr log10($potenza_nominale)]]
		if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
	    }
	    if {[iter_check_date $data_installazione] > "19931029"} {
		set rend_min [expr 80 + 2*[expr log10($potenza_nominale)]]
		if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
	    }

	}
    }

	     if {$rend_min == ""
                &&[iter_check_date $data_installazione] <= "19931029"} {
                 set rend_min [expr 77 + 2*[expr log10($potenza_nominale)]]
                  if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
             } 


            if {$rend_min == ""
                &&([iter_check_date $data_installazione] > "19931029") && ([iter_check_date $data_installazione] <= "19971231")} {
                 set rend_min [expr 84 + 2*[expr log10($potenza_nominale)]]
                  if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
             } 


           if {$rend_min == ""
                &&([iter_check_date $data_installazione] > "19980101") && ([iter_check_date $data_installazione] <= "20051007")} {
                 set rend_min [expr 80 + 2*[expr log10($potenza_nominale)]]
                  if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
             } 

           if {$rend_min == ""
                &&([iter_check_date $data_installazione] >= "20051008")} {
                 set rend_min [expr 87 + 2*[expr log10($potenza_nominale)]]
                  if {$rend_combust < $rend_min} {
                   lappend lista_anom "M12"
                  }
             } 



	     if {![string equal $tiraggio ""]
		 && $tiraggio < 3
		 && $tiraggio_gend == "N"
		 && $tipo_foco == "A" } {
		 lappend lista_anom "M11"
	     }

           if {![string equal $tiraggio ""]
		  && $tiraggio_gend == "F"
		 && $tipo_foco == "A" } {
		 lappend lista_anom "M11"
	     }
             #if {![string equal $tiraggio ""]
             #  && $tiraggio_gend == "F"
	     #	 && $tipo_foco == "C" } {
	     #	 lappend lista_anom "M13"
	     # }
          if {![string equal $tiraggio ""]
		  && $tiraggio_gend == "N"
		 && $tipo_foco == "C" } {
		 lappend lista_anom "M11"
	     }

	 }

	 if {$flag_status == "N"} {
	     lappend lista_anom "M15"
	 }
#rom02 tolta anomalia "M14"
#         if {$flag_status == ""} {
#	     lappend lista_anom "M14"
#	 }


#	 if {![string equal $raccomandazioni ""]} {
#	     lappend lista_anom "GL1"
#	 }
	 


	 db_transaction {
	     db_dml del_anom "delete from coim_d_anom where cod_cimp_dimp = :cod_dimp"
	     set conta 0
	     foreach cod_d_tano $lista_anom {
		 if {[db_0or1row sel_descr "select descr_breve,
                                                                   gg_adattamento
                                                                 from coim_d_tano
                                                                  where cod_tano = :cod_d_tano"] == 0} {

		     append msg "tipo anomalia $cod_d_tano inesistente;
                                "
		     continue
		 }

		 incr conta
		 
		 set data_uti_inter [db_string query "select :data_controllo::date + :gg_adattamento::integer" -default ""]
#                                              ns_log Notice "prova Mariano dt uti inter $cod_d_tano $data_uti_inter"
                                              db_dml ins_anom "insert into coim_d_anom
                                                                           ( cod_cimp_dimp
                                                                           , prog_anom
                                                                           , tipo_anom
                                                                           , cod_tanom
                                                                           , dat_utile_inter
                                                                           , flag_origine
                                                                           ) values (
                                                                            :cod_dimp
                                                                           ,:conta
                                                                           , null
                                                                           ,:cod_d_tano
                                                                           ,:data_uti_inter
                                                                           , 'MH'           
                                                                           )"
	     }
	 }
     }


    set progressivo [db_string query "select coalesce(max(progressivo) + 1,1) as progressivo from coim_d_esit"]
    db_dml ins_esit "insert into coim_d_esit ( progressivo
                                              , data_elaborazione
                                              , flag_tracciato
                                              ) values (
                                               :progressivo
                                              , current_date
                                              , 'G')"


    set msg " Fine caricamento."

    element set_properties $form_name msg -value $msg
    ad_return_template

}


