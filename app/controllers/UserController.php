<?php

class UserController extends Zend_Controller_Action
{
	private $_user = null;

	public function init()
	{
		$this->_user = Zend_Auth::getInstance()->getStorage()->read();
	}

	public function indexAction()
	{
		$this->_helper->checkAccess('profile','view','redirect');

		$this->view->title = "Профиль пользователя";

		$this->view->user = $user = $this->_helper->modelLoad('Account')->getInfo($this->_user->id);
		$this->view->players = $this->_helper->modelLoad('Players')->getAllByAcc($this->_user->id);
		$this->view->startPages = $this->_helper->modelLoad('StartPage')->listAll();

		//границы интервала для проверки сот
		$this->view->checkInterval = $this->getFrontController()->getParam('bootstrap')->getOption('checkInterval');

		//приближение к нулевому балансу или дате проксей
		$limits = $this->getFrontController()->getParam('bootstrap')->getOption('limitWarning');
		$now = new DateTime();
		$limit = new DateTime($user->proxy_expired);
		$limit->sub(new DateInterval(sprintf("P%dD", $limits['proxy'])));
		$this->view->proxyWarn = ($now >= $limit);
		$this->view->balanceWarn = (floatval($user->balance) <= floatval($limits['balance']));

		//сообщения из других мест
		$mes = $this->_helper->flashMessenger->getMessages();
		if( count($mes) > 0 && is_array($mes) )
		{
			$mes = array_shift($mes);
			$keys = array_keys($mes);
			$this->view->messType = array_shift( $keys );
			$this->view->messText = array_shift( $mes );
		}

		$this->view->edited = $this->_helper->checkAccess('profile','edit','return');
		$this->view->avaliableSms = ! $this->_helper->modelLoad('Account')->balanceNegative($this->_user->id);
		$this->view->avaliableMonitoring = ! $this->_helper->modelLoad('Account')->proxyExpired($this->_user->id);
	}

	public function balanceAction()
	{
		$this->_helper->checkAccess('profile','view','redirect');

		$this->view->title = "История платежей";

		$this->view->amounts = $this->_helper->modelLoad('BalanceHistory')->listAll($this->_user->id,100);
	}

	public function messagesAction()
	{
		$this->_helper->checkAccess('profile','view','redirect');

		$this->view->title = "История сообщений";

		$this->view->messages = $this->_helper->modelLoad('Messages')->listAll($this->_user->id,100);
	}

	public function checksAction()
	{
		$this->_helper->checkAccess('profile','view','redirect');

		$this->view->title = "История проверок";

		$this->view->messages = $this->_helper->modelLoad('Checks')->listAll($this->_user->id,100);
	}

	public function changepassAction()
	{
		$this->_helper->checkAccess('profile','edit','redirect');

		$this->view->title = "Изменение пароля от аккаунта";

		if( $this->_request->isPost() )
		{
			$oldPass = $this->_request->getPost('oldpass');
			$newPass = $this->_request->getPost('newpass');
			$retryPass = $this->_request->getPost('retrypass');

			$res = $this->_helper->modelLoad('Account')->validatePass($newPass, $retryPass, $this->_user->id, $oldPass);
			if( $res !== true )
			{
				$this->view->messType = 'error';
				$this->view->messText = $res;
				return;
			}

			$this->_helper->modelLoad('Account')->changePass($this->_user->id, $this->_helper->modelLoad('Account')->getPasswordHash($newPass));
			$this->_helper->flashMessenger->addMessage(  array( 'success' => "Пароль от аккаунта успешно изменён" ) );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}
	}

	public function changegamepassAction()
	{
		$this->_helper->checkAccess('profile','edit','redirect');

		$this->view->title = "Изменение пароля от игры";

		if( $this->_request->isPost() )
		{
			$accPass = $this->_request->getPost('accpass');
			$gamePass = $this->_request->getPost('gamepass');

			$res = $this->_helper->modelLoad('Account')->validateAccPass($accPass, $this->_user->id);
			if( $res !== true )
			{
				$this->view->messType = 'error';
				$this->view->messText = 'Некорректное значение текущего пароля';
				return;
			}

			$this->_helper->modelLoad('Account')->changeGamePass($this->_user->id, $gamePass);
			$this->_helper->flashMessenger->addMessage(  array( 'success' => "Пароль от игры успешно изменён" ) );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}
	}

	public function addplayerAction()
	{
		$this->_helper->checkAccess('profile','edit','redirect');

		$this->view->title = "Добавление игрока";

		//доступные миры (одна сота в одном мире)
		$this->view->worlds = $worlds = $this->_helper->modelLoad('Worlds')->getNotUsedByAcc($this->_user->id);

		//границы интервала для проверки сот
		$this->view->checkInterval = $intervalProps = $this->getFrontController()->getParam('bootstrap')->getOption('checkInterval');

		if( $this->_request->isPost() )
		{
			$monitoring = ($this->_request->getPost('monitoring','off') === 'on') ? true : false;
			if( $this->_helper->modelLoad('Account')->proxyExpired($this->_user->id) )
				$monitoring = false;

			$notify = ($this->_request->getPost('notify','off') == 'on') ? true : false;
			$intervalCheck = (int)$this->_request->getPost('intervalcheck',0);
			$intervalNotify = (int)$this->_request->getPost('intervalnotify',0);
			$sots = $this->_helper->modelLoad('PlayerSots')->parseSots($this->_request->getPost('sots',''));
			$world_id = $this->_request->getPost('world',0);

			//проверка параметров
			$this->view->messType = 'error';
			if( $intervalCheck < $intervalProps['min'] || $intervalCheck > $intervalProps['max'] )
				$this->view->messText = 'Недопустимое значение интервала проверок';

			if( $intervalNotify < $intervalProps['min'] || $intervalNotify > $intervalProps['max'] )
				$this->view->messText = 'Недопустимое значение интервала оповещения';

			if( count($sots) == 0 )
				$this->view->messText = 'Введите хотя бы одну соту для мониторинга';

			if( count($sots) > 10 )
				$this->view->messText = 'Разрешено отслеживать не более 10 сот одного игрока';

			if( !in_array($world_id, array_map(function($value){return $value['id'];}, $worlds->toArray())) )
				$this->view->messText = 'Некорректный идентификатор мира';

			if( !empty($this->view->messText) )
				return;

			$idP = $this->_helper->modelLoad('Players')->addNew($this->_user->id, $world_id, $intervalCheck, $intervalNotify, $monitoring, $notify);
			$this->_helper->modelLoad('PlayerSots')->addSots( $idP, $sots );

			$this->_helper->flashMessenger->addMessage(  array( 'success' => "Игрок успешно добавлен" ) );
			$this->_helper->redirector->gotoRoute(array(), 'userProfile');
		}
	}


}