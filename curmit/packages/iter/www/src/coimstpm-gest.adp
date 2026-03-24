<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>


<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimstpm-list?@link_list;noquote@" class=func-menu>Ritorna</a>
   </td>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimstpm-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimstpm-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimstpm-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
      </td>
   </else>
</tr>
</table>


<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_id_stampa">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<tr><td valign=top align=right class=form_title>Descrizione</td>
    <td valign=top colspan=2><formwidget id="descrizione">
        <formerror  id="descrizione"><br>
        <span class="errori">@formerror.descrizione;noquote@</span>
        </formerror>
    </td>
    <td align=right>
        <a href="#" onclick="javascript:window.open('coimstpm-help', 'help', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)"><b>Help</b></a>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Dicitura Variabile 1</td>
    <td valign=top><formwidget id="campo1">
        <formerror  id="campo1"><br>
        <span class="errori">@formerror.campo1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome Variabile 1</td>
    <td valign=top><formwidget id="campo1_testo">
        <formerror  id="campo1_testo"><br>
        <span class="errori">@formerror.campo1_testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Dicitura Variabile 2</td>
    <td valign=top><formwidget id="campo2">
        <formerror  id="campo2"><br>
        <span class="errori">@formerror.campo2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome Variabile 2</td>
    <td valign=top><formwidget id="campo2_testo">
        <formerror  id="campo2_testo"><br>
        <span class="errori">@formerror.campo2_testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Dicitura Variabile 3</td>
    <td valign=top><formwidget id="campo3">
        <formerror  id="campo3"><br>
        <span class="errori">@formerror.campo3;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome Variabile 3</td>
    <td valign=top><formwidget id="campo3_testo">
        <formerror  id="campo3_testo"><br>
        <span class="errori">@formerror.campo3_testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Dicitura Variabile 4</td>
    <td valign=top><formwidget id="campo4">
        <formerror  id="campo4"><br>
        <span class="errori">@formerror.campo4;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome Variabile 4</td>
    <td valign=top><formwidget id="campo4_testo">
        <formerror  id="campo4_testo"><br>
        <span class="errori">@formerror.campo4_testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Dicitura Variabile 5</td>
    <td valign=top><formwidget id="campo5">
        <formerror  id="campo5"><br>
        <span class="errori">@formerror.campo5;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Nome Variabile 5</td>
    <td valign=top><formwidget id="campo5_testo">
        <formerror  id="campo5_testo"><br>
        <span class="errori">@formerror.campo5_testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Inserisci nota</td>
    <td valign=top><formwidget id="var_testo">(Se s&igrave; utilizzare $nota nel testo modello stampa)
        <formerror  id="var_testo"><br>
        <span class="errori">@formerror.var_testo;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Allegato</td>
    <td valign=top><formwidget id="allegato">
        <formerror  id="allegato"><br>
        <span class="errori">@formerror.allegato;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Tipo Foglio</td>
    <td valign=top><formwidget id="tipo_foglio">
        <formerror  id="tipo_foglio"><br>
        <span class="errori">@formerror.tipo_foglio;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Orientamento carta</td>
    <td valign=top><formwidget id="orientamento">
        <formerror  id="orientamento"><br>
        <span class="errori">@formerror.orientamento;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Tipo documento</td>
    <td valign=top><formwidget id="tipo_documento">
        <formerror  id="tipo_documento"><br>
        <span class="errori">@formerror.tipo_documento;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Margine alto(cm)</td>
    <td valign=top><formwidget id="margine_alto">
        <formerror  id="margine_alto"><br>
        <span class="errori">@formerror.margine_alto;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Margine basso(cm)</td>
    <td valign=top><formwidget id="margine_basso">
        <formerror  id="margine_basso"><br>
        <span class="errori">@formerror.margine_basso;noquote@</span>
        </formerror>
    </td>
</tr>
    <td valign=top align=right class=form_title>Margine sinistro(cm)</td>
    <td valign=top><formwidget id="margine_sinistro">
        <formerror  id="margine_sinistro"><br>
        <span class="errori">@formerror.margine_sinistro;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Margine destro(cm)</td>
    <td valign=top><formwidget id="margine_destro">
        <formerror  id="margine_destro"><br>
        <span class="errori">@formerror.margine_destro;noquote@</span>
        </formerror>
    </td>
<tr>
</tr>
<tr><td valign=top align=right class=form_title>Testo</td>
    <td valign=top colspan=3><formwidget id="testo">
        <formerror  id="testo"><br>
        <span class="errori">@formerror.testo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan 4>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

