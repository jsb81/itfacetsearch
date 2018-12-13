<?php

/**
 * Esegue una ricerca su vivoscuola utilizando ezfind e ritorna il geojson
 */

$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();

$module = $Params['Module'];
// Classe su cui eseguire la ricerca
$class_identifier = $Params['Class'];
// Elenco degli attributi su cui eseguire la ricerca
$attribute_identifiers = $Params['Attributes'];
// Nodo contenitore in cui limitare la ricerca
$parent_node_id = $Params['ParentNodeID'];

// Se valorizzato indica che la localizzazione sta in un attributo di relazione (multipla)
$locations_attribute = $Params['LocationsAttribute'];

try {
    $ini = eZINI::instance( "facetsearch.ini" );
    $handlers = $ini->variable('FacetSearch', 'Handlers');
    $geoHandler = $handlers['geo'];
    
    if( !empty($geoHandler) ){
        $geoSearch = new $geoHandler(
                                        $Params['Class'],
                                        $Params['Attributes'],
                                        $Params['ParentNodeID'],
                                        $Params['LocationsAttribute']
                                    );
        
        $geoSearch->initFacets();
        
        $geoSearch->initFetchParameters();
        
        $geoSearch->doSearch();
        
        $geoSearch->outputResults();
    }
    else{
        throw new Exception('Geo Handler not configured in facetsearch.ini');
    }
    
} catch (Exception $e) {
    
    header('Content-Type: application/json');
    echo json_encode(
                        array( 
                                'Error' => $e->getMessage(),
                                'Line' => $e->getLine(),
                                'Trace' => $e->getTraceAsString()
                             )
                    );
}

eZExecution::cleanExit();