<?php

/*
 * Ricerca invocabile da remoto per l'importazione di contenuti
 */

$http = eZHTTPTool::instance();

$module = $Params['Module'];
// Classe su cui eseguire la ricerca
$class_identifier = $Params['Class'];
// Elenco degli attributi da usare per la ricerca
$class_attribute_identifiers = $Params['SearchAttributes'];
// Elenco degli attributi per cui estrarre le faccette
$attribute_identifiers = $Params['FacetAttributes'];
// Nodo contenitore in cui limitare la ricerca
$parent_node_id = $Params['ParentNodeID'];

try
{
    $ini = eZINI::instance( "facetsearch.ini" );
    $handlers = $ini->variable('FacetSearch', 'Handlers');
    $remoteHandler = $handlers['remote'];
    
    if( !empty($remoteHandler) ){
        
        $remoteSearch = new $remoteHandler(
                                                    $Params['Class'],
                                                    $Params['SearchAttributes'],
                                                    $Params['FacetAttributes'],
                                                    $Params['ParentNodeID'],
                
                                                    (array_key_exists( 'draw', $_GET )?$_GET['draw']:NULL),
                                                    (array_key_exists( 'start', $_GET )?$_GET['start']:NULL),
                                                    (array_key_exists( 'length', $_GET )?$_GET['length']:NULL),
                                                    (array_key_exists( 'order', $_GET )?$_GET['order']:NULL)
                                                );
        
        $remoteSearch->initFacets();
        
        $remoteSearch->initFetchParameters();
        
        $remoteSearch->doSearch();
        
        $remoteSearch->outputResults();
    }
    else{
        throw new Exception('Remote Datatable Handler not configured in facetsearch.ini');
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