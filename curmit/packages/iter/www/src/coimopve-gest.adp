<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 15/09/2021 Modifiche per targatura Ispettori: Aggiunto il campo cod_portale, va valorizzato con lo stesso
    rom02            valore dell'omonimo campo del portale (iter_inspectors) dopo che viene registrato l'ispettore.
    rom02            Modifica riportata per allinemanto di UCIT al nuovo cvs. E' stata una modifica fatta appositamente
    rom02            per Ucit e con Sandro si e' deciso di rendere il campo visibile solo per Regione Friuli.

    rom01 13/09/2018 Aggiunto campo email
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<table align=center>
      <tr>
         <td align=center>Ente verificatore: <b>@nome_enve;noquote@</b></td>
      </tr>
      <tr>
         <td align=center>&nbsp;</td>
      </tr>
</table>

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimopve-list?@link_list;noquote@" class=func-menu>Ritorna</a>
   </td>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimopve-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimopve-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimopve-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
      </td>
   </tr>
   <tr>

      <td width="25%" nowrap class=func-menu>
         <a href="#" onclick="javascript:window.open('@link_area;noquote@', 'aree', 'scrollbars=yes, resizable=yes, width=790, height=450').moveTo(50,140)">Aree</a>
      </td>
           <td width="25%" nowrap class=func-menu>
	    <a href="@link_disp;noquote@" class=func-menu>Disponibilit&agrave; giornaliera</a>
	    </td>
	    <td width="25%" nowrap class=func-menu>
	    <a href="@link_disp2;noquote@" class=func-menu>Creazione Disponibilit&agrave;</a>
	    </td>
	    <td width="25%" class=func-menu>&nbsp;</td>
    
      </else>
</tr>
</table>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="extra_par">
<formwidget   id="last_cod_opve">
<formwidget   id="cod_enve">
<formwidget   id="cod_opve">
<formwidget   id="url_enve">
<formwidget   id="nome_funz_caller">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

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
    <td valign=top><formwidget id="matricola">
        <formerror  id="matricola"><br>
        <span class="errori">@formerror.matricola;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Tariffa</td>
    <td valign=top><formwidget id="cod_listino">
        <formerror  id="cod_listino"><br>
        <span class="errori">@formerror.cod_listino;noquote@</span>
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
    <td valign=top align=right class=form_title>E-mail</td><!--rom01-->
    <td valign=top><formwidget id="email">
        <formerror  id="email"><br>
          <span class="errori">@formerror.email;noquote@</span>
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
    <if @coimtgen.regione@ eq "FRIULI-VENEZIA GIULIA"><!--rom02 Aggiunta if e suo contenuto -->
      <td valign=top align=right class=form_title>Codice Portale</td>
      <td valign=top><formwidget id="cod_portale">
        <formerror  id="cod_portale"><br>
	 <span class="errori">@formerror.cod_portale;noquote@</span>
        </formerror>
     </td>
   </if>
</tr>

<tr><td valign=top align=right class=form_title>Note</td>
    <td valign=top colspan=3><formwidget id="note">
        <formerror  id="note"><br>
        <span class="errori">@formerror.note;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
   <td colspan=4>
   <hr>
   </td>
</tr>

<if @funzione@ eq I or @funzione@ eq M>
<tr><td colspan=4>@link_aggiungi_gen;noquote@</td></tr>
</if>

<formwidget id="conta_max">
<if @flag_esiste@ eq S>
<tr><td align=left colspan=4><table width="100%">

    <multiple name=multiple_form>
    <tr>
       <td valign=top align=right class=form_title>Strumento</td>
       <td valign=top ><formwidget id="strumento.@multiple_form.conta;noquote@">
         <formerror  id="strumento.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(strumento.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
       <td valign=top align=right class=form_title>Imposta come default</td>
       <td valign=top ><formgroup id="strum_default.@multiple_form.conta;noquote@">@formgroup.widget;noquote@</formgroup>
         <formerror  id="strum_default.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(strum_default.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
       </td>
    </tr>
    <tr>
       <td valign=top align=right class=form_title>Marca</td>
       <td valign=top><formwidget id="marca_strum.@multiple_form.conta;noquote@">
         <formerror  id="marca_strum.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(marca_strum.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
       <td valign=top align=right class=form_title>Modello</td>
       <td valign=top><formwidget id="modello_strum.@multiple_form.conta;noquote@">
         <formerror  id="modello_strum.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(modello_strum.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
    </tr>
    <tr>
       <td valign=top align=right class=form_title>Data Taratura</td>
       <td valign=top><formwidget id="dt_tar_strum.@multiple_form.conta;noquote@">
         <formerror  id="dt_tar_strum.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(dt_tar_strum.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
       <td valign=top align=right class=form_title>Matricola</td>
       <td valign=top><formwidget id="matr_strum.@multiple_form.conta;noquote@">
         <formerror  id="matr_strum.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(matr_strum.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
    </tr>
    <tr>
       <td valign=top align=right class=form_title>Data inizio att.</td>
       <td valign=top><formwidget id="dt_inizio_att.@multiple_form.conta;noquote@">
         <formerror  id="dt_inizio_att.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(dt_inizio_att.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
       <td valign=top align=right class=form_title>Data fine att.</td>
       <td valign=top><formwidget id="dt_fine_att.@multiple_form.conta;noquote@">
         <formerror  id="dt_fine_att.@multiple_form.conta;noquote@"><br>
         <span class="errori"><%= $formerror(dt_fine_att.@multiple_form.conta;noquote@) %></span>
         </formerror>
       </td>
    </tr>
    <tr><td colspan=4>&nbsp;</td></tr>
    </multiple>
</table></td></tr>
</if>
<tr><td colspan=4>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

