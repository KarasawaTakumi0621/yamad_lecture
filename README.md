## 使用技術
Swift5.0
Vapor
SQLite

## 書いたSQL
テーブルのCreateのみ

``` 
sql:sql
$ sqlite3 yamadhacks 
sqlite> create table users (id integer, name text);
```

## 実行結果

```
json:http://127.0.0.1:8080/readAll
[{"id":1,"name":"Takumi Karasawa"}]
```
