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

#Область СлужебныйПрограммныйИнтерфейс

Процедура Установить(Контекст, ИмяРеквизита, Значение) Экспорт
	
	ОписаниеРеквизита(Контекст, ИмяРеквизита); // Проверка наличия реквизита
	
	ТекущаяЗапись = ТекущаяЗапись(Контекст);
	ТекущаяЗапись.Вставить(ИмяРеквизита, Значение);
	
КонецПроцедуры

Процедура УстановитьРеквизиты(Контекст, ЗначенияРеквизитов) Экспорт
	
	ТекущаяЗапись = ТекущаяЗапись(Контекст);
	Для Каждого ЗначениеРеквизита Из ЗначенияРеквизитов Цикл
		
		ОписаниеРеквизита(Контекст, ЗначениеРеквизита.Ключ);
		ТекущаяЗапись.Вставить(ЗначениеРеквизита.Ключ, ЗначениеРеквизита.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Фикция(Контекст, ИмяРеквизита, РеквизитыЗаполнения, Знач ОграничениеТипа) Экспорт
	
	ЮТПроверкиСлужебный.ПроверитьТипПараметра(ОграничениеТипа, "Тип, ОписаниеТипов, Строка", "Фикция", "ЮТКонструкторТестовыхДанных", Истина);
	
	ТекущаяЗапись = ТекущаяЗапись(Контекст);
	ОписаниеРеквизита = ОписаниеРеквизита(Контекст, ИмяРеквизита);
	
	Если ОграничениеТипа <> Неопределено Тогда
		ПолноеИмяРеквизита = ЮТСтроки.ДобавитьСтроку(Контекст.ТекущаяТабличнаяЧасть, ИмяРеквизита, ".");
		ТипЗначения = ПересечениеТипов(ОписаниеРеквизита.Тип, ОграничениеТипа, ПолноеИмяРеквизита);
	Иначе
		ТипЗначения = ОписаниеРеквизита.Тип;
	КонецЕсли;
	
	Значение = ЮТТестовыеДанныеСлужебный.Фикция(ТипЗначения, РеквизитыЗаполнения);
	ТекущаяЗапись.Вставить(ИмяРеквизита, Значение);
	
КонецПроцедуры

Процедура ФикцияОбязательныхПолей(Контекст) Экспорт
	
	Реквизиты = Реквизиты(Контекст);
	ТекущаяЗапись = ТекущаяЗапись(Контекст);
	
	ОписаниеРеквизитов = Новый Структура;
	Для Каждого Элемент Из Реквизиты Цикл
		Реквизит = Элемент.Значение;
		Если Реквизит.Обязательный И НЕ ТекущаяЗапись.Свойство(Реквизит.Имя) Тогда
			ОписаниеРеквизитов.Вставить(Реквизит.Имя, Реквизит.Тип);
		КонецЕсли;
	КонецЦикла;
	
	ФикцияРеквизитовЗаписи(ТекущаяЗапись, ОписаниеРеквизитов);
	
КонецПроцедуры

Процедура ФикцияРеквизитов(Контекст, ИменаРеквизитов) Экспорт
	
	ТекущаяЗапись = ТекущаяЗапись(Контекст);
	ОписаниеРеквизитов = Новый Структура;
	
	Если ТипЗнч(ИменаРеквизитов) = Тип("Строка") Тогда
		КоллекцияИменРеквизитов = ЮТСтроки.РазделитьСтроку(ИменаРеквизитов, ",");
	Иначе
		КоллекцияИменРеквизитов = ИменаРеквизитов;
	КонецЕсли;
	
	Для Каждого ИмяРеквизита Из КоллекцияИменРеквизитов Цикл
		Реквизит = ОписаниеРеквизита(Контекст, ИмяРеквизита);
		ОписаниеРеквизитов.Вставить(ИмяРеквизита, Реквизит.Тип);
	КонецЦикла;
	
	ФикцияРеквизитовЗаписи(ТекущаяЗапись, ОписаниеРеквизитов);
	
КонецПроцедуры

Процедура ТабличнаяЧасть(Контекст, ИмяТабличнойЧасти) Экспорт
	
	Контекст.ТекущаяТабличнаяЧасть = ИмяТабличнойЧасти;
	
	Если ИмяТабличнойЧасти <> Неопределено Тогда
		Контекст.Данные.Вставить(ИмяТабличнойЧасти, Новый Массив());
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтроку(Контекст, ЗначенияРеквизитов) Экспорт
	
	Запись = Новый Структура();
	ДанныеТабличнойЧасти(Контекст).Добавить(Запись);
	
	Если ЗначенияРеквизитов <> Неопределено Тогда
		УстановитьРеквизиты(Контекст, ЗначенияРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьДополнительноеСвойство(Контекст, ИмяСвойства, Значение = Неопределено) Экспорт
	
	Контекст.ДополнительныеСвойства.Вставить(ИмяСвойства, Значение);
	
КонецПроцедуры

Процедура УстановитьСсылкуНового(Контекст, Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
		УникальныйИдентификаторСсылки = Значение;
	ИначеЕсли ЮТСтроки.ЭтоУникальныйИдентификаторСтрокой(Значение) Тогда
		УникальныйИдентификаторСсылки = Новый УникальныйИдентификатор(Значение);
	Иначе
		ВызватьИсключение "Неправильный тип значения для ссылки нового";
	КонецЕсли;
	
	Контекст.УникальныйИдентификаторСсылки = УникальныйИдентификаторСсылки;
	
КонецПроцедуры

Функция Записать(Контекст, ВернутьОбъект = Ложь, ОбменДаннымиЗагрузка = Ложь) Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ДополнительныеСвойства = Контекст.ДополнительныеСвойства;
	ПараметрыЗаписи.УникальныйИдентификаторСсылки = Контекст.УникальныйИдентификаторСсылки;
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = ОбменДаннымиЗагрузка;
	
	Ссылка = ЮТТестовыеДанныеСлужебный.СоздатьЗапись(Контекст.Менеджер, Контекст.Данные, ПараметрыЗаписи, ВернутьОбъект);
	
	Возврат Ссылка;
	
КонецФункции

Функция НовыйОбъект(Контекст) Экспорт
	
	Возврат ЮТТестовыеДанныеСлужебный.НовыйОбъект(Контекст.Менеджер,
												  Контекст.Данные,
												  Контекст.ДополнительныеСвойства,
												  Контекст.УникальныйИдентификаторСсылки);
	
КонецФункции

Функция Провести(Контекст, ВернутьОбъект = Ложь) Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ДополнительныеСвойства = Контекст.ДополнительныеСвойства;
	ПараметрыЗаписи.УникальныйИдентификаторСсылки = Контекст.УникальныйИдентификаторСсылки;
	ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение;
	
	Ссылка = ЮТТестовыеДанныеСлужебный.СоздатьЗапись(Контекст.Менеджер, Контекст.Данные, ПараметрыЗаписи, ВернутьОбъект);
	
	Возврат Ссылка;
	
КонецФункции

Функция ДанныеСтрокиТабличнойЧасти(Контекст) Экспорт
	
	Если ПустаяСтрока(Контекст.ТекущаяТабличнаяЧасть) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеТабличнойЧасти = ДанныеТабличнойЧасти(Контекст);
	
	Если ДанныеТабличнойЧасти.Количество() Тогда
		Возврат ДанныеТабличнойЧасти[ДанныеТабличнойЧасти.ВГраница()];
	Иначе
		ВызватьИсключение "Сначала необходимо добавить строку табличной части";
	КонецЕсли;
	
КонецФункции

Функция ДанныеСтрокиКоллекции(Контекст) Экспорт
	
	Если ЗначениеЗаполнено(Контекст.Данные) Тогда
		Возврат Контекст.Данные[Контекст.Данные.ВГраница()];
	Иначе
		ВызватьИсключение "Сначала необходимо добавить строку";
	КонецЕсли;
	
КонецФункции

Функция ДанныеОбъекта(Контекст) Экспорт
	
	Возврат Контекст.Данные;
	
КонецФункции

// Инициализирует конструктор тестовых данных
// 
// Параметры:
//  Менеджер - Строка - Имя менеджера. Примеры: Справочники.Товары, Документы.ПриходТоваров
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторТестовыхДанных
Функция Инициализировать(Менеджер) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	Конструктор = Обработки.ЮТКонструкторТестовыхДанных.Создать();
#Иначе
	//@skip-check use-non-recommended-method
	Конструктор = ПолучитьФорму("Обработка.ЮТКонструкторТестовыхДанных.Форма.КлиентскийКонструктор"); // BSLLS:GetFormMethod-off
#КонецЕсли
	
	//@skip-check unknown-method-property
	Конструктор.Инициализировать(Менеджер);
	
	Возврат Конструктор;
	
КонецФункции

Функция ИнициализироватьКонструкторДвижений(Документ, ИмяРегистра) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	Конструктор = Обработки.ЮТКонструкторДвижений.Создать();
#Иначе
	//@skip-check use-non-recommended-method
	Конструктор = ПолучитьФорму("Обработка.ЮТКонструкторДвижений.Форма.КлиентскийКонструктор"); // BSLLS:GetFormMethod-off
#КонецЕсли
	
	//@skip-check unknown-method-property
	Конструктор.Инициализировать(Документ, ИмяРегистра);
	
	Возврат Конструктор;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Новый контекст конструктора.
// 
// Параметры:
//  Менеджер - Произвольный
// 
// Возвращаемое значение:
//  Структура - Новый контекст конструктора:
//  * Менеджер - Произвольный
//  * Данные - Структура
//  * Метаданные - см. ЮТМетаданные.СтруктураОписанияОбъектаМетаданных
//  * ТекущаяТабличнаяЧасть - Строка
//  * ДополнительныеСвойства - Структура
//  * УникальныйИдентификаторСсылки - УникальныйИдентификатор
//							  		- Неопределено
Функция НовыйКонтекстКонструктора(Менеджер) Экспорт
	
	Контекст = Новый Структура();
	Контекст.Вставить("Менеджер", Менеджер);
	Контекст.Вставить("Данные", Новый Структура());
	Контекст.Вставить("Метаданные", ЮТМетаданные.ОписаниеОбъектаМетаданных(Менеджер));
	Контекст.Вставить("ТекущаяТабличнаяЧасть", "");
	Контекст.Вставить("ДополнительныеСвойства", Новый Структура());
	Контекст.Вставить("УникальныйИдентификаторСсылки", Неопределено);
	
	//@skip-check constructor-function-return-section
	Возврат Контекст;
	
КонецФункции

Функция НовыйКонтекстКонструктораДвижений(Документ, ИмяРегистра) Экспорт
	
	ОписаниеРегистра = ЮТМетаданные.ОписаниеРегистраДвиженийДокумента(Документ, ИмяРегистра);
	
	Если ОписаниеРегистра = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Документ %1 не делает движений по регистру ""%2""", Документ, ИмяРегистра);
	КонецЕсли;
	
	Контекст = Новый Структура();
	Контекст.Вставить("Данные", Новый Массив());
	Контекст.Вставить("Метаданные", ОписаниеРегистра);
	Контекст.Вставить("ДополнительныеСвойства", Новый Структура());
	
	//@skip-check constructor-function-return-section
	Возврат Контекст;
	
КонецФункции

Функция ДанныеТабличнойЧасти(Контекст)
	
	Возврат Контекст.Данные[Контекст.ТекущаяТабличнаяЧасть];
	
КонецФункции

Функция ПересечениеТипов(Знач ОписаниеТипов, Знач ОграничениеТипов, ИмяРеквизита)
	
	ТипОграничения = ТипЗнч(ОграничениеТипов);
	
	Если ТипОграничения = Тип("Строка") Тогда
		ОграничениеТипов = Новый ОписаниеТипов(ОграничениеТипов);
		ТипОграничения = Тип("ОписаниеТипов");
	КонецЕсли;
	
	Если ТипОграничения = Тип("Тип") И ОписаниеТипов.СодержитТип(ОграничениеТипов) И ОграничениеТипов <> Тип("Неопределено") Тогда
		Результат = ЮТКоллекции.ЗначениеВМассиве(ОграничениеТипов);
	ИначеЕсли ТипОграничения = Тип("ОписаниеТипов") Тогда
		Результат = ЮТКоллекции.ПересечениеМассивов(ОписаниеТипов.Типы(), ОграничениеТипов.Типы());
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		
		Сообщение = СтрШаблон("Исправьте ограничение типов для реквизита `%1` (`%2`), оно не входит в множество типов реквизита (`%3`)",
							  ИмяРеквизита,
							  ОграничениеТипов,
							  ОписаниеТипов);
		ВызватьИсключение Сообщение;
		
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов(Результат,
								ОписаниеТипов.КвалификаторыЧисла,
								ОписаниеТипов.КвалификаторыСтроки,
								ОписаниеТипов.КвалификаторыДаты,
								ОписаниеТипов.КвалификаторыДвоичныхДанных);
	
КонецФункции

Функция Реквизиты(Контекст)
	
	Если ФокусНаТабличнойЧасти(Контекст) Тогда
		Возврат Контекст.Метаданные.ТабличныеЧасти[Контекст.ТекущаяТабличнаяЧасть];
	Иначе
		Возврат Контекст.Метаданные.Реквизиты;
	КонецЕсли;
	
КонецФункции

Функция ОписаниеРеквизита(Контекст, ИмяРеквизита)
	
	Реквизиты = Реквизиты(Контекст);
	
	Если НЕ Реквизиты.Свойство(ИмяРеквизита) Тогда
		ИмяОсновнойТаблицы = ЮТМетаданные.НормализованноеИмяТаблицы(Контекст.Метаданные);
		Если ФокусНаТабличнойЧасти(Контекст) Тогда
			Пояснение = СтрШаблон("Табличная часть `%1.%2` не содержит реквизит `%3`", ИмяОсновнойТаблицы, Контекст.ТекущаяТабличнаяЧасть, ИмяРеквизита);
		Иначе
			Пояснение = СтрШаблон("`%1` не содержит реквизит `%2`", ИмяОсновнойТаблицы, ИмяРеквизита);
		КонецЕсли;
		
		ВызватьИсключение Пояснение;
	КонецЕсли;
	
	Возврат Реквизиты[ИмяРеквизита];
	
КонецФункции

Функция ТекущаяЗапись(Контекст)
	
	Если ФокусНаТабличнойЧасти(Контекст) Тогда
		Возврат ДанныеСтрокиТабличнойЧасти(Контекст);
	ИначеЕсли ЭтоКонструкторКоллекции(Контекст) Тогда
		Возврат ДанныеСтрокиКоллекции(Контекст);
	Иначе
		Возврат Контекст.Данные;
	КонецЕсли;
	
КонецФункции

Процедура ФикцияРеквизитовЗаписи(ТекущаяЗапись, ОписаниеРеквизитов)
	
	ЗначенияРеквизитов = ЮТТестовыеДанныеСлужебный.ФикцияЗначений(ОписаниеРеквизитов);
	ЮТКоллекции.ДополнитьСтруктуру(ТекущаяЗапись, ЗначенияРеквизитов);
	
КонецПроцедуры

Функция ФокусНаТабличнойЧасти(Контекст)
	
	Возврат Контекст.Свойство("ТекущаяТабличнаяЧасть") И ЗначениеЗаполнено(Контекст.ТекущаяТабличнаяЧасть);
	
КонецФункции

Функция ЭтоКонструкторКоллекции(Контекст)
	
	Возврат ЮТТипыДанныхСлужебный.ЭтоМассив(ТипЗнч(Контекст.Данные));
	
КонецФункции

#КонецОбласти
