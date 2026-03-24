<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<table align=center>
      <tr>
         <td align=center>Ditta manutentrice: <b>@nome_manu;noquote@</b></td>
      </tr>
      <tr>
         <td align=center>&nbsp;</td>
      </tr>
</table>

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimopma-list?@link_list;noquote@" class=func-menu>Ritorna</a>
   </td>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimopma-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimopma-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
<!-- Sandro in data 08/03/2017 ha chiesto che venisse disabilitata la cancellazione
         <a href="coimopma-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
-->
	@riga_reset_password;noquote@ <!-- rom01 11/04/2025 -->
      </td>
   </tr>
   </else>
</tr>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="extra_par">
<formwidget   id="last_cod_opma">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_opma">
<formwidget   id="url_manu">
<formwidget   id="nome_funz_caller">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<tr><td colspan=4>&nbsp;</td></tr>
<tr><td valign=top align=right class=form_title>Cognome</td>
    <td valign=top><formwidget id="cognome">
        <formerror  id="cognome"><br>
        <span class="errori">@formerror.cognome;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome</td>
    <td valign=top><formwidget id="nome">
        <formerror  id="nome"><br>
        <span class="errori">@formerror.nome;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Matricola</td>
    <td valign=top colspan=3><formwidget id="matricola">
        <formerror  id="matricola"><br>
        <span class="errori">@formerror.matricola;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Telefono</td>
    <td valign=top><formwidget id="telefono">
        <formerror  id="telefono"><br>
        <span class="errori">@formerror.telefono;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Cellulare</td>
    <td valign=top><formwidget id="cellulare">
        <formerror  id="cellulare"><br>
        <span class="errori">@formerror.cellulare;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Recapito</td>
    <td valign=top><formwidget id="recapito">
        <formerror  id="recapito"><br>
        <span class="errori">@formerror.recapito;noquote@</span>
        </formerror>
    </td>
    <!--but01 aggiunto il campo email_operator -->
    <td valign=top align=right class=form_title>Email</td>
        <td valign=top><formwidget id="email_operator">
	  <formerror  id="email_operator"><br>
	  <span class="errori">@formerror.email_operator;noquote@</span>
	  </formerror>
    </td>
				    
</tr>

<tr><td valign=top align=right class=form_title>Stato</td>
    <td valign=top><formwidget id="stato">
        <formerror  id="stato"><br>
        <span class="errori">@formerror.stato;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Codice Fiscale</td>
    <td valign=top><formwidget id="codice_fiscale">
        <formerror  id="codice_fiscale"><br>
        <span class="errori">@formerror.codice_fiscale;noquote@</span>
        </formerror>
    </td>
</tr>
<if @flag_portafoglio@ eq "T">
<tr><td valign=top align=right class=form_title>Amministratore portafoglio</td>
    <td valign=top><formwidget id="flag_portafoglio_admin">
        <formerror  id="flag_portafoglio_admin"><br>
        <span class="errori">@formerror.flag_portafoglio_admin;noquote@</span>
        </formerror>
    </td>
</tr>
</if>

<tr><td valign=top align=right class=form_title>Patentino</td>
    <td valign=top><formwidget id="patentino">
        <formerror  id="patentino"><br>
        <span class="errori">@formerror.patentino;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Patentino Fgas</td>
    <td valign=top><formwidget id="patentino_fgas">
        <formerror  id="patentino_fgas"><br>
        <span class="errori">@formerror.patentino_fgas;noquote@</span>
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

<if @funzione@ ne "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

