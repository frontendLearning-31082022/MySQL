-- Генерация колонки для SELECT
SELECT id, order_status,
CASE
	WHEN order_status='OPEN'
		THEN 'Заказ в открытом состояние'
	WHEN order_status='CANCELLED'
		THEN 'Заказ был отменен'
	WHEN order_status='CLOSED'
		THEN 'Заказ завершен'
	ELSE 'Состояние заказа неизвестно'
END AS order_state
FROM orders
ORDER BY id;
