<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @caller@ eq index>
     <table width="25%" cellspacing=0 class=func-menu>
     <tr>
       <if @nome_funz_caller@ eq impianti or @nome_funz_caller@ eq essi>
           <td width="25%" nowrap class=func-menu>
               <a href="coimaimp-filter?@link_filter;noquote@" class=func-menu>Ritorna</a>
           </td>
       </if>
       <else>
           <if @nome_funz_caller@ eq @nome_funz_citt@ >
               <td width="25%" nowrap class=func-menu>
                   <a href="@url_citt;noquote@" class=func-menu>Ritorna</a>
               </td>
           </if>
           <if @nome_funz_caller@ eq @nome_funz_manu@ >
               <td width="25%" nowrap class=func-menu>
                   <a href="@url_manu;noquote@" class=func-menu>Ritorna</a>
               </td>
           </if>
       </else>
       <td width="25%" nowrap class=func-menu>
          <a href="coimaimp-list-csv?@link_scar;noquote@"  class=func-menu>Scarica CSV</a>
       </td>
       <td width="25%" nowrap class=func-menu>
         <!-- rom01<a href="coimaimp-scar-xml?@link_scar;noquote@"  class=func-menu download="scarica_xml.xml">Scarica XML</a>--><!-- ric01 -->
	 <a href="#" onclick="javascript:window.open('@pack_dir;noquote@/coimaimp-scar-xml?@link_scar;noquote@' , 'help', 'scrollbars=yes, resizable=yes, width=840, height=520').moveTo(110,140)">Scarica XML</a><!-- rom01 -->
       </td>
     </tr>
     </table>
</if>
@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>

