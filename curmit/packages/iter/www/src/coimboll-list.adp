<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @nome_funz_caller@ eq @nome_funz@ >
   <table width="100%" cellspacing=0 class=func-menu>
   <tr>
      <td width="25%" nowrap class=func-menu>
          <a href="coimboll-filter?@link_filter;noquote@" class=func-menu>Ritorna</a>
      </td>
      <td width="25%" nowrap class=func-menu>
        <a href="coimboll-scar?@link_scar;noquote@" class=func-menu>Scarica CSV</a>
      </td>
      <td width="25%" nowrap class=func-menu>
        <a target="Stampa lista bollini" href="coimboll-layout?@link_stp;noquote@" class=func-menu>Stampa PDF</a>
      </td>
      <td width="25%" nowrap class=func-menu>
       &nbsp;
      </td>

   </tr>
   </table>
</if>
<else>
   <table width="25%" cellspacing=0 class=func-menu>
   <tr>
      <if @flag_manu@ eq S>
         <td width="25%" nowrap class=func-menu>
             <a href=@url_manu;noquote@ class=func-menu>Ritorna</a>
         </td>
      </if>
   </tr>
   </table>
</else>

@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>

