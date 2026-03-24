<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_dimp">
       <querytext>
select a.cod_dimp
     , iter_edit_data(a.data_controllo) as data_controllo_edit
     , a.data_controllo 
     , a.cod_manutentore
     , case 
          when a.flag_status = 'P' then 'Positivo'
          when a.flag_status = 'N' then 'Negativo'
          else ''
       end as flag_status
       , iter_history_desc_manutentore(a.cod_manutentore,a.data_controllo) as desc_manutentore --ric01
    --ric01       , b.cognome||' '||coalesce(b.nome,'') as desc_manutentore
     , c.cognome||' '||coalesce(c.nome,'') as desc_responsabile
     , a.flag_tracciato
     , case a.flag_tracciato
          when 'H'  then 'Mod. H'
          when 'HB' then 'Mod. H bis'
          when 'G'  then 'Mod. G'
          when 'F'  then 'Mod. F'
          when 'R1' then 'RCEE Tipo 1'
	  when '1B' then 'RCEE Tipo 1 Legna'
	  when 'R2' then 'RCEE Tipo 2'
          when 'R3' then 'RCEE Tipo 3'
	  when 'R4' then 'RCEE Tipo 4'
	  when 'DA' then 'Avven. Man.'
	  when 'O1' then 'RCEE Tipo 1 Rv.Op.'
	  when 'O2' then 'RCEE Tipo 2 Rv.Op.'
          else ''
       end as flag_tracciato_edit,
       case a.stato_dich
          when null then ' '
          when 'R'  then 'Ric. storno'
          when 'S'  then 'Sost.Eff.'
          when 'A'  then 'Storno Acc.'
          when 'X'  then 'Storno Rif.'
          else ''
       end as stato_storno
      , case when a.stato_dich = 'R' 
 --rom02      and '$ruolo'     = 'admin' 
              and '$ruolo'    != 'manutentore' --rom02 31/10/2018 Sandro ha detto che solo i manutentori non devono vedere il link.
           then '<a href="#" onclick="javascript:window.open(''coimdimp-mot-storno?cod_dimp=' || a.cod_dimp || '&cod_impianto=' || a.cod_impianto || ''', ''coimdimp-mot-storno'', ''scrollbars=yes, resizable=yes, width=580, height=320'').moveTo(110,140)">Motivazione storno</a>'
	   else '' end as link_stato_dich_code --rom01
      , cod_docu_distinta
      , riferimento_pag
  from coimdimp a
  left outer join  coimmanu b on b.cod_manutentore = a.cod_manutentore
  left outer join  coimcitt c on c.cod_cittadino   = a.cod_responsabile
 where 1 = 1
$where_aimp
$where_last
$where_word
order by data_controllo desc, cod_dimp desc
       </querytext>
    </partialquery>

    <partialquery name="sel_nove">
       <querytext>
           select a.cod_nove
                , iter_edit_data(a.data_consegna) as data_consegna
                , b.cognome||' '||coalesce(b.nome,'') as desc_manu
            from coimnove a
 left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
           where a.cod_impianto = :cod_impianto
        order by a.data_consegna desc, a.cod_nove desc
       </querytext>
    </partialquery>


    <partialquery name="sel_noveb">
       <querytext>
           select a.cod_noveb
                , iter_edit_data(a.data_consegna) as data_consegna
                , b.cognome||' '||coalesce(b.nome,'') as desc_manu
            from coimnoveb a
 left outer join coimmanu  b on b.cod_manutentore = a.cod_manutentore
           where a.cod_impianto = :cod_impianto
               $where_noveb
        order by a.data_consegna desc, a.cod_noveb desc
       </querytext>
    </partialquery>

    <partialquery name="sel_coimdope">
       <querytext>
           select a.cod_dope_aimp
                , iter_edit_data(a.data_dich)         as data_dich
		, iter_history_desc_manutentore(a.cod_manutentore,a.data_dich) as desc_manu --ric01
		-- ric01, b.cognome||' '||coalesce(b.nome,'') as desc_manu
                , case
                  when a.flag_tipo_impianto = 'R' then
                  'Riscaldamento'
		   when a.flag_tipo_impianto = 'T' then 'Teleriscaldamento'  --but01
                   when a.flag_tipo_impianto = 'F' then 'Raffreddamento'     --but01
                   when a.flag_tipo_impianto = 'C' then 'Cogenerazione'      --but01
                    end     as tipo_dich
             from coimdope_aimp a
  left outer join coimmanu      b on b.cod_manutentore = a.cod_manutentore
            where a.cod_impianto = :cod_impianto
         order by a.data_dich desc, a. cod_dope_aimp desc
       </querytext>
    </partialquery>

    <partialquery name="sel_aimp_potenza">
       <querytext>
          select potenza,
                 flag_tipo_impianto
            from coimaimp 
           where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

</queryset>
