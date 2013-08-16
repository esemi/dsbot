<?php

class App_Model_DbTable_Checks extends Zend_Db_Table_Abstract
{
	protected
		$_name = 'check_tasks';

	public function listAll( $idA, $limit )
	{
		$select = $this->select()
				->setIntegrityCheck(false)
				->from($this, array('custom_date' => "DATE_FORMAT(`date` , '%H:%i %d.%m.%Y')", 'status', 'try_count'))
				->join('players', "players.id = player_id")
				->join('worlds', "worlds.id = world_id", array('pattern'))
				->where('acc_id = ?', $idA, Zend_Db::INT_TYPE)
				->order('date DESC')
				->limit($limit);

		return $this->fetchAll($select);
	}

	public function resetByPlayer($idP)
	{
		return $this->delete( array(
			$this->_db->quoteInto( 'player_id = ?', $idP, Zend_Db::INT_TYPE ), '`date` >= NOW()'));
	}
}
