jQuery(document).ready(function()
	{
	//удаление игрока с аккаунта (с подтверждением)
	jQuery('.js-player-delete').click(function()
	{
		if( !confirm('Вы уверены, что хотите удалить данного игрока с вашего аккаунта?') )
		return false;

		var container = jQuery(this).parents('.js-player:first');
		printLoad();

		jQuery.post('/ajax/playerdelete/',
		{
		'idP': container.attr('idPlayer'),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else{
			printMessage('success', data.success);
			container.remove();
		}
		},
		'json');
	});

	//при фокусе на текстарии с игроками - активировать кнопки сохранения и отмены
	jQuery('.js-sots-change').focus(function()
	{
		var container = jQuery(this).parents('.js-player:first');
		var buttons = container.find('.js-change-buttons');
		var cache = container.find('.js-sots-cache');

		if( buttons.is(":hidden") )
		{
		buttons.show();
		cache.val(jQuery(this).val());
		}
	});

	//откатить изменения в сотах игрока по нажатию на ссылку отмена
	jQuery('.js-sots-cancel').click(function()
	{
		var container = jQuery(this).parents('.js-player:first');
		container.find('.js-sots-change').val(container.find('.js-sots-cache').val());
		container.find('.js-change-buttons').hide();

		return false;
	});

	//сохранить изменения
	jQuery('.js-sots-save').click(function()
	{
		var container = jQuery(this).parents('.js-player:first');

		printLoad();
		jQuery.post('/ajax/changesots/',
		{
		'idP':  container.attr('idPlayer'),
		'sots': container.find('.js-sots-change').val(),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' ){
			printMessage('error', data.error);
		}else{
			printMessage('success', data.success);
			container.find('.js-change-buttons').hide();
			container.find('.js-sots-cache').val('');
		}
		},
		'json');

		return false;
	});

	//смена интервала проверки игрока
	jQuery(".js-change-interval-check").change(function()
	{
		printLoad();
		jQuery.post('/ajax/changeintervalcheck/',
		{
		'idP':  jQuery(this).parents('.js-player:first').attr('idPlayer'),
		'interval': jQuery(this).find('option:selected').val(),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

		//смена интервала оповещений игрока
	jQuery(".js-change-notify-interval").change(function()
	{
		printLoad();
		jQuery.post('/ajax/changeintervalnotify/',
		{
		'idP':  jQuery(this).parents('.js-player:first').attr('idPlayer'),
		'interval': jQuery(this).find('option:selected').val(),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

	//смена стартового урла
	jQuery(".js-change-url").change(function()
	{
		printLoad();
		jQuery.post('/ajax/starturl/',
		{
		'idU': jQuery(this).find('option:selected').val(),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

	//смени типа оповещений на аккаунте
	jQuery(".js-change-notify-type").change(function()
	{
		printLoad();
		jQuery.post('/ajax/change-notify-type/',
		{
		'type': jQuery(this).find('option:selected').val(),
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

	//вкл/выкл мониторинга
	jQuery(".js-monitoring-toggle").change(function()
	{
		printLoad();
		jQuery.post('/ajax/monitortoggle/',
		{
		'idP':  jQuery(this).parents('.js-player:first').attr('idPlayer'),
		'toggle': jQuery(this).is(':checked') ? 1 : 0,
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

	//вкл/выкл оповещений
	jQuery(".js-notify-toggle").change(function()
	{
		printLoad();
		jQuery.post('/ajax/notifytoggle/',
		{
		'idP':  jQuery(this).parents('.js-player:first').attr('idPlayer'),
		'toggle': jQuery(this).is(':checked') ? 1 : 0,
		'csrf': jQuery('#js-csrf-token').val(),
		'format': 'json'
		},
		function(data){
		if( typeof data.error != 'undefined' )
			printMessage('error', data.error);
		else
			printMessage('success', data.success);
		},
		'json');
	});

	});

function printLoad()
{
	jQuery(".js-ajax-result").html('<img src="/img/load.gif" />');
}

function printMessage(type, message)
{
	var container = jQuery(".js-ajax-result");
	if(type == 'error')
	{
	container.addClass('error');
	container.removeClass('success');
	container.html(message);
	}else if( type == 'success' ){
	container.removeClass('error');
	container.addClass('success');
	container.html(message);
	}
}