<?php

class App_Model_DbTable_Worlds extends Zend_Db_Table_Abstract
{

	protected $_name = 'worlds';

	public function getNotUsedByAcc( $idA )
	{
		$select = $this->select()
				->setIntegrityCheck(false)
				->from($this, array('id', 'pattern'))
				->where("id NOT IN (select `world_id` from `players` WHERE `acc_id` = ?)", $idA, Zend_Db::INT_TYPE);
		return $this->fetchAll($select);
	}

}
