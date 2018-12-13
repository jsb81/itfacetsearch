{set_defaults( hash(
    'export_attributes', '',
))}

{* Script per la ricerca della classe persone (repo112) *}
{literal}
<script>
    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    var class_identifier = "{/literal}{$classes}{literal}";
    var class_attributes = "{/literal}{$class_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = {/literal}{$node.node_id}{literal};
    var show_datatable = false;
    

    // Imposta le faccette per le select options
    function setSelectFacet( facet, item, selected_item_value ){
        if(selected_item_value === ''){
            item.html('<option value="" selected>(Tutti)</option>');
        }
        else{
            item.html('<option value="">(Tutti)</option>');
        }

        if( facet !== null ){
            $.each(facet.countList, function( _label, _count ){
                var _disabled = false;
                if(_count === 0){
                    _disabled = true;
                }

                /* DEBUG *
                if(_label === ''){
                    _label = '<N/D>';
                    _disabled = true;
                }
                /**/

                if(_label !== ''){
                    if(selected_item_value === _label){
                       item.append($('<option>', {
                            value: _label,
                            text : _label + ' (' +  _count +  ')',
                            disabled: _disabled,
                            selected: ''
                        }));
                    }
                    else{
                        item.append($('<option>', {
                            value: _label,
                            text : _label + ' (' +  _count +  ')',
                            disabled: _disabled
                        }));
                    }
                }

            });
        }
    }
    
    $(document).ready(function(){
        var dataTable = $("#datatable_content").DataTable({
             "processing": true,
             "serverSide": true,
             "bFilter": false,
             "ajax": {
                 "type": "GET",
                 "url": "https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id,
                 "data": function( d ) {
                     // Select Options
                     $('#search_form option:selected').each(function(){
                         var parent = $(this).parent();

                         d[ parent.attr('name') ] = $(this).val();
                     });
                     // Inputs
                     $('#search_form :input').each(function(){
                         d[ $(this).attr('name') ] = $(this).val();
                     });
                 }
             },
             /*"order": [[ 0, "asc" ],[ 1, "asc" ]], // Barbatrucco per ordinare per rilevanza*/
             "language": {
                 sEmptyTable: "Nessun dato presente nella tabella",
                 sInfo: "Vista da _START_ a _END_ di _TOTAL_ elementi",
                 sInfoEmpty: "Vista da 0 a 0 di 0 elementi",
                 sInfoFiltered: "(filtrati da _MAX_ elementi totali)",
                 sInfoPostFix: "",
                 sInfoThousands: ".",
                 sLengthMenu: "Visualizza _MENU_ elementi",
                 sLoadingRecords: "Caricamento...",
                 sProcessing: "Elaborazione...",
                 sSearch: "Cerca:",
                 sZeroRecords: "La ricerca non ha portato alcun risultato.",
                 oPaginate: {
                     sFirst: "Inizio",
                     sPrevious: "Precedente",
                     sNext: "Successivo",
                     sLast: "Fine"
                 },
                 oAria: {
                     sSortAscending: ": attiva per ordinare la colonna in ordine crescente",
                     sSortDescending: ": attiva per ordinare la colonna in ordine decrescente"
                 },
                 buttons: {
                     print: "Stampa",
                     copy: "Copia"
                 }
             }, 
             "responsive": true,
             "bInfo" : false // Nasconde il numero di righe visualizzate
        });


        // Aggiorno le Faccette //
        $("#datatable_content").on('xhr.dt', function(e, settings, result, xhr){
            
            {/literal}
                {foreach $facet_attributes|explode('|') as $index => $fct}
                    setSelectFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
                {/foreach}
            {literal}
            
            // Visualizzo i dati caricati //
            $("#loading").hide();
            $("#search").show();
            
            $("#datatable").show();
            $('#datatable_content').DataTable()
                .columns.adjust()
                .responsive.recalc();

            if(result.recordsTotal === 1){
                $("#numRows").html( '<b>' + result.recordsTotal + ' {/literal}{$single_result_count_name}{literal}</b>' );
            }
            else{
                $("#numRows").html( '<b>' + result.recordsTotal + ' {/literal}{$multiple_result_count_name}{literal}</b>' );
            }
            
            // search( null );
        });
        
        // Aggiorna la ricerca //
        function search(event){
            
            // Sistema per togliere impostazione di una faccetta
            if(event !== null && $(event.target).attr("class") === "search-choice-close"){
                var id_reset = event.target.id;
                var parent_id = id_reset.replace('_reset', '');
                
                $("#"+parent_id).val( '' );
                $("#"+parent_id).show();
                
                $("#"+parent_id+"_value").html( '' );
                $("#"+parent_id+"_choosen").hide();
            }

            console.log("https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id);

            dataTable.ajax.reload();
            
            // Imposta il sistema per rimuovere la faccetta se è selezionato un valore
            if(event !== null){
                var value = $(event.target).val();
                var source_id = event.target.id;
                if(value !== '' && source_id !== 'query'){
                    $(event.target).hide();

                    $("#"+source_id+"_value").html( value );
                    $("#"+source_id+"_choosen").show();
                }
            }
            
        }
        
        // Ricarica lanciata su invio //
        $("#query").keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                search(event);
            }
        });
        
        // Ricarica lanciata su mouse click //
        $("#query_click").click(function(event) {
            search(event);
        });
        
        
        // Ricarica lanciata su select //
        $("#search_form select").change(function(event){
            search(event);
        });
        
       // Reset di una faccetta //
       $(".search-choice-close").click(function(event){
            search(event);
       });
       
        // Azzera la ricerca //
        $("#reset_button").click(function(event){
            $("#query").val("");
            
            {/literal}
            {foreach $facet_attributes|explode('|') as $index => $fct}
                $("#{$fct}").val("");
                $("#{$fct}").show();
                $("#{$fct}_choosen").hide("");
            {/foreach}
            {literal}


            search(event);
        });
        
        search( null );
        
        // Esporta i risultati su CSV
        $("#export_list").click(function(event){
            var spinner = '<i class="fa fa-spinner fa-spin"></i>';
            var original_html = $(this).html();
            $(this).html( $(this).html() +  spinner );
             class_attributes = "{/literal}{$export_attributes}{literal}";

            var csv_download = "https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id + "/CSV";
            csv_download        += '?' + $('#search_form').serialize();

            document.location.href = csv_download;

            $(this).html( original_html );
        });
    });

</script>
{/literal}