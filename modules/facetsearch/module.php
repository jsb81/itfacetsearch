<?php

$Module = array( 'name' => 'facetsearch' );

$ViewList = array();

$ViewList['datatable_search'] = array(
    'script'			=>      'datatable_search.php',
    'params'			=> 	array('Class', 'ClassAttributes', 'FacetAttributes', 'ParentNodeID', 'ExportFormat', 'RemoteSearch'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['search'] = array(
    'script'			=>      'search.php',
    'params'			=> 	array('Classes', 'ClassAttributes', 'FacetAttributes', 'ParentNodeID', 'Offset', 'Limit'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['geo_search'] = array(
    'script'			=>      'geo_search.php',
    'params'			=> 	array('Class', 'Attributes', 'ParentNodeID', 'LocationsAttribute'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['remote_search'] = array(
    'script'			=>      'remote_search.php',
    'params'			=> 	array('Class', 'SearchAttributes', 'FacetAttributes', 'ParentNodeID'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['import'] = array(
    'script'			=>      'import.php',
    'params'			=> 	array('ClassID', 'ClassIdentifier'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['config'] = array(
    'script'			=>      'config.php',
    'params'			=> 	array(),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['facetsearch'] = array(
    'script'			=>      'facetsearch.php',
    'params'			=> 	array('ClassID', 'Operation'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['facetsearchattribute'] = array(
    'script'			=>      'facetsearchattribute.php',
    'params'			=> 	array('FacetSearchID', 'Operation'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$ViewList['events_search'] = array(
    'script'			=>      'events_search.php',
    'params'			=> 	array('Class', 'ParentNodeID', 'Timestamp', 'Days'),
    'unordered_params'		=> 	array(),
    'single_post_actions'	=> 	array(),
    'post_action_parameters'	=> 	array()
);

$FunctionList = array();
$FunctionList['datatable_search'] = array();
$FunctionList['geo_search'] = array();
$FunctionList['remote_search'] = array();
$FunctionList['import'] = array();
$FunctionList['config'] = array();
$FunctionList['facetsearch'] = array();
$FunctionList['facetsearchattribute'] = array();
$FunctionList['events_search'] = array();
$FunctionList['search'] = array();
