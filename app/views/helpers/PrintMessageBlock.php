<?php
/*
 * выводит блок для сообщений, также используемый для ajax сообщений
 * 
 *
 * @param string type (error|success)
 * @param string text message
 */
class Zend_View_Helper_PrintMessageBlock extends Zend_View_Helper_Abstract
{
    public function printMessageBlock( $type = null, $text = null )
    {
        if( is_null($type) || is_null($text) )
        {
            printf('<span class="message-block js-ajax-result"></span>');
            return;
        }
        
        switch ($type)
        {
            case 'error':
                printf('<span class="message-block error js-ajax-result">%s</span>', $text);
            break;

            case 'success':
                printf('<span class="message-block success js-ajax-result">%s</span>', $text);
            break;

            default:
                throw new Exception('Undefined error type (helper printMessage())');
            break;
        }
    }
}
