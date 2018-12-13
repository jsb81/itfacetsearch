<?php

/**
 * Contiene l'attributo di una classe configurata per la ricerca tramite itfacet_search
 */
class ITFacetSearchAttributePO extends eZPersistentObject
{
    const SEARCH_TYPE = 1;
    const TABLE_TYPE  = 2;
    const EXPORT_TYPE = 3;
    const IMPORT_TYPE = 4;
    
    static function definition()
    {
        return array( "fields" => array( 'id' => array( 'name' => 'ID',
                                                        'datatype' => 'integer',
                                                        'default' => 0,
                                                        'required' => true ),
                                         'facet_search_id'  => array( 'name'     => 'facet_search_id',
                                                                      'datatype' => 'integer',
                                                                      'default'  => 0,
                                                                      'required' => true ),
                                         'type'  => array( 'name'     => 'type',
                                                           'datatype' => 'integer',
                                                           'default'  => 0,
                                                           'required' => true ),
                                         'attribute_id'  => array( 'name'     => 'attribute_id',
                                                                   'datatype' => 'integer',
                                                                   'default'  => 0,
                                                                   'required' => true ),
                                         'attribute_label' => array( 'name' => 'attribute_label',
                                                                     'datatype' => 'text',                                                             
                                                                     'required' => true,                                                            
                                                                     'multiplicity' => '1..*' ),
                                         'attribute_datatype'  => array( 'name'     => 'attribute_datatype',
                                                                         'datatype' => 'integer',
                                                                         'default'  => 0,
                                                                         'required' => false ),
                                         'attribute_cols'  => array( 'name'  => 'attribute_cols',
                                                                     'datatype' => 'integer',
                                                                     'default'  => 0,
                                                                     'required' => false ),
                                         'attribute_identifier'  => array( 'name'  => 'attribute_identifier',
                                                                           'datatype' => 'text',
                                                                           'default'  => '',
                                                                           'required' => true ),
                                         'attribute_dependency'  => array( 'name'  => 'attribute_dependency',
                                                                     'datatype' => 'text',
                                                                     'default'  => 0,
                                                                     'required' => false ),
                                        'attribute_full_link'  => array( 'name'  => 'attribute_full_link',
                                                                         'datatype' => 'integer',
                                                                         'default'  => 0,
                                                                         'required' => false ),
                                        'sort_order'  => array( 'name'  => 'sort_order',
                                                                         'datatype' => 'integer',
                                                                         'default'  => 0,
                                                                         'required' => false )
                                        ),
                      "keys" => array( 'id' ),
                      "sort" => array( "id" => "asc" ),
                      "class_name" => "ITFacetSearchAttributePO",
                      "name" => "itfacet_search_attribute" );
    }
    
    /**
     * Creazione della configurazione per un attributo
     * 
     * @param type $facet_search_id
     * @param type $type
     * @param type $attribute_id
     * @param type $attribute_label
     * @param type $attribute_datatype
     * @param type $attribute_cols
     * @param type $attribute_dependency
     * @param type $attribute_full_link
     * @return \ITFacetSearchAttributePO
     */
    public static function create( $facet_search_id
                                 , $type
                                 , $attribute_id
                                 , $attribute_identifier
                                 , $attribute_label
                                 , $attribute_datatype
                                 , $attribute_cols
                                 , $attribute_dependency
                                 , $attribute_full_link
                                 , $sort_order = 0)
    {
        $itfacet_search_attribute = new ITFacetSearchAttributePO( array( 'facet_search_id' => $facet_search_id,
                                                                         'type' => $type,
                                                                         'attribute_id' => $attribute_id,
                                                                         'attribute_label' => $attribute_label,
                                                                         'attribute_datatype' => $attribute_datatype,
                                                                         'attribute_cols' => $attribute_cols,
                                                                         'attribute_identifier' => $attribute_identifier,
                                                                         'attribute_dependency' => $attribute_dependency,
                                                                         'attribute_full_link' => $attribute_full_link,
                                                                         'sort_order' => $sort_order) );
        return $itfacet_search_attribute;
    }
    
    /**
     * Cerca tutti gli attributi configurati per una classe
     * 
     * @param integer $contentclass_id
     * @return \ITFacetSearchAttributePO
     */
    public static function fetchByFacetSearchID( $facet_search_id, $filter = null )
    {
        $object = eZPersistentObject::fetchObjectList(
                self::definition(),
                $filter,
                array( 'facet_search_id' => $facet_search_id ),
                array( 'sort_order' => 'asc' )
            );
        
        return $object;
    }
    
    /**
     * Cerca un singolo attributo
     * 
     * @param integer $facet_search_id
     * @param integer $attribute_id
     * @param integer $attribute_type
     * @return \ITFacetSearchAttributePO
     */
    public static function fetchByAttributeID( $facet_search_id, $attribute_id, $attribute_type, $filter = null )
    {
        $object = eZPersistentObject::fetchObject(
                self::definition(),
                $filter,
                array( 'facet_search_id' => $facet_search_id
                     , 'attribute_id' => $attribute_id
                     , 'type' => $attribute_type)
            );
        
        return $object;
    }
    
    /**
     * Rimuove la configurazione di un attributo
     * 
     * @param integer $contentclass_id
     */
    public static function deleteByAttributeID( $facet_search_id, $attribute_id, $attribute_type )
    {
        $cond = array( 'facet_search_id' => $facet_search_id
                     , 'attribute_id' => $attribute_id
                     , 'type' => $attribute_type );
        
        eZPersistentObject::removeObject( self::definition(), $cond );
    }
}
