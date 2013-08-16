<?php

/*
 * рисует разные уровни основного меню
 * строится автоматически по наличию флага $active
 */

class Zend_View_Helper_MainMenu extends Zend_View_Helper_Abstract
{

	public function MainMenu( $level )
	{
		switch ($level)
		{
			case 'auth':
				$this->printAuthMenu();
				break;
			case 'main':
				$this->printMainMenu();
				break;
			case 'profile':
				$this->printUserMenu();
				break;
			default:
				throw new Exception('Undefined identity for menu level');
				break;
		}
	}

	/*
	 * меню авторизации
	 * для авторизованных юзеров возвращает шапку с их ником, кнопкой выход и меню по внутренним сервисам
	 * для гостей - кнопки войти и регистрация
	 */
	protected function printAuthMenu()
	{
		$auth = Zend_Auth::getInstance();

		if ( $auth->hasIdentity() )
		{
			$user = $auth->getStorage()->read();
			echo "<p><a href='" . $this->view->url(array(),'userProfile',true) . "'>" . $this->view->escape($user->login) . "</a></p>
				  <p><a href='" . $this->view->url(array(),'staticLogout',true) . "'>выйти</a></p>";
		}else{
			echo '<p><a href="' . $this->view->url(array(),'staticLogin',true) . '">вход</a></p>
				  <p><a href="' . $this->view->url(array(),'staticRegistration',true) . '">регистрация</a></p>';

		}
	}

	/*
	 * главное меню
	 * всегда активно
	 */
	protected function printMainMenu( )
	{
		$menu = array(
			array( 'href' => $this->view->url(array( ), 'staticIndex', true), 'name' => 'главная', 'cntr' => 'index', 'act' => 'index' ),
			array( 'href' => $this->view->url(array( ), 'staticFaq', true), 'name' => 'вопрос-ответ', 'cntr' => 'index', 'act' => 'faq' ),
			);

		$controller = Zend_Controller_Front::getInstance()->getRequest()->getControllerName();
		$action = Zend_Controller_Front::getInstance()->getRequest()->getActionName();

		echo "<div id='main-menu'>";
		foreach($menu as $point)
		{
			$selected = ( $controller === $point['cntr'] && $point['act'] === $action ) ? 'selected-label' : '';
			echo "<a class='{$selected}' href='{$point['href']}'>{$point['name']}</a>";
		}
		echo '</div>';
	}

	/*
	 * меню пользователя
	 * отталкивается от прав
	 */
	protected function printUserMenu(  )
	{
		if ( !Zend_Auth::getInstance()->hasIdentity() )
			return;

		$access = Zend_Controller_Action_HelperBroker::getStaticHelper('CheckAccess');

		$menu = array();

		if($access->check('profile', 'view', 'return'))
			$menu[] = array(
				'href' => $this->view->url(array( ), 'userProfile', true),
				'name' => 'профиль',
				'cntr' => 'user',
				'act' => array('index','changepass','addplayer','changegamepass') );

		if($access->check('profile', 'view', 'return'))
			$menu[] = array(
				'href' => $this->view->url(array( ), 'userBalance', true),
				'name' => 'списания',
				'cntr' => 'user',
				'act' => 'balance' );

		if($access->check('profile', 'view', 'return'))
			$menu[] = array(
				'href' => $this->view->url(array( ), 'userMessages', true),
				'name' => 'сообщения',
				'cntr' => 'user',
				'act' => 'messages', );

		if($access->check('profile', 'view', 'return'))
			$menu[] = array(
				'href' => $this->view->url(array( ), 'userChecks', true),
				'name' => 'проверки',
				'cntr' => 'user',
				'act' => 'checks', );

		$controller = Zend_Controller_Front::getInstance()->getRequest()->getControllerName();
		$action = Zend_Controller_Front::getInstance()->getRequest()->getActionName();

		echo "<div id='personal-menu'>";
		foreach($menu as $point)
		{
			$selected = ( $controller === $point['cntr'] && ( $point['act'] === $action || ( is_array($point['act']) && in_array($action, $point['act']) ) ) ) ? 'selected-label' : '';
			echo "<a class='{$selected}' href='{$point['href']}'>{$point['name']}</a>";
		}
		echo '</div>';

	}
}
