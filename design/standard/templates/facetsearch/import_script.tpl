{def $search_attributes = ''
     $facet_attributes = ''}
{foreach $facet_search_attributes as $search_attribute}
        {if $search_attribute.type|eq(4)}
            {if $search_attributes|eq('')}
                {set $search_attributes=$search_attribute.attribute_identifier}
            {else}
                {set $search_attributes=concat($search_attributes, '|', $search_attribute.attribute_identifier)}
            {/if}
            
            {if $search_attribute.attribute_datatype|eq(2)}
                {if $facet_attributes|eq('')}
                    {set $facet_attributes=$search_attribute.attribute_identifier}
                {else}
                    {set $facet_attributes=concat($facet_attributes, '|', $search_attribute.attribute_identifier)}
                {/if}
            {/if}
        {/if}
{/foreach}

{literal}
<script>
    var remoteSiteUrl = "{/literal}{$configured_facet_search.remote_site_import_url}{literal}";
    var class_identifier = "{/literal}{$class_identifier}{literal}";
    var search_attributes = "{/literal}{$search_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = 2;
    
    // Imposta le faccette per le select options
    function setSelectFacet( facet, item, selected_item_value ){
        
        item.html('<option value="">'+item.data("placeholder")+'</option>');

        if( facet !== null ){
            $.each(facet.countList, function( _label, _count ){
                var _disabled = false;
                if(_count === 0){
                    _disabled = true;
                }

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
    
    var dataTable = $("#result_table").DataTable({
        "processing": true,
        "serverSide": true,
        "bFilter": false,
        "ajax": {
            "type": "GET",
            "url": remoteSiteUrl+"/facetsearch/remote_search/" + class_identifier + "/" + search_attributes + "/" + facet_attributes + "/" + node_id,
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
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Italian.json"
        }
    });
    
    // Aggiorno le Faccette //
    $("#result_table").on('xhr.dt', function(e, settings, result, xhr){
        {/literal}
            {foreach $facet_attributes|explode('|') as $index => $fct}
                setSelectFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
            {/foreach}
        {literal}
    });
    
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
    
    $(document).ready(function(){
        
        // Ricarica lanciata su select //
        $("#search_form select").change(function(event){
            search(event);
        });
        
       // Reset di una faccetta //
       $(".search-choice-close").click(function(event){
            search(event);
       });
       
        $("#search_button").click(function(event){
            search(event);
        });
    });
</script>
{/literal}

{undef $search_attributes}