<?php

class IndexController extends Zend_Controller_Action
{
	public function indexAction()
	{
		$this->view->title = "Главная";
	}

	public function faqAction()
	{
		$this->view->title = "FAQ";
	}

	public function manuallyAction()
	{
		$this->view->title = "Действие доступно только администратору";
	}
}