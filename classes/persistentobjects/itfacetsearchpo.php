<?php

/**
 * Contiene una classe configurata per la ricerca tramite itfacet_search
 */
class ITFacetSearchPO extends eZPersistentObject
{
    static function definition()
    {
        return array( "fields" => array( "id" => array( 'name' => 'ID',
                                                        'datatype' => 'integer',
                                                        'default' => 0,
                                                        'required' => true ),
                                         'contentclass_id'  => array( 'name'     => 'contentclass_id',
                                                                      'datatype' => 'integer',
                                                                      'default'  => 0,
                                                                      'required' => true ),
                                         'type'  => array( 'name'     => 'type',
                                                           'datatype' => 'integer',
                                                           'default'  => 0,
                                                           'required' => true ),
                                         'export' => array( 'name' => 'export',
                                                            'datatype' => 'boolean',
                                                            'default' => false,
                                                            'required' => false ),
                                         'single_res' => array( 'name' => 'single_res',
                                                                'datatype' => 'text',                                                             
                                                                'required' => false,                                                            
                                                                'multiplicity' => '1..*' ),
                                         'multiple_res' => array( 'name' => 'multiple_res',
                                                                  'datatype' => 'text',                                                             
                                                                  'required' => false,                                                            
                                                                  'multiplicity' => '1..*' ),
                                         'search_cols'  => array( 'name' => 'search_cols',
                                                                  'datatype' => 'integer',
                                                                  'default'  => 0,
                                                                  'required' => false ),
                                         'remote_site_import_url' => array( 'name' => 'remote_site_import_url',
                                                                'datatype' => 'text',                                                             
                                                                'required' => false,                                                            
                                                                'multiplicity' => '1..*' )
                                        ),
                      "keys" => array( 'id', 'contentclass_id' ),
                      "sort" => array( "id" => "asc" ),
                      "class_name" => "ITFacetSearchPO",
                      "name" => "itfacet_search" );
    }
    
    /**
     * Creazione della configurazione per una classe
     * 
     * @param integer $contentclass_id
     * @param integer $type
     * @param integer $export
     * @param string $single_res
     * @param string $multiple_res
     * @param string $search_cols
     * @param string $remote_site_import_url
     * 
     * @return \ITFacetSearchPO
     */
    public static function create( $contentclass_id, $type, $export, $single_res, $multiple_res, $search_cols, $remote_site_import_url )
    {
        $itfacet_search = new ITFacetSearchPO( array( 'contentclass_id' => $contentclass_id,
                                                      'type' => $type,
                                                      'export' => $export,
                                                      'single_res' => $single_res,
                                                      'multiple_res' => $multiple_res,
                                                      'search_cols' => $search_cols,
                                                      'remote_site_import_url' => $remote_site_import_url ) );
        return $itfacet_search;
    }
    
    /**
     * Cerca la configurazione di una classe
     * 
     * @param integer $contentclass_id
     * @return \ITFacetSearchPO
     */
    public static function fetchByClassID( $contentclass_id, $filter = null )
    {
        $object = eZPersistentObject::fetchObject(
                self::definition(),
                $filter,
                array( 'contentclass_id' => $contentclass_id )
            );
        
        return $object;
    }
    
    /**
     * Cerca tutte le configurazioni
     * 
     * @param integer $contentclass_id
     * @return \ITFacetSearchPO
     */
    public static function fetchAll( )
    {
        $objects = eZPersistentObject::fetchObjectList(
                self::definition()
            );
        
        return $objects;
    }
    
    /**
     * Rimuove la configurazione di una classe
     * 
     * @param integer $contentclass_id
     */
    public static function deleteByClassID( $contentclass_id )
    {
        $cond = array( 'contentclass_id' => $contentclass_id );
        eZPersistentObject::removeObject( self::definition(), $cond );
    }
}

