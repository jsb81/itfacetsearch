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
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='registro_cariche' attr_name='Carica'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='persona' attr_name='Persona'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='durata_mandato' attr_name='Durata mandato'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='data_provvedimento' attr_name='Data provvedimento'}

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
                        <th>Carica</th>
                        <th>Persona</th>
                        <th>Data inizio</th>
                        <th>Data scadenza</th>
                        <th>Durata mandato</th>
                        <th>Disposizione normativa</th>
                        <th>Motivazione</th>
                        <th>Provvedimento</th>
                        <th>Data provvedimento</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
    
    
</div> <!-- .content-view-full -->


{include uri='design:facetdatatable/facetdt_script.tpl' 
         classes='mandati'
         class_attributes='registro_cariche|persona|data_inizio_mandato|data_scadenza_mandato|durata_mandato|disposizioni_normativa|motivo_disposizioni_normativa|provvedimento_nomina|data_provvedimento'
         facet_attributes='registro_cariche|persona|durata_mandato|data_provvedimento'
         single_result_count_name='mandato trovato'
         multiple_result_count_name='mandati trovati'
         export_attributes='registro_cariche|persona|data_inizio_mandato|data_scadenza_mandato|durata_mandato|disposizioni_normativa|motivo_disposizioni_normativa|provvedimento_nomina|data_provvedimento'}