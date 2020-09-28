
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьПредварительныеНастройки();

КонецПроцедуры


&НаСервере
Процедура ИнициализироватьПредварительныеНастройки()
	Перем ПараметрыРедакторФорм;
	Перем ОбработкаОбъект;
	Перем ПустоеДеревоЭлементов;
	Перем ПустаяТаблицаКоманд;
	Перем ПустоеДеревоРеквизитов;
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ПустоеДеревоЭлементов = ОбработкаОбъект.ДеревоЭлементов.Скопировать();
	ПустоеДеревоЭлементов.Строки.Очистить();
	ПустоеДеревоРеквизитов = ОбработкаОбъект.ДеревоРеквизитов.Скопировать();
	ПустоеДеревоРеквизитов.Строки.Очистить();
	ПустаяТаблицаКоманд = ОбработкаОбъект.ТаблицаКоманд.ВыгрузитьКолонки();

	ПараметрыРедакторФорм = Новый Структура;
	ПараметрыРедакторФорм.Вставить("СоответствиеТекстовыхПредставлений", ОбработкаОбъект.НовоеСоответствиеТекстовыхПредставлений());
	ПараметрыРедакторФорм.Вставить("СоответствиеПредставленийТипов", ОбработкаОбъект.НовоеСоответствиеПредставленийТипов());
	ПараметрыРедакторФорм.Вставить("ДеревоЭлементов", ПустоеДеревоЭлементов);
	ПараметрыРедакторФорм.Вставить("ДеревоРеквизитов", ПустоеДеревоРеквизитов);
	ПараметрыРедакторФорм.Вставить("ТаблицаКоманд", ПустаяТаблицаКоманд);
	
	Объект.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыРедакторФорм, ЭтаФорма.УникальныйИдентификатор);
	Объект.ИмяВременногоФайла = ПолучитьИмяВременногоФайла(); 
	Объект.ИмяПодключеннойОбработки = ОбработкаОбъект.ИспользуемоеИмяФайла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "SRVR=") Тогда
		//Положить обработку в хранилище и подключить
		Объект.АдресДанныхФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Объект.ИмяПодключеннойОбработки),ЭтаФорма.УникальныйИдентификатор);
		ПодключитьОбработкуНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеречитатьФорму(Команда)
	
	Если ЗначениеЗаполнено(ФормаАнализируемая) Тогда
		ИнициализироватьПредварительныеНастройки();
		ПодготовитьДанныеИзФормы(ФормаАнализируемая);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовДереваРеквизитов

&НаКлиенте
Процедура ОбъектДеревоРеквизитовВыбранПриИзменении(Элемент)
	
	ИдентификаторыВыбранныхРеквизитов = Новый Массив();
	
		Для Каждого Строка Из Объект.ДеревоРеквизитов.ПолучитьЭлементы() Цикл 
			   
			Если Строка.Выбран Тогда
				ИдентификаторыВыбранныхРеквизитов.Добавить(Строка.ПолучитьИдентификатор());
			КонецЕсли; 
				
				Для Каждого СтрокаОбъект Из Строка.ПолучитьЭлементы() Цикл    	
					
					Если СтрокаОбъект.Выбран Тогда
						ИдентификаторыВыбранныхРеквизитов.Добавить(СтрокаОбъект.ПолучитьИдентификатор());
					КонецЕсли; 
											
						Для Каждого СтрокаФормы Из СтрокаОбъект.ПолучитьЭлементы() Цикл 
							   
							Если СтрокаФормы.Выбран Тогда	
								ИдентификаторыВыбранныхРеквизитов.Добавить(СтрокаФормы.ПолучитьИдентификатор());	
							КонецЕсли;
							 
						КонецЦикла;				
				КонецЦикла;			
		КонецЦикла;
		
		Объект.ТекстДобавленияРеквизитов = "";
		ТекстИнициализироватьМассив = "НовыеРеквизитыФормы = Новый Массив;" + Символы.ПС + Символы.ПС;
		ТекстИзменитьРеквизитыФормы = "Форма.ИзменитьРеквизиты(НовыеРеквизитыФормы);";
		ТекстДобавитьВМассив = "НовыеРеквизитыФормы.Добавить(НовыйРеквизит);";
		ШаблонРеквизитыПрограммно = "%1
		|%2";
		ТекстРеквизитыПрограммно = ШаблонРеквизитыПрограммно;
		
		Если ИдентификаторыВыбранныхРеквизитов.Количество() > 0 Тогда
			
				
			Для Каждого Идентификатор Из ИдентификаторыВыбранныхРеквизитов Цикл
				ЭлементРеквизита = Объект.ДеревоРеквизитов.НайтиПоИдентификатору(Идентификатор);
				
				ШаблонРеквизита = ШаблонРеквизитыПрограммно + Символы.ПС;
				ТекстДобавления = СтрШаблон(ШаблонРеквизита, ЭлементРеквизита.ТекстСоздания, ТекстДобавитьВМассив);
				ТекстРеквизитыПрограммно = СтрШаблон(ТекстРеквизитыПрограммно, ТекстДобавления, ШаблонРеквизитыПрограммно);
			КонецЦикла;	
			
			Объект.ТекстДобавленияРеквизитов = ТекстИнициализироватьМассив + СтрШаблон(ТекстРеквизитыПрограммно, ТекстИзменитьРеквизитыФормы, "");

		КонецЕсли;
		
		ОбновитьОбщийТекстПрограмногоДобаления();
		
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьОбщийТекстПрограмногоДобаления()
	Объект.ТекстПрограммногоДобавления = Объект.ТекстДобавленияРеквизитов;
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ФормаАнализируемаяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборФормыАнализируемойЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФормаИмяОбъекта", ФормаИмяОбъекта);
	ПараметрыОткрытия.Вставить("ФормаТипОбъекта", ФормаТипОбъекта);
	ПараметрыОткрытия.Вставить("ФормаИмяФормы", ФормаИмяФормы);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", ФормаАнализируемая);	
	
	ОткрытьФорму("ВнешняяОбработка.FormGenerator.Форма.ФормаВыбораФормы", ПараметрыОткрытия, Элемент, , , , ОповещениеВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ВыборФормыАнализируемойЗавершение(Результат, Параметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ФормаАнализируемая = Результат.ПолныйПутьКФорме;
		ФормаТипОбъекта = Результат.ТипОбъекта;
		ФормаИмяОбъекта = Результат.ИмяОбъекта;
		ФормаИмяФормы = Результат.ИмяФормы;
		
		ПодготовитьДанныеИзФормы(ФормаАнализируемая);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодготовитьДанныеИзФормы(ПолныйПутьКФорме)
	
		ПараметрыПолученияДанных = Новый Структура();
		ПараметрыПолученияДанных.Вставить("АдресВоВременномХранилище", Объект.АдресВоВременномХранилище);
		ПараметрыПолученияДанных.Вставить("ИмяПодключеннойОбработки", Объект.ИмяПодключеннойОбработки);
		ПараметрыПолученияДанных.Вставить("ИмяВременногоФайла", Объект.ИмяВременногоФайла);
		
		ПараметрыФормы = Новый Структура("РедакторФорм", ПараметрыПолученияДанных);
		
		Объект.ПолныйПутьКФорме = ПолныйПутьКФорме;
		ПолучитьФорму(ПолныйПутьКФорме, ПараметрыФормы);
		
		ЗаполнитьДанныеПоХранилищу();
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоХранилищу() Экспорт

    ФайлСДанными = Новый Файл(Объект.ИмяВременногоФайла);
    
    Если ФайлСДанными.Существует() Тогда
		ПараметрыРедакторФорм = ЗначениеИзФайла(Объект.ИмяВременногоФайла);
		УдалитьФайлы(Объект.ИмяВременногоФайла);
		//ЭтотОбъект.ДеревоЭлементов = ПараметрыРедакторФорм.ДеревоЭлементов;
		ЗначениеВРеквизитФормы(ПараметрыРедакторФорм.ДеревоРеквизитов, "Объект.ДеревоРеквизитов");
		ЗначениеВРеквизитФормы(ПараметрыРедакторФорм.ДеревоЭлементов, "Объект.ДеревоЭлементов");		
		//Объект.ДеревоРеквизитов = ПараметрыРедакторФорм.ДеревоРеквизитов;
		//ЭтотОбъект.ТаблицаКоманд.Загрузить(ПараметрыРедакторФорм.ТаблицаКоманд);
	Иначе
		Сообщить("Заполнение не выполнено!
		|Необходимо разместить в процедуре ""ПриСозданииНаСервере()""
		|модуля формы """+Объект.ПолныйПутьКФорме+""" следующий код:
		|
	    |Если ЭтаФорма.Параметры.Свойство(""РедакторФорм"") Тогда
		|     ВнешниеОбработки.Создать(ЭтаФорма.Параметры.РедакторФорм.ИмяПодключеннойОбработки,Ложь).ПодготовитьДанныеАнализируемойФормы(ЭтаФорма);
        |КонецЕсли;"); 

		//Сообщить("Файл "+ЭтотОбъект.ИмяВременногоФайла+" не существует!");
	КонецЕсли;

	//ПоместитьПустыеДанныеВХранилище();	
	
	//АдресХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ЭтотОбъект.ИспользуемоеИмяФайла));
	//ЭтотОбъект.ИмяПодключеннойОбработки = ВнешниеОбработки.Подключить(АдресХранилища,Строка(Новый УникальныйИдентификатор)); 	

КонецПроцедуры

&НаСервере
Процедура ПодключитьОбработкуНаСервере()
	Объект.ИмяПодключеннойОбработки = ВнешниеОбработки.Подключить(Объект.АдресДанныхФайлаВоВременномХранилище, , Ложь);
КонецПроцедуры


		
#КонецОбласти