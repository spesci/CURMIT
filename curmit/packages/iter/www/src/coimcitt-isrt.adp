<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 17/12/2018 Aggiunto asterisco rosso per i campi obbligatori

    gab01 13/02/2017 Gestisco il nuovo campo pec della coimcitt.

-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

@js_function;noquote@
<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="dummy">
<formwidget   id="receiving_element">
<formwidget   id="descr_via">
<formwidget   id="descr_topo">
<formwidget   id="cod_comune">
<formwidget   id="flag_modello_h">
<formwidget   id="flag_ins_prop">
<formwidget   id="numero">
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>


<tr><td valign=top align=right class=form_title>Cognome<font color=red>*</font></td>
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

<tr><td valign=top align=right class=form_title>Indirizzo<font color=red>*</font></td>
    <td valign=top ><formwidget id="indirizzo">
        <formerror  id="indirizzo"><br>
        <span class="errori">@formerror.indirizzo;noquote@</span>
        </formerror>
    </td>
    <!-- <td valign=top align=right class=form_title>Civico</td>
    <td valign=top><formwidget id="numero">
        <formerror  id="numero"><br>
        <span class="errori">@formerror.numero;noquote@</span>
        </formerror>
    </td> -->
</tr>

<tr><td valign=top align=right class=form_title>Comune<font color=red>*</font></td>
    <td valign=top nowrap><formwidget id="comune">@link_comune;noquote@
        <formerror  id="comune"><br>
        <span class="errori">@formerror.comune;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Localit&agrave;</td>
    <td valign=top><formwidget id="localita">
        <formerror  id="localita"><br>
        <span class="errori">@formerror.localita;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Provincia<font color=red>*</font></td>
    <td valign=top><formwidget id="provincia">
        <formerror  id="provincia"><br>
        <span class="errori">@formerror.provincia;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>C.A.P.<font color=red>*</font></td>
    <td valign=top><formwidget id="cap">
        <formerror  id="cap"><br>
        <span class="errori">@formerror.cap;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
   <td valign=top align=right class=form_title>Natura giuridica<font color=red>*</font></td>
   <td valign=top><formwidget id="natura_giuridica">
       <formerror  id="natura_giuridica"><br>
       <span class="errori">@formerror.natura_giuridica;noquote@</span>
       </formerror>
   </td>
   <td valign=top align=right class=form_title>Cod.Fisc.</td>
   <td valign=top><formwidget id="cod_fiscale">
       <formerror  id="cod_fiscale"><br>
       <span class="errori">@formerror.cod_fiscale;noquote@</span>
       </formerror>
   </td>
   <td valign=top align=right class=form_title>P.IVA</td>
   <td valign=top><formwidget id="cod_piva">
       <formerror  id="cod_piva"><br>
       <span class="errori">@formerror.cod_piva;noquote@</span>
       </formerror>
   </td>
</tr>

<tr><td valign=top align=right class=form_title>Telefono</td>
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

<tr><td valign=top align=right class=form_title>E-mail</td>
    <td valign=top><formwidget id="email">
        <formerror  id="email"><br>
        <span class="errori">@formerror.email;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Fax</td>
    <td valign=top><formwidget id="fax">
        <formerror  id="fax"><br>
        <span class="errori">@formerror.fax;noquote@</span>
        </formerror>
    </td>
    <!-- gab01 aggiunto il campo pec -->
    <td valign=top align=right class=form_title>Pec</td>
    <td valign=top><formwidget id="pec">
        <formerror  id="pec"><br>
        <span class="errori">@formerror.pec;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Comune di nascita</td>
    <td valign=top><formwidget id="comune_nas">@link_comune_nas;noquote@
        <formerror  id="comune_nas"><br>
        <span class="errori">@formerror.comune_nas;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data</td>
    <td valign=top><formwidget id="data_nas">
        <formerror  id="data_nas"><br>
        <span class="errori">@formerror.data_nas;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Note</td>
    <td valign=top colspan=3><formwidget id="note">
        <formerror  id="note"><br>
        <span class="errori">@formerror.note;noquote@</span>
        </formerror>
    </td>
</tr>



<if @funzione@ ne "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>


<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

