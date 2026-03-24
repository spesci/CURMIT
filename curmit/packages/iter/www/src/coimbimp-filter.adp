<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="f_cod_via">
<formwidget   id="f_cod_manu">
<formwidget   id="dummy">
<if @flag_ente@ eq "C">
    <formwidget id="f_comune">
</if>
<!-- Inizio della form colorata -->

<%=[iter_form_iniz]%>

<tr>
   <td>
   <table>
      @impianto_old_adp;noquote@
      <tr><td colspan=2 align=right>
           <a href="#" onclick="javascript:window.open('coimdimp-ins-help', 'help', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)"><b>Help</b></a>
         </td>
      </tr>
      <if @flag_ente@ eq P and @sigla_prov@ eq LI>
          <tr>
             <td valign=top align=right class=form_title>Codice bollino</td>
             <td valign=top><formwidget id="cod_impianto_est_new">
                <formerror  id="cod_impianto_est_new"><br>
                <span class="errori">@formerror.cod_impianto_est_new;noquote@</span>
                </formerror>
             </td>
          </tr>
      </if>
      <tr>
         <td valign=top colspan=2 align=left class=form_title>
             <b>Ricerca per responsabile</b>
         </td>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Cognome</td>
         <td valign=top><formwidget id="f_resp_cogn">
            <formerror  id="f_resp_cogn"><br>
            <span class="errori">@formerror.f_resp_cogn;noquote@</span>
            </formerror>
         </td>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Nome</td>
         <td valign=top><formwidget id="f_resp_nome">
            <formerror  id="f_resp_nome"><br>
            <span class="errori">@formerror.f_resp_nome;noquote@</span>
            </formerror>
         </td>
      </tr>

      <tr>
         <td valign=top colspan=2 nowrap align=left class=form_title>
             <b>Ricerca per indirizzo</b>
         </td>
      </tr>

      <tr>
      <if @flag_ente@ eq "P">
         <td valign=top align=right class=form_title>Comune</td>
         <td valign=top><formwidget id="f_comune">
            <formerror  id="f_comune"><br>
            <span class="errori">@formerror.f_comune;noquote@</span>
            </formerror>
         </td>
      </if>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Indirizzo</td>
         <td valign=top><formwidget id="f_desc_topo">
             <formwidget id="f_desc_via">@cerca_viae;noquote@
             <formerror  id="f_desc_via"><br>
             <span class="errori">@formerror.f_desc_via;noquote@</span>
             </formerror>
         </td>

      </tr>

      <tr>
         <td valign=top colspan=2 nowrap align=left class=form_title>
             <b>Ricerca per manutentore</b>
         </td>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Cognome</td>
         <td valign=top><formwidget id="f_manu_cogn">
            <formerror  id="f_manu_cogn"><br>
            <span class="errori">@formerror.f_manu_cogn;noquote@</span>
            </formerror>
         </td>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Nome</td>
         <td valign=top><formwidget id="f_manu_nome">@cerca_manu;noquote@
            <formerror  id="f_manu_nome"><br>
            <span class="errori">@formerror.f_manu_nome;noquote@</span>
            </formerror>
         </td>
      </tr>

   </table>
   </td>
</tr>

<tr><td>&nbsp;</td>
<tr><td align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

