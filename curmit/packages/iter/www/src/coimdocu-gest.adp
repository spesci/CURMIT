<!DOCTYPE html>
<!--
    USER  DATA        MODIFICHE
    ===== ==========  =============================================================================
    ric01 18/11/2025  Aggiunta gestione terzo numero di protocollo (Punto 17 MEV Regione Marche).
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>


@link_tab;noquote@
@dett_tab;noquote@

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <if @funzione@ eq "I">
      <if @nome_funz_caller@ eq "docu">
          <td width="25%" nowrap colspan=4 class=func-menu>
             <a href="coimdocu-list?@link_list;noquote@">Ritorna</a>
          </td>
          <td width="75%" nowrap colspan=4 class=func-menu>&nbsp;</td>
      </if>
      <else>
          <td width="100%" nowrap colspan=4 class=func-menu>&nbsp;</td>
      </else>
   </if>
   <else>
      <if @flag_pote@ eq "S">
         <td width="25%" nowrap class=func-menu>
            <a href="coimacts-gest?funzione=V&@link_acts;noquote@">Ritorna</a>
         </td>
      </if>
      <else>
         <if @nome_funz_caller@ eq "docu" or @nome_funz_caller@ eq manutentori >
	     <td width="25%" nowrap class=func-menu>
                 <a href="coimdocu-list?@link_list;noquote@">Ritorna</a>
             </td>
         </if>
      </else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimdocu-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimdocu-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimdocu-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
      </td>
   </else>
</tr>

<if @funzione@ ne "I">
    <tr>
      <td width="25%" nowrap class=func-menu>
         @link_alle;noquote@
      </td>
      <td width="25%" nowrap class=@func_c;noquote@>
         @link_del_alle;noquote@
      </td>
    </tr>
</if>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_documento">
<formwidget   id="cod_impianto">
<formwidget   id="url_aimp">
<formwidget   id="url_list_aimp">
<formwidget   id="cod_documento">
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<tr>
    <if @caller@ eq "coimdocu-filter" or @nome_funz_caller@ eq "docu-ins">
        <td valign=top align=right class=form_title>Cod. impianto</td>
        <td valign=top><formwidget id="cod_impianto_est">
            <formerror  id="cod_impianto_est"><br>
            <span class="errori">@formerror.cod_impianto_est;noquote@</span>
            </formerror>
        </td>
    </if>
    <else>
        <td colspan=2>&nbsp;</td>
    </else>
    <td valign=top align=right class=form_title>Tipo documento</td>
    <td valign=top><formwidget id="tipo_documento">
        <formerror  id="tipo_documento"><br>
        <span class="errori">@formerror.tipo_documento;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data stampa</td>
    <td valign=top><formwidget id="data_stampa">
        <formerror  id="data_stampa"><br>
        <span class="errori">@formerror.data_stampa;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data documento</td>
    <td valign=top><formwidget id="data_documento">
        <formerror  id="data_documento"><br>
        <span class="errori">@formerror.data_documento;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data prot.1</td>
    <td valign=top><formwidget id="data_prot_01">
        <formerror  id="data_prot_01"><br>
        <span class="errori">@formerror.data_prot_01;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Protocollo 1</td>
    <td valign=top><formwidget id="protocollo_01">
        <formerror  id="protocollo_01"><br>
        <span class="errori">@formerror.protocollo_01;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data prot. 2</td>
    <td valign=top><formwidget id="data_prot_02">
        <formerror  id="data_prot_02"><br>
        <span class="errori">@formerror.data_prot_02;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Protocollo 2</td>
    <td valign=top><formwidget id="protocollo_02">
        <formerror  id="protocollo_02"><br>
        <span class="errori">@formerror.protocollo_02;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- ric01 aggiunta data_prot_03, protocollo_03 -->
<tr><td valign=top align=right class=form_title>Data prot. 3</td>
    <td valign=top><formwidget id="data_prot_03">
        <formerror  id="data_prot_03"><br>
        <span class="errori">@formerror.data_prot_03;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Protocollo 3</td>
    <td valign=top><formwidget id="protocollo_03">
        <formerror  id="protocollo_03"><br>
        <span class="errori">@formerror.protocollo_03;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Flag notifica/consegna</td>
    <td valign=top><formwidget id="flag_notifica">
        <formerror  id="flag_notifica"><br>
        <span class="errori">@formerror.flag_notifica;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data notifica/consegna</td>
    <td valign=top><formwidget id="data_notifica">
        <formerror  id="data_notifica"><br>
        <span class="errori">@formerror.data_notifica;noquote@</span>
        </formerror>
    </td>
</tr>

<if @funzione@ eq I or @funzione@ eq M>
<tr><td valign=top align=right class=form_title>Contenuto</td>
    <td valign=top colspan=3><formwidget id="contenuto">
        <formerror  id="contenuto"><br>
        <span class="errori">@formerror.contenuto;noquote@</span>
        </formerror>
    </td>
</tr>
</if>
<tr><td valign=top align=right class=form_title>Descrizione</td>
    <td valign=top colspan=3><formwidget id="descrizione">
        <formerror  id="descrizione"><br>
        <span class="errori">@formerror.descrizione;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Note</td>
    <td valign=top colspan=3><formwidget id="note">
        <formerror  id="note"><br>
        <span class="errori">@formerror.note;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan=4>&nbsp;</td></tr>

<if @funzione@ ne "V" or @nome_funz_caller@ eq "docu-ins">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

