<?php

$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();


$Result['content'] = $tpl->fetch( "design:facetsearch/config.tpl" );