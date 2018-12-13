<?php

/**
 * Handler di Default per la gestione della ricerca di eventi
 *
 * @author Stefano Ziller
 */
class ITFacetSearchEventsHandler implements ITFacetSearch
{
    
    // ============================ CLASS VARIABLES ============================
    private $class_identifier; 
    private $parent_node_id;
    private $timestamp;
    private $days;
    
    private $facets;
    private $fetch_parameters;
    private $result;
    private $resultData;
    
    private $mese_eng_ita = array(
        'January'   => 'Gennaio',
        'February'  => 'Febbraio',
        'March'     => 'Marzo',
        'April'     => 'Aprile',
        'May'       => 'Maggio',
        'June'      => 'Giugno',
        'July'      => 'Luglio',
        'August'    => 'Agosto',
        'September' => 'Settembre',
        'October'   => 'Ottobre',
        'November'  => 'Novembre',
        'December'  => 'Dicembre'
    );
    
    private $weekday_eng_ita = array(
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mer',
        'Thu' => 'Gio',
        'Fri' => 'Ven',
        'Sat' => 'Sab',
        'Sun' => 'Dom'
    );
    
    // ============================ PRIVATE METHODS ============================
    
    
    // ============================ PUBLIC METHODS ============================


    /**
     *
     * @param type $class_identifier
     * @param type $parent_node_id
     * @param type $timestamp
     * @param type $days
     * @throws Exception
     */
    public function __construct($class_identifier, $parent_node_id, $timestamp, $days) 
    {
        $this->class_identifier = $class_identifier;
        $this->parent_node_id = $parent_node_id;
        $this->timestamp = $timestamp;
        $this->days = $days;
        
        // Controlli
        if(empty($this->class_identifier)){
            throw new Exception('You must set Class Identifier on URL');
        }
        if(empty($this->parent_node_id)){
            throw new Exception('You must set Parent Node ID on URL');
        }
        if(empty($this->timestamp)){
            throw new Exception('You must set Initial Timestamp on URL');
        }
        if(empty($this->days)){
            throw new Exception('You must set Days number on URL');
        }
        
        
    }

    /*/
     * @TODO: impostare faccette da estrarre
     */
    public function initFacets()
    {
        $this->facets = array();
    }
    
    /**
     * Imposta la query per la ricerca
     */
    public function initFetchParameters()
    {
        $query = "";
        
        //1976-03-06
        
        $__from = date ( 'Y-m-d', $this->timestamp );
        
        $filter = array('published:['. $__from . 'T00:00:000Z' . ' TO ' . $__from . 'T23:59:999Z' . '+' . $this->days . 'DAY]');
        
        $this->fetch_parameters = array(
            'query' => $query,
            'facet' => $this->facets,
            'filter' => array('filter' => $filter),
            'class_id' => array( $this->class_identifier ),
            'subtree_array' => array( $this->parent_node_id ),
            'sort_by' => array( 'published' => 'asc')
        );
    }
    
    /**
     * Esegui la ricerca e formatta l'array dei risultati
     */
    public function doSearch()
    {
        $this->result = eZFunctionHandler::execute('ezfind', 'search', $this->fetch_parameters);

        $searchResult = $this->result['SearchResult'];
        $this->resultData = array();
        
        
        $this->resultData['timestamp'] = $this->timestamp;
        $this->resultData['month'] = $this->mese_eng_ita[ date( 'F', $this->timestamp ) ] . " " . date( 'Y', $this->timestamp );
        
        $__days = array();
        
        for($i=0; $i<$this->days; $i++){
            $__timestamp = $this->timestamp + ($i * 86400);
            $__currentDay = date ( 'd', $__timestamp );
            $__currentMonth = strtolower( substr( $this->mese_eng_ita[  date ( 'F', $__timestamp ) ], 0, 3) );
            
            $__events = array();
            if( !empty($searchResult) ){
                foreach( $searchResult as $resultNode ){
                    $__eventDay = date( 'd', $resultNode->ContentObject->Published );

                    if($__eventDay == $__currentDay) {
                        $dataMap = $resultNode->dataMap();
                        
                        //$tplAttr = eZTemplate::factory();
                        //$tplAttr->setVariable( 'attribute', $dataMap['informazioni'] );
                        //$tplAttr->setVariable( 'is_facetsearch', TRUE );
                        //$tplAttr->setVariable( 'node_name', $resultNode->ContentObject->Name );
                        
                        //$__informazioni = $tplAttr->fetch('design:content/datatype/view/' . $dataMap['informazioni']->attribute( 'data_type_string' ) .'.tpl');
                        
                        $__events[] = array(
                            'contentobject_id' => $resultNode->ContentObject->ID,
                            'node_id' => $resultNode->MainNodeID,
                            'name' => $resultNode->ContentObject->Name
                            //'info' => $__informazioni
                        );
                    }
                }
            }
            
            $__days[] = array(
              'day' => $__currentDay,
              'date' => date('Y-m-d', $__timestamp),
              'weekday' => $this->weekday_eng_ita[ date ( 'D', $__timestamp ) ],
              'month' => $__currentMonth,
              'events' => $__events
            );
        }
        $this->resultData['days'] = $__days;
    }
    
    /**
     * Espone i risultati
     */
    public function outputResults()
    {
        $json_result = array(
            'data' => $this->resultData,
            // 'SearchResult' => $this->result['SearchResult'],
            'FetchParameters' => $this->fetch_parameters
        );

        echo json_encode($json_result);
    }
}