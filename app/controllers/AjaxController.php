<?php

/*
 * контроллер для всех ajax запросов
 *
 */

class AjaxController extends Zend_Controller_Action
{
	private $_log = null;

	public function init()
	{
		$this->_log = $this->getInvokeArg('bootstrap')->getResource('Log');

		//только аякс запросы
		if( !$this->_request->isXmlHttpRequest() )
			throw new Exception('AJAX only');

		//проверка на реферер
		$url = $this->view->serverUrl();
		if( $url !== substr($this->_request->getServer('HTTP_REFERER', ''), 0, mb_strlen($url) ) )
			throw new Exception('AJAX referer');

		//логирование всех запросов
		$this->_addAjaxLog();

		$this->_helper->getHelper('AjaxContext')
							->addActionContext('starturl', 'json')
							->addActionContext('monitortoggle', 'json')
							->addActionContext('notifytoggle', 'json')
							->addActionContext('changeintervalcheck', 'json')
							->addActionContext('changeintervalnotify', 'json')
							->addActionContext('playerdelete', 'json')
							->addActionContext('changesots', 'json')
							->addActionContext('change-notify-type', 'json')
							->initContext();
	}

	/*
	 * добавление лога запроса
	 */
	private function _addAjaxLog()
	{
		$this->_log->ajax(
				  $this->_request->getClientIp()
				. ' '
				. $this->_request->getRequestUri()
				. ' '
				. $this->_request->getServer('HTTP_REFERER', '')
				. ' '
				. serialize($this->_request->getPost())
				. ' '
				. $this->_request->getServer('HTTP_USER_AGENT', '')
				);
	}

	/*
	 * добавление лога ошибки CSRF токена
	 */
	private function _addCsrfLog()
	{
		$this->_log->csrf(
				  $this->_request->getClientIp()
				. ' '
				. $this->_request->getRequestUri()
				. ' '
				. $this->_request->getServer('HTTP_REFERER', '')
				. ' '
				. serialize($this->_request->getPost())
				. ' '
				. $this->_request->getServer('HTTP_USER_AGENT', '')
				);
	}

	/*
	 * добавление лога странной ошибки
	 */
	private function _addErrorLog()
	{
		$error = (isset($this->view->error)) ? $this->view->error : 'Undefined error';
		$this->_log->error(
				  $this->_request->getClientIp()
				. ' '
				. $this->_request->getRequestUri()
				. ' '
				. $error
				. ' '
				. $this->_request->getServer('HTTP_REFERER', '')
				. ' '
				. serialize($this->_request->getPost())
				. ' '
				. $this->_request->getServer('HTTP_USER_AGENT', '')
				);
	}


	public function playerdeleteAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);

		if( !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Players')->del( $idP );

		$this->view->success = 'Игрок успешно удалён';
	}

	public function starturlAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$idU = (int)$this->_request->getPost('idU');
		if( !$this->_helper->modelLoad('StartPage')->validate($idU) )
		{
			$this->view->error = 'Некорректный идентификатор стартовой страницы.';
			$this->_addErrorLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$this->_helper->modelLoad('Account')->changeUrl( $user->id, $idU );

		$this->view->success = "Новая стартовая страница успешно установлена";
	}

	public function changeNotifyTypeAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$newType = $this->_request->getPost('type');
		if( !in_array($newType, array('email', 'sms')) )
		{
			$this->view->error = 'Некорректный тип';
			$this->_addErrorLog();
			return;
		}

		//если баланс меньше нуля - не даём включать смс оповещения
		$user = Zend_Auth::getInstance()->getStorage()->read();
		if( $this->_helper->modelLoad('Account')->balanceNegative($user->id) && $newType == 'sms' )
		{
			$this->view->error = 'Для sms-оповещений необходим положительный баланс';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Account')->changeNotifyType( $user->id, $newType );
		$this->view->success = "Тип оповещений успешно изменён";
	}

	public function monitortoggleAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);
		$toggle = $this->_request->getPost('toggle','');

		if( !in_array($toggle, array('1','0')) || !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		//если прокси истекли не даём включать мониторинг
		if( $this->_helper->modelLoad('Account')->proxyExpired($user->id) && $toggle == '1' )
		{
			$this->view->error = 'Срок оплаты прокси сервера истёк';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Players')->changeMonitoring( $idP, (int)$toggle );

		$this->view->success = ($toggle) ? 'Мониторинг включен' : 'Мониторинг выключен';
	}

	public function notifytoggleAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);
		$toggle = $this->_request->getPost('toggle','');

		if( !in_array($toggle, array('1','0')) || !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Players')->changeNotification( $idP, (int)$toggle );

		$this->view->success = ($toggle) ? 'Оповещения включены' : 'Оповещения выключены';
	}


	public function changeintervalcheckAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);
		$interval = (int)$this->_request->getPost('interval',0);

		$checkInterval = $this->getFrontController()->getParam('bootstrap')->getOption('checkInterval');
		if( $interval < $checkInterval['min'] || $interval > $checkInterval['max'] || !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Players')->changeIntervalCheck( $idP, $interval );
		$this->_helper->modelLoad('Checks')->resetByPlayer( $idP );

		$this->view->success = 'Интервал проверок успешно изменён';
	}

	public function changeintervalnotifyAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);
		$interval = (int)$this->_request->getPost('interval',0);

		$checkInterval = $this->getFrontController()->getParam('bootstrap')->getOption('checkInterval');
		if( $interval < $checkInterval['min'] || $interval > $checkInterval['max'] || !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		$this->_helper->modelLoad('Players')->changeIntervalNotify( $idP, $interval );

		$this->view->success = 'Интервал оповещений успешно изменён';
	}

	public function changesotsAction()
	{
		if( !$this->_helper->checkAccess('profile','edit','return') )
		{
			$this->view->error = 'Сессия устарела. Перезайдите в систему и попробуйте снова.';
			$this->_addErrorLog();
			return;
		}

		if( !$this->_helper->tokenCheck($this->_request->getPost('csrf')) )
		{
			$this->view->error = 'Токен устарел. Перезагрузите страницу.';
			$this->_addCsrfLog();
			return;
		}

		$user = Zend_Auth::getInstance()->getStorage()->read();
		$idP = (int)$this->_request->getPost('idP',0);
		$sots = $this->_helper->modelLoad('PlayerSots')->parseSots($this->_request->getPost('sots',''));

		if( !$this->_helper->modelLoad('Players')->validate($user->id, $idP) )
		{
			$this->view->error = 'Невалидные параметры запроса';
			$this->_addErrorLog();
			return;
		}

		if( count($sots) == 0 )
		{
			$this->view->error = 'Введите хотя бы одну соту для мониторинга';
			$this->_addErrorLog();
			return;
		}

		if( count($sots) > 10 )
		{
			$this->view->error = 'Разрешено отслеживать не более 10 сот одного игрока';
			$this->_addErrorLog();
			return;
		}

	//изменяем соты (удаляем все старые, добавляем новые)
		$this->_helper->modelLoad('PlayerSots')->changeSots( $idP, $sots );

		$this->view->success = 'Соты игрока успешно изменены';
	}
}
