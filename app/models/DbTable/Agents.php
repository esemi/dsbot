<?php

class App_Model_DbTable_Agents extends Zend_Db_Table_Abstract
{

	protected $_name = 'agents';

	public function getRandId()
	{
		$list = $this->fetchAll( $this->select()->from($this, array( 'id' )) );
		return $list[rand(0, count($list)-1)]->id;
	}

}
