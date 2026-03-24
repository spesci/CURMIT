<?xml version="1.0"?>
/*
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================================
    rom01 02/11/2022 Corretta query sel_fatture, dalla coimfatt devo andare in left join su coimmovi e coimaimp
    rom01            altrimenti non vengono stampate tutte le fatture.  

*/
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_fatture">
       <querytext>
           select a.cod_fatt
                , a.num_fatt
                , a.matr_da
                , a.matr_a
                , a.n_bollini
                , a.imponibile
                , a.flag_pag
                , a.mod_pag
                , coalesce(a.perc_iva,22.00) as perc_iva
                , iter_edit_num(coalesce(a.perc_iva,22.00), 2) as perc_iva_edit 
                , iter_edit_data(a.data_fatt) as data_fatt
                , a.cod_sogg 
                , a.tipo_sogg 
                , a.desc_fatt
                , iter_edit_num(a.spe_legali,2) as spe_legali
                , iter_edit_num(a.spe_postali,2) as spe_postali
                , c.cod_impianto_est
                , b.riferimento
                , iter_edit_data(b.data_compet) as data_compet
             from coimfatt  as a
     --rom01    , coimmovi as  b
     --rom01    , coimaimp  as c
             left outer join coimmovi b on b.cod_fatt     = a.cod_fatt       --rom01
	     left outer join coimaimp c on c.cod_impianto = b.cod_impianto   --rom01
            where lpad(a.num_fatt, 10, '0') >= lpad(:f_da_num_fatt, 10, '0')
              and lpad(a.num_fatt, 10, '0') <= lpad(:f_a_num_fatt, 10, '0')
              and to_char(data_fatt, 'yyyy') = :anno_fatt
     --rom01  and a.cod_fatt = b.cod_fatt
     --rom01  and b.cod_impianto = c.cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_boll">
       <querytext>
           select num_fatt
                , matr_da
                , matr_a
                , n_bollini
                , imponibile
                , flag_pag
                , mod_pag
                , coalesce(perc_iva,22.00) as perc_iva
                , iter_edit_num(coalesce(perc_iva,22.00), 2) as perc_iva_edit 
                , iter_edit_data(data_fatt) as data_fatt
                , tipo_sogg
                , desc_fatt
                , iter_edit_num(spe_legali,2) as spe_legali
                , iter_edit_num(spe_postali,2) as spe_postali
             from coimfatt 
            where cod_fatt     = :cod_fatt
       </querytext>
    </fullquery>
 
    <fullquery name="sel_manu">
       <querytext>
	 select a.nome as m_nome
                , a.cognome as m_cognome
                , a.cap as m_cap
                , a.comune as m_comune
                , a.indirizzo as m_indirizzo
                , a.localita as m_localita
                , a.cod_piva as m_piva
                , a.cod_fiscale as m_cod_fiscale
             from coimmanu a
	        , coimmovi b
                , coimaimp c  
            where a.cod_manutentore = c.cod_manutentore
	      and b.cod_impianto = c.cod_impianto
	      and b.cod_fatt = :cod_fatt
       </querytext>
    </fullquery>


    <fullquery name="sel_citt">
       <querytext>
	 select a.nome as c_nome
                , a.cognome as c_cognome
                , a.cap as c_cap
                , a.comune as c_comune
                , a.indirizzo as c_indirizzo
                , a.localita as c_localita
                , a.cod_piva as c_piva
                , a.cod_fiscale as c_cod_fiscale
             from coimcitt a
            where a.cod_cittadino = :cod_sogg
       </querytext>
    </fullquery>

 </queryset>
