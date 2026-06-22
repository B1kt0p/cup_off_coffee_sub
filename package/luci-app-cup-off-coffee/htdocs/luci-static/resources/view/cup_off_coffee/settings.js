'use strict';
'require view';
'require form';
'require fs';
'require ui';

return view.extend({
	render: function() {
		var m = new form.Map('cup_off_coffee', _('Cup of Coffee'));
		var s = m.section(form.NamedSection, 'main', 'subscription', _('Подписка'));
		var o;

		o = s.option(form.Flag, 'enabled', _('Включить автоматическое обновление'));
		o.rmempty = false;

		o = s.option(form.Value, 'url', _('Ссылка на подписку'));
		o.datatype = 'url';
		o.password = true;
		o.rmempty = false;
		o.placeholder = 'https://example.com/subscription/token';

		o = s.option(form.Value, 'update_times', _('Время обновления'));
		o.default = '05:00';
		o.rmempty = false;
		o.placeholder = '05:00 13:30 21:00';
		o.description = _('Укажите одно или несколько значений в формате ЧЧ:ММ через пробел. Например: 05:00 13:30 21:00.');
		o.validate = function(section_id, value) {
			var values = String(value || '').trim().split(/\s+/);

			if (!values.length || !values[0])
				return _('Укажите хотя бы одно время обновления.');

			for (var i = 0; i < values.length; i++)
				if (!/^([01][0-9]|2[0-3]):([0-5][0-9])$/.test(values[i]))
					return _('Используйте 24-часовой формат ЧЧ:ММ и разделяйте значения пробелами.');

			return true;
		};

		o = s.option(form.Flag, 'run_on_start', _('Обновлять при запуске службы'));
		o.default = '1';
		o.rmempty = false;

		o = s.option(form.Button, '_update', _('Обновить сейчас'));
		o.inputstyle = 'apply';
		o.onclick = function() {
			return fs.exec('/usr/bin/cup_off_coffee-update', []).then(function(res) {
				if (res.code !== 0)
					throw new Error(res.stderr || res.stdout || _('Не удалось обновить подписку'));
				ui.addNotification(null, E('p', {}, res.stdout || _('Подписка обновлена.')), 'info');
			}).catch(function(err) {
				ui.addNotification(null, E('p', {}, err.message), 'error');
			});
		};

		return m.render();
	}
});
