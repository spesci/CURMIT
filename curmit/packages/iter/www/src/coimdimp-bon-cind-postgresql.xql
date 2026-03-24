<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================

-->
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>
      <fullquery name="sel_dati_cind">
       <querytext>
           select max(cod_cind) as cod_cind_n
            from coimcind
             where stato = '1'
       </querytext>
      </fullquery>
      <partialquery name="upd_cind">
        <querytext>
          update coimdimp
                set cod_cind = :cod_cind_n
              where cod_dimp = :cod_dimp
       </querytext>
    </partialquery>

</queryset>
