<?php
/*
 * Access control list
 */
class Mylib_Acl extends Zend_Acl
{
	public function __construct()
	{
		$this->addRole(new Zend_Acl_Role('guest'));
		$this->addRole(new Zend_Acl_Role('demo'), 'guest');
		$this->addRole(new Zend_Acl_Role('user'), 'guest');

		$this->add(new Zend_Acl_Resource('profile')); //всё что связано с профилем юзера
		$this->add(new Zend_Acl_Resource('others'));  //всякое остальное

		$this->allow( 'demo', 'profile', array('view') );

		$this->allow( 'user', 'profile', array('view', 'edit') );
		$this->allow( 'user', 'others', array('faq') );
	}
}