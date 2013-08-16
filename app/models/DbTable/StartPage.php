<?php

class App_Model_DbTable_StartPage extends Zend_Db_Table_Abstract
{

	protected $_name = 'start_urls';

	public function listAll()
	{
		$select = $this->select()->from($this, array( 'id', 'url' ));
		return $this->fetchAll($select);
	}

	public function validate($idU)
	{
		$select = $this->select()
				->from($this, array( 'id' ))
				->where('id = ?', $idU, Zend_Db::INT_TYPE)
				->limit(1);
		return !is_null($this->fetchRow($select));
	}

	public function getRandId()
	{
		$list = $this->listAll();
		return $list[rand(0, count($list)-1)]->id;
	}

}
