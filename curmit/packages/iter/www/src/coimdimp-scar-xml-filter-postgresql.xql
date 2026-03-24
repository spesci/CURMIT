<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_manu_nome">
       <querytext>
           select cognome as f_manu_cogn
                , nome    as f_manu_nome
             from coimmanu
            where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

    <fullquery name="sel_manu">
       <querytext>
           select cod_manutentore as cod_manu_db
             from coimmanu
            where upper(cognome) $eq_cognome
              and upper(nome)    $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_batc">
       <querytext>
             select iter_edit_data(dat_prev) as dat_prev
                  , iter_edit_time(ora_prev) as ora_prev
                  , par
               from coimbatc
              where cod_batc = :cod_batc
       </querytext>
    </fullquery>

    <fullquery name="sel_batc_next">
       <querytext>
             select nextval('coimbatc_s') as cod_batc
       </querytext>
    </fullquery>

    <partialquery name="ins_batc">
      <querytext>
	       insert
                  into coimbatc
                     ( cod_batc
                     , nom
                     , flg_stat
                     , dat_prev
                     , ora_prev
                     , cod_uten_sch
                     , nom_prog
                     , par
                     , note)
                     values
		     (:cod_batc
                     ,:nom
                     ,:flg_stat
                     ,:dat_prev
                     ,:ora_prev
                     ,:cod_uten_sch
                     ,:nom_prog
                     ,:par
                     ,:note)
       </querytext>
    </partialquery>

</queryset>
