<!DOCTYPE html>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 21/11/2018 Gestito la cancellazione con un flag diverso da quello della modifica.
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<script type="text/javascript">
  function onSearchClose() {
      document.@form_name@.__refreshing_p.value = '1';
      document.@form_name@.submit();
  }
</script>

@link_tab;noquote@
@dett_tab;noquote@

<table width="100%" cellspacing=0 class=func-menu>
  <tr>	
    <if @funzione@ ne I and @menu@ eq 1>
      <td width="20%" nowrap class=@func_v;noquote@>
        <a href="@questa_pagina@?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>

      <if @flag_modifica@ eq t>
        <td width="20%" nowrap class=@func_m;noquote@>
          <a href="@questa_pagina@?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
        </td>
      </if>
      <else><!--rom01 aggiuntaelse e contenuto-->
        <td width="20%" nowrap class=func-menu>Modifica</td>
     </else>
      <if @flag_cancella@ eq t><!--rom01 aggiunta if, else e contenuto-->
        <td width="20%" nowrap class=@func_d;noquote@>
          <a href="@questa_pagina@?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
        </td>
      </if>
      <else>
        <td width="20%" nowrap class=func-menu>Cancella</td>
      </else>

      <td width="20%" nowrap class=func-menu>
        <a href="coimdimp-dam-layout?@link_gest;noquote@&flag_ins=N" class=func-menu target="Stampa">Stampa</a>
      </td>
      <td width="20%" nowrap class=func-menu>
        <a href="coimdimp-dam-layout?@link_gest;noquote@&flag_ins=S" class=func-menu target="Stampa">Ins. Doc.</a>
      </td>
    </if>
    <else>
      <td width="20%" nowrap class=func-menu>Visualizza</td>
      <td width="20%" nowrap class=func-menu>Modifica</td>
      <td width="20%" nowrap class=func-menu>Cancella</td>
      <td width="20%" nowrap class=func-menu>Stampa</td>
      <td width="20%" nowrap class=func-menu>Ins. Doc.</td>
    </else>
  </tr>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="cod_impianto">
<formwidget   id="cod_dimp">
<formwidget   id="cod_opmanu_new">

<formwidget   id="last_cod_dimp">

<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">

<formwidget   id="url_aimp">
<formwidget   id="url_list_aimp">

<formwidget   id="f_cod_via">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_responsabile">
<formwidget   id="cod_legale_rapp">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
      <tr>
	<td colspan=10 align="center" class="errori">@errori;noquote@</td>
      </tr>
      <tr>
	<td align=right class=form_title width=20%>Cognome dichiarante</td>
	<td align=left colspan=9>
	  <formwidget id="dam_cognome_dichiarante">
	  <formerror  id="dam_cognome_dichiarante">
	    <br>
	    <span class="errori">@formerror.dam_cognome_dichiarante;noquote@</span>
	  </formerror>
	</td>
      </tr>
      <tr>
	<td align=right class=form_title>Nome dichiarante</td>
	<td align=left colspan=9>
	  <formwidget id="dam_nome_dichiarante">
	  <formerror  id="dam_nome_dichiarante">
	    <br>
	    <span class="errori">@formerror.dam_nome_dichiarante;noquote@</span>
	  </formerror>
	</td>
      </tr>
      
      <tr>
	<td align=right nowrap class=form_title>Tecnico della Ditta</td>
	<td align=left colspan=9>
	  <formwidget id="cognome_manu"><formwidget id="nome_manu">@cerca_manu;noquote@
	  <formerror  id="cognome_manu"><br>
	    <span class="errori">@formerror.cognome_manu;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <tr>
	<td align=right class=form_title width=21% nowrap>iscritta alla CCIAA di</td>
	<td><formwidget id="localita_reg">
	    <formerror   id="localita_reg"><br>
	      <span class="errori">@formerror.localita_reg;noquote@</span>
	    </formerror>
	</td>
	<td align=right nowrap>al numero</td>
	<td colspan=7><formwidget id="reg_imprese">
	    <formerror   id="reg_imprese"><br>
	      <span class="errori">@formerror.reg_imprese;noquote@</span>
	    </formerror>
	</td>
      </tr>

      <tr>
	<td align=right>abilitata ad operare per gli impianti di cui alle lettere:</td>
	<td colspan=9>
	  <table width=100%>
	    <tr>
	      <td>a)<formgroup id="flag_a">@formgroup.widget;noquote@</formgroup></td>
<!--	      <td>b)<formgroup id="flag_b">@formgroup.widget;noquote@</formgroup></td>-->
	      <td>c)<formgroup id="flag_c">@formgroup.widget;noquote@</formgroup></td>
<!--	      <td>d)<formgroup id="flag_d">@formgroup.widget;noquote@</formgroup></td>-->
	      <td>e)<formgroup id="flag_e">@formgroup.widget;noquote@</formgroup></td>
<!--	      <td>f)<formgroup id="flag_f">@formgroup.widget;noquote@</formgroup></td>
	      <td>g)<formgroup id="flag_g">@formgroup.widget;noquote@</formgroup></td>-->
              <td>dell'articolo 1 del D.M. 37/08</td>
	    </tr>
	  </table>
	</td>
      </tr>
      <tr>
	<td align=right nowrap class=form_title>in qualità di</td>
	<td align=left colspan=9>
	  <formwidget id="dam_tipo_tecnico">
	  <formerror  id="dam_tipo_tecnico">
	    <br>
	    <span class="errori">@formerror.dam_tipo_tecnico;noquote@</span>
	  </formerror>
	</td>
      </tr>
      
      <tr>
	<td align=right nowrap class=form_title>Tecnico che ha effettuato il controllo</td>
	<td align=left colspan=9>
	  <formwidget id="cognome_opma"><formwidget id="nome_opma">@cerca_opma;noquote@
	  <formerror  id="cognome_opma"><br>
	    <span class="errori">@formerror.cognome_opma;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <tr><td colspan=10 align=center><b>DICHIARA</b></td></tr>

      <tr>
	<td align=right class=form_title valign=top>Di aver effettuato in data</td>
	<td align=left colspan=9><formwidget id="data_dich">
	  <formerror  id="data_dich"><br>
	    <span class="errori">@formerror.data_dich;noquote@</span>
	  </formerror>
	</td>
      </tr>
      
<!--      <tr>
	<td align=right class=form_title valign=top>Le operazioni di controllo e manutenzione dell'impianto termico:</td>
	<td align=left colspan=9><formwidget id="flag_impianto">
	  <formerror id="flag_impianto"><br>
	    <span class="errori">@formerror.impianto;noquote@</span>
	  </formerror>
	</td>
      </tr>-->
      
      <tr>
	<td align=right class=form_title valign=top>Le operazioni di controllo e manutenzione dell'impianto termico con codice catasto impianti</td>
	<td align=left colspan=9><formwidget id="cod_impianto_est">
	  <formerror  id="cod_impianto_est"><br>
	    <span class="errori">@formerror.cod_impianto_est;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <tr>
	<td valign=top align=right class=form_title width=21%>Indirizzo</td>
	<td valign=top width=28%><formwidget id="toponimo">
	  <formwidget id="indirizzo">
	  <formerror  id="indirizzo"><br>
	    <span class="errori">@formerror.indirizzo;noquote@</span>
	  </formerror>
	  <formerror  id="toponimo"><br>
	    <span class="errori">@formerror.toponimo;noquote@</span>
	  </formerror>
	</td>
	<td valign=top align=right class=form_title width=7%>N&deg; Civ.</td>
	<td valign=top width=6% nowrap>
	  <formwidget id="numero">/<formwidget id="esponente">
	  <formerror  id="numero"><br>
	    <span class="errori">@formerror.numero;noquote@</span>
	  </formerror>
	</td>
	<td valign=top align=right class=form_title width=4%>Scala</td>
	<td valign=top width=3%><formwidget id="scala">
	  <formerror  id="scala"><br>
	    <span class="errori">@formerror.scala;noquote@</span>
	  </formerror>
	</td>
	<td valign=top align=right class=form_title width=4%>Piano</td>
	<td valign=top width=3%><formwidget id="piano">
	  <formerror  id="piano"><br>
	    <span class="errori">@formerror.piano;noquote@</span>
	  </formerror>
	</td>
	<td valign=top align=right class=form_title width=3%>Int.</td>
	<td valign=top><formwidget id="interno">
	  <formerror  id="interno"><br>
	    <span class="errori">@formerror.interno;noquote@</span>
	  </formerror>
	</td>
      </tr>
      
      <tr>
	<td align=right class=form_title valign=top>Comune </td>
	<td align=left colspan=9><formwidget id="descr_comu">
	  <formerror  id="descr_comu"><br>
	    <span class="errori">@formerror.descr_comu;noquote@</span>
	  </formerror>
	</td>
      </tr>
      
      <tr>
	<td align=right class=form_title>Responsabile dell'impianto </td>
	<td align=left colspan=9>
	  <formwidget id="cognome_resp">
	  <formwidget id="nome_resp">@cerca_prop;noquote@|@link_ins_prop;noquote@
	  <formerror  id="cognome_resp"><br>
	    <span class="errori">@formerror.cognome_resp;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <!--
      <tr>
	<td align=right class=form_title>Il controllo &egrave; stato effettuato in seguito a </td>
	<td align=left colspan=9>
	  <formwidget id="dam_tipo_manutenzione">
	  <formerror  id="dam_tipo_manutenzione"><br>
	    <span class="errori">@formerror.dam_tipo_manutenzione;noquote@</span>
	  </formerror>
	</td>
      </tr>
      -->

</table>      
<table width="100%" align="center">
      <tr><td colspan=8 align=center><b>In particolare il controllo ha riguardato i seguenti generatori:</b></td></tr>

      <multiple name="campi_manutenzioni">
        <tr><td align=center>&nbsp;</td></tr>

        <tr>
          <td align="right" class="form_title" width="25%" nowrap>Ha riguardato il generatore num. @campi_manutenzioni.gen_prog@?</td>
          <td align="left" width="10%">
	      <formwidget id="@campi_manutenzioni.campo_riguarda_p@">
              <span class="errori"><br>
                  <formerror id="@campi_manutenzioni.campo_riguarda_p@"></formerror>
              </span>
          </td>

          <td align="right" class="form_title">Costruttore:</td>
          <td align="left"                    ><b>@campi_manutenzioni.fabbricante@</b></td>

          <td align="right" class="form_title">Modello:</td>
          <td align="left"                    ><b>@campi_manutenzioni.modello@</b></td>

          <td align="right" class="form_title">Matricola:</td>
          <td align="left"                    ><b>@campi_manutenzioni.matricola@</b></td>
	</tr>

	<tr>
	  <!--
	  <td align=right class=form_title>Data ultima manutenzione o disattivazione</td>
	  <td align=left>
              <formwidget id="@campi_manutenzioni.campo_data_ult_manu@">
	      <span class="errori"><br>
                  <formerror id="@campi_manutenzioni.campo_data_ult_manu@"></formerror>
	      </span>
	  </td>
          -->
	  
	  <td align=right class=form_title>Data ultima manutenzione</td>
	  <td align=left>
	      <formwidget id="@campi_manutenzioni.campo_data_ult_manu@">
		<span class="errori"><br>
		  <formerror id="@campi_manutenzioni.campo_data_ult_manu@"></formerror>
		</span>
	  </td>
	  
	  
          <td align="right" class="form_title">Data Installazione:</td>
          <td align="left"                    ><b>@campi_manutenzioni.data_installaz@</b></td>
        </tr>

        <tr>
          <td align="right" class="form_title">Installatore (ragione sociale):</td>
          <td align="left"  colspan="7"><b>@campi_manutenzioni.installatore@</b></td>
        </tr>        
      </multiple>

      <tr>
	<td align=right class=form_title>Sono presenti osservazioni</td>
	<td align=left>
	  <formwidget id="dam_flag_osservazioni">
	  <formerror  id="dam_flag_osservazioni"><br>
	    <span class="errori">@formerror.dam_flag_osservazioni;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <tr>
	<td align=right class=form_title>Sono presenti raccomandazioni</td>
	<td align=left >
	  <formwidget id="dam_flag_raccomandazioni">
	  <formerror  id="dam_flag_raccomandazioni"><br>
	    <span class="errori">@formerror.dam_flag_raccomandazioni;noquote@</span>
	  </formerror>
	</td>
      </tr>

      <tr>
	<td align=right class=form_title>Sono presenti prescrizioni</td>
	<td align=left>
	  <formwidget id="dam_flag_prescrizioni">
	  <formerror  id="dam_flag_prescrizioni"><br>
	    <span class="errori">@formerror.dam_flag_prescrizioni;noquote@</span>
	  </formerror>
	</td>
      </tr>
</table>
<!-- gac01 aggiunta table e suo contenuto-->
<table width="100%" align="center">
<tr>
    <td width=21% valign=top align=center class=form_title>Stagione di riscaldamento attuale</td>
    <td width=15% valign=top align=center class=form_title>Acquisti</td>
    <td width=15% valign=top align=center class=form_title>Scorta o lett. iniziale</td>
    <td width=15% valign=top align=center class=form_title>Scorta o lett. finale</td>
    <td width=34% valign=top align=center class=form_title>Consumi stagione <if @um;noquote@ ne "">(@um;noquote@)</if> </td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="stagione_risc">
        <formerror  id="stagione_risc"><br>
        <span class="errori">@formerror.stagione_risc;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="acquisti">
        <formerror  id="acquisti"><br>
        <span class="errori">@formerror.acquisti;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_iniz">
        <formerror id="scorta_o_lett_iniz"><br>
        <span class="errori">@formerror.scorta_o_lett_iniz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_fin">
        <formerror id="scorta_o_lett_fin"><br>
        <span class="errori">@formerror.scorta_o_lett_fin;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="consumo_annuo">
        <formerror  id="consumo_annuo"><br>
        <span class="errori">@formerror.consumo_annuo;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>@cons_annuo;noquote@</td>
</tr>
<tr>
    <td valign=top align=center class=form_title>Stagione di riscaldamento precedente</td>
    <td valign=top align=center class=form_title>Acquisti</td>
    <td valign=top align=center class=form_title>Scorta o lett. iniziale</td>
    <td valign=top align=center class=form_title>Scorta o lett. finale</td>
    <td valign=top align=center class=form_title>Consumi stagione <if @um;noquote@ ne "">(@um;noquote@)</if></td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="stagione_risc2">
        <formerror  id="stagione_risc2"><br>
        <span class="errori">@formerror.stagione_risc2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="acquisti2">
        <formerror  id="acquisti2"><br>
        <span class="errori">@formerror.acquisti2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_iniz2">
        <formerror id="scorta_o_lett_iniz2"><br>
        <span class="errori">@formerror.scorta_o_lett_iniz2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_fin2">
        <formerror id="scorta_o_lett_fin2"><br>
        <span class="errori">@formerror.scorta_o_lett_fin2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="consumo_annuo2">
        <formerror  id="consumo_annuo2"><br>
        <span class="errori">@formerror.consumo_annuo2;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>@cons_annuo;noquote@</td>
</tr>
</table>

<tr><td colspan=2>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=8 align=center><formwidget id="submit_btn"></td></tr>
</if>


<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

<!-- Fine della form colorata -->
</formtemplate>
<p>
</center>

</table>
<table>
</table>
