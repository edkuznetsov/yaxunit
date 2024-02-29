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

// Модули подсистемы.
//  Возвращает список модулей подсистемы
//  Подсистема должна находится в подсистеме "ЮТДинамическиПодключаемые"
// Параметры:
//  ИмяПодсистемы - Строка - Имя подсистемы
//  Серверные - Булево - Возвращять модули доступные на сервере
//  Клиентские - Булево - Возвращять модули доступные на клиенте
// Возвращаемое значение:
//  Массив из Строка - Имена модулей входящих в подсистему
Функция МодулиПодсистемы(ИмяПодсистемы, Серверные = Истина, Клиентские = Истина) Экспорт
	
	Возврат ЮТМетаданныеПовтИсп.МодулиПодсистемы(ИмяПодсистемы, Серверные, Клиентские);
	
КонецФункции

// Описание объекта метаданных.
// 
// Параметры:
//  Значение - ОбъектМетаданных
//           - Тип - Тип объекта информационной базы
//           - Строка - Полное имя объекта метаданных
//           - см. ОписаниеОбъектаМетаданных
//           - Произвольный - Объект информационной базы
// 
// Возвращаемое значение:
//  Структура - Описание менеджера:
// * ОписаниеТипа - см. ЮТМетаданныеСервер.ОписаниеТипаМетаданных
// * Реквизиты - Структура из см. ЮТФабрика.ОписаниеРеквизита
// * ТабличныеЧасти - Структура из Структура -
Функция ОписаниеОбъектаМетаданных(Знач Значение) Экспорт
	
	ТипЗначения = ТипЗнч(Значение);
	
	Если ТипЗначения = Тип("Структура") И ЭтоОписаниеОбъектаМетаданных(Значение) Тогда
		//@skip-check constructor-function-return-section
		Возврат Значение;
	КонецЕсли;
	
	ТипТип = Тип("Тип");
#Если Сервер Тогда
	Если ТипЗначения = Тип("ОбъектМетаданных") Тогда
		Значение = Значение.ПолноеИмя();
		ТипЗначения = Тип("Строка");
	КонецЕсли;
#КонецЕсли
	
	Если ТипЗначения <> ТипТип И ТипЗначения <> Тип("Строка") Тогда
		Значение = ТипЗнч(Значение);
		ТипЗначения = ТипТип;
	КонецЕсли;
	
	Если ТипЗначения = ТипТип Тогда
		ИдентификаторТипа = ЮТТипыДанныхСлужебный.ИдентификаторТипа(Значение); // Для работы кэширования
		//@skip-check constructor-function-return-section
		Возврат ЮТМетаданныеПовтИсп.ОписаниеОбъектаМетаданныхПоИдентификаторуТипа(ИдентификаторТипа);
	Иначе
		//@skip-check constructor-function-return-section
		Возврат ЮТМетаданныеПовтИсп.ОписаниеОбъектаМетаданных(Значение);
	КонецЕсли;
	
КонецФункции

Функция НормализованноеИмяТаблицы(Значение) Экспорт
	
	Описание = ОписаниеОбъектаМетаданных(Значение);
	
	Возврат СтрШаблон("%1.%2", Описание.ОписаниеТипа.Имя, Описание.Имя);
	
КонецФункции

Функция ЭтоОписаниеОбъектаМетаданных(Параметры) Экспорт
	
	Возврат ЮТОбщий.ЭтаСтруктураИмеетТип(Параметры, "ОписаниеОбъектаМетаданных");
	
КонецФункции

Функция ТипыМетаданных() Экспорт
	
	Возврат ЮТМетаданныеПовтИсп.ТипыМетаданных();
	
КонецФункции

Функция ЭтоПеречисление(Значение) Экспорт
	
	Описание = ОписаниеОбъектаМетаданных(Значение);
	
	Возврат Описание <> Неопределено И Описание.ОписаниеТипа.Имя = "Перечисление";
	
КонецФункции

Функция РазрешеныСинхронныеВызовы() Экспорт
	
	Возврат ЮТМетаданныеПовтИсп.РазрешеныСинхронныеВызовы();
	
КонецФункции

// Возвращяет набор регистров движений документа
// 
// Параметры:
//  Документ - ОбъектМетаданных
//           - Тип - Тип объекта информационной базы
//           - Строка - Полное имя объекта метаданных
//           - см. ОписаниеОбъектаМетаданных
//           - ДокументСсылка, ДокументОбъект - Объект информационной базы
//           - ДокументМенеджер - Менеджер вида документа
// 
// Возвращаемое значение:
//  Структура - Регистры движений документа. Ключи - Имя регистра, Значение - Полное имя регистра
Функция РегистрыДвиженийДокумента(Документ) Экспорт
	
	ОписаниеОбъектаМетаданных = ОписаниеОбъектаМетаданных(Документ);
	
	ПолноеИмя = СтрШаблон("%1.%2", ОписаниеОбъектаМетаданных.ОписаниеТипа.ИмяКоллекции, ОписаниеОбъектаМетаданных.Имя);
	
	Возврат ЮТМетаданныеПовтИсп.РегистрыДвиженийДокумента(ПолноеИмя);
	
КонецФункции

#КонецОбласти
