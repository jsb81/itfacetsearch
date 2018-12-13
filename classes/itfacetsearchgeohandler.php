<?php

use IT\FacetSearch\ITFacetSearchCommon;

/**
 * Handler di Default per la gestione della ricerca per l'estrazione di un GeoJson
 *
 * @author Stefano Ziller
 */
class ITFacetSearchGeoHandler extends ITFacetSearchCommon implements ITFacetSearch 
{    
    // ============================ CLASS VARIABLES ============================
    
    // Constants
    const RESULTS_LIMIT = 10000;

    // Module Parameters
    private $class_identifier;
    private $attribute_identifiers;
    private $parent_node_id;
    private $locations_attribute;
    
    // Utility Variables
    private $search_attributes = NULL;
    
    // 
    private $result = NULL;
    private $json_result = '';
    
    // ============================ PRIVATE METHODS ============================
    
    private function addGeoJsonFeature( $resultNode, $gmapLocation )
    {
        $itemFeature = array();

        $itemFeature['id'] = $resultNode->ContentObject->ID;
        $geometry = array();
        $geometry['type'] = 'Point';
        $geometry['coordinates'] = array($gmapLocation->longitude, $gmapLocation->latitude);
        $itemFeature['geometry']=$geometry;
        $itemFeature['type']='Feature';
        $properties = array();
        $properties['id'] = $resultNode->MainNodeID;
        $properties['name'] = $resultNode->ContentObject->Name;
        //$properties['class_identifier'] = $this->class_identifier;
        // Recupera il 
        $objClassIdentifier = $resultNode->ContentObject->ClassIdentifier;
        $properties['class_identifier'] = $objClassIdentifier;
        $properties['geo'] = $gmapLocation->street;
        $itemFeature['properties']=$properties;

        $this->resultData[] = $itemFeature;
    }
    
    // ============================ PUBLIC METHODS ============================
    
    /**
     * Costruttore
     * 
     * @param string $class_identifier
     * @param string $attributes
     * @param integer $parent_node_id
     * @throws Exception
     */
    public function __construct($class_identifier, $attributes, $parent_node_id, $locations_attribute)
    {
        parent::__construct();

        $this->class_identifier = explode('|', $class_identifier);
        
        $this->attribute_identifiers = $attributes;
        $this->parent_node_id = $parent_node_id;
        $this->locations_attribute = $locations_attribute;
        
        if(empty($this->class_identifier)){
            throw new Exception('You must set Class Identifier on URL');
        }
        /*
        if(empty($this->attribute_identifiers)){
            throw new Exception('You must set Attribute Identifier on URL');
        }
         */
    }

    /**
     * Non sono necessarie faccette da estrarre per questa classe
     */
    public function initFacets()
    {
        if( !empty($this->attribute_identifiers) ){
            $this->search_attributes = explode('|', $this->attribute_identifiers);
        }
    }

    /**
     * Imposta i parametri per la ricerca
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
                }
                else if( !empty($this->search_attributes) && in_array($attribute, $this->search_attributes) ){
                    // Gestione del class_identifier come array
                    if (is_array ($this->class_identifier)){
                        
                        $or_filter = array('or');
                        
                        foreach ($this->class_identifier as $classidentifier ){                          
                            if (!empty($classidentifier) && strlen($classidentifier) > 0) {
                                if(strpos($attribute, 'extra')!==FALSE){
                                    $or_filter[] = $attribute . ':' . '"' .$value .'"';
                                }
                                else if( strpos($value, '[DateRange]') !== false ){
                                    $dateRange = substr($value , strlen( '[DateRange]' ) );

                                    $from = explode(' - ', $dateRange)[0];
                                    $to = explode(' - ', $dateRange)[1];

                                    $or_filter[] = $classidentifier . '/' . $attribute .':[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                                }
                                else{
                                    $or_filter[] = $classidentifier . '/' . $attribute . ':' . '"' .$value .'"';
                                }
                            }
                        }
                        $filter[] = $or_filter;
                    }
                    else if( strpos($value, '[DateRange]') !== false ){
                        $dateRange = substr($value , strlen( '[DateRange]' ) );

                        $from = explode(' - ', $dateRange)[0];
                        $to = explode(' - ', $dateRange)[1];

                        $filter[] = $this->class_identifier . '/' . $attribute .':[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                    }
                    else if(strpos($attribute, 'extra')!==FALSE){
                        $filter[] = $attribute . ':' . '"' .$value .'"';
                    }
                    else{
                        $filter[] = $this->class_identifier . '/' . $attribute . ':' . '"' .$value .'"';
                    }
                }                
                /* @TODO
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
                 * 
                 */
            }
        }

        $this->fetch_parameters = array(
            'query' => $query,
            'limit' => self::RESULTS_LIMIT,
            'class_id' => $this->class_identifier ,
            'subtree_array' => array($this->parent_node_id)
        );

        if( !empty($filter) ){
            $this->fetch_parameters['filter'] = array('filter' => $filter);
        }
    }
    
    /**
     * Esegue la ricerca con ezFind
     * 
     */
    public function doSearch()
    {
        $this->json_result = $this->getCachedJson();

        // echo '<pre>';
        // print_r( $this->json_result );
        // die();

        if( !$this->json_result ){
           
            $this->result = eZFunctionHandler::execute('ezfind', 'search', $this->fetch_parameters);

            $searchResult = $this->result['SearchResult'];
            
            $this->resultData = array();

            if( !empty($searchResult) ){
                foreach( $searchResult as $resultNode ){
                    $dataMap = $resultNode->dataMap();
                    
                    if(empty($this->locations_attribute)){
                        // Una sola Location

                        $gmapLocation = eZGmapLocation::fetch($dataMap['geo']->ID, $dataMap['geo']->Version);

                        if($gmapLocation != null){
                            $this->addGeoJsonFeature($resultNode, $gmapLocation);
                        }
                    }
                    else{
                        // Location relazionate multiple

                        $relatedObjects = eZFunctionHandler::execute(
                            'content',
                            'related_objects',
                            array(
                                 'object_id' => $resultNode->ContentObjectID,
                                 'attribute_identifier' => $this->class_identifier . '/' . $this->locations_attribute
                            )
                        );

                        foreach($relatedObjects as $relatedObject){
                            $relatedDataMap = $relatedObject->dataMap();

                            $gmapLocation = eZGmapLocation::fetch($relatedDataMap['geo']->ID, $relatedDataMap['geo']->Version);

                            if($gmapLocation != null){
                                $this->addGeoJsonFeature($resultNode, $gmapLocation);
                            }
                        }
                    }

                }
            }
        }
        
    }

    /**
     * GeoJson Output
     * 
     */
    public function outputResults()
    {
        if($this->json_result){
            header('Access-Control-Allow-Origin: *');
            header('Content-Type: application/json');

            // BugFix: non visualizza mappa su caricamento troppo veloce.
            sleep(1);

            echo $this->json_result;
        }
        else{
            $this->json_result = array(
                'type' => 'FeatureCollection',
                'features' => $this->resultData,
                'GET' => $_GET,
                'FetchParameters' => $this->fetch_parameters
            );
            $this->json_result = json_encode($this->json_result);
            
            $ini = eZINI::instance( "facetsearch.ini" );
            $cacheMinSearchCount = $ini->variable('FacetSearch', 'CacheMinSearchCount');

            // se il risultato dela ricerca è oltre il valore di $cacheMinSearchCount crea il file di cache
            if($this->result['SearchCount'] > $cacheMinSearchCount){
                $this->writeJsonCache($this->json_result);
            }

            header('Access-Control-Allow-Origin: *');
            header('Content-Type: application/json');
            echo $this->json_result;
        }
    }

}

