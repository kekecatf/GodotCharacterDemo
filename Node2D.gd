extends Node2D

4000 veri
3. sayfaya ulaşacağız
filtrelemeler var
her sayfada 5 veri var

SELECT COUNT(*) 
FROM coats 
WHERE color = "black" AND size = "M"; ürünler filtrelenecek ve kalan ürün sayısını verecek

SELECT *
FROM TabloAdı
LIMIT 5 OFFSET (5 * (3 - 1)); hedef sayfa 3 ve 5 tane veri gösterecek
