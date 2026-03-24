<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom03 30/03/2022 In base alla variabile visualizza_scheda5_1 faccio vedere o meno i campi 
    rom03            della scheda stessa (solo per le Marche puo' valere "f").

    rom01 07/11/2018 Aggiunti titoli 5.1,5.2,5.3,5.4 e cambiate label.
    rom02            Solo per le marche aggiunte liste ....
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
<formwidget   id="last_cod_impianto">
<formwidget   id="cod_impianto">
<formwidget   id="data_fin_valid">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">
<formwidget   id="dummy">

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0  class=func-menu>
<tr>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimaimp-regol-contab-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimaimp-regol-contab-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
   </else>
</tr>
</table>

<%=[iter_form_iniz]%>
<!-- Inizio della form colorata -->
<table width="80%"><!--rom01-->
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td class="func-menu-yellow2" align="center"><b>5.1 - Regolazione primaria (situazione alla prima installazione e alla ristrutturazione dell'impianto termico)</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<if @visualizza_scheda5_1@ eq "t"><!--rom03 Aggiunta if ma non il suo contenuto -->
<table width="100%">
  <tr>
    <td valign=top align=right class=form_title>Sistema di regolazione ON-OFF</td>
    <td valign=top>
      <formwidget id="regol_on_off">
	<formerror  id="regol_on_off"><br>
	  <span class="errori">@formerror.regol_on_off;noquote@</span>
	</formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Sistema di regolazione con impostazione della curva climatica integrata nel generatore</td>
    <td valign=top>
      <formwidget id="regol_curva_integrata">
	<formerror  id="regol_curva_integrata"><br>
	  <span class="errori">@formerror.regol_curva_integrata;noquote@</span>
	</formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Sistema di regolazione con impostazione della curva climatica indipendente</td>
    <td valign=top>
      <formwidget id="regol_curva_indipendente">
	<formerror  id="regol_curva_indipendente"><br>
	  <span class="errori">@formerror.regol_curva_indipendente;noquote@</span>
	</formerror>
    </td>
  </tr>
  <if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if-->
    <tr>
      <td valign=top align=right class=form_title>Data di installazione</td>
      <td valign=top>
	<formwidget id="regol_curva_ind_iniz_data_inst">
	  <formerror  id="regol_curva_ind_iniz_data_inst"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_data_inst;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>Data di dismissione</td>
      <td valign=top>
	<formwidget id="regol_curva_ind_iniz_data_dism">
	  <formerror  id="regol_curva_ind_iniz_data_dism"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_data_dism;noquote@</span>
	  </formerror>
      </td>
    </tr>
    <tr>  
      <td valign=top align=right class=form_title>Fabbricante</td>
      <td valign=top >
	<formwidget id="regol_curva_ind_iniz_fabbricante">
	  <formerror  id="regol_curva_ind_iniz_fabbricante"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_fabbricante;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>Modello</td>
      <td valign=top >
	<formwidget id="regol_curva_ind_iniz_modello">
	  <formerror  id="regol_curva_ind_iniz_modello"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_modello;noquote@</span>
	  </formerror>
      </td>
    </tr>
    <tr>
      <td valign=top align=right class=form_title>N° punti di regolaz.</td>
      <td valign=top >
	<formwidget id="regol_curva_ind_iniz_n_punti_reg">
	  <formerror  id="regol_curva_ind_iniz_n_punti_reg"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_n_punti_reg;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>N° livelli di temperatura</td>
      <td valign=top >
	<formwidget id="regol_curva_ind_iniz_n_liv_temp">
	  <formerror  id="regol_curva_ind_iniz_n_liv_temp"><br>
	    <span class="errori">@formerror.regol_curva_ind_iniz_n_liv_temp;noquote@</span>
	  </formerror>
      </td>
    </tr>
  </if><else><!--rom01 else e contenuto-->
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td colspan="2" align="center">
	<table width="50%">
	  <tr>
	    <td>
	      <b>Sistema di Regolazione</b>
	      <br>@link_aggiungi_1;noquote@
	    </td>
	  </tr>
	  <tr>
	    <td>@table_result_1;noquote@</td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
  </else>
  <tr>
    <td valign=top align=right class=form_title>Valvole di regolazione (se non incorporate nel generatore)</td>
    <td valign=top colspan=3>
    <formwidget id="regol_valv_regolazione">
      <formerror  id="regol_valv_regolazione"><br>
      <span class="errori">@formerror.regol_valv_regolazione;noquote@</span>
      </formerror>
  </td>
</tr>
  <if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if -->
    <tr>
      <td valign=top align=right class=form_title>Data di installazione</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_data_inst">
	  <formerror  id="regol_valv_ind_iniz_data_inst"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_data_inst;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>Data di dismissione</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_data_dism">
	  <formerror  id="regol_valv_ind_iniz_data_dism"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_data_dism;noquote@</span>
	  </formerror>
      </td>
    </tr>
    <tr>
      <td valign=top align=right class=form_title>Fabbricante</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_fabbricante">
	  <formerror  id="regol_valv_ind_iniz_fabbricante"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_fabbricante;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>Modello</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_modello">
	  <formerror  id="regol_valv_ind_iniz_modello"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_modello;noquote@</span>
	  </formerror>
      </td>
    </tr>
    <tr>
      <td valign=top align=right class=form_title>N° di vie</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_n_vie">
	  <formerror  id="regol_valv_ind_iniz_n_vie"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_n_vie;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title>Servomotore</td>
      <td valign=top >
	<formwidget id="regol_valv_ind_iniz_servo_motore">
	  <formerror  id="regol_valv_ind_iniz_servo_motore"><br>
	    <span class="errori">@formerror.regol_valv_ind_iniz_servo_motore;noquote@</span>
	  </formerror>
      </td>
    </tr>
  </if><else><!--rom01 aggiunta else e contenuto-->
    <tr>
      <td colspan="2" align="center">
	<table width="50%">
	  <tr>
	    <td>
              <b>Valvole di Regolazione</b>
	      <br>@link_aggiungi_2;noquote@
	    </td>
	  </tr>
	  <tr>
	    <td>@table_result_2;noquote@</td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
  </else><!--rom01-->
  <tr>
    <td valign=top align=right class=form_title>Sistema di regolazione multigradino</td>
    <td valign=top>
      <formwidget id="regol_sist_multigradino">
      <formerror  id="regol_sist_multigradino"><br>
      <span class="errori">@formerror.regol_sist_multigradino;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Sistema di regolazione a Inverter del generatore</td>
  <td valign=top>
      <formwidget id="regol_sist_inverter">
      <formerror  id="regol_sist_inverter"><br>
      <span class="errori">@formerror.regol_sist_inverter;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Altri sistemi di regolazione primaria</td>
  <td valign=top>
      <formwidget id="regol_altri_flag">
      <formerror  id="regol_altri_flag"><br>
      <span class="errori">@formerror.regol_altri_flag;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Descrizione del sistema</td>
  <td valign=top colspan=3>
      <formwidget id="regol_altri_desc_sistema">
      <formerror  id="regol_altri_desc_sistema"><br>
      <span class="errori">@formerror.regol_altri_desc_sistema;noquote@</span>
      </formerror>
  </td>
</tr>
</table>
</if>
<else><!--rom03 Aggiunta else e il suo contenuto -->
  <table width="50%">
    <tr>
      <td valign="top" align="justify" class="form_title">Il sistema di regolazione primaria nella scheda 1 &egrave; stato indicato come unico all'impianto ibrido principale con codice @cod_impianto_est_ibrido_princ@.<br>
	Per visualizzare/modificare i dati della scheda 5.1 dell'impianto ibrido principale <a href="#" onclick="javascript:window.open('coimaimp-regol-contab-gest?@export_vars_ibrido;noquote@', 'scrollbars=yes, resizable=yes')">clicca qui</a>.<br>
	
      </td>
    </tr>
</else>
<table width="80%"><!--rom01-->
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td class="func-menu-yellow2" align="center"><b>5.2 - Regolazione singolo ambiente di zona</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table>
<tr>
  <td valign=top align=right class=form_title>Tipo regolaz. singolo ambiente di zona</td>
  <td valign=top colspan=3>
      <formwidget id="regol_cod_tprg">
      <formerror  id="regol_cod_tprg"><br>
      <span class="errori">@formerror.regol_cod_tprg;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Valvole Termostatiche</td>
  <td valign=top>
      <formwidget id="regol_valv_termostatiche">
      <formerror  id="regol_valv_termostatiche"><br>
      <span class="errori">@formerror.regol_valv_termostatiche;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Valvole a 2 vie</td>
  <td valign=top>
      <formwidget id="regol_valv_due_vie">
      <formerror  id="regol_valv_due_vie"><br>
      <span class="errori">@formerror.regol_valv_due_vie;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Valvole a 3 vie</td>
  <td valign=top>
      <formwidget id="regol_valv_tre_vie">
      <formerror  id="regol_valv_tre_vie"><br>
      <span class="errori">@formerror.regol_valv_tre_vie;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Note</td>
  <td valign=top colspan=3>
    <formwidget id="regol_valv_note">
      <formerror  id="regol_valv_note"><br>
	<span class="errori">@formerror.regol_valv_note;noquote@</span>
      </formerror>
  </td>   
</tr>
</table>
<table width="80%"><!--rom01-->
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td class="func-menu-yellow2" align="center"><b>5.3 - Sistemi telematici di telelettura e telegestione</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table>
<tr>
  <td valign=top align=right class=form_title>Telelettura</td>
  <td valign=top >
      <formwidget id="regol_telettura">
      <formerror  id="regol_telettura"><br>
      <span class="errori">@formerror.regol_telettura;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right class=form_title>Telegestione</td>
  <td valign=top >
      <formwidget id="regol_telegestione">
      <formerror  id="regol_telegestione"><br>
      <span class="errori">@formerror.regol_telegestione;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Descrizione del sistema</td>
    <td valign=top colspan=3>
      <formwidget id="regol_desc_sistema_iniz">
      <formerror  id="regol_desc_sistema_iniz"><br>
      <span class="errori">@formerror.regol_desc_sistema_iniz;noquote@</span>
      </formerror>
    </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Data di sostituzione</td>
  <td valign=top colspan=3>
      <formwidget id="regol_data_sost_sistema">
      <formerror  id="regol_data_sost_sistema"><br>
      <span class="errori">@formerror.regol_data_sost_sistema;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
   <td valign=top align=right class=form_title>Descrizione del sistema (sostituzione)</td>
   <td valign=top colspan=3>
      <formwidget id="regol_desc_sistema_sost">
      <formerror  id="regol_desc_sistema_sost"><br>
      <span class="errori">@formerror.regol_desc_sistema_sost;noquote@</span>
      </formerror>
   </td>
</tr>
</table>
<table width="80%"><!--rom01-->
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td class="func-menu-yellow2" align="center"><b>5.4- Contabilizzazione</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table>
<tr>
  <td valign=top align=right class=form_title>Unità immobiliari contabilizzate</td>
  <td valign=top>
      <formwidget id="contab_si_no">
      <formerror  id="contab_si_no"><br>
      <span class="errori">@formerror.contab_si_no;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Se contabilizzate</td>
  <td valign=top>
      <formwidget id="contab_tipo_contabiliz">
      <formerror  id="contab_tipo_contabiliz"><br>
      <span class="errori">@formerror.contab_tipo_contabiliz;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Tipologia sistema</td>
  <td valign=top>
      <formwidget id="contab_tipo_sistema">
      <formerror  id="contab_tipo_sistema"><br>
      <span class="errori">@formerror.contab_tipo_sistema;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Descrizione del sistema</td>
  <td valign=top colspan=3>
      <formwidget id="contab_desc_sistema_iniz">
      <formerror  id="contab_desc_sistema_iniz"><br>
      <span class="errori">@formerror.contab_desc_sistema_iniz;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Data di sostituzione</td>
  <td valign=top colspan=3>
      <formwidget id="contab_data_sost_sistema">
      <formerror  id="contab_data_sost_sistema"><br>
      <span class="errori">@formerror.contab_data_sost_sistema;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Descrizione del sistema (sostituzione)</td>
    <td colspan=3 valign=top>
      <formwidget id="contab_desc_sistema_sost">
      <formerror  id="contab_desc_sistema_sost"><br>
      <span class="errori">@formerror.;noquote@</span>
      </formerror>
    </td>
<tr>
</table></td>
<tr><td colspan=4>&nbsp;</td></tr>
<if @funzione@ ne "V">
<tr>
    <td colspan=4 align=center><formwidget id="submit"></td>
</tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

