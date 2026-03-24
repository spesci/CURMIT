<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    ric01 15/03/2023 Aggiunta if per regione Marche, per tutti gli altri enti non saranno più 
    ric01            visibili i flag relativi all'art. 11 perchè abrogati.

    gac01 21/11/2018 Modificata struttura e alcuni campi per regione marche

  -->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="cod_impianto">
<formwidget   id="cod_manutentore">
<formwidget   id="url_list_aimp">
<formwidget   id="__refreshing_p"><!-- nic01 -->
<formwidget   id="changed_field"> <!-- nic01 -->
     

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0 class=func-menu>
<tr>
<if @funzione@ ne I and @menu@ eq 1>
<td width="25%" nowrap class=@func_v;noquote@>
  <a href="coimnoveb-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
</td>
<td width="25%" nowrap class=@func_m;noquote@>
  <a href="coimnoveb-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
</td>
<td width="25%" nowrap class=@func_d;noquote@>
  <a href="coimnoveb-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
</td>
</if>
<else>
       <td width="25%" nowrap class=func-menu>Visualizza</td>
       <td width="25%" nowrap class=func-menu>Modifica</td>
       <td width="25%" nowrap class=func-menu>Cancella</td>
</else>
<if @funzione@ eq V>
   <td width="25%" nowrap class=func-menu>
     <if @coimtgen.regione@ ne "MARCHE">
       <a href="coimnoveb-layout?@link_gest;noquote@" class=func-menu target="Stampa allegato IX B">Stampa</a>
     </if>
     <else>
       <a href="coimnoveb-layout?@link_gest;noquote@" class=func-menu target="Stampa allegato IX B">Stampa dichiarazione art.284 D. Lgs. 152/2006</a>
     </else>
   </td>
</if>
<else>
   <td width="25%" nowrap class=func-menu>Stampa allegato IX B</td>
</else>
</tr>
</table>

<table width="70%" cellspacing=1 cellpadding=1 border=0>
  <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td valign=top align=left class=form_title>Progressivo:</td>
        <td valign=top align=left><formwidget id="cod_noveb">
            <formerror  id="cod_noveb"><br>
            <span class="errori">@formerror.cod_noveb;noquote@</span>
            </formerror></td>
    </tr>
    <tr>
      <td valign=top align=right class=form_title nowrap>Num. protocollo</td>
      <td valign=top><formwidget id="n_prot">
          <formerror  id="n_prot"><br>
            <span class="errori">@formerror.n_prot;noquote@</span>
          </formerror>
      </td>
    </tr>
      <tr>      
	<td valign=top align=right class=form_title>Data protocollo</td>
	<td valign=top><formwidget id="dat_prot">
            <formerror  id="dat_prot"><br>
              <span class="errori">@formerror.dat_prot;noquote@</span>
            </formerror>
	</td>
      </tr>
    <if @coimtgen.regione@ eq "MARCHE">
      <tr><td align=right colspan=4><b>modulo A</b></td></tr>
    </if>
    <else>
      <tr><td align=right colspan=2><b>modulo A</b></td></tr>
    </else>
<if @coimtgen.regione@ eq "MARCHE">
    <tr><td align=center colspan=4>DICHIARAZIONE PER IMPIANTI TERMICI CIVILI DI POTENZA TERMICA NOMINALE AL FOCOLARE > 35 kW</td></tr>
      <tr><td align=center colspan=4>(D.Lgs. 152/06 art. 284)</td></tr>
      <tr><td align=center colspan=4><i>Da allegare alla Dichiarazione di conformit�' per nuova installazione o modifica (art.284 c.1); e da allegare al Libretto d'impianto per gli impianti in esercizio (art.284 c.2);</i></td></tr>
    </if>
    <else>
      <tr><td align=center colspan=2>ATTO DI DICHIARAZIONE PER IMPIANTI TERMICI CIVILI DI POTENZA TERMICA NOMINALE > 0,035 MW</td></tr>
      <tr><td colspan=2>&nbsp;</td></tr>
      <tr><td align=center colspan=2>(D.Lgs. 152/06 art. 284 come modificato dal D.Lgs. 128/10 art. 3 comma 7)</td></tr>
      <tr><td align=center colspan=2>Da allegare alla Dichiarazione di conformit�' per nuova installazione o modifica (art.284 c.1);</td></tr>
      <tr><td align=center colspan=2>e per gli impianti in esercizio da inserire nel Libretto di Centrale (art.284 c.2);</td></tr>
    </else>
    <tr><td colspan=2>&nbsp;</td></tr>
<if @coimtgen.regione@ eq "MARCHE">
    <tr><td valign=top align=left class=form_title width=10%>Data consegna:</td>
        <td valign=top align=left><formwidget id="data_consegna">
            <formerror  id="data_consegna"><br>
            <span class="errori">@formerror.data_consegna;noquote@</span>
            </formerror>
        </td>
      <td valign=top align=right class=form_title>Luogo consegna:</td>
      <td valign=top><formwidget id="luogo_consegna">
    </tr>
</if>
<else>
  <tr><td valign=top align=left class=form_title nowrap width=10%>Data consegna:</td>
    <td valign=top align=left><formwidget id="data_consegna">
        <formerror  id="data_consegna"><br>
          <span class="errori">@formerror.data_consegna;noquote@</span>
        </formerror>
    </td>
  </tr>

  <tr><td valign=top align=left class=form_title>Luogo consegna:</td>
    <td valign=top><formwidget id="luogo_consegna">
  </tr>
</else>

<if @coimtgen.regione@ eq "MARCHE">
</table>
<table width="70%" border=0 cellspacing=0><tr><td>
    <tr>
      <td>&nbsp;</td>
    </tr>
	  <tr>
	    <td colspan=2>Relativamente all'impianto termico adibito a: <formgroup id="riscaldamento_ambienti">@formgroup.widget;noquote@</formgroup> riscaldamento ambienti &nbsp; <formgroup id="produzione_acs">@formgroup.widget;noquote@</formgroup> produzione acqua calda sanitaria 
	    </td>
	  </tr>
	  <tr>
	    <td>Catasto impianti/codice <formwidget id="cod_impianto_est">
	        <formerror  id="cod_impianto_est"><br>
	          <span class="errori">@formerror.cod_impianto_est;noquote@</span>
	        </formerror>
	    </td>
	    <td colspan=2>sito in via <formwidget id="indirizzo_impianto"></td>
	  </tr>
	  <tr>
	    <td colspan=3>di potenza termica nominale utile complessiva pari a <formwidget id="potenza_utile">
                kW n° gruppi termici presenti <formwidget id="n_generatori_marche">
            </td>
	  </tr>
	  <tr>
	    <td colspan=4>
	      Combustibile <formwidget id="combustibile">
	    </td>
	  </tr>
          <tr>
	    <td colspan=3>&nbsp;</td>
	  </tr>
</table>
<table width="70%" border=1 cellspacing=0><tr><td>
<table width="100%" cellspacing=0 cellpadding=1 border=0>
	  <tr>
            <td colspan=3 align=left class=form_title>Il sottoscritto
	      <formwidget id="cognome_dichiarante">
		<formwidget id="nome_dichiarante">
		  <formerror  id="nome_dichiarante">
		    <br>
		    <span class="errori">@formerror.nome_dichiarante;noquote@</span>
		  </formerror>@cerca_manu;noquote@ installatore/manutentore
		  <formerror  id="cognome_dichiarante">
		  <br>
		  <span class="errori">@formerror.cognome_dichiarante;noquote@</span>
	      </formerror>

	    </td>
	  </tr>
	  
    <tr>
      <td>In qualità di: 
	<formwidget id="flag_dichiarante">
	  <formerror  id="flag_dichiarante">
	    <br>
	    <span class="errori">@formerror.flag_dichiarante;noquote@</span>
	  </formerror>
      </td>
      
    </tr>
    <tr>
      <td colspan=2>della ditta <formwidget id="cognome_manu"><formwidget id="nome_manu">
           <formerror  id="cognome_manu"><br>
            <span class="errori">@formerror.cognome_manu;noquote@</span>
            </formerror>
        </td>
      <td>P.IVA <formwidget id="piva">
	  <formerror  id="piva">
            <br>
            <span class="errori">@formerror.piva;noquote@</span>
          </formerror>
      </td>
    </tr>
    <tr>
      <td colspan=2>con sede sita in via <formwidget id="indirizzo_manu">
          <formerror  id="indirizzo_manu">
            <br>
            <span class="errori">@formerror.indirizzo_manu;noquote@</span>
          </formerror>
      </td>
      <td>Comune <formwidget id="comune_manu">
          <formerror  id="comune_manu">
            <br>
            <span class="errori">@formerror.comune_manu;noquote@</span>
          </formerror>
      </td>
    </tr>
    <tr>
      <td>Provincia <formwidget id="provincia_manu">
          <formerror  id="provincia_manu">
            <br>
            <span class="errori">@formerror.provincia_manu;noquote@</span>
          </formerror>
      </td>
    </tr>
    <tr>
      <td>Telefono <formwidget id="telefono">
          <formerror  id="telefono">
            <br>
            <span class="errori">@formerror.telefono;noquote@</span>
          </formerror>
      </td>
      <td>Fax <formwidget id="fax">
          <formerror  id="fax">
            <br>
            <span class="errori">@formerror.fax;noquote@</span>
          </formerror>
      </td>
      <td width=25%>E-mail <formwidget id="email">
          <formerror  id="email">
            <br>
            <span class="errori">@formerror.email;noquote@</span>
          </formerror>
      </td>
    </tr>
    <tr>
      <td>Iscritta alla CCIAA di <formwidget id="localita_reg">
          <formerror   id="localita_reg"><br>
            <span class="errori">@formerror.localita_reg;noquote@</span>
	  </formerror>
      </td>
      <td>al numero <formwidget id="reg_imprese">
          <formerror   id="reg_imprese"><br>
            <span class="errori">@formerror.reg_imprese;noquote@</span>
	  </formerror>
      </td>
    </tr>
	  <tr>
	    <td colspan=3>abilitata ad operare agli impianti di cui alle lettere: a)<formgroup id="flag_a">@formgroup.widget;noquote@</formgroup> c)<formgroup id="flag_c">@formgroup.widget;noquote@</formgroup> e)<formgroup id="flag_e">@formgroup.widget;noquote@</formgroup> dell'articolo 1 del D.M. 37/08,</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	  </tr>
    <tr>
      <td colspan=3><formgroup id="flag_installatore">@formgroup.widget;noquote@</formgroup> (per gli impianti di nuova installazione) in qualità di <b>installatore</b> dell'impianto di cui sopra, dichiara che lo stesso è dotato dell'attestazione del costruttore prevista all'articolo 282, comma 2-bis del F.Lgs. 152/2006</td>
    </tr>
    <tr>
      <td colspan=3><formgroup id="flag_rispetta_val_min">@formgroup.widget;noquote@</formgroup> (solo per impianti alimentati a legna, carbone, biomasse combustibili, biogas) rispetta i valori limite di emissione prevista dall'articolo 286 del D. Lgs. 152/2006.</td>
    </tr>
    <tr>
      <td colspan=3><formgroup id="flag_manutentore">@formgroup.widget;noquote@</formgroup> (per gli impianti già in esercizio) in qualità di <b>manutentore/terzo responsabile</b> dell'impianto di cui sopra, dichiara che lo stesso è conforme alle caratteristiche tecmiche di cui all'art.285 ed è idoneo a rispettare i valori di cui all'art. 286 del D.Lgs. 152/06</td>
    </tr>
	<tr><td colspan=3><font color=red>@errore_3;noquote@</font></td></tr>
        <tr><td align=left colspan=3>&nbsp;</td></tr>
	    <tr><td align=left colspan=3>in possesso dei requisiti di cui</td></tr>
    <tr><td colspan=3>&nbsp;</td></tr>
    <tr><td align=left><formgroup id="flag_art_3">@formgroup.widget;noquote@</formgroup> al D.M. 22/01/2008 n. 37 art. 3</td>
    </tr>
    <tr><td align=left><formgroup id="flag_art_11">@formgroup.widget;noquote@</formgroup> al DPR 412/93 art. 11</td>
    </tr>
    <tr><td colspan=3><font color=red>@errore_1;noquote@</font></td></tr>

    <tr><td colspan=3>&nbsp;</td></tr>
    <tr><td align=left colspan=3>Ed in possesso degli eventuali ulteriori requisiti:</td></tr>
    <tr><td colspan=3>&nbsp;</td></tr>
    <tr><td align=left><formgroup id="flag_patente_abil">@formgroup.widget;noquote@</formgroup> patentino di abilitazione per la conduzione di impianti termici (obbligatorio per Portata Termica Nominale > 0,232 MW)</td>
    </tr>
    <tr><td align=left><formgroup id="flag_art_11_comma_3">@formgroup.widget;noquote@</formgroup> requisiti di cui al DPR 412/93 art. 11 comma 3</td>
    </tr>
    <tr><td colspan=3><font color=red>@errore_2;noquote@</font></td></tr>

</table></td></tr>
</if>


<else>
    <tr>
        <td align=left class=form_title>Io sottoscritto</td>
        <td nowrap><formwidget id="cognome_manu"><formwidget id="nome_manu">@cerca_manu;noquote@ manutentore &nbsp;\&nbsp; @cerca_citt;noquote@ cittadino
           <formerror  id="cognome_manu"><br>
            <span class="errori">@formerror.cognome_manu;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>in possesso dei requisiti di cui</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td align=left><formgroup id="flag_art_3">@formgroup.widget;noquote@</formgroup></td>
        <td align=left>al D.M. 22/01/2008 n. 37 art. 3</td>
    </tr>

<if @coimtgen.regione@ eq "MARCHE"><!-- ric01 aggiunta if ma non suo contenuto contenuto -->		
    	 <tr><td align=left><formgroup id="flag_art_11">@formgroup.widget;noquote@</formgroup></td>
             <td align=left> al DPR 412/93 art. 11</td>
         </tr>
</if>

    <tr><td colspan=2><font color=red>@errore_1;noquote@</font></td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Ed in possesso degli eventuali ulteriori requisiti:</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left><formgroup id="flag_patente_abil">@formgroup.widget;noquote@</formgroup></td>
        <td align=left>patentino di abilitazione per la conduzione di impianti termici (obbligatorio per Portata Termica Nominale > 0,232 MW)</td>
    </tr>

<if @coimtgen.regione@ eq "MARCHE"><!-- ric01 aggiunta if ma non suo contenuto -->
    <tr><td align=left><formgroup id="flag_art_11_comma_3">@formgroup.widget;noquote@</formgroup></td>
        <td align=left> requisiti di cui al DPR 412/93 art. 11 comma 3</td>
    </tr>
    <tr><td colspan=2><font color=red>@errore_2;noquote@</font></td></tr>
</if>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=3>Nella sua qualita' di</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left><formgroup id="flag_installatore">@formgroup.widget;noquote@</formgroup></td>
        <td align=left>installatore</td></tr>
    <tr><td align=left><formgroup id="flag_responsabile">@formgroup.widget;noquote@</formgroup></td>
        <td align=left>terzo responsabile</td></tr>
    <tr><td align=left><formgroup id="flag_manutentore">@formgroup.widget;noquote@</formgroup></td>
        <td align=left>manutentore</td></tr>

    <tr><td colspan=2><font color=red>@errore_3;noquote@</font></td></tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>dell' impianto sito in</td>
         <td valign=top colspan=2><formwidget id="indirizzo_impianto"></td>
    </tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td align=left colspan=2>Avente le seguenti caratteristiche:</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>. Combustibile utilizzato:</td>
        <td valign=top colspan=2><formwidget id="combustibili">
    </tr>
    <tr><td valign=top align=left class=form_title>. N° generatori:</td>
        <td valign=top colspan=2><formwidget id="n_generatori">
            <formerror  id="n_generatori"><br>
            <span class="errori">@formerror.n_generatori;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top align=left class=form_title>. Potenza Termica Nominale Complessiva (MW):</td>
        <td valign=top colspan=2><formwidget id="pot_term_tot_mw">
            <formerror  id="pot_term_tot_mw"><br>
            <span class="errori">@formerror.pot_term_tot_mw;noquote@</span>
            </formerror>
        </td>
    </tr>
</else>

<if @coimtgen.regione@ eq "MARCHE">
  </table>

  <table width="70%" cellspacing=0 cellpadding=1 border=0>
</if>
<tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Dichiara, ai sensi di quanto previsto dal D.Lgs. 152/06 art. 284 e ss.mm.ii.</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Che l’impianto è conforme alle caratteristiche tecniche di cui all’art. 285 del D.Lgs. 152/06, come specificate nella parte II dell’allegato IX alla parte V del Decreto citato</td></tr>
<tr><td align=left colspan=2>Che l’impianto è idoneo a rispettare i valori di cui all all’art. 286 del D.Lgs. 152/06, come specificate nella parte III  dell’allegato IX alla parte V del Decreto citato.</td></tr>
 
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Il presente documento viene allegato a:</td></tr>
    <tr><td align=left colspan=2> 
                       <formgroup id="flag_dich_conformita">@formgroup.widget;noquote@</formgroup>
		       Dichiarazione conformita' n°
                       <formwidget id="dich_conformita_nr">
                       <formerror  id="dich_conformita_nr"><br>
                             <span class="errori">@formerror.dich_conformita_nr;noquote@</span>
                       </formerror>
                       del
                       <formwidget id="data_dich_conform">
                       <formerror  id="data_dich_conform">
                             <span class="errori">@formerror.data_dich_conform;noquote@</span>
                       </formerror>   
           </td>  
    </tr>

    <tr><td align=left><formgroup id="flag_libretto_centr">@formgroup.widget;noquote@</formgroup> Libretto di centrale</td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=right colspan=2><b>modulo B</b></td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=center colspan=2>ISTRUZIONI PER LE MANUTENZIONI ORDINARIE E STRAORDINARIE DA EFFETTUARSI AL FINE DI ASSICURARE IL RISPETTO DEI VALORI LIMITE DI EMISSIONI DI CUI AL D.Lgs. 152/06 art. 286</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=center colspan=2>(D.Lgs. 152/06 art. 284 come modificato dal D.Lgs. 128/10 art. 3 comma 7) - Da inserire nel Libretto di Centrale(art.284)</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Visti:</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>. Il Libretto di Uso e Manutenzione relativo all'impianto rilasciato dall'installatore</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>. I Libretti di Uso e Manutenzione degli apparecchi e componenti dell'impianto</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>. Il D.Lgs. 192/05 e s.m.i.</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>. I regolamenti locali</td>
        <td valign=top ><formwidget id="regolamenti_locali">
	</td>
    </tr>




    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>. La norma UNI 8364-1-2-3:2007 - Impianti di Riscldamento</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>. La norma UNI 10435:1995 - Impianti di combustione alimentati a gas con bruciatori ad aria soffiata di portata termica nominale > 35 kW. Controllo e manutenzione</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>  
    <tr><td align=left colspan=2>. La norma UNI 10389:2009 - Generatori di calore - Analisi dei prodotti della combustione e misurazione in opera del rendimento di combustione</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td align=left colspan=2>Elenco di seguito le opere di manutenzione ordinaria e straordinaria per assicurare il rispetto dei valori limite di emissioni di polveri di cui al D.Lgs. 152/06 art. 286 e ss.mm.ii. :</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td align=left colspan=2>MANUTENZIONE ORDINARIA</td></tr>




<tr> <td colspan=2>
<table cellspacing=0 cellpadding=1 border=0>

    <tr><td width=50%><b>Operazione</b></td><td width=50%><b>Periodicita'</b></td></tr>

    <tr><td valign=top><formwidget id="manu_ord_1">
            <formerror  id="manu_ord_1"><br>
            <span class="errori">@formerror.manu_ord_1;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_1">
            <formerror  id="manu_flag_1"><br>
            <span class="errori">@formerror.manu_flag_1;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_2">
            <formerror  id="manu_ord_2"><br>
            <span class="errori">@formerror.manu_ord_2;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_2">
            <formerror  id="manu_flag_2"><br>
            <span class="errori">@formerror.manu_flag_2;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_3">
            <formerror  id="manu_ord_3"><br>
            <span class="errori">@formerror.manu_ord_3;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_3">
            <formerror  id="manu_flag_3"><br>
            <span class="errori">@formerror.manu_flag_3;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_4">
            <formerror  id="manu_ord_4"><br>
            <span class="errori">@formerror.manu_ord_4;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_4">
            <formerror  id="manu_flag_4"><br>
            <span class="errori">@formerror.manu_flag_4;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_5">
            <formerror  id="manu_ord_5"><br>
            <span class="errori">@formerror.manu_ord_5;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_5">
            <formerror  id="manu_flag_5"><br>
            <span class="errori">@formerror.manu_flag_5;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_6">
            <formerror  id="manu_ord_6"><br>
            <span class="errori">@formerror.manu_ord_6;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_6">
            <formerror  id="manu_flag_6"><br>
            <span class="errori">@formerror.manu_flag_6;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr><td valign=top><formwidget id="manu_ord_7">
            <formerror  id="manu_ord_7"><br>
            <span class="errori">@formerror.manu_ord_7;noquote@</span>
            </formerror>
        </td>
        <td valign=top><formwidget id="manu_flag_7">
            <formerror  id="manu_flag_7"><br>
            <span class="errori">@formerror.manu_flag_7;noquote@</span>
            </formerror>
        </td>
    </tr>


    <tr><td align=left colspan=2>MANUTENZIONE STRAORDINARIA</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan = 2 valign=top><formwidget id="manu_stra_1">
            <formerror  id="manu_stra_1"><br>
            <span class="errori">@formerror.manu_stra_1;noquote@</span>
            </formerror>
        </td>
    </tr>



    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>VERIFICA STRUMENTALE EMISSIONI</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>La verifica del rispetto dei valori limite di emissione previsti dal D.Lgs 152/06 art.286 ss.mm.ii.:</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td align=left colspan=2>
        <formgroup id="verif_emis_286_no">@formgroup.widget;noquote@</formgroup>
        non e' stata effettuata trattandosi di impianto che rientra nei casi previsti dalla parte III sez. 1 dell'allegato IX alla parte V del D.lgs. 152/2006 e ss.mm.ii)</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    
    <tr><td align=left colspan=2>
        <formgroup id="verif_emis_286_si">@formgroup.widget;noquote@</formgroup>
        e' stata effettuata in data 
        <formwidget id="data_verif_emiss">
          <formerror  id="data_verif_emiss">
            <span class="errori">@formerror.data_verif_emiss;noquote@</span>
          </formerror>
          con il seguente risultato:
          <formwidget id="risultato_mg_nmc_h">
	    Mg/Nmc all'ora  
      </td>
    </tr>
  
    <tr>  
        <td align=left colspan=2>Tale risultato e'
                       <formgroup id="risultato_conforme_si">@formgroup.widget;noquote@</formgroup>
                       conforme 
                       <formgroup id="risultato_conforme_no">@formgroup.widget;noquote@</formgroup>
                       non conforme
        </td>
    </tr>
   
    <tr>
        <td align=left colspan=2><b>(N.B. Il limite massimo di polveri totali è pari a 50  mg/Nmc)</b></td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td align=left colspan=2>Il presente documento viene allegato al Libretto di Centrale in data
                       <formwidget id="data_alleg_libretto">
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>Il Dichiarante (Timbro e firma)</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr>
        <td valign=top><formwidget id="firma_dichiarante">
        <td valign=top align=left colspan=2>Data,
            <formwidget id="data_dichiarazione">
            <formerror  id="data_dichiarazione"><br>
            <span class="errori">@formerror.data_dichiarazione;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>Per ricevuta e presa visione</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td valign=top align=left class=form_title>Il responsabile dell'impianto (Firma)</td></tr>
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr>
        <td valign=top><formwidget id="firma_responsabile">
        <td valign=top align=left colspan=2>Data,
            <formwidget id="data_ricevuta">
            <formerror  id="data_ricevuta"><br>
            <span class="errori">@formerror.data_ricevuta;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td valign=top align=left class=form_title width=10%>Consegnato:</td>
        <td valign=top align=left><formwidget id="flag_consegnato">
            <formerror  id="flag_consegnato"><br>
            <span class="errori">@formerror.flag_consegnato;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
</if>
</table>
</table>
</formtemplate>
<p>
</center>

