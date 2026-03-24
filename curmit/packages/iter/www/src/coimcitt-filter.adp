<!--
    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    rom01 12/09/2022 Aggiunto filtro per p_iva.

-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="receiving_element">
<formwidget   id="dummy">
<formwidget   id="flag_ammi">
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr>
   <td align=right colspan=2><a href="#" onclick="javascript:window.open('coimcitt-help', 'help', 'scrollbars=yes, resizable=yes, width=570, height=320').moveTo(110,140)"><b>Help</b></a>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Codice Soggetto</td>
    <td valign=top><formwidget id="f_cod_cittadino">
        <formerror  id="f_cod_cittadino"><br>
        <span class="errori">@formerror.f_cod_cittadino;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Cod.Fisc.</td>
    <td valign=top nowrap><formwidget id="f_cod_fiscale">
        <formerror  id="f_cod_fiscale"><br>
        <span class="errori">@formerror.f_cod_fiscale;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><!--rom01 Aggiunta riga con campo f_cod_piva -->
  <td valign=top align=right class=form_title>P.Iva</td>
  <td valign=top nowrap><formwidget id="f_cod_piva">
      <formerror  id="f_cod_piva"><br>
	<span class="errori">@formerror.f_cod_piva;noquote@</span>
      </formerror>
  </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Cognome</td>
    <td valign=top nowrap><formwidget id="f_cognome">
        <formerror  id="f_cognome"><br>
        <span class="errori">@formerror.f_cognome;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Nome</td>
    <td valign=top nowrap><formwidget id="f_nome">
        <formerror  id="f_nome"><br>
        <span class="errori">@formerror.f_nome;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Comune</td>
    <td valign=top nowrap><formwidget id="f_comune">@link_comune;noquote@
        <formerror  id="f_comune"><br>
        <span class="errori">@formerror.f_comune;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Stato soggetto</td>
    <td valign=top nowrap><formwidget id="f_stato_citt">
        <formerror  id="f_stato_citt"><br>
        <span class="errori">@formerror.f_stato_citt;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

