//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
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
	
	Если ЗначениеЗаполнено(Контекст.ТекущаяТабличнаяЧасть) Тогда
		ТекущаяЗапись = ДанныеСтроки(Контекст);
	Иначе
		ТекущаяЗапись = Контекст.Данные;
	КонецЕсли;
	
	ТекущаяЗапись.Вставить(ИмяРеквизита, Значение);
	
КонецПроцедуры

Процедура Фикция(Контекст, ИмяРеквизита, РеквизитыЗаполнения = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Контекст.ТекущаяТабличнаяЧасть) Тогда
		ОписаниеРеквизита = Контекст.Метаданные.ТабличныеЧасти[Контекст.ТекущаяТабличнаяЧасть][ИмяРеквизита];
		ТекущаяЗапись = ДанныеСтроки(Контекст);
	Иначе
		ОписаниеРеквизита = Контекст.Метаданные.Реквизиты[ИмяРеквизита];
		ТекущаяЗапись = Контекст.Данные;
	КонецЕсли;
	
	Значение = ЮТТестовыеДанныеСлужебный.Фикция(ОписаниеРеквизита.Тип, РеквизитыЗаполнения);
	ТекущаяЗапись.Вставить(ИмяРеквизита, Значение);
	
КонецПроцедуры

Процедура ФикцияОбязательныхПолей(Контекст) Экспорт
	
	Если ЗначениеЗаполнено(Контекст.ТекущаяТабличнаяЧасть) Тогда
		Реквизиты = Контекст.Метаданные.ТабличныеЧасти[Контекст.ТекущаяТабличнаяЧасть];
		ТекущаяЗапись = ДанныеСтроки(Контекст);
	Иначе
		Реквизиты = Контекст.Метаданные.Реквизиты;
		ТекущаяЗапись = Контекст.Данные;
	КонецЕсли;
	
	Для Каждого Элемент Из Реквизиты Цикл
		Реквизит = Элемент.Значение;
		Если Реквизит.Обязательный И НЕ Контекст.Данные.Свойство(Реквизит.Имя) Тогда
			Значение = ЮТТестовыеДанныеСлужебный.Фикция(Реквизит.Тип);
			ТекущаяЗапись.Вставить(Реквизит.Имя, Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ТабличнаяЧасть(Контекст, ИмяТабличнойЧасти) Экспорт
	
	Контекст.ТекущаяТабличнаяЧасть = ИмяТабличнойЧасти;
	Контекст.Данные.Вставить(ИмяТабличнойЧасти, Новый Массив());
	
КонецПроцедуры

Процедура ДобавитьСтроку(Контекст) Экспорт
	
	Запись = Новый Структура();
	ДанныеТабличнойЧасти(Контекст).Добавить(Запись);
	
КонецПроцедуры

Процедура УстановитьДополнительноеСвойство(Контекст, ИмяСвойства, Значение) Экспорт
	
	Контекст.ДополнительныеСвойства.Вставить(ИмяСвойства, Значение);
	
КонецПроцедуры

Функция Записать(Контекст, ВернутьОбъект = Ложь, ОбменДаннымиЗагрузка = Ложь) Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ДополнительныеСвойства = Контекст.ДополнительныеСвойства;
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = ОбменДаннымиЗагрузка;
	
	Ссылка = ЮТТестовыеДанныеВызовСервера.СоздатьЗапись(Контекст.Менеджер, Контекст.Данные, ПараметрыЗаписи, ВернутьОбъект);
	
	ЮТТестовыеДанныеСлужебный.ДобавитьТестовуюЗапись(Ссылка);
	
	Возврат Ссылка;
	
КонецФункции

Функция НовыйОбъект(Контекст) Экспорт
	
	Возврат ЮТТестовыеДанныеВызовСервера.НовыйОбъект(Контекст.Менеджер, Контекст.Данные, Контекст.ДополнительныеСвойства);
	
КонецФункции

Функция Провести(Контекст, ВернутьОбъект = Ложь) Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ДополнительныеСвойства = Контекст.ДополнительныеСвойства;
	ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение;
	
	Ссылка = ЮТТестовыеДанныеВызовСервера.СоздатьЗапись(Контекст.Менеджер, Контекст.Данные, ПараметрыЗаписи, ВернутьОбъект);
	
	ЮТТестовыеДанныеСлужебный.ДобавитьТестовуюЗапись(Ссылка);
	
	Возврат Ссылка;
	
КонецФункции

Функция ДанныеСтроки(Контекст) Экспорт
	
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

Функция ДанныеОбъекта(Контекст) Экспорт
	
	Возврат Контекст.Данные;
	
КонецФункции

// Инициализирует конструктор тестовых данных
// 
// Параметры:
//  Менеджер - Строка - Имя менеджера. Примеры: Справочники.Товары, Документы.ПриходТоваров
// 
// Возвращаемое значение:
//  ОбщийМодуль - Конструктор
Функция Инициализировать(Менеджер) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	Конструктор = Обработки.ЮТКонструкторТестовыхДанных.Создать();
#Иначе
	Конструктор = ПолучитьФорму("Обработка.ЮТКонструкторТестовыхДанных.Форма.КлиентскийКонструктор");
#КонецЕсли
	
	Конструктор.Инициализировать(Менеджер);
	
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
//  * Метаданные - см. ЮТМетаданные.ОписаниеОбъектМетаданных
//  * ТекущаяТабличнаяЧасть - Строка -
//  * ДополнительныеСвойства - Структура
Функция НовыйКонтекстКонструктора(Менеджер) Экспорт
	
	Контекст = Новый Структура("Менеджер, Данные, Метаданные", Менеджер, Новый Структура());
	Контекст.Вставить("Менеджер", Менеджер);
	Контекст.Вставить("Данные", Новый Структура());
	Контекст.Вставить("Метаданные", ЮТМетаданные.ОписаниеОбъектМетаданных(Менеджер));
	Контекст.Вставить("ТекущаяТабличнаяЧасть", "");
	Контекст.Вставить("ДополнительныеСвойства", Новый Структура());
	
	Возврат Контекст;
	
КонецФункции

Функция ДанныеТабличнойЧасти(Контекст)
	
	Возврат Контекст.Данные[Контекст.ТекущаяТабличнаяЧасть];
	
КонецФункции

#КонецОбласти
