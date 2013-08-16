<?php

/*
 * игровые аккаунты юзера
 */
class App_Model_DbTable_Players extends Zend_Db_Table_Abstract
{

	protected $_name = 'players';

	public function getAllByAcc( $idA )
	{
		$select = $this->select()
				->setIntegrityCheck(false)
				->from($this, array('id', 'enable_monitor', 'enable_notify', 'check_interval', 'notify_hours'))
				->join('worlds', "worlds.id = world_id", array( 'pattern' ))
				->joinLeft('player_sots', "player_sots.player_id = players.id", array( 'sots' => new Zend_Db_Expr('CAST( GROUP_CONCAT(player_sots.name SEPARATOR ";;;") AS char)') ))
				->where("acc_id = ?", $idA, Zend_Db::INT_TYPE)
				->group('players.id');

		return $this->fetchAll($select);
	}

	public function validate($idA, $idP)
	{
		$select = $this->select()
					->from($this, array('id'))
					->where('id = ?', $idP, Zend_Db::INT_TYPE)
					->where('acc_id = ?', $idA, Zend_Db::INT_TYPE)
					->limit(1);
		return !is_null($this->fetchRow($select));
	}

	public function changeMonitoring($idP, $toggle)
	{
		$this->update(
				array( 'enable_monitor' => $toggle ),
				array( $this->_db->quoteInto( 'id = ?', $idP, Zend_Db::INT_TYPE ) )
				);
	}
	public function changeNotification($idP, $toggle)
	{
		$this->update(
				array( 'enable_notify' => $toggle ),
				array( $this->_db->quoteInto( 'id = ?', $idP, Zend_Db::INT_TYPE ) )
				);
	}

	public function changeIntervalCheck($idP, $interval)
	{
		$this->update(
				array( 'check_interval' => $interval ),
				array( $this->_db->quoteInto( 'id = ?', $idP, Zend_Db::INT_TYPE ) )
				);
	}

	public function changeIntervalNotify($idP, $interval)
	{
		$this->update(
				array( 'notify_hours' => $interval ),
				array( $this->_db->quoteInto( 'id = ?', $idP, Zend_Db::INT_TYPE ) )
				);
	}

	public function del($idP)
	{
		return $this->delete($this->_db->quoteInto( 'id = ?', $idP, Zend_Db::INT_TYPE ));
	}

	public function addNew($idA, $idW, $intervalCheck, $intervalNotify, $monitoring, $notify)
	{
		return $this->insert(array(
				'acc_id' => $idA,
				'world_id' => $idW,
				'enable_monitor' => intval($monitoring),
				'enable_notify' => intval($notify),
				'check_interval' => $intervalCheck,
				'notify_hours' => $intervalNotify,
				) );
	}
}
