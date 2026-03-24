<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="count_gg_lavoro_opve">
       <querytext>
              select count(distinct(data_controllo)) as gg_lavoro_opve
                from coimcimp
               where data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_lettere_spe">
       <querytext>
              select count(*) as lettere_spe
                from coimdocu a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
               and  data_documento between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_lettere_spe_inf">
       <querytext>
              select count(*) as lettere_spe_inf
                from coimdocu a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and data_documento between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_lettere_spe_sup">
       <querytext>
              select count(*) as lettere_spe_sup
                from coimdocu a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and data_documento between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_riserve">
       <querytext>
              select count(*) as riserve
                from coiminco a
               where data_verifica is not null
                 and ora_verifica is null
                 and data_verifica between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_riserve_inf">
       <querytext>
              select count(*) as riserve_inf
                from coiminco a,
                     coimaimp b
               where a.data_verifica is not null
                 and a.ora_verifica is null
                 and b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and data_verifica between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_riserve_sup">
       <querytext>
              select count(*) as riserve_sup
                from coiminco a,
                     coimaimp b
               where a.data_verifica is not null
                 and a.ora_verifica is null
                 and b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and data_verifica between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff">
       <querytext>
              select count(*) as controlli_eff
              from coimcimp a,
	           coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and flag_tracciato != 'MA'
                 and data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf">
       <querytext>
              select count(*) as controlli_eff_inf
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_nnoto">
       <querytext>
              select count(*) as controlli_eff_inf_nnoto
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.cod_combustibile = '0'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

        <fullquery name="count_controlli_eff_inf_pcalo">
       <querytext>
              select count(*) as controlli_eff_inf_pcalo
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.cod_combustibile = '88'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_csolid">
       <querytext>
              select count(*) as controlli_eff_inf_csolid
                from coimcimp a,
                     coimaimp b
		left join coimcomb c on b.cod_combustibile = c.cod_combustibile --rom100
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
        --rom100 and a.cod_combustibile in ('12','6','211') --comb. solido,legna,pellet
                 and c.tipo ='S'  --rom100
		 and upper(c.descr_comb) not like 'ALTRO%' --rom100
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_gasn">
       <querytext>
              select count(*) as controlli_eff_inf_gasn
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.cod_combustibile = '5'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_gaso">
       <querytext>
              select count(*) as controlli_eff_inf_gaso
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.cod_combustibile = '3'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_gpl">
       <querytext>
              select count(*) as controlli_eff_inf_gpl
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.cod_combustibile = '4'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_inf_olio">
       <querytext>
              select count(*) as controlli_eff_inf_olio
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
		 and a.cod_combustibile not in ('4','3','5','12','6','211','88') --rom100 Aggiunto comb. 88 e tolto comb. 0
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup">
       <querytext>
              select count(*) as controlli_eff_sup
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_nnoto">
       <querytext>
              select count(*) as controlli_eff_sup_nnoto
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile = '0'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_pcalo">
       <querytext>
              select count(*) as controlli_eff_sup_pcalo
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile = '88'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    
    <fullquery name="count_controlli_eff_sup_csolid">
       <querytext>
              select count(*) as controlli_eff_sup_csolid
                from coimcimp a,
                     coimaimp b
		left join coimcomb c on b.cod_combustibile = c.cod_combustibile --rom100
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
        --rom100 and a.cod_combustibile in ('12','6','211') --comb. solido,legna,pellet
                 and c.tipo ='S'  --rom100
                 and upper(c.descr_comb) not like 'ALTRO%' --rom100
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_gasn">
       <querytext>
              select count(*) as controlli_eff_sup_gasn
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile = '5'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_gaso">
       <querytext>
              select count(*) as controlli_eff_sup_gaso
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile = '3'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_gpl">
       <querytext>
              select count(*) as controlli_eff_sup_gpl
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile = '4'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_sup_olio">
       <querytext>
              select count(*) as controlli_eff_sup_olio
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.cod_combustibile not in ('4','3','5','12','6','211','88') --rom100 Aggiunto comb. 88 e tolto comb. 0
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_eff_pos">
       <querytext>
              select count(*) as controlli_eff_pos
                from coimcimp
               where esito_verifica = 'P'
                 and data_controllo between :f_data1 and :f_data2
                 and flag_tracciato != 'MA'
       </querytext>
    </fullquery>

    <fullquery name="count_mancate_ver">
       <querytext>
              select count(*) as mancate_ver
                from coimcimp
               where flag_tracciato = 'MA'
                 and data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_controlli_con_note">
       <querytext>
              select count(distinct(cod_cimp_dimp)) as controlli_con_note
                from coimanom a,
                     coimcimp b
               where a.cod_cimp_dimp = b.cod_cimp
                 and b.data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_negativo_uni_inf">
       <querytext>
              select count(*) as negativo_uni_inf
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and data_controllo between :f_data1 and :f_data2
                 and (a.new1_co_rilevato > 1000
                 or ((a.indic_fumosita_md > '2' and a.cod_combustibile = '3')
                   or (a.indic_fumosita_md > '6' and a.cod_combustibile = '1'))) 
       </querytext>
    </fullquery>

    <fullquery name="count_negativo_uni_sup">
       <querytext>
              select count(*) as negativo_uni_sup
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and data_controllo between :f_data1 and :f_data2
                 and (a.new1_co_rilevato > 1000
                 or ((a.indic_fumosita_md > '2' and a.cod_combustibile = '3')
                   or (a.indic_fumosita_md > '6' and a.cod_combustibile = '1'))) 
       </querytext>
    </fullquery>

    <fullquery name="count_negativo_dpr_inf">
       <querytext>
              select count(*) as negativo_dpr_inf
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza < '35'
                 and a.rend_comb_conv < a.rend_comb_min
                 and data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

    <fullquery name="count_negativo_dpr_sup">
       <querytext>
              select count(*) as negativo_dpr_sup
                from coimcimp a,
                     coimaimp b
               where b.cod_impianto = a.cod_impianto
                 and b.potenza >= '35'
                 and a.rend_comb_conv < a.rend_comb_min
                 and data_controllo between :f_data1 and :f_data2
       </querytext>
    </fullquery>

</queryset>
