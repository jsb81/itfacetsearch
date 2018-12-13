<?php


$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();

$class_id = $Params['ClassID'];
$class_identifier = $Params['ClassIdentifier'];

$tpl->setVariable('class_id', $class_id);
$tpl->setVariable('class_identifier', $class_identifier);

$Result['content'] = $tpl->fetch( "design:facetsearch/import.tpl" );
