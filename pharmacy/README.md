
# Схема `pharmacy`

## Таблицы


1. `goods_on_place` - таблица с местами хранения товаров и их количеством 
2. `places`   - таблица содержит места хранения  
    - `parent_place_id` - id родительского места хранения.  
     У `place_type_id = 1` (помещение) NULL.  
     - Помещение с `place_id = 1` - тогровый зал, `place_id = 2` - склад
    - `place_type_id` - тип места хранения из `dictionary.place_types`
    - `max_children`  - максимальное количество дочерних элементов, которое может содержать каждое конкретное место хранения  
      (помещение - шкафов, шкаф - полок, полка - секций, секция - товаров)


3. `prices`   - таблица актуальных цен
4. `sales`    - таблица продаж
   - `client_id` - если `is_delivery = TRUE` должен быть заполнен
   - `is_delivery` TRUE - доставка, FALSE - самовывоз/оффлайн покупка
   - `delivery_info` JSONB  
   если `is_delivery = TRUE`, должен содержать адресс доставки, может также содержать комментарий клиента
    ```json
    {
      "delivery_info": [
        {
          "address": "адрес доставки",
          "comment": ""
        }
      ]
    }
    ```
   - `status`
      * `EXP` - expect - оформлен и ожидает сборки
      * `INP` - in process - в процессе сборки
      * `RDY` - ready - готов к получению/доставке
      * `DEL` - delivery - в доставке
      * `COM` - completed - доставлен/получен  
     продажа через кассу - сразу статус `COM`  
   - `dt` - дата формирования заказа / оффлайн продажи
     

5. `sale_items` - таблица с товарами продажи и итоговой стоимостью
6. `supplies` - таблица поставок
7. `supply_orders` - таблица с заказами поставок
   * `order_info` - позиции заказа и их количество - JSONB - 
   ```json
   {
     "order_info": [
       {
         "nm_id": 1,
         "quantity": 1
       },
       {
         "nm_id": 2,
         "quantity": 3
       }
     ]
   }
   ```


## Функции

### Добавление и обновление цен prices
```sql
SELECT pharmacy.prices_upd('
                           {
                             "nm_id": 2,
                             "price": 206
                           }
                           ', 15);
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Создание нового места хранения
При создании `place_type_id = 1` - `parent_place_id` NULL.  
```sql
SELECT pharmacy.places_ins('{
                             "place_type_id": 1,
                             "max_children": 6
                            }');
```
Для создания дочерних мест хранения необходимо соблюдать иерархию: Помещение -> Стеллаж -> Полка -> Секция.  
В родительском элементе можно создать только следующий по иерархии дочерний.
```sql
SELECT pharmacy.places_ins('{
                             "parent_place_id": 1,
                             "place_type_id": 2,
                             "max_children": 4
                            }');
```
Пример ошибки:
```jsonb
{
  "errors": [
    {
      "error": "pharmacy.places_ins.place.there_is_no_place",
      "detail": "place_id = 1, max_children = 6",
      "message": "Это место уже заполнено"
    }
  ]
}
```
При правильном выполнении выводит id созданного места хранения.  
Пример ответа при правильном выполнении:
```jsonb
{"place_id": 12}
```

### Раскладывание по местам хранения
Сначала необходимо вызвать ф-цию `pharmacy.goods_on_place_get(nm_id)` чтобы узнать где лежит такой товар   
Если хотим добавить товар - вызвать ф-цию `pharmacy.places_get_by_id(place_id)`, чтобы проверить наличие свободного места

Если товар забираем из места хранения `"is_taken": true`, если кладем - `"is_taken": false`.
```sql
SELECT pharmacy.goods_on_place_upd('{
                                      "nm_id": 26,
                                      "place_id": 23,
                                      "quantity": 2,
                                      "is_taken": true
                                    }')
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```
### Получение информации о количестве товаров в наличии и их местах хранения
При вызове функции без параметров выводится информация о местах хранения всех товаров
```sql
SELECT pharmacy.goods_on_place_get();
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "nm_id": 26,
      "place_id": 15,
      "quantity": 1
    },
    {
      "nm_id": 30,
      "place_id": 15,
      "quantity": 1
    },
    {
      "nm_id": 35,
      "place_id": 17,
      "quantity": 1
    },
    {
      "nm_id": 26,
      "place_id": 23,
      "quantity": 10
    },
    {
      "nm_id": 28,
      "place_id": 23,
      "quantity": 5
    },
    {
      "nm_id": 35,
      "place_id": 38,
      "quantity": 5
    }
  ]
}
```
При вызове функции с указанием `nm_id` выводится информация о месте хранения только этого товара
```sql
SELECT pharmacy.goods_on_place_get(26);
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "nm_id": 26,
      "place_id": 23,
      "quantity": 10
    },
    {
      "nm_id": 26,
      "place_id": 15,
      "quantity": 1
    }
  ]
}
```

### Получение информации о месте хранения по place_id
```sql
SELECT pharmacy.places_get_by_id(23);
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "place_id": 23,
      "free_space": 5,
      "max_children": 20,
      "count_children": 15
    }
  ]
}
```

### Создание заказа поставщику
```sql
SELECT pharmacy.supply_orders_ins('{
                                      "supplier_id": 18,
                                      "order_info": [
                                        {
                                          "nm_id": 27,
                                          "quantity": 20
                                        },
                                        {
                                          "nm_id": 35,
                                          "quantity": 10
                                        },
                                        {
                                          "nm_id": 32,
                                          "quantity": 5
                                        }]
                                    }', 15);
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Приемка поставки
`"is_accepted": false` - если поставка еще в процессе приемки
`"is_accepted": true` - если поставка принята (добавляется последний товар поставки)   
```sql
SELECT pharmacy.supplies_upd('{
                                  "supply_id": 40,
                                  "nm_id": 32,
                                  "quantity": 1,
                                  "supplier_id": 18,
                                  "dt": "2023-10-22 20:30:46.253701 +03:00",
                                  "is_accepted": true
                             }', 15);
```
При `supply_id` NULL добавится новая запись.  
При вводе существующего `supply_id` запись о поставке обновится.  
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Получение информации о поставках
При вызове функции без параметров выводится информация о всех поставках
```sql
SELECT pharmacy.supplies_get();
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-22T23:55:10.670952+00:00",
      "nm_id": 34,
      "quantity": 8,
      "supply_id": 41,
      "is_accepted": false,
      "supplier_id": 18,
      "ch_employee_id": 15
    },
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-22T23:55:34.91766+00:00",
      "nm_id": 31,
      "quantity": 1,
      "supply_id": 41,
      "is_accepted": false,
      "supplier_id": 18,
      "ch_employee_id": 15
    },
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-23T19:43:50.614778+00:00",
      "nm_id": 32,
      "quantity": 3,
      "supply_id": 40,
      "is_accepted": true,
      "supplier_id": 18,
      "ch_employee_id": 15
    },
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-22T23:33:14.266201+00:00",
      "nm_id": 35,
      "quantity": 3,
      "supply_id": 40,
      "is_accepted": true,
      "supplier_id": 18,
      "ch_employee_id": 15
    }
  ]
}
```
При вызове функции с указанием `supply_id` выводится информация только об этой поставке
```sql
SELECT pharmacy.supplies_get(40);
```
Пример ответа при правильном выполнении:
```jsonb
{
  "data": [
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-22T23:33:14.266201+00:00",
      "nm_id": 35,
      "quantity": 3,
      "supply_id": 40,
      "is_accepted": true,
      "supplier_id": 18,
      "ch_employee_id": 15
    },
    {
      "dt": "2023-10-22T17:30:46.253701+00:00",
      "ch_dt": "2023-10-23T19:43:50.614778+00:00",
      "nm_id": 32,
      "quantity": 3,
      "supply_id": 40,
      "is_accepted": true,
      "supplier_id": 18,
      "ch_employee_id": 15
    }
  ]
}
```

### Создание продажи/заказа
Создается запись о продаже на кассе или об оформленном заказе.
Статус заказа меняется с помощью ф-ции `pharmacy.sales_upd()`

Продажа на кассе:  
`is_delivery` - false, `status` - "COM", `client_id` может быть NULL
```sql
SELECT pharmacy.sales_ins('{
                                "client_id": 24,
                                "is_delivery": false,
                                "status": "COM",
                                "responsible_employee_id": 15
                            }',
                            '[{
                                "nm_id": 27,
                                "quantity": 1
                            },
                            {
                                "nm_id": 31,
                                "quantity": 1
                            }]', 15)
```
Создание заказа:  
`is_delivery` - true, `delivery_info` - jsonb,   
`status` - "EXP", `client_id` должен быть заполнен
```sql
SELECT pharmacy.sales_ins('{
                                "client_id": 24,
                                "is_delivery": true,
                                "delivery_info": {
                                                   "address": "улица, дом, кв",
                                                   "comment": "комментарий"
                                                 },
                                "status": "EXP",
                                "responsible_employee_id": 15
                            }',
                            '[{
                                "nm_id": 27,
                                "quantity": 2
                            },
                            {
                                "nm_id": 31,
                                "quantity": 1
                            }]', 15)
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Обновление статуса заказа
После создания заказа, его нельзя изменить - меняется только статус.  
Порядок изменения статуса: EXP -> INP -> RDY -> DEL -> COM
```sql
SELECT pharmacy.sales_upd('{
                                "sale_id": 45,
                                "client_id": 24,
                                "is_delivery": true,
                                "delivery_info": {
                                                   "address": "улица, дом, кв",
                                                   "comment": "комментарий"
                                                 },
                                "status": "INP",
                                "dt":"2023-10-23 20:22:40.164127 +00:00",
                                "responsible_employee_id": 15
                            }', 15);
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```