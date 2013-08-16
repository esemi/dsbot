<?php
/*
 * выводит блок для сообщений, также используемый для ajax сообщений
 * 
 *
 * @param string type (error|success)
 * @param string text message
 */
class Zend_View_Helper_PrintCheckStatus extends Zend_View_Helper_Abstract
{
    public function printCheckStatus( $status )
    {
		$class = '';		
		if( $status == 'fail' )
			$class = 'error';		
		if( $status ==  'success' )
			$class = 'success';
		
		printf('<span class="%s">%s</span>', $class, $status);        
    }
}
