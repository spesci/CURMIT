<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 09/09/2025 Aggiunta la classe link-button-2 ai link continua e torna alla home page.
    mat01            Tolto il trattino tra i 2 link. 
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
  <formtemplate id="@form_name@">
    @dett_tab;noquote@
    <table width="80%" align="center">
      <tr>
	<td>&nbsp;</td>
      </tr>
      <tr>
	<td>&nbsp;</td>
      </tr>
      <tr>
	<td class="func-menu-yellow2"><big><b>@titolo;noquote@</b></big></td> 
      </tr>
      <tr>
	<td>&nbsp;</td>
      </tr>
      <tr>
	<td>
	  <table width="70%" align="center">
	    <tr>
	      <td valign="top" align="justify" class="form_title"><big>E’ ora possibile visualizzare/inserire/modificare le schede del libretto relative a questo impianto <small> (che saranno poi inserite in automatico da CURMIT nel libretto complessivo stampabile, insieme alle schede di eventuali altri impianti del sistema edificio-impianto)</small> o inserire i Rapporti di controllo dell’efficienza energetica e gli altri moduli regionali.</big>
	      </td>
	    </tr>
	  </table>
	</td>
      </tr>
      <tr>
	<td>&nbsp;</td>
      </tr>
      <tr>
	<td>&nbsp;</td>
      </tr>
      <tr>
      <td align="center"><a class="link-button-2" href="@return_url;noquote@">CONTINUA</a>&nbsp;&nbsp;<a class="link-button-2" href="/../iter/main">TORNA ALLA HOME PAGE</a>
      </td>
      </tr>
        <td align="center"></td>
	</tr>
    </table>
</center>

