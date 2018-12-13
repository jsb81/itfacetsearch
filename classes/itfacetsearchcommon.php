<?php

namespace IT\FacetSearch;

use IT\PATBase\ITClass;
/**
 * 
 * Funzioni comuni per gli handler di ITFacetSearch
 * 
 */
class ITFacetSearchCommon extends ITClass
{
    public function __construct( $env = self::NON_TEST )
    {
        parent::__constructor( $env );
    }

    private function getCacheFileName()
    {
        $currentFile = preg_replace('/[^a-zA-Z0-9_.]/', '', $_SERVER['REQUEST_URI']);

        $eZUser = $this->checkEnv('eZUser');
        $currentUser = $eZUser::currentUser();

        $__currentSiteAccess = $GLOBALS['eZCurrentAccess']['name'];
        $__cacheFilePath = "var/" . $__currentSiteAccess . "/cache/itfacetsearch/";
        // Se non esiste la cartella la crea
        if( !file_exists ( $__cacheFilePath ) ){
            mkdir( $__cacheFilePath );
        }
        chmod($__cacheFilePath, 0777); 
        $__cacheFilePath = $__cacheFilePath . $currentFile . $currentUser->id() .".json";
        
        return $__cacheFilePath;
    }
    
    protected function getCachedJson($cacheTimeOut = 'CacheTimeout')
    {
        $returnJson = '';
        
        $__cacheFilePath = $this->getCacheFileName();
        $eZINI = $this->checkEnv('eZINI');
        $ini = $eZINI::instance( "facetsearch.ini" );
        $__cacheTimeout = $ini->variable('FacetSearch', $cacheTimeOut);
        // $__cacheTimeout = 1 * 24 * 60 * 60;
        
        $__cacheUsed = false;
        if( file_exists($__cacheFilePath) ){
            if( filemtime($__cacheFilePath) + $__cacheTimeout > time() ){
            $__cacheContent = file_get_contents($__cacheFilePath);
            if(!empty($__cacheContent)){
                $returnJson = $__cacheContent;
                $__cacheUsed = true;
                }
            }
        }
        
        return $returnJson;
    }
    
    protected function writeJsonCache($json)
    {
        // Scrivo il file dalla cache
        file_put_contents($this->getCacheFileName(), $json); 
    }
}

