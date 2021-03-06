using .SQLite
using .DBInterface

using Dates

const SQLITE_TYPE_MAPPINGS = Dict{Union{Type, Symbol}, Symbol}( # Julia => SQLite
  Char => :CHARACTER,
  String => :VARCHAR,
  Integer => :INTEGER,
  Int => :INTEGER,
  Float64 => :FLOAT,
  DateTime => :DATETIME,
  Time => :TIME,
  Date => :DATE,
  Bool => :BOOLEAN,
  Dict => :JSON
)



function database_column_type(dbtype::Type{SQLite.DB}, d::Union{Type, Symbol}) :: Symbol
    return SQLITE_TYPE_MAPPINGS[d]
end

function clean_table_query(table::Table, dbtype::Type{SQLite.DB}) 
    return "DELETE FROM $(table.name)"
end

database_kind(c::Type{SQLite.DB}) = Relational
close!(db::SQLite.DB) = DBInterface.close!(db)
