
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
   - `goods` - содержит проданные/заказанные товары и их количество  
   ```json
   {
     "goods": [
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
     

5. `sales_cancelled` - таблица с товарами от которых отказались
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
При вызове функции с указанием `nm_id` выводится информация только об этом товаре 
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