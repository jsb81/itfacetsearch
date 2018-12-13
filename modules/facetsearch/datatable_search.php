<?php
/**
 * Esegue una ricerca utilizando ezfind e le faccette.
 */

$http = eZHTTPTool::instance();

$module = $Params['Module'];
// Classe su cui eseguire la ricerca
$class_identifier = $Params['Class'];
// Elenco degli attributi per cui estrarre le faccette
$class_attribute_identifiers = $Params['ClassAttributes'];
// Elenco degli attributi per cui estrarre le faccette
$attribute_identifiers = $Params['FacetAttributes'];
// Nodo contenitore in cui limitare la ricerca
$parent_node_id = $Params['ParentNodeID'];
// Parametro per esportare in CSV o altri formati
$export_format = $Params['ExportFormat'];
// Indica se è una ricerca eseguita su sito remoto
$remote_search = $Params['RemoteSearch'];

try
{
    $ini = eZINI::instance( "facetsearch.ini" );
    $handlers = $ini->variable('FacetSearch', 'Handlers');
    $datatableHandler = $handlers['datatable'];

    
    if( !empty($datatableHandler) ){
        
        $datatableSearch = new $datatableHandler(
                                                    $Params['Class'],
                                                    $Params['ClassAttributes'],
                                                    $Params['FacetAttributes'],
                                                    $Params['ParentNodeID'],
                                                    $Params['ExportFormat'],
                                                    $Params['RemoteSearch'],
                
                                                    (array_key_exists( 'draw', $_GET )?$_GET['draw']:NULL),
                                                    (array_key_exists( 'start', $_GET )?$_GET['start']:NULL),
                                                    (array_key_exists( 'length', $_GET )?$_GET['length']:NULL),
                                                    (array_key_exists( 'order', $_GET )?$_GET['order']:NULL)
                                                );
        
        $datatableSearch->initFacets();
        
        $datatableSearch->initFetchParameters();
        
        $datatableSearch->doSearch();
        
        $datatableSearch->outputResults();
        
    }
    else{
        throw new Exception('Datatable Handler not configured in facetsearch.ini');
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