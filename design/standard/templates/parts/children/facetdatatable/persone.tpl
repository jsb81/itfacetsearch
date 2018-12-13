<div class="content-view-full class-{$node.class_identifier} row">
    
    <div id="loading" class="col_md-12 text-center">
        <i class="fa fa-spinner fa-spin fa-3x"></i>
    </div>
    
    <div id="numRows" class="pull-right">

    </div>
    
    <div class="row">
        
        <div id='search' class="col-md-12" style="display: none;">
            
            <form id="search_form">
                <div class="searchform" style="padding-top: 20px;">
                    <div class="row">
                        {include uri='design:facetdatatable/facetdt_query.tpl' cols=2 query_label='Ricerca libera'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='nome' attr_name='Nome'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='cognome' attr_name='Cognome'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='genere' attr_name='Genere'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='titolo' attr_name='Titolo'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='comune_residenza' attr_name='Comune'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='provincia_residenza' attr_name='Provincia'}
                        
                        <div class="form_group col-md-12">
                            <button type="button" id="reset_button" class="btn btn-success pull-right" style="display: none;">
                                Azzera Filtri
                            </button>
                        </div>
                        
                    </div> {* row *}
                </div>
                
            </form><!-- form -->
            
        </div> <!-- .col-md-12 -->
        
    </div> <!-- .row -->
    
    <div class="row">
        <div id='datatable' class="col-md-12" style="display: none;">
            <button id="export_list" class="btn btn-primary pull-right" role="button">
                Esporta Risultati
                <i class="fa fa-table"></i>
            </button>

            {* TABELLA *}
            <table class="table table-striped" id="datatable_content" width="100%">
                <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Genere</th>
                        <th>Data di nascita</th>
                        <th>Titolo</th>
                        <th>Via/piazza</th>
                        <th>Numero civico</th>
                        <th>Comune</th>
                        <th>Provincia</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
    
    
</div> <!-- .content-view-full -->


{include uri='design:facetdatatable/facetdt_script.tpl' 
         classes='persone'
         class_attributes='nome|cognome|genere|data_nascita|titolo|via_residenza|numero_civico_residenza|comune_residenza|provincia_residenza'
         facet_attributes='nome|cognome|genere|titolo|comune_residenza|provincia_residenza'
         single_result_count_name='persona trovata'
         multiple_result_count_name='persone trovate'
         export_attributes='nome|cognome|genere|data_nascita|titolo|via_residenza|numero_civico_residenza|comune_residenza|provincia_residenza'}