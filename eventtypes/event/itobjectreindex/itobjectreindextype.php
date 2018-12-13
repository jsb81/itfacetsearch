<?php

/**
 * Class ITObjectReindexType
 *
 * @author Stefano Ziller
 */
class ITObjectReindexType extends eZWorkflowEventType
{
    const WORKFLOW_TYPE_STRING = "itobjectreindex";

    public function __construct()
    {
        $this->eZWorkflowEventType( self::WORKFLOW_TYPE_STRING, 'Reindicizza Oggetto' );
    }


    public function execute( $process, $event )
    {
        $parameters = $process->attribute('parameter_list');

        try {
            return eZWorkflowType::STATUS_ACCEPTED;
        }
        catch(Exception $e){
            eZDebug::writeError( $e->getMessage(), __METHOD__ );
            return eZWorkflowType::STATUS_REJECTED;
        }
    }

}
eZWorkflowEventType::registerEventType( ITObjectReindexType::WORKFLOW_TYPE_STRING, 'ITObjectReindexType' );
