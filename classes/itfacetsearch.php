<?php

/**
 *
 * @author Stefano Ziller
 */
interface ITFacetSearch {
    
    public function initFacets();
    
    public function initFetchParameters();
    
    public function doSearch();
    
    public function outputResults();
    
}
