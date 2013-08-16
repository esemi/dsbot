<?php

class Zend_View_Helper_PrintCsrfToken extends Zend_View_Helper_Abstract
{
    public function printCsrfToken()
    {        
        $token = $this->view->getToken();
        if(!is_null($token))
            printf('<input id="js-csrf-token" type="hidden" class="hide" name="token" value="%s"/>', $token);        
    }
}
