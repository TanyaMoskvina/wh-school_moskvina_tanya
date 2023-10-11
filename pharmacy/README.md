
## Схема `pharmacy`

### Таблицы

1. `goods`    - таблица товаров
    * `by_prescription = TRUE ` - отпускается по рецепту, возможен только самомывоз


2. `goods_on_place` - таблица с местами хранения товаров и их количеством 
3. `places`   - таблица содержит места хранения
4. `prices`   - таблица актуальных цен
5. `sales`    - таблица продаж
   - `client_id` - если `is_delivery = TRUE` должен быть заполнен
   - `goods` - содержит купленные/заказанные товары и их количество  
   ```json
   {
     "data": [
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
   если `is_delivery = TRUE` должен содержать адресс доставки, может также содержать комментарий
    ```josn
    {
      "data": [
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
      * `DEL` - delivery - в доставке
      * `FIN` - finished - доставлен  
     продажа через кассу - сразу статус `FIN`


6. `supplies` - таблица поставок
7. `supply_orders` - таблица с заказами поставок 
   * `order_info` JSONB - 
   ```json
   {
     "data": [
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
