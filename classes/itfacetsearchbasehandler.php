<?php

use IT\FacetSearch\ITFacetSearchCommon;

class ITFacetSearchBaseHandler extends ITFacetSearchCommon implements ITFacetSearch
{
    private $class_identifiers;
    private $class_attribute_identifiers;
    private $facet_attribute_identifiers;
    private $parent_node_id;

    private $class_identifiers_array;
    private $class_attribute_identifiers_array;
    private $parentNode;
    private $canEdit;
    private $facets;
    private $fetch_parameters;
    private $result;
    private $resultData;
    private $offset;
    private $limit;
    private $sort_by;

    private $paging;

    private $json_result;

    // ============================ PRIVATE METHODS ============================
    private function generatePaging() {
        $this->paging = array();

        $recordsTotal = $this->result['SearchCount'];
        $step = $this->limit;

        // Array di paginazione completo
        $prev = $this->offset - $step;
        $this->paging[] = array('label' => 'Previous', 'offset' => $prev, 'status' => ($prev >= 0?'enabled':'disabled'));

        $index = 0;
        while($index * $step <= $recordsTotal) {
            $status = 'enabled';
            if($index * $step == $this->offset){
                $status = 'selected';
            }

            $this->paging[] = array('label' =>  $index+1, 'offset' => $index * $step, 'status' => $status);

            $index++;
        }

        $next = $this->offset + $step;
        $this->paging[] = array('label' => 'Next', 'offset' => $next, 'status' => ($next <= $recordsTotal?'enabled':'disabled'));
    }


    private function getSortArray()
    {
        $nodeSortArray = $this->parentNode->mainNode()->sortArray();
        $sortArray = array('published' => 'desc');
        $order = ['desc', 'asc'];

        if(array_key_exists(0, $nodeSortArray) && array_key_exists(0, $nodeSortArray[0])) {

            switch($nodeSortArray[0][0]){
                case 'name':
                    $sortArray = array('name' => $order[ $nodeSortArray[0][1] ]);
                    break;
                case 'published':
                    $sortArray = array('published' => $order[ $nodeSortArray[0][1] ]);
                    break;
                case 'modified':
                    $sortArray = array('modified' => $order[ $nodeSortArray[0][1] ]);
                    break;
                case 'class_name':
                    $sortArray = array('class_name' => $order[ $nodeSortArray[0][1] ]);
                    break;
                case 'section':
                    $sortArray = array('section_id' => $order[ $nodeSortArray[0][1] ]);
                    break;
                case 'path':
                    $sortArray = array('path' => $order[ $nodeSortArray[0][1] ]);
                    break;
            }
        }

        return $sortArray;
    }


    // ============================ PUBLIC METHODS ============================
    public function __construct(
        $class_identifiers,
        $class_attribute_identifiers,
        $facet_attribute_identifiers,
        $parent_node_id,

        $offset,
        $limit
    )
    {
        parent::__construct();

        $this->class_identifiers = $class_identifiers;
        $this->class_attribute_identifiers = $class_attribute_identifiers;
        $this->facet_attribute_identifiers = $facet_attribute_identifiers;
        $this->parent_node_id = $parent_node_id;

        $this->offset = $offset;
        $this->limit = $limit;

        // Controlli
        if(empty($this->class_identifiers)){
            throw new Exception('You must set Class Identifieres on URL');
        }
        if(empty($this->parent_node_id)){
            throw new Exception('You must set Parent Node ID on URL');
        }

        // Variabili di utilità
        $this->class_identifiers_array = explode('|', $class_identifiers);
        $this->class_attribute_identifiers_array = explode('|', $class_attribute_identifiers);
        $this->parentNode = eZContentObject::fetchByNodeID( $parent_node_id );
        $this->canEdit = $this->parentNode->canEdit();

        // Carica ordinamento configurato nel nodo
        $this->sort_by = $this->getSortArray();
    }

    public function initFacets()
    {
        // TODO: Implement initFacets() method.
    }

    public function initFetchParameters()
    {
        $query = '';
        $filter = array();
        foreach($_GET as $attribute => $value) {
            if (!empty($value)) {
                if ($attribute === 'query') {
                    $query = $value;
                    $this->query = $value;
                }
                else if( $attribute === 'daterange_published' ){
                    $from = explode(' - ', $value)[0];
                    $to = explode(' - ', $value)[1];

                    $filter[] = 'published:[' .  $from . 'T00:00:000Z' . ' TO ' . $to . 'T23:59:999Z' .']';
                }

                // TODO: finire implementazione dei filtri di ricerca
            }
        }


        $this->fetch_parameters = array(
            'query' => $query,
            'class_id' => $this->class_identifiers_array,
            'subtree_array' => array($this->parent_node_id)
        );

        if(!empty($this->facets)) {
            $this->fetch_parameters['facet'] = $this->facets;
        }
        
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

    public function doSearch()
    {
        $this->json_result = $this->getCachedJson('CachePanelTimeout');

        if( !$this->json_result ) {
            $this->result = eZFunctionHandler::execute('ezfind', 'search', $this->fetch_parameters);

            $searchResult = $this->result['SearchResult'];
            $this->resultData = array();
            $view = 'panel'; // TODO: Rendere parametrico

            if (!empty($searchResult)) {
                foreach ($searchResult as $key => $resultNode) {
                    $tplNode = eZTemplate::factory();
                    $tplNode->setVariable('node', $resultNode);
                    $tplNode->setVariable('is_facetsearch', TRUE);
                    $tplNode->setVariable('index', $key);
                    $nodeValue = $tplNode->fetch('design:node/view/' . $view . '.tpl');

                    $this->resultData[] = $nodeValue;
                }

                $this->generatePaging();
            }
        }
    }

    public function outputResults()
    {
        if( empty($this->json_result) ) {
            $this->json_result = array(
                'recordsTotal' => $this->result['SearchCount'],
                'recordsFiltered' => $this->result['SearchCount'],
                'data' => $this->resultData,
                'paging' => $this->paging,
                'FacetFields' => $this->result['SearchExtras']->attribute('facet_fields'),
                'GET' => $_GET,
                'FetchParameters' => $this->fetch_parameters,
                'ClassAttributes' => $this->class_attribute_identifiers_array
            );
            $this->json_result = json_encode($this->json_result);

            $ini = eZINI::instance( "facetsearch.ini" );
            $cacheMinSearchCount = $ini->variable('FacetSearch', 'CachePanelMinSearchCount');

            // se il risultato dela ricerca è oltre il valore di $cacheMinSearchCount crea il file di cache
            if($this->result['SearchCount'] > $cacheMinSearchCount){
                $this->writeJsonCache($this->json_result);
            }
        }


        // header('Access-Control-Allow-Origin: *');
        header('Content-Type: application/json');

        echo $this->json_result;
    }

}