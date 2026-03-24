<?xml version="1.0"?>
<!-- 
    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    rom01 28/09/2022 Aggiunta colonna pec del soggetto responsabile su richiesta di Paravan di Ucit.
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_docu_si_viae">
       <querytext>
          select iter_edit_data(a.data_documento) as data_stampa
               , b.cod_inco
               , a.data_documento
               , a.protocollo_01
               , iter_edit_data(b.data_verifica) as data_verifica
               , coalesce(c.nome, '')||' '||coalesce(c.cognome, '') as nome_opve
               , iter_edit_time(b.ora_verifica)  as ora_verifica
               , d.cod_impianto_est
               , coalesce(e.descr_topo,'')||' '||coalesce(e.descrizione,'')||' '||coalesce(d.numero,'')||' '||coalesce(d.esponente,'') as indir
               , coalesce(g.nome, '')||' '||coalesce(g.cognome, '') as nom_resp
               , coalesce(g.pec, '') as pec_resp --rom01
               , coalesce(g.indirizzo,'')||' '||coalesce(g.numero,'') as indir_resp
               , coalesce(g.localita,'') as loca_resp
               , coalesce(g.cap,'')||' '||coalesce(g.comune,'') ||' '||coalesce(g.provincia,'') as cap_comune_provincia_resp
               , coalesce(g.cap,'-') as cap_resp
               , coalesce(g.comune,'-') as comune_resp
               , coalesce(g.provincia,'-') as provincia_resp
               , d.potenza
            from coimdocu a
      inner join coiminco b on a.cod_documento = b.cod_documento_01
 left outer join coimopve c on c.cod_opve      = b.cod_opve
      inner join coimaimp d on d.cod_impianto  = a.cod_impianto
 left outer join coimviae e on e.cod_via       = d.cod_via
                           and e.cod_comune    = d.cod_comune
 left outer join coimcomu f on f.cod_comune    = d.cod_comune
 left outer join coimcitt g on g.cod_cittadino = d.cod_responsabile
           where a.data_documento = :f_data_stampa
             and a.tipo_documento = :f_tipo_documento
       </querytext>
    </fullquery>

    <fullquery name="sel_docu_no_viae">
       <querytext>
          select iter_edit_data(a.data_documento) as data_stampa
               , b.cod_inco
               , a.data_documento
               , a.protocollo_01
               , iter_edit_data(b.data_verifica) as data_verifica
               , coalesce(c.nome, '')||' '||coalesce(c.cognome, '') as nome_opve
               , iter_edit_time(b.ora_verifica) as ora_verifica
               , d.cod_impianto_est
               , coalesce(d.indirizzo,'')||' '||coalesce(d.numero,'')||' '||coalesce(d.esponente,'')||' '||coalesce(d.localita, '')||' '||coalesce(f.denominazione, '') as indir
               , coalesce(g.nome, '')||' '||coalesce(g.cognome, '') as nom_resp
               , coalesce(g.pec, '') as pec_resp --rom01
               , coalesce(g.indirizzo,'')||' '||coalesce(g.numero,'') as indir_resp
               , coalesce(g.localita,'-') as loca_resp
               , coalesce(g.cap,'')||' '||coalesce(g.comune,'') ||' '||coalesce(g.provincia,'') as cap_comune_provincia_resp
               , coalesce(g.cap,'-') as cap_resp
               , coalesce(g.comune,'-') as comune_resp
               , coalesce(g.provincia,'-') as provincia_resp
               , d.potenza
            from coimdocu a
      inner join coiminco b on a.cod_documento = b.cod_documento_01
 left outer join coimopve c on c.cod_opve      = b.cod_opve
      inner join coimaimp d on d.cod_impianto  = a.cod_impianto
 left outer join coimcomu f on f.cod_comune    = d.cod_comune
 left outer join coimcitt g on g.cod_cittadino = d.cod_responsabile
           where a.data_documento = :f_data_stampa
             and a.tipo_documento = :f_tipo_documento
       </querytext>
    </fullquery>

    <fullquery name="sel_dual_cod_bpos">
       <querytext>
           select nextval('coimbpos_s') as cod_bpos
       </querytext>
    </fullquery>



</queryset>
