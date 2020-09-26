#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    // Создание и заполнение "обычного" объекта прикладного типа ДеревоЗначений,
    // который будет отображен на управляемой форме
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище("",ЭтаФорма.УникальныйИдентификатор);
	
	ОбработкаОбъект.ЗаполнитьДеревоФорм();

    // Преобразование объекта прикладного типа ДеревоЗначений 
    // в реквизит управляемой формы (данные формы)
    ЗначениеВРеквизитФормы(ОбработкаОбъект,"Объект");
	
	СтраницаРазработки = "http://infostart.ru/public/304736/";
	

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Только для серверного варианта
	Если Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "SRVR=") Тогда
		//Положить обработку в хранилище и подключить
		Объект.АдресДанныхФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Объект.ИмяПодключеннойОбработки),ЭтаФорма.УникальныйИдентификатор);
		ПодключитьОбработкуНаСервере();
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура СтраницаРазработкиНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    ЗапуститьПриложение(СтраницаРазработки);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоХранилищуНаСервере()

		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.ЗаполнитьДанныеПоХранилищу();
		ЗначениеВРеквизитФормы(ОбработкаОбъект,"Объект");
		
КонецПроцедуры // ЗаполнитьДанныеПоХранилищу()
	
#КонецОбласти 

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура ДеревоЭлементовФормыПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.ДеревоЭлементов.ТекущиеДанные;
	Если ТекущаяСтрока<>Неопределено Тогда
		ТекстФормированияЭлементов = ТекущаяСтрока.ТекстСоздания;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРеквизитовПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.ДеревоРеквизитов.ТекущиеДанные;
	Если ТекущаяСтрока<>Неопределено Тогда
	ТекстФормированияЭлементов = ТекущаяСтрока.ТекстСоздания;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомандПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.ТаблицаКоманд.ТекущиеДанные;
	Если ТекущаяСтрока<>Неопределено Тогда
	ТекстФормированияЭлементов = ТекущаяСтрока.ТекстСоздания;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	ТекСтрока = Объект.ДеревоФорм.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если НЕ ПустаяСтрока(ТекСтрока.ПолныйПутьКФорме) Тогда
		//Имя справочника, имя документа, ....
		РодительФормы = ТекСтрока.ПолучитьРодителя();
		//Справочник, документ,....
		ТипОбъекта = РодительФормы.ПолучитьРодителя();
		
		СтруктИнфыОМетаданном = Новый Структура;
		СтруктИнфыОМетаданном.Вставить("ТипОбъекта",ТипОбъекта.Имя);
		СтруктИнфыОМетаданном.Вставить("ИмяОбъекта",РодительФормы.Имя);
		СтруктИнфыОМетаданном.Вставить("ИмяФормы",ТекСтрока.Имя);
		
		//Объект.ПолноеИмяФормы = ТекСтрока.ПолныйПутьКФорме;
		
		ДекомпиляцияЭлементов = Новый Структура("АдресВоВременномХранилище,ИмяПодключеннойОбработки,ИмяВременногоФайла",Объект.АдресВоВременномХранилище,Объект.ИмяПодключеннойОбработки,Объект.ИмяВременногоФайла);
		ПараметрыФормы = Новый Структура("ДекомпиляцияЭлементов",ДекомпиляцияЭлементов);
		
		Объект.ПолныйПутьКФорме = ТекСтрока.ПолныйПутьКФорме;
		ПолучитьФорму(ТекСтрока.ПолныйПутьКФорме,ПараметрыФормы);
		
		ЗаполнитьДанныеПоХранилищуНаСервере();
		
		//Развернуть дерево
		Для Каждого Строка Из Объект.ДеревоФорм.ПолучитьЭлементы() Цикл    
			Если Строка.Имя = СтруктИнфыОМетаданном.ТипОбъекта Тогда
				//Ищем объект
				Для Каждого СтрокаОбъект Из Строка.ПолучитьЭлементы() Цикл    
					Если СтрокаОбъект.Имя = СтруктИнфыОМетаданном.ИмяОбъекта Тогда
						//Ищем форму
						Для Каждого СтрокаФормы Из СтрокаОбъект.ПолучитьЭлементы() Цикл    
							Если СтрокаФормы.Имя = СтруктИнфыОМетаданном.ИмяФормы Тогда
								ИдентификаторСтроки = СтрокаФормы.ПолучитьИдентификатор();
								Элементы.ДревоФорм.ТекущаяСтрока = ИдентификаторСтроки;	
							КонецЕсли; 
						КонецЦикла;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьКод(Команда)
	
	ТекстФормированияЭлементов = "/////   РЕКВИЗИТЫ   //////////"+Символы.ПС+Символы.ПС+"МассивДобавляемыхРеквизитов = Новый Массив;";	
	СформироватьКодРеквизитовПоСтрокам(Объект.ДеревоРеквизитов.ПолучитьЭлементы());
	ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС + Символы.ПС+ "ЭтаФорма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);"+Символы.ПС;
	
	ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС + Символы.ПС+ "/////   КОМАНДЫ   //////////";
	Для каждого ТекКоманда Из Объект.ТаблицаКоманд Цикл
		Если ТекКоманда.Выбран Тогда
			ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС+Символы.ПС+ТекКоманда.ТекстСоздания;	
		КонецЕсли; 
	КонецЦикла; 
	
	ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС + Символы.ПС+ "/////   ЭЛЕМЕНТЫ   //////////"+Символы.ПС;
	СформироватьКодЭлементовПоСтрокам(Объект.ДеревоЭлементов.ПолучитьЭлементы());
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКодЭлементовПоСтрокам(ДеревоЭлементов)

	КоличествоСтрок = ДеревоЭлементов.Количество();
	СледующийЭлемент = "Неопределено";
	Для Индекс = 1 По КоличествоСтрок Цикл
		СтрокаЭлемента = ДеревоЭлементов[КоличествоСтрок-Индекс];
		Если СтрокаЭлемента.Выбран Тогда
			ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС+Символы.ПС+СтрокаЭлемента.ТекстСоздания;	
		КонецЕсли; 
		СформироватьКодЭлементовПоСтрокам(СтрокаЭлемента.ПолучитьЭлементы());
	КонецЦикла; 

КонецПроцедуры // СформироватьКодПоСтрокам()

&НаКлиенте
Процедура СформироватьКодРеквизитовПоСтрокам(ДеревоРеквизитов)

	Для каждого СтрокаРеквизита Из ДеревоРеквизитов Цикл
		Если СтрокаРеквизита.Выбран Тогда
			ТекстФормированияЭлементов = ТекстФормированияЭлементов + Символы.ПС+Символы.ПС+СтрокаРеквизита.ТекстСоздания+
			   Символы.ПС+"МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);";	
		КонецЕсли; 
		СформироватьКодРеквизитовПоСтрокам(СтрокаРеквизита.ПолучитьЭлементы());
	КонецЦикла; 

КонецПроцедуры // СформироватьКодПоСтрокам()

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДревоФормВыборНаСервере()   
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПолучитьСвойстваВыбраннойФормы();	
    ЗначениеВРеквизитФормы(ОбработкаОбъект,"Объект");
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьОбработкуНаСервере()
	// Вставить содержимое обработчика.
	//ДвоичныеДанныеОбработки = ПолучитьИзВременногоХранилища(Объект.АдресДанныхФайлаВоВременномХранилище);
	Объект.ИмяПодключеннойОбработки = ВнешниеОбработки.Подключить(Объект.АдресДанныхФайлаВоВременномХранилище,,Ложь);
КонецПроцедуры


#КонецОбласти



