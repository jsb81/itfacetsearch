<?php

/**
 * Classe per l'operatore di template
 * 
 * @author Ziller
 */
class FacetSearchOperators
{
    public $Operators;
    
    /** 
     * Nome dell'operatore
     * 
     * @param string $name
     */
    public function FacetSearchOperators( )
    {
        $this->Operators = array( 'itfacet_search'
                                , 'itfacet_search_attribute'
                                , 'itfacet_search_repositories'

                                , 'children_classes');
    }
    
    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }
    
    function namedParameterList()
    {
        return array(
            'itfacet_search' => array( 
                'contentclass_id' => array( 'type'     => 'int',	
                                            'required' => true )                
            ),
            'itfacet_search_attribute' => array( 
                'facet_search_id' => array( 'type'     => 'int',	
                                            'required' => true )                 
            ),
            'itfacet_search_repositories' => array( 
            ),
            'children_classes' => array(
                'node_id' => array( 'type'     => 'int',
                                    'required' => true )
            )
        );
    }
    
    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        switch ( $operatorName )
        {
            case 'itfacet_search':
            {
                $class_id = $namedParameters['contentclass_id'];
                $operatorValue = ITFacetSearchPO::fetchByClassID($class_id);
            } break;
        
            case 'itfacet_search_attribute':
                {
                    $facet_search_id = $namedParameters['facet_search_id'];
                    $operatorValue = ITFacetSearchAttributePO::fetchByFacetSearchID( $facet_search_id );
                }
                break;
            
            case 'itfacet_search_repositories':
                {
                    $configured_classes = ITFacetSearchPO::fetchAll();
                    $configured_repositories = array();
                    
                    foreach($configured_classes as $configured_class){
                        $remote_site_import_url =  $configured_class->attribute('remote_site_import_url');
                        
                        if( !empty($remote_site_import_url) ){
                            $facet_attributes = ITFacetSearchAttributePO::fetchByFacetSearchID( $configured_class->ID );
                            
                            foreach($facet_attributes as $facet_attribute){
                                if($facet_attribute->attribute('type') == ITFacetSearchAttributePO::IMPORT_TYPE){
                                    $configured_repositories[] = $configured_class;
                                    break;
                                }
                            }
                        }
                    }
                    
                    $operatorValue = $configured_repositories;
                }
                break;

            case 'children_classes':
                {
                    $node_id = $namedParameters['node_id'];
                    $treeNode = eZContentObjectTreeNode::fetch($node_id);
                    $children_classes = array();

                    foreach ($treeNode->children() as $child) {
                        $children_classes[] = $child->ContentObject->ClassIdentifier;
                    }

                    $operatorValue = array_unique($children_classes);

                }
                break;
        }
    }
    
}

