<?php

class ErrorController extends Zend_Controller_Action
{
    public function errorAction()
    {
        $errors = $this->_getParam('error_handler');
        switch ($errors->type) {
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
        
                // 404 error -- controller or action not found
                $this->getResponse()->setHttpResponseCode(404);

                $this->view->keywords = '404, Страница не найдена';
                $this->view->description = 'Страница не найдена';
                $this->view->title = 'Страница не найдена';
                $this->view->message = 'Страница не найдена';
                
                $log = $this->getLog();
                $log->err(
                            '404 '
                            . $errors->request->getClientIp()
                            . ' '
                            . $errors->request->getRequestUri()
                            . ' '
                            . $errors->request->getServer('HTTP_REFERER', 'undef')
                            . ' '
                            . $errors->request->getServer('HTTP_USER_AGENT', 'undef'));

                break;
            default:
                // App error
                $this->getResponse()->setHttpResponseCode(500);

                $this->view->keywords = 'Ошибка, Error';
                $this->view->description = 'Ошибка приложения';
                $this->view->title = 'Ошибка приложения';
                $this->view->message = 'Ошибка приложения';

                $log = $this->getLog();
                $log->crit(
                            $errors->exception->getMessage()
                            .  ' '
                            . $errors->request->getClientIp()
                            . ' '
                            . $errors->request->getRequestUri()
                            . ' '
                            . $errors->request->getServer('HTTP_REFERER', 'undef')
                            . ' '
                            . $errors->request->getServer('HTTP_USER_AGENT', 'undef'));

                break;
        }
                
        if ($this->getInvokeArg('displayExceptionMessage') == true) 
        {
            $this->view->exceptionMessage = $errors->exception->getMessage();
        }

              
        if ($this->getInvokeArg('displayExceptions') == true) 
        {
            $this->view->exception = $errors->exception;
        }
        
        $this->view->request   = $errors->request;
    }

    protected function getLog()
    {
        return $this->getInvokeArg('bootstrap')->getResource('Log');
    }


}

