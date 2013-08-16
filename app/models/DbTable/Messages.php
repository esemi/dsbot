<?php

class App_Model_DbTable_Messages extends Zend_Db_Table_Abstract
{
	protected
		$_name = 'messages',
		$_primary = 'acc_id';

	public function listAll( $idA, $limit )
	{
		$select = $this->select()
				->from($this, array(
					'message',
					'to',
					'custom_date' => "DATE_FORMAT(`date` , '%H:%i:%s %d.%m.%Y')"))
				->where('acc_id = ?', $idA, Zend_Db::INT_TYPE)
				->order('date DESC')
				->limit($limit);

		return $this->fetchAll($select);
	}
}