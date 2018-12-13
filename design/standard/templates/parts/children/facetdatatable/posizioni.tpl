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
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='numero_posizioni_aperte' attr_name='Posizioni aperte'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='data_fine_pubblicazione' attr_name='Fine pubblicazione'}

                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=2 attr_id='data_termine_presentazione_domanda' attr_name='Termine presentazione domanda'}

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
                        <th>Numero posizioni aperte</th>
                        <th>Data scadenza mandato</th>
                        <th>Fine pubblicazione</th>
                        <th>Termine presentazione domanda</th>
                        <th>Disposizione normativa</th>
                        <th>Note</th>
                        <th>Allegati</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
    
    
</div> <!-- .content-view-full -->


{include uri='design:facetdatatable/facetdt_script.tpl' 
         classes='posizioni'
         class_attributes='registro_cariche|numero_posizioni_aperte|data_scadenza_mandato|data_fine_pubblicazione|data_termine_presentazione_domanda|disposizione_normativa|note|allegati'
         facet_attributes='registro_cariche|numero_posizioni_aperte|data_fine_pubblicazione|data_termine_presentazione_domanda'
         single_result_count_name='posizione trovata'
         multiple_result_count_name='posizioni trovate'
         export_attributes='registro_cariche|numero_posizioni_aperte|data_scadenza_mandato|data_fine_pubblicazione|data_termine_presentazione_domanda|disposizione_normativa|note'}