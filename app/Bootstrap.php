<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	protected function _initRoute()
	{
		$front = Zend_Controller_Front::getInstance();
		$router = $front->getRouter();

		$router->removeDefaultRoutes();

		$router->addRoute('staticIndex',
				new Zend_Controller_Router_Route_Static('/',
						array( 'controller' => 'index', 'action' => 'index' )));
		$router->addRoute('staticFaq',
				new Zend_Controller_Router_Route_Static('/faq.html',
						array( 'controller' => 'index', 'action' => 'faq' )));
		$router->addRoute('staticManually',
				new Zend_Controller_Router_Route_Static('/manually-only.html',
						array( 'controller' => 'index', 'action' => 'manually' )));

		$router->addRoute('allAjax',
				new Zend_Controller_Router_Route('/ajax/:action',
						array( 'controller' => 'ajax') ));

		$router->addRoute('userProfile',
				new Zend_Controller_Router_Route_Static('/profile',
						array( 'controller' => 'user', 'action' => 'index' )));
		$router->addRoute('userBalance',
				new Zend_Controller_Router_Route_Static('/balance',
						array( 'controller' => 'user', 'action' => 'balance' )));
		$router->addRoute('userMessages',
				new Zend_Controller_Router_Route_Static('/messages',
						array( 'controller' => 'user', 'action' => 'messages' )));
		$router->addRoute('userChecks',
				new Zend_Controller_Router_Route_Static('/checks',
						array( 'controller' => 'user', 'action' => 'checks' )));
		$router->addRoute('userChangePass',
				new Zend_Controller_Router_Route_Static('/changepass',
						array( 'controller' => 'user', 'action' => 'changepass' )));
		$router->addRoute('userChangeGamePass',
				new Zend_Controller_Router_Route_Static('/changegamepass',
						array( 'controller' => 'user', 'action' => 'changegamepass' )));
		$router->addRoute('userAddPlayer',
				new Zend_Controller_Router_Route_Static('/addplayer',
						array( 'controller' => 'user', 'action' => 'addplayer' )));

		$router->addRoute('staticLogin',
				new Zend_Controller_Router_Route_Static('/login.html',
						array( 'controller' => 'auth', 'action' => 'login' )));
		$router->addRoute('staticDemoLogin',
				new Zend_Controller_Router_Route_Static('/demo-login.html',
						array( 'controller' => 'auth', 'action' => 'demo-login' )));
		$router->addRoute('staticRegistration',
				new Zend_Controller_Router_Route_Static('/registration.html',
						array( 'controller' => 'auth', 'action' => 'registration' )));
		$router->addRoute('staticLogout',
				new Zend_Controller_Router_Route_Static('/logout.html',
						array( 'controller' => 'auth', 'action' => 'logout' )));
	}

	protected function _initZFDebug()
	{
		//открываем на боевом только для домашнего адреса
		if( APPLICATION_ENV === 'production' )
			return false;

		$autoloader = Zend_Loader_Autoloader::getInstance();
		$autoloader->registerNamespace('ZFDebug');

		$options = array(
			'plugins' => array(
				'Variables',
				'File' => array( 'base_path' => APPLICATION_PATH ),
				'Memory',
				'Time',
				'Registry',
				'Exception',
				'Html',
			)
		);

		// Настройка плагина для адаптера базы данных
		if( $this->hasPluginResource('db') ) {
			$this->bootstrap('db');
			$db = $this->getPluginResource('db')->getDbAdapter();
			$options['plugins']['Database']['adapter'] = $db;
		}

		$debug = new ZFDebug_Controller_Plugin_Debug($options);

		$this->bootstrap('frontController');
		$frontController = $this->getResource('frontController');
		$frontController->registerPlugin($debug);
	}

	protected function _initLogs()
	{
		$this->bootstrap('log');
		$log = $this->getResource('log');

		$log->addPriority('ajax', 8);
		$log->addPriority('csrf', 9);
		$log->addPriority('error', 10);
	}

	protected function _initCaches()
	{
		$this->bootstrap('cachemanager');
		Zend_Db_Table_Abstract::setDefaultMetadataCache( $this->getResource('cachemanager')->getCache('long') );
	}

	/*
	 * дефолтные значения статиками
	 * экшен хелперы (инстанс ради хуков в диспетчеризацию)
	 * итд
	 */
	protected function _initOthers()
	{
		Zend_Session::registerValidator( new Zend_Session_Validator_HttpUserAgent() );
		Zend_Session::registerValidator( new Mylib_Session_Validator_IPAdress() );
	}


}
