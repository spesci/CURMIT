<master src="../master">
<!--  <property name="context">@context;noquote@</property> -->
  <property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>  
<table width="100%" cellspacing=0 class=func-menu>
   <tr>
     <if @id_ruolo@ ne "manutentore">
     <td width="25%" nowrap class=func-menu>
       <a href=coimmanu-list?@link_list;noquote@  class=func-menu>Ritorna</a>
     </td>
     </if>
   <td width="25%" nowrap class=func-menu>
       <a href=ec?format=csv&@link_scar;noquote@  class=func-menu>Scarica CSV</a>
   </td>
   <td width="75%" class=func-menu>&nbsp;</td>
</tr>
</table>
<br>
<table cellpadding="2" cellspacing="2">
  <tr>
    <th>Manutentore:</th><td>@cognome@</td>
    <th>Cod. portafoglio</th><td>@wallet_id@</td>
    <th>Cod. iban</th><td>@iban_code@</td>
  </tr>
</table>

<if @errnum@ nil>
<table cellpadding="2" cellspacing="2">
  <tr>
    <th>Entrate nel periodo</th><td>@entrate@</td>
    <th>Uscite nel periodo</th><td>@uscite@</td>
    <th>Differenza</th><td>@delta@</td>
    <th>Credito residuo</th><td>@final_balance@</td>
  </tr>
</table>
</if>

<table cellpadding="2" cellspacing="2">

  <tr>

    <td class="list-filter-pane" valign="top">
      <formtemplate id="filter" style="filter"></formtemplate>
    </td>

    <td valign="top">
      @ec;noquote@
    </td>

  </tr>

</table>

