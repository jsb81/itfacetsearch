<?php

$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();

$module = $Params['Module'];

$class_id = $Params['ClassID'];
$operation = $Params['Operation'];

try {
    if(empty($class_id)){
        throw new Exception('Class id not set');
    }
    
    if(empty($operation)){
        throw new Exception('Operation parameter not set');
    }
    
    $result = array();
    
    
    $db = eZDB::instance();
    $db->begin();
    
    switch($operation){
        case 'search':
            $result = ITFacetSearchPO::fetchByClassID($class_id);
            
            break;
        case 'create':
            if( !array_key_exists('type', $_GET) ){
                throw new Exception('create Operation: type not set');
            }
            
            $result = ITFacetSearchPO::create(  $class_id, 
                                                (array_key_exists('type', $_GET)?$_GET['type']:null), 
                                                (array_key_exists('export', $_GET)?$_GET['export']:null), 
                                                (array_key_exists('single_res', $_GET)?$_GET['single_res']:null), 
                                                (array_key_exists('multiple_res', $_GET)?$_GET['multiple_res']:null), 
                                                (array_key_exists('search_cols', $_GET)?$_GET['search_cols']:null), 
                                                (array_key_exists('remote_site_import_url', $_GET)?$_GET['remote_site_import_url']:null));
            $result->store();
            
            break;
        case 'delete':
            ITFacetSearchPO::deleteByClassID($class_id);
            
            $result = array('message' => 'configuration deleted');
            
            break;
        case 'edit':
            $result = ITFacetSearchPO::fetchByClassID( $class_id );
            
            if(array_key_exists('type', $_GET)){ $result->setAttribute( 'type', $_GET['type']); }
            if(array_key_exists('export', $_GET)){ $result->setAttribute( 'export', $_GET['export']); }
            if(array_key_exists('single_res', $_GET)){ $result->setAttribute( 'single_res', $_GET['single_res']); }
            if(array_key_exists('multiple_res', $_GET)){ $result->setAttribute( 'multiple_res', $_GET['multiple_res']); }
            if(array_key_exists('search_cols', $_GET)){ $result->setAttribute( 'search_cols', $_GET['search_cols']); }
            if(array_key_exists('remote_site_import_url', $_GET)){ $result->setAttribute( 'remote_site_import_url', $_GET['remote_site_import_url']); }
            
            $result->store();
            
            break;
    }
    
    $db->commit();
    
    header('Content-Type: application/json');
    echo json_encode( $result );
    
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
