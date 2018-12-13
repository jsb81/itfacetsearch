<?php

/**
 * Handler di Default per la gestione della ricerca su datatable
 *
 * @author Stefano Ziller
 */
class ITFacetSearchDatatableHandler implements ITFacetSearch
{
    
    // ============================ CLASS VARIABLES ============================
    
    // Constants
    const CSV_EXPORT_LIMIT = 10000;
    
    // Module Parameters
    protected $class_identifier;
    protected $class_attribute_identifiers;
    protected $attribute_identifiers;
    protected $parent_node_id;
    protected $export_format;
    protected $remote_search;
    
    // Search Parameters
    protected $draw;
    protected $offset;
    protected $limit;
    protected $order;
    
    // Utility Variables
    protected $class_attribute_identifiers_array;
    protected $sort_by;
    protected $search_attributes;
    protected $facets;
    protected $fetch_parameters;
    protected $parentNode;
    protected $canEdit;
    protected $result;
    protected $resultData;
    protected $query;
    
    protected $facet_search;
    protected $facet_search_attributes;
    
    // ============================ PRIVATE METHODS ============================
    
    /**
     * Imposta l'orinamento per la ricerca.
     * 
     * Come convenzione se vengono impostati più criteri di ordinamento uso 
     * l'ordinamento per rilevanza.
     */
    protected function initSortBy()
    {
        $this->sort_by = array();

        if( count($this->order) === 2 ){
            // Ordinamento per rilevanza (default)
        }
        else{
            $order_col = $this->order[0];
            if( isset($order_col) ){
                if( $order_col['column'] < count($this->class_attribute_identifiers_array) ){

                    if( $this->class_attribute_identifiers_array[$order_col['column']] === 'published' || $this->class_attribute_identifiers_array[$order_col['column']] === 'modified'){
                        $this->sort_by[ $this->class_attribute_identifiers_array[$order_col['column']] ] = $order_col['dir'];
                    }
                    else if ( substr($this->class_attribute_identifiers_array[$order_col['column']], 0, 1) === '$') {
                        // Do Nothing
                    }
                    else{
                        $this->sort_by[$this->class_identifier.'/'.$this->class_attribute_identifiers_array[$order_col['column']]] = $order_col['dir'];
                    }
                }
            }
        }
    }
    
    /**
     * Inizializza i persistent objects
     */
    protected function initFacetSearchAttributes()
    {
        $class_id = eZContentClass::classIDByIdentifier($this->class_identifier);
        $this->facet_search = ITFacetSearchPO::fetchByClassID($class_id);
        $this->facet_search_attributes = ITFacetSearchAttributePO::fetchByFacetSearchID($this->facet_search->ID);
    }
    
    // ============================ PUBLIC METHODS ============================
    
    /**
     * Costruisce l'handler per la ricerca impostando le variabili
     * 
     * @param String $class_identifier
     * @param String $class_attribute_identifiers
     * @param String $attribute_identifiers
     * @param String $parent_node_id
     * @param String $export_format
     * @param Integer $draw
     * @param Integer $offset
     * @param Integer $limit
     * @param String $order
     */
    public function __construct(
                                                    $class_identifier,
                                                    $class_attribute_identifiers,
                                                    $attribute_identifiers,
                                                    $parent_node_id,
                                                    $export_format,
                                                    $remote_search,
                                                    
                                                    $draw,
                                                    $offset,
                                                    $limit,
                                                    $order
                                                )
    {
        $this->class_identifier = $class_identifier;
        $this->class_attribute_identifiers = $class_attribute_identifiers;
        $this->attribute_identifiers = $attribute_identifiers;
        $this->parent_node_id = $parent_node_id;
        $this->export_format = $export_format;
        $this->remote_search = $remote_search;

        $this->draw = $draw;
        $this->offset = $offset;
        $this->limit = $limit;
        $this->order = $order;
        
        // Controlli
        if(empty($this->class_identifier)){
            throw new Exception('You must set Class Identifier on URL');
        }
        if(empty($this->class_attribute_identifiers)){
            throw new Exception('You must set Class Attribute Identifiers on URL');
        }
        if(empty($this->attribute_identifiers)){
            throw new Exception('You must set Facet Attribute Identifiers on URL');
        }
        if(empty($this->parent_node_id)){
            throw new Exception('You must set Parent Node ID on URL');
        }
        
        // Variabili di utilità
        $this->class_attribute_identifiers_array = explode('|', $class_attribute_identifiers);
        $this->parentNode = eZContentObject::fetchByNodeID( $parent_node_id );
        $this->canEdit = $this->parentNode->canEdit();
        
        // Limite export CSV
        if(!empty($export_format) && $export_format === 'CSV'){
            $this->limit = self::CSV_EXPORT_LIMIT;
        }
        
        $this->initSortBy();
        $this->initFacetSearchAttributes();
    }
    
    /**
     * Imposta le faccette da estrarre
     */
    public function initFacets()
    {
        $this->search_attributes = explode('|', $this->attribute_identifiers);
        
        $this->facets = array();
        foreach( $this->search_attributes as $key => $attribute_identifier ){
            $__ai = explode(';', $attribute_identifier);

            if(count($__ai) === 2){
                // Contiene anche il mincount
                $this->facets[] = array('field' => $this->class_identifier.'/'.$__ai[0],
                                  'limit' => 1000,
                                  'sort' => 'alpha',
                                  'mincount' => $__ai[1]);

                // tolgo il mincount da $search_attributes
                $this->search_attributes[$key] = $__ai[0];
            }
            else{
                // Mincount default a 0
                $field = $this->class_identifier.'/'.$attribute_identifier;
                if(strpos($attribute_identifier, 'extra')!==FALSE){
                    $field = $attribute_identifier;
                }

                $this->facets[] = array('field' => $field,
                                  'limit' => 1000,
                                  'sort' => 'alpha',
                                  'mincount' => 0);
            }
        }
       
        
    }
    
    /**
     * Imposta i filtri per la ricerca ed i parametri per la chiamata ad ezfind
     */
    public function initFetchParameters()
    {
        // Imposta il filtro sulla ricerca
        $query = '';
        $filter = array();
        foreach($_GET as $attribute => $value){
            if( !empty($value) ){
                if($attribute === 'query'){
                    $query = $value;
                    $this->query = $value;
                }
                else if( in_array($attribute, $this->search_attributes) ){
                    if( strpos($value, '|') !== false ){
                        $filter_values = explode('|', $value);
                        
                        foreach( $filter_values as $filter_value ){
                            $filter[] = $this->class_identifier . '/' . $attribute . ':' . '"' .$filter_value .'"';
                        }
                    }
                    else if(strpos($attribute, 'extra')!==FALSE){
                        $filter[] = $attribute . ':' . '"' .$value .'"';
                    }
                    else if( strpos($value, '[DateRange]') !== false ){
                        $dateRange = substr($value , strlen( '[DateRange]' ) );
                        
                        $from = explode(' - ', $dateRange)[0];
                        $to = explode(' - ', $dateRange)[1];
                        
                        $filter[] = $this->class_identifier . '/' . $attribute .':[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                    }
                    else{
                        $filter[] = $this->class_identifier . '/' . $attribute . ':' . '"' .$value .'"';
                    }
                }
                else if( $attribute === 'daterange_published' ){
                    $from = explode(' - ', $value)[0];
                    $to = explode(' - ', $value)[1];

                    $filter[] = 'published:[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                }
                else if( $attribute === 'daterange_modified' ){
                    $from = explode(' - ', $value)[0];
                    $to = explode(' - ', $value)[1];

                    $filter[] = 'modified:[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                }
                else if( $attribute === 'daterange' ){
                    
                    $dateRange = $value;
                    if( !empty($dateRange) ){
                        $__from = explode(' - ', $dateRange)[0];
                        $__to = explode(' - ', $dateRange)[1];
                        $and_filter = array('and');

                        $and_filter[] = $this->class_identifier . '/data_inizio:[* TO ' . $__to . 'T23:59:999Z' .']';
                        $and_filter[] = $this->class_identifier . '/data_fine:[' .  $__from . 'T00:00:000Z' . ' TO *]';

                        $or_filter = array('or');

                        $or_filter[] = $and_filter;
                        $or_filter[] = $this->class_identifier . '/data_inizio:[' .  $__from . 'T00:00:000Z' . ' TO ' . $__to . 'T23:59:999Z' .']';

                        $filter[] = $or_filter;
                    }
                }
            }
        }
        
        $this->fetch_parameters = array(
            'query' => $query,
            'facet' => $this->facets,
            'class_id' => array( $this->class_identifier ),
            'subtree_array' => array($this->parent_node_id)
        );

        if(!empty($this->offset)){
            $this->fetch_parameters['offset'] = $this->offset;
        }

        if(!empty($this->limit)){
            $this->fetch_parameters['limit'] = $this->limit;
        }

        if( !empty($filter) ){
            $this->fetch_parameters['filter'] = array('filter' => $filter);
        }

        if( !empty($this->sort_by) ){
            $this->fetch_parameters['sort_by'] = $this->sort_by;
        }

    }
    /**
     * Esegue la ricerca con ezFind
     * 
     * ATTRIBUTI FUNZIONE:
     *  - $CHILDS_COUNT$: Conta i figli dell'oggetto
     * 
     */
    public function doSearch()
    {
        $this->result = eZFunctionHandler::execute('ezfind', 'search', $this->fetch_parameters);

        $searchResult = $this->result['SearchResult'];
        $this->resultData = array();
        
        if( !empty($searchResult) ){
            foreach( $searchResult as $resultNode ){
                $dataMap = $resultNode->dataMap();
                $node_url = 'content/view/full/' . $resultNode->MainNodeID;

                $rowData = array();
                
                foreach($this->class_attribute_identifiers_array as $key => $class_attribute){
                    $attrValue='';
                    
                    $show_link = NULL;
                    foreach($this->facet_search_attributes as $attribute_config){
                        if($attribute_config->type === '2'){
                            if($class_attribute === $attribute_config->attribute_identifier){
                                if($attribute_config->attribute_full_link === '1'){
                                    $show_link=TRUE;
                                }
                                else if($attribute_config->attribute_full_link === '2'){
                                    $show_link=FALSE;
                                }
                            }
                        }
                    }
                    
                    
                    if( ($key === 0 && $show_link===NULL) || $show_link ){
                        
//                        if($this->class_identifier === 'scuola' || $this->class_identifier === 'istituto'){
//                            $tplAttr = eZTemplate::factory();
//                            $tplAttr->setVariable( 'node', $resultNode );
//                            $attrValue .= $tplAttr->fetch('design:parts/children/facetdatatable/sei_url.tpl');
//                        }
//                        else{
                            if(!empty($this->remote_search) && $this->remote_search === 'true'){

                                $attrValue = '<a href="https://' . $_SERVER['HTTP_HOST'] . '/' . $node_url . '" target="_blank">';
                            }
                            else {
                                $ini = eZINI::instance( "site.ini" );
                                $site_url = $ini->variable("SiteSettings", "SiteURL");
                                $attrValue = '<a href="https://' . $site_url . "/" .$node_url . '">';
                            }
//                        }
                    }
                    
                    if($class_attribute === 'published'){
                        $attrValue .= date('d/m/Y H:i', $resultNode->ContentObject->Published);
                    }
                    else if($class_attribute === 'modified'){
                        $attrValue .= date('d/m/Y H:i', $resultNode->ContentObject->Modified);
                    }
                    // FUNZIONI
                    else if($class_attribute === '$CHILDS_COUNT$'){
                        // Numero di figli
                        $attrValue .= $resultNode->ContentObject->mainNode()->childrenCount();
                    }
                    else if($class_attribute === '$PARENT_CHILD_NAME$'){
                        $resultNode->ParentNodeID;
                        $parent_object = eZContentObject::fetchByNodeID( $resultNode->ParentNodeID );
                        
                        // Nome del nodo padre concatenato con quello del nodo figlio
                        
                        $attrValue .= $parent_object->name() . ' - ' . $resultNode->ContentObject->name();
                    }
                    else if($class_attribute === '$PARENT_NAME$'){
                        $resultNode->ParentNodeID;
                        $parent_Node = eZContentObjectTreeNode::fetch( $resultNode->ParentNodeID );
                        
                        // Nome del nodo padre concatenato con quello del nodo figlio
                        $attrValue  = '<a href="/content/view/full/'.$parent_Node->MainNodeID.'">';
                        $attrValue .= $parent_Node->Name;
                        $attrValue .= '</a>';
                    }
                    else if($class_attribute === '$MODAL_GEO$'){
                        $tplAttr = eZTemplate::factory();
                        $tplAttr->setVariable( 'geo_item_attr', $dataMap['geo'] );
                        $attrValue .= $tplAttr->fetch('design:parts/children/facetdatatable/modal_geo.tpl');
                    }
                    else if($class_attribute === '$SEARCHED_CHILD$'){
                        $tplAttr = eZTemplate::factory();
                        $tplAttr->setVariable( 'children', $resultNode->children() );
                        $tplAttr->setVariable( 'query',  $this->query);
                        $attrValue .= $tplAttr->fetch('design:parts/children/facetdatatable/searched_child.tpl');
                    }
                    else if($class_attribute === '$DOWNLOAD_ATTACHED_FILE$'){
                        $tplAttr = eZTemplate::factory();
                        $tplAttr->setVariable( 'node', $resultNode );
                        $attrValue .= $tplAttr->fetch('design:parts/children/facetdatatable/download_attached_file.tpl');
                    }
                    else if($class_attribute === '$PRIORITY$'){
                        //$tplAttr = eZTemplate::factory();
                        //$tplAttr->setVariable( 'node', $resultNode );
                        //$attrValue .= $tplAttr->fetch('design:parts/children/facetdatatable/download_attached_file.tpl');

                        // $attrValue .= str_pad($resultNode->Priority, 6, '0', STR_PAD_LEFT);
                        $attrValue .= $resultNode->Priority;
                    }
                    //
                    else{
                        $tplAttr = eZTemplate::factory();
                        $tplAttr->setVariable( 'attribute', $dataMap[$class_attribute] );
                        $tplAttr->setVariable( 'is_facetsearch', TRUE );
                        $tplAttr->setVariable( 'node_name', $resultNode->ContentObject->Name );
                        
                        $attrValue .= $tplAttr->fetch('design:content/datatype/view/' . $dataMap[$class_attribute]->attribute( 'data_type_string' ) .'.tpl');
                    }
                    
                    if( ($key === 0 && $show_link===NULL) || $show_link ){
                        $attrValue .= '</a>';
                    }
                    
                    $rowData[] = $attrValue;
                    
                }
                
                $this->resultData[] = $rowData;
            }
        }
    }
    
    /**
     * Esporta i risultati in JSON o CSV
     */
    public function outputResults()
    {
        if(!empty($this->export_format) && $this->export_format === 'CSV'){
            // Esportazione in CSV
            header('Content-Type: text/csv; charset=utf-8');
            header('Content-Disposition: attachment; filename=risultati.csv');
            header("Pragma: no-cache");
            header("Expires: 0");
            $output = fopen('php://output', 'w');

            $searchResult = $this->result['SearchResult'];
            
            if( !empty($searchResult) ){
                fputcsv($output, $this->class_attribute_identifiers_array, ';');

                foreach( $searchResult as $resultNode ) {
                    $dataMap = $resultNode->dataMap();
                    
                    $rowData = array();

                    foreach($this->class_attribute_identifiers_array as $class_attribute){
                        if($class_attribute === 'published'){
                            $rowData[] = date('d/m/Y H:i', $resultNode->ContentObject->Published);
                        }
                        else if($class_attribute === 'modified'){
                            $rowData[] = date('d/m/Y H:i', $resultNode->ContentObject->Modified);
                        }
                        else{
                            if($dataMap[$class_attribute]->attribute( 'data_type_string' ) === 'ezstring'){
                                $rowData[] = $dataMap[$class_attribute]->DataText;
                            }
                            else{
                                $tplAttr = eZTemplate::factory();
                                $tplAttr->setVariable( 'attribute', $dataMap[$class_attribute] );
                                $tplAttr->setVariable( 'is_csvexport', TRUE );
                                $rowData[] = $tplAttr->fetch('design:content/datatype/view/' . $dataMap[$class_attribute]->attribute( 'data_type_string' ) .'.tpl');
                            }
                        }
                    }

                    fputcsv($output, $rowData, ';');
                }
                
            }
            fclose($output);
            // Fine CSV
        }
        else{
            $json_result = array(
                'draw' => $this->draw,
                'recordsTotal' => $this->result['SearchCount'],
                'recordsFiltered' => $this->result['SearchCount'],
                'data' => $this->resultData,
                'FacetFields' => $this->result['SearchExtras']->attribute('facet_fields'),
                'GET' => $_GET,
                'FetchParameters' => $this->fetch_parameters,
                'ClassAttributes' => $this->class_attribute_identifiers_array
            );

            header('Access-Control-Allow-Origin: *');
            header('Content-Type: application/json');
            echo json_encode($json_result);
        }
    }
}
