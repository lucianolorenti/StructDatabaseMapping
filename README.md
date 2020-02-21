# Installation
```julia
] add https://github.com/lucianolorenti/StructDatabaseMapper.git
```

# Compatibility
* SQLite
* PostgreSQL
* Possibly every relational DB that supports the DBInterface

# Let define a model
This is a simple model. There are two different types: ForeignKey and DBId. 
Each of the `struct` has to have a construcor with named parameters.
```julia
using StructDatabaseMapping
using Dates
struct Author
    id::DBId{Integer}
    name::String
    date::DateTime
end
function Author(;id::Union{Integer, Nothing} = nothing,
                name::String="",
                date::DateTime=now())
    return Author(id, name, date)
end
struct Book
    id::DBId{String}
    author::ForeignKey{Author}
end
function Book(;id::Union{String, Nothing}=nothing,
               author::ForeignKey{Author}=ForeignKey{Author}())
    return Book(id, author)
end
```

First we should create the DBMapper and register our types

```julia
using SQLite
DB_FILE = "test.db"
mapper = DBMapper(()->SQLite.DB(DB_FILE))

register!(mapper, Author)
register!(mapper, Book)
```

Table creation
```julia
create_table(mapper, Author)
create_table(mapper, Book)
``` 
```sql
CREATE TABLE IF NOT EXISTS author (id INTEGER PRIMARY KEY, name VARCHAR  NOT NULL, date DATETIME  NOT NULL)

CREATE TABLE IF NOT EXISTS book (id VARCHAR PRIMARY KEY, author_id INTEGER  NOT NULL)
```

```julia
author = Author(name="pirulo")
insert!(mapper, author)
```
```julia
┌ Info: INSERT INTO author (name,date)
│ VALUES (?,?)
└     
Author(DBId{Integer}(1), "pirulo", 2020-02-21T15:52:12.677)
```


```julia
author_selected = select_one(mapper, Author, id=id)
```

```julia
book = Book("super_string_id", author)
insert!(mapper, book)
get(a.author, mapper).name == "pirulo"
```
