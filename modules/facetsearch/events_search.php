<?php
/**
 * Estrae un elenco di eventi a partire dal timestamp passato 
 * per il numero di giorni indicato
 */

$http = eZHTTPTool::instance();

$module = $Params['Module'];
// Classe su cui eseguire la ricerca
$class_identifier = $Params['Class'];
// Nodo contenitore in cui limitare la ricerca
$parent_node_id = $Params['ParentNodeID'];
// Timestamp da cui iniziare la ricerca
$timestamp = $Params['Timestamp'];
// Numero di giorni da estrarre
$days = $Params['Days'];

header('Content-Type: application/json');

try{
    
    $ini = eZINI::instance( "facetsearch.ini" );
    $handlers = $ini->variable('FacetSearch', 'Handlers');
    $eventsHandler = $handlers['events'];
    
    if( !empty($eventsHandler) ){
        $eventsSearch = new $eventsHandler($class_identifier, $parent_node_id, $timestamp, $days);
        
        $eventsSearch->initFacets();
        
        $eventsSearch->initFetchParameters();
        
        $eventsSearch->doSearch();
        
        $eventsSearch->outputResults();
    }
    else{
        throw new Exception('Events Handler not configured in facetsearch.ini');
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

