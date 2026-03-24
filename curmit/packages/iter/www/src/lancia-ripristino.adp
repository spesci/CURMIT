<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mic01 27/05/2022 Introdotta funzione di ricerca manutentori
    
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="current_date">
<formwidget   id="current_time">

<h2>Ripristino caricamento interrotto</h2><!--mic01-->

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>


<tr>
    <td valign=top align=right class=form_title>Tipo modello</td>
    <td valign=top><formwidget id="tipo_modello">
        <formerror  id="tipo_modello"><br>
        <span class="errori">@formerror.tipo_modello;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
<td colspan=2 align=center><b><br>Manutentore</b></td>
</tr>
<tr>  <!--mic01 introdotta funzione di ricerca manutentori-->
  <td valign=top align=right class=form_title>Cognome</td>
  <td valign=top><formwidget id="f_manu_cogn">
    <formerror  id="f_manu_cogn"><br>
      <span class="errori">@formerror.f_manu_cogn;noquote@</span>
    </formerror>
  </td>   
  <td valign=top align=right class=form_title>Nome</td>
  <td valign=top><formwidget id="f_manu_nome">@cerca_manu;noquote@
    <formerror  id="f_manu_nome"><br>
      <span class="errori">@formerror.f_manu_nome;noquote@</span>
    </formerror>
  </td>   
</tr>


<tr><td colspan=2>&nbsp;</td></tr>

    <tr><td colspan=2 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->

<%=[iter_form_fine]%>


</table>
</if>

</formtemplate>
<p>
</center>

