
# Схема `pharmacy`

## Таблицы


1. `goods_on_place` - таблица с местами хранения товаров и их количеством 
2. `places`   - таблица содержит места хранения
    - `parent_place_id` - 
    - `max_children`  - максимальное количество потомков, которое может содержать каждое конкретное место хранения  
      (помещение - шкафов, шкаф - этажей, этаж - секций, секция - товаров)


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
      * `CNL` - cancelled - отменен  
        (отказаться от заказа можно в момент получения, если с ним что-то не так)
      * `FIN` - finished - доставлен/получен  
     продажа через кассу - сразу статус `FIN`  
     

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
```sql
SELECT pharmacy.places_ins('
                           {
                             "parent_place_id": 14,
                             "place_type_id": 4,
                             "max_children": 6
                           }
                           ');
```

Пример ответа при правильном выполнении:
```jsonb
{"place_id": 32}
```

Пример ошибки:
```jsonb
{
  "errors": [
    {
      "error": "pharmacy.places_ins.place.there_is_no_place",
      "detail": null,
      "message": "place_id = 17 уже заполнено"
    }
  ]
}
```