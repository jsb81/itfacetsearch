<?php

$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();

$module = $Params['Module'];

$facet_search_id = $Params['FacetSearchID'];
$operation = $Params['Operation'];
$attribute_id = NULL;
$attribute_type = NULL;

if(array_key_exists('attribute_id', $_GET)){
    $attribute_id = $_GET['attribute_id'];
}

if(array_key_exists('attribute_type', $_GET)){
    $attribute_type = $_GET['attribute_type'];
}

try {
    if(empty($facet_search_id)){
        throw new Exception('Facet Search id not set');
    }
    
    if(empty($operation)){
        throw new Exception('Operation parameter not set');
    }
    
    $result = array();
    
    
    $db = eZDB::instance();
    $db->begin();
    
    
    switch($operation){
        case 'search':
            $result = ITFacetSearchAttributePO::fetchByFacetSearchID( $facet_search_id );
            break;
        
        case 'create':
            if( !array_key_exists('type', $_GET) ){
                throw new Exception('create Operation: type not set');
            }
            if( !array_key_exists('attribute_id', $_GET) ){
                throw new Exception('create Operation: attribute_id not set');
            }
            if( !array_key_exists('attribute_label', $_GET) ){
                throw new Exception('create Operation: attribute_label not set');
            }
            
            $new_attr = ITFacetSearchAttributePO::create( $facet_search_id
                                                      , (array_key_exists('type', $_GET)?$_GET['type']:null)
                                                      , (array_key_exists('attribute_id', $_GET)?$_GET['attribute_id']:null)
                                                      , (array_key_exists('attribute_identifier', $_GET)?$_GET['attribute_identifier']:null)
                                                      , (array_key_exists('attribute_label', $_GET)?$_GET['attribute_label']:null)
                                                      , (array_key_exists('attribute_datatype', $_GET)?$_GET['attribute_datatype']:null)
                                                      , (array_key_exists('attribute_cols', $_GET)?$_GET['attribute_cols']:null)
                                                      , (array_key_exists('attribute_dependency', $_GET)?$_GET['attribute_dependency']:null)
                                                      , (array_key_exists('attribute_full_link', $_GET)?$_GET['attribute_full_link']:null));
            
            $new_attr->store();
            
            
            $result = ITFacetSearchAttributePO::fetchByFacetSearchID( $facet_search_id );
            
            break;
        
        case 'delete':
            if(!empty($attribute_id)){
                ITFacetSearchAttributePO::deleteByAttributeID( $facet_search_id, $attribute_id, $attribute_type );
                
                $result = ITFacetSearchAttributePO::fetchByFacetSearchID( $facet_search_id );

                // $result = array('message' => 'configuration deleted');
            }
            else{
                throw new Exception('Attribute ID not set');
            }
            
            break;
        
        case 'edit':
            $object = ITFacetSearchAttributePO::fetchByAttributeID( $facet_search_id, $attribute_id, $attribute_type );
            
            if(array_key_exists('type', $_GET)){ $object->setAttribute( 'type', $_GET['type']); }
            if(array_key_exists('attribute_id', $_GET)){ $object->setAttribute( 'attribute_id', $_GET['attribute_id']); }
            if(array_key_exists('attribute_identifier', $_GET)){ $object->setAttribute( 'attribute_identifier', $_GET['attribute_identifier']); }
            if(array_key_exists('attribute_label', $_GET)){ $object->setAttribute( 'attribute_label', $_GET['attribute_label']); }
            if(array_key_exists('attribute_datatype', $_GET)){ $object->setAttribute( 'attribute_datatype', $_GET['attribute_datatype']); }
            if(array_key_exists('attribute_cols', $_GET)){ $object->setAttribute( 'attribute_cols', $_GET['attribute_cols']); }
            if(array_key_exists('attribute_dependency', $_GET)){ $object->setAttribute( 'attribute_dependency', $_GET['attribute_dependency']); }
            if(array_key_exists('attribute_full_link', $_GET)){ $object->setAttribute( 'attribute_full_link', $_GET['attribute_full_link']); }
            if(array_key_exists('sort_order', $_GET)){ $object->setAttribute( 'sort_order', $_GET['sort_order']); }
            
            $object->store();
            
            
            $result = ITFacetSearchAttributePO::fetchByFacetSearchID( $facet_search_id );
            
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
