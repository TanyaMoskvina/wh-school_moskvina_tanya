# Схема `dictionary`

## Таблицы

1. `card_level` - уровни скидочных карт
   * `discount` - скидки в процентах
   * `amount_spent` - сумма, которую нужно потратить для перехода на следующий уровень  

2. `goods_category` - категории товаров
3. `manufacturers` - производители
4. `place_types` - типы мест хранения
5. `ranks` - должности и зарплаты
6. `release_forms` - форма выпуска лекарств
7. `suppliers` - поставщики
8. `goods`    - таблица товаров
    * `by_prescription = TRUE ` - отпускается по рецепту, возможен только самомывоз

## Функции

### Заполнение и обновление таблицы ranks
```sql
SELECT dictionary.ranks_upd('
                            {
                              "name": "Директор",
                              "salary": 150000
                            }');
```
При вводе существующего `rank_id` запись о должности обновится.  
При `rank_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```
Пример ошибки:
```jsonb
{
  "errors": [
    {
      "error": "dictionary.ranks_upd.name_exists",
      "detail": "name = Директор",
      "message": "Такая должность уже существует"
    }
  ]
}
```

### Заполнение и обновление таблицы card_levels
```sql
SELECT dictionary.card_levels_upd('{
                                      "level_id": 1,
                                      "discount": 1,
                                      "amount_spent": 10000
                                    }');
```
При вводе существующего `level_id` запись обновится.  
При `level_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы goods_category
```sql
SELECT dictionary.goods_category_upd('{"name": "Аллергия"}');
```
При вводе существующего `category_id` запись обновится.  
При `category_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы release_forms
```sql
SELECT dictionary.release_forms_upd('{"name": "Капсулы"}');
```
При вводе существующего `release_form_id` запись обновится.  
При `release_form_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы manufacturers
```sql
SELECT dictionary.manufacturers_upd('{
                                      "name": "Фармстандарт-Лексредства",
                                      "country": "Россия"
                                     }');
```
При вводе существующего `manufacturer_id` запись обновится.  
При `manufacturer_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы place_types
```sql
SELECT dictionary.place_types_upd('{"name": "Стеллаж"}');
```
При вводе существующего `place_type_id` запись обновится.  
При `place_type_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы goods
```sql
SELECT dictionary.goods_upd('{
                              "name": "Парацетамол",
                              "by_prescription": false,
                              "dosage": "500 мг",
                              "count_in_pack": 30,
                              "release_form_id": 1,
                              "category_id": 3,
                              "manufacturer_id": 1
                              }');
```
При вводе существующего `nm_id` запись обновится.  
При `nm_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Заполнение и обновление таблицы suppliers
```sql
SELECT dictionary.suppliers_upd('
                                 {
                                   "name": "PharmaGo",
                                   "inn": "4267742265",
                                   "is_active": true
                                 }
                                 ', 15)
```
При вводе существующего `supplier_id` запись обновится.  
При `supplier_id` NULL добавится новая запись.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Получение всех поставщиков 
```sql
SELECT dictionary.suppliers_getall();
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "inn": "806640748686",
      "name": "ИП Кобяков Г.А.",
      "is_active": false,
      "supplier_id": 17
    },
    {
      "inn": "4267742265",
      "name": "PharmaGo",
      "is_active": true,
      "supplier_id": 18
    }
  ]
}
```