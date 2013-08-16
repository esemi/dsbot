<?php

/*
 * соты игрока
 */
class App_Model_DbTable_PlayerSots extends Zend_Db_Table_Abstract
{

    protected $_name = 'player_sots';

    public function changeSots($idP, $sots)
    {
        //удаляем старые
        $this->delete($this->_db->quoteInto( 'player_id = ?', $idP, Zend_Db::INT_TYPE ));

        //добаляем новые
        $this->addSots($idP, $sots);
    }

    public function addSots($idP, $sots)
    {
        foreach( $sots as $name )
        {
            $this->insert(array(
                'player_id' => $idP,
                'name' => $name
                ) );
        }
    }

    public function parseSots($data)
    {
        $tmp = array_unique(preg_split("/[\s\n]+/", trim($data)));
        $sots = array();
        foreach( $tmp as $t )
            if( preg_match('/^[\w\dа-яё]{3,250}$/iu', $t) )
                $sots[] = trim($t);
        return $sots;
    }
}
