//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область ПрограммныйИнтерфейс

#Область НастройкиТеста

// Возвращает значение настройки "ВТранзакции" для текущего исполняемого объекта (тест, набор, модуль)
// 
// Возвращаемое значение:
//  Булево
Функция ВТранзакции() Экспорт
	
	ИмяПараметра = ЮТФабрика.ПараметрыИсполненияТеста().ВТранзакции;
	
	Возврат ЗначениеНастройкиТеста(ИмяПараметра, Ложь);
	
КонецФункции

// Возвращает значение настройки "УдалениеТестовыхДанных" для текущего исполняемого объекта (тест, набор, модуль)
// 
// Возвращаемое значение:
//  Булево
Функция УдалениеТестовыхДанных() Экспорт
	
	ИмяПараметра = ЮТФабрика.ПараметрыИсполненияТеста().УдалениеТестовыхДанных;
	
	Возврат ЗначениеНастройкиТеста(ИмяПараметра, Ложь);
	
КонецФункции

// Возвращает значение настройки "Перед" для текущего исполняемого объекта (тест, набор, модуль)
// Возвращает имя назначенного обработчика события (имя метода) "Перед".
// 
// Возвращаемое значение:
//  Строка
Функция Перед() Экспорт
	
	ИмяПараметра = ЮТФабрика.ПараметрыИсполненияТеста().Перед;
	
	Возврат ЗначениеНастройкиТеста(ИмяПараметра, "", Истина);
	
КонецФункции

// Возвращает значение настройки "После" для текущего исполняемого объекта (тест, набор, модуль)
// Возвращает имя назначенного обработчика события (имя метода) "После".
// 
// Возвращаемое значение:
//  Строка
Функция После() Экспорт
	
	ИмяПараметра = ЮТФабрика.ПараметрыИсполненияТеста().После;
	
	Возврат ЗначениеНастройкиТеста(ИмяПараметра, "", Истина);
	
КонецФункции

// Возвращает значение произвольной настройки для текущего исполняемого объекта (тест, набор, модуль)
// 
// Параметры:
//  ИмяНастройки - Строка - Имя настройки, см. ЮТФабрика.ПараметрыИсполненияТеста
//  ЗначениеПоУмолчанию - Произвольный - Значение по умолчанию
//  СтрогийУровеньИсполнения - Булево - Признак, стоит ли проверять наличие настройки у родительских элементов.
//  									Ложь - По умолчанию, будет выполнен поиск и получение значения для родителей (набор, модуль), 
//  									       если значения для текущего элемента не установлено.
//  									Истина - Получение настройки только для текущего элемента.
// 
// Возвращаемое значение:
//  Произвольный, Неопределено, Булево, Строка - Значение настройки теста
Функция ЗначениеНастройкиТеста(ИмяНастройки, ЗначениеПоУмолчанию, СтрогийУровеньИсполнения = Ложь) Экспорт
	
	Значение = ЗначениеПоУмолчанию;
	КонтекстИсполнения = ЮТКонтекстСлужебный.КонтекстИсполнения();
	
	Если СтрогийУровеньИсполнения Тогда
		
		ТекущийКонтекстИсполнения = ЮТКонтекстСлужебный.КонтекстИсполненияТекущегоУровня();
		
		Если ТекущийКонтекстИсполнения <> Неопределено Тогда
			Значение = ЮТКоллекции.ЗначениеСтруктуры(ТекущийКонтекстИсполнения.НастройкиВыполнения, ИмяНастройки, ЗначениеПоУмолчанию);
		КонецЕсли;
		
	ИначеЕсли КонтекстИсполнения.Тест <> Неопределено И КонтекстИсполнения.Тест.НастройкиВыполнения.Свойство(ИмяНастройки) Тогда
		
		Значение = КонтекстИсполнения.Тест.НастройкиВыполнения[ИмяНастройки];
		
	ИначеЕсли КонтекстИсполнения.Набор <> Неопределено И КонтекстИсполнения.Набор.НастройкиВыполнения.Свойство(ИмяНастройки) Тогда
		
		Значение = КонтекстИсполнения.Набор.НастройкиВыполнения[ИмяНастройки];
		
	ИначеЕсли КонтекстИсполнения.Модуль <> Неопределено И КонтекстИсполнения.Модуль.НастройкиВыполнения.Свойство(ИмяНастройки) Тогда
		
		Значение = КонтекстИсполнения.Модуль.НастройкиВыполнения[ИмяНастройки];
		
	Иначе
		
		ГлобальныеНастройки = ЮТКонтекстСлужебный.ГлобальныеНастройкиВыполнения();
		
		Если ГлобальныеНастройки.Свойство(ИмяНастройки) Тогда
			Значение = ГлобальныеНастройки[ИмяНастройки];
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#Область НастройкиСеанса

// Возвращает глобальные настройки выполнения, указанные в файле настроек запуска, объект`settings`
// 
// Возвращаемое значение:
//  Структура, Неопределено - Глобальные настройки
Функция ГлобальныеНастройкиВыполнения() Экспорт
	
	//@skip-check constructor-function-return-section
	Возврат ЮТКонтекстСлужебный.ГлобальныеНастройкиВыполнения();
	
КонецФункции

// Возвращает путь к каталогу проекта, указанному в файле настроек - `projectPath`
// 
// Возвращаемое значение:
//  Строка - Каталог проекта
Функция КаталогПроекта() Экспорт
	
	Возврат ЮТКонтекстСлужебный.ПараметрыЗапуска().projectPath;
	
КонецФункции

#КонецОбласти

#КонецОбласти
