<div class="u-facet">
    
    <div class="u-facet-title">
        <div class="Grid">
            <div class="u-facet-heading">
                <h1>{$node.name|wash()}</h1>
            </div>
            <div id="numRows" class="u-facet-result-count">
                
            </div>
        </div>
    </div>
    
    <div id="loading" class="Grid-cell u-textCenter">
        <i class="fa fa-spin fa-circle-o-notch fa-3x"></i>
    </div>
    
    <div id="search" class="u-facet-form" style="display: none;">

        <form id="search_form" class="Form">

            <div class="Grid">
                        
                {include uri='design:facetdatatable/facetdt_query.tpl' cell='u-facet-form-cell-half' query_label=concat('Search'|i18n('designitalia'),'...')}

                {include uri='design:facetdatatable/facetdt_select.tpl' cell='u-facet-form-cell-half' attr_id='xscuola' attr_name='Tutte le scuole'}
                
                {include uri='design:facetdatatable/facetdt_select.tpl' cell='u-facet-form-cell-half' attr_id='xclasse' attr_name='Tutte le classi'}
                
                {include uri='design:facetdatatable/facetdt_select.tpl' cell='u-facet-form-cell-half' attr_id='xtpposto' attr_name='Tutti i posti'}

                <div class="u-facet-form-cell-half">
                    <label for="show">{'Show'|i18n('designitalia/full')}</label>
                    
                    <select class="Form-input Form-input-inline u-text-r-s u-border-none" 
                            id="show" 
                            name="show">
                        <option value="10" selected>10</option>
                        <option value="25">25</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                </div>
                
                <div class="u-facet-form-cell-half">
                    <a id="reset_button" class="pull-right" style="cursor: pointer;">
                        {'Reset Filters'|i18n('designitalia/full')}
                    </a>
                </div>
                        
            </div> <!-- .Grid -->
            
        </form> <!-- .Form -->
                            
    </div> <!-- .u-facet-form -->
        
    
    <div class="u-facet-table" id="datatable" style="display: none;">
        <table class="Table Table--striped Table--responsive" id="datatable_content" width="100%">
            <thead>
                <tr>
                    <th>{'School'|i18n('designitalia/full')}</th>
                    <th>Classe</th>
                    <th>Posto</th>
                    <th>Inizio</th>
                    <th>Fine</th>
                    <th>Ore</th>
                    
                </tr>
            </thead>
        </table>
    </div>
    
</div> <!-- .u-facet -->


{include uri='design:facetdatatable/facetdt_script.tpl' 
         classes='posto'
         class_attributes='xscuola|xclasse|xtpposto|diposto|dfposto|ore'
         facet_attributes='xscuola|xclasse|xtpposto'
         single_result_count_name='posto trovato'
         multiple_result_count_name='posti trovati'}