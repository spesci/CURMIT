<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 13/02/2023 Aggiunti i campi data_Accertamento e numero_accertamento su richiesta di Palermo.
    rom01            Sandro ha detto che va bene per tutti.

-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

@link_tab;noquote@
@dett_tab;noquote@

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimsanz-ins?funzione=I&@link_gest;noquote@" class=func-menu>Nuova Sanzione</a>
   </td>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimsanz-ins?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimsanz-ins?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimsanz-ins?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
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
<formwidget   id="last_cod_movi">
<formwidget   id="cod_impianto">
<formwidget   id="url_aimp">
<formwidget   id="url_list_aimp">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<tr><td valign=top align=right class=form_title>Codice</td>
    <td valign=top><formwidget id="cod_movi">
        <formerror  id="cod_movi"><br>
        <span class="errori">@formerror.cod_movi;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Causale pagamento</td>
    <td valign=top nowrap><formwidget id="id_caus">
        <formerror  id="id_caus"><br>
        <span class="errori">@formerror.id_caus;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<tr><td valign=top align=right class=form_title>Data Competenza</td>
    <td valign=top><formwidget id="data_compet">
        <formerror  id="data_compet"><br>
        <span class="errori">@formerror.data_compet;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Data scadenza</td>
    <td valign=top><formwidget id="data_scad">
        <formerror  id="data_scad"><br>
        <span class="errori">@formerror.data_scad;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Importo</td>
    <td valign=top><formwidget id="importo">
        <formerror  id="importo"><br>
        <span class="errori">@formerror.importo;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data pagamento</td>
    <td valign=top><formwidget id="data_pag">
        <formerror  id="data_pag"><br>
        <span class="errori">@formerror.data_pag;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Importo pagato</td>
    <td valign=top><formwidget id="importo_pag">
        <formerror  id="importo_pag"><br>
        <span class="errori">@formerror.importo_pag;noquote@</span>
        </formerror>
    </td>
</tr>


<tr><td valign=top align=right class=form_title>Tipo pagamento</td>
    <td valign=top colspan=3><formwidget id="tipo_pag">
        <formerror  id="tipo_pag"><br>
        <span class="errori">@formerror.tipo_pag;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Nota</td>
    <td valign=top colspan=3><formwidget id="nota">
        <formerror  id="nota"><br>
        <span class="errori">@formerror.nota;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan=4>&nbsp;</td></tr>
<tr><td colspan=4>&nbsp;</td></tr>

<tr><td valign=top align=right class=form_title>Data accertamento</td>
    <td valign=top><formwidget id="data_accertamento">
        <formerror  id="data_accertamento"><br>
        <span class="errori">@formerror.data_accertamento;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Numero accertamento</td>
    <td valign=top><formwidget id="numero_accertamento">
        <formerror  id="numero_accertamento"><br>
        <span class="errori">@formerror.numero_accertamento;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Tipo sanzione 1</td>
    <td valign=top colspan=3><formwidget id="cod_sanzione_1">
        <formerror  id="cod_sanzione_1"><br>
        <span class="errori">@formerror.cod_sanzione_1;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Tipo sanzione 2</td>
    <td valign=top colspan=3><formwidget id="cod_sanzione_2">
        <formerror  id="cod_sanzione_2"><br>
        <span class="errori">@formerror.cod_sanzione_2;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Tipo soggetto</td>
    <td valign=top colspan=3><formwidget id="tipo_soggetto">
        <formerror  id="tipo_soggetto"><br>
        <span class="errori">@formerror.tipo_soggetto;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
     <td valign=top align=right>Soggetto</td>
     <td valign=top nowrap colspan=3><formwidget id="cognome">
        <valign=top><formwidget id="nome">
        <formerror  id="cognome_occ"><br>
        <span class="errori">@formerror.cognome;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Data richiesta audizione</td>
    <td valign=top><formwidget id="data_rich_audiz">
        <formerror  id="data_rich_audiz"><br>
        <span class="errori">@formerror.data_rich_audiz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note richiesta audizione</td>
    <td valign=top><formwidget id="note_rich_audiz">
        <formerror  id="note_rich_audiz"><br>
        <span class="errori">@formerror.note_rich_audiz;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data presentazione deduzioni</td>
    <td valign=top><formwidget id="data_pres_deduz">
        <formerror  id="data_pres_deduz"><br>
        <span class="errori">@formerror.data_pres_deduz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note presentazione deduzioni</td>
    <td valign=top><formwidget id="note_pres_deduz">
        <formerror  id="note_pres_deduz"><br>
        <span class="errori">@formerror.note_pres_deduz;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data ricorso al giudice</td>
    <td valign=top><formwidget id="data_ric_giudice">
        <formerror  id="data_ric_giudice"><br>
        <span class="errori">@formerror.data_ric_giudice;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note ricorso al giudice</td>
    <td valign=top><formwidget id="note_ric_giudice">
        <formerror  id="note_ric_giudice"><br>
        <span class="errori">@formerror.note_ric_giudice;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data primo ricorso</td>
    <td valign=top><formwidget id="data_ric_tar">
        <formerror  id="data_ric_tar"><br>
        <span class="errori">@formerror.data_ric_tar;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note primo ricorso</td>
    <td valign=top><formwidget id="note_ric_tar">
        <formerror  id="note_ric_tar"><br>
        <span class="errori">@formerror.note_ric_tar;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data secondo ricorso</td>
    <td valign=top><formwidget id="data_ric_ulter">
        <formerror  id="data_ric_ulter"><br>
        <span class="errori">@formerror.data_ric_ulter;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note secondo ricorso</td>
    <td valign=top><formwidget id="note_ric_ulter">
        <formerror  id="note_ric_ulter"><br>
        <span class="errori">@formerror.note_ric_ulter;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Data ruolo</td>
    <td valign=top><formwidget id="data_ruolo">
        <formerror  id="data_ruolo"><br>
        <span class="errori">@formerror.data_ruolo;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Note ruolo</td>
    <td valign=top><formwidget id="note_ruolo">
        <formerror  id="note_ruolo"><br>
        <span class="errori">@formerror.note_ruolo;noquote@</span>
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

