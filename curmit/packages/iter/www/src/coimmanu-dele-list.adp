<!DOCTYPE html>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================

  -->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @flag_portafoglio@ eq T>
<if @flag_valor_cod@ eq t>

<script type="text/javascript">
function sel() {
 window.opener.document.coimdimp.rag_sociale_delegato.value = '@rag_sociale_delegato;noquote@';
 window.opener.document.coimdimp.cod_manu_dele.value = '@cod_manu_dele;noquote@';
@javascript_sel;noquote@ 
 window.close();
 } 

setTimeout('sel()',0);
</script>

</if>
</if>

@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>

