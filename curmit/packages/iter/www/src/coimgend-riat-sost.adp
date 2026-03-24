<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<blockquote>

  <center>
    <formtemplate id="addedit">
    
    <!-- Inizio della form colorata -->
    <%=[iter_form_iniz]%>
    
    
    Riattivazione di un generatore che è stato sostituito.
    <tr><td>&nbsp</td></tr>
    
    <tr>
      <td valign=top align=right class=form_title>Codice impianto</td>
        <td valign=top><formwidget id="cod_impianto_est">
            <formerror  id="cod_impianto_est"><br>
            <span class="errori">@formerror.cod_impianto_est;noquote@</span>
            </formerror>
        </td>
    </tr>
    <tr>
      <td valign=top align=right class=form_title>Numero generatore</td>
      <td valign=top><formwidget id="gen_prog_est">
          <formerror  id="gen_prog_est"><br>
            <span class="errori">@formerror.gen_prog_est;noquote@</span>
          </formerror>
      </td>
    </tr>
    
    <tr><td>&nbsp</td></tr>
    
    <tr><td align=center colspan=2><formwidget id="submit"></td></tr>
 
    <!-- Fine della form colorata -->
    <%=[iter_form_fine]%>
    </formtemplate>
    <p>
  </center>
  
</blockquote>
