<?php

/**
 * Esegue una ricerca tramite ezfind
 */

$http = eZHTTPTool::instance();

$module = $Params['Module'];
// Classi su cui eseguire la ricerca
$class_identifiers = $Params['Classes'];
// Elenco degli attributi per cui estrarre le faccette
$class_attribute_identifiers = $Params['ClassAttributes'];
// Elenco degli attributi per cui estrarre le faccette
$attribute_identifiers = $Params['FacetAttributes'];
// Nodo contenitore in cui limitare la ricerca
$parent_node_id = $Params['ParentNodeID'];
// Offset attuale
$offset =  $Params['Offset'];
// Limite risultati in una ricerca
$limit =  $Params['Limit'];

header('Content-Type: application/json');

try{
    
    $ini = eZINI::instance( "facetsearch.ini" );
    $handlers = $ini->variable('FacetSearch', 'Handlers');
    $baseHandler = $handlers['base'];
    
    if( !empty($baseHandler) ){
        $baseHandler = new $baseHandler(
            $class_identifiers,
            $class_attribute_identifiers,
            $attribute_identifiers,
            $parent_node_id,
            $offset,
            $limit
        );
        
        $baseHandler->initFacets();
        
        $baseHandler->initFetchParameters();
        
        $baseHandler->doSearch();
        
        $baseHandler->outputResults();
    }
    else{
        throw new Exception('Base Handler not configured in facetsearch.ini');
    }
    
} catch (Exception $e) {
    echo json_encode(
                        array( 
                                'Error' => $e->getMessage(),
                                'Line' => $e->getLine(),
                                'Trace' => $e->getTraceAsString()
                             )
                    );
}


eZExecution::cleanExit();
