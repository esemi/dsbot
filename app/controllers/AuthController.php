<?php

/*
 * контроллер аутентификации юзера
 *
 */
class AuthController extends Zend_Controller_Action
{

	public function loginAction()
	{
		$this->view->title = "Вход в личный кабинет";

		if( Zend_Auth::getInstance()->hasIdentity() )
		{
			$this->_helper->flashMessenger->addMessage( array('error' => 'Вы уже авторизованы') );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}

		//сообщения из других мест
		$mes = $this->_helper->flashMessenger->getMessages();
		if( count($mes) > 0 && is_array($mes) )
		{
			$mes = array_shift($mes);
			$keys = array_keys($mes);
			$this->view->messType = array_shift( $keys );
			$this->view->messText = array_shift( $mes );
		}

		if( $this->_request->isPost() )
		{
			$this->view->login = $login = $this->_request->getPost('login','');

			$adapter = $this->_getAuthAdapter();
			$adapter->setIdentity( $login )
					->setCredential( $this->_helper->modelLoad('Account')->getPasswordHash($this->_request->getPost('pass','')) );

			$auth = Zend_Auth::getInstance();
			if ( empty($login) || !$auth->authenticate($adapter)->isValid() )
			{
				$this->view->messType = 'error';
				$this->view->messText = 'Неверная пара логин/пароль или аккаунт ещё не активирован';
				return;
			}

			$user = $this->_getAuthUser($adapter->getResultRowObject(), 'user');
			$auth->getStorage()->write($user);

			//умный редирект
			$this->_redirect( $this->_getParam('return', $this->_helper->url->url(array(),'userProfile',true) ) , array('exit') );
		}

	}

	public function demoLoginAction()
	{
		if( Zend_Auth::getInstance()->hasIdentity() )
		{
			$this->_helper->flashMessenger->addMessage( array('error' => 'Вы уже авторизованы') );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}

		//логиним юзера под демо акком
		$prop = $this->getFrontController()->getParam('bootstrap')->getOption('demouser');
		$adapter = $this->_getAuthAdapter();
		$adapter->setIdentity( $prop['login'] )
				->setCredential( $this->_helper->modelLoad('Account')->getPasswordHash($prop['pass']) );

		$auth = Zend_Auth::getInstance();
		if( !$auth->authenticate($adapter)->isValid() )
			throw new Exception('Invalid credentialy of demo user');

		$user = $this->_getAuthUser($adapter->getResultRowObject(), 'demo');
		$auth->getStorage()->write($user);

		//умный редирект
		$this->_redirect( $this->_getParam('return', $this->_helper->url->url(array(),'userProfile',true) ) , array('exit') );
	}

	protected function _getAuthAdapter()
	{
		$db = $this->getInvokeArg('bootstrap')->getResource('db');
		$adapter = new Zend_Auth_Adapter_DbTable($db);
		$adapter->setTableName('account')
				->setIdentityColumn('login')
				->setCredentialColumn('pass')
				->setCredentialTreatment('? AND `approved` = 1');
		return $adapter;
	}

	protected function _getAuthUser($row, $role)
	{
		$u = new stdClass();
		$u->id = $row->id;
		$u->login = $row->login;
		$u->role = $role;
		$u->csrf = hash('sha256', uniqid( mt_rand(), true ));
		return $u;
	}


	public function logoutAction()
	{
		$auth = Zend_Auth::getInstance();
		if( $auth->hasIdentity() )
		{
			Zend_Auth::getInstance()->clearIdentity();
			Zend_Session::forgetMe();
			Zend_Session::expireSessionCookie();
		}

		$this->_redirect('/', array('exit') );
	}

	public function registrationAction()
	{
		$this->view->title = "Регистрация";

		if( Zend_Auth::getInstance()->hasIdentity() )
		{
			$this->_helper->flashMessenger->addMessage( array('error' => 'Вы уже авторизованы') );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}

		$conf = $this->getFrontController()->getParam('bootstrap')->getOption('recaptcha');
		$this->view->recaptcha = $recaptcha = new Zend_Service_ReCaptcha($conf['pubkey'],$conf['privkey']);

		if( $this->_request->isPost() )
		{
			$this->view->post = $post = $this->_request->getPost();
			$result = $this->_helper->modelLoad('Account')->validateNewAccount($post, $recaptcha);

			if( $result === true )
			{
				//выбираем рандомного агента
				$agentId = $this->_helper->modelLoad('Agents')->getRandId();

				//выбираем рандомный урл стартовой страницы
				$urlId = $this->_helper->modelLoad('StartPage')->getRandId();

				$this->_helper->modelLoad('Account')->addNew( $post, $agentId, $urlId );
				$this->_helper->flashMessenger->addMessage(
						array( 'success' => sprintf("Вы успешно зарегистрировались под ником %s. Для входа необходимо <a href='%s'>активировать аккаунт</a>.",
							$this->view->escape($post['login']),
							$this->_helper->url->url(array(),'staticManually',true)) ));

				$this->_helper->redirector->gotoRoute(array(), 'staticLogin');
			}else{
				$this->view->messType = 'error';
				$this->view->messText = $result;
			}
		}
	}
}





