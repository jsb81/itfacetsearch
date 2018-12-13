{def $extra_indexes=ezini('ExtraIndexes', 'index', 'facetsearch.ini')
     $first_extra_index = true()}

{literal}
<script>
    // MAPPINGS
    var _ATTR_TYPE = ['Null', 'Search', 'Table', 'Export', 'Import'];
    var _ATTR_DATATYPE = ['Null', 'Input', 'Select', 'Date', 'Tags', 'RadioButton', 'Checkbox'];
    
    var _EXTRA_INDEXES = [
        {/literal}
        {foreach $extra_indexes as $class_identifier => $extra_index}
            {if $first_extra_index}
                {set $first_extra_index = false()}
            {else}
                ,
            {/if}
            {literal}
                {
                    class_identifier : '{/literal}{$class_identifier}{literal}',
                    extra_index: '{/literal}{$extra_index}{literal}'
                }
            {/literal}
        {/foreach}
        {literal}
    ];
    
    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    
    // opzioni scelte
    var selected_class_id;
    
    var facetsearch_obj;
    var facetsearch_attributes;
    
    // Imposta gli attributi della classe selezionata
    function setClassAttributes( class_id, class_identifier ){
        contentClasseAttributes = $.ajax({
            "type": "GET",
            "url": "https://" + siteURL + "/openpa/classdefinition/" + class_id,
            "success": function( result ){
                
                // Reset
                $('#attribute_identifier option').remove();
                $('#attribute_identifier').append($('<option>', {
                    value: 0,
                    text: '{/literal}{'Attribute Identifier'|i18n('facetconfig')}{literal}'
                }));
                //
                
                var dataMap = result.DataMap[0];
                
                $.each(dataMap, function(attr, value){
                    $('#attribute_identifier').append($('<option>', {
                        value: value.ID,
                        text: attr
                    }));
                    
                });
                
                $('#attribute_identifier').append($('<option>', {
                    value: '',
                    text: '----------------------'
                }));
                
                // Aggiungo funzioni
                $('#attribute_identifier').append($('<option>', {
                    value: -1,
                    text: '$CHILDS_COUNT$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -2,
                    text: '$PARENT_CHILD_NAME$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -3,
                    text: '$CHILD_NAME$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -4,
                    text: '$MODAL_GEO$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -5,
                    text: '$SEARCHED_CHILD$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -6,
                    text: '$DOWNLOAD_ATTACHED_FILE$'
                }));
                $('#attribute_identifier').append($('<option>', {
                    value: -7,
                    text: '$PRIORITY$'
                }));
                
                $('#attribute_identifier').append($('<option>', {
                    value: '',
                    text: '----------------------'
                }));
                
                // Aggiungo indici solr
                var index_id = -100;
                $.each(_EXTRA_INDEXES, function(attr, value){
                    if(value.class_identifier === class_identifier){
                        $.each(value.extra_index.split(','), function(extra_attr, extra_value){
                            $('#attribute_identifier').append($('<option>', {
                                value: index_id,
                                text: extra_value
                            }));
                            
                            index_id = index_id-1;
                        });
                    }
                    
                });
                
            }
        });
    }
    
    // chiama modulo per la configurazione di una classe
    function facetSearchConfig( operation, class_id, parameters ){
        $.ajax({
            "type": "GET",
            "data": parameters,
            "url": "https://" + siteURL + "/facetsearch/facetsearch/" + class_id + "/" + operation,
            "success": function( result ){
                facetsearch_obj = result;
                
                if(result != null && result.message !== "configuration deleted"){
                    $('#view_type').val(facetsearch_obj.type);
                    $('#single_res').val(facetsearch_obj.single_res);
                    $('#multiple_res').val(facetsearch_obj.multiple_res);
                    $('#search_cols').val(facetsearch_obj.search_cols);
                    $('#remote_site_import_url').val(facetsearch_obj.remote_site_import_url);
                    
                    if(facetsearch_obj.export === 't'){
                        $('#export').attr('checked','checked');
                        $("label[for='export']").addClass('is-checked');
                    }
                    else{
                        $('#export').removeAttr('checked','');
                        $("label[for='export']").removeClass('is-checked');
                    }
                    
                    facetSearchAttributeConfig( 'search', facetsearch_obj.ID, null ); 
                    
                    $('.content-class-attributes').show();
                }
                else{
                    facetsearch_obj=null;
                    
                    $('#view_type').val(0);
                    $('#single_res').val('');
                    $('#multiple_res').val('');
                    $('#search_cols').val(0);
                    $('#remote_site_import_url_res').val('');
                    
                    $('#export').removeAttr('checked','');
                    $("label[for='export']").removeClass('is-checked');
                    
                    
                    facetSearchAttributeConfig( 'search', null, null ); 
                    
                    $('.content-class-attributes').hide();
                }
            }
        });
    }
    
    // chiama modulo per la configurazione di una classe
    function facetSearchAttributeConfig( operation, facetsearch_id, parameters ){
        if(facetsearch_id===null){
            $("#attributes_table tbody").empty();
        }
        else{
            $.ajax({
                "type": "GET",
                "data": parameters,
                "url": "https://" + siteURL + "/facetsearch/facetsearchattribute/" + facetsearch_id + "/" + operation,
                "success": function( result ){
                    facetsearch_attributes = result;
                    
                    // Reset dipendenze
                    $('#attribute_dependency option').remove();
                    $('#attribute_dependency').append($('<option>', {
                        value: 0,
                        text: '{/literal}{'Attribute dependency'|i18n('facetconfig')}{literal}'
                    }));
                    //
                    
                    if(result !== null && (result.length > 0 || result.message !== "configuration deleted")){
                        var data = [];

                        $.each(facetsearch_attributes, function(i,v){
                            data.push(
                                [
                                    v.sort_order,
                                    v.attribute_identifier,
                                    (v.attribute_dependency!=='0'?v.attribute_dependency:'Nessuna'),
                                    v.attribute_label,
                                    _ATTR_TYPE[v.type],
                                    _ATTR_DATATYPE[v.attribute_datatype],
                                    v.attribute_cols,
                                    '<div style="white-space: nowrap">' +
                                    '<button data-facetid="'+facetsearch_id+'" data-attrid="'+v.attribute_id+'" data-attrtype="'+v.type+'" type="button" class="Button Button--danger u-text-xs rem_attribute">'+
                                    '    <i class="mdi mdi-delete"></i>'+
                                    '</button>' +
                                    '<button data-facetid="'+facetsearch_id+'" data-attrid="'+v.attribute_id+'" data-attrtype="'+v.type+'" data-sortorder="'+v.sort_order+'" type="button" class="Button Button--info u-text-xs up_attribute">'+
                                    '    <i class="mdi mdi-arrow-up"></i>'+
                                    '</button>' +
                                    '<button data-facetid="'+facetsearch_id+'" data-attrid="'+v.attribute_id+'" data-attrtype="'+v.type+'" data-sortorder="'+v.sort_order+'" type="button" class="Button Button--info u-text-xs down_attribute">'+
                                    '    <i class="mdi mdi-arrow-down"></i>'+
                                    '</button>' +
                                    '</div>'
                                ]
                            );
                            
                            // Aggiungo dipendenze
                            if(v.type === "1"){
                                $('#attribute_dependency').append($('<option>', {
                                    value: v.attribute_identifier,
                                    text: v.attribute_identifier
                                }));
                            }
                        });
                        
                        $('#attributes_table').dataTable().fnDestroy();
                    
                        $('#attributes_table').DataTable(
                            {
                                bFilter: false,
                                lengthChange: false,
                                // responsive: true,
                                bPaginate: false,
                                data: data,
                                language: {
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
                                        sPrevious: "<<",
                                        sNext: ">>",
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
                                createdRow: function ( row, data, dataIndex ) {
                                    if( data[4].toUpperCase() === 'SEARCH' ){
                                        $(row).addClass( 'u-background-compl-5' );
                                    }
                                    else if( data[4].toUpperCase() === 'EXPORT' ){
                                        $(row).addClass( 'u-background-compl' );
                                    }
                                    else if( data[4].toUpperCase() === 'IMPORT' ){
                                        $(row).addClass( 'u-background-10' );
                                    }
                                }
                            }
                        );
                    }
                    else{
                        $('#attributes_table').dataTable().fnDestroy();
                    }
                    
                    remAttributeAction();
                    sortAttributeAction();
                }
            });
            
            
        }
    }
    
    // Chiamata quando viene scelta una classe
    function contentClassChoosen( class_id, class_identifier ){
        setClassAttributes( class_id, class_identifier );
        facetSearchConfig( 'search', class_id, null );
    }
    
    $(document).ready(function(){
        
        // Nasconde elementi non inizializzati
        $('.content-class-properties').hide();
        $('.content-class-attributes').hide();
        
        $('#attribute_datatype').hide();
        $('#attribute_cols').hide();
        $('#attribute_dependency').hide();
        $('#attribute_full_link').hide();
        
        
        // Carica le classi di contenuto
        contentClassesSearch = $.ajax({
            "type": "GET",
            "url": "https://"+siteURL+"/itclassmanager/classlist/",
            "success": function( result ){
                
                $.each(result, function(i,v){
                    
                    if(v.NameList.NameList['ita-IT']){
                        $('#content_classes').append($('<option>', {
                            value: v.ID,
                            text: v.NameList.NameList['ita-IT'] + ' (' + v.Identifier +')'
                        }).data('identifier', v.Identifier) );
                    }
                });
            }
        });
        
        // Selezione di una classe di contenuto
        $('#content_classes').change(function(event){
            selected_class_id = $("#content_classes").val();
            selected_class_identifier = $(this).find("option:selected").data('identifier');
            
            if(selected_class_id !== "0"){
                contentClassChoosen( selected_class_id, selected_class_identifier );
                $('.content-class-properties').show();
            }
            else{
                $('.content-class-properties').hide();
            }
        });
        
        // Salvataggio di una configurazione
        $("#save_class_properties").click(function(){
            if(facetsearch_obj === null){
                facetSearchConfig( 'create'
                                 , selected_class_id
                                 , {
                                     'type' : $("#view_type").val(),
                                     'export' : $("label[for='export']").hasClass('is-checked'),
                                     'single_res' : $("#single_res").val(),
                                     'multiple_res' : $("#multiple_res").val(),
                                     'search_cols' : $("#search_cols").val(),
                                     'remote_site_import_url' : $("#remote_site_import_url").val()
                                   });
            }
            else{
                facetSearchConfig( 'edit'
                                 , selected_class_id
                                 , {
                                     'type' : $("#view_type").val(),
                                     'export' : $("label[for='export']").hasClass('is-checked'),
                                     'single_res' : $("#single_res").val(),
                                     'multiple_res' : $("#multiple_res").val(),
                                     'search_cols' : $("#search_cols").val(),
                                     'remote_site_import_url' : $("#remote_site_import_url").val()
                                   });
            }
        });
        
        
        // Eliminazione di una configurazione
        $("#delete_class_properties").click(function(){
            if(facetsearch_obj !== null){
                facetSearchConfig( 'delete', selected_class_id, null );
            }
        });
        
        // Selezione di un tipo di attributo
        $('#attribute_type').change(function(){
            console.log($("#attribute_type").val());
            
            if( $("#attribute_type").val() === "1"){
                $('#attribute_datatype').show();
                $('#attribute_cols').show();
                $('#attribute_dependency').show();
                $('#attribute_full_link').hide();
                $('#attribute_full_link').val(0);
            }
            else if ( $("#attribute_type").val() === "2" ){
                $('#attribute_full_link').show();
            }
            else if ( $("#attribute_type").val() === "3" ){
                $('#attribute_datatype').hide();
                $('#attribute_datatype').val(0);
                $('#attribute_cols').hide();
                $('#attribute_cols').val(0);
                $('#attribute_dependency').hide();
                $('#attribute_dependency').val(0);
                $('#attribute_full_link').hide();
                $('#attribute_full_link').val(0);
            }
            else if ( $("#attribute_type").val() === "4" ){
                $('#attribute_datatype').show();
                $('#attribute_cols').hide();
                $('#attribute_cols').val(0);
                $('#attribute_dependency').hide();
                $('#attribute_dependency').val(0);
            }
            else{
                $('#attribute_datatype').hide();
                $('#attribute_datatype').val(0);
                $('#attribute_cols').hide();
                $('#attribute_cols').val(0);
                $('#attribute_dependency').hide();
                $('#attribute_dependency').val(0);
                $('#attribute_full_link').hide();
                $('#attribute_full_link').val(0);
            }
        });
        
        // Aggiunta di una configurazione per un attributo
        $('#add_attribute').click(function(){
            if(facetsearch_obj !== null){
                
                facetSearchAttributeConfig( 'create'
                                           , facetsearch_obj.ID
                                           , {
                                                type: $('#attribute_type').val(),
                                                attribute_id: $('#attribute_identifier').val(),
                                                attribute_identifier: $('#attribute_identifier option:selected').html(),
                                                attribute_label: $('#attribute_label').val(),
                                                attribute_datatype: $('#attribute_datatype').val(),
                                                attribute_cols: $('#attribute_cols').val(), 
                                                attribute_dependency: $('#attribute_dependency').val(), 
                                                attribute_full_link: $('#attribute_full_link').val()
                                            });
            }
        });
    });
    
    function remAttributeAction(){
        // Rimozione di una configurazione per un attributo
        
        $('.rem_attribute').click(function(){
            
            facetSearchAttributeConfig( 'delete'
                                      , $(this).data('facetid')
                                      , {
                                            attribute_id: $(this).data('attrid'),
                                            attribute_type: $(this).data('attrtype')
                                        } 
                                      );
        });
    }
    
    function sortAttributeAction(){
        // UP
        $('.up_attribute').click(function(){
            let sort_order =  Number($(this).data('sortorder')) - 1;
            
            facetSearchAttributeConfig( 'edit'
                                      , $(this).data('facetid')
                                      , {
                                            attribute_id: $(this).data('attrid'),
                                            attribute_type: $(this).data('attrtype'),
                                            sort_order: sort_order
                                        } 
                                      );
        });
        
        // DOWN
        $('.down_attribute').click(function(){
            let sort_order = Number($(this).data('sortorder')) + 1;
            
            facetSearchAttributeConfig( 'edit'
                                      , $(this).data('facetid')
                                      , {
                                            attribute_id: $(this).data('attrid'),
                                            attribute_type: $(this).data('attrtype'),
                                            sort_order: sort_order
                                        } 
                                      );
        });
    }
</script>
{/literal}