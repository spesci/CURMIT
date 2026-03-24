<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 28/02/2023 Aggiunto campo targa

    san01 12/08/2016 Aggiunto campo data_ultim_dich
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_inco_si_viae">
       <querytext>
select coalesce(iter_edit_data(a.data_verifica),'&nbsp;') as data_verifica
     , case a.esito
       when 'P' then 'Positivo'
       when 'N' then 'Negativo'
       else '&nbsp;'
       end as desc_esito
     , coalesce(a.ora_verifica,'&nbsp;') as ora_verifica
     , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_opve
     , c.ragione_01
     , d.cod_impianto_est
     , d.targa --rom01
     , d.flag_tipo_impianto
     , e.cognome||' '||coalesce(e.nome,'') as nome_resp
     , coalesce(e.telefono,'&nbsp;')  ||' '|| coalesce(e.cellulare,'') as telefono
     , coalesce(e.cellulare,'&nbsp;') as cellulare
     , coalesce(f.descr_topo,'')||' '||coalesce(f.descr_estesa,'')||' '||coalesce(d.numero,'')||' '||coalesce(d.esponente, '-') ||' '||coalesce(d.scala, '-') ||' '||coalesce(d.piano, '-')||' '||coalesce(d.interno, '-')as indir
     , coalesce(f.cap,'&nbsp;') as cap
     , coalesce(f.cod_qua,'&nbsp;') as cod_qua
     , coalesce(g.denominazione,'&nbsp;') ||' '||coalesce(d.localita,'') as denom_comune
     , coalesce(a.note,'&nbsp;') || 'Man.' || coalesce(zz.cognome,'-') || ' ' || coalesce(zz.nome,'-') || ' N.Gen '|| coalesce(d.n_generatori,'0') as note
     , h.descr_inst as stato_inco
     , a.stato
     , a.cod_noin
     , a.cod_inco --sim02
     , coalesce(trim(d.gb_x), '&nbsp;') || '&nbsp;'|| coalesce(trim(d.gb_y), '&nbsp;') as gb
        -- campi estratti per il csv
     , coalesce(iter_edit_data(a.data_verifica), '') as data_verifica_csv
     , case a.esito
         when 'P' then 'Positivo'
         when 'N' then 'Negativo'
         else ''
       end                          as desc_esito_csv
     , coalesce(a.ora_verifica, '') as ora_verifica_csv
     , coalesce(g.denominazione,'') ||' '||coalesce(d.localita,'') as denom_comune_csv
     , coalesce(a.note,'') || 'Man.' || coalesce(zz.cognome,'-') || ' ' || coalesce(zz.nome,'-') || 'N.Gen '|| coalesce(d.n_generatori,'0')     as note_csv
     , coalesce(f.cap, '')          as cap_csv
     , coalesce(f.cod_qua, '')      as cod_qua_csv
     , coalesce(e.telefono,'') ||' '|| coalesce(e.cellulare,'')  as telefono_csv
     , coalesce(trim(d.gb_x), '')|| ''||coalesce(trim(d.gb_y), '') as gb_csv
     , iter_edit_num(d.potenza, 0) as potenza_csv
     , case 
                   when d.data_scad_dich > current_date   then 'S'
                   else 'N'  
              end as flag_dichiarato_csv
     , coalesce(iter_edit_data(d.data_ultim_dich), '') as data_ultim_dich -- san01
     , case ll.flag_notifica
         when 'W' then 'Attesa'
         when 'A' then 'Accettata'
         when 'R' then 'Rifiutata'
         when 'E' then 'ErratoDest'
         when '1' then 'IndirErrato'
         when '2' then 'CompiutaGiac'
         when '3' then 'Deceduto'
         when '4' then 'Sconosciuto'
         when '5' then 'Trasferito'
         else ''
         end                          as desc_notifica
  from coiminco a
   $opve_join_pos coimopve b on b.cod_opve = a.cod_opve
                                $where_opve
   $enve_join_pos coimenve c on c.cod_enve = b.cod_enve
                                $where_enve
       inner join coimaimp d on d.cod_impianto = a.cod_impianto
                             $where_comune
                             $where_tipo_imp
  left outer join coimcitt e on e.cod_cittadino = d.cod_responsabile
  left outer join coimmanu zz on zz.cod_manutentore = d.cod_manutentore
  left outer join coimviae f on f.cod_via       = d.cod_via
                            and f.cod_comune    = d.cod_comune
  left outer join coimcomu g on g.cod_comune    = d.cod_comune
       inner join coiminst h on h.cod_inst      = a.stato
                            $where_area
  left outer join coimdocu ll on a.cod_documento_01 = ll.cod_documento
  where a.cod_cinc = :cod_cinc
 $where_stato
 $where_data_app
 $where_data_spe
 $where_noin
$order_by
       </querytext>
    </fullquery>

    <fullquery name="sel_inco_no_viae">
       <querytext>
select coalesce(iter_edit_data(a.data_verifica),'&nbsp;') as data_verifica
     , case a.esito
       when 'P' then 'Positivo'
       when 'N' then 'Negativo'
       else '&nbsp;'
       end as desc_esito
     , coalesce(a.ora_verifica,'&nbsp;') as ora_verifica
     , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_opve
     , c.ragione_01
     , d.cod_impianto_est
     , d.targa --rom01
     , d.flag_tipo_impianto
     , e.cognome||' '||coalesce(e.nome,'') as nome_resp
     , coalesce(e.telefono,'&nbsp;') as telefono
     , coalesce(e.cellulare,'&nbsp;') as cellulare
     , coalesce(d.toponimo,'')||' '||coalesce(d.indirizzo,'')||' '||coalesce(d.numero,'')||' '||coalesce(d.esponente, '') as indir
     , coalesce(g.denominazione,'&nbsp;') as denom_comune
     , coalesce(a.note,'&nbsp;') as note
     , h.descr_inst as stato_inco
     , coalesce(d.cap,'&nbsp;') as cap
     , coalesce(d.cod_qua,'&nbsp;') as cod_qua
     , coalesce(d.gb_x, '') as gb_x
     , coalesce(d.gb_y, '') as gb_y
     , iter_edit_num(d.potenza, 0) as potenza_csv
     , coalesce(d.flag_dichiarato, '') as flag_dichiarato_csv

  from coiminco a
   $opve_join_pos coimopve b on b.cod_opve = a.cod_opve
                                $where_opve
   $enve_join_pos coimenve c on c.cod_enve = b.cod_enve
                                $where_enve
       inner join coimaimp d on d.cod_impianto = a.cod_impianto
                             $where_comune
                             $where_tipo_imp
  left outer join coimcitt e on e.cod_cittadino = d.cod_responsabile
  left outer join coimcomu g on g.cod_comune    = d.cod_comune
       inner join coiminst h on h.cod_inst      = a.stato
  left outer join coimdocu ll on a.cod_documento_01 = ll.cod_documento
 where a.cod_cinc = :cod_cinc
 $where_stato
 $where_data_app
 $where_data_spe
$order_by
       </querytext>
    </fullquery>

    <fullquery name="sel_opve">
       <querytext>
        select a.cognome||' '||coalesce(a.nome,'') as nome_opve
             , b.ragione_01
          from coimopve a
             , coimenve b
         where a.cod_opve = :cod_opve
           and b.cod_enve = a.cod_enve
       </querytext>
    </fullquery>

    <fullquery name="sel_cinc">
       <querytext>
       select descrizione as desc_cinc
         from coimcinc
        where cod_cinc = :cod_cinc
       </querytext>
    </fullquery>

    <fullquery name="sel_enve">
       <querytext>
        select ragione_01
          from coimenve
         where cod_enve = :cod_enve
       </querytext>
    </fullquery>

    <fullquery name="sel_desc_stato">
       <querytext>
        select descr_inst as desc_stato
          from coiminst
         where cod_inst = :flag_stato_appuntamento
       </querytext>
    </fullquery>

   <fullquery name="sel_desc_comu">
       <querytext>
        select denominazione as desc_comune
          from coimcomu
         where cod_comune = :cod_comune
       </querytext>
    </fullquery>


</queryset>
