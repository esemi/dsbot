<?php

/*
 * пользователи
 */

class App_Model_DbTable_Account extends Zend_Db_Table_Abstract
{

	protected $_name = 'account';

	public function getInfo($idA)
	{
		$select = $this->select()
				->setIntegrityCheck(false)
				->from($this, array(
					'balance', 'phone', 'email', 'notify_type',
					'proxy_expired' => "DATE_FORMAT(`proxy_expired` , '%d.%m.%Y')" ))
				->join('start_urls', "start_urls.id = url_id", array( 'start_url' => 'url' ))
				->where("{$this->_name}.id = ?", $idA, Zend_Db::INT_TYPE)
				->limit(1);

		return $this->fetchRow($select);
	}

	public function changePass($idA, $pass)
	{
		$this->update(
				array( 'pass' => $pass ),
				array( $this->_db->quoteInto('id = ?', $idA, Zend_Db::INT_TYPE) )
		);
	}

	public function changeGamePass($idA, $pass)
	{
		$key = Zend_Controller_Front::getInstance()->getParam('bootstrap')->getOption('game_pass_key');
		$this->update(
				array( 'game_pass' => new Zend_Db_Expr( $this->_db->quoteInto("AES_ENCRYPT(?, '{$key}')", $pass) ) ),
				array( $this->_db->quoteInto('id = ?', $idA, Zend_Db::INT_TYPE) )
		);
	}

	public function changeNotifyType($idA, $type)
	{
		$this->update(
				array( 'notify_type' => $type ), array( $this->_db->quoteInto('id = ?', $idA, Zend_Db::INT_TYPE) )
		);
	}

	public function changeUrl($idA, $idU)
	{
		$this->update(
				array( 'url_id' => $idU ), array( $this->_db->quoteInto('id = ?', $idA, Zend_Db::INT_TYPE) )
		);
	}

	public function validateNewAccount($data)
	{
		//обязательные параметры
		$tmp = $this->_validateRequireParams($data);
		if( $tmp !== true )
			return $tmp;

		//логин
		$tmp = $this->_validateLogin($data['login']);
		if( $tmp !== true )
			return $tmp;

		//пароль
		$tmp = $this->validatePass($data['pass'], $data['pass']);
		if( $tmp !== true )
			return $tmp;

		//мыло
		$tmp = $this->_validateEmail($data['email']);
		if( $tmp !== true )
			return $tmp;

		//телефон
		$tmp = $this->_validatePhone($data['phone']);
		if( $tmp !== true )
			return $tmp;

		//игровой пароль
		$tmp = $this->_validateGamePass($data['game_pass']);
		if( $tmp !== true )
			return $tmp;

		return 'Регистрация на данный момент только по инвайтам';
	}

	private function _validateRequireParams($post)
	{
		$params = array(
			'login',
			'pass',
			'email',
			'phone',
			'game_pass');

		foreach($params as $p)
			if( !isset($post[$p]) )
				return "Не переданы один или несколько обязательных параметров";

		return true;
	}


	private function _validateLogin($login)
	{
		if( !preg_match('/^[\w]{3,50}$/', $login) )
			return 'Некорректный логин';

		return true;
	}

	private function _validateEmail($email)
	{
		$validMail = new Zend_Validate_EmailAddress(array( 'mx' => true, 'deep' => true ));
		if( !$validMail->isValid($email) )
			return sprintf('Некорректный адрес электронной почты (%s)', implode('; ', $validMail->getMessages()));

		return true;
	}

	private function _validatePhone($phone)
	{
		if( !preg_match('/^[\d\+]{5,20}$/', $phone) )
			return 'Некорректный номер телефона (5-20 чисел)';

		return true;
	}

	private function _validateGamePass($gpass)
	{
		if( mb_strlen($gpass) < 3 )
			return "Игровой пароль слишком короткий";

		return true;
	}

	public function validatePass($pass, $pass2, $idA = null, $oldpass = null)
	{
		//пароль неверен
		if( mb_strlen($pass) < 6 )
			return "Пароль слишком короткий";

		//пароли не совпадают
		if( $pass !== $pass2 )
			return 'Пароли не совпадают';

		//проверим старый пароль
		if( !is_null($idA) ) {
			if( !$this->validateAccPass($oldpass, $idA) )
				return 'Некорректное значение текущего пароля';
		}
		return true;
	}

	public function validateAccPass($accPass, $idA)
	{
		$select = $this->select()
				->from($this, array( 'id' ))
				->where('id = ?', $idA, Zend_Db::INT_TYPE)
				->where('pass = ?', $this->getPasswordHash($accPass))
				->limit(1);

		return (!is_null($this->fetchRow($select)) );
	}

	public function proxyExpired($idA)
	{
		$select = $this->select()
				->from($this, array( 'id', 'result' => new Zend_Db_Expr('IF( `proxy_expired` < CURDATE(), 1, 0 )') ))
				->where('id = ?', $idA, Zend_Db::INT_TYPE)
				->limit(1);

		$res = $this->fetchRow($select);
		return (bool) $res['result'];
	}

	public function balanceNegative($idA)
	{
		$select = $this->select()
				->from($this, array( 'id', 'result' => new Zend_Db_Expr('IF( `balance` < 0, 1, 0 )') ))
				->where('id = ?', $idA, Zend_Db::INT_TYPE)
				->limit(1);

		$res = $this->fetchRow($select);
		return (bool) $res['result'];
	}

	public function getPasswordHash($pass)
	{
		return hash('sha256', $pass);
	}


	/*
	 * добавление нового юзера
	 */
	public function addNew( $post, $agentId, $urlId )
	{
		$key = Zend_Controller_Front::getInstance()->getParam('bootstrap')->getOption('game_pass_key');
		return $this->insert( array(
			'agent_id' => $agentId,
			'url_id' => $urlId,
			'login' => $post['login'],
			'pass' => $this->_db->quote($this->getPasswordHash($post['pass'])),
			'approved' => 0,
			'game_pass' => new Zend_Db_Expr( $this->_db->quoteInto("AES_ENCRYPT(?, '{$key}')", $post['game_pass']) ),
			'balance' => 0.0,
			'phone' => $post['phone'],
			'email' => $this->_db->quote($post['email']),
			'proxy_expired' => new Zend_Db_Expr('CURDATE() - INTERVAL 1 DAY'),
			'notify_type' => 'email') );
	}

}
