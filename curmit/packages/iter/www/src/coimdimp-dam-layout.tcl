ad_page_contract {

    @author Antonio Pisano
 

    USER  DATA       MODIFICHE
    ===== ========== ================================================================================================
    ric01 03/10/2025 Punto 4 MEV Marche: lettura storico ditta di manutenzione.

    gac04 16/11/2018 Varie modifiche alla stampa su richiesta della Regione Marche

    gac03 29/11/2017 modificato potenza focolare e potenza utile, aggiunto nominale e tolto lib

    gac02 19/10/2017 aggiunto num_circuiti alla stampa

    gac01 18/10/2017 aggiunta foreach e il suo contenuto per la stampa del caldo, freddo e teleriscaldamento 
    
} {
    {cod_dimp ""}
    
    {nome_funz ""}
    {flag_ins ""}
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
  # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

set img_url [iter_set_logo_dir]
set img_checked   "${img_url}/checked.bmp"
set img_unchecked "${img_url}/unchecked.bmp"


# Estraggo i dati della dichiarazione
if {![db_0or1row query "
  select 
      cod_impianto,
      cod_documento,
      flag_tracciato,
      dam_cognome_dichiarante,
      dam_nome_dichiarante,
      cod_manutentore,
      dam_tipo_tecnico,
      cod_opmanu_new,
      data_controllo as data_dich_db,
      iter_edit_data(data_controllo) as data_dich,
      cod_responsabile,
      dam_tipo_manutenzione,
      dam_flag_osservazioni,
      dam_flag_raccomandazioni,
      dam_flag_prescrizioni,
      iter_edit_num(consumo_annuo, 2) as consumo_annuo,            --gac04
      iter_edit_num(consumo_annuo2, 2) as consumo_annuo2,          --gac04
      stagione_risc,                                               --gac04
      stagione_risc2,                                              --gac04
      iter_edit_num(acquisti, 2) as acquisti,                      --gac04
      iter_edit_num(acquisti2, 2) as acquisti2,                    --gac04
      iter_edit_num(scorta_o_lett_iniz, 2) as scorta_o_lett_iniz,  --gac04
      iter_edit_num(scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2,--gac04
      iter_edit_num(scorta_o_lett_fin, 2) as scorta_o_lett_fin,    --gac04
      iter_edit_num(scorta_o_lett_fin2, 2) as scorta_o_lett_fin2   --gac04
  from coimdimp d
where cod_dimp = :cod_dimp
"]} {
    iter_return_complaint "Dati Dichiarazione non trovati"
    return
}

# Voglio salvare il documento...
if {$flag_ins eq "S"} {
    # non esiste, lo salvo come nuovo
    if {$cod_documento eq ""} {
        set sw_insert_coimdocu "t"
    # dovrebbe esistere. Lo verifico e nel caso lo salvo
    } else {
        if {[db_0or1row query "
            select 1 from coimdocu
             where cod_documento = :cod_documento"]
	} {
	    set sw_insert_coimdocu "f"
    	} else {
	    set sw_insert_coimdocu "t"
	}
    }
}

# Nominativo del responsabile
db_1row query "
    select cognome as cognome_resp,
           nome as nome_resp
    from coimcitt
    where cod_cittadino = :cod_responsabile"

# Dati dell'impianto
db_1row query "
  select trim(m.cognome || ' ' || m.nome) as installatore,
         cod_impianto_est,
         flag_tipo_impianto as flag_impianto
    from coimaimp i
         left join coimmanu m on i.cod_installatore = m.cod_manutentore
where i.cod_impianto = :cod_impianto"
    
# Nominativo del tecnico che ha svolto la manutenzione
set nome_opma    ""
set cognome_opma ""
db_0or1row query "
  select nome    as nome_opma,
         cognome as cognome_opma
    from coimopma
  where cod_opma = :cod_opmanu_new"

# Dati topografici dell'impianto
db_1row query "
    select i.indirizzo     as indirizzo_imp,
           numero          as numero_imp,
           esponente       as esponente_imp,
           scala           as scala_imp,
           piano           as piano_imp,
           interno         as interno_imp,
           c.denominazione as comune_imp,
           p.sigla         as provincia_imp
        from coimaimp i,
             coimcomu c,
             coimprov p
        where i.cod_comune = c.cod_comune
          and p.cod_provincia = c.cod_provincia
          and i.cod_impianto = :cod_impianto"

# Altri dati del manutentore/dichiarante
db_1row query "
 
select *
  from (
   select nome    as nome_manu,
           cognome as cognome_manu,
           cod_piva,
           localita_reg,
           reg_imprese,
           indirizzo as indirizzo_manu,
           telefono,
           fax,
           email,
           comune    as comune_manu,
           provincia as provincia_manu,
           flag_a,
           flag_b,
           flag_c,
           flag_d,
           flag_e,
           flag_f,
           flag_g,
           current_date as data_validita
        from coimmanu
    where cod_manutentore = :cod_manutentore

   union   --ric01 aggiunta union

      select nome    as nome_manu,
           cognome as cognome_manu,
           cod_piva,
           localita_reg,
           reg_imprese,
           indirizzo as indirizzo_manu,
           telefono,
           fax,
           email,
           comune    as comune_manu,
           provincia as provincia_manu,
           flag_a,
           flag_b,
           flag_c,
           flag_d,
           flag_e,
           flag_f,
           flag_g,
           st_data_validita as data_validita
        from coimmanu_st
    where cod_manutentore = :cod_manutentore
) as st
where st.data_validita >= :data_dich_db
order by st.data_validita
limit 1"

# Estraggo i dati dell'ente per la stampa
iter_get_coimtgen
set flag_viario  $coimtgen(flag_viario)
set flag_ente    $coimtgen(flag_ente)
set cod_prov     $coimtgen(cod_provincia)
set sigla_prov   $coimtgen(sigla_prov)
set denom_comune $coimtgen(denom_comune)

db_1row sel_desc "
  select nome_ente, 
         indirizzo    as indirizzo_ente, 
         tipo_ufficio as tipo_ufficio_ente,
         telefono     as telefono_ente,
         assessorato
    from coimdesc"

set logo_dir      [iter_set_logo_dir];#rom01
set stampe_logo_in_tutte_le_stampe [parameter::get_from_package_key -package_key iter -parameter stampe_logo_in_tutte_le_stampe -default "0"];#gac04
set stampe_logo_height             [parameter::get_from_package_key -package_key iter -parameter stampe_logo_height];#gac04
set stampe_logo_nome               [parameter::get_from_package_key -package_key iter -parameter stampe_logo_nome];#gac04

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#gac04: Aggiunta if e suo contenuto
    if {$stampe_logo_height ne ""} {
	if {$coimtgen(regione) eq "MARCHE"} {
	    set height_logo "height=28"
	} else {
	    set height_logo "height=$stampe_logo_height"
	}
    } else {
	set height_logo ""
    }
    set logo "<img src=$logo_dir/$stampe_logo_nome $height_logo>"

    if {$coimtgen(regione) eq "MARCHE"} {
	if {$coimtgen(ente) ne "CANCONA"} {
	    set logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default ""]
	    set logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"]
	    set logo_dx "<img src=$logo_dir/logo_dx_nome.png height=15>"

	} else {
	    set logo_dx "<img src=$logo_dir/logo-comune-ancona.png width=32 height=32>"
	}
    } else {
	set logo_dx ""
    }

    if {$coimtgen(ente) eq "PRC"} {
	set master_logo_dx_nome [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
	set logo_dx "<img src=$logo_dir/$master_logo_dx_nome $height_logo align=right>"

    }
} else {
    set logo_dx ""
    set logo ""
}

set html ""
# Codice per creare l'HTML di una pagina
#append html "<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->";#gac01

set create_page_cmd {
    set code [template::adp_compile -file [ad_conn file]]
    append html [template::adp_eval code]
    append html "<!-- PAGE BREAK -->"
}

set pagina_corrente 1

#gac01 set rows_per_page 20
set rows_per_page 18;#gac01
set rows 0
set key ""
# Queste sono tutte le righe sull'impianto.
# Per poter mostrare il numero di pagine in cui siamo, prima mi 
# scorro tutte le righe calcolandomi quante pagine usciranno.
db_multirow righe_tot query "
    select d.gen_prog, 
           iter_edit_data(g.data_installaz) as data_installaz, 
           iter_edit_data(d.data_ult_man_o_disatt) as data_ult_man_o_disatt,
           :installatore as installatore,
           g.flag_attivo,
           g.modello,
           g.matricola,
          (select descr_cost 
             from coimcost 
            where cod_cost = g.cod_cost) as fabbricante
      from coimdimp_gend d,
           coimgend g
     where d.gen_prog = g.gen_prog
       and d.cod_dimp = :cod_dimp
       and cod_impianto = :cod_impianto
   order by gen_prog asc" {
    incr rows 4

    if {$rows >= $rows_per_page} {
        incr pagina_corrente
        set rows 0
    }
}

set tot_pagine $pagina_corrente
set pagina_corrente 1
set rows 0


# Da qui creero' le pagine contenenti l'elenco righe

# Dopo aver calcolato il numero totale di pagine, procedo
# a travasarle una per una in una multirow temporanea,
# che conterra' solo le righe stampate nella pagina
# corrente.
set colonne [template::multirow columns righe_tot]
set variabili \$[join $colonne " \$"]
# La creo dalla definizione di quella grossa...
eval "template::multirow create righe $colonne"
template::multirow foreach righe_tot {
    # ...e la riempio con valori di quella grossa...
    eval "multirow append righe $variabili"

    incr rows 4
    if {$rows >= $rows_per_page} {
        # ...creo l'html di questa pagina e lo accodo al resto
        eval $create_page_cmd
        # ...quindi azzero la multirow temporanea.
        eval "template::multirow create righe $colonne"
        incr pagina_corrente
        if {$pagina_corrente > 1} {
            set rows_per_page 32
        }
        set rows 0
    }
}

# Uso questa multirow per riempire le righe mancanti con spazi
# ed avere sempre la firma a fondo pagina (vedi adp)
set rows_remaining [expr {$rows_per_page - $rows - 1}]
template::multirow create cont cont
for {set i 0} {$i < $rows_remaining} {incr i} {
    template::multirow append cont $i
}

# Accodo l'ultima pagina
eval $create_page_cmd


set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]

# save rml in a temporary file
set filename "coimdimp-dam-${id_utente}"
set filename [iter_temp_file_name $filename]
set file_html "$spool_dir/$filename.html"
set file_pdf  "$spool_dir/$filename.pdf"

set wfd [open $file_html w]
fconfigure $wfd -encoding "iso8859-15"


#############qui codice per fare seconda pagina.

#gac04 tolta tutta la parte relativa alla nuova installazione
#gac01 aggiunta foreach e il suo contenuto
#set pagina_corrente 2
#set rows_per_page 80
#set rows 0
#append html "
#<br>
#<br>
#<br>
#<b>In caso di nuova installazione/ristrutturazione indicare le seguenti ulteriori informazioni facendo riferimento al numero di generatore precedentemente indicato:</b><br>
#<br>
#<table width=100% border=0>"
#incr rows 5
#db_foreach query "
#    select d.gen_prog, 
#           iter_edit_data(g.data_installaz) as data_installaz, 
#           iter_edit_data(d.data_ult_man_o_disatt) as data_ult_man_o_disatt,
#           :installatore as installatore,
#           g.flag_attivo,
#           g.modello,
#           g.matricola,
#           g.cod_emissione,
#          (select descr_cost 
#             from coimcost 
#            where cod_cost = g.cod_cost) as fabbricante,
#           g.mod_funz,
#           f.sigla,
#           g.cod_flre,
#           g.locale,
#           g.tipo_foco,
#           g.tiraggio,
#           g.dpr_660_96,
#           g.cod_combustibile,
#           iter_edit_data(g.data_costruz_gen) as data_costruz_gen,
#           g.pot_focolare_lib,
#           iter_edit_num(g.pot_focolare_nom,2) as pot_focolare_nom, --gac03
#           iter_edit_num(g.pot_utile_nom,2) as pot_utile_nom, --gac03
#           g.pot_utile_lib,
#           g.cod_tpco,
#           c.descr_comb,
#           g.num_circuiti --gac02
#      from coimdimp_gend d,
#           coimgend g 
# left join coimcomb c
#        on g.cod_combustibile = c.cod_combustibile
# left join coimflre f
#        on f.cod_flre = g.cod_flre
#     where d.gen_prog = g.gen_prog
#       and d.cod_dimp = :cod_dimp
#       and cod_impianto = :cod_impianto
#   order by gen_prog asc" {
       
#       set img_acqua_calda $img_unchecked
#       set img_aria_calda $img_unchecked
#       set img_altro $img_unchecked
#       if {$mod_funz eq "1"} {
#	   set img_acqua_calda $img_checked
#       } elseif {$mod_funz eq "2"} {
#	   set img_aria_calda $img_checked
#       } else {
#	   set img_altro $img_checked
#       }
       
#       if {$flag_impianto eq "R"} {
           
#	   incr rows 16
     
#	   if {$rows >= $rows_per_page} {
#	       incr pagina_corrente
#	       set rows 0
#	   }
      
#	   set img_interno $img_unchecked
#	   set img_esterno $img_unchecked
#	   set img_esclusivo $img_unchecked
#	   set img_non_noto $img_unchecked
#	   if {$locale eq "I"} {
#	       set img_interno $img_checked
#	   } elseif {$locale eq "E"} {
#	       set img_esterno  $img_checked
#	   } elseif {$locale eq "T"} {
#	       set img_esclusivo $img_checked
#	   } else {
#	       set img_non_noto $img_checked
#	   }
	   
#          set img_camino_collettivo $img_unchecked
#           set img_camino_individuale $img_unchecked
#           set img_scarico_a_parete $img_unchecked
#           set img_non_noto $img_unchecked
# 	   if {$cod_emissione eq "C"} {
#               set img_camino_collettivo $img_checked
#           } elseif {$cod_emissione eq "I"} {
#               set img_camino_individuale  $img_checked
#           } elseif {$cod_emissione eq "P"} {
#               set img_scarico_a_parete $img_checked
#           } else {
#	       set img_non_noto $img_checked
#	   }
	   
#           set img_aperta $img_unchecked
#           set img_stagna $img_unchecked
#	   set img_nullo $img_unchecked
#           if {$tipo_foco eq "A"} {
#               set img_aperta $img_checked
#           } elseif {$tipo_foco eq "C"} {
#               set img_stagna $img_checked
#           } else {
#	       set img_nullo $img_checked
#	   }
	   
#           set img_naturale $img_unchecked
#           set img_forzato $img_unchecked
#           if {$tiraggio eq "N"} {
#	       set img_naturale $img_checked
#          } else {
#	       set img_forzato $img_checked
#           }
	   
#           set img_standard $img_unchecked
#           set img_a_bassa_temperatura $img_unchecked
#           set img_a_gas_a_condensazione $img_unchecked
#           if {$dpr_660_96 eq "S"} {
#               set img_standard $img_checked
#           } elseif {$dpr_660_96 eq "B"} {
#               set img_a_bassa_temperatura  $img_checked
#           } else {
#               set img_a_gas_a_condensazione $img_checked
#           }
	   #gac03 al posto di pot_utile_lib ho usato pot_utile_nom
#	   append html "
#<tr>
#     <td colspan=4> Generatore di calore a fiamma n.<b>$gen_prog</b> &nbsp;  data di costruzione <b>$data_costruz_gen</b> &nbsp; data di installazione <b>$data_installaz</b></td>
#</tr>
#<tr>
#     <td colspan=4> Tipo di combustibile <b>$descr_comb</b> &nbsp; Potenza termica max nominale: al focolare <b>$pot_focolare_nom</b> kW &nbsp; utile <b>$pot_utile_nom</b> kW</td>
#</tr>
#<tr>  
#     <td>Locale di installazione:</td>
#     <td> <img src=\"$img_interno\" height=\"12\" width=\"12\"> interno</td>
#     <td> <img src=\"$img_esterno\" height=\"12\" width=\"12\"> esterno</td>
#     <td> <img src=\"$img_esclusivo\" height=\"12\" width=\"12\"> locale ad uso esclusivo</td>
#</tr>
#<tr>     
#     <td>Fluido termovettore:</td>
#     <td> <img src=\"$img_acqua_calda\" height=\"12\" width=\"12\"> acqua </td>
#     <td> <img src=\"$img_aria_calda\" height=\"12\" width=\"12\"> aria </td>
#     <td> <img src=\"$img_altro\" height=\"12\" width=\"12\"> altro</td>
#</tr>
#<tr>
#     <td>Scarico Fumi: </td>
#     <td> <img src=\"$img_camino_collettivo\" height=\"12\" width=\"12\"> camino collettivo </td>
#     <td> <img src=\"$img_camino_individuale\" height=\"12\" width=\"12\"> camino individuale </td> 
#     <td> <img src=\"$img_scarico_a_parete\" height=\"12\" width=\"12\"> scarico a parete</td>
#</tr>
#<tr>
#     <td>Camera di combustione: </td>
#     <td> <img src=\"$img_aperta\" height=\"12\" width=\"12\"> aperta (B) </td>
#     <td> <img src=\"$img_stagna\" height=\"12\" width=\"12\"> stagna (C) </td>
#     <td>Tiraggio: <img src=\"$img_naturale\" height=\"12\" width=\"12\"> naturale <img src=\"$img_forzato\" height=\"12\" width=\"12\"> forzato</td>
#</tr>
#<tr>
#     <td>Classificazione caldaia:</td>
#     <td> <img src=\"$img_standard\" height=\"12\" width=\"12\"> standard </td>
#     <td> <img src=\"$img_a_bassa_temperatura\" height=\"12\" width=\"12\"> a bassa temperatura </td>
#     <td> <img src=\"$img_a_gas_a_condensazione\" height=\"12\" width=\"12\"> a gas a condensazione </td>
#</tr>
#<tr>
#  <td colspan=4>&nbsp;</td>
#</tr>
#"
#       } elseif {$flag_impianto eq "F"} {
#           
#           incr rows 10

#           if {$rows >= $rows_per_page} {
#               incr pagina_corrente
#               set rows 0
#           }

#           set img_assorb_rec_calore $img_unchecked
#           set img_ciclo_compress_motore_elettr_o_endo $img_unchecked
#           set img_assorb_fiamma_dir_alim_combust $img_unchecked
#           if {$cod_tpco eq "2" || "4"} {
#               set img_ciclo_compress_motore_elettr_o_endo $img_checked
#           } elseif {$cod_tpco eq "3"} {
#               set img_assorb_rec_calore  $img_checked
#           } elseif {$cod_tpco eq "1"} {
#               set img_assorb_fiamma_dir_alim_combust $img_checked
#           } else {
#	   }

#	   append html "
#<tr>
#    <td colspan=6>Generatore frigo/pompa di calore n.<b>$gen_prog</b>
#    data di costruzione <b>$data_costruz_gen</b>
#    data di installazione <b>$data_installaz</b></td>
#</tr>
#<tr>
#    <td>Tipo di macchina:</td>
#    <td colspan=5> <img src=\"$img_assorb_rec_calore\" height=\"12\" width=\"12\"> ad assorbimento per recupero di calore
#    &nbsp;&nbsp;&nbsp;<img src=\"$img_ciclo_compress_motore_elettr_o_endo\" height=\"12\" width=\"12\"> a ciclo di compressione con motore elettrico o endotermico</td>
#</tr>
#<tr>
#    <td>&nbsp;</td>
#    <td colspan=5> <img src=\"$img_assorb_fiamma_dir_alim_combust\" height=\"12\" width=\"12\"> ad assorbimento a fiamma ditretta con alimentazione a combustibile</td>
#</tr>
#<tr>
#    <td>Sorgente lato esterno:</td>
#    <td> <img src=\"$img_acqua_calda\" height=\"12\" width=\"12\"> acqua</td>
#    <td> <img src=\"$img_aria_calda\" height=\"12\" width=\"12\"> aria</td>
#    <td> <img src=\"$img_altro\" height=\"12\" width=\"12\"> altro</td>
#    <td>Numero di circuiti <b>$num_circuiti</b></td> <!-- #gac02 -->
#    <td>Fluido frigorifero <b>$sigla</b></td>  
#</tr>
#<tr>
#    <td colspan=3>Potenza frigorifera nominale in raffrescamento <b>$pot_focolare_nom</b> kw</td>
#    <td colspan=3>Potenza termica nominale in riscaldamento <b>$pot_focolare_lib</b> kw</td>
#</tr>
#<tr>
#  <td colspan=6>&nbsp;</td>
#</tr>
#"
	   
#       } elseif {$flag_impianto eq "T"} {

#           incr rows 6

#           if {$rows >= $rows_per_page} {
#               incr pagina_corrente
#               set rows 0
#           }

#append html "
#<td colspan=4>Scambiatore di calore n.<b>$gen_prog</b> &nbsp; Data di installazione <b>$data_installaz</b> &nbsp; Potenza termica nominale <b>$pot_focolare_nom</b></td>
#<tr>
#    <td>Alimentazione:</td>
#    <td> acqua calda ........................</td>
#    <td> acqua surriscaldata .........................</td>
#    <td> vapore .........................</td>
#    <td> altro .........................</td>
#</tr>
#<tr>
#  <td colspan=6>&nbsp;</td>
#</tr>"
	   
#       }
              
#   }

#append html "</table>
#"
set rows_remaining [expr $rows_per_page - $rows - 5]

set i 0

while {$i < $rows_remaining} {
    incr i
    append html "<br>"

    if {$i == 10000} {
	break
   }
}      

#    append html "
#<table width=100%>
#  <tr>
#    <td><b>Tecnico che ha effettuato il controllo: </b> $cognome_opma $nome_opma</td>
#  </tr>
#  <tr><td colspan=2>&nbsp;</td></tr>
#  <tr>
#      <td align=center>
#          <h6>Firma leggibile del tecnico</h6><br>
#          ..............................................................................
#      </td>
#      <td align=center>
#          <h6>Firma leggibile, per presa visione, del responsabile dell'impianto</h6><br>
#          ..............................................................................
#      </td>
#  </tr>
#</table>
#"

set html [encoding convertto "iso8859-15" $html]

puts $wfd $html
close $wfd

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 8 --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]
ns_unlink $file_html

if {$flag_ins eq "S"} {
    db_transaction {
        # Se e' un nuovo documento
        if {$sw_insert_coimdocu eq "t"} {
            set contenuto     ""
            set cod_documento [db_string query "select nextval('coimdocu_s')"]
            # AM = 'Dich. di avvenuta manutenzione'
            set tipo_documento "AM"
            db_dml query "
               insert
                 into coimdocu
                    ( cod_documento
                    , tipo_documento
                    , cod_impianto
                    , data_documento
                    , data_stampa
                    , protocollo_02
                    , data_prot_02
                    , tipo_soggetto
                    , cod_soggetto
                    , data_ins
                    , utente
           ) values ( :cod_documento
                    , :tipo_documento
                    , :cod_impianto
                    , :data_dich_db
                    , current_date
                    , null
                    , null
                    , 'C'
                    , :cod_responsabile
                    , current_date
                    , :id_utente
                )"

            # Inserisco il riferimento al documento sulla dichiarazione
            db_dml query "
            update coimdimp
               set cod_documento = :cod_documento 
             where cod_dimp = :cod_dimp"
        } else {
	    # E' un documento gia' esistente

            db_dml query "
            update coimdocu
               set data_documento = :data_dich_db
                 , data_stampa    = current_date
                 , data_mod       = current_date
                 , utente         = :id_utente
             where cod_documento  = :cod_documento"

            db_1row query "
            select contenuto
              from coimdocu
             where cod_documento = :cod_documento"

	    # Se avevo del contenuto salvato, 
	    # prima lo elimino dai large objects
	    if {$contenuto ne ""} {
		db_dml query "
                update coimdocu
                   set contenuto     = lo_unlink(coimdocu.contenuto)
                 where cod_documento = :cod_documento"
	    }
        }
        
        # Ed infine salvo il nuovo pdf nella tabella
        set tipo_contenuto [ns_guesstype $file_pdf]
        db_dml query "
        update coimdocu
           set tipo_contenuto = :tipo_contenuto
             , contenuto      = lo_import(:file_pdf)
         where cod_documento  = :cod_documento"
    }
}

ad_returnredirect "$spool_dir_url/$filename.pdf"
ad_script_abort
