<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="edit_date_dual">
       <querytext>
       select iter_edit_data(:f_data_evas_da) as data_evas_da_ed
            , iter_edit_data(:f_data_evas_a) as data_evas_a_ed
       </querytext>
    </fullquery>

    <fullquery name="edit_num_dual">
       <querytext>
       select iter_edit_num(:f_potenza_da, 2) as potenza_da_ed
            , iter_edit_num(:f_potenza_a,  2) as potenza_a_ed
       </querytext>
    </fullquery>

    <fullquery name="get_desc_comb">
       <querytext>
       select descr_comb 
         from coimcomb
        where cod_combustibile = :f_cod_combustibile
       </querytext>
    </fullquery>

    <fullquery name="get_desc_tpim">
       <querytext>
       select descr_tpim as descr_tpim
         from coimtpim
        where cod_tpim = :f_cod_tpim
       </querytext>
    </fullquery>

    <fullquery name="sel_desc_comu">
       <querytext>
       select denominazione as desc_comu
         from coimcomu
        where cod_comune = :f_cod_comune
       </querytext>
    </fullquery>

    <fullquery name="get_todo_si_vie">
       <querytext>
       select b.cod_impianto_est as cod_imp
              , case  b.flag_tipo_impianto 
                    when 'R' then 'Risc.'
                    when 'F' then 'Raff.'
                    when 'C' then 'Cog.'
                    when 'T' then 'Tel.'
                    when '' then 'N.N.'
                  end as flag_tipo_impianto
            , a.note
            , coalesce(c.cognome,'')||' '||coalesce(c.nome,'') as resp
            , coalesce(c.indirizzo,'')||' '||coalesce(c.cap,'')||' '||coalesce(c.comune,'') as indirizzo_resp
            , coalesce(d.descr_topo, '')||' '||coalesce(d.descrizione, '')||' '||coalesce(b.numero, '') as indirizzo
            , e.denominazione   as comune
            , f.descrizione     as tipologia
            , m.verb_n          as num_verbale
            , to_char(a.data_scadenza, 'dd/mm/yyyy') as data_scadenza
            , to_char(m.data_verb, 'dd/mm/yyyy') as data_verbale
            , to_char(m.data_controllo, 'dd/mm/yyyy') as data_controllo
	 from coimtodo a
              inner join coimaimp b on b.cod_impianto  = a.cod_impianto
              inner join coimtpdo f on f.cod_tpdo      = a.tipologia
         left outer join coimcitt c on c.cod_cittadino = b.cod_responsabile
         left outer join coimviae d on d.cod_comune    = b.cod_comune
                                   and d.cod_via       = b.cod_via
         left outer join coimcomu e on e.cod_comune    = b.cod_comune 
         left outer join coimanom g on g.cod_cimp_dimp = a.cod_cimp_dimp
         left outer join coimcimp m on m.cod_cimp      = a.cod_cimp_dimp
	 left outer join coimopve p on p.cod_opve      = m.cod_opve  --rom01
        where 1 = 1          
        $where_comune
        $where_tipologia
        $where_evasione
        $where_data
        $where_data_controllo
        $where_potenza
        $where_comb
        $where_tpim	
        $where_tipo_imp
	--rom01 $where_rgen
	$where_enve --rom01
        group by b.flag_tipo_impianto
               , b.cod_impianto_est
               , a.note
               , coalesce(c.cognome,'')||' '|| coalesce(c.nome,'')
               , coalesce(c.indirizzo,'')||' '||coalesce(c.cap,'')||' '||coalesce(c.comune,'')
               , coalesce(d.descr_topo, '')||' '|| coalesce(d.descrizione, '')||' '|| coalesce(b.numero, '')
               , e.denominazione
               , f.descrizione
               , a.data_scadenza
               , m.verb_n
               , m.data_verb
               , m.data_controllo
	order by e.denominazione
       </querytext>
    </fullquery>

<fullquery name="get_todo_si_vie_num">
       <querytext>
       select count(distinct(a.cod_impianto)) as num
	 from coimtodo a
              inner join coimaimp b on b.cod_impianto  = a.cod_impianto
              inner join coimtpdo f on f.cod_tpdo      = a.tipologia
         left outer join coimcitt c on c.cod_cittadino = b.cod_responsabile
         left outer join coimviae d on d.cod_comune    = b.cod_comune
                                   and d.cod_via       = b.cod_via
         left outer join coimcomu e on e.cod_comune    = b.cod_comune 
         left outer join coimanom g on g.cod_cimp_dimp = a.cod_cimp_dimp
         left outer join coimcimp m on m.cod_cimp      = a.cod_cimp_dimp    
	 left outer join coimopve p on p.cod_opve      = m.cod_opve --rom01
         where 1 = 1  
        $where_comune
        $where_tipologia
        $where_evasione
        $where_data
        $where_data_controllo
        $where_potenza
        $where_comb
        $where_tpim	
	--rom01 $where_rgen
        $where_enve --rom01
       </querytext>
    </fullquery>

    <fullquery name="get_todo_no_vie">
       <querytext>
       select b.cod_impianto_est as cod_imp
             , case  b.flag_tipo_impianto 
                    when 'R' then 'Risc.'
                    when 'F' then 'Raff.'
                    when 'C' then 'Cog.'
                    when 'T' then 'Tel.'
                    when '' then 'N.N.'
                  end as flag_tipo_impianto
            , a.note
           , coalesce(c.cognome,'')||' '||coalesce(c.nome,'') as resp
            , coalesce(c.indirizzo,'')||' '||coalesce(c.cap,'')||' '||coalesce(c.comune,'') as indirizzo_resp
            , coalesce(b.toponimo,'')||' '||coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indirizzo
            , e.denominazione   as comune
            , f.descrizione     as tipologia
            , to_char(a.data_scadenza, 'dd/mm/yyyy') as data_scadenza
            , m.verb_n          as num_verbale
            , to_char(m.data_verb, 'dd/mm/yyyy') as data_verbale
            , to_char(m.data_controllo, 'dd/mm/yyyy') as data_controllo
	 from coimtodo a
              inner join coimtpdo f on f.cod_tpdo      = a.tipologia
         left outer join coimaimp b on b.cod_impianto  = a.cod_impianto
         left outer join coimcitt c on c.cod_cittadino = b.cod_responsabile
         left outer join coimcomu e on e.cod_comune    = b.cod_comune 
         left outer join coimanom g on g.cod_cimp_dimp = a.cod_cimp_dimp
         left outer join coimcimp m on m.cod_cimp      = a.cod_cimp_dimp    
	 left outer join coimopve p on p.cod_opve      = m.cod_opve --rom01
         where 1 = 1  
       
        $where_comune
        $where_tipologia
        $where_evasione
        $where_data
        $where_potenza
        $where_comb
        $where_tpim	
        $where_tipo_imp
	--rom01 $where_rgen
	$where_enve --rom01
        group by b.flag_tipo_impianto
               , b.cod_impianto_est
               , a.note
               , coalesce(c.cognome,'')||' '|| coalesce(c.nome,'')
               , coalesce(c.indirizzo,'')||' '||coalesce(c.cap,'')||' '||coalesce(c.comune,'')
               , coalesce(d.descr_topo, '')||' '|| coalesce(d.descrizione, '')||' '|| coalesce(b.numero, '')
               , e.denominazione
               , f.descrizione
               , a.data_scadenza
               , m.verb_n
               , m.data_verb
               , m.data_controllo
  	order by e.denominazione
       </querytext>
    </fullquery>

    <fullquery name="estrai_data">
       <querytext>
       select iter_edit_data(current_date) as data_time
       </querytext>
    </fullquery>

</queryset>
