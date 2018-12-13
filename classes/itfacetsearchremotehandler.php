<?php

use IT\FacetSearch\ITFacetSearchCommon;

/**
 * Handler di Default per la gestione della ricerca da remoto su datatable
 *
 * @author Stefano Ziller
 */
class ITFacetSearchRemoteHandler extends ITFacetSearchCommon implements ITFacetSearch 
{
    // ============================ CLASS VARIABLES ============================
    
    // Module Parameters
    private $class_identifier;
    private $search_identifiers;
    private $facet_identifiers;
    private $parent_node_id;
    
    // Search Parameters
    private $draw;
    private $offset;
    private $limit;
    private $order;
    
    // Utility Variables
    private $search_identifiers_array;
    private $facet_identifiers_array;
    private $sort_by;
    private $parentNode;
    private $canEdit;
    private $facets;
    private $fetch_parameters;
    private $result;
    private $resultData;
    private $site_url;
    
    // ============================ PRIVATE METHODS ============================
    
    /**
     * Imposta l'orinamento per la ricerca.
     * 
     * Come convenzione se vengono impostati più criteri di ordinamento uso 
     * l'ordinamento per rilevanza.
     */
    private function initSortBy()
    {
        $this->sort_by = array();

        if( count($this->order) > 1 ){
            // Ordinamento per rilevanza (default)
        }
        else{
            $order_col = $this->order[0];
            if( isset($order_col) ){
                if( $order_col['column'] < count($this->search_identifiers_array) ){

                    if( $this->search_identifiers_array[$order_col['column']] === 'published' || $this->search_identifiers_array[$order_col['column']] === 'modified'){
                        $this->sort_by[ $this->search_identifiers_array[$order_col['column']] ] = $order_col['dir'];
                    }
                    else if ( substr($this->search_identifiers_array[$order_col['column']], 0, 1) === '$') {
                        // Do Nothing
                    }
                    else{
                        $this->sort_by[$this->class_identifier.'/'.$this->search_identifiers_array[$order_col['column']]] = $order_col['dir'];
                    }
                }
            }
        }
    }
    
    // ============================ PUBLIC METHODS ============================

    /**
     * Costruisce l'handler per la ricerca impostando le variabili
     *
     * @param String $class_identifier
     * @param String $search_identifiers // Attributi di ricerca
     * @param String $facet_identifiers // Faccette
     * @param String $parent_node_id
     * @param Integer $draw
     * @param Integer $offset
     * @param Integer $limit
     * @param String $order
     * @throws Exception
     */
    public function __construct(
        $class_identifier,
        $search_identifiers,
        $facet_identifiers,
        $parent_node_id,

        $draw,
        $offset,
        $limit,
        $order
    )
    {
        parent::__construct();

        $this->class_identifier = $class_identifier;
        $this->search_identifiers = $search_identifiers;
        $this->facet_identifiers = $facet_identifiers;
        $this->parent_node_id = $parent_node_id;

        $this->draw = $draw;
        $this->offset = $offset;
        $this->limit = $limit;
        $this->order = $order;
        
        // Controlli
        if(empty($this->class_identifier)){
            throw new Exception('You must set Class Identifier on URL');
        }
        if(empty($this->search_identifiers)){
            throw new Exception('You must set Search Attribute Identifiers on URL');
        }
        // if(empty($this->facet_identifiers)){
        //     throw new Exception('You must set Facet Attribute Identifiers on URL');
        // }
        if(empty($this->parent_node_id)){
            throw new Exception('You must set Parent Node ID on URL');
        }
        
        // Variabili di utilità
        $this->search_identifiers_array = explode('|', $search_identifiers);
        if(!empty($this->facet_identifiers)){ 
            $this->facet_identifiers_array = explode('|', $facet_identifiers);
        }
        $this->parentNode = eZContentObject::fetchByNodeID( $parent_node_id );
        $this->canEdit = $this->parentNode->canEdit();
        
        $this->initSortBy();
        
        // Indirizzo del sito attuale
        $ini = eZINI::instance( "site.ini" );
        $this->site_url = $ini->variable("SiteSettings", "SiteURL");
    }
    
    /**
     * Imposta le faccette da estrarre
     */
    public function initFacets() {
        $this->facets = array();
        foreach( $this->facet_identifiers_array as $key => $attribute_identifier ){
            $__ai = explode(';', $attribute_identifier);

            if(count($__ai) === 2){
                // Contiene anche il mincount
                $this->facets[] = array('field' => $this->class_identifier.'/'.$__ai[0],
                                  'limit' => 1000,
                                  'sort' => 'alpha',
                                  'mincount' => $__ai[1]);

                // tolgo il mincount da $facet_identifiers_array
                $this->facet_identifiers_array[$key] = $__ai[0];
            }
            else{
                // Mincount default a 0
                $this->facets[] = array('field' => $this->class_identifier.'/'.$attribute_identifier,
                                  'limit' => 1000,
                                  'sort' => 'alpha',
                                  'mincount' => 0);
            }
        }
    }
    
    /**
     * Imposta i parametri di ricerca
     */
    public function initFetchParameters() {
        // Imposta il filtro sulla ricerca
        $query = '';
        $filter = array();
        
        foreach($_GET as $attribute => $value){
            if( !empty($value) ){
                if($attribute === 'query'){
                    $query = $value;
                }
                else if( in_array($attribute, $this->search_identifiers_array) ){
                    if( strpos($value, '|') !== false ){
                        $filter_values = explode('|', $value);
                        
                        foreach( $filter_values as $filter_value ){
                            $filter[] = $this->class_identifier . '/' . $attribute . ':' . '"' .$filter_value .'"';
                        }
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
    
    
    public function doSearch() {
        $this->result = eZFunctionHandler::execute('ezfind', 'search', $this->fetch_parameters);

        $searchResult = $this->result['SearchResult'];
        $this->resultData = array();
        
        if( !empty($searchResult) ){
            foreach( $searchResult as $resultNode ){
                $dataMap = $resultNode->dataMap();
                
                $node_url = "https://" . $this->site_url . '/content/view/full/' . $resultNode->MainNodeID;

                $rowData = array();
                
                $attrValue  = '<a href="'.$node_url.'" target="_blank">';
                $attrValue .= $resultNode->ContentObject->Name;
                $attrValue .= '</a>';
                
                $rowData[] = $attrValue;
                
                // Pulsante azione
                
                $class_repository = $this->class_identifier;
                if($class_repository === 'comunicato'){$class_repository = 'comunicati';} // Workaround
                $import_url = "/repository/import/" . $class_repository . "/" . $resultNode->MainNodeID;
                $attrValue  = '<a class="Button Button--default Button--s" style="color: white !important;" href="'.$import_url.'">';
                $attrValue .= '<i class="mdi mdi-download"></i>';
                $attrValue .= 'Importa';
                $attrValue .= '</a>';
                
                $rowData[] = $attrValue;
                
                $this->resultData[] = $rowData;
            }
        }
    }

    public function outputResults() {
        $json_result = array(
            'draw' => $this->draw,
            'recordsTotal' => $this->result['SearchCount'],
            'recordsFiltered' => $this->result['SearchCount'],
            'data' => $this->resultData,
            'FacetFields' => $this->result['SearchExtras']->attribute('facet_fields'),
            'GET' => $_GET,
            'FetchParameters' => $this->fetch_parameters,
            'SearchAttributes' => $this->search_identifiers_array
        );

        header('Access-Control-Allow-Origin: *'); // unsafe
        header('Content-Type: application/json');
        echo json_encode($json_result);
    }

}



